# healthchex

[![Build Status](https://travis-ci.org/KamilLelonek/healthchex.svg?branch=master)](https://travis-ci.org/KamilLelonek/healthchex)

Kubernetes Liveness and Readiness Probes as Elixir Plugs.

## Installation

The package can be installed by adding `healthchex` to your list of dependencies in [`mix.exs`](mix.exs):

```elixir
def deps do
  [
    {:healthchex, "~> 0.2"}
  ]
end
```

## Usage

To keep the documentation up to date, I decided to not duplicate it here, but include all usage examples as test cases.

Have a look at [`test/probes`](./test/probes) directory to see how you can use these Plugs.

### Basic

```elixir
defmodule MyApp.Router do
  use Phoenix.Router

  forward("/health/live", Healthchex.Probes.Liveness)
  forward("/health/ready", Healthchex.Probes.Readiness)

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", MyApp do
    pipe_through :api
  end
end
```

### With custom readiness probe

```elixir
defmodule MyApp.Router do
  use Phoenix.Router

  forward "/health/live", Healthchex.Probes.Liveness
  forward "/health/ready", Healthchex.Probes.Readiness, probe: &Domain.db_ready?/0

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", MyApp do
    pipe_through :api
  end
end
```
