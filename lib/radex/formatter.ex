defmodule Radex.Formatter do
  @moduledoc """
  ExUnit formatter

  Writes documentation after the suite has finished
  """

  use GenServer

  #
  # Server
  #

  def init(opts) do
    ExUnit.CLIFormatter.init(opts)
  end

  def handle_cast(args = {:suite_finished, _run_us, _load_us}, state) do
    IO.puts "\n"
    IO.write "Writing documentation"
    ExUnit.CLIFormatter.handle_cast(args, state)
  end

  def handle_cast(args, state) do
    ExUnit.CLIFormatter.handle_cast(args, state)
  end
end
