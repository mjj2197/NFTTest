Mint App

### About the Project

    This is ERC721 NFT mint project that only allows certain users.

### Setting up Local Development

    Required:
    	Node ^v14
    	Git
    Local Setup Steps:
    	git clone https://github.com/mjj2197/NFTTest.git
    	Install dependencies: npm install
    	Installs Hardhat & OpenZepplin dependencies
    	Compile Solidity: npm run compile

### Contracts & Addresses

    Testnet Addresses
    	- Network: Rinkeby (4)
    		NFT: 0x9606debE23e2cbFA76321f8257dF5609a43085bc

### How to do unit test

    npx hardhat node (in indivitual terminal window)
    npx hardhat compile
    npx hardhat test

### How to do unit test

    npx hardhat run scripts/deploy.js --network NetworkName(ex: rinkeby)

    npx hardhat verify --network NetworkName(ex: rinkeby) _baseMetadataURI allowedMinters _startTime _endTime
        Params:
            _baseMetadataURI: base uri
            allowedMinters: array of minters
            _startTime: timestamp of start time
            _endTime: timestamp of end time
