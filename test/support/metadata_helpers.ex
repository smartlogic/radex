defmodule Test.MetadataHelpers do
  @moduledoc """
  Helpers for dealing with the Metadata module
  """

  alias Radex.Metadata

  @doc """
  Clear the metadata stored in the gen server
  """
  def clear_metadata() do
    # Replace the internal state to make sure this test passes
    :sys.replace_state(Metadata, fn (_state) -> %{} end)
  end
end
