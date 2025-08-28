---
author: Brian Hu
pubDatetime: 2022-09-6T14:23:11.000Z
title: Monorepo 能给前端工程带来什么
postSlug: Monorepo 能给前端工程带来什么
featured: false
draft: false
tags:
  - Monorepo
  - Front-end
ogImage: "https://res.cloudinary.com/dewu7okpv/image/upload/v1675680883/blog/BVuVT66Vb1YHIbLy1KG75I9jgzaasxxE6oDlWtJ7L6Yz_ltj8ii.png"
description: 现在谈 Monorepo 或许有些晚了，作为历史可以追溯到 2000 年初的技术思想，它已经经过多次的迭代优化，衍生出了很多优秀的框架和工具。不过对于前端在近几年工程的日益复杂化，Monorepo 在前端领域或许可以降低一定的项目复杂度。
---

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675680883/blog/BVuVT66Vb1YHIbLy1KG75I9jgzaasxxE6oDlWtJ7L6Yz_ltj8ii.png)

# Monorepo 能给前端工程带来什么

现在谈 Monorepo 或许有些晚了，作为历史可以追溯到 2000 年初的技术思想，它已经经过多次的迭代优化，衍生出了很多优秀的框架和工具。不过对于前端在近几年工程的日益复杂化，Monorepo 在前端领域或许可以降低一定的项目复杂度。

# 什么是 Monorepo ？

Monorepo 最早的出处是软件开发策略的一个分支，”mono” 表示单一 “repo” 是”reository”的缩写，

意为多个项目共用一个代码库来管理依赖关系，同一套配置文件，统一构建部署流程等等。

## 不仅仅是代码托管

如果项目之间没有定义明确的关系，仅仅是用同一个 git 仓库的话，并不能称之为 Monorepo 并且这样明显弊大于利。

如果有明确的依赖关系，但是关系冗余，并没有复用抽象，其实也不算真正意义上的 Monorepo。

![Image.jpeg](https://res.cloudinary.com/dewu7okpv/image/upload/v1675680924/blog/Image_fhyjvu.jpg)

# 为什么需要 Monorepo ?

我们把现在最普遍的 Polyrepo 拿出来比较一下

## Polyrepo

Polyrepo 是当前开发应用程序的标准方式：每个团队的应用程序或项目都有一个单独的 repo。每个 repo 都有一个构建脚本配置和部署流程。

![Image.jpeg](https://res.cloudinary.com/dewu7okpv/image/upload/v1675680942/blog/Image_fs1qlj.jpg)

Polyrepo 流行的一个重要原因是有很好的天然隔离机制，项目自身不依赖其他任何团队的项目，开发团队可以自己决定使用那些框架，依赖库的版本，代码风格的配置，构建的自定义配置。

但过多的自由性和项目隔离也带来了很多协作和管理的问题

- **繁琐的代码共享**

  要跨代码库共享代码的话，可能要为共享代码创建一个代码库。然后设置工具和 CI 环境，并设置包发布，以便其他存储库可以依赖它。与此同时，还要有代码更新版本，同时要维护其他项目依赖更新的心智负担。

- **代码重复**

  在维护多个项目的时候，有一些逻辑很有可能会被多次用到，比如一些基础的组件、工具函数，或者一些配置，这些代码如果单单复制过来，之后这些代码出现 bug、或者需要做一些调整的时候，就得修改多份，维护成本越来越高。

- **不统一的代码风格和配置文件**

  每个项目都使用自己的一组命令来运行测试、构建、服务、linting、部署等。不一致会产生需要记忆在不同项目之间使用哪些命令的心理开销。

  代码风格的不一致，也会大大的降低可读性，以及不同开发人员在格式化时造成没必要的修改。

- **黑洞级别的 node_modules**

  多个代码库会导致重复依赖的安装文件分布在每个代码库的 node_modules 中。

## Monorepo

monorepo 如何帮助解决所有这些问题？

- **更好的代码复用**

  所有项目代码集中于单一仓库，易于抽离出共用的业务组件或工具。由于所有的项目放在一个仓库当中，复用起来非常方便，如果有依赖的代码变动，那么用到这个依赖的项目当中会立马感知到。并且所有的项目都是使用最新的代码，不会产生其它项目版本更新不及时的情况。

- **工作流的一致性**

  复用已有的方式来构建和测试使用不同工具和技术编写的应用程序。只需要很少的人来维护所有项目的基建，维护成本也大大减低。不同开发人员可以自信地为其他团队的应用程序提交代码。

- **依赖**关系清晰

  对于内部依赖有很清晰的引用路径，改动即时更新，不会有代码不同步的情况。改一处，所有依赖同步更新。

## Monorepo 配合工具还可以做到什么？

Monorepos 有很多优势，但要让它们发挥作用，需要拥有正确的工具。随着工作空间的扩大，这些工具必须帮助您保持快速、易于理解和易于管理。

- **增量构建**

  如果我们的项目过大，构建多个子包会造成时间和性能的浪费，基于 turborepo 的 Monorepo 的缓存机制 可以帮助我们记住构建内容 并且跳过已经计算过的内容，优化打包效率。

- **代码生成**

  大部分 Monorepo 工具都提供模板代码的自动生成，降低新增 workspace 的心智负担，并统一配置，不用担心不一致的问题。

![Image.jpeg](https://res.cloudinary.com/dewu7okpv/image/upload/v1675680989/blog/Image_j4ijrb.jpg)

- **项目结构更加清晰可见**

  nx 提供清晰的依赖关系可视化

![Image.jpeg](https://res.cloudinary.com/dewu7okpv/image/upload/v1675681012/blog/Image_ycplbk.jpg)

# Monorepo 不同 solution 的比较

来源于 nrwl 整理的各个 Monorepo 工具的统计数据

![Image](https://res.cloudinary.com/dewu7okpv/image/upload/v1675681035/blog/Image_gxy8tr.jpg)

# 关于 Monorepo 的更多资源

[GitHub - korfuri/awesome-monorepo: A curated list of awesome Monorepo tools, software and architectures.](https://github.com/korfuri/awesome-monorepo)

[The One Version Rule  |  Google Open Source](https://opensource.google/documentation/reference/thirdparty/oneversion?utm_source=monorepo.tools)

[Build Monorepos, not Monoliths](https://dev.to/agentender/build-monorepos-not-monoliths-4gbc?utm_source=monorepo.tools)
