defmodule Radex.ConnCase do
  defmacro __using__(_opts) do
    quote do
      use ExUnit.Case
      use Plug.Test

      @plug_opts Test.Router.init([])

      def basic_conn() do
        conn = conn(:post, "/ping")
        Test.Router.call(conn, @plug_opts)
      end
    end
  end
end
