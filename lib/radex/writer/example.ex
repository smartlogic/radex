defmodule Radex.Writer.Example do
  @moduledoc """
  Behaviour for example writers
  """

  alias Radex.Metadata

  @callback write(metadata :: map, path :: Path.t()) :: :ok

  @doc """
  Get examples for a map of metadata
  """
  @spec examples(metadata :: map) :: [Metadata.t()]
  def examples(metadata) do
    metadata
    |> Map.values()
    |> Enum.filter(&use_example?/1)
  end

  @doc """
  Only use an example if there are 1 or more conns
  """
  def use_example?(example) do
    length(example.conns) > 0
  end
end
