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

  test "records metadata for a key twice - merging the second time" do
    key = generate_key()
    Metadata.record_metadata(key, %{resource: "A Resource"})
    Metadata.record_metadata(key, %{description: "Creating a resource"})

    assert Metadata.get(key) == %Metadata{
             metadata: %{resource: "A Resource", description: "Creating a resource"}
           }
  end

  test "records metadata for a key twice - disable overwrite for a second call" do
    key = generate_key()
    Metadata.record_metadata(key, %{description: "Creating a resource"})
    Metadata.record_metadata(key, %{description: "renders without error"}, overwrite: false)

    assert Metadata.get(key) == %Metadata{metadata: %{description: "Creating a resource"}}
  end

  test "records a conn" do
    key = generate_key()

    Metadata.record_conn(key, basic_conn())
    Metadata.record_conn(key, basic_conn())

    assert %{conns: [%Radex.Conn{}, %Radex.Conn{}]} = Metadata.get(key)
  end

  test "record a successful example" do
    key = generate_key()

    Metadata.record_success(key)

    assert Metadata.get(key) == %Metadata{success: true}
  end

  test "register a key to a file and line number for marking successful" do
    key = generate_key()

    Metadata.register(key, "file.exs", 10)

    assert Metadata.get(key)
    assert Metadata.get(%{file: "file.exs", line: 10})
  end

  test "get all from the metadata server" do
    clear_metadata()

    Metadata.record_conn(generate_key(), basic_conn())
    Metadata.record_conn(generate_key(), basic_conn())

    assert Metadata.get_all() |> Map.keys() |> length() == 2
  end
end
