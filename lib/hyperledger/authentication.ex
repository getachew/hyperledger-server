defmodule Hyperledger.Authentication do
  @moduledoc """
    Insppired by https://github.com/briksoftware/plug_auth
    
    Authenticates HTTP connection by public key and signature
  """

  @behaviour Plug
  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    conn
    |> get_auth_header
    |> parse_params
    |> decode_params
    |> assert_auth
  end

  defp get_auth_header(conn) do
    {conn, get_req_header(conn, "authorization")}
  end
  
  defp parse_params({conn, ["Hyper " <> params]}) do
    parsed_params = params
    |> String.split(", ")
    |> Enum.map(&String.strip/1)
    |> Enum.map(&(String.split(&1, "=")))
    |> Enum.filter(&(Enum.count(&1) == 2))
    |> Enum.map(&List.to_tuple/1)
    {conn, parsed_params}
  end
  
  defp parse_params({conn, _}) do
    {conn, []}
  end
  
  defp decode_params({conn, [{"Key", key}, {"Signature", sig}]}) do
    case {Base.decode16(key), Base.decode16(sig)} do
      {{:ok, key}, {:ok, sig}} ->
        {conn, %{key: key, sig: sig}}
      _ ->
        {conn, :error}
    end
  end
  
  defp decode_params({conn, _}) do
    {conn, :error}
  end
  
  defp assert_auth({conn, %{key: key, sig: sig}}) do
    conn
    |> assign(:authentication_key, key)
    |> assign(:signature, sig)
  end

  defp assert_auth({conn, _}) do
    conn 
    |> put_resp_header("Www-Authenticate", "Hyper")
    |> send_resp(401, "")
    |> halt
  end
end