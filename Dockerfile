FROM ubuntu:latest

# get required tools and link
RUN apt-get update -y && apt-get install -y wget git nodejs npm postgresql-client
RUN sudo ln -s /usr/bin/nodejs /usr/bin/node

# get elixir stuff
RUN wget http://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb
RUN apt-get update -y  && apt-get install -y elixir
RUN mix local.hex --force

WORKDIR /hyperledger-server
ADD . /hyperledger-server

# set environment variable via .env file
RUN export "DATABASE_URL=ecto://postgres:$HYPERLEDGER_ENV_POSTGRES_PASSWORD@$HYPERLEDGER_PORT_5432_TCP_ADDR/hl_dev"
RUN sed -e "1s#.*#$DATABASE_URL#" .env > .tmp # using '#' as a delimiter for sed command
RUN mv .tmp .env

# install dependencies
RUN mix deps.get
RUN yes|mix ecto.create
RUN mix ecto.migrate
RUN npm install
RUN mix run -y 'Hyperledger.Node.create(1, System.get_env("NODE_URL"), System.get_env("PUBLIC_KEY"))'

#run
CMD ["mix", "phoenix.server"]
