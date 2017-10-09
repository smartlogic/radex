defmodule Radex.Endpoint do
  @radex_key :radex

  alias Radex.Metadata

  @type route :: {method :: String.t(), path :: String.t()}

  defmacro __using__(_opts) do
    quote do
      import Radex.Endpoint

      Module.register_attribute(__MODULE__, :parameter, accumulate: true)

      @before_compile Radex.Endpoint

      @resource nil
      @route nil

      setup opts do
        key = Radex.generate_key()
        Process.put(radex_key(), key)

        on_exit(fn ->
          Radex.Metadata.record_metadata(key, %{
            resource: resource(),
            description: description(opts),
            route: route(),
            parameters: parameters()
          })
        end)

        :ok
      end
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      @doc """
      Accessor for the resource of the endpoint
      """
      def resource, do: @resource

      @doc """
      Accessor for the route of the endpoint
      """
      def route, do: @route

      @doc """
      Accessor for all defined parameters
      """
      def parameters, do: @parameter
    end
  end

  @doc false
  def radex_key, do: @radex_key

  @doc """
  Convert test metadata into a description
  """
  def description(%{describe: describe, test: test}) when describe != nil do
    %{test: test}
    |> description()
    |> String.replace_prefix(describe, "")
    |> String.trim()
  end

  def description(%{test: test}) do
    test
    |> to_string()
    |> String.replace_prefix("test ", "")
    |> String.trim()
  end

  @doc """
  Record a `Plug.Conn` for the current test process
  """
  @spec record(conn :: Plug.Conn.t()) :: Plug.Conn.t()
  def record(conn) do
    radex_key()
    |> Process.get()
    |> Metadata.record_conn(conn)
  end
end
