// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface BaseERC20CallBack {
    function tokensReceived(address account, uint256 amount, uint256 tokenId) external returns(bytes4);
}
