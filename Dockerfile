FROM waxteam/dev:wax-1.6.1-1.2.1 as eosio.contracts.v1.8.x
WORKDIR /app

# install dependencies
RUN apt-get update
RUN apt-get install -y wget git build-essential cmake --no-install-recommends
RUN rm -rf /var/lib/apt/lists/*

RUN git clone -b wax-1.7.0-2.0.2 https://github.com/worldwide-asset-exchange/wax-system-contracts.git
RUN cd wax-system-contracts && mkdir build && cd build && cmake .. && make


FROM waxteam/dev:wax-1.6.1-2.0.12
WORKDIR /app

# install dependencies
RUN apt-get update
RUN apt-get install -y wget git build-essential cmake --no-install-recommends
RUN rm -rf /var/lib/apt/lists/*

RUN echo "export PATH=~/wax-blockchain/bin:$PATH" >> ~/.bashrc

ENV TESTNET_EOSIO_PRIVATE_KEY 5KQPgxtxWqziZggdsYjgMkBcd8iHr96HPY2kr4CGLqA7eid4FCG
ENV TESTNET_EOSIO_PUBLIC_KEY EOS6SpGqFohbAHZHK3cDTT7oKyQedwXd4nZ6H6t9PKk2UN5hqNbna

COPY ./contracts ./contracts
COPY ./start.sh ./
COPY ./config.ini ./config/
COPY ./genesis.json ./
COPY --from=eosio.contracts.v1.8.x /app/wax-system-contracts/build/contracts ./eosio.contracts.v1.8.x

RUN chmod +x ./start.sh
CMD ["./start.sh"]