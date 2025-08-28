---
author: Brian Hu
pubDatetime: 2019-04-18T09:21:54.000Z
title: 如何打造一款自己的 VSCode 主题？
postSlug: 如何打造一款自己的 VSCode 主题？
featured: false
draft: false
tags:
  - Library
  - Front-end
  - VScode
ogImage: "https://res.cloudinary.com/dewu7okpv/image/upload/v1675679420/blog/16a30374038ac5db_tplv-t2oaga2asx-zoom-in-crop-mark_3024_0_0_0_auwz0t.webp"
description: 我之前一直用 **One Dark Pro** 后来又转到 **Material Theme Palenight** 再到后来的 **Dracula** 。总觉得有些配色很奇怪（工作太闲），于是写了一个 VSCode 深色主题：
---

我之前一直用 **One Dark Pro** 后来又转到 **Material Theme Palenight** 再到后来的 **Dracula** 。总觉得有些配色很奇怪（工作太闲），于是写了一个 VSCode 深色主题：[Duang](https://github.com/hubingliang/Duang)，之所以叫 Duang 是因为它很黑，很亮，很柔....

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675679420/blog/16a30374038ac5db_tplv-t2oaga2asx-zoom-in-crop-mark_3024_0_0_0_auwz0t.webp)

[大家可以在这下载体验](https://marketplace.visualstudio.com/items?itemName=Brownhu.duang)

[github 在这里](https://github.com/hubingliang/Duang)

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675679460/blog/16a303c83daf3bb6_tplv-t2oaga2asx-zoom-in-crop-mark_3024_0_0_0_yazsrs.webp)

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675679485/blog/16a3062d5015d575_tplv-t2oaga2asx-zoom-in-crop-mark_3024_0_0_0_rk1xrs.webp)

如果你也对编辑器有自己独特风格的偏好，但是在成千上万款主题中又没有一款主题完全符合你的口味，那么跟着下面的流程我们自己动手做一个完全符合自己风格的主题吧。

---

## 注册你的开发者帐号和配置 token

如果你安装过其他的 VSCode 主题的话应该知道，所有主题都属于 VSCode 插件。那么要开发插件，必不可少的工具就是 [vsce](https://github.com/Microsoft/vscode-vsce)，这个是官方管理插件的工具，所有插件都通过这个工具来发布。

如果你英文够好，建议看 VSCode 官网的这篇[文章](https://code.visualstudio.com/api/working-with-extensions/publishing-extension)来学习从申请账号到发布插件的整个流程，非常详细。当然也可以跟着我后面的流程一起。

首先全局安装 **vsce** :

```
npm install -g vsce
```

之后你需要去注册一个账号，网址在这：[Azure DevOps Services | Microsoft Azure](https://azure.microsoft.com/zh-cn/services/devops/)

登陆之后，首先新建一个 **public** 项目:

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675679513/blog/16a2fc45a7e1f7c1_tplv-t2oaga2asx-zoom-in-crop-mark_3024_0_0_0_czg1k9.webp)

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675679532/blog/16a2fbc998050c96_tplv-t2oaga2asx-zoom-in-crop-mark_3024_0_0_0_ueqws3.webp)

然后获取你的 **Personal access tokens** ，点击右上角的头像，点击 **Security**。

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675679552/blog/16a2fc9eafaf6678_tplv-t2oaga2asx-zoom-in-crop-mark_3024_0_0_0_vhuxyz.webp)

为你的 **token** 指定一个名称，时间的话最长到期可以设置为一年。

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675679570/blog/16a2fcf53e722c4a_tplv-t2oaga2asx-zoom-in-crop-mark_3024_0_0_0_xtfsl7.webp)

点击查看所有的配置项，找到 **Marketplace** 并选择 **Acquire** and **Manage**：

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675679588/blog/16a2fd0406d2c348_tplv-t2oaga2asx-zoom-in-crop-mark_3024_0_0_0_d69k7e.webp)

点击 **Create** ，复制生成的 **token**，之后就要用到我们刚才安装的 **vsce** 来创建新的发布者（publisher）

```
vsce create-publisher (发布者的名字)
```

回车之后会依次提示输入**name**、**email**，和你刚刚复制的 **token**。

现在你可以通过下面这个命令来登陆:

```
vsce login (发布者的名字)
```

到此为止我们第一步就完成了，不要觉得繁琐，因为这些我们只需要配置一次就好了，每次开发插件的时候都不用重复这些操作。

如果你遇到文中没有提到的问题，我继续建议你看官方这两篇文章

- [创建账号](https://docs.microsoft.com/zh-cn/azure/devops/organizations/accounts/create-organization?view=azure-devops)
- [发布扩展](https://code.visualstudio.com/api/working-with-extensions/publishing-extension)

---

## 用脚手架生成基本的插件代码

之后我们需要安装一个脚手架工具：

```
npm install -g yo generator-code
```

然后运行下面的命令 👇，它可以在任何目录中生成一套基本的插件代码：

```
yo code
```

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675679609/blog/16a2fe0fab9fb691_tplv-t2oaga2asx-zoom-in-crop-mark_3024_0_0_0_fhwsyy.webp)

我们要开发一个主题，所以选中 **New Color Theme**，之后会继续询问你是否新建主题还是从现有主题导入，我们这里选创建一个全新的。

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675679623/blog/16a2fe3e4302080e_tplv-t2oaga2asx-zoom-in-crop-mark_3024_0_0_0_wegl0p.webp)

之后还会问你一些问题：

- 插件名字
- 标识符
- 描述 （这个后面可以在**package.json**里面改）
- 发布者的名字 (见前文)
- 对于用户这个插件的名字
- 这个主题是 dark 还是 light 还是高对比度

之后就会为我们生成一套主题插件的基本代码，到此为止我们已经完成了 80%了，剩下的就只需要更改生成目录 **themes** 下的 **json** 文件就可以了，但是....

---

## 修改 themes 下的 json 文件

看似很简单的事情，其实是我认为最难的，因为要设计一款，好看的主题，配色真的太难了！！！

很多我以为会很好看的颜色，改进去却 like a shit....

em.....扯远了

首先用 VSCode 打开生成的目录，我们看到结构如下：

![221555584047_.pic_hd.jpg](https://res.cloudinary.com/dewu7okpv/image/upload/v1675679641/blog/16a3009f1663e799_tplv-t2oaga2asx-zoom-in-crop-mark_3024_0_0_0_p7omf3.webp)

之后我们的工作都会在 **themes** 下的 **json** 文件展开，不要害怕，我们其实不需要看完这几百上千行 json 文件的意思。

首先我们先进去调试模式，看看脚本自动生成的主题是什么样子的：

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675679658/blog/16a300dbfbd72558_tplv-t2oaga2asx-zoom-in-crop-mark_3024_0_0_0_d05al1.webp)

点击调试，会自动打开一个新的 VSCode 窗口展示预设的主题。

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675679677/blog/16a301018c9aec7d_tplv-t2oaga2asx-zoom-in-crop-mark_3024_0_0_0_z2befs.webp)

接下来 **Command + Shift + P** 输入 **Developer: Inspect TM Scopes**

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675679694/blog/16a30132c4f482c7_tplv-t2oaga2asx-zoom-in-crop-mark_3024_0_0_0_c6o4po.webp)

现在你可以看文件中每一个字符的颜色配置在哪了，只需要在 json 文件里搜对应的配置就好了。

如果你觉得不习惯，你甚至可以打开和 **Chrome** 一样的开发者工具，快捷键是 **option + command + i**

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675679712/blog/16a3015c6f12955f_tplv-t2oaga2asx-zoom-in-crop-mark_3024_0_0_0_v5jb7g.webp)

不过我还是建议你用第一种方法，因为开发者工具有时候搜到颜色，但是你找不到配置项。

---

## 配色方案

如果你现在一无所措，改了一些颜色也不尽如人意，那就看下我的配色建议：

首先我的建议是，直接抄你喜欢或者成熟主题对应的 **json**文件，比如 **One Dark Pro** 、**Material Theme Palenight**、**Dracula**

之所以这样是因为出于几个考虑：

1. 脚手架的配置项并不齐全，比如底部状态栏和侧边栏甚至光标的颜色都没有，而比较成熟下载量多的主题边边角角都配置到了，我们拿过来把对应的颜色全局替换就好了，不用再去官网上找对应的配置项。
2. 并不是每种类型的字符配一种颜色，很多类型是复用同一种颜色的，但是对应关系并不好找，所以如果我们看到一个改一个很容易改的乱七八糟，所以拷贝过来之后每次改颜色，**一定要全局替换，不要只改一个**！！！
3. 因为之前可能有了喜欢的主题，只不过主题之中有一些元素不喜欢而已，这样也会省下很多工作量。
4. 你可以借鉴一些主题的颜色，或者整体风格，由于都在 json 文件里面，你可以很方便的找到它。

那么问题来了，那些主题的 **json** 文件我去哪里找呢？

[这里](https://vscodethemes.com/)有几乎所有有名的 VSCode 主题，你可以点开看它的 **github** 那里就有它们的 **json** 文件，你可以 clone 整个项目，也可以单单只复制 **json** 。

**注意，不要全部复制过来，只复制 **colors** 和 **tokenColors** 就可以了。**

---

至于颜色的选取这里推荐几个网站，供大家参考：

1. [Colorable](http://jxnblk.com/colorable/demos/text/)
2. [colorsafe](http://colorsafe.co/)
3. [Adobe Color CC](https://color.adobe.com/zh/create)
