// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "./bundle/Constructor.sol";

/**
 * @title NFT smart contract
 */
contract NFT is Constructor {
    /**
     * @dev Set Merkle root
     */
    function setMerkleRoot(bytes32 _merkleRoot) public ownership {
        _setMerkleRoot(_merkleRoot);
    }

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
     * @dev Mint function for whitelist
     */
    function privateMint(uint256 _quantity, bytes32[] calldata _merkleProof) public merkleProof(msg.sender, _merkleProof) {
        _mint(msg.sender, _quantity);
    }

    /**
     * @dev Mint function for public
     */
    function publicMint(uint256 _quantity) public {
        _mint(msg.sender, _quantity);
    }

    /**
     * @dev Mint function for airdrop
     */
    function airdrop(address _to, uint256 _quantity) public ownership {
        _mint(_to, _quantity);
    }
}
