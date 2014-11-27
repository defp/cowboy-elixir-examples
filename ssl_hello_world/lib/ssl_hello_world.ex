defmodule SslHelloWorld do
  use Application

  def start(_type, _args) do
    dispatch = :cowboy_router.compile([
      {:_, [
        {"/", ToppageHandler, []}
      ]}
    ])

    priv_dir = :code.priv_dir(:ssl_hello_world)

    {:ok, _} = :cowboy.start_https(:https, 100, [
      {:port, 8443},
      {:cacertfile, "#{priv_dir}/ssl/cowboy-ca.crt"},
      {:certfile, "#{priv_dir}/ssl/server.crt"},
      {:keyfile, "#{priv_dir}/ssl/server.key"}
    ], [{:env, [{:dispatch, dispatch}]}])

    ShwSupervisor.start_link
  end
end
