-include .env

build:; forge build

conduct-test:; forge test

check-coverage:; forge coverage

deploy-sepolia:
	forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(ETH_SEPOLIA_RPC_URL) --private-key $(ETH_SEPOLIA_PRIVATE_KEY) --broadcast --resume --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv