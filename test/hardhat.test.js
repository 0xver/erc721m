const { expect } = require("chai")
const { ethers } = require("hardhat")
const { MerkleTree } = require("merkletreejs")
const keccak256 = require("keccak256")
const whitelist = require("./whitelist.json")

/**
 * @dev Merkle tree functions
 */
 function merkle(whitelist) {
  const leafNodes = whitelist.map(addr => keccak256(addr))
  const merkleTree = new MerkleTree(leafNodes, keccak256, {sortPairs: true})
  const rootHash = merkleTree.getRoot()
  const root = "0x" + rootHash.toString("hex")
  return [merkleTree, root]
}

function proof(whitelist, addr) {
  var whitelistAddress = keccak256(addr.address)
  var merkleProof = merkle(whitelist)[0].getHexProof(whitelistAddress)
  return merkleProof
}

/**
 * @dev Tests NFT functions
 */
describe("", function () {
  it("NFT functions", async function () {
    /**
     * @dev Contract deployments
     */

    // Gets owner address and second address
    const [addr1, addr2, addr3] = await ethers.getSigners()

    // Deploys tokens
    var Token
    Token = await ethers.getContractFactory("NFT")
    const NFT = await Token.deploy()

    /**
     * @dev NFT function tests
     */

    // Should return name and symbol
    expect(await NFT.name()).equal("Non-Fungible Token")
    expect(await NFT.symbol()).equal("NFT")

    // Token balance for addr1 should equal 0
    expect(await NFT.balanceOf(addr1.address)).equal(0)

    // Mint with addr2
    await NFT.connect(addr2).publicMint(1)

    // Token balance for addr2 should equal 0
    expect(await NFT.balanceOf(addr2.address)).equal(1)

    // Token owner of ID 0 should be addr2
    expect(await NFT.ownerOf(0)).equal(addr2.address)

    // Set merkle root
    await NFT.setMerkleRoot(merkle(whitelist)[1])

    // Mint with addr1
    await NFT.connect(addr1).privateMint(1, proof(whitelist, addr1))

    // Token balance for addr1 should equal 1
    expect(await NFT.balanceOf(addr1.address)).equal(1)

    // Token owner of ID 1 should be addr1
    expect(await NFT.ownerOf(1)).equal(addr1.address)

    // Token URI should be prereveal
    expect(await NFT.tokenURI(0)).equal("ipfs://pr34v31/prereveal.json")
    expect(await NFT.tokenURI(1)).equal("ipfs://pr34v31/prereveal.json")
    expect(await NFT.tokenURI(2)).equal("Token does not exist")

    // Set reveal CID
    await NFT.setRevealCID("r3v34l", false)

    // Check reveal URI
    expect(await NFT.checkURI(0)).equal("ipfs://r3v34l/0")
    expect(await NFT.checkURI(1)).equal("ipfs://r3v34l/1")
    expect(await NFT.checkURI(2)).equal("Token does not exist")

    // Reveal tokens
    await NFT.connect(addr1).reveal()

    // Stop check
    expect(await NFT.checkURI(0)).equal("Tokens have been revealed")

    // Token URI should return correct identifier
    expect(await NFT.tokenURI(0)).equal("ipfs://r3v34l/0")
    expect(await NFT.tokenURI(1)).equal("ipfs://r3v34l/1")
    expect(await NFT.tokenURI(2)).equal("Token does not exist")

    // Transfer token ID 1 from addr2 to addr3
    await NFT.connect(addr2).transferFrom(addr2.address, addr3.address, 0)

    // Token owner of ID 1 should be addr2
    expect(await NFT.ownerOf(0)).equal(addr3.address)

    // Token balance for addr3 should equal 2
    expect(await NFT.balanceOf(addr3.address)).equal(1)

    // Approve addr1 to spend addr3 tokens
    await NFT.connect(addr3).approve(addr1.address, 0)

    // Spend addr3 tokens with addr1
    await NFT.connect(addr1).transferFrom(addr3.address, addr1.address, 0)

    // Test airdrop
    await NFT.airdrop(addr1.address, 1)
  })
})

/**
 * @dev Checks supports interface for NFT
 */
describe("", function () {
  it("Supports interface for NFT", async function () {
    /**
     * @dev Contract deployments
     */

    // Deploys tokens
    var Token
    Token = await ethers.getContractFactory("NFT")
    const NFT = await Token.deploy()

    /**
     * @dev Check for supports interface
     */

    // ERC165 support should return true
    expect(await NFT.supportsInterface(ethers.utils.hexlify(0x01ffc9a7))).equal(true)

    // ERC173 support should return true
    expect(await NFT.supportsInterface(ethers.utils.hexlify(0x7f5828d0))).equal(true)

    // ERC721 support should return true
    expect(await NFT.supportsInterface(ethers.utils.hexlify(0x80ac58cd))).equal(true)

    // ERC721Metadata support should return true
    expect(await NFT.supportsInterface(ethers.utils.hexlify(0x5b5e139f))).equal(true)

    // ERC721Receiver support should return true
    expect(await NFT.supportsInterface(ethers.utils.hexlify(0x150b7a02))).equal(true)
  })
})
