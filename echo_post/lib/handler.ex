defmodule Handler do
  def init(_transport, req, []) do
    {:ok, req, :undefined}
  end

  def handle(req, state) do
    {method, req} = :cowboy_req.method(req)
    hasbody = :cowboy_req.has_body(req)
    {:ok, req} = maybe_echo(method, hasbody, req)
    {:ok, req, state}
  end

  defp maybe_echo("POST", true, req) do
    {:ok, post_vals, req} = :cowboy_req.body_qs(req)
    echo = :proplists.get_value("echo", post_vals)
    echo(echo, req)
  end

  defp maybe_echo("POST", false, req) do
    :cowboy_req.reply(400, [], "Missing body.", req)
  end

  defp maybe_echo(_, _, req) do
    :cowboy_req.reply(405, req)
  end

  defp echo(:undefined, req) do
    :cowboy_req.reply(400, [], "Missing echo parameter.", req)
  end

  defp echo(echo, req) do
    :cowboy_req.reply(200, [{"content-type", "text/plain; charset=utf-8"}], echo, req)
  end

  def terminate(_reason, _req, _state) do
    :ok
  end
end
