// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

/**
 * @title ERC165 standard
 */
interface ERC165 {
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}