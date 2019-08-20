defmodule Healthchex.Probes.Readiness do
  import Plug.Conn

  @default_probe &__MODULE__.probe/0

  def init(opts) do
    %{
      path: Keyword.get(opts, :path, default_path()),
      resp: Keyword.get(opts, :resp, default_resp()),
      probe: Keyword.get(opts, :probe, @default_probe)
    }
  end

  def call(%Plug.Conn{request_path: path} = conn, %{path: path, resp: resp, probe: probe}) do
    case probe.() do
      :ok ->
        conn
        |> send_resp(200, resp)
        |> halt()

      _ ->
        conn
    end
  end

  def call(conn, _opts), do: conn

  def probe, do: :ok
  defp default_path, do: Application.get_env(:healthchex, :readiness_path, "/health/ready")
  defp default_resp, do: Application.get_env(:healthchex, :readiness_response, "OK")
end
