---
author: Brian Hu
pubDatetime: 2017-04-29T12:31:12.000Z
title: 搞懂 Z-index 的所有细节
postSlug: 搞懂 Z-index 的所有细节
featured: false
draft: false
tags:
  - CSS
ogImage: "https://res.cloudinary.com/dewu7okpv/image/upload/v1675680091/blog/4337988-da32ea3f63d9b3c2.png_xtgtmg.png"
description: Z-index 的运用是需要条件的,与其相关的属性就是 position 属性。我们以三个 div 来举例子。
---

![用Z-index来改变堆叠顺序](http://upload-images.jianshu.io/upload_images/4337988-72fc3279283f3d96.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

[Z-index 测试网站](http://www.cssmojo.com/extras/everything_you_always_wanted_to_know_about_z-index_but_were_afraid_to_ask/)

## z-index 在什么情况下才生效？

Z-index 的运用是需要条件的,与其相关的属性就是 position 属性。我们以三个 div 来举例子。

- position: static;

当三个 div 的 position 都为 static 时,我们把 div(A)的 Z-index 设置为 15, 把 div(B)的 Z-index 设置为 10,把 div(C)的 Z-index 设置为 5。

![](http://upload-images.jianshu.io/upload_images/4337988-dc45d7a26386344b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**发现 div(B)依然把 div(A)的一部分挡住了,所以当 position 为 static 时,Z-index 起不到任何改变堆叠的作用。**

- position: relative/absolute/fixed;

当三个 div 的 position 都为 relative/absolute/fixed 时,发现 Z-index 生效。
![](http://upload-images.jianshu.io/upload_images/4337988-b3b78915180bd5e3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**总结: 只有 position 的值为 relative/absolute/fixed 中的一个,Z-index 才会生效。**

## z-index 值越大元素越靠前，对吗？

我们现在 div(A)和 div(B)中再分别创建一个小的 div(c)和 div(d)

![这一张图就是一个特例](https://res.cloudinary.com/dewu7okpv/image/upload/v1675680050/blog/4337988-8330fa3e640fe19e.png_akr9bt.png)

我们观察到,div(a)的 Z-index 为 20 可是为什么还会被 Z-index 仅仅为 10 的 div(B)遮挡住呢?
难道是因为 Z-index 继承给他的子元素了吗?不 Z-index 可是不继承给它的子元素的。
我们试试把 biv(A)的 Z-index 设置成 auto

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675680061/blog/4337988-e92ccbadb3ad1561.png_auuetw.png)

div(a)成功的遮挡住了 Z-index 比他小的元素。

再试试只把 div(a)设置为 auto

![Paste_Image.png](https://res.cloudinary.com/dewu7okpv/image/upload/v1675680079/blog/4337988-e4724db7e354c034.png_roxdqa.png)

## 总结:

1. 当 Z-index 的值设置为 auto 时,不建立新的堆叠上下文,当前堆叠上下文中生成的 div 的堆叠级别与其父项的框相同。
2. 当 Z-index 的值设置为一个整数时,该整数是当前堆叠上下文中生成的 div 的堆栈级别。该框还建立了其堆栈级别的本地堆叠上下文。这意味着后代的 z-index 不与此元素之外的元素的 z-index 进行比较。

ps: 通俗讲就是,当一个 div 的 Z-index 为整数时,它的子元素和外界元素进行比较时,采用父元素的 Z-index 进行比较, 和兄弟元素比较采用自身的 Z-index。当一个 div 的 Z-index 为 auto 时,如果它和它的兄弟进行比较,采用它父元素的 Z-index。

## z-index 不设置和设置为 0 有什么区别?

如果不设置 Z-index 那么默认值为 auto,则不建立层叠上下文。设置为 0 则会脱离文档流,建立层叠上下文。
![文档流Z轴](https://res.cloudinary.com/dewu7okpv/image/upload/v1675680091/blog/4337988-da32ea3f63d9b3c2.png_xtgtmg.png)
