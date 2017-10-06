defmodule Radex.Metadata do
  @moduledoc """
  Process for storing metadata about the API
  """

  use GenServer

  @type t :: %{}

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
  @spec record_metadata(key :: String.t, metadata :: t) :: :ok
  def record_metadata(pid \\ __MODULE__, key, metadata) do
    GenServer.cast(pid, {:record_metadata, key, metadata})
  end

  @doc """
  Record a `Plug.Conn` for a key
  """
  @spec record_conn(key :: String.t, conn :: Plug.Conn.t) :: Plug.Conn.t
  def record_conn(pid \\ __MODULE__, key, conn) do
    GenServer.cast(pid, {:record_conn, key, conn})
    conn
  end

  @doc """
  Get information about a test by it's key
  """
  @spec get(key :: String.t) :: map
  def get(pid \\ __MODULE__, key) do
    GenServer.call(pid, {:get, key})
  end

  @doc """
  Get all metadata in the process

  For when all tests have completed and documentation will be written
  """
  @spec get_all() :: [t]
  def get_all(pid \\ __MODULE__) do
    GenServer.call(pid, :get_all)
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

  def handle_cast({:record_metadata, key, metadata}, state) do
    test =
      state
      |> Map.get(key, %{})
      |> Map.put(:metadata, metadata)

    {:noreply, Map.put(state, key, test)}
  end

  def handle_cast({:record_conn, key, conn}, state) do
    test = Map.get(state, key, %{})
    conns = Map.get(test, :conns, [])
    conns = [conn | conns]
    test = Map.put(test, :conns, conns)

    {:noreply, Map.put(state, key, test)}
  end
end
