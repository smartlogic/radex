defmodule Radex.Writer do
  @moduledoc """
  Write documentation based on the metadata stored
  """

  alias Radex.Writer.JSON.Example
  alias Radex.Writer.JSON.Index

  @doc """
  Generate the index and all example files
  """
  def write!(metadata, path) do
    Index.write(metadata, path)
    Example.write(metadata, path)
  end

  @doc """
  Generate a file path for an example

      iex> example = %{metadata: %{resource: "Orders", description: "Creating an order"}}
      iex> Radex.Writer.example_file_path(example)
      "orders/creating_an_order.json"
  """
  @spec example_file_path(map) :: String.t
  def example_file_path(example) do
    folder = String.downcase(example.metadata.resource)
    file =
      example.metadata.description
      |> String.downcase()
      |> String.replace(~r/\s+/, "_")

    Path.join(folder, "#{file}.json")
  end
end
