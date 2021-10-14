class FileController < Grip::Controllers::Http
    def upload_file(context : Context) : Context
        begin 
            params =
                context
                    .fetch_file_params

            puts params

            context
                .put_status(200)
                .halt
        rescue
            context
                .put_status(400)
                .json({"cbt" => "cbt"})
                .halt
        end
    end
end