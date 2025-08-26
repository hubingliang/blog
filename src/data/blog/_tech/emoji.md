---
author: Brian Hu
pubDatetime: 2017-09-17T09:55:55.000Z
title: 如何在你的项目中引入 emoji 😀
postSlug: 如何在你的项目中引入 emoji 😀
featured: false
draft: false
tags:
  - Library
  - Front-end
ogImage: ""
description: 最近在做我们学校的表白墙网站，在做到评论功能的时候自然而然就想到了emoji-😏
---

最近在做我们学校的[表白墙网站](https://hubingliang.github.io/Confession-wall/dist/)，在做到评论功能的时候自然而然就想到了 emoji-😏。
于是就去搜了一些这方面的资料，发现了比较好的三个 emoji 库：

- [emojione](https://github.com/emojione/emojione)（第一个开源且完整的 emoji 网站，编码方面 100%免费，且与项目有非常好的整合性）
- [Twemoji](https://github.com/twitter/twemoji) (完全免费，简单小巧，API 相比 emojione 较少。)
- [Twemoji Awesome](http://ellekasai.github.io/twemoji-awesome/) (Twemoji 社区的项目，纯 css 显示 emoji)

综合考虑最后选择了 emojione 来实现，因为 API 比较多而且文档十分友好。

## 引入 emojione

- 通过外链

```html
<script src="https://cdn.jsdelivr.net/npm/emojione@3.1.2/lib/js/emojione.min.js"></script>
<link
  rel="stylesheet"
  href="https://cdn.jsdelivr.net/npm/emojione@3.1.2/extras/css/emojione.min.css"
/>
```

- NPM

```
> npm install emojione
```

## 生成 emoji 选择界面

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675675180/blog/4337988-ef3ae78893a558c3.png_llucms.png)

首先我们需要这些 emoji 的图片，随即我就去[emojione](https://www.emojione.com/developers/download)官网下载了 32×32px 的 PNG 图片，可是之后我发现图片太多不可能让我一个一个引入吧！

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675675204/blog/4337988-21d1a6f7e13a2288.png_e4bun0.png)

转变思路，去看 emojione 的[文档](https://github.com/emojione/emojione)，发现了一个提供 API 演示功能的[emojione 实验室](https://demos.emojione.com/latest/index.html## extras)。

实验室中有一个 API 可以把 HTML 中的 unicode 转换为图片：[.unicodeToImage(str)](https://demos.emojione.com/latest/jsunicodetoimage.html)

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675675227/blog/4337988-baca09028eec4ae2.png_c75wsi.png)

于是我用 JS Bin 做了一个小[demo](http://js.jirengu.com/vupel/2/edit)测试了一下,发现没有什么问题。

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675675240/blog/4337988-2650383b4132fa9d.png_laoonx.png)

OK，那么我们就可以通过这个 API 批量生成 emoji 的图片了，可是 emoji 的 Unicode 码去哪找呢？
官方提供了一个 Unicode 复制粘贴的网站：[emojiCOPY](https://www.emojicopy.com/)

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675675267/blog/4337988-a391a9796b5010fd.png_izrugj.png)

选中想要的 emoji，之后点击 COPY 就可以复制下来，然后再粘贴到刚才的 JS Bin 之中就可以批量生成图片了：

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675675254/blog/4337988-9f47be5f280a88f1.png_wtcotz.png)

之后把这些图片的 HTML 直接复制到我们的项目之中：

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675675279/blog/4337988-45fb81e4f83df1d4.png_r6jcwq.png)

让人惊喜的是这些生成的 img 的 alt 是 Unicode，这让 input 显示和用户点击同步也变得简单了。

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675675290/blog/4337988-19fd42f9cf8aa49b.png_dhwtet.png)

接下来只需要写很简单的 JS 就可以实现了：

```js
$(".emoji")
  .children()
  .click(emoji => {
    comment = comment + " " + emoji.target.alt + " ";
  });
```

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675675305/blog/4337988-c0ae294af0d711b5.png_ea6k48.png)

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675675318/blog/4337988-64fbd4090a322e38.png_km4zfq.png)
