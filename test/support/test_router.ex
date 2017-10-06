defmodule Test.Router do
  use Plug.Router

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug :match
  plug :dispatch

  post "/ping" do
    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(200, %{ping: "pong"} |> Poison.encode!())
  end

  match _ do
    IO.inspect "oops"
    send_resp(conn, 404, "oops")
  end
end
