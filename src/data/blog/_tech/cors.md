---
author: Brian Hu
pubDatetime: 2018-06-03T09:55:34.000Z
title: 跨域方法整理
postSlug: 跨域方法整理
featured: false
draft: false
tags:
  - HTTP
  - Front-end
ogImage: ""
description: 为了防止网站被 XSS、CSRF 攻击，Netscape 公司在 1995 年引入同源策略/SOP(Same origin policy),它是指“协议+域名+端口”三者相同
---

## 什么是同源

为了防止网站被 XSS、CSRF 攻击，Netscape 公司在 1995 年引入同源策略/SOP(Same origin policy),它是指“协议+域名+端口”三者相同。

## 什么是跨域

其实就是在违反了同源策略的情况下请求到资源的行为就是跨域，也就是说当协议、域名、端口号有一个或者多个不同时获取数据就是跨域。

在同源限制下 cookie localStorage dom ajax IndexDB 都不支持跨域。

另外，所谓同源策略并不是说在非同源的情况下服务器不返回数据，而是返回的数据被浏览器拦截了。

## 跨域的几种实现

### jsonp

```js
// 封装 jsonp 跨域请求的方法
function jsonp({ url, params, callBack }) {
  return new Promise((resolve, reject) => {
    // 创建一个 script 标签帮助我们发送请求
    let script = document.createElement("script");
    let arr = [];
    params = { ...params, callBack };

    // 循环构建键值对形式的参数
    for (let key in params) {
      arr.push(`${key}=${params[key]}`);
    }

    // 创建全局函数
    window[callBack] = function (data) {
      resolve(data);
      // 在跨域拿到数据以后将 script 标签销毁
      document.body.removeChild(script);
    };

    // 拼接发送请求的参数并赋值到 src 属性
    script.src = `${url}?${arr.join("&")}`;
    document.body.appendChild(script);
  });
}

// 调用方法跨域请求百度搜索的接口
json({
  url: "https://sp0.baidu.com/5a1Fazu8AA54nxGko9WTAnF6hhy/su",
  params: {
    wd: "jsonp",
  },
  callBack: "show",
}).then(data => {
  // 打印请求回的数据
  console.log(data);
});
```

**缺点：**

- 只支持 get
- 不安全，容易引发 xss 攻击，别人有可能在返回的结果中返回恶意代码

### CORS

跨源资源共享/CORS（Cross-Origin Resource Sharing）是 W3C 的一个工作草案，定义了在必须访问跨源资源时，浏览器与服务器应该如何沟通。CORS 背后的基本思想，就是使用自定义的 HTTP 头部让浏览器与服务器进行沟通，从而决定请求或响应是应该成功，还是应该失败。

浏览器将 CORS 请求分成两类：简单请求（simple request）和非简单请求（not-so-simple request）。

简单请求必须要满足两个条件：

1. 请求方法：

- HEAD
- GET
- POST

2. HTTP 头信息不超出以下字段

- Accept
- Accept-Language
- Content-Language
- Last-Event-ID
- Content-Type：只限于三个值 application/x-www-form-urlencoded、multipart/form-data、text/plain
