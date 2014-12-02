defmodule ErrorHook do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Define workers and child supervisors to be supervised
      # worker(ErrorHook.Worker, [arg1, arg2, arg3])
      worker(__MODULE__, [], function: :run)
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ErrorHook.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def run do
    routes = []
    dispatch = :cowboy_router.compile([{:_, routes}])
    opts = [port: 8080]
    env = [dispatch: dispatch]
    {:ok, _pid} = :cowboy.start_http(:http, 100, opts, [env: env, onresponse: &error_hook/4])
  end

  def error_hook(404, headers, <<>>, req) do
    {path, req} = :cowboy_req.path(req)
    body = ["404 Not Found: \"", path, "\" is not the path you are looking for.\n"]
    content_length = Integer.to_char_list(IO.iodata_length(body))
    headers = List.keyreplace(headers, "content-length", 0, {"content-length", content_length})
    {:ok, req} = :cowboy_req.reply(404, headers, body, req)
    req
  end

  def error_hook(code, headers, <<>>, req) when is_integer(code) and code >= 400 do
    body = ["HTTP Error ", Integer.to_char_list(code), "\n"]
    content_length = Integer.to_char_list(IO.iodata_length(body))
    headers = List.keyreplace(headers, "content-length", 0, {"content-length", content_length})
    {:ok, req} = :cowboy_req.reply(code, headers, body, req)
    req
  end

  def error_hook(_code, _headers, _body, req) do
    req
  end
end
