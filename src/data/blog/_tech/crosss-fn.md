---
author: Brian Hu
pubDatetime: 2018-03-18T14:55:25.000Z
title: 吃透 ES6 简洁优雅的箭头函数
postSlug: 吃透 ES6 简洁优雅的箭头函数
featured: false
draft: false
tags:
  - JavaScript
  - Front-end
ogImage: "@/assets/images/tech/nick-fewings-zF_pTLx_Dkg-unsplash.jpg"
description: 箭头函数可能是 ES6 最有特点的新特性了，它不仅可以让代码变得优美，而且更直观利于理解。
---

## 基本用法

箭头函数可能是 ES6 最有特点的新特性了，它不仅可以让代码变得优美，而且更直观利于理解。

```js
let f = v => v;
//等同于
let f = function () {
  return v;
};
```

如果箭头函数不需要参数或者需要多个参数的的情况下，就使用圆括号代表参数部分：

```js
let f = () => 5;

//等同于
let f = function () {
  return 5;
};
```

多个参数：

```js
let f = (a, b) => a + b;
//等同于
let f = function (a, b) {
  return a + b;
};
```

如果函数要执行的操作很多就需要用代码块括起来：

```js
let f = function (a,b) =>{
  //somecode
}
```

但是当你要使用箭头函数返回一个对象时，要用大括号把对象括起来：

`let f = () => ({ id : '1' , name : '小明 '})`

## 注意事项

### this 的确定?

和普通函数不同，箭头函数的 this 就是定义时的所在的对象，而不是使用时所在的对象。 也就是说一旦定义箭头函数，那么他的 this 对象就是定义时所在的对象，并不会因为 bind(),call()而改变。

### 不可以当作构造函数

也就是说不可以 new 一个箭头函数，否则会抛出一个错误：

```js
let f = () => {
  this.a = 1;
};
let x = new f(); //报错
```

### arguments 对象

对于箭头函数来讲，不可以使用 arguments 对象，该对象在函数体内不存在：

```js
let f = (a, b) => {
  console.log(arguments);
};
f(1, 2); // arguments is not defined
```

作为代替 ES6 新加入了 rest 参数：

```js
let f = (...numbers) => {
  for (let a of numbers) {
    console.log(a);
  }
};
f(1, 2);
//1
//2
```

### yield 命令

不可以使用 yield 命令，因此箭头函数不能用作 Generator

## 箭头函数绑定 this

ES7 提出了“函数绑定”运算符，用来取代 call、bind、apply。虽然只是提案但是 Babel 转码器已经支持。 函数绑定运算符是并排的双冒号（::）,双冒号左边是一个对象，右边是一个函数。该运算符会自动将左边的对象作为上下文环境（this 对象）绑定到右边的函数上。

```js
foo::bar;
//等同于
bar.bind(foo);
有参数的情况下;

foo::bar(...arguments);
//等同于
bar.apply(foo, arguments);
```

如果双冒号的左边为空，右边是一个对象的方法，那么该方法的 this 就是该对象。

```js
let method = obj::obj,
  foo;
//等同于
let method = ::obj.foo;
```

由于双冒号运算符返回的还是原对象，因此可以采用链式写法。
