defmodule Handler do
  def init(_transport, _req, []) do
    {:upgrade, :protocol, :cowboy_rest}
  end

  def content_types_provided(req, state) do
    {
      [
        {"text/html", :hello_to_html},
        {"application/json", :hello_to_json},
        {"text/plain", :hello_to_text}
      ], req, state}
  end

  def hello_to_html(req, state) do
    body = """
    <html>
    <head>
      <meta charset=\"utf-8\">
      <title>REST Hello World!</title>
    </head>
    <body>
      <p>REST Hello World as HTML!</p>
    </body>
    </html>
    """
    {body, req, state}
  end
  
  def hello_to_json(req, state) do
    body = "{\"rest\": \"Hello World!\"}"
    {body, req, state}
  end

  def hello_to_text(req, state) do
    {"REST Hello World as text!", req, state}
  end
end