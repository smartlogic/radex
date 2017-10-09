defmodule Radex.Formatter do
  @moduledoc """
  ExUnit formatter

  Writes documentation after the suite has finished
  """

  use GenServer

  alias Radex.Metadata
  alias Radex.Writer

  @path Application.get_env(:radex, :path, "docs")

  #
  # Server
  #

  def init(opts) do
    ExUnit.CLIFormatter.init(opts)
  end

  def handle_cast(args = {:test_finished, test}, state) do
    case Metadata.get(%{file: test.tags.file, line: test.tags.line}) do
      nil -> nil
      {key, _example} -> if is_nil(test.state), do: Metadata.record_success(key)
    end

    ExUnit.CLIFormatter.handle_cast(args, state)
  end

  def handle_cast(args = {:suite_finished, _run_us, _load_us}, state) do
    IO.puts("\n")
    IO.write("Writing documentation")

    metadata = Metadata.get_all()

    Writer.write!(metadata, @path)

    ExUnit.CLIFormatter.handle_cast(args, state)
  end

  def handle_cast(args, state) do
    ExUnit.CLIFormatter.handle_cast(args, state)
  end
end
