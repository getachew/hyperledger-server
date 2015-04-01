defmodule Hyperledger.Router do
  use Phoenix.Router

  pipeline :api do
    plug :accepts, ~w(json)
    plug :put_resp_content_type, Plug.MIME.type("json")
  end

  scope "/", Hyperledger do
    pipe_through :api

    resources "/", PageController, only: [:index]
    resources "/log", LogEntryController, only: [:index, :create]
    resources "/ledgers", LedgerController, only: [:index, :create] do
      resources "/issues", IssueController, only: [:create]
      resources "/transfers", TransferController, only: [:create]
    end
    resources "/accounts", AccountController, only: [:index, :show, :create]
  end
end
