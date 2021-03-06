defmodule Radex.WriterTest do
  use ExUnit.Case
  doctest Radex.Writer

  alias Radex.Conn
  alias Radex.Metadata
  alias Radex.Writer.JSON

  setup [:temp_path, :record_metadata]

  test "writes the index", %{path: path, metadata: metadata} do
    JSON.Index.write(metadata, path)

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
                     "link" => "orders/creating_an_order.json"
                   }
                 ]
               }
             ]
           }
  after
    File.rm_rf(path)
  end

  test "writes examples", %{path: path, metadata: metadata} do
    JSON.Example.write(metadata, path)

    example_file = Path.join(path, "orders/creating_an_order.json")
    assert File.exists?(example_file)

    {:ok, body} = File.read(example_file)

    assert Poison.decode!(body) == %{
             "resource" => "Orders",
             "http_method" => "POST",
             "route" => "/orders",
             "description" => "Creating an Order",
             "explanation" => nil,
             "parameters" => [
               %{"name" => "email", "description" => "The order's email address"},
               %{"name" => "name", "description" => "A name for the order", "type" => "string"}
             ],
             "response_fields" => [],
             "requests" => [
               %{
                 "request_method" => "POST",
                 "request_path" => "/orders",
                 "request_body" => "{}",
                 "request_headers" => %{"Content-Type" => "application/json"},
                 "request_query_parameters" => %{},
                 "response_status" => 201,
                 "response_body" => "order body",
                 "response_headers" => %{"Content-Type" => "application/json"}
               }
             ]
           }
  after
    File.rm_rf(path)
  end

  # Generate a temp path to work in
  def temp_path(_) do
    {:ok, path} = Temp.mkdir("radex")
    %{path: path}
  end

  # Set up metadata for generation
  def record_metadata(_) do
    key = Radex.generate_key()

    metadata = %{
      key => %Metadata{
        success: true,
        metadata: %{
          resource: "Orders",
          description: "Creating an Order",
          route: {"POST", "/orders"},
          parameters: [
            {"email", "The order's email address"},
            {"name", "A name for the order", type: :string}
          ]
        },
        conns: [
          %Conn{
            request: %Conn.Request{
              method: "POST",
              path: "/orders",
              headers: [{"content-type", "application/json"}],
              query_params: %{},
              body: "{}"
            },
            response: %Conn.Response{
              status: 201,
              headers: [{"content-type", "application/json"}],
              body: "order body"
            }
          }
        ]
      }
    }

    %{key: key, metadata: metadata}
  end
end
