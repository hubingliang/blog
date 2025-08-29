---
author: Brian Hu
pubDatetime: 2018-07-20T09:45:16.000Z
title: 浅拷贝没那么简单
postSlug: 浅拷贝没那么简单
featured: false
draft: false
tags:
  - JavaScript
  - Front-end
ogImage: "@/assets/images/tech/freestocks-I_pOqP6kCOI-unsplash.jpg"
description: 浅拷贝： 只能对基本类型的值拷贝，如果所要拷贝的对象的某个属性的值是对象的话，那么目标对象拷贝得到的是这个对象的引用。
---

## 拷贝的分类

1. 浅拷贝： 只能对基本类型的值拷贝，如果所要拷贝的对象的某个属性的值是对象的话，那么目标对象拷贝得到的是这个对象的引用。
2. 深拷贝： 和原对象一样的属性和原型，相互之间互不影响（不一样的内存地址）

在写这篇博客之前，看了很多博客实现的浅拷贝，发现大家实现的方法或多或少都有些不足，今天就把这些坑说一说。

- 我需不需要拷贝原对象的原型？
- 对象中有以 Symbol 为属性名的属性我需不需要拷贝？
- 对象中有不可遍历的属性，我要不要拷贝？

## 逐个属性遍历（ES6 之前）

通过逐个遍历对象的属性并复制，来实现浅拷贝，但这种方法有两个弊端：

- 不可遍历以 symbol 为属性名的属性
- 不可遍历不可枚举属性

> Symbol 作为属性名，该属性不会出现在 for...in、for...of 循环中，也不会被 Object.keys()、Object.getOwnPropertyNames()、JSON.stringify()返回。

```js
// 浅拷贝函数
function shallowClone(obj) {
  const newObj = {};
  for (let i in obj) {
    newObj[i] = obj[i];
  }
  return newObj;
}
// 被拷贝对象
const obj1 = {
  a: 1,
  b: "hellow world",
  c: true,
  d: Symbol("symbol"),
  [Symbol("e")]: "e",
};
Object.defineProperty(obj1, "f", {
  value: "f",
  enumerable: false,
}); // 添加不可枚举属性
const obj2 = shallowClone(obj1);

obj2; // {a: 1, b: "hellow world", c: true, d: Symbol(symbol)}
```

所拷贝的对象并没有以 symbol 为属性名的属性，也不能拷贝不可遍历的属性，所以这种方法并不是最佳实践。

## ES6 下的浅拷贝

ES6 新增了许多操作对象或者遍历对象的 API，下面分别测试下能不能实现完美的浅拷贝

### [Object.assign()](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Object/assign)

通过和空对象合并来实现浅拷贝：

```js
const obj1 = {
  a: 1,
  b: "hellow world",
  c: true,
  d: Symbol("symbol"),
  [Symbol("e")]: "e",
};
const obj2 = Object.assign({}, obj1); // ES6新扩展： Object.assign()
obj2; // {a: 1, b: "hellow world", c: true, d: Symbol(symbol), Symbol(e): "e"}
```

发现可以实现对以 symbol 为属性名的属性的拷贝，但是对于不可枚举属性`Object.assign()`还是无能为力。 我们在 MDN 上发现[Object.assign()](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Object/assign)不可以遍历出不可枚举属性：

> Object.assign() 方法用于将所有可枚举属性的值从一个或多个源对象复制到目标对象。它将返回目标对象。

### 解构赋值+rest

那我们看看更加优雅的解构赋值+rest 能不能实现完美的浅克隆通过 ES6 的解构赋值可以更简单的实现浅拷贝：

```js
const obj1 = {
  a: 1,
  b: "hellow world",
  c: true,
  d: Symbol("symbol"),
  [Symbol("e")]: "e",
};
Object.defineProperty(obj1, "f", {
  value: "f",
  enumerable: false,
});
let { ...obj2 } = obj1;
obj2; // {a: 1, b: "hellow world", c: true, d: Symbol(symbol), Symbol(e): "e"}
```

发现依然不能解决不可遍历属性的问题。

## ES7 下的浅拷贝

### [Object.getOwnPropertyDescriptors](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Object/getOwnPropertyDescriptor)

> `Object.getOwnPropertyDescriptor()` 方法返回指定对象上一个自有属性对应的属性描述符。（自有属性指的是直接赋予该对象的属性，不需要从原型链上进行查找的属性）

`Object.getOwnPropertyDescriptors`方法可以配合`Object.create`方法实现浅拷贝:

```js
const shallowClone = obj =>
  Object.create(
    Object.getPrototypeOf(obj),
    Object.getOwnPropertyDescriptors(obj)
  );
const obj1 = {
  a: 1,
  b: "hellow world",
  c: true,
  d: Symbol("symbol"),
  [Symbol("e")]: "e",
};
Object.defineProperty(obj1, "f", {
  value: "f",
  enumerable: false,
});
const obj2 = shallowClone(obj1);

obj2; //{a: 1, b: "hellow world", c: true, d: Symbol(symbol), f: "f"}
```

基本上完美实现了对所有类型属性的拷贝，可以看见即使是浅拷贝，要踩得坑还是很多的。
