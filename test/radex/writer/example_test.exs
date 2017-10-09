defmodule Radex.Writer.ExampleTest do
  use ExUnit.Case

  alias Radex.Conn
  alias Radex.Metadata
  alias Radex.Writer.Example

  test "filters out empty examples from metadata" do
    metadata = %{
      "key1" => %Metadata{},
      "key2" => %Metadata{conns: [%Conn{}]}
    }

    assert Example.examples(metadata) == [%Metadata{conns: [%Conn{}]}]
  end

  test "ignore examples that are missing conns" do
    assert Example.use_example?(%Metadata{conns: [%Conn{}]})
    refute Example.use_example?(%Metadata{})
  end
end
