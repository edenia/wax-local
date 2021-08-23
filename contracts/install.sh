atomicassets() {
    git clone https://github.com/pinknetworkx/atomicassets-contract.git
    cd atomicassets-contract
    eosio-cpp -abigen -I include -R resource -contract atomicassets -o atomicassets.wasm src/atomicassets.cpp
}

atomicassets