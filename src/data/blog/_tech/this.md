---
author: Brian Hu
pubDatetime: 2018-02-25T14:23:11.000Z
title: this 到底指向哪里？
postSlug: this 到底指向哪里？
featured: false
draft: false
tags:
  - JavaScript
  - Front-end
ogImage: "@/assets/images/tech/brendan-church-pKeF6Tt3c08-unsplash.jpg"
description: 老生常谈的问题了，之前一直有些模糊，这次争取一次写清楚。
---

老生常谈的问题了，之前一直有些模糊，这次争取一次写清楚。

## 指向只与调用有关

不论代码多么复杂我们只关心到底是谁最后调用的 this 就可以了。

来看一个例子：

```js
var obj = {
  foo: function () {
    console.log(this);
  },
};

var bar = obj.foo;
obj.foo(); // obj
bar(); //  window
```

为什么最后两行所打印出的 this 不同？还是那句话 **“谁最后调用的 this，this 就指向谁。”**

- 先看第一行调用 foo()函数的对象是 obj，所以 this 指向 obj。
- 前面没有调用的对象那么就是全局对象 window，所以调用 bar()函数的对象是全局 window，相当于 window.bar()，所以 this 指向 window（严格模式下全局为 undifined）

## 改变 this 指向的方法

### 箭头函数下的 this

箭头函数下的 this 有些特殊，函数体内的 this 对象就是定义时的所在的对象，而不是使用时所在的对象。

例子：

```js
function Timer() {
  this.s1 = 0;
  this.s2 = 0;

  setInterval(() => this.s1++, 1000);
  setInterval(function () {
    this.s2++;
  }, 1000);
}

let timer = new Timer();

setTimeout(() => console.log(timer.s1), 3100); //  3
setTimeout(() => console.log(timer.s2), 3100); //  0
```

上面的例子，Timer 函数内部设置了两个定时器，分别使用了箭头函数和普通函数，箭头函数的 this 指向函数定义时所在的作用于（即 Timer 函数），普通函数的 this 指向调用时所在的作用于（即全局对象 window）。所以，3100ms 之后，timer.s1 加到了 3，而 timer.s2 一次都没有更新。

### apply & call

apply call bind 都可以改变 this 的指向，这里先说 apply 和 call 的区别。 **apply 和 call 的区别是 call 方法接受的是若干个参数列表，而 apply 接收的是一个包含多个参数的数组。**

- apply

```js
var a = {
  fn: function (a, b) {
    console.log(a + b);
  },
};
var b = a.fn;
b.apply(a, [1, 2]); // 3
```

call

```js
var a = {
  fn: function (a, b) {
    console.log(a + b);
  },
};
var b = a.fn;
b.call(a, 1, 2); // 3
```

### bind 和 call apply

直接看 MDN 上面的介绍：

> bind()方法创建一个新的函数, 当被调用时，将其 this 关键字设置为提供的值，在调用新函数时，在任何提供之前提供一个给定的参数序列。

```js
var a = {
  fn: function (a, b) {
    console.log(a + b);
  },
};
var b = a.fn;
b.bind(a, 1, 2)(); // 3
```
