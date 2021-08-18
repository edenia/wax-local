FROM waxteam/production:v2.0.5wax01 as blockchain
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


# RUN git clone https://github.com/worldwide-asset-exchange/wax-blockchain.git
# RUN cd wax-blockchain && git submodule update --init --recursive

# RUN cd wax-blockchain && ./wax_build.sh -i ~/wax-blockchain && ./wax_install.sh

# RUN "export PATH=~/wax-blockchain/bin:$PATH" >> ~/.bashrc && source ~/.bashrc

RUN git clone --recursive https://github.com/worldwide-asset-exchange/wax-cdt.git
RUN cd wax-cdt && ./build.sh && sudo ./install.sh

ENV TESTNET_EOSIO_PRIVATE_KEY 5KQPgxtxWqziZggdsYjgMkBcd8iHr96HPY2kr4CGLqA7eid4FCG
ENV TESTNET_EOSIO_PUBLIC_KEY EOS6SpGqFohbAHZHK3cDTT7oKyQedwXd4nZ6H6t9PKk2UN5hqNbna

COPY ./start.sh ./
COPY ./config.ini ./config/
COPY ./genesis.json ./

RUN chmod +x ./start.sh
CMD ["./start.sh"]