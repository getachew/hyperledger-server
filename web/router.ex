defmodule Hyperledger.Router do
  use Phoenix.Router

  pipeline :api do
    plug :accepts, ~w(uber)
    plug :put_resp_content_type, "application/vnd.uber-amundsen+json"
  end

  scope "/", Hyperledger do
    pipe_through :api

    get "/", PageController, :index
    get "pool", PoolController, :index
    resources "log", LogEntryController, only: [:index, :create]
    resources "ledgers", LedgerController, only: [:index, :create] do
      resources "issues", IssueController, only: [:index, :create]
    end
    resources "transfers", TransferController, only: [:index, :create]
    resources "accounts", AccountController, only: [:index, :show, :create]
  end
end
