// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.15;

import "../lib/forge-std/src/Test.sol";
import {ProductNFT} from "../src/ProductNFT.sol";

contract ContractTest is Test {
  ProductNFT product;
  address testMaster = address(0xb4c79daB8f259C7Aee6E5b2Aa729821864227e84);
  address firstBuyer = address(0x1);
  address secondBuyer = address(0x2);
  string tokenURI1 = "test_token_URI_1";
  string tokenURI2 = "test_token_URI_2";
  string tokenURI3 = "test_token_URI_3";

  function setUp() public {
    product = new ProductNFT("Test Product NFT", "tpNFT", 3);
  }

  function testSafeMintToken() public {
    product.safeMint(firstBuyer, tokenURI1);
    uint256 firstBuyerBalance = product.balanceOf(firstBuyer);
    assertEq(firstBuyerBalance, 1);
  }

  function testOnlyOwnerCanMint() public {
    vm.startPrank(firstBuyer);
    vm.expectRevert("Ownable: caller is not the owner");
    product.safeMint(firstBuyer, tokenURI1);
  }

  function testMaxSupplyLimit() public {
    product.safeMint(firstBuyer, tokenURI1);
    product.safeMint(secondBuyer, tokenURI2);
    product.safeMint(firstBuyer, tokenURI3);
    vm.expectRevert("NFT max supply has been reached");
    product.safeMint(secondBuyer, tokenURI1);
  }

  function testGetTokenURI() public {
    product.safeMint(firstBuyer, tokenURI1);
    product.safeMint(firstBuyer, tokenURI2);
    product.safeMint(secondBuyer, tokenURI3);
    string memory mintedTokenURI1 = product.tokenURI(0);
    string memory mintedTokenURI2 = product.tokenURI(1);
    string memory mintedTokenURI3 = product.tokenURI(2);
    assertEq(mintedTokenURI1, tokenURI1);
    assertEq(mintedTokenURI2, tokenURI2);
    assertEq(mintedTokenURI3, tokenURI3);
  }

  function testSetTokenURI() public {
    product.safeMint(firstBuyer, tokenURI1);
    vm.startPrank(firstBuyer);
    product.setTokenURI(0, tokenURI2);
    string memory mintedTokenURI = product.tokenURI(0);
    assertFalse(keccak256(bytes(mintedTokenURI)) == keccak256(bytes(tokenURI1)));
  }

  function testOnlyNftOwnerCanSetTokenURI() public {
    product.safeMint(firstBuyer, tokenURI1);
    vm.startPrank(secondBuyer);
    vm.expectRevert("Caller is not the owner or an approved operator");
    product.setTokenURI(0, tokenURI2);
  }
}
