defmodule Healthchex.Probes.LivenessTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Plug.Conn
  alias Healthchex.Probes.Liveness

  describe "plain Plug" do
    defmodule PlainPlug do
      use Plug.Router

      plug(Liveness)

      get("/", do: send_resp(conn, 200, "Hello"))
    end

    test "should respond with OK" do
      assert %Conn{resp_body: "OK", halted: true} =
               :get
               |> conn("/health/live")
               |> PlainPlug.call([])
    end
  end

  describe "Plug with a custom path" do
    defmodule PlugWithPath do
      use Plug.Router

      plug(Liveness, path: "/alive")

      get("/", do: send_resp(conn, 200, "Hello"))
    end

    test "should respond with OK" do
      assert %Conn{resp_body: "OK", halted: true} =
               :get
               |> conn("/alive")
               |> PlugWithPath.call([])
    end
  end

  describe "Plug with a custom response" do
    defmodule PlugWithResp do
      use Plug.Router

      plug(Liveness, resp: "Working")

      get("/", do: send_resp(conn, 200, "Hello"))
    end

    test "should respond with Working" do
      assert %Conn{resp_body: "Working", halted: true} =
               :get
               |> conn("/health/live")
               |> PlugWithResp.call([])
    end
  end

  describe "Plug with forwarding" do
    defmodule PlugForward do
      use Plug.Router

      plug(:match)
      plug(:dispatch)

      forward(
        "/health/live",
        to: Liveness
      )
    end

    test "should respond with OK" do
      assert %Conn{resp_body: "OK", halted: true} =
               :get
               |> conn("/health/live")
               |> PlugForward.call([])
    end
  end

  describe "Plug with forwarding and a custom path" do
    defmodule PlugForwardPath do
      use Plug.Router

      plug(:match)
      plug(:dispatch)

      forward(
        "/alive",
        to: Liveness,
        init_opts: [path: "/alive"]
      )
    end

    test "should respond with OK" do
      assert %Conn{resp_body: "OK", halted: true} =
               :get
               |> conn("/alive")
               |> PlugForwardPath.call([])
    end
  end

  describe "Plug with forwarding and a custom response" do
    defmodule PlugForwardResp do
      use Plug.Router

      plug(:match)
      plug(:dispatch)

      forward(
        "/health/live",
        to: Liveness,
        init_opts: [resp: "Working"]
      )
    end

    test "should respond with Working" do
      assert %Conn{resp_body: "Working", halted: true} =
               :get
               |> conn("/health/live")
               |> PlugForwardResp.call([])
    end
  end
end
