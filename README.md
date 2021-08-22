<p align="center">
	<a href="#">
		<img src="https://img.shields.io/dub/l/vibe-d.svg" alt="MIT">
	</a>
</p>

# WAX Local Network

## Description
WAX Local provides a quick way to setup an WAX Local Network for development.

The primary benefits of containers are consistency across different environments and deployment ease.

This project works along with a [full-stack-boilerplate](https://github.com/eoscostarica/full-stack-boilerplate) to help you build your EOS dApp.

### Why to use a local environment?
Having a local environment provides a series of benefits that you cannot in a public network, for example, with WAX locally, transaction costs are avoided since they are carried out in a development environment and not in production, also, they are accessed to system contracts to modify them as appropriate.

In a Blockchain network every transaction creates an immutable record and everything that is modified can affect both positively and negatively the users within it, for this reason is essential to have an environment premises where functionality tests, performance tests, stress tests, among others, can be carried out without the risk of producing a failure that affects users.

Finally, a factor to consider is the time that is reduced in the initial configuration of any network, this image allows directly, with only two commands to have the network installed and ready to perform functionality tests as necessary.

### Contracts
The WAX image is based on the `eosio.system`, `eosio.token` and `eosio.msig` contracts for its configuration. Your code can be found at [this link](https://github.com/worldwide-asset-exchange/wax-system-contracts).
1. **eosio.system**: Defines the structures and actions needed for blockchain's core functionality.
2. **eosio.token**: Defines the structures and actions that allow users to create, issue, and manage tokens for EOSIO-based blockchains.
3. **eosio.msig**: Allows the creation of proposed transactions that require authorization from a list of accounts.

### Deployable projects
As WAX Local Network is based on EOSIO protocol with some little changes, some already smart contract production projects can be deployed on our local network due to the local dev environment setup. Some of them are:
1. simpleassets: A simple standard for digital assets on EOSIO blockchains: Non-Fungible Tokens (NFTs), Fungible Tokens (FTs), and Non-Transferable Tokens (NTTs). Take a look at the smart contract code [here](https://github.com/CryptoLions/SimpleAssets).
2. atomicassets: AtomicAssets is a Non Fungible Token (NFT) standard for eosio blockchains developed by pink.network. Take a look at the smart contract code [here](https://github.com/pinknetworkx/atomicassets-contract).
3. dgoods: dGoods is an open source and free standard for handling the virtual representation of items, both digital and physical, on the EOS blockchain led by Mythical Games. Take a look at the smart contract code [here](https://github.com/MythicalGames/dgoods).

### Configuration key
The preconfigured key to setup the genesis node is passed throw Dockerfile using the --build-arg option, so make sure to create a start key and save it to continue using the local dev environment with full access.

To create a key, you can use `cleos create key --to-console`:

```
Private key: 5KQPgxtxWqziZggdsYjgMkBcd8iHr96HPY2kr4CGLqA7eid4FCG
Public key: EOS6SpGqFohbAHZHK3cDTT7oKyQedwXd4nZ6H6t9PKk2UN5hqNbna
```

### Prerequisites
- [Git](https://git-scm.com/)
- [Node.js](https://nodejs.org/en/)
- [Docker](https://www.docker.com/)
- [Eosio](https://developers.eos.io/welcome/latest/getting-started-guide/local-development-environment/index)

## Quick start
- Download the Docker image `docker pull eoscostarica506/wax-local`
- Run the Docker image `docker run -dp 8888:8888 eoscostarica506/wax-local`
- Run the command `cleos get info` or check the link in the browser `http://127.0.0.1:8888/v1/chain/get_info`

If you run the command `cleos get info` or go to` http://127.0.0.1:8888/v1/chain/` and get information like the following it is because you already have the environment ready to work.

```
{
  "server_version": "183c000e",
  "chain_id": "856de91bed1633c1e6e65eb397da4fc98a0b65afc0f658b01cfda35190f16d55",
  "head_block_num": 22,
  "last_irreversible_block_num": 21,
  "last_irreversible_block_id": "000000158e055bca1fcdc7cff8f6344f1e9d8cf580ddf29e82a6e17f89cb96bd",
  "head_block_id": "00000016c706c238db4d2514c486b5be4cf25f54ef25094cac4df4a7c7096201",
  "head_block_time": "2021-08-22T08:35:06.500",
  "head_block_producer": "eosio",
  "virtual_block_cpu_limit": 204238,
  "virtual_block_net_limit": 1070828,
  "block_cpu_limit": 199900,
  "block_net_limit": 1048576,
  "server_version_string": "v2.0.12wax01",
  "fork_db_head_block_num": 22,
  "fork_db_head_block_id": "00000016c706c238db4d2514c486b5be4cf25f54ef25094cac4df4a7c7096201",
  "server_full_version_string": "v2.0.12wax01-183c000ee30ce9700aec1b5875d2a0a51516ac14"
}
```

**Note:** As the docker image were pulled from `eoscostarica506`, the eosio account keys are:

```
Private key: 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3
Public key: EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
```

## Instructions for creating WAX Local Network image locally
To create the Docker image locally, you must run the following commands:
- Clone the local Eos repository `https://github.com/eoscostarica/wax-local`
- Enter to the cloned repository folder `cd <path/wax-local>`
- Build the Dockerfile image with env variables `docker build -t wax-local --build-arg testnet_eosio_public_key="<public_key>" --build-arg testnet_eosio_private_key="<private_key>" .`
- Run the Dockerfile image `docker run -dp 8888:8888 wax-local`
- Run the command `cleos get info` or check next browser link `http://127.0.0.1:8888/v1/chain/get_info`

By this point, you already have the WAX Local Network image running locally.

## File structure
```text title="./wax-local"
/
├── .github
│   └── workflows
│       └── publish-docker-image.yml
├── config.ini ............... Nodeos configuration file
├── Dockerfile ............... Contains instructions for building the WAX Local Network image
├── genesis.json ............. Specifies the network genesis node parameters
├── LICENSE .................. Terms and Conditions
├── README.md ................ Repository specification
└── start.sh ................. Instructions for configuring contracts and usage characteristics
```

## License
MIT © [EOS Costa Rica](https://eoscostarica.io/)

## Contributing
If you want to contribute to this repository, please follow the steps below:

1. Fork the project
2. Create a new branch (`git checkout -b feat/sometodo`)
3. Commit changes (`git commit -m '<type>(<scope>): <subject>'`)
4. Push the commit (`git push origin feat/sometodo`)
5. Open a Pull Request

Read the EOS Costa Rica open source [contribution guidelines](https://guide.eoscostarica.io/docs/open-source-guidelines/) for more information on scheduling conventions.

If you find any bugs, please report them by opening an issue at [this link](https://github.com/eoscostarica/wax-local/issues).


## What is EOSIO?
EOSIO is a highly performant open-source blockchain platform, built to support and operate safe, compliant, and predictable digital infrastructures.

## About EOS Costa Rica
<br>
<center>
<img src="https://raw.githubusercontent.com/eoscostarica/design-assets/master/logos/eosCR/fullColor-horizontal-transparent-white.png" width="400" >
</center>
<br>

EOS Costa Rica is an independently-owned, self-funded, bare-metal Genesis block producer that provides stable and secure infrastructure for EOSIO blockchains. We support open source software for our community while offering enterprise solutions and custom smart contract development for our clients.

[eoscostarica.io](https://eoscostarica.io/)