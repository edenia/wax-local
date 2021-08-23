#!/usr/bin/env bash

unlock_wallet() {
  cleos wallet unlock --password $(cat eosio.pwd) || echo ""
  sleep 1
}

lock_wallet() {
  cleos wallet lock
  sleep 1
}

genesis() {
  echo "====================================== Start genesis ======================================"
  sed -i "s/TESTNET_EOSIO_PUBLIC_KEY/$TESTNET_EOSIO_PUBLIC_KEY/" genesis.json
  nodeos \
  --config-dir config \
  --data-dir data \
  --blocks-dir blocks \
  --delete-all-blocks \
  --genesis-json genesis.json \
  >> "nodeos.log" 2>&1 &

  while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' localhost:8888/v1/chain/get_info)" != "200" ]]; 
  do
    sleep 1
  done
  echo "====================================== Done genesis ======================================"
}

setup_wallet () {
  cleos wallet create -f eosio.pwd
  cleos wallet import --private-key $TESTNET_EOSIO_PRIVATE_KEY
  lock_wallet
}

setup_accounts() {
  echo "====================================== Start setup_accounts ======================================"
  unlock_wallet
  accounts=( \
    "eosio.bpay" \
    "eosio.msig" \
    "eosio.names" \
    "eosio.ram" \
    "eosio.ramfee" \
    "eosio.saving" \
    "eosio.stake" \
    "eosio.token" \
    "eosio.vpay" \
    "eosio.rex" \
  )

  for account in "${accounts[@]}"; do
    cleos create account eosio $account $TESTNET_EOSIO_PUBLIC_KEY
  done
  lock_wallet
  echo "====================================== Done setup_accounts ======================================"
}

setup_contracts() {
  echo "====================================== Start setup_contracts ======================================"
  unlock_wallet

  curl --request POST \
    --url http://127.0.0.1:8888/v1/producer/schedule_protocol_feature_activations \
    -d '{"protocol_features_to_activate": ["0ec7e080177b2c02b278d5088611686b49d739925a92d9bfcacd7fc6b74053bd"]}' \
    && echo -e "\n"
  sleep 1

  # Deploy system contract
  cleos set code eosio ./eosio.contracts.v1.8.x/eosio.system/eosio.system.wasm
  sleep 1
  cleos set abi eosio ./eosio.contracts.v1.8.x/eosio.system/eosio.system.abi
  sleep 1

  # Deploy eosio.token and eosio.msig contracts
  cleos set contract eosio.token ./eosio.contracts.v1.8.x/eosio.token/
  cleos set contract eosio.msig ./eosio.contracts.v1.8.x/eosio.msig/

  cleos push action eosio setpriv '["eosio.msig", 1]' -p eosio@active

  cleos push action eosio.token create '[ "eosio", "10000000000.0000 WAX" ]' -p eosio.token@active
  cleos push action eosio.token issue '[ "eosio", "1000000000.0000 WAX", "memo" ]' -p eosio@active
  cleos push action eosio init '["0", "4,WAX"]' -p eosio@active

  lock_wallet
  echo "====================================== Done setup_contracts ======================================"
}

start() {
  echo "====================================== Start ======================================"
  nodeos \
  --config-dir config \
  --data-dir data \
  --blocks-dir blocks \
  >> "nodeos.log" 2>&1 &
  sleep 10;

  if [ -z "$(pidof nodeos)" ]; then
    echo "====================================== Start hard replay ======================================"
    nodeos \
    --config-dir config \
    --data-dir data \
    --blocks-dir blocks \
    --hard-replay-blockchain \
    >> "nodeos.log" 2>&1 & \
  fi
}

logs() {
  tail -n 100 -f nodeos.log
}

if [ ! -f inited ]; then
  genesis
  setup_wallet
  setup_accounts
  setup_contracts
  touch inited
else
  start
fi

logs