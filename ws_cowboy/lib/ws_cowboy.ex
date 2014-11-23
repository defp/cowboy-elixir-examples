defmodule WsCowboy do
  use Application

  def start(_type, _args) do
    dispatch = :cowboy_router.compile([
      {:_, [
        {"/", :cowboy_static, {:priv_file, :ws_cowboy, "index.html"}},
        {"/websocket", WsHandler, []},
        {"/static/[...]", :cowboy_static, {:priv_dir, :ws_cowboy, "static"}}
      ]}
    ])

    {:ok, _} = :cowboy.start_http(:http, 100, [{:port, 8080}], [{:env, [{:dispatch, dispatch}]}])

    WsSupervisor.start_link
  end
end
