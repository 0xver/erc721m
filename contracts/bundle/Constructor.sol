// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "./173/Ownership.sol";
import "./721/ERC721M.sol";
import "../erc/165/ERC165.sol";
import "../erc/721/ERC721.sol";
import "../erc/721/extensions/ERC721Metadata.sol";
import "../erc/721/receiver/ERC721Receiver.sol";

/**
 * @dev NFT constructor contract
 */
contract Constructor is ERC721M, Ownership {
    receive() external payable {}
    fallback() external payable {}

    event Withdraw(address operator, address receiver, uint256 value);

    constructor() ERC721M("Non-Fungible Token", "NFT", "pr34v31/prereveal.json") Ownership(msg.sender) {}

    function withdraw(address _account) public ownership {
        uint256 balance = address(this).balance;
        (bool success, ) = payable(_account).call{value: address(this).balance}("");
        require(success, "Ether transfer failed");
        emit Withdraw(msg.sender, _account, balance);
    }

    function supportsInterface(bytes4 interfaceId) public pure override(ERC721A) returns (bool) {
        return
            interfaceId == type(ERC165).interfaceId ||
            interfaceId == type(ERC173).interfaceId ||
            interfaceId == type(ERC721).interfaceId ||
            interfaceId == type(ERC721Metadata).interfaceId ||
            interfaceId == type(ERC721Receiver).interfaceId;
    }
}
