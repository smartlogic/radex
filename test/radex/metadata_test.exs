defmodule Radex.MetadataTest do
  use ExUnit.Case

  alias Radex.Metadata

  import Radex, only: [generate_key: 0]

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
end
