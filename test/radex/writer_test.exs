defmodule Radex.WriterTest do
  use ExUnit.Case
  doctest Radex.Writer

  alias Radex.Writer

  setup [:temp_path, :record_metadata]

  test "writes the index", %{path: path, metadata: metadata} do
    Writer.Index.write(metadata, path)

    index_file = Path.join(path, "index.json")
    assert File.exists?(index_file)

    {:ok, body} = File.read(index_file)
    assert Poison.decode!(body) == %{
      "resources" => [
        %{
          "name" => "Orders",
          "examples" => [
            %{
              "description" => "Creating an Order",
              "link" => "orders/creating_an_order.json",
            },
          ],
        },
      ],
    }
  after 
    File.rm_rf(path)
  end

  # Generate a temp path to work in
  def temp_path(_) do
    {:ok, path} = Temp.mkdir "radex"
    %{path: path}
  end

  # Set up metadata for generation
  def record_metadata(_) do
    key = Radex.generate_key()

    metadata = %{
      key => %{
        metadata: %{
          resource: "Orders",
          description: "Creating an Order",
        },
      },
    }

    %{key: key, metadata: metadata}
  end
end
