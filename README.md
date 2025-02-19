## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```
### .env Sample
```
ETH_SEPOLIA_RPC_URL=<ETH_SEPOLIA_RPC_URL>
ETH_MAINNET_RPC_URL=<ETH_MAINNET_RPC_URL>
ETH_SEPOLIA_PRIVATE_KEY=<ETH_SEPOLIA_PRIVATE_KEY>
ETHERSCAN_API_KEY=<ETHERSCAN_API_KEY>
```

### Installation
```shell
$ forge install foundry-rs/forge-std@v1.9.6 --no-commit
$ forge install smartcontractkit/chainlink-brownie-contracts@v1.3.0 --no-commit
$ forge install Cyfrin/foundry-devops@0.3.2 --no-commit
```

### Deploy

```shell
$ source .env
$ forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $ETH_SEPOLIA_RPC_URL --private-key $ETH_SEPOLIA_PRIVATE_KEY --broadcast -vvvv
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
