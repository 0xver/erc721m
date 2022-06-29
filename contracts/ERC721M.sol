// SPDX-License-Identifier: MIT
// ERC721M v0.2.1

pragma solidity ^0.8.4;

import "erc721a/contracts/ERC721A.sol";

/**
 * @dev ERC721Metadata override for ERC721A
 * @author Sam Larsen (0xver.io)
 */
contract ERC721M is ERC721A {
    // Mapping token ID to token CID
    mapping(uint256 => string) private _tokenCid;

    // Mapping token ID to override boolean
    mapping(uint256 => bool) private _overrideCid;

    // Name string variable
    string private _name;

    // Symbol string variable
    string private _symbol;

    // Reveal CID metadata variable
    string private _revealCid;

    // Fallback CID string variable
    string private _fallbackCid;

    // Revealed boolean
    bool private _isRevealed;

    // Set CID for reveal boolean
    bool private _setCID;

    // Has json extension boolean
    bool private _jsonExtension;

    /**
     * @dev Reconstructs ERC721Metadata from ERC721A
     */
    constructor(string memory name_, string memory symbol_, string memory fallbackCid_) ERC721A("", "") {
        _name = name_;
        _symbol = symbol_;
        _fallbackCid = fallbackCid_;
        _isRevealed = false;
        _setCID = false;
    }

    /**
     * @dev Name of contract
     */
    function name() public view virtual override(ERC721A) returns (string memory) {
        return _name;
    }

    /**
     * @dev Symbol of contract
     */
    function symbol() public view virtual override(ERC721A) returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns string for tokenId
     */
    function tokenURI(uint256 _tokenId) public view virtual override(ERC721A) returns (string memory) {
        if (!_exists(_tokenId)) {
            return "Token does not exist";
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

    /**
     * @dev Token reveal path
     */
    function _revealURI(uint256 _tokenId) internal view returns (string memory) {
        if (_jsonExtension == true) {
            return string(abi.encodePacked(_ipfs(), _revealCid, "/", _toString(_tokenId), ".json"));
        } else {
            return string(abi.encodePacked(_ipfs(), _revealCid, "/", _toString(_tokenId)));
        }
    }

    /**
     * @dev _ipfs used in place of _baseURI
     */
    function _ipfs() internal pure returns (string memory) {
        return "ipfs://";
    }

    /**
     * @dev Custom token CID for one of one minting
     */
    function _overrideTokenCID(uint256 _tokenId, string memory _cid) internal {
        _tokenCid[_tokenId] = _cid;
        _overrideCid[_tokenId] = true;
    }

    /**
     * @dev Sets the reveal CID
     */
    function _setRevealCID(string memory _cid, bool _isExtension) internal {
        require(_isRevealed == false, "ERC721M: tokens revealed");
        _revealCid = _cid;
        _jsonExtension = _isExtension;
        _setCID = true;
    }

    /**
     * @dev Checks if tokens look correct after setting reveal CID
     */
    function _checkURI(uint256 _tokenId) public view returns (string memory) {
        if (!_exists(_tokenId)) {
            return "Token does not exist";
        } else if (_revealed() == true) {
            return "Tokens have been revealed";
        } else {
            return _revealURI(_tokenId);
        }
    }

    /**
     * @dev Locks the reveal CID in place
     */
    function _reveal() internal {
        require(_setCID == true, "ERC721M: reveal CID not set");
        _isRevealed = true;
    }

    /**
     * @dev Returns `true` if tokens are revealed
     */
    function _revealed() internal view returns (bool) {
        return _isRevealed;
    }
}
