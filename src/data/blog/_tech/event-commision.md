---
author: Brian Hu
pubDatetime: 2017-04-17T09:20:22.000Z
title: 使用原生 JS 实现事件委托
postSlug: 使用原生 JS 实现事件委托
featured: false
draft: false
tags:
  - JavaScript
  - Front-end
ogImage: "@/assets/images/tech/sudharshan-tk-mM9vVJ2oDeI-unsplash.jpg"
description: 什么是事件委托?用个例子就可以很简单的解释事件委托是怎么一回事了：
---

## 什么是事件委托?

用个例子就可以很简单的解释事件委托是怎么一回事了：

> 假设一个公司有三个职员在网上买了东西,那么他们三个在接收快递的时候有两种方法。
> 第一种：等快递来的时候,自己下楼去拿。
> 第二种：快递来的时候,先经过公司前台,然后在分发给每个人。
> 然而,正常情况下,第一种显然比较浪费劳动力,所以现实情况我们都采取第二种方法。
> 而且,第二种方法有个优势,新加入的职员也可以享受代签快递的服务。

我们把场景换到网页上：

> 假设一个网页中有三个 li,并且绑定了事件,那么它们三个在触发事件的时候有两种方法。
> 第一种：当用户点击了 li 的时候,li 触发事件
> 第二种：当用户点击了 ul 的时候,ul 中的 li 触发事件
> 优势,显而易见就是新加入的 li 也可以通过 ul 触发。

也就是说事件委托,就是把本该由 li 触发的事件,交由 ul 代理。

## 为什么要用事件委托?

道理我都懂,可为什么要交给 ul 委托呢?我把每个 li 都绑定一遍不好吗?

**一般来说，dom 需要有事件处理程序，我们都会直接给它设事件处理程序就好了，那如果是很多的 dom 需要添加事件处理呢？比如我们有 100 个 li，每个 li 都有相同的 click 点击事件，可能我们会用 for 循环的方法，来遍历所有的 li，然后给它们添加事件，那这么做会存在什么影响呢？**

在 JavaScript 中，添加到页面上的事件处理程序数量将直接关系到页面的整体运行性能，因为需要不断的与 dom 节点进行交互，访问 dom 的次数越多，引起浏览器重绘与重排的次数也就越多，就会延长整个页面的交互就绪时间，这就是为什么性能优化的主要思想之一就是减少 DOM 操作的原因；如果要用事件委托，就会将所有的操作放到 js 程序里面，与 dom 的操作就只需要交互一次，这样就能大大的减少与 dom 的交互次数，提高性能；

每个函数都是一个对象，是对象就会占用内存，对象越多，内存占用率就越大，自然性能就越差了（内存不够用，是硬伤，哈哈），比如上面的 100 个 li，就要占用 100 个内存空间，如果是 1000 个，10000 个呢，那只能说呵呵了，如果用事件委托，那么我们就可以只对它的父级（如果只有一个父级）这一个对象进行操作，这样我们就需要一个内存空间就够了，是不是省了很多，自然性能就会更好。

## 事件委托的原理

### 冒泡

事件委托是利用事件的冒泡原理来实现的，何为事件冒泡呢？举个例子：

1. 先创建三个不同颜色的 div,X>Y>Z
   ![我们先创建三个div](https://res.cloudinary.com/dewu7okpv/image/upload/v1675675662/blog/4337988-37693187845a65bf.png_ewqokx.png)
2. 然后分别给 XYZ 绑定事件
   ![绑定事件](https://res.cloudinary.com/dewu7okpv/image/upload/v1675675675/blog/4337988-45f36ee353bd2325.png_i210np.png)
3. 然后就可以测试冒泡事件了,我们先点击一下最里面的黄色 div,发现三个事件都触发了
   ![三个事件都触发了](https://res.cloudinary.com/dewu7okpv/image/upload/v1675675688/blog/4337988-01f625531f219e2f.png_ecyl0e.png)
4. 我们再点击一下绿色 div,发现只触发了绿色 div 和红色 div 的事件.
   ![只触发了绿色div和红色div的事件](https://res.cloudinary.com/dewu7okpv/image/upload/v1675675699/blog/4337988-8561b9f82d4e7ba2.png_bly3xt.png)
5. 所以我们可以总结,事件冒泡的规则就是事件从最深的节点开始，然后逐步向上传播事件。同时这也是事件委托，委托它们父级代为执行事件。

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675675713/blog/4337988-ef026ce54d376fb4.png_kvn4hp.png)

## 如何实现委托?

既然是委托,那么直接给 li 的父级 ul 绑定事件就可以了啊。但是这里存在一个 BUG!
我们换个例子：
ul 下有 4 个 li,并且给 ul 绑定事件,为了方便演示给 ul 和 li 加一个 border
![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675675725/blog/4337988-241d910a7679af62.png_tnj16t.png)

**BUG 就是当我们点击红色和绿色之间的时候也会触发事件!!!**

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675675737/blog/4337988-fe134b3f88648ae4.png_tfremh.png)

那么这个 BUG 如何处理呢?
**如果在用户点击的时候判断一下是不是点击了 li，如果是就触发，如果不是就不触发，是不是就解决了?**

![加一步判断](https://res.cloudinary.com/dewu7okpv/image/upload/v1675675748/blog/4337988-b1b6387fe832c2bd.png_two7uh.png)
这样看似成功了,只有点击了 li 才会触发事件.
**但是并不完美,因为当 li 有子元素的时候就会失效!!!**

![这个时候点击选项1的时候并不触发事件](https://res.cloudinary.com/dewu7okpv/image/upload/v1675675761/blog/4337988-fd45f15459ce67ee.png_rtcmvx.png)

那么我们该如何继续优化呢?
当我们发现被点击的元素不是 li 的时候,那么我们就找被点击元素的父元素,判断它是不是 li,如果不是就继续找.......以此类推,当我们找到 li 那么就触发事件,如果没找到,就不触发。

![触发成功](https://res.cloudinary.com/dewu7okpv/image/upload/v1675675775/blog/4337988-826d7b2b9b2ad110.png_v3tcue.png)
最终代码:

```js
var ul = document.querySelector(".a");
ul.addEventListener("click", function (e) {
  var 被点击的元素 = e.target;
  while (被点击的元素.tagName !== "LI") {
    被点击的元素 = 被点击的元素.parentNode;
    if (被点击的元素 === ul) {
      被点击的元素 = null;
      break;
    }
  }
  if (被点击的元素) {
    console.log("触发成功");
  }
});
```
