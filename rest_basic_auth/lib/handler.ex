defmodule Handler do
  def init(_transport, _req, []) do
    {:upgrade, :protocol, :cowboy_rest}
  end

  def is_authorized(req, state) do
    {:ok, auth, req} = :cowboy_req.parse_header("authorization", req)
    case auth do
      {"basic", {user = "Alladin", "open sesame"}} ->
        {true, req, user}
      _ ->
        {{false, "Basic realm=\"cowboy\""}, req, state}
    end
  end

  def content_types_provided(req, state) do
    {[ {"text/plain", :to_text} ], req, state}
  end

  def to_text(req, user) do
    {"Hello, #{user} !\n", req, user}
  end
end
