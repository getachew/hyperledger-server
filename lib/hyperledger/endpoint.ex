defmodule Hyperledger.Endpoint do
  use Phoenix.Endpoint, otp_app: :hyperledger

  plug Plug.Static,
    at: "/", from: :hyperledger

  plug Plug.Logger

  # Code reloading will only work if the :code_reloader key of
  # the :phoenix application is set to true in your config file.
  plug Phoenix.CodeReloader

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session,
    store: :cookie,
    key: "_hyperledger_key",
    signing_salt: "7W9fFuDp",
    encryption_salt: "yUuVSVc/"

  plug :router, Hyperledger.Router
end
