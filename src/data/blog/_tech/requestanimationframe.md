---
author: Brian Hu
pubDatetime: 2018-05-20T09:42:21.000Z
title: 使用 requestAnimationFrame 来提升动画性能
postSlug: 使用 requestAnimationFrame 来提升动画性能
featured: false
draft: false
tags:
  - JavaScript
  - Front-end
ogImage: ""
description: 在实际项目中我们经常会遇到生成动画的需求，传统方法是通过使用setTimeout和setInterval进行实现，但是定时器动画有两个弊端
---

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675676273/blog/1637ddf84e9110d6_tplv-t2oaga2asx-zoom-in-crop-mark_3024_0_0_0_brituv.webp)

## 传统动画的弊端

在实际项目中我们经常会遇到生成动画的需求，传统方法是通过使用 setTimeout 和 setInterval 进行实现，但是定时器动画有两个弊端：

- 时间间隔并不好拿捏，设置太短浏览器重绘频率太快会产生性能问题，太慢的话又显得像 PPT 不够平滑，业界推荐的时间间隔是 16.66...（显示器刷新频率是 60Hz，1000ms/60）
- 浏览器 UI 线程堵塞问题，如果 UI 线程之中有很多待完成的渲染任务，所要执行的动画就会被搁置。

为了解决这些问题 HTML5 加入了 requestAnimationFrame

## requestAnimationFrame？

[MDN](https://developer.mozilla.org/zh-CN/docs/Web/API/Window/requestAnimationFrame)

> window.requestAnimationFrame() 方法告诉浏览器您希望执行动画并请求浏览器在下一次重绘之前调用指定的函数来更新动画。该方法使用一个回调函数作为参数，这个回调函数会在浏览器重绘之前调用。

- requestAnimationFrame 会把每一帧中的所有 DOM 操作集中起来，在一次重绘或回流中就完成，并且重绘或回流的时间间隔紧紧跟随浏览器的刷新频率

- 在隐藏或不可见的元素中，requestAnimationFrame 将不会进行重绘或回流，这当然就意味着更少的 CPU、GPU 和内存使用量

- requestAnimationFrame 是由浏览器专门为动画提供的 API，在运行时浏览器会自动优化方法的调用，并且如果页面不是激活状态下的话，动画会自动暂停，有效节省了 CPU 开销

## 用法

你可以直接调用`requestAnimationFrame()`，也可以通过 window 来调用`window.requestAnimationFrame()`。
requestAnimationFrame()接收一个函数作为回调，返回一个 ID 值，通过把这个 ID 值传给`window.cancelAnimationFrame()`可以取消该次动画。

MDN 上给的例子：

```js
var start = null;
var element = document.getElementById("SomeElementYouWantToAnimate");
element.style.position = "absolute";

function step(timestamp) {
  if (!start) start = timestamp;
  var progress = timestamp - start;
  element.style.left = Math.min(progress / 10, 200) + "px";
  if (progress < 2000) {
    window.requestAnimationFrame(step);
  }
}
```

## 例子

我们来试试生成一个旋转并逐渐变窄的方块，当窄到一定程度又会复原循环往复。
[jsbin 看看效果](http://jsbin.com/xeferik/3/edit?js,output)

```js
var rotate = 0;
var width = 400;
var element = document.getElementById("box");

function step(timestamp) {
  rotate += 10;
  element.style.transform = `rotate(${rotate}deg)`;
  window.requestAnimationFrame(step);
}

function small(timestamp) {
  width = width - 1;
  element.style.width = width + "px";
  if (width <= 50) {
    window.requestAnimationFrame(big);
  } else {
    window.requestAnimationFrame(small);
  }
}
function big() {
  width = width + 1;
  element.style.width = width + "px";
  if (width >= 400) {
    window.requestAnimationFrame(small);
  } else {
    window.requestAnimationFrame(big);
  }
}

window.requestAnimationFrame(step);
window.requestAnimationFrame(small);
```

## 浏览器兼容情况

我们来看一下[Can I Use](https://caniuse.com/## search=requestAnimationFrame)上的兼容情况：
![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675676294/blog/1637d6be4df448ce_tplv-t2oaga2asx-zoom-in-crop-mark_3024_0_0_0_f3cs52.webp)
requestAnimationFrame 的兼容情况还是不错的（看不见 IE）

如果非要兼容 IE 的话可以用定时器来做一下兼容：

```js
(function () {
  var lastTime = 0;
  var vendors = ["webkit", "moz"];
  for (var x = 0; x < vendors.length && !window.requestAnimationFrame; ++x) {
    window.requestAnimationFrame = window[vendors[x] + "RequestAnimationFrame"];
    window.cancelAnimationFrame =
      window[vendors[x] + "CancelAnimationFrame"] ||
      window[vendors[x] + "CancelRequestAnimationFrame"];
  }

  if (!window.requestAnimationFrame)
    window.requestAnimationFrame = function (callback) {
      /*调整时间，让一次动画等待和执行时间在最佳循环时间间隔内完成*/
      var currTime = new Date().getTime();
      var timeToCall = Math.max(0, 16 - (currTime - lastTime));
      var id = window.setTimeout(function () {
        callback(currTime + timeToCall);
      }, timeToCall);
      lastTime = currTime + timeToCall;
      return id;
    };

  if (!window.cancelAnimationFrame)
    window.cancelAnimationFrame = function (id) {
      clearTimeout(id);
    };
})();
```
