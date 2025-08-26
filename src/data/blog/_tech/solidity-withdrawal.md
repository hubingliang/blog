---
author: Brian Hu
pubDatetime: 2023-03-14T08:56:20.000Z
title: Solidity 提款模式（withdrawal） 是什么？
postSlug: solidity-withdrawal
featured: false
draft: false
tags:
  - Solidity
ogImage: ""
description: 如果在一些逻辑之后需要进行转移资金操作时通常是建议使用提款模式（withdrawal pattern）。
---

如果在一些逻辑之后需要进行转移资金操作时通常是建议使用提款模式（withdrawal pattern）。尽管通常情况下发送 Ether 的方法是直接调用 `transfer`，但不建议这样做，因为它引入了潜在的安全风险。

下面举一个提款模式的合约例子，简单来说是个比富游戏，智能合约接收用户发送的款项(以太)，金额最高的将成为 richest，前一位 richest 失去头衔，但将获得金钱补偿，当前 richest 发送的款项，将转账给前 richest,灵感来自 [King of the Ether](https://www.kingoftheether.com/thrones/kingoftheether/index.html)

## Table of contents

## 直接转账模式

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract SendContract {
    address payable public richest;
    uint public mostSent;

    // 收到的 ether 并不高于当前最高值时的错误
    error NotEnoughEther();

    constructor() payable {
        richest = payable(msg.sender);
        mostSent = msg.value;
    }

    function becomeRichest() public payable {
        if (msg.value <= mostSent) revert NotEnoughEther();
        // 这一步使用 transfer 进行转账可能会出现安全隐患(下文解释)。
        richest.transfer(msg.value);
        richest = payable(msg.sender);
        mostSent = msg.value;
    }
}
```

请注意，在此示例中，攻击者可以通过使 `richest` 成为攻击合约，攻击合约具有一定会失败的 `receive` 或 `fallback` 方法（例如，通过调用 `revert()` 或执行超过 2300 gas 限制的恶意代码）。这样，每当调用 `transfer` 将资金交付给“攻击”合约时，它就会失败，因此 `becomeRichest` 也会失败，合约将永远卡住。

相反，如果使用“提款”模式，攻击者只能导致它自己的取款失败，而不会阻塞合约的其余逻辑失败。

## 提款模式

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract WithdrawalContract {
    address public richest;
    uint public mostSent;

    mapping (address => uint) pendingWithdrawals;

    // 收到的 ether 并不高于当前最高值时的错误
    error NotEnoughEther();

    constructor() payable {
        richest = msg.sender;
        mostSent = msg.value;
    }

    function becomeRichest() public payable {
        if (msg.value <= mostSent) revert NotEnoughEther();
        pendingWithdrawals[richest] += msg.value;
        richest = msg.sender;
        mostSent = msg.value;
    }

    function withdraw() public {
        uint amount = pendingWithdrawals[msg.sender];
        // 注意在发送 ether 之前把账户余额设置为 0，以此来预防重入攻击
        pendingWithdrawals[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }
}
```

提款模式，让收款方(上一个 richest )主动来提取款项，交易不会失败，游戏可以继续。
