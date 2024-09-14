# Deployment

## Process
### Build the UniswapV2Factory contract
Use this command to build the contract
```bash
forge build src/UniswapV2Factory.sol --use 0.5.16
```

The original `UniswapV2Factory.sol` is set to Solidity version `0.5.16` which is why we have to manually build it.

#### Sample logs
```bash
forge build src/UniswapV2Factory.sol --use 0.5.16
[⠊] Compiling...
[⠢] Compiling 11 files with Solc 0.5.16
[⠆] Solc 0.5.16 finished in 154.19ms
Compiler run successful!
```

## Deploy to testnet
Create a `.env.local` file and add the following information in

```bash
KAIROS_TESTNET_RPC_URL=<insert_RPC_URL>
KAIA_MAINNET_RPC_URL=<insert_RPC_URL>
WALLET_NAME=<insert_foundry_wallet_name>
```

Make sure to replace the `<insert_RPC_URL>` with your RPC URL from a node provider.

Then use the `makefile` to deploy `UniswapV2Factory.sol` contract by running this command in the terminal

```bash
make deploy-uni-v2-factory-kairos
```

This will run the command `forge create --rpc-url ${KAIROS_TESTNET_RPC_URL} --account ${WALLET_NAME} src/UniswapV2Factory.sol:UniswapV2Factory --constructor-args <insert_feeToSetter_address>`

#### Sample logs
```bash
forge create --rpc-url ***** --account ***** src/UniswapV2Factory.sol:UniswapV2Factory --constructor-args *****
[⠊] Compiling...
No files changed, compilation skipped
Enter keystore password:
Deployer: *****
Deployed to: 0x82429c2D18d0B68D894DB26167DeACa904765BF2
Transaction hash: 0xaa9eb65edd2692f04210315be39762b869e8ea171d5ae572818fc2c699763bfb
```

## Deploy to mainnet
Create a `.env.local` file and add the following information in

```bash
KAIROS_TESTNET_RPC_URL=<insert_RPC_URL>
KAIA_MAINNET_RPC_URL=<insert_RPC_URL>
WALLET_NAME=<insert_foundry_wallet_name>
```

Make sure to replace the `<insert_RPC_URL>` with your RPC URL from a node provider.

Then use the `makefile` to deploy `UniswapV2Factory.sol` contract by running this command in the terminal

```bash
make deploy-uni-v2-factory-kaia
```

This will run the command `forge create --rpc-url ${KAIA_MAINNET_RPC_URL} --account ${WALLET_NAME} src/UniswapV2Factory.sol:UniswapV2Factory --constructor-args <insert_feeToSetter_address>`

