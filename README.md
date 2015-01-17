# Hyperledger Reference Implementation

This is the reference implementation of Hyperledger. Hyperledger is a protocol
for creating and transferring assets on decentralised ledgers. It's designed to
be run in environments where the set of replicating nodes is known. All the
resources in the system are exposed through a hypermedia interface to allow for
loose coupling between parties, especially the clients.

This software is currently in beta so run at your own risk.

To start the server:

1. Install dependencies with `mix deps.get`
2. Create a database with `mix ecto.create Hyperledger.Repo`
3. Run Migration with `mix ecto.migrate Hyperledger.Repo`
4. Start Hyperledger with `mix phoenix.start`

The endpoint is now running at `localhost:4000`.

## License

hyperledger Reference Server is released under the
[MIT License](http://www.opensource.org/licenses/MIT).
