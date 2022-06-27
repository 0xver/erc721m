// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "erc721a/contracts/ERC721A.sol";
import "../../library/utils.sol";

/**
 * @dev Metadata and merckle implementation for ERC721A
 */
contract ERC721M is ERC721A {
    mapping(uint256 => string) private _tokenCid;
    mapping(uint256 => bool) private _overrideCid;

    string private _name;
    string private _symbol;
    string private _metadata;
    string private _fallbackCid;

    bool private _isRevealed;
    bool private _setURI;
    bool private _jsonExtension;

    bytes32 private root;

    constructor(string memory name_, string memory symbol_, string memory fallbackCid_) ERC721A("", "") {
        _name = name_;
        _symbol = symbol_;
        _fallbackCid = fallbackCid_;
        _isRevealed = false;
        _setURI = false;
    }

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function _setMerkleRoot(bytes32 _root) internal {
        root = _root;
    }

    function merkleRoot() internal view returns (bytes32) {
        return root;
    }

    modifier merkleProof(address _to, bytes32[] calldata _merkleProof) {
        bytes32 leaf = keccak256(abi.encodePacked(_to));
        require(utils.verify(_merkleProof, merkleRoot(), leaf), "ERC721M: invalid merkle proof");
        _;
    }

    function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
        if (!_exists(_tokenId)) {
            return "Token ID out of range";
        } else if (_overrideCid[_tokenId] == true) {
            return string(abi.encodePacked(_ipfs(), _tokenCid[_tokenId]));
        } else {
            if (_isRevealed == true) {
                return _revealURI(_tokenId);
            } else {
                return string(abi.encodePacked(_ipfs(), _fallbackCid));
            }
        }
    }

    function _revealURI(uint256 _tokenId) internal view returns (string memory) {
        if (_jsonExtension == true) {
            return string(abi.encodePacked(_ipfs(), _metadata, "/", utils.toString(_tokenId), ".json"));
        } else {
            return string(abi.encodePacked(_ipfs(), _metadata, "/", utils.toString(_tokenId)));
        }
    }

    function _ipfs() internal pure returns (string memory) {
        return "ipfs://";
    }

    function _overrideTokenURI(uint256 _tokenId, string memory _cid) internal {
        _tokenCid[_tokenId] = _cid;
        _overrideCid[_tokenId] = true;
    }

    function _setRevealCID(string memory _cid, bool _isExtension) internal {
        require(_isRevealed == false, "ERC721M: reveal has already occured");
        _metadata = _cid;
        _jsonExtension = _isExtension;
        _setURI = true;
    }

    function checkURI(uint256 _tokenId) public view returns (string memory) {
        if (!_exists(_tokenId)) {
            return "Token ID out of range";
        } else if (_revealed() == true) {
            return "Tokens have been revealed";
        } else {
            return _revealURI(_tokenId);
        }
    }

    function _reveal() internal {
        require(_setURI == true, "ERC721M: reveal URI not set");
        _isRevealed = true;
    }

    function _revealed() internal view returns (bool) {
        return _isRevealed;
    }
}
