module BerriFile < Granite::Base
    connection sqlite

    column id : Int64, primary: true
    column username : String
    column email : String
    column real_name : String?
    column created_at : Time
    column password : String
end

class FileController < Grip::Controllers::Http
    def upload_file(context : Context) : Context
        begin 
            params =
                context
                    .fetch_file_params
            begin
                file = params["file"]?
                if file
                    filename = file.filename
                    tempfile = file.tempfile
                    File.open("#{filename.to_s}", "w") do |file|
                        IO.copy(tempfile, file)
                    end
                    tempfile.delete
                end

                context
                    .put_status(200)
                    .json({"success": true})
                    .halt
            rescue
                context
                    .put_status(400)
                    .json({"error": "Upload error"})
                    .halt
            end
        rescue
            context
                .put_status(400)
                .json({success: false, message: "Unknown error"})
                .halt
        end
    end
end


# Grip::Parsers::FileUpload(@tempfile=#<File:/tmp/.IjAAkz>, @filename="RE4wtct.jpg", @headers=HTTP::Headers{"Content-Disposition" => "form-data; name=\"file\"; filename=\"RE4wtct.jpg\"", "Content-Type" => "image/jpeg"}, @creation_time=nil, @modification_time=nil, @read_time=nil, @size=nil)
