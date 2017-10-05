defmodule RadexTest do
  use ExUnit.Case
  doctest Radex

  test "generate a key" do
    assert is_binary(Radex.generate_key())
  end
end
