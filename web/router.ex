defmodule Hyperledger.Router do
  use Phoenix.Router

  pipeline :api do
    plug :accepts, ~w(json)
    plug :put_resp_content_type, Plug.MIME.type("json")
  end

  scope "/", Hyperledger do
    pipe_through :api

    resources "/ledgers", LedgerController, only: [:index, :create] do
      resources "/accounts", AccountController, only: [:index, :show, :create]
      resources "/issues", IssueController, only: [:create]
      resources "/transfers", TransferController, only: [:create]
    end
  end
end
