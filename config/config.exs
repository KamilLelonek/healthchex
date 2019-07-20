use Mix.Config

config :healthchex,
  liveness_path: "/health/live",
  liveness_response: "OK",
  readiness_path: "/health/ready",
  readiness_response: "OK"
