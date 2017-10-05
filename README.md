# Radex

A utility to generate documentation for your web API via tests.

## Installation

```elixir
def deps do
  [
    {:radex, "~> 0.1.0"},
  ]
end
```

## Usage

An example test:

```elixir
defmodule AppWeb.OrderControllerTest do
  use AppWeb.ConnCase

  describe "creating" do
    use Radex.Endpoint

    @resource "Orders"
    @route {"POST", "/orders"}

    @parameter {"location", "Order Location", type: :string}

    test "Creating an Order", %{conn: conn} do
      conn =
        conn
        |> post(order_path(conn, :create), %{name: "Cafe"})
        |> record()

      assert conn.status == 201
    end
  end
end
```

Record documentation by using the Radex formatter:

```
mix test --formatter Radex.Formatter
```
