defmodule GetHandler do
  def init(_transport, req, []) do
    {:ok, req, :undefined}
  end

  def handle(req, state) do 
    {method, req} = :cowboy_req.method(req)
    {echo, req} = :cowboy_req.qs_val("echo", req)
    {:ok, req} = echo(method, echo, req)
    {:ok, req, state}
  end

  defp echo("GET", :undefined, req) do
    :cowboy_req.reply(400, [], "Missing echo parameter.", req)
  end

  defp echo("GET", echo, req) do
    :cowboy_req.reply(200, [{"content-type", "text/plain; charset=utf-8"}], echo, req)
  end

  defp echo(_, _, req) do
    :cowboy_req.reply(405, req)
  end

  def terminate(_reason, _req, _state) do
    :ok
  end
end