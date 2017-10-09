defmodule Radex.MetadataTest do
  use Radex.ConnCase

  import Test.MetadataHelpers
  import Radex, only: [generate_key: 0]

  alias Radex.Metadata

  test "records metadata for a key" do
    key = generate_key()
    Metadata.record_metadata(key, %{resource: "A Resource"})

    assert Metadata.get(key) == %Metadata{metadata: %{resource: "A Resource"}}
  end

  test "records a conn" do
    key = generate_key()

    Metadata.record_conn(key, basic_conn())
    Metadata.record_conn(key, basic_conn())

    assert %{conns: [%Radex.Conn{}, %Radex.Conn{}]} = Metadata.get(key)
  end

  test "get all from the metadata server" do
    clear_metadata()

    Metadata.record_conn(generate_key(), basic_conn())
    Metadata.record_conn(generate_key(), basic_conn())

    assert Metadata.get_all() |> Map.keys() |> length() == 2
  end
end
