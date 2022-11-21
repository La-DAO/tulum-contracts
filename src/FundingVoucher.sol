// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

/**
 * @title Funding Voucher
 * @author La DAO
 * @notice This contract contains the main functions for a Funding Voucher
 * represents investment in project and allows user to claim earnings
 */
import {Counters} from "https://github.com/iafhurtado/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol";
import {ERC3525Upgradeable} from "https://github.com/parseb/ERC3525/blob/main/contracts/ERC3525Upgradeable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract FundingVoucher {
    // Las variables
    using Counters for Counters.Counter;

    Counters.Counter private _voucherIdCounter;

    uint8 maxVoucherSupply;

    constructor(uint8 _maxVoucherSupply) ERC3525Upgradeable("Funding Voucher", "FUND") {
        maxVoucherSupply = _maxVoucherSupply;
    }

    function safeMint(address to, string memory uri) public onlyOwner { // ProjectEscrow address como admin
    require(_voucherIdCounter.current() < _maxVoucherSupply, "Funding voucher max supply has been reached");
    uint256 tokenId = _voucherIdCounter.current();
    _voucherIdCounter.increment();
    _mint(to, tokenId);
    _setTokenURI(tokenId, uri);
    }

    function setTokenURI(uint256 tokenId, string memory newURI) public {
    address tokenOwner  = ownerOf(tokenId);
    require(msg.sender == tokenOwner, "Caller is not the owner or an approved operator");
    _setTokenURI(tokenId, newURI);
    }

    function burn(uint256 tokenId_) external virtual {
    require(_msgSender() == ownerOf(tokenId_), "only owner");
    _burnVoucher(tokenId_);
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
