defmodule AppTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias App.Router.AppRouter

  doctest App

  @router_opts AppRouter.init([])

  test "returns no employees" do
    conn = conn(:get, "/employees")
      |> AppRouter.call(@router_opts)

    assert conn.state == :sent
    assert conn.status == 204
    assert String.match?(conn.resp_body, ~r/No employees found/)
  end

  test "returns correct route not_found message" do
    conn = conn(:get, "/not_found_url")
      |> AppRouter.call(@router_opts)

    assert conn.state == :sent
    assert conn.status == 404
    assert String.match?(conn.resp_body, ~r/Couldn't find that page, sorry!!/)
  end
end
