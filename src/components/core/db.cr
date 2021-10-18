module Berri::DB
    def self.mysql(name, url)
        Granite::Connections << Granite::Adapter::Mysql.new(name: "mysql", url: "mysql://root:nodeIsGod@127.0.0.1/berri")
    end
end

Berri::DB.mysql("mysql", "mysql://root:nodeIsGod@127.0.0.1/berri")

class User < Granite::Base
    connection mysql

    column id : Int64, primary: true
    column username : String
    column email : String
    column real_name : String?
    column created_at : Time
    column password : String
end

#class BerriObject < Granite::Base
#    connection mysql
#
#    column id : String, primary: true
#    column directory : String
#    column folder : Int64
#    column name : String
#    column size : String?
#    column created_at : Time
#    column type : String
#    column owner : Int64
#end

#User.migrator.drop_and_create

