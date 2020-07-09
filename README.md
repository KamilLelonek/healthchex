# healthchex

[![Build Status](https://travis-ci.org/KamilLelonek/healthchex.svg?branch=master)](https://travis-ci.org/KamilLelonek/healthchex)

Kubernetes Liveness and Readiness Probes as Elixir Plugs.

## Installation

The package can be installed by adding `healthchex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:healthchex, "~> x.x.x"}
  ]
end
```

## Usage

To keep the documentation up to date, I decided to not duplicate it here, but include all usage examples as test cases.

Have a look at [`test/probes`](./test/probes) directory to see how you can use these Plugs.

```elixir
defmodule MyApp.Router do
  use Phoenix.Router

  forward "/health/live", Healthchex.Probes.Liveness
  forward "/health/ready", Healthchex.Probes.Readiness

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", MyApp do
    pipe_through :api
  end
end
```
