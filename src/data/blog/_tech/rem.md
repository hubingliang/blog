---
author: Brian Hu
pubDatetime: 2017-10-07T08:31:46.000Z
title: rem 方案完美解决自适应
postSlug: rem 方案完美解决自适应
featured: false
draft: false
tags:
  - CSS
  - Front-end
ogImage: "https://res.cloudinary.com/dewu7okpv/image/upload/v1675676126/blog/4337988-bc2b886890d0962a.png_f3slaw.png"
description: 随着移动互联网的兴起，Web app的开发也越来越重要，与此同时页面布局也成了一个令人头痛的问题。rem的出现貌似可以完美解决移动端适配的问题。
---

随着移动互联网的兴起，Web app 的开发也越来越重要，与此同时页面布局也成了一个令人头痛的问题。rem 的出现貌似可以完美解决移动端适配的问题。

## 什么是 rem

说到 rem 自然就会想到 em，我们知道 em 是相对于父元素的字体大小的单位，那么 rem 则是相对于根元素也就是`<html>`元素的字体大小的单位。

## 如何用 rem 解决移动端适配

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675676126/blog/4337988-bc2b886890d0962a.png_f3slaw.png)

通过这张图我们就可以观察到，div 的宽度和高度是根据根元素`<html>`来决定的，根元素的字体大小为 100px，然后给 div 的宽度和高度设置为 2rem、1rem，最后生成的 div 的宽度为 200px、高度为 100px。
也就是说我们可以通过改变根元素的字体大小，进而对页面进行等比例缩放,从而实现自适应。
那么如何根据设备的不同来改变根元素的字体大小呢？
我们在`<head>`标签里面引入这样一段 js 代码：

```js
var width = document.documentElement.clientWidth;
var css = `
    html{
    font-size: ${width / 10}px;
    }
    `;
document.write(`<style>${css}</style>`);
```

很简单，只做了一件事：就是把根元素的字体大小改成当前设备的宽度，然后我们在开发的时候全部根据设计稿的宽度来设置每一个元素的大小。
如果设计稿的宽度是按照 iphone5 的宽度来设计的，那么开发的时候也要根据 iphone 的宽度也就是 320px 来设置。

> 不过最后不要忘了在 body 元素中重新设置正常的 font-size，不然整个页面会垮掉！！

例子：如果这是我们要做的设计稿

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675676112/blog/4337988-591bb00dccbcc0f0.png_afgxkp.png)

一个歌单的封面大小为 103px，那么我们在写 css 的时候就要写（103/320）px，这时候你肯定会觉得很麻烦，难道我每次都要这样计算吗？
不用，每次只要写出实际的 px 大小就好，px 和 rem 的转换可以借助网站工具：
[px => rem](http://520ued.com/tools/rem)
[功能更加强大的 rem 转换](http://alurk.com/)

## 参考文献

- [rem 是如何实现自适应布局的？](http://caibaojian.com/web-app-rem.html)
- [rem 自适应布局的回顾总结](http://caibaojian.com/rem-responsive-2.html)
