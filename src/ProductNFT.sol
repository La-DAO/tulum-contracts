// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.15;

/**
 * @title ProjectProductNFT
 * @author La DAO
 * @notice This contract contains the main functions for a Product NFT
 */

import {ERC721} from "../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {ERC721URIStorage} from "../lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {Counters} from "../lib/openzeppelin-contracts/contracts/utils/Counters.sol";
import {Ownable} from "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract ProductNFT is ERC721, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    // Token name
    string private _name;
    // Token symbol
    string private _symbol;
    uint256 maxSupply;

    constructor(string memory name_, string memory symbol_, uint8 _maxSupply) ERC721("Product NFT", "PRDNFT") {
        _name = name_;
        _symbol = symbol_;
        maxSupply = _maxSupply;
    }

    // Safe mint is called by ProjectEscrow contract and NFT is owned by ProjectEscrow?
    function safeMint(address to, string memory uri) public onlyOwner { // ProjectEscrow address como admin
        require(_tokenIdCounter.current() < maxSupply, "NFT max supply has been reached");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    function setTokenURI(uint256 tokenId, string memory newURI) public {
        address tokenOwner  = ownerOf(tokenId);
        require(msg.sender == tokenOwner, "Caller is not the owner or an approved operator");
        _setTokenURI(tokenId, newURI);
    }

    function _burn(uint256 tokenId) internal onlyOwner override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}