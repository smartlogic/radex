defmodule Radex.Writer.Example do
  @moduledoc """
  Generate example files
  """

  alias Radex.Writer

  @doc """
  Generate and write the example files
  """
  @spec write(map, Path.t) :: :ok
  def write(metadata, path) do
    metadata
    |> Map.values()
    |> Enum.each(&(write_example(&1, path)))
  end

  @doc """
  Generate and write a single example file
  """
  @spec write_example(map, Path.t) :: :ok
  def write_example(example, path) do
    file = Path.join(path, Writer.example_file_path(example))
    directory = Path.dirname(file)
    File.mkdir_p(directory)

    file
    |> File.write(example |> generate_example())
  end

  @doc """
  Generate an example
  """
  @spec generate_example(map) :: String.t
  def generate_example(example) do
    %{
      resource: example.metadata.resource,
      http_method: example.metadata |> route_method(),
      route: example.metadata |> route_path(),
      description: example.metadata.description,
      explanation: nil,
      parameters: [],
      response_fields: [],
      requests: example.conns |> generate_requests(),
    }
    |> Poison.encode!
  end

  defp route_method(%{route: {method, _}}), do: method
  defp route_path(%{route: {_, path}}), do: path

  @doc """
  Generate response map from a Radex.Conn
  """
  @spec generate_requests([Radex.Conn.t]) :: [map]
  def generate_requests([]), do: []
  def generate_requests([conn | conns]) do
    request = generate_request(conn)
    [request | generate_requests(conns)]
  end

  @doc """
  Generate a single request map from a Radex.Conn
  """
  @spec generate_request(Radex.Conn.t) :: map
  def generate_request(conn) do
    %{
      request_method: conn.request.method,
      request_path: conn.request.path,
      request_headers: conn.request.headers |> generate_headers(),
      request_body: conn.request.body,
      request_query_parameters: conn.request.query_params,
      response_status: conn.response.status,
      response_body: conn.response.body,
      response_headers: conn.response.headers |> generate_headers(),
    }
  end

  defp generate_headers(headers) do
    headers
    |> Enum.into(%{})
  end
end
