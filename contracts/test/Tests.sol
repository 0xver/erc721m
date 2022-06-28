// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "./Constructor.sol";

/**
 * @title NFT test smart contract
 */
contract Tests is Constructor {
    /**
     * @dev Set reveal base CID
     */
    function setRevealCID(string memory _cid, bool _isExtension) public ownership {
        _setRevealCID(_cid, _isExtension);
    }

    /**
     * @dev Reveal token collection
     */
    function reveal() public ownership {
        _reveal();
    }

    /**
     * @dev Mint function for public
     */
    function mint(uint256 _quantity) public {
        _mint(msg.sender, _quantity);
    }

    /**
     * @dev Mint function for airdrop
     */
    function airdrop(address _to, uint256 _quantity) public ownership {
        _mint(_to, _quantity);
    }
}
