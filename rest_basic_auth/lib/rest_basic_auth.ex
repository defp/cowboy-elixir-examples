defmodule RestBasicAuth do
  use Application

  def start(_type, _args) do
    dispatch = :cowboy_router.compile([
        {:'_', [
            {"/", Handler, []}
        ]}
    ])
    {:ok, _ } = :cowboy.start_http(:http, 100, [{:port, 8080}], [{:env, [{:dispatch, dispatch}]}])
    RbaSupervisor.start_link
  end
end
