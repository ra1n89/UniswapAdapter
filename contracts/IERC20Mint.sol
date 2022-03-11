// SPDX-License-Identifier: MIT
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20Mint is IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function mint(address account, uint256 amount) external;
}
