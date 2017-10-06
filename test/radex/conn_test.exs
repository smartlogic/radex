defmodule Radex.ConnTest do
  use Radex.ConnCase

  alias Radex.Conn

  describe "documenting a conn" do
    setup [:document_conn]

    test "request method", %{example: example} do
      assert example.request.method == "POST"
    end

    test "request path", %{example: example} do
      assert example.request.path == "/ping"
    end

    test "request query params", %{example: example} do
      assert example.request.query_params == %{"query" => "param"}
    end

    test "request headers", %{example: example} do
      assert example.request.headers == [
        {"accept", "application/json"},
        {"content-type", "application/json"},
      ]
    end

    test "request body", %{example: example} do
      assert example.request.body == ~s({"body":"param"})
    end

    test "response status", %{example: example} do
      assert example.response.status == 200
    end

    test "response headers", %{example: example} do
      assert example.response.headers == [
        {"cache-control", "max-age=0, private, must-revalidate"},
        {"content-type", "application/json"},
      ]
    end

    test "response body", %{example: example} do
      assert example.response.body == %{ping: "pong"} |> Poison.encode!
    end

    def document_conn(_) do
      body = Poison.encode!(%{body: "param"})
      conn =
        :post
        |> conn("/ping?query=param", body)
        |> put_req_header("accept", "application/json")
        |> put_req_header("content-type", "application/json")

      conn = Test.Router.call(conn, @plug_opts)
      example = Conn.document(conn)

      %{conn: conn, example: example}
    end
  end
end
