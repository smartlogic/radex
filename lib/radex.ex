defmodule Radex do
  @moduledoc """
  Documentation for Radex.
  """

  @doc """
  Generate a key to tie together a test
  """
  @spec generate_key() :: String.t
  def generate_key() do
    30 |> :crypto.strong_rand_bytes() |> Base.url_encode64 |> binary_part(0, 30)
  end
end
