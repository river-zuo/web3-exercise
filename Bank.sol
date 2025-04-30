// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Bank {

    // 记录每个合约地址的存款金额
    mapping(address => uint256) public addr_balance;

    // 存款最高的前三名
    address[3] public top_3_balance_addr;
    bool has_init_top3 = false;
    // 存款最高的三个里面最少的金额、地址
    uint256 public lowest_balance_in_top;
    address public lowest_balance_addr_in_top;
    // 管理员地址
    address private immutable ADMIN_ADDR;
    // 未初始化时的地址
    address private constant UN_INIT_ADDR = 0x0000000000000000000000000000000000000000;

    constructor(address addr) {
        ADMIN_ADDR = addr;
    }

    // 向合约转账, remix中测试使用
    // function transferTocontract() external payable {
    //     address payable addr = payable(address(this));
    //     addr.transfer(msg.value);
    //     recordBalanceOfAddr();
    // }

    // 接受转账
    receive() external payable {
        recordBalanceOfAddr();
    }

    // 记录存款金额
    function recordBalanceOfAddr() private {
        address sender = msg.sender;
        uint256 send_balance = msg.value;
        uint256 balance = addr_balance[sender];
        uint256 new_balance;
        if (balance > 0) {
            new_balance = balance + send_balance;
            addr_balance[sender] = new_balance;
        } else {
            new_balance = send_balance;
        }
        addr_balance[sender] = new_balance;
        // 记录前三名地址
        if (has_init_top3 && new_balance > lowest_balance_in_top) {
            // top3数组已满
            for (uint i = 0; i< top_3_balance_addr.length; i++) {
                address tmp_addr = top_3_balance_addr[i];
                if (tmp_addr == lowest_balance_addr_in_top) {
                    top_3_balance_addr[i] = sender;
                    break ;
                }
            }
            // 重新记录最小的值和地址
            lowest_balance_in_top = new_balance;
            lowest_balance_addr_in_top = sender;
            for (uint i = 0; i< top_3_balance_addr.length; i++) {
                address tmp_addr = top_3_balance_addr[i];
                uint256 tmp_balance = addr_balance[tmp_addr];
                if (tmp_balance < lowest_balance_in_top) {
                    lowest_balance_in_top = tmp_balance;
                    lowest_balance_addr_in_top = tmp_addr;
                }
            }
        } else {
            // top3数组未满
            for (uint i = 0; i < top_3_balance_addr.length; i++) {
                address tmp_addr = top_3_balance_addr[i];
                if (tmp_addr == UN_INIT_ADDR) {
                    top_3_balance_addr[i] = sender;
                    if (i == 0) {
                        lowest_balance_in_top = new_balance;
                        lowest_balance_addr_in_top = sender;
                    }
                    if (i == 2) {
                        has_init_top3 = true;
                    }
                    break ;
                } else if (tmp_addr == sender) {
                    break ;
                }
            }
            if (lowest_balance_addr_in_top == sender) {
                lowest_balance_in_top = new_balance;
            }
            if (lowest_balance_in_top != 0 && lowest_balance_in_top > new_balance) {
                lowest_balance_in_top = new_balance;
                lowest_balance_addr_in_top = sender;
            }  
        }
    }

    // 管理员可以通过该方法提取所有的资金
    function withdraw() external payable returns(int8) {
        address payable addr = payable(address(msg.sender));
        // 是否为管理员地址
        if (addr != ADMIN_ADDR) {
            return -1;
        }
        address payable this_addr = payable(address(this));
        uint256 balance = this_addr.balance;
        if (balance > 0) {
            addr.transfer(balance);
        } else {
            // 没有余额
            return -2;
        }
        return 0;
    }

}

