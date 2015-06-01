#!/bin/bash
export "DATABASE_URL=ecto://postgres:$HYPERLEDGER_ENV_POSTGRES_PASSWORD@$HYPERLEDGER_PORT_5432_TCP_ADDR/hl_dev"
sed -e "1s#.*#$DATABASE_URL#" .env > .tmp # using '#' as a delimiter for sed command
mv .tmp /hyperledger-server/.env

echo "running ecto create"
mix ecto.create

echo "----------------------"
echo "running ecto migrate"
mix ecto.migrate

echo "----------------------"
echo "running npm install"
npm install

echo "----------------------"
echo "running mix run"
mix run -y 'Hyperledger.Node.create(1, System.get_env("NODE_URL"), System.get_env("PUBLIC_KEY"))'

echo "----------------------"
echo "running phoenix server"
mix phoenix.server
