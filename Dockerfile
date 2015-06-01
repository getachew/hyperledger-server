FROM dockersrock/hldevtools

WORKDIR /hyperledger-server
ADD . /hyperledger-server
RUN /usr/local/bin/mix local.hex --force && \
    /usr/local/bin/mix local.rebar --force

# install dependencies
RUN mix deps.get
CMD ["/hyperledger-server/start.sh"]
