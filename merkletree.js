const { MerkleTree } = require('merkletreejs');
const keccak256 = require('keccak256');

let whitelistAddresses = [
    "0x48F528cE86BEc210bc5D1A5e0cd6d60eEA801a8D",
    "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4",
    "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2",
    "0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB",
    "0X09BAAB19FC77C19898140DADD30C4685C597620B",
    "0XCC4C29997177253376528C05D3DF91CF2D69061A",
    "0xdD870fA1b7C4700F2BD7f44238821C26f7392148" // The address in remix
  ];
const leafNodes = whitelistAddresses.map(addr => keccak256(addr));
const merkleTree = new MerkleTree(leafNodes, keccak256, { sortPairs: true});
const rootHash = merkleTree.getRoot();
console.log('Whitelist Merkle Tree\n', merkleTree.toString());
console.log("Root Hash: ", rootHash);
const claimingAddress = leafNodes[1];
const hexProof = merkleTree.getHexProof(claimingAddress);
console.log(hexProof);
console.log(merkleTree.verify(hexProof, claimingAddress, rootHash));