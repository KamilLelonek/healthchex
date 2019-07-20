use Mix.Config

config :healthchex,
  liveness_path: "/health/live",
  liveness_response: "OK"
