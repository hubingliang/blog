---
author: Brian Hu
pubDatetime: 2018-07-20T09:45:16.000Z
title: 上手 Vue 3 + TS 应该用 Oprions API 还是 Composition API？
postSlug: 上手 Vue 3 + TS 应该用 Oprions API 还是 Composition API？
featured: false
draft: false
tags:
  - JavaScript
  - Front-end
  - Vue
ogImage: ""
description: 在这篇文章中，我会同时用常规 JavaScript 和 options API 以及 TypeScript 和 Composition API 写出两种不同风格的 Vue 3 组件，我们会从中看到两者的差异以及一些可能被忽视的优点。
---

在这篇文章中，我会同时用常规 JavaScript 和 options API 以及 TypeScript 和 Composition API 写出两种不同风格的 Vue 3 组件，我们会从中看到两者的差异以及一些可能被忽视的优点。

[你可以在这找到本文提及到的源码](https://gist.github.com/lmiller1990/f12b847fc23592f25ab70b17074fe946)

## The Component

我将会重构一个显示新闻的组件，它是通过 render 函数编写的。但因为 Vue Test Utils 和 Jest 还没有支持 Vue3 组件。对于那些不熟悉 render 函数的人，我附上了生成好的 HTML。由于源代码很长，组件的基本思想是生成此标记：

```html
<div>
  <h1>Posts from {{ selectedFilter }}</h1>
  <Filter
    v-for="filter in filters"
    @select="filter => selectedFilter = filter"
    :filter="filter"
  />
  <NewsPost v-for="post in filteredPosts" :post="post" />
</div>
```

`<NewsPost />` 负责展示渲染一些新闻帖子，用户可以通过设置`<Filter />`组件来配置他们想看哪个时间段的新闻，这个组件基本上只需要渲染“今天”，“最近一周”等类似的按钮。

在重构的过程中，我会介绍每个组件的源代码。至于用户如何与组件交互，下面是测试 👇

```js
describe('FilterPosts', () => {
  it('renders today posts by default', async () => {
    const wrapper = mount(FilterPosts)

    expect(wrapper.find('.post').text()).toBe('In the news today...')
    expect(wrapper.findAll('.post')).toHaveLength(1)
  })

  it('toggles the filter', async () => {
    const wrapper = mount(FilterPosts)

    wrapper.findAll('button')[1].trigger('click')
    await nextTick()

    expect(wrapper.findAll('.post')).toHaveLength(2)
    expect(wrapper.find('h1').text()).toBe('Posts from this week')
    expect(wrapper.findAll('.post')[0].text()).toBe('In the news today...')
    expect(wrapper.findAll('.post')[1].text()).toBe('In the news this week...')
  })
})`
```

我们需要关注的改动：

- 使用 composition API 的 `ref` 和 `computed` 代替 `data` 和 `computed`
- 使用 TypeScript 来强化类型声明
- 最重要的是，哪种 API 风格更加友好，以及 JS 和 TS 使用的利弊

## Typing the `filter` type and Refactoring `Filter`

从最简单的组件开始是最容易理解的，筛选组件如下所示：

```js
const filters = ["today", "this week"];

export const Filter = defineComponent({
  props: {
    filter: {
      type: String,
      required: true,
    },
  },

  render() {
    // <button @click="$emit('select', filter)>{{ filter }}/<button>
    return h(
      "button",
      { onClick: () => this.$emit("select", this.filter) },
      this.filter
    );
  },
});
```

我们主要修改的是要给传入的 `filter` prop 定义类型，我们可以新定义一种类型（也可以使用`enum`）来做到这一点。

```js
type FilterPeriod = 'today' | 'this week'
const filters: FilterPeriod[] = ['today', 'this week']

export const Filter = defineComponent({
  props: {
    filter: {
      type: String as () => FilterPeriod,
      required: true
    }
  },
  // ...
)
```

你可能注意到在声明类型的时候用到了很奇怪的 `String as () => FilterPeriod` 语法，我不太确定为什么，可能是 Vue `props`系统的一些限制。

这已经是一个很大的改动了，使用者不需要考虑哪种字符串才是有效的，而且有可能会打错字，但是现在他们可以通过 IDE 查找，甚至可以在执行测试用例的时候或者启动 app 时提前发现问题。

我们还可以将 `render` 函数移动到 `setup` 函数中，这样做就可以在 `this.filter` 和 `this.$emit` 中获得更好的类型判断。

```js
setup(props, ctx) {
  return () => h('button', { onClick: () => ctx.emit('select', props.filter) }, props.filter)
}
```

给出更好的类型判断的主要原因是，定义类型对于 `props` 和 `context` 比定义高动态的 js 更容易。

但其实当 Vetur 为 Vue3 更新时，你实际上会在 `<template>` 中获得判断，这无疑是激动人心的。

此时的测试用例依然可以通过，让我们继续重构`NewsPost`组件。

## Typing the `post` type and `NewsPost`

NewsPost 组件看起来像这样：

```js
export const NewsPost = defineComponent({
  props: {
    post: {
      type: Object,
      required: true,
    },
  },

  render() {
    return h("div", { className: "post" }, this.post.title);
  },
});
```

另一个非常简单的组件，你会注意到`this.post.title`是没有被定义的，如果你在 VSCode 中打开这个组件，它会显示 `this.post` 是 `any` ，这是因为在 JavaScript 中很难定义 `this` ，与此同时 `type: Object` 实际上并没有什么用，因为他不能定义对象中的字段，让我们用 `Post` interface 来解决这个定义：

```js
interface Post {
  id: number
  title: string
  created: Moment
}
```

我们把 `render` 移动到 `setup`：

```js
export const NewsPost = defineComponent({
  props: {
    post: {
      type: Object as () => Post,
      required: true
    },
  },

  setup(props) {
    return () => h('div', { className: 'post' }, props.post.title)
  }
})
```

如果你在 VSCode 中打开这个组件，则会注意到 `props.post.title` 已经有了正确的类型定义。

## Updating `FilterPosts`

现在只剩下一个组件了 — `FilterPosts` 它看起来像这样：

```js
export const FilterPosts = defineComponent({
  data() {
    return {
      selectedFilter: "today",
    };
  },

  computed: {
    filteredPosts() {
      return posts.filter(post => {
        if (this.selectedFilter === "today") {
          return post.created.isSameOrBefore(moment().add(0, "days"));
        }

        if (this.selectedFilter === "this week") {
          return post.created.isSameOrBefore(moment().add(1, "week"));
        }

        return post;
      });
    },
  },

  // <h1>Posts from {{ selectedFilter }}</h1>
  // <Filter
  //   v-for="filter in filters"
  //   @select="filter => selectedFilter = filter
  //   :filter="filter"
  // />
  // <NewsPost v-for="post in posts" :post="post" />
  render() {
    return h("div", [
      h("h1", `Posts from ${this.selectedFilter}`),
      filters.map(filter =>
        h(Filter, {
          filter,
          onSelect: filter => (this.selectedFilter = filter),
        })
      ),
      this.filteredPosts.map(post => h(NewsPost, { post })),
    ]);
  },
});
```

我们从删除 `data` 函数开始，然后在`setup`中定义`selectedFilter`为`ref`，`ref`是一个泛型，因此我可以使用`<>`来将其传给其他类型，现在`ref`知道哪些值可以被分给`selectedFilter`。

```js
setup() {
  const selectedFilter = ref<FilterPeriod>('today')

  return {
    selectedFilter
  }
}
```

测试用例仍然可以通过，所以让我们把`computed`和`filteredPosts`移动到`setup`。

```js
const filteredPosts = computed(() => {
  return posts.filter(post => {
    if (selectedFilter.value === "today") {
      return post.created.isSameOrBefore(moment().add(0, "days"));
    }

    if (selectedFilter.value === "this week") {
      return post.created.isSameOrBefore(moment().add(1, "week"));
    }

    return post;
  });
});
```

唯一改变的就是取代了`this.selectedFilter`我们使用了`selectedFilter.value`，`.value`在访问`selectedFilter` 的时候是必须的，因为你引用的是 `Proxy` 它是 ES6 的新特性，Vue3 使用它来实现响应式。如果你在 VSCode 打开它，你会注意到`selectedFilter.value === 'this year'` 这将会出现编译错误，我们类型声明`FilterPeriod`所以编译器可以捕获该错误。

最后的改动是把`render`函数移动到`setup`

```js
return () =>
  h("div", [
    h("h1", `Posts from ${selectedFilter.value}`),
    filters.map(filter =>
      h(Filter, { filter, onSelect: filter => (selectedFilter.value = filter) })
    ),
    filteredPosts.value.map(post => h(NewsPost, { post })),
  ]);
```

现在我们在`setup`中返回一个函数，所以我们不再需要返回`selectedFilter`和`filteredPosts` 我们可以在返回的函数中直接引用它，因为他们是在同一作用域中声明的。

所有的测试都通过了，因此重构结束。

## Discussion

一个重要的事情是，我们不需要为重构改变测试用例。这是因为测试着重于组件的行为，而不是实现细节。

尽管这种重构并不有趣，而且并不能带来什么业务增长，但它确实提出一些有趣的观点，以供开发人员讨论。

- 我们应该用 Composition API 还是 Options API?
- 我们应该用 JS 还是 TS?

## Composition API vs Options API

这其实是 Vue2 到 Vue3 的最大变化，尽管你可以在 Vue3 使用 Options API，那是因为两者都存在。但是自然会引出一个问题，哪一个是解决问题的最好方法？或者哪一个适合我的项目？

我不认为他们之中的一个要优于一个，就我个人而言，我发现 Options API 更容易理解，因为它很直观。了解 `ref` 和 `reactive` 以及`.value`需要了解的前置知识很多。至少 Options API 会迫使你才用 ` computed``methods``data `的结构。

但是话虽这么说，但是在使用 Options API 的时候很难充分利用 TypeScript 的全部功能，这是引用 Composition API 的原因之一。这是我要讨论的第二点。

## Typescript vs JavaScript

一开始我发现 TypeScript 的学习曲线并不友好，但是我真的很喜欢使用 TypeScript 来编写应用程序。它帮助我捕获很多错误，并且使事情更容易推断，如果你不知道一个对象有什么属性或者它们是否为空，只知道传入的 `prop` 是 `Object` 是没什么帮助的。

另一方面，当我学习一个新概念，构建一个原型或者尝试一个新库时，我仍然更喜欢 JavaScript ，因为它不需要构建直接可以在浏览器运行，而当我尝试某些操作时，我也不需要关心特定的类型和泛型。这就是我最初学习 Composition API 的方式 仅仅用脚本标签构建一些例子。

当你对某些库或者设计模式有信心，并且对要解决的问题充分了解之后，我更喜欢用 TypeScript ，考虑到 TypeScript 的普及程度，与其他强类型语言的相似性以及它带来的好处，用 JavaScript 来编写大型且复杂的应用会造成不必要的疏忽。TypeScript 的好处太吸引人了，特别是对于定义复杂的业务逻辑或与团队一起扩展代码库而言。

另外一种我更偏爱 JavaScript 的地方是在构建以设计为中心的组件或应用时，大部分只需要使用 CSS 动画，SVG 进行操作，并且仅使用 Vue 诸如 Transition 基本的数据绑定 动画钩子之类的事情，这种情况我觉得 JavaScript 更为合适，只有在业务逻辑复杂的时候才会考虑 TypeScript。

总而言之，我非常喜欢 TypeScript 和 Composition api，不是因为我因为它比 Options API 更直观或更简洁，而是因为它可以使我更有效地去利用 TypeScript。我认为 Options API 和 Composition API 都是构建 Vue.js 组件的适当方法。

## Conclusion

我演示并且讨论了：

- 循序渐进的向常规 JavaScript 编写的组件添加类型
- 好的测试用例只关注行为表现而不关注代码的实现细节
- TypeScript 的优点
- Options API 和 Composition API 的比较
