// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TokenBank {

    mapping(address => uint256) public addr_balance;

    address public immutable erc20;

    constructor(address erc20Addr) {
        erc20 = erc20Addr;
    }

    // 把erc20合约地址上的token，提取到bank
    function deposit(uint256 amount) public {
        bytes memory call_tranferFrom = abi.encodeWithSignature("transferFrom(address,address,uint256)", msg.sender, address(this), amount);
        (bool success, bytes memory res) = erc20.call(call_tranferFrom);
        require(success, "fail to invoke erc20");
        (bool erc20_res) = abi.decode(res, (bool));
        require(erc20_res, "invoke success, but results fail");
        addr_balance[msg.sender] += amount;
    }

    // 把用户bank里的token转移到erc20合约中
    function withdraw() public {
        bytes memory call_transfer = abi.encodeWithSignature("transfer(address,uint256)", msg.sender, addr_balance[msg.sender]);
        (bool success, bytes memory res) = erc20.call(call_transfer);
        require(success, "fail to invoke erc20");
        (bool erc20_res) = abi.decode(res, (bool));
        require(erc20_res, "invoke success, but results fail");
        addr_balance[msg.sender] = 0;
    }

}
