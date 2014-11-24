defmodule HelloWorld do
  use Application

  def start(_type, _args) do
    dispath = :cowboy_router.compile([
      {:_, [
        {"/helloworld", HelloWorld.ToppageHandler, []}
      ]}
    ])

    {:ok, _} = :cowboy.start_http(:http, 100, [{:port, 3000}], [{:env, [{:dispatch, dispath}]}])
    HelloWorld.Supervisor.start_link
  end
end
