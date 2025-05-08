# 使用 Foundry 测试 Bank 合约
## 测试文件
BankTest.sol
## 输出日志
```
forge test --match-contract BankTest -vvv
[⠊] Compiling...
[⠰] Compiling 3 files with Solc 0.8.28
[⠔] Solc 0.8.28 finished in 356.97ms
Compiler run successful!

Ran 1 test for test/bank/BankTest.sol:BankTest
[PASS] testDeposit() (gas: 984456)
Logs:
  new user addr:  0xcD108C22d713AF99eD60b7FD930b3F98726Db9e5
  name:  user_AA
  balance:  1000000000000000000
  new user addr:  0x3BFCE0d1A55f3b73F39A623Ae07A9eBeA0F4D749
  name:  user_BB
  balance:  1000000000000000000
  new user addr:  0xFc2a979bda77Ce452AfF1420e1bf1184fb7d1a58
  name:  user_CC
  balance:  1000000000000000000
  new user addr:  0xe656441F396fD7B84912605a0584C5A89FC45eeb
  name:  user_DD
  balance:  1000000000000000000
  admin addr:  0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496
  _bank addr:  0x5615dEB798BB3E4dFa0139dFa1b3D433Cc23b72f
  bank's balance:  1400000000000000000
  ua's balance:  800000000000000000
  ub's balance:  700000000000000000
  uc's balance:  600000000000000000
  ud's balance:  500000000000000000
  receive:  2000000000000000000

Suite result: ok. 1 passed; 0 failed; 0 skipped; finished in 7.31ms (2.89ms CPU time)

Ran 1 test suite in 101.97ms (7.31ms CPU time): 1 tests passed, 0 failed, 0 skipped (1 total tests)
```

