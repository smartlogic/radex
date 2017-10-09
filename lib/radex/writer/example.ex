defmodule Radex.Writer.Example do
  @moduledoc """
  Behaviour for example writers
  """

  @callback write(metadata :: map, path :: Path.t) :: :ok
end
