---
author: Brian Hu
pubDatetime: 2018-03-29T13:23:02.000Z
title: 使用 ColorfulImg 获取图片主题色！
postSlug: 使用 ColorfulImg 获取图片主题色！
featured: false
draft: false
tags:
  - Front-end
ogImage: "https://res.cloudinary.com/dewu7okpv/image/upload/v1675674464/blog/165c960c72a38dae_tplv-t2oaga2asx-zoom-in-crop-mark_3024_0_0_0_uukfjz.webp"
description: 前几天遇到了获取图片主题色的需求，于是去找了一些相关的博客，发现实现起来相当简单，于是自己开发了一个获取图片主题色的网站
---

## 取色网站

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675674464/blog/165c960c72a38dae_tplv-t2oaga2asx-zoom-in-crop-mark_3024_0_0_0_uukfjz.webp)
前几天遇到了获取图片主题色的需求，于是去找了一些相关的博客，发现实现起来相当简单，于是自己开发了一个获取图片主题色的网站---[ColorfulImg](https://hubingliang.github.io/colorfulImg/dist/)
大家可以通过上传/拖拽图片的方式获取图片主题色。

欢迎 Star~

## ColorfulImg

Colorfulimg 是一个能够通过 canvas 获取图片主题色的 js 工具库。

安装：

`npm i colorfulimg `

使用方法：

```js
let colorfulimg = require("colorfulimg");
let myImg = document.getElementById("myImg");
let rgb = colorfulImg(myImg);
```

[这是项目地址](https://github.com/hubingliang/colorfulImg)

欢迎 star~

## ColorfulImg 实现思路

下面说一下实现思路，主要是通过[canvas](https://developer.mozilla.org/zh-CN/docs/Web/API/Canvas_API/Tutorial)的[getImageData()](https://developer.mozilla.org/zh-CN/docs/Web/API/ImageData)方法获取图片每个像素点的 rgba 数据。通过取得平均值的方法来算出图片主题色。
所以要想实现此效果有两个限制：

- 网站和图片必须是相同的域名（getImageData()限制图片必须同源）
- 浏览器必须支持 canvas

### 在 canvas 中绘制 img 图像

1. 首先我们要新建一个 canvas 标签并且访问它的绘画上下文：

```js
let canvas = document.createElement("canvas");
let context = canvas.getContext && canvas.getContext("2d");
```

2. 绘制 img 图像，X 轴与 Y 轴的起始点都设置为 0：

```js
let myImg = document.getElementById("myImg");
context.drawImage(myImg, 0, 0);
```

### 获取图片颜色数据 getImageData()

[getImageData()](https://developer.mozilla.org/zh-CN/docs/Web/API/ImageData)这个 API 需要四个参数，前两个是获取图片数据的起点，后两个是提取的图像数据矩形区域的宽度和高度，我们要得到图片全部的数据所以后两个参数就是图片的宽高，于此同时我们也要把 canvas 的宽高设置为图片的宽高能完全装下图片。

```js
let height = (canvas.height = imgEl.height);
let width = (canvas.width = imgEl.width);
let data = context.getImageData(0, 0, width, height).data;
```

在我第一次测试的时候遇到了跨域的问题：

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675674379/blog/165c960c72b06536_tplv-t2oaga2asx-zoom-in-crop-mark_3024_0_0_0_hncw5m.webp)

图片如果不同源的话必须要加`crossorigin="anonymous"`的属性，并且服务器存储那边也要开放相应的权限才行。
`<img id="img" crossorigin="anonymous">`

### 处理获取的颜色数据

我们先 log 一下拿到的数据是什么吧：

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675674406/blog/165c960c72cc7c75_tplv-t2oaga2asx-zoom-in-crop-mark_3024_0_0_0_dx2fzk.webp)

是一个有着一堆数据的数组，这些数据是什么呢？我们先看一下 MDN：

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675674434/blog/165c960c72e4542f_tplv-t2oaga2asx-zoom-in-crop-mark_3024_0_0_0_tqo20d.webp)

也就是说按顺序来看前四位组成一个以 RGBA 顺序的数据：
**rgba(red, green, blue, alpha)**

对于获取的图片数据透明度（alpha）都是 255 也就是不透明的所以我们不对透明度做处理，之后我们只需要把 rgb 的其他三个值分别求和再取均值就可以得到图片的主题色了！

```js
let count = 0;
let i = 0;
let blockSize = 1;
while ((i += blockSize * 4) < length) {
  ++count;
  rgb.r = data[i] + rgb.r;
  rgb.g = data[i + 1] + rgb.g;
  rgb.b = data[i + 2] + rgb.b;
}
rgb.r = ~~(rgb.r / count);
rgb.g = ~~(rgb.g / count);
rgb.b = ~~(rgb.b / count);
```

### 最终代码

```js
function colorfulImg(img) {
  let canvas = document.createElement("canvas"),
    context = canvas.getContext && canvas.getContext("2d"),
    height,
    width,
    length,
    data,
    i = -4,
    blockSize = 5,
    count = 0,
    rgb = { r: 0, g: 0, b: 0 };

  height = canvas.height = imgEl.height;
  width = canvas.width = imgEl.width;
  context.drawImage(imgEl, 0, 0);
  data = context.getImageData(0, 0, width, height).data;
  length = data.length;
  while ((i += blockSize * 4) < length) {
    ++count;
    rgb.r += data[i];
    rgb.g += data[i + 1];
    rgb.b += data[i + 2];
  }
  rgb.r = ~~(rgb.r / count);
  rgb.g = ~~(rgb.g / count);
  rgb.b = ~~(rgb.b / count);
  return rgb;
}
```
