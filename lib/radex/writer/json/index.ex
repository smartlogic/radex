defmodule Radex.Writer.JSON.Index do
  @moduledoc """
  Generate the index file
  """

  alias Radex.Writer

  @behaviour Radex.Writer.Index

  @doc """
  Write the index
  """
  @spec write(map, path :: Path.t()) :: :ok
  @impl Radex.Writer.Index
  def write(metadata, path) do
    File.mkdir_p(path)

    path
    |> Path.join("index.json")
    |> File.write(metadata |> generate_index())
  end

  @doc """
  Generate the contents of the index file
  """
  @spec generate_index(map) :: String.t()
  def generate_index(metadata) do
    metadata
    |> Enum.map(&elem(&1, 1))
    |> Enum.group_by(& &1.metadata.resource)
    |> Enum.reduce(%{resources: []}, &generate_sections/2)
    |> Poison.encode!()
  end

  @doc """
  Generate sections of the index file
  """
  @spec generate_sections({String.t(), [map]}, map) :: map
  def generate_sections({resource_name, examples}, map) do
    resource = %{
      name: resource_name,
      examples: examples |> Enum.map(&index_example/1)
    }

    resources = [resource | map.resources]
    Map.put(map, :resources, resources)
  end

  defp index_example(example) do
    %{
      description: example.metadata.description,
      link: example |> Writer.example_file_path()
    }
  end
end
