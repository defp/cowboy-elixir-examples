defmodule StaticWorld do
  use Application 

  def start(_type, _args) do
    dispatch = :cowboy_router.compile([
      {:_, [
        {"/[...]", :cowboy_static, {:priv_dir, :static_world, "", [{:mimetypes, :cow_mimetypes, :all}]}}
      ]}
    ])

    {:ok, _} = :cowboy.start_http(:http, 100, [{:port, 8080}], [{:env, [{:dispatch, dispatch}]} ])
    SwSupervisor.start_link
  end
end
