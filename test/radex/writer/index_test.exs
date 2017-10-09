defmodule Radex.Writer.IndexTest do
  use ExUnit.Case

  alias Radex.Conn
  alias Radex.Metadata
  alias Radex.Writer.Index

  test "filters out empty examples from metadata" do
    metadata = %{
      "key1" => %Metadata{success: true},
      "key2" => %Metadata{success: true, conns: [%Conn{}]}
    }

    assert Index.examples(metadata) == [%Metadata{success: true, conns: [%Conn{}]}]
  end
end
