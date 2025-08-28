---
author: Brian Hu
pubDatetime: 2023-03-27T8:52:10Z
title: Uniswap Permit2：下一代以太坊授权机制，低开销、安全且通用
postSlug: permit2
featured: true
draft: false
tags:
  - Solidity
  - Uniswap
  - EIP
ogImage: "https://res.cloudinary.com/dewu7okpv/image/upload/v1679901132/blog/canary/%E6%97%A0%E6%A0%87%E9%A2%98-2023-03-27-1504_biwerw.png"
description: 本文对以太坊授权机制做简单解析。
---

Permit2 是 Uniswap 上的一种新的授权机制。它可以让用户在无需进行交易的情况下，通过授权来允许其他人代表自己进行交易。正如 [Github](https://github.com/Uniswap/permit2) 的介绍那样，这种授权机制可以在一定程度上提高用户的交易效率，同时也可以减少用户的 Gas 消耗。

> Permit2 引入了一个低开销的下一代 token 批准/元交易系统，使 token 批准更容易、更安全、跨应用程序更一致。

## Table of contents

## 传统授权模式

在传统的以太坊交易中，用户需要先进行授权，然后才能进行交易。

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1679901132/blog/canary/%E6%97%A0%E6%A0%87%E9%A2%98-2023-03-27-1504_biwerw.png)

- 图中流程非常耗时且重复，每当用户需要与新的合约交互都需要再次授权，而且每一步都要支付 Gas fee。
- 部分合约为了简化授权流程往往需要用户一次性授权很高的额度，但这往往又带来安全问题。

## 授权签名（EIP-2612）模型

EIP-2612 是以太坊网络上的一项重要协议，该协议简化了 ERC-20 代币的授权机制。在以往的 ERC-20 代币授权机制中，用户需要分别进行授权和转账操作，这种方式操作繁琐、费用高昂。而 EIP-2612 则将授权和转账操作合并成一步，大大提高了用户体验。

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1679902960/blog/canary/22222_aonhht.png)

1. User 签署链外 "permit(签名授权)" 信息，授权一个合约使用其（EIP-2612）代币。
2. User 提交签署的消息，作为与所述合约交互的一部分。
3. 合约调用代币的 "permit()" 方法，使用签名授权信息和签名，获得授权。
4. 合约现在已经获得授权，它可以在代币上调用 transferFrom()方法，转移 User 持有的代币。

EIP-2612 则将授权和转账的操作合并成一步，大大提高了用户体验，同时也提高了用户的安全性。

除了提高用户体验之外，EIP-2612 还具有更高的安全性。在以前的授权机制中，如果用户错误地授权了恶意合约，那么这个合约就可以随意使用用户的代币。但是，EIP-2612 协议要求合约必须在进行交易前明确告知用户需要授权的代币数量，从而提高了用户的安全性。

尽管 EIP-2612 使代币授权更加安全，但在 EIP-2612 推出之前发行的代币并不支持签名授权功能，而且并非所有较新的代币都采用了这种功能，这是一个现实的问题。因此，大多数情况下，这种方法并不推荐。

## Permit2 授权模式

Permit2 结合了 EIP-2612 的优点并且将它们扩展兼容了 ERC20 代币标准！

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1679904442/blog/canary/permit2_g9npnw.png)

1. User 向 ERC-20 调用 `approve()` 对 Permit2 授予一个无限额度的授权
2. User 签署链外 "permit2(签名授权)" 信息，授权一个合约使用其（ERC-20）代币
3. User 在调用合约交互函数时，将签名过的的 permit2 消息作为参数传入
4. 合约拿到签名消息并调用 permit2 的 `permitTransferFrom()` 申请转账
5. Permit2 合约通过自己的授权额度来将 User 的代币从 ERC-20 转账给目标合约

由于 User 之前已经授权过 Permit2，那么其他任何一个合约都可以带着签名信息通过向 Permit2 请求转账来跳过授权步骤。
