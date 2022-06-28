# ERC721M

[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/0xver/erc721m/blob/master/LICENSE.md)

## ERC721Metadata override for ERC721A

Use this extension for an improved reveal system. ERC721M is located at `contracts/ERC721M.sol`.

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
One of one NFT contract
```solidity
pragma solidity ^0.8.4;

import "./ERC721M.sol";

contract NFT is ERC721M {
    constructor() ERC721M("Non-Fungible Token", "NFT", "") {}

    function mint(string memory _cid) public {
        _overrideTokenCID(_nextTokenId(), _cid);
        _mint(msg.sender, 1);
    }
}
```
Collectible NFT contract
```solidity
pragma solidity ^0.8.4;

import "./ERC721M.sol";
import "./Ownership.sol";

contract NFT is ERC721M {
    constructor() ERC721M("Non-Fungible Token", "NFT", "pr34v31/prereveal.json") Ownership(msg.sender) {}

    function setRevealCID(string memory _cid, bool _isExtension) public ownership {
        _setRevealCID(_cid, _isExtension);
    }

    function reveal() public ownership {
        _reveal();
    }

    function mint(uint256 _quantity) public {
        _mint(msg.sender, _quantity);
    }
}
```