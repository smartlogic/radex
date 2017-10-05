defmodule Radex.MetadataTest do
  use ExUnit.Case

  import Test.MetadataHelpers
  import Radex, only: [generate_key: 0]

  alias Radex.Metadata

  test "records metadata for a key" do
    key = generate_key()
    Metadata.record_metadata(key, %{resource: "A Resource"})

    assert Metadata.get(key) == %{metadata: %{resource: "A Resource"}}
  end

  test "records a conn" do
    key = generate_key()

    Metadata.record_conn(key, :conn)
    Metadata.record_conn(key, :conn)

    assert Metadata.get(key) == %{conns: [:conn, :conn]}
  end

  test "get all from the metadata server" do
    clear_metadata()

    Metadata.record_conn(generate_key(), :conn)
    Metadata.record_conn(generate_key(), :conn)

    assert Metadata.get_all() |> Map.keys() |> length() == 2
  end
end
