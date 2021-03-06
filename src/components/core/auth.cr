require "./db.cr"

class AuthController < Grip::Controllers::Http

    def register(context : Context) : Context

        params = context.fetch_json_params

        username = params["username"]?
        email = params["email"]?
        password = params["password"]?

        if username && email && password

            db_username = User.find_by(username: username)

            if db_username
                context
                    .put_status(400)
                    .json({"error" => "Username has been taken."})
                    .halt
            else 
                hasher = Argon2::Password.new

                user = User.new
                user.username = username.to_s
                user.email = email.to_s
                user.password = hasher.create(password.to_s)
                user.created_at = Time.utc
                user.save

                token = JWT.encode({"id" => "#{user.id}", "exp" => (Time.utc + 1.week).to_unix, "iat"  => Time.utc.to_unix}, ENV["BERRI_SECRET_KEY"], JWT::Algorithm::HS512)

                context
                    .put_status(200)
                    .json({"token": token})
                    .halt
            end
        else
            context
                .put_status(400)
                .json({"error": "Required parameter missing"})
                .halt
        end
    end

    def login(context : Context) : Context

        params = context.fetch_json_params

        email = params["email"]?
        password = params["password"]?

        if email && password
            # dummy, fix this!
            db_user = User.find_by(username: email.to_s)

            if db_user

                hashed_password = db_user.password
                Argon2::Password.verify_password(password.to_s, hashed_password)

                token = JWT.encode({"id" => "#{db_user.id}", "exp" => (Time.utc + 1.week).to_unix, "iat"  => Time.utc.to_unix}, ENV["BERRI_SECRET_KEY"], JWT::Algorithm::HS512)

                context
                    .put_status(200)
                    .json({"token": token})
                    .halt

            else
                context
                    .put_status(400)
                    .json({"error": "User does not exist."})
                    .halt
            end
        else
            context
                .put_status(400)
                .json({"error": "Required parameter missing"})
                .halt
        end
    end

    def user_info(context : Context) : Context
        begin 
            token =
                context
                    .get_req_header("Authorization")
                    .split("Bearer ")
                    .last
    
            payload, header = JWT.decode(token, ENV["BERRI_SECRET_KEY"], JWT::Algorithm::HS512)

            db_user = User.find_by(id: payload["id"].to_s.to_i)

            if db_user
                context
                    .put_status(200)
                    .json({"username" => "#{db_user.username}"})
                    .halt()
            else
                context
                    .put_status(400)
                    .json({"error" => "400"})
                    .halt()
            end
            context
                .put_status(200)
                .json({"error" => "success"})
                .halt
        rescue
            context
                .put_status(400)
                .json({"error" => "Authentication error"})
                .halt
        end
    end
end

class TokenAuthorization
    include HTTP::Handler

    def call(context : HTTP::Server::Context) : HTTP::Server::Context
        begin
            token = context
                .get_req_header("Authorization")
                .split("Bearer ")
                .last

            payload = JWT.decode(token, ENV["BERRI_SECRET_KEY"], JWT::Algorithm::HS512)

            context
        rescue
            context
                .put_status(400)
                .json({"error" => "Authentication error"})
                .halt
        end
    end
end
