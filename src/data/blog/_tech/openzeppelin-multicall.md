---
author: Brian Hu
pubDatetime: 2023-04-24T3:47:10Z
title: OpenZeppelin Multicall 源码解读
postSlug: openzeppelin-multicall
featured: true
draft: false
tags:
  - Solidity
  - OpenZeppelin
ogImage: "@/assets/images/tech/chris-ried-ieic5Tq8YMk-unsplash.jpg"
description: 本文对 OpenZeppelin Multicall 的源码做简单解析，基于 OpenZeppelin v4.5.0 版本。
---

OpenZeppelin Multicall 是一个开源的智能合约，它允许以低成本一次调用执行多个函数操作。它是 Uniswap v3、Aave、Compound 等项目中使用的核心基础设施之一。

Multicall 合约允许用户执行多个智能合约函数的读取操作，并返回所有函数调用的结果，从而减少了通信成本和区块链资源的使用。因为在以太坊上每次调用智能合约函数都需要支付 gas，所以使用 Multicall 合约可以大大降低成本。

除此之外，OpenZeppelin Multicall 还提供了一些其他的特性，例如：

- 防止重入攻击：Multicall 合约使用 Solidity v0.6 中引入的 "nonReentrant" 修饰符，防止被调用的合约被重复调用。
- 节省 gas 费用：Multicall 合约将所有的函数调用放在同一个交易中执行，从而节省了一部分 gas 费用。

## 源码逻辑

原理其实就是利用 for 循环调用 input data 的数组来实现一次外部调用处理多个内部函数调用逻辑

```solidity
pragma solidity ^0.8.0;

import "./Address.sol";

/**
 * @dev 提供一次外部调用处理多次内部调用的方法
 *
 * _Available since v4.1._
 */
abstract contract Multicall {
    /**
     * @dev 在此合约上接收并执行一批函数调用。
     * @custom:oz-upgrades-unsafe-allow-reachable delegatecall
     */
    function multicall(bytes[] calldata data) external virtual returns (bytes[] memory results) {
        results = new bytes[](data.length);
        // 利用 for 循环执行多个函数调用
        for (uint256 i = 0; i < data.length; i++) {
            // 使用 DelegateCall 调用
            results[i] = Address.functionDelegateCall(address(this), data[i]);
        }
        return results;
    }
}
```
