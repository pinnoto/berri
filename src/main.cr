require "grip"
require "crystal-argon2"
require "db"
require "sqlite3"
require "granite"
require "jwt"
require "yaml"
require "granite/adapter/sqlite"

# Mandatory components
require "./components/core/db.cr"
require "./components/core/auth.cr"
require "./components/core/core.cr"

# Put any library requirements before these two lines



module Berri::Core
  VERSION = "0.1.0"

  ENV["BERRI_SECRET_KEY"] ||= Random::Secure.urlsafe_base64(128)

  class Application < Grip::Application

    def routes
      
      pipeline :jwt_auth, [
        TokenAuthorization.new
      ]
  
      scope "/api" do
        scope "/v1" do
          post "/register", AuthController, as: register
          post "/login", AuthController, as: login
          post "/upload_file", FileController, as: upload_file
          pipe_through :jwt_auth

          get "/user_info", AuthController, as: user_info
        end
      end
    end
  
    def port
      4560
    end
  
  end
  
  app = Application.new
  app.run
end