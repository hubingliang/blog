---
author: Brian Hu
pubDatetime: 2019-01-02T10:58:11.000Z
title: 可能是最全的 Javascript 类型检查方案
postSlug: 可能是最全的 Javascript 类型检查方案
featured: false
draft: false
tags:
  - JavaScript
  - Front-end
ogImage: "@/assets/images/tech/sudharshan-tk-mM9vVJ2oDeI-unsplash.jpg"
description: 类型检查在各种强类型语言（Typescript、Flow.js）出现之前一直是我们手动检查的，检查的方式也是多种多样。本文尽量总结出所有类型最优的检查方式，和解释所有方式的原理，如果有错误请各位大佬指正，除此之外对于类型检查当然拥抱强类型我觉得才是未来。
---

## 前言

类型检查在各种强类型语言（Typescript、Flow.js）出现之前一直是我们手动检查的，检查的方式也是多种多样。本文尽量总结出所有类型最优的检查方式，和解释所有方式的原理，如果有错误请各位大佬指正，除此之外对于类型检查当然拥抱强类型我觉得才是未来。

es6 之后新加入了 Symbol 类型，目前为止 JavaScript 一共有 7 种类型，但其中还有分类（set WeakSet Map WeakMap），我们就基于这些类型来探索：

- null
- undefined
- boolean
- number
- string
- object (set WeakSet Map WeakMap)
- symbol(ES6 中新增)

## Typeof

首先是 Typeof，Typeof 可能是最多人所熟知的判断类型的方法，但是它并不完美，在有些情况下它的判断是有偏差的，我们来看看几个例子：

```js
// 首先判断基本类型
typeof 1; // number
typeof "Hellow world !"; // string
typeof true; // boolean
typeof null; // object
typeof undefined; // undefined

let s = Symbol();
typeof s; // symbol
```

可以看到 null 的判断出了错误，这个大家看面试题也或多或少知道这个坑。
然后我们再来看看引用类型：

```js
const obj = Object.create(null); // 之所以这样创建是因为编程习惯...
function foo() {}
const arr = [];
const s = new Set();
const ws = new WeakSet();
const m = new Map();
const wm = new WeakMap();

typeof obj; // object
typeof foo; // function
typeof arr; // object
typeof s; // object
typeof ws; // object
typeof m; // object
typeof wm; // object
```

我们发现 typeof 在判断引用类型的时候并不能区分除了 function 以外其他类型的区别。至于为什么会出现这样的情况，就要看看 typeof 的原理。

### typeof 原理

在说原理之前需要先知道，js 是怎么储存数据类型的？

JavaScript 在底层储存变量时出于性能考虑会把数据的类型用前三位表示，typeof 就是通过前三位来判断类型：

- 000: 对象
- 001: 整数
- 010: 浮点数
- 100: 字符串
- 110: 布尔

两个特殊类型：

- undefined: -2^30
- null: 全是 0

因为 null 的机器码是全 0，它的类型标签自然就是 000，所以 typeof null 返回"object"。

## instanceof

instanceof 是有局限性的，它要求判断的目标必须是一个对象，与此同时 instanceof 的原理是判断只要右边的 prototype 出现在左边的原型链上就返回 true。所以说 instanceof 是判断一个实例是否是其父类型或者祖先类型的实例更为恰当。

代码的基本实现：

```js
function instance_of(L, R) {
  // L 表示左表达式，R 表示右表达式
  var O = R.prototype; // 取 R 的显示原型
  L = L.__proto__; // 取 L 的隐式原型
  while (true) {
    if (L === null) return false;
    if (O === L)
      // 当 O 严格等于 L 时，返回 true
      return true;
    L = L.__proto__;
  }
}
```

还是看例子比较直接：

```js
const obj1 = Object.create(null);
const obj2 = {};

obj1 instanceof Object; // false
obj2 instanceof Object; // true
```

通过这个例子你能很明确的想明白 instanceof 的原理，因为 obj1 是通过`Object.create(null)`来创建的，它原型链上什么都没有：

![](https://i.loli.net/2019/01/02/5c2c8b9a13878.png)

而直接通过`{}`赋值生成的对象它的`_proto_`是指向 Object 的：

![](https://i.loli.net/2019/01/02/5c2c8bc36b1f2.png)

所以判断结果就会有不同，

## Object.prototype.toString.call()

这个方法可以说是目前比较全面的类型判断方法了，还是看看例子：

```js
Object.prototype.toString.call(null); // "[object Null]"
Object.prototype.toString.call(undefined); // "[object Undefined]"
Object.prototype.toString.call(123); // "[object Number]"
Object.prototype.toString.call(true); // "[object Boolean]"
Object.prototype.toString.call("Hellow world !"); // "[object String]"
Object.prototype.toString.call({ a: 123 }); // "[object Object]"
Object.prototype.toString.call(Symbol()); // "[object Symbol]"
Object.prototype.toString.call([1, 2, 3]); // "[object Array]"
Object.prototype.toString.call(function a() {}); // "[object Function]"
Object.prototype.toString.call(new Date()); // "[object Date]"
Object.prototype.toString.call(Math); // "[object Math]"
Object.prototype.toString.call(new Set()); // "[object Set]"
Object.prototype.toString.call(new WeakSet()); // "[object WeakSet]"
Object.prototype.toString.call(new Map()); // "[object Map]"
Object.prototype.toString.call(new WeakMap()); // "[object WeakMap]",/'.lk
```

可以说`Object.prototype.toString.call()`在大部分类型的考验下都不落下风，可以说是比较完美的类型检查了。
至于原理大家可以移步至[谈谈 Object.prototype.toString](https://segmentfault.com/a/1190000009407558)
