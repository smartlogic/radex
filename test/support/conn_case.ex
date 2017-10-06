defmodule Radex.ConnCase do
  defmacro __using__(_opts) do
    quote do
      use ExUnit.Case
      use Plug.Test

      @plug_opts Test.Router.init([])
    end
  end
end
