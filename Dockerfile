FROM hldevtools 

WORKDIR /hyperledger-server
ADD . /hyperledger-server

# install dependencies
RUN ["expect", "mix_deps_script"]
CMD ["/hyperledger-server/start.sh"]
