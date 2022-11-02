// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.15;

/**
 * @title ProjectFactory
 * @author La DAO
 * @notice This contract deploys new projects to be funded, and
 * maintains record of deployed projects.
 */

import {EscrowedProject} from "./EscrowedProject.sol";

contract ProjectFactory {
  /**
   * @dev Emit when a new project is created.
   * @param manager address
   * @param project address
   */
  event ProjectCreated(address indexed manager, address project);

  mapping(address => bool) public isProject;

  /**
   * @notice Creates a new project
   *
   * Requirements:
   * - MUST be access restricted
   */
  function createProject(
    address projectManager_,
    address fundingAsset_,
    uint256 fundingGoal_,
    uint256 minFundAmount_
  )
    external
  {
    bytes32 salt =
      keccak256(abi.encode(projectManager_, fundingAsset_, fundingGoal_, minFundAmount_));
    address newProject = address(
      new EscrowedProject{salt: salt}(
            projectManager_,
            fundingAsset_,
            fundingGoal_,
            minFundAmount_
        )
    );
    emit ProjectCreated(msg.sender, newProject);
  }
}
