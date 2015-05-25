defmodule Hyperledger.Authentication.Test do
  use ExUnit.Case, async: true
  use Plug.Test

  defmodule TestPlug do
    use Plug.Builder
    import Plug.Conn

    plug Hyperledger.Authentication
    plug :index

    defp index(conn, _opts) do
      send_resp(conn, 200, "")
    end
  end

  defp call(plug) do
    conn(:get, "/", [])
    |> plug.call([])
  end
  
  defp call(plug, auth_header) do
    conn(:get, "/", [])
    |> put_req_header("authorization", auth_header)
    |> plug.call([])
  end
  
  defp key_pair do
    :crypto.generate_key(:ecdh, :secp256k1)
  end
  
  defp sign(message, key) do
    :crypto.sign(:ecdsa, :sha256, message, [key, :secp256k1])
  end

  defp assert_unauthorized(conn) do
    assert conn.status == 401
    refute conn.assigns[:authentication_key]
    refute conn.assigns[:signature]
  end

  defp assert_authorized(conn) do
    assert conn.status == 200
    assert conn.assigns[:authentication_key]
    assert conn.assigns[:signature]
  end

  defp auth_header(key, sig) do
    "Hyper Key=#{key}, Signature=#{sig}"
  end
  
  setup do
    {public_key, private_key} = key_pair
    body = "{}"
    signature = sign(body, private_key)
    {:ok, key: Base.encode16(public_key), sig: Base.encode16(signature)}
  end

  test "request without auth header" do
    conn = call(TestPlug)
    assert_unauthorized conn
  end
  
  test "request without key", %{sig: sig} do
    conn = call(TestPlug, "Hyper Signature=#{sig}")
    assert_unauthorized conn
  end
  
  test "request without signature", %{key: key} do
    conn = call(TestPlug, "Hyper Key=#{key}")
    assert_unauthorized conn
  end

  test "request with wrong scheme", %{key: key, sig: sig} do
    conn = call(TestPlug, "Basic Key=#{key}, Signature=#{sig}")
    assert_unauthorized conn
  end
  
  test "request with key which is not base 32", %{key: key} do
    conn = call(TestPlug, auth_header(key, "foo"))
    assert_unauthorized conn
  end

  test "request with signature which is not base 32", %{key: key} do
    conn = call(TestPlug, auth_header(key, "foo"))
    assert_unauthorized conn
  end

  test "request correct details", %{key: key, sig: sig} do
    conn = call(TestPlug, auth_header(key, sig))
    assert_authorized conn
  end
end