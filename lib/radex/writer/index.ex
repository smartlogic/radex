defmodule Radex.Writer.Index do
  @moduledoc """
  Behaviour for Index writers
  """

  @callback write(metadata :: map, path :: Path.t()) :: :ok

  defdelegate examples(metadata), to: Radex.Writer.Example
end
