defmodule HelloWorld.ToppageHandler do

  def init(_type, req, []) do
    {:ok, req, :undefined}
  end
  
  def handle(req, state) do
    {:ok, req2} = :cowboy_req.reply(200, [{"content-type", "text/plain"}], "Hello world!", req)
    {:ok, req2, state}
  end

  def terminate(_reason, _req, _state) do
    :ok
  end
  
end
