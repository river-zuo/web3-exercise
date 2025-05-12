// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract MultipleSign {

// 实现⼀个简单的多签合约钱包，合约包含的功能：

// 创建多签钱包时，确定所有的多签持有⼈和签名门槛
// 多签持有⼈可提交提案
// 其他多签⼈确认提案（使⽤交易的⽅式确认即可）
// 达到多签⻔槛、任何⼈都可以执⾏交易

    uint16 public signer_total;
    uint16 public signer_at_least;

    address[] public signers;

    // 提案
    mapping (uint256 => Proposal) public trx_proposal;

    receive() external payable { }

    struct Proposal {
        // 交易id
        uint256 trx_id;
        // 目标合约地址;
        address target_contract_addr;
        // 转账数量
        uint256 amount;
        // 调用数据
        bytes data;
        // 已签名
        address[] hasSigneds;
        bool has_invoke;
    }

    modifier must_be_signer() {
        address sender = msg.sender;
        bool is_signer = false;
        for (uint i=0; i< signers.length;i++) {
            if (sender == signers[i]) {
                is_signer = true;
                break ;
            }
        }
        if (!is_signer) {
            revert("must be a signer.");
        }
        _;
    }

    // 提案必须可签名
    modifier trx_signable(uint256 trx_id) {
        Proposal memory checkP = trx_proposal[trx_id];
        require(checkP.trx_id != 0, string.concat("trx_id has not exists"));
        address[] memory hasSigned = checkP.hasSigneds;
        uint has_sign_num = 0;
        for (uint i = 0; i< hasSigned.length; i++) {
            if (msg.sender == hasSigned[i]) {
                revert("you has signed the trx");
            }
            if (hasSigned[i] != address(0)) {
                has_sign_num += 1;
            }
        }
        if (has_sign_num ==  signers.length) {
            revert("all have signed.");
        }
        _;
    }

    // 提案必须可运行
    modifier trx_executable(uint256 trx_id) {
        Proposal memory checkP = trx_proposal[trx_id];
        require(checkP.trx_id != 0, string.concat("trx_id has not exists"));
        require(!checkP.has_invoke, "trx has invoked.");
        address[] memory hasSigned = checkP.hasSigneds;
        uint has_sign_num = 0;
        for (uint i = 0; i< hasSigned.length; i++) {
            if (hasSigned[i] != address(0)) {
                has_sign_num += 1;
            }
        }
        bool can_be_exec = has_sign_num >= signer_at_least;
        if (!can_be_exec) {
            revert("trx can not be executed");
        }
        _;
    }

    // 提交提案
    function submit_proposal(uint256 trx_id, address target_contract_addr, uint256 amount, bytes memory data) public must_be_signer {
        Proposal memory checkP = trx_proposal[trx_id];
        require(checkP.trx_id == 0, string.concat("trx_id has existed"));
        require(amount >= 0, "amount must not be negitive");
        Proposal memory ppl =  Proposal({
            trx_id: trx_id,
            target_contract_addr: target_contract_addr,
            amount: amount,
            data: data,
            hasSigneds: new address[](signer_total),
            has_invoke: false
        });
        trx_proposal[trx_id] = ppl;
    }

    // 签名提案
    function sign_proposal(uint256 trx_id) public must_be_signer trx_signable(trx_id) {
        address sender = msg.sender;
        Proposal memory checkP = trx_proposal[trx_id];
        address[] memory hasSigneds = checkP.hasSigneds;
        for (uint i = 0; i< hasSigneds.length; i++) {
            if (hasSigneds[i] == address(0)) {
                hasSigneds[i] = sender;
                break;
            }
        }
        checkP.hasSigneds = hasSigneds;
        trx_proposal[trx_id] = checkP;
    }

    // 执行提案
    function exec_proposal(uint256 trx_id) public trx_executable(trx_id) {
        Proposal memory checkP = trx_proposal[trx_id];
        address payable contract_address = payable(checkP.target_contract_addr);
        uint256 amount = checkP.amount;
        bytes memory data = checkP.data;
        (bool success, ) = contract_address.call{value: amount}(data);
        require(success, "invoke proposal failure");
        // 标记已调用
        checkP.has_invoke = true;
        trx_proposal[trx_id] = checkP;
    }

}
