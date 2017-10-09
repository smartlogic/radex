defmodule Radex.EndpointTest do
  use Radex.ConnCase

  alias Radex.Endpoint
  alias Radex.Metadata

  describe "generates the description properly" do
    test "without a describe" do
      opts = %{
        describe: nil,
        test: "test Creating an Order"
      }

      assert Endpoint.description(opts) == "Creating an Order"
    end

    test "with a describe" do
      opts = %{
        describe: "create an order",
        test: "test create an order Creating an Order"
      }

      assert Endpoint.description(opts) == "Creating an Order"
    end
  end

  describe "updating metadata" do
    setup [:prepare_process]

    test "from a test", %{key: key} do
      Endpoint.radex_metadata(%{description: "Creating an order"})

      assert Metadata.get(key).metadata.description == "Creating an order"
    end
  end

  describe "recording conns" do
    setup [:prepare_process]

    test "saves to the key's metadata", %{key: key} do
      Endpoint.record(basic_conn())

      assert %{conns: [%Radex.Conn{}]} = Metadata.get(key)
    end
  end

  describe "the use macro" do
    use Radex.Endpoint

    @resource "Orders"
    @route {"POST", "/orders"}

    @parameter {"name", "Order Name", type: :string}

    test "get the resource" do
      assert resource() == "Orders"
    end

    test "get the route" do
      assert route() == {"POST", "/orders"}
    end

    test "get the parameters" do
      assert parameters() == [
               {"name", "Order Name", type: :string}
             ]
    end
  end

  def prepare_process(_) do
    key = Radex.generate_key()
    Process.put(Endpoint.radex_key(), key)
    %{key: key}
  end
end
