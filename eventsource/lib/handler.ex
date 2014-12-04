defmodule Handler do
  def init(_transport, req, []) do
    headers = [{"content-type", "text/event-stream"}]
    {:ok, req} = :cowboy_req.chunked_reply(200, headers, req)
    Process.send_after(self, {:message, "Tick"}, 1000)
    {:loop, req, :undefined, 5000}
  end

  def info({:message, msg}, req, state) do
    :ok = :cowboy_req.chunk(["id: ", id(), "\ndata: ", msg, "\n\n"], req)
    Process.send_after(self, {:message, "Tick"}, 1000)
    {:loop, req, state}
  end

  def terminate(_reason, _req, _state) do
    :ok
  end

  defp id do
    {mega, sec, micro} = :erlang.now()
    id = (mega * 1000000 + sec) * 1000000 + micro
    Integer.to_char_list(id, 16)
  end
end
