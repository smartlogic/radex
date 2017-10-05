defmodule Radex.Formatter do
  @moduledoc """
  ExUnit formatter

  Writes documentation after the suite has finished
  """

  use GenServer

  @doc false
  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  #
  # Server
  #

  def init(_) do
    {:ok, %{}}
  end

  def handle_cast({:suite_finished, _run_us, _load_us}, state) do
    IO.puts "Writing documentation"
    {:noreply, state}
  end

  def handle_cast(_, state) do
    {:noreply, state}
  end
end
