defmodule Radex.Writer.JSON.ExampleTest do
  use ExUnit.Case

  alias Radex.Writer.JSON.Example

  doctest Radex.Writer.JSON.Example

  test "generates a header from the conn tuple" do
    assert Example.generate_header({"accept", "application/json"}) == {
             "Accept",
             "application/json"
           }
  end
end
