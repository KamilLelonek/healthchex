defmodule Healthchex.Probes.ReadinessTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Plug.Conn
  alias Healthchex.Probes.Readiness

  describe "plain Plug" do
    defmodule PlainPlug do
      use Plug.Router

      plug(Readiness)

      get("/", do: send_resp(conn, 200, "Hello"))
    end

    test "should respond with OK" do
      assert %Conn{resp_body: "OK", halted: true} =
               :get
               |> conn("/health/ready")
               |> PlainPlug.call([])
    end
  end

  describe "Plug with a custom path" do
    defmodule PlugWithPath do
      use Plug.Router

      plug(Readiness, path: "/ready")

      get("/", do: send_resp(conn, 200, "Hello"))
    end

    test "should respond with OK" do
      assert %Conn{resp_body: "OK", halted: true} =
               :get
               |> conn("/ready")
               |> PlugWithPath.call([])
    end
  end

  describe "Plug with a custom response" do
    defmodule PlugWithResp do
      use Plug.Router

      plug(Readiness, resp: "Working")

      get("/", do: send_resp(conn, 200, "Hello"))
    end

    test "should respond with Working" do
      assert %Conn{resp_body: "Working", halted: true} =
               :get
               |> conn("/health/ready")
               |> PlugWithResp.call([])
    end
  end

  describe "Plug with a custom probe" do
    defmodule PlugWithProbe do
      use Plug.Router

      plug(Readiness, probe: &PlugWithProbe.probe/0)

      get("/", do: send_resp(conn, 200, "Hello"))

      def probe, do: :ok
    end

    test "should respond with OK" do
      assert %Conn{resp_body: "OK", halted: true} =
               :get
               |> conn("/health/ready")
               |> PlugWithProbe.call([])
    end
  end

  describe "Plug with a failing probe" do
    defmodule PlugWithFailingProbe do
      use Plug.Router

      plug(Readiness, probe: &PlugWithFailingProbe.probe/0)

      get("/", do: send_resp(conn, 200, "Hello"))

      def probe, do: :error
    end

    test "should respond with OK" do
      assert %Conn{resp_body: nil, halted: false} =
               :get
               |> conn("/health/ready")
               |> PlugWithFailingProbe.call([])
    end
  end

  describe "Plug with forwarding" do
    defmodule PlugForward do
      use Plug.Router

      plug(:match)
      plug(:dispatch)

      forward(
        "/health/ready",
        to: Readiness
      )
    end

    test "should respond with OK" do
      assert %Conn{resp_body: "OK", halted: true} =
               :get
               |> conn("/health/ready")
               |> PlugForward.call([])
    end
  end

  describe "Plug with forwarding and a custom path" do
    defmodule PlugForwardPath do
      use Plug.Router

      plug(:match)
      plug(:dispatch)

      forward(
        "/ready",
        to: Readiness,
        init_opts: [path: "/ready"]
      )
    end

    test "should respond with OK" do
      assert %Conn{resp_body: "OK", halted: true} =
               :get
               |> conn("/ready")
               |> PlugForwardPath.call([])
    end
  end

  describe "Plug with forwarding and a custom response" do
    defmodule PlugForwardResp do
      use Plug.Router

      plug(:match)
      plug(:dispatch)

      forward(
        "/health/ready",
        to: Readiness,
        init_opts: [resp: "Working"]
      )
    end

    test "should respond with Working" do
      assert %Conn{resp_body: "Working", halted: true} =
               :get
               |> conn("/health/ready")
               |> PlugForwardResp.call([])
    end
  end

  describe "Plug with forwarding and a custom probe" do
    defmodule PlugForwardProbe do
      use Plug.Router

      plug(:match)
      plug(:dispatch)

      forward(
        "/health/ready",
        to: Readiness,
        init_opts: [probe: &PlugForwardProbe.probe/0]
      )

      def probe, do: :ok
    end

    test "should respond with OK" do
      assert %Conn{resp_body: "OK", halted: true} =
               :get
               |> conn("/health/ready")
               |> PlugForwardProbe.call([])
    end
  end

  describe "Plug with forwarding and a failing probe" do
    defmodule PlugForwardFailingProbe do
      use Plug.Router

      plug(:match)
      plug(:dispatch)

      forward(
        "/health/ready",
        to: Readiness,
        init_opts: [probe: &PlugForwardFailingProbe.probe/0]
      )

      def probe, do: :error
    end

    test "should respond with OK" do
      assert %Conn{resp_body: nil, halted: false} =
               :get
               |> conn("/health/ready")
               |> PlugForwardFailingProbe.call([])
    end
  end
end
