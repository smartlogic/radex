defmodule Radex.Conn do
  @moduledoc """
  Helpers for documenting a Plug.Conn
  """

  defstruct [:request, :response]

  @type t :: %__MODULE__{}

  defmodule Request do
    @moduledoc """
    A struct for containing Request information
    """

    defstruct [:method, :path, :headers, :query_params, :body]

    @type t :: %__MODULE__{}
  end

  defmodule Response do
    @moduledoc """
    A struct for containing Response information
    """

    defstruct [:status, :headers, :body]

    @type t :: %__MODULE__{}
  end

  @doc """
  Document a Plug.Conn

  Prepares it for writing by fetching all information required from the conn.
  """
  @spec document(conn :: Plug.Conn.t()) :: t()
  def document(conn = %Plug.Conn{}) do
    %__MODULE__{
      request: document_request(conn),
      response: document_response(conn)
    }
  end

  @doc """
  Document the request half of the Conn
  """
  @spec document_request(conn :: Plug.Conn.t()) :: Request.t()
  def document_request(conn) do
    %Request{
      method: conn.method,
      path: conn.request_path,
      headers: conn.req_headers,
      query_params: conn.query_params,
      body: request_body(conn.body_params)
    }
  end

  defp request_body(body) when body == %{}, do: nil
  defp request_body(body), do: Poison.encode!(body)

  @doc """
  Document the response half of the Conn
  """
  @spec document_response(conn :: Plug.Conn.t()) :: Response.t()
  def document_response(conn) do
    %Response{
      status: conn.status,
      headers: conn.resp_headers,
      body: conn.resp_body
    }
  end
end
