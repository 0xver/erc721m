# ERC721M

[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/0xver/erc721m/blob/master/LICENSE.md)

## Metadata and Merkle extension for ERC721A

Use this extension for an improved reveal system and merkle modifier. ERC721M is located at `contracts/bundle/721/ERC721M.sol`. There is an NFT template contract located at `contracts/NFT.sol`. The constructor contract located at `contracts/bundle/Constructor.sol` is where other standard implementations should be added such as ERC2981.

# Installation
Clone erc721m
```
gh repo clone 0xver/erc721m
```
Install packages
```
npm install
```

# Usage
```solidity
pragma solidity ^0.8.4;

import "./bundle/721/ERC721M.sol";

contract NFT is ERC721M {
    constructor() ERC721M("Non-Fungible Token", "NFT", "pr34v31/prereveal.json") {}

    function setRevealCID(string memory _cid, bool _isExtension) public ownership {
        _setRevealCID(_cid, _isExtension);
    }

    function mint(uint256 _quantity, bytes32[] calldata _merkleProof) public merkleProof(msg.sender, _merkleProof) {
        _mint(msg.sender, _quantity);
    }
}
```
