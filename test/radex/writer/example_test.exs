defmodule Radex.Writer.ExampleTest do
  use ExUnit.Case

  alias Radex.Conn
  alias Radex.Metadata
  alias Radex.Writer.Example

  test "filters out empty examples from metadata" do
    metadata = %{
      "key1" => %Metadata{success: true},
      "key2" => %Metadata{success: true, conns: [%Conn{}]}
    }

    assert Example.examples(metadata) == [%Metadata{success: true, conns: [%Conn{}]}]
  end

  test "ignore examples that are missing conns" do
    assert Example.use_example?(%Metadata{success: true, conns: [%Conn{}]})
    refute Example.use_example?(%Metadata{success: true, conns: []})
  end

  test "ignore examples that are not marked as successful" do
    assert Example.use_example?(%Metadata{conns: [%Conn{}], success: true})
    refute Example.use_example?(%Metadata{conns: [%Conn{}], success: false})
  end
end
