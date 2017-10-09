defmodule Radex.Metadata do
  @moduledoc """
  Process for storing metadata about the API
  """

  use GenServer

  alias Radex.Conn

  defstruct metadata: %{}, conns: []

  @type t :: %__MODULE__{}

  @doc false
  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  #
  # Client
  #

  @doc """
  Record metadata about a key
  """
  @spec record_metadata(key :: String.t(), metadata :: t) :: :ok
  def record_metadata(key, metadata, opts \\ []) do
    GenServer.cast(__MODULE__, {:record_metadata, key, metadata, opts})
  end

  @doc """
  Record a `Plug.Conn` for a key
  """
  @spec record_conn(key :: String.t(), conn :: Plug.Conn.t()) :: Plug.Conn.t()
  def record_conn(key, conn) do
    GenServer.cast(__MODULE__, {:record_conn, key, conn})
    conn
  end

  @doc """
  Get information about a test by it's key
  """
  @spec get(key :: String.t()) :: map
  def get(key) do
    GenServer.call(__MODULE__, {:get, key})
  end

  @doc """
  Get all metadata in the process

  For when all tests have completed and documentation will be written
  """
  @spec get_all() :: [t]
  def get_all() do
    GenServer.call(__MODULE__, :get_all)
  end

  #
  # Server
  #

  def init(_) do
    {:ok, %{}}
  end

  def handle_call({:get, key}, _from, state) do
    test = state |> Map.get(key, nil)
    {:reply, test, state}
  end

  def handle_call(:get_all, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:record_metadata, key, new_metadata, opts}, state) do
    example = Map.get(state, key, %__MODULE__{})
    metadata = Map.get(example, :metadata, %{})

    metadata =
      case Keyword.get(opts, :overwrite, true) do
        true -> Map.merge(metadata, new_metadata)
        false -> Map.merge(new_metadata, metadata)
      end

    example = Map.put(example, :metadata, metadata)

    {:noreply, Map.put(state, key, example)}
  end

  def handle_cast({:record_conn, key, conn}, state) do
    test = Map.get(state, key, %__MODULE__{})
    conns = Map.get(test, :conns, [])
    conns = conns ++ [Conn.document(conn)]
    test = Map.put(test, :conns, conns)

    {:noreply, Map.put(state, key, test)}
  end
end
