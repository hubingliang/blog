---
author: Flâneur
pubDatetime: 2023-04-13T9:07:20Z
title: 代理模式：部署可升级智能合约的关键
postSlug: upgradeable-smart-contract
featured: true
draft: false
tags:
  - Solidity
  - OpenZeppelin
  - ERC
ogImage: ""
description: 智能合约部署后无法修改，若出现 bug 或需要添加新功能，只能重新部署新合约、迁移数据、更新相关合约地址并说服社区使用新合约。为了解决这个问题，需要一个方便的解决方案，允许在不丢失数据的情况下更改合约代码。
---

## Table of contents

智能合约部署后无法修改，若出现 bug 或需要添加新功能，只能重新部署新合约、迁移数据、更新相关合约地址并说服社区使用新合约。为了解决这个问题，需要一个方便的解决方案，允许在不丢失数据的情况下更改合约代码。

## 代理模式

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1681376143/blog/canary/asdawdwwwwdsZdazc_iydvdh.png)

虽然已部署的智能合约不能直接升级代码，但可以使用**代理合约**架构来实现重定向到新部署的合约。

代理架构模式的原理是，所有的调用都会经过代理合约，重定向到最新部署的合约逻辑。如果想升级，只需部署新版本的合约，并更新代理以引用新的合约地址即可。

## 透明代理（Transparent Proxy）

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1681376026/blog/canary/asdawwww_lkxq5o.png)

透明代理 [EIP-1967](https://eips.ethereum.org/EIPS/eip-1967) 引入了 ProxyAdmin 合约作为管理员来解决“函数选择器冲突”的问题

- ProxyAdmin 合约被限制为只能调用代理合约的可升级函数升级合约。他不能调用任何逻辑合约的函数方法。
- 其他用户不能调用可升级函数，但可以调用逻辑合约的函数。

## UUPS 代理 (Universal Upgradeable Proxy Standard)

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1681375887/blog/canary/sdawdasdawdwa_t7q72o.png)

这种代理模式也称为通用可升级代理标准，相对于透明代理更加轻巧且通用，UUPS 的名称来自 [EIP-1822](https://eips.ethereum.org/EIPS/eip-1822)，它首先记录了该模式。

UUPS 把升级函数放在了逻辑合约中，所以代理合约本身部署成本会低于透明代理，除此之外，由于 UUPS Proxy 的升级逻辑由逻辑合约执行，不需要额外部署 Admin 合约完成升级逻辑，因此 UUPS Proxy 的部署成本比 Transparent Proxy 低。升级由逻辑合约控制，随时可以停止合约的可升级性。

## Beacon Proxy

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1681375593/blog/canary/sdasd_ycxiaf.png)

Beacon 模式是一种更加灵活的合约升级方式，实现方式是将 Implementation 地址存放在 Beacon 合约里，Proxy 合约中只保存 Beacon 合约的地址。在合约交互时，Proxy 合约需要先访问 Beacon 合约获取 Implementation 地址，然后再通过 delegatecall 调用 Implementation。

而在合约升级时，管理员不需要和 Proxy 合约打交道，只需要通过交互 Beacon 合约将新的 Implementation 地址存储到 Beacon 合约中即可。这个过程中，Proxy 合约的代码不需要改变，只需要改变 Beacon 合约中保存的 Implementation 地址即可实现合约升级。

Beacon 模式与其他两种模式不同，Implementation 地址不直接存储在 Proxy 合约中，可能看起来有些麻烦。然而，在多个 Proxy 共享同一 Implementation 并需要批量升级的场景中，该模式具有优势。在这种情况下，升级 Beacon 自然地实现了所有代理的升级效果。如果使用透明模式或 UUPS 模式，则每个代理必须单独升级。

## Transparent VS UUPS VS Beacon

| 代理模式 | 升级合约逻辑位置 | Gas                 | 可终止升级 |
| -------- | ---------------- | ------------------- | ---------- |
| 透明代理 | Proxy            | 高                  | 不可       |
| UUPS     | Logic            | 单 Proxy 代理时最低 | 可         |
| Beacon   | Beacon           | 多 Proxy 代理时最低 | 不可       |
