# Hyperledger Reference Implementation

This is the reference implementation of Hyperledger. Hyperledger is a protocol
for creating and transferring assets on decentralised ledgers. It's designed to
be run in environments where the set of replicating nodes is known. All the
resources in the system are exposed through a hypermedia interface to allow for
loose coupling between parties, especially the clients.

This software is currently in beta so run at your own risk.

Prerequisites; Elixir v1.0.4, PostgreSQL, Node (npm)

To install the server:

1. Install dependencies with `mix deps.get`
2. Modify the `DATABASE_URL` environment variable in the `.env` file to
   reference your Postgres user
3. Create a database with `mix ecto.create`
4. Run the migrations with `mix ecto.migrate`
5. Run `npm install` to install tools for asset compilation
6. Start the server with `mix phoenix.server`

The server should now be running at `localhost:4000`.
