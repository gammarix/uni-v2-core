-include .env.local

build:
	forge build

test-all:
	forge test -vvvv

deploy-uni-v2-factory-kairos:
	forge create --rpc-url ${KAIROS_TESTNET_RPC_URL} --account ${WALLET_NAME} src/UniswapV2Factory.sol:UniswapV2Factory --constructor-args <insert_feeToSetter_address>

deploy-uni-v2-factory-kaia:
	forge create --rpc-url ${KAIA_MAINNET_RPC_URL} --account ${WALLET_NAME} src/UniswapV2Factory.sol:UniswapV2Factory --constructor-args <insert_feeToSetter_address>
