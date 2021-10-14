def upload_file(context : Context) : Context
    params =
        context
            .fetch_path_params

    puts params

    context
        .put_status(200)
        .json(params)
        .halt
end