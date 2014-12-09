defmodule Handler do
  @behaviour :cowboy_http_handler

  def init(_, req, _opts) do
    {:ok, req, :undefined}
  end

  def handle(req, state) do
    {:ok, headers, req} = :cowboy_req.part(req)
    {:ok, data, req} = :cowboy_req.part_body(req)
    {:file, "inputfile", filename, content_type, _TE} = :cow_multipart.form_data(headers)
    IO.puts(filename)
    IO.puts(content_type)
    IO.puts(data)
    {:ok, req, state}
  end

  def terminate(_reason, _req, _state) do
    :ok
  end
end
