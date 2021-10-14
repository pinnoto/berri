require "grip"
require "crystal-argon2"
require "db"
require "sqlite3"
require "granite"
require "jwt"
require "yaml"
# Put any library requirements before these two lines
require "./core-modules/*"
require "./modules/*"

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
          pipe_through :jwt_auth
        end
      end
      
      post "/api/v1/register", AuthController, as: register
      post "/api/v1/login", AuthController, as: login
    
    end
  
    def port
      4560
    end
  
  end
  
  app = Application.new
  app.run
end