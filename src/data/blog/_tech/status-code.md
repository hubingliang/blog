---
author: Brian Hu
pubDatetime: 2017-10-28T05:57:41.000Z
title: 认识 HTTP 状态码
postSlug: 认识 HTTP 状态码
featured: false
draft: false
tags:
  - HTTP
  - Front-end
ogImage: ""
description: 当我们向服务端发送请求的时候，为了让用户更好的理解返回结果，通常要借助状态码来通知用户服务器端是正常处理了请求，还是出现了偏差。
---

**本文内容大多参考[《图解 HTTP》一书](https://book.douban.com/subject/25863515/)**

## 什么是状态码？

当我们向服务端发送请求的时候，为了让用户更好的理解返回结果，通常要借助状态码来通知用户服务器端是正常处理了请求，还是出现了偏差。

![响应的状态码可描述请求的处理结果](https://res.cloudinary.com/dewu7okpv/image/upload/v1675677761/blog/4337988-58f1c4215d05ea95.png_kvuilw.png)

**状态码如 200 OK，以 3 位数字和原因短语组成。**
**数字中的第一位指定了响应类别，后两位无分类。响应类别有以下 5 种。**

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675678203/blog/4337988-bf822bc144edc3e8.png_wnv1f1.png)

状态码数量繁多，实际经常使用只有 14 多种，下面只介绍一下具有代表性的 14 个状态码。

## 2XX 成功

2XX 的响应结果表明请求被正常处理了。

### 200 OK

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675678242/blog/4337988-61676b0654a08ac5.png_esl6sy.png)

表示从客户端发来的请求在服务器端被正常处理了。

### 204 No Content

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675678258/blog/4337988-f9d6fbcced90d307.png_miviza.png)
该状态码代表服务器接收的请求已成功处理，但在返回的响应报文中不含实体的主体部分。另外，也不允许返回任何实体的主体。比如，当从浏览器发出请求处理后，返回 204 响应，那么浏览器显示的页面不发生更新。
一般在只需要从客户端往服务器发送信息，而对客户端不需要发送新信息内容的情况下使用。

### 206 Partial Content

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675678274/blog/4337988-3026ffedffa36572.png_molx9w.png)

该状态码表示客户端进行了范围请求，而服务器成功执行了这部分的 GET 请求。响应报文中包含由 Content-Range 指定范围的实体内容。

## 3XX 重定向

3XX 响应结果表明浏览器需要执行某些特殊的处理以正确处理请求。

### 301 Moved Permanently

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675678835/blog/4337988-b1345d016e324c54.png_n83ocb.png)

永久性重定向。该状态码表示请求的资源已被分配了新的 URI，以后应使用资源现在所指的 URI。

### 302 Found

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675678788/blog/4337988-da317dbc465ef206.png_gmadmy.png)

临时性重定向。该状态码表示请求的资源已被分配了新的 URI，希望用户（本次）能使用新的 URI 访问。
和 301 Moved Permanently 状态码相似，但 302 状态码代表的资源不是被永久移动，只是临时性质的。换句话说，已移动的资源对应的 URI 将来还有可能发生改变。

### 303 See Other

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675678850/blog/4337988-42dfb7ef295639d6.png_twmspr.png)

该状态码表示由于请求对应的资源存在着另一个 URI，应使用 GET 方法定向获取请求的资源。
303 状态码和 302 Found 状态码有着相同的功能，但 303 状态码明确表示客户端应当采用 GET 方法获取资源，这点与 302 状态码有区别。
比如，当使用 POST 方法访问 CGI 程序，其执行后的处理结果是希望客户端能以 GET 方法重定向到另一个 URI 上去时，返回 303 状态码。虽然 302 Found 状态码也可以实现相同的功能，但这里使用 303 状态码是最理想的。

### 304 Not Modified

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675678878/blog/4337988-e014430e6b091447.png_uc4ejt.png)
该状态码表示客户端发送附带条件的请求时，服务器端允许请求访问资源，但未满足条件的情况。304 状态码返回时，不包含任何响应的主体部分。304 虽然被划分在 3XX 类别中，但是和重定向没有关系。

### 307 Temporary Redirect

临时重定向。该状态码与 302 Found 有着相同的含义。尽管 302 标准禁止 POST 变换成 GET，但实际使用时大家并不遵守。
307 会遵照浏览器标准，不会从 POST 变成 GET。但是，对于处理响应时的行为，每种浏览器有可能出现不同的情况。

## 4XX 客户端错误

4XX 的响应结果表明客户端是发生错误的原因所在。

### 400 Bad Request

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675678891/blog/4337988-a76b87f7b3357e68.png_ozklcy.png)
该状态码表示请求报文中存在语法错误。当错误发生时，需修改请求的内容后再次发送请求。另外，浏览器会像 200 OK 一样对待该状态码。

### 401 Unauthorized

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675678904/blog/4337988-fcd2dcebfb074152.png_huhj1o.png)
该状态码表示发送的请求需要有通过 HTTP 认证（BASIC 认证、DIGEST 认证）的认证信息。另外若之前已进行过 1 次请求，则表示用户认证失败。
返回含有 401 的响应必须包含一个适用于被请求资源的 WWWAuthenticate 首部用以质询（challenge）用户信息。当浏览器初次接收到 401 响应，会弹出认证用的对话窗口。

### 403 Forbidden

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675678917/blog/4337988-604eb2183c50e7d7.png_rhnlsn.png)
该状态码表明对请求资源的访问被服务器拒绝了。服务器端没有必要给出拒绝的详细理由，但如果想作说明的话，可以在实体的主体部分对原因进行描述，这样就能让用户看到了。
未获得文件系统的访问授权，访问权限出现某些问题（从未授权的发送源 IP 地址试图访问）等列举的情况都可能是发生 403 的原因。

### 404 Not Found

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675678930/blog/4337988-1802cc9939aae6c4.png_vki10y.png)

该状态码表明服务器上无法找到请求的资源。除此之外，也可以在服务器端拒绝请求且不想说明理由时使用。

## 5XX 服务器错误

5XX 的响应结果表明服务器本身发生错误。

### 500 Internal Server Error

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675678943/blog/4337988-beb418dab1c3dbba.png_s314mr.png)

该状态码表明服务器端在执行请求时发生了错误。也有可能是 Web 应用存在的 bug 或某些临时的故障。

### 503 Service Unavailable

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675678957/blog/4337988-46134e7be9df6947.png_xdtuko.png)
该状态码表明服务器暂时处于超负载或正在进行停机维护，现在无法处理请求。如果事先得知解除以上状况需要的时间，最好写入 Retry-After 首部字段再返回给客户端。
