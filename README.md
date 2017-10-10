# Radex

[![Build Status](https://travis-ci.org/smartlogic/radex.svg?branch=master)](https://travis-ci.org/smartlogic/radex)

A utility to generate documentation for your web API via tests.

## Installation

```elixir
# mix.exs

defp deps do
  [
    {:radex, "~> 0.1.0"},
  ]
end

# You can also set up an alias for the formatter
# This must be run with MIX_ENV=test explicitly declared
defp aliases do
  [
    "radex.test": ["test --formatter Radex.Formatter"],
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
MIX_ENV=test mix radex.test
```

## Configuration

```elixir
# config/test.exs

config :radex,
  path: "docs"
```
