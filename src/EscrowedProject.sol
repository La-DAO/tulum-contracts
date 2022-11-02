// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.15;

/**
 * @title EscrowedProject
 * @author La DAO
 * @notice This contract contains the main functions for an escrowed project
 * controls release of funding, and distributes earnings if applicable.
 */
import {IERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

contract EscrowedProject {
  using SafeERC20 for IERC20;

  address public immutable projectManager;

  IERC20 public fundingAsset;
  uint256 public fundingGoal;

  uint256 public immutable minFundAmount;

  address public immutable fundingVoucher;
  address public immutable productNFT;

  uint256 public fundedTotal;
  mapping(address => uint256) private _supporters;

  uint256 public immutable supportDeadline;

  constructor(
    address projectManager_,
    address fundingAsset_,
    uint256 fundingGoal_,
    uint256 minFundAmount_
  ) {
    projectManager = projectManager_;
    fundingAsset = IERC20(fundingAsset_);
    fundingGoal = fundingGoal_;
    minFundAmount = minFundAmount_;
    supportDeadline = block.timestamp + 12 weeks;

    fundingVoucher = _deployFundingVoucher();
    productNFT = _deployProductNFT();
  }

  /**
   * @notice Returns the `funded` amount of `supporter`.
   */
  function getSupportBalance(address supporter) public view returns (uint256 funded) {
    return _supporters[supporter];
  }

  /**
   * @notice Call to support this project by `amount`.
   */
  function fundProject(uint256 amount) external {
    // TODO
  }

  /**
   * @notice Approve budget pull by `projectManager`.
   *
   * Requirements:
   * - MUST check caller is a `supporter`.
   */
  function approveBudgetPull() external {
    // TODO
  }

  function _deployFundingVoucher() internal returns (address) {
    // TODO
  }

  function _deployProductNFT() internal returns (address) {
    // TODO
  }
}
