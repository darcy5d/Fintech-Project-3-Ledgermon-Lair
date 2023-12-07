// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Ledgermon is ERC721 {
    using Strings for uint256;
    uint256 private _nextTokenId = 1; //start at
    uint256 public cost = 0.00001 ether;
    string public uriSuffix = ".json";
    string public uriPrefix = "https://teal-key-jaguar-194.mypinata.cloud/ipfs/QmR5M9jA9mfFwmv18xdMvWcNhuXnRExYDsifGbLUZs2wYH/";
    constructor() ERC721("LedgermonLegends", "LL") {}
    struct PokemonAttributes {
        uint256 level;
        uint256 attack;
        uint256 defense;
        uint256 speed;
        uint256 tokenId;
    }
    // Set the base location of the token URI
    function setUriPrefix(string memory _uriPrefix) public {
        uriPrefix = _uriPrefix;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return uriPrefix;
        //return "https://teal-key-jaguar-194.mypinata.cloud/ipfs/QmSadmgBdqNMnUiD3LHJq5PZTeHnNfyFqdLTfdYyHUexAh/";
    }
    // Concatenate the baseURI + tokenID + .json
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        _requireOwned(tokenId);
        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string.concat(baseURI, tokenId.toString(), uriSuffix) : "";
    }
    // Buy a Ledgemon!
    function MINT() public payable {
        require(msg.value >= cost, "Insufficient funds!");
        uint256 tokenId = _nextTokenId++;
        _safeMint(msg.sender, tokenId);

    }
  function withdraw() public {
    // =============================================================================
    (bool hs1, ) = payable(0x0FF6d151Ed313Ad9Eb839Ab4aE80A28CbB60afc4).call{value: address(this).balance * 25 / 100}("");
    require(hs1);
    (bool hs2, ) = payable(0x1Fa036B51FB30d460F7F1Aa5Ca0C6aaC724920Af).call{value: address(this).balance * 25 / 100}("");
    require(hs2);
    (bool hs3, ) = payable(0x1Fa036B51FB30d460F7F1Aa5Ca0C6aaC724920Af).call{value: address(this).balance * 25 / 100}("");
    require(hs3);
    (bool hs4, ) = payable(0x1Fa036B51FB30d460F7F1Aa5Ca0C6aaC724920Af).call{value: address(this).balance * 25 / 100}("");
    require(hs4);
  }
}