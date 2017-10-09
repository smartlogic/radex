defmodule Radex.Writer.JSON.IndexTest do
  use ExUnit.Case

  alias Radex.Conn
  alias Radex.Metadata
  alias Radex.Writer.JSON.Index

  test "generating index information" do
    metadata = %{
      Radex.generate_key() => %Metadata{
        success: true,
        metadata: %{
          resource: "Orders",
          description: "Creating an Order"
        },
        conns: [%Conn{}]
      },
      Radex.generate_key() => %Metadata{
        success: true,
        metadata: %{
          resource: "Orders",
          description: "Viewing an Order"
        },
        conns: [%Conn{}]
      }
    }

    expected_index = %{
      "resources" => [
        %{
          "name" => "Orders",
          "examples" => [
            %{"description" => "Creating an Order", "link" => "orders/creating_an_order.json"},
            %{"description" => "Viewing an Order", "link" => "orders/viewing_an_order.json"}
          ]
        }
      ]
    }

    index = Index.generate_index(metadata)
    assert Poison.decode!(index) == expected_index
  end
end
