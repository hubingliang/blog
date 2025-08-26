---
author: Brian Hu
pubDatetime: 2017-07-11T18:59:35.000Z
title: JavaScript 继承新旧方法汇总
postSlug: JavaScript 继承新旧方法汇总
featured: false
draft: false
tags:
  - JavaScript
  - Front-end
ogImage: ""
description: 我们生成两个构造函数，后面的例子都是让‘’猫‘’继承‘’动物‘’的所有属性和方法。
---

## 例子

我们生成两个构造函数，后面的例子都是让‘’猫‘’继承‘’动物‘’的所有属性和方法。

- 动物(为了更好的理解各种继承，这里给动物附上了基本类型和引用类型)

```js
function Animal() {
  this.species = "动物";
  this.do = ["运动", "繁殖"];
}
```

- 猫

```js
function Cat(name, color) {
  this.name = name;
  this.color = color;
}
```

## 1.简单的原型链

这可能是最简单直观的一种实现继承方式了

### 1.1 实现方法

```js
function Animal() {
  this.species = "动物";
  this.do = ["运动", "繁殖"];
}
function Cat(name, color) {
  this.name = name;
  this.color = color;
}
Cat.prototype = new Animal(); //重点！！！！！
Cat.prototype.constructor = Cat;
var cat1 = new Cat("小黄", "黄色");
console.log(cat1.species); // 动物
console.log(cat1.do); // [ '运动', '繁殖' ]
```

### 1.2 核心

这种方法的核心就这一句话：Cat.prototype = new Animal 也就是拿父类实例来充当子类原型对象

### 1.3 优缺点

然而这个方法虽然简单但是有一个很严重的问题：在我们修改一个实例的属性时，其他的也随之改变。

```js
var cat1 = new Cat("小黄", "黄色");
var cat2 = new Cat("小白", "白色");
cat1.species = "哺乳动物";
cat1.do.push("呼吸");
console.log(cat1.species); // 哺乳动物
console.log(cat2.species); // 动物
console.log(cat1.do); // [ '运动', '繁殖', '呼吸' ]
console.log(cat2.do); // [ '运动', '繁殖', '呼吸' ]
```

- 优点

1.  容易实现

- 缺点

  1. 修改 cat1.do 后 cat2.do 也变了，因为来自原型对象的引用属性是所有实例共享的。
     可以这样理解：执行 cat1.do.push('呼吸');先对 cat1 进行属性查找，找遍了实例属性（在本例中没有实例属性），没找到，就开始顺着原型链向上找，拿到了 cat1 的原型对象，一搜身，发现有 do 属性。于是给 do 末尾插入了'呼吸'，所以 sub2.do 也变了

  2. 创建子类实例时，无法向父类构造函数传参

### 1.4 继承链的紊乱问题

```js
Cat.prototype = new Animal();
```

任何一个 prototype 对象都有一个 constructor 属性，指向它的构造函数。如果没有"Cat.prototype = new Animal();"这一行，Cat.prototype.constructor 是指向 Cat 的。加了这一行以后，Cat.prototype.constructor 指向 Animal。

```js
alert(Cat.prototype.constructor == Animal); //true
```

更重要的是，每一个实例也有一个 constructor 属性，默认调用 prototype 对象的 constructor 属性。因此，在运行"Cat.prototype = new Animal();"这一行之后，cat1.constructor 也指向 Animal！

```js
alert(cat1.constructor == Cat.prototype.constructor); // true
```

这显然会导致继承链的紊乱（cat1 明明是用构造函数 Cat 生成的），因此我们必须手动纠正，将 Cat.prototype 对象的 constructor 值改为 Cat。

```js
Cat.prototype.constructor = Cat;
```

这是很重要的一点，编程时务必要遵守。下文都遵循这一点，即如果替换了 prototype 对象，那么，下一步必然是为新的 prototype 对象加上 constructor 属性，并将这个属性指回原来的构造函数。

## 2. 借用构造函数

使用 call 或 apply 方法，将父对象的构造函数绑定在子对象上，即在子对象构造函数中加一行：Animal.apply(this, arguments)

### 2.1 实现方法

```js
function Animal() {
  this.species = "动物";
  this.do = ["运动", "繁殖"];
}
function Cat(name, color) {
  Animal.call(this, arguments); ///重点！！！！
  this.name = name;
  this.color = color;
}
var cat1 = new Cat("小黄", "黄色");
console.log(cat1.species); // 动物
console.log(cat1.do); // [ '运动', '繁殖' ]
```

### 2.2 核心

借父类的构造函数来增强子类实例，等于是把父类的实例属性复制了一份给子类实例装上了（完全没有用到原型）

### 2.3 优缺点

```js
var cat1 = new Cat("小黄", "黄色");
var cat2 = new Cat("小白", "白色");
cat1.species = "哺乳动物";
cat1.do.push("呼吸");
console.log(cat1.species); // 哺乳动物
console.log(cat2.species); // 动物
console.log(cat1.do); // [ '运动', '繁殖', '呼吸' ]
console.log(cat2.do); // [ '运动', '繁殖' ]
```

- 优点：

1.  解决了子类实例共享父类引用属性的问题
2.  创建子类实例时，可以向父类构造函数传参

- 缺点：

1. 无法实现函数复用，过多的占用内存。
2. 创建子类实例时，无法向父类构造函数传参

## 3. 组合继承（伪经典继承）

将原型链和借用构造函数的技术组合起来，发挥二者之长：使用原型链实现对原型属性和方法的继承，而通过借用构造函数来实现对实例属性的继承。这样，既通过在原型上定义的方法实现了函数复用，又能够保证每个实例都有它自己的属性。是实现继承最常用的方式。

### 3.1 实现方法

```js
function Animal() {
  this.species = "动物";
  this.do = ["运动", "繁殖"];
}
function Cat(name, color) {
  Animal.call(this, arguments); //重点！！！！
  this.name = name;
  this.color = color;
}
Cat.prototype = new Animal(); //重点！！！！
Cat.prototype.constructor = Cat;
var cat1 = new Cat("小黄", "黄色");
console.log(cat1.species); // 动物
console.log(cat1.do); // [ '运动', '繁殖' ]
```

### 3.2 核心

把实例函数都放在原型对象上，以实现函数复用。同时还要保留借用构造函数方式的优点，通过 Animal.call(this);继承父类的基本属性和引用属性并保留能传参的优点；通过 Cat.prototype = new Animal 继承父类函数，实现函数复用。

### 3.3 优缺点

- 优点：

1.  不存在引用属性共享问题
2.  可传参
3.  函数可复用

- 缺点:

1.  子类原型上有一份多余的父类实例属性，因为父类构造函数被调用了两次，生成了两份。(私有属性一份，原型里面一份)

## 4. 原型式

道格拉斯·克罗克福德在 2006 年写了一篇文章，Prototypal Inheritance in JavaScript(JavaScript 中的原型式继承)。在这篇文章中，他介绍了一种实现继承的方法，这种方法并没有使用严格意义上的构造函数。他的想法是借助原型可以基于已有的对象创建新对象，同时还不必因此创建自定义类型，为了达到这个目的，他给出了如下函数。

```js
function object(o) {
  function F() {}
  f.prototype = o;
  return new F();
}
```

在 object()函数内部，先创建了一个临时性的构造函数，然后将传入的对象作为这个构造函数的原型，最后返回了这个临时类型的一个新实例。从本质上讲，object()对传入其中的对象执行了一次浅拷贝。

### 4.1 实现方法

```js
function object(o) {
  function F() {}
  F.prototype = o;
  return new F();
}

function Animal() {
  this.species = "动物";
  this.do = ["运动", "繁殖"];
}
var Animal1 = new Animal();
var cat1 = object(Animal1); //重点！！！！

cat1.name = "小黄";
cat1.color = "黄色";

console.log(cat1.species); //动物
console.log(cat1.do); //["运动", "繁殖"]
```

### 4.2 核心

核心就是通过一个函数来得到一个空的新对象，再在空对象的基础上添加需要的方法（实例属性）

### 4.3 优缺点

- 优点：

1.  从已有对象衍生新对象，不需要创建自定义类型。

- 缺点:

1.  原型引用属性会被所有实例共享，因为是用整个父类对象来充当了子类
    原型对象，所以这个缺陷无可避免
2.  无法实现代码复用

## 5. 寄生式

寄生式在我看来和原型式差别不大，只是把对空对象私有属性的添加封装成了一个函数。

### 5.1 实现方法

```js
function object(o) {
  function F() {}
  F.prototype = o;
  return new F();
}

function Animal() {
  this.species = "动物";
  this.do = ["运动", "繁殖"];
}
function getCatObject(obj) {
  var clone = object(obj); //重点！！！！
  clone.name = "小黄";
  clone.color = "黄色";
  return clone;
}

var cat1 = getCatObject(new Animal());

console.log(cat1.species); //动物
console.log(cat1.do); //["运动", "繁殖"]
```

### 5.2 核心

只是给原型式继承套了一个壳子而已。
对于寄生式的理解：创建新对象 -> 增强 -> 返回该对象，这样的过程叫寄生式继承，新对象是如何创建的并不重要。

### 5.3 优缺点

- 优点：

1.  不需要创建自定义类型。

- 缺点:

1.  无法实现代码复用

## 6. 寄生组合继承

前面说过，组合继承是 JavaScript 最常用的继承模式；不过，它也有自己的不足。组合继承最大的问题就是无论什么情况下，都会调用两次超类型构造函数：一次是在创建子类型原型的时候，另一次是在子类型构造函数内部。也就是会出现这种情况：
![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675676012/blog/4337988-038d15a750ee3e97.png_htu7uf.png)
我们发现在私有属性和原型里面都有 name 和 do 的属性，这是因为调用了两次构造函数造成的后果，这必然会过多占用内存。
寄生组合继承完美的解决了这个问题。

### 6.1 实现方法

```js
function object(o) {
  function F() {}
  F.prototype = o;
  return new F();
}

function Animal() {
  this.species = "动物";
  this.do = ["运动", "繁殖"];
}
function Cat(name, color) {
  Animal.call(this, arguments); //重点！！！！
  this.name = name;
  this.color = color;
}

var proto = object(Animal.prototype); //重点！！！！
proto.constructor = Cat; //重点！！！！
Cat.prototype = proto; //重点！！！！

var cat1 = new Cat();

console.log(cat1.species); //动物
console.log(cat1.do); //["运动", "繁殖"]
```

### 6.2 核心

用 object(Animal.prototype)切掉了原型对象上多余的那份父类实例属性

### 6.3 优缺点

- 优点：

1.  几乎完美

- 缺点:

1.  用起来有些麻烦，理论上没有缺点。

## 7. ES5 使用 Object.create 创建对象

ECMAScript 5 中引入了一个新方法：[Object.create()
](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Object/create)。可以调用这个方法来创建一个新对象。新对象的原型就是调用 create 方法时传入的第一个参数：

```js
var a = { a: 1 };
// a ---> Object.prototype ---> null

var b = Object.create(a);
// b ---> a ---> Object.prototype ---> null
console.log(b.a); // 1 (继承而来)

var c = Object.create(b);
// c ---> b ---> a ---> Object.prototype ---> null

var d = Object.create(null);
// d ---> null
console.log(d.hasOwnProperty); // undefined, 因为d没有继承Object.prototype
```

## 8. ES6 使用 class 关键字

ECMAScript6 引入了一套新的关键字用来实现 [class](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Classes)。使用基于类语言的开发人员会对这些结构感到熟悉，但它们是不一样的。 JavaScript 仍然是基于原型的。这些新的关键字包括 [class
](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Statements/class), [constructor
](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Classes/constructor), [static
](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Classes/static), [extends
](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Classes/extends), 和 [super
](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Operators/super).
例子如下：

```js
class Animal {
  constructor(species, canDo) {
    this.species = "动物";
    this.canDo = ["运动", "繁殖"];
  }
}

class Cat extends Animal {
  constructor(name, color) {
    super();
    this.name = name;
    this.color = color;
  }
}
var cat1 = new Cat("小黄", "黄色");
console.dir(cat1);
```

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675675992/blog/4337988-fb5013616b04ead4.png_ckryze.png)

## 9. 参考文献

- [JavaScript 高级程序设计（第 3 版）6.3 继承](https://book.douban.com/subject/10546125/)
- [阮一峰博客-Javascript 面向对象编程（二）：构造函数的继承](http://www.ruanyifeng.com/blog/2010/05/object-oriented_javascript_inheritance.html)
- [重新理解 JS 的 6 种继承方式](http://www.cnblogs.com/ayqy/p/4471638.html)
- [MDN-Class](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Statements/class)
