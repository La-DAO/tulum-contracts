// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.15;

import "../lib/forge-std/src/Test.sol";
import {RealEstateNFT} from "../src/ProductNFT.sol";

contract ContractTest is Test {
    RealEstateNFT realEstateNFT;
    address testMaster = address(0xb4c79daB8f259C7Aee6E5b2Aa729821864227e84);
    address firstBuyer = address(0x1);
    address secondBuyer = address(0x2);
    string tokenURI1 = "test_token_URI_1";
    string tokenURI2 = "test_token_URI_2";
    string tokenURI3 = "test_token_URI_3";

    function setUp() public {
        realEstateNFT = new RealEstateNFT(3);
    }

    function testSafeMintToken() public {
        realEstateNFT.safeMint(firstBuyer, tokenURI1);
        uint256 firstBuyerBalance = realEstateNFT.balanceOf(firstBuyer);
        assertEq(firstBuyerBalance, 1);
    }

    function testOnlyOwnerCanMint() public {
        vm.startPrank(firstBuyer);
        vm.expectRevert("Ownable: caller is not the owner");
        realEstateNFT.safeMint(firstBuyer, tokenURI1);
    }

    function testMaxSupplyLimit() public {
        realEstateNFT.safeMint(firstBuyer, tokenURI1);
        realEstateNFT.safeMint(secondBuyer, tokenURI2);
        realEstateNFT.safeMint(firstBuyer, tokenURI3);
        vm.expectRevert("NFT max supply has been reached");
        realEstateNFT.safeMint(secondBuyer, tokenURI1);
    }

    function testGetTokenURI() public {
        realEstateNFT.safeMint(firstBuyer, tokenURI1);
        realEstateNFT.safeMint(firstBuyer, tokenURI2);
        realEstateNFT.safeMint(secondBuyer, tokenURI3);
        string memory mintedTokenURI1 = realEstateNFT.tokenURI(0);
        string memory mintedTokenURI2 = realEstateNFT.tokenURI(1);
        string memory mintedTokenURI3 = realEstateNFT.tokenURI(2);
        assertEq(mintedTokenURI1, tokenURI1);
        assertEq(mintedTokenURI2, tokenURI2);
        assertEq(mintedTokenURI3, tokenURI3);
    }

    function testSetTokenURI() public {
        realEstateNFT.safeMint(firstBuyer, tokenURI1);
        vm.startPrank(firstBuyer);
        realEstateNFT.setTokenURI(0, tokenURI2);
        string memory mintedTokenURI = realEstateNFT.tokenURI(0);
        assertFalse(keccak256(bytes(mintedTokenURI)) == keccak256(bytes(tokenURI1)));
    }

    function testOnlyNftOwnerCanSetTokenURI() public {
        realEstateNFT.safeMint(firstBuyer, tokenURI1);
        vm.startPrank(secondBuyer);
        vm.expectRevert("Caller is not the owner or an approved operator");
        realEstateNFT.setTokenURI(0, tokenURI2);
    }
}