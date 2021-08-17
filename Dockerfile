FROM eosio/eosio:release_2.0.x as eosio.old.contracts
WORKDIR /app

# install dependencies
RUN apt-get update
RUN apt-get install -y wget git build-essential cmake --no-install-recommends
RUN rm -rf /var/lib/apt/lists/*

# install eosio.cdt 1.6.3
RUN wget https://github.com/eosio/eosio.cdt/releases/download/v1.6.3/eosio.cdt_1.6.3-1-ubuntu-18.04_amd64.deb
RUN apt install ./eosio.cdt_1.6.3-1-ubuntu-18.04_amd64.deb

# build contracts release/1.8.x
RUN git clone -b release/1.8.x https://github.com/EOSIO/eosio.contracts.git
RUN cd /app/eosio.contracts && ./build.sh -c /usr/local/eosio.cdt


FROM eosio/eosio:release_2.0.x as eosio.contracts
WORKDIR /app

# install dependencies
RUN apt-get update
RUN apt-get install -y wget git build-essential cmake --no-install-recommends
RUN rm -rf /var/lib/apt/lists/*

# install eosio.cdt 1.7.0
RUN wget https://github.com/eosio/eosio.cdt/releases/download/v1.7.0/eosio.cdt_1.7.0-1-ubuntu-18.04_amd64.deb
RUN apt install ./eosio.cdt_1.7.0-1-ubuntu-18.04_amd64.deb

# build contracts releases/1.9.x
RUN git clone -b release/1.9.x https://github.com/EOSIO/eosio.contracts.git
RUN cd /app/eosio.contracts && ./build.sh -c /usr/local/eosio.cdt


FROM ubuntu:18.04 as wax
WORKDIR /app

# install dependencies
RUN apt-get update
RUN apt-get install -y \
    wget \
    git \
    build-essential \
    cmake --no-install-recommends \
    python3.8 \
    g++ \
    python3-pip \
    openssl \
    curl \
    jq \
    psmisc \
    automake \
    libbz2-dev \
    libssl-dev \
    doxygen \
    graphviz \
    libgmp3-dev \
    libicu-dev \
    python3-dev \
    python2.7 \
    python2.7-dev \
    libtool \
    zlib1g-dev \
    sudo \
    ruby \
    libusb-1.0-0-dev \
    libcurl4-gnutls-dev \
    pkg-config \
    clang \
    llvm-7-dev

RUN rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/worldwide-asset-exchange/wax-blockchain.git
RUN cd wax-blockchain && git submodule update --init --recursive

RUN cd wax-blockchain && ./wax_build.sh -i ~/wax-blockchain
RUN cd wax-blockchain && ./wax_install.sh

COPY --from=eosio.old.contracts /app/eosio.contracts/build/contracts ./eosio.old.contracts
COPY --from=eosio.contracts /app/eosio.contracts/build/contracts ./eosio.contracts