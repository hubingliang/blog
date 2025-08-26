---
author: Flaneur
pubDatetime: 2023-03-09T13:04:00Z
title: ethers.js V6 带来了什么
postSlug: ethers-v6
featured: false
draft: false
tags:
  - ethers.js
  - Solidity
ogImage: ""
description: 本文对 ethers.js 更新版本 V6 的内容做简要总结
---

## Table of contents

ethers.js v6 中最大的不同是使用了现代的 ES6 feature。

## Big Numbers

v6 中最大的变化之一是 BigNumber 类已被现代 JavaScript 环境提供的内置 ES2020 BigInt 取代。

可以在 [MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/BigInt) 这里查看 JavaScript ES2020 BigInt 的具体用法。

### 初始化 BigNumber

```js
// BigNumber in v5
value = BigNumber.from("1000");

// Using BigInt in v6 (using literal notation).
// Notice the suffix n
value = 1000n;

// Using the BigInt function for strings
value = BigInt("1000");
```

### 简单计算

```js
// Adding two values in v5
sum = value1.add(value2);

// Using BigInt in v6; keep in mind, both values
// must be a BigInt
sum = value1 + value2;
```

### 数字比较

```js
// Checking equality in v5
isEqual = value1.eq(value2);

// Using BigInt in v6
isEqaul = value1 == value2;
```

## Contracts

Contract 就是一个 ES6 的 Proxy, 这意味着它可以在运行时解析方法名称。

### 未知命名的函数

- v5

```js
abi = ["function foo(address bar)", "function foo(uint160 bar)"];
contract = new Contract(address, abi, provider);

// In v5 it was necessary to specify the fully-qualified normalized
// signature to access the desired method. For example:
contract["foo(address)"](addr);

// These would fail, since there signature is not normalized:
contract["foo(address )"](addr);
contract["foo(address addr)"](addr);

// This would fail, since the method is ambiguous:
contract.foo(addr);
```

- v6

```js
abi = ["function foo(address bar)", "function foo(uint160 bar)"];
contract = new Contract(address, abi, provider);

// Any of these work fine:
contract["foo(address)"](addr);
contract["foo(address )"](addr);
contract["foo(address addr)"](addr);

// This still fails, since there is no way to know which
// method was intended
contract.foo(addr);

// However, the Typed API makes things a bit easier, since it
// allows providing typing information to the Contract:
contract.foo(Typed.address(addr));
```

### 其他方法

- v5

```js
// The default action chooses send or call base on method
// type (pure, view, constant, non-payable or payable)
contract.foo(addr);

// This would perform the default action, but return a Result
// object, instead of destructing the value
contract.functions.foo(addr);

// Forces using call
contract.staticCall.foo(addr);

// Estimate the gas
contract.estimateGas.foo(addr);

// Populate a transaction
contract.populateTransaction.foo(addr);
```

- v6

```js
// Still behaves the same
contract.foo(addr);

// Perform a call, returning a Result object directly
contract.foo.staticCallResult(addr);

// Forces using call (even for payable and non-payable)
contract.foo.staticCall(addr);

// Forces sending a transaction (even for pure and view)
contract.foo.send(addr);

// Estimate the gas
contract.foo.estimateGas(addr);

// Populate a transaction
contract.foo.populateTransaction(addr);
```

## Importing

v5 版本 ethers.js 使用 sub-package 方式管理 和 monorepo 比较相似

在 v6 版本所有 `import` 都可以在根 package 里面导入

### v5 导入

```js
// Many things (but not all) we available on the root package
import { ethers } from "ethers";

// But some packages were grouped behind an additional property
import { providers } from "ethers";
const { InfuraProvider } = providers;

// For granular control, importing from the sub-package
// was necessary
import { InfuraProvider } from "@ethersproject/providers";
```

### v6 导入

```js
// Many things (but not all) we available on the root package
import { ethers } from "ethers";

// But some packages were grouped behind an additional property
import { providers } from "ethers";
const { InfuraProvider } = providers;

// For granular control, importing from the sub-package
// was necessary
import { InfuraProvider } from "@ethersproject/providers";
```

## Providers

之前所有 `ethers.providers.*` 转变成 `ethers.*`

```js
// v5
provider = new ethers.providers.Web3Provider(window.ethereum);

// v6:
provider = new ethers.BrowserProvider(window.ethereum);
```

## Signatures

v6 版本的 Signature 将是一个类，可以方便地进行解析和序列化操作。

```js
// v5
splitSig = splitSignature(sigBytes);
sigBytes = joinSignature(splitSig);

// v6
splitSig = ethers.Signature.from(sigBytes);
sigBytes = ethers.Signature.from(splitSig).serialized;
```

## Transactions

v5 版本中的 transaction 相关方法现在被封装到了 Transaction 类中，该类可以处理任何支持的交易格式以进一步进行处理。

```js
// v5
tx = parseTransaction(txBytes);
txBytes = serializeTransaction(tx);
txBytes = serializeTransaction(tx, sig);

// v6
tx = Transaction.from(txBytes);

// v6 (the tx can optionally include the signature)
txBytes = Transaction.from(tx).serialized;
```

## Utilities

### Bytes32 string helpers

```js
// In v5:
bytes32 = ethers.utils.formatBytes32String(text);
text = ethers.utils.parseBytes32String(bytes32);

// In v6:
bytes32 = ethers.encodeBytes32String(text);
text = ethers.decodeBytes32String(bytes32);
```

### constants

```js
// v5:
ethers.constants.AddressZero;
ethers.constants.HashZero;

// v6:
ethers.ZeroAddress;
ethers.ZeroHash;
```

### data manipulation

```js
// v5
slice = ethers.utils.hexDataSlice(value, start, end);
padded = ethers.utils.hexZeroPad(value, length);

// v5; converting numbers to hexstrings
hex = hexlify(35);

// v6
slice = ethers.dataSlice(value, start, end);
padded = ethers.zeroPadValue(value, length);

// v6; converting numbers to hexstrings
hex = toBeHex(35);
```

### defaultAbiCoder

```js
// In v5, it is a property of AbiCoder
coder = AbiCoder.defaultAbiCoder;

// In v6, it is a static function on AbiCoder, which uses
// a singleton pattern; the first time it is called, the
// AbiCoder is created and on subsequent calls that initial
// instance is returned.
coder = AbiCoder.defaultAbiCoder();
```

### hex conversion

```js
// v5
hex = ethers.utils.hexValue(value);
array = ethers.utils.arrayify(value);

// v6
hex = ethers.toQuantity(value);
array = ethers.getBytes(value);
```

### solidity non-standard packed

```js
// v5
ethers.utils.solidityPack(types, values);

// v6
ethers.solidityPacked(types, values);
```

### property manipulation

```js
// v5
ethers.utils.defineReadOnly(obj, "name", value);

// v6
ethers.defineProperties(obj, { name: value });
```
