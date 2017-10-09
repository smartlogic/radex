defmodule Radex.Writer.IndexTest do
  use ExUnit.Case

  alias Radex.Conn
  alias Radex.Metadata
  alias Radex.Writer.Index

  test "filters out empty examples from metadata" do
    metadata = %{
      "key1" => %Metadata{},
      "key2" => %Metadata{conns: [%Conn{}]}
    }

    assert Index.examples(metadata) == [%Metadata{conns: [%Conn{}]}]
  end
end
