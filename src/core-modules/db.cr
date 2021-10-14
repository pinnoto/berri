require "granite"
require "granite/adapter/sqlite"

module Berri::DB
    def self.sqlite(name, url)
        Granite::Connections << Granite::Adapter::Sqlite.new(name: name, url: url)
    end
end

Berri::DB.sqlite("sqlite", "sqlite3://./db.sqlite3")

class User < Granite::Base
    connection sqlite

    column id : Int64, primary: true
    column username : String
    column email : String
    column real_name : String?
    column created_at : Time
    column password : String
end

User.migrator.drop_and_create

