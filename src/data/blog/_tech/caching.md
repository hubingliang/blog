---
author: Brian Hu
pubDatetime: 2017-06-18T05:07:05.000Z
title: 认识 HTTP 缓存篇
postSlug: 认识 HTTP 缓存篇
featured: false
draft: false
tags:
  - HTTP
ogImage: "https://res.cloudinary.com/dewu7okpv/image/upload/v1675673300/blog/4337988-2f83dd324ca06c63.png_zw6s3t.png"
description: 所以讲缓存为什么要先扯代理服务器？别急，让我们看一下一个请求的简单示意图。
---

**本文内容大多参考[《图解 HTTP》一书](https://book.douban.com/subject/25863515/)**

## 认识代理服务器

所以讲缓存为什么要先扯代理服务器？别急，让我们看一下一个请求的简单示意图。

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675673300/blog/4337988-2f83dd324ca06c63.png_zw6s3t.png)

我们看到客户端(用户)发送了一个请求并不是直接发给源服务器的而是经过了代理服务器，然后经由代理服务器再发送给源服务器，响应也同样遵循这个顺序。
那么代理服务器在这中间担任了什么角色？

### 代理服务器的分类

- 缓存代理
  代理转发响应时，缓存代理（Caching Proxy）会预先将资源的副本（缓存）保存在代理服务器上。当代理再次接收到对相同资源的请求时，就可以不从源服务器那里
  获取资源，而是将之前缓存的资源作为响应返回。
- 透明代理（本文不做细致讨论）
  转发请求或响应时，不对报文做任何加工的代理类型被称为透明代理（Transparent Proxy）。反之，对报文内容进行加工的代理被称为非透明代理。

![浏览器、代理、服务器三者关系](https://res.cloudinary.com/dewu7okpv/image/upload/v1675673363/blog/4337988-d11ea257f3348fb1.png_ae2qnu.png)

## 保存资源的缓存

缓存是指代理服务器或客户端本地磁盘内保存的资源副本。利用缓存可减少对源服务器的访问，因此也就节省了通信流量和通信时间。
缓存服务器是代理服务器的一种，并归类在缓存代理类型中。换句话说，当代理转发从服务器返回的响应时，代理服务器将会保存一份资源的副本。

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675673380/blog/4337988-f0b2c6574f5d4670.png_ildihi.png)

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675673394/blog/4337988-d469c7564bf7dc8d.png_sbpmvc.png)

缓存服务器的优势在于利用缓存可避免多次从源服务器转发资源。因此客户端可就近从缓存服务器上获取资源，而源服务器也不必多次处理相同的请求了。

### 缓存的有效期限

即便缓存服务器和客户端内有缓存，也不能每次都给我返回缓存吧，如果是这样，源服务器更新了我也不知道，因为我每次都是看缓存的资源。
为了解决这个问题，针对缓存设计了时效性的概念：
即使存在缓存，也会因为客户端的要求、缓存的有效期等因素，向源服务器确认资源的有效性。若判断缓存失效，缓存服务器将会再次从源服务器上获取“新”资源。
![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675673408/blog/4337988-7b2ba0f55384fc8b.png_nfoq3q.png)

### 客户端的缓存

缓存不仅可以存在于缓存服务器内，还可以存在客户端浏览器中。以 Internet Explorer 程序为例，把客户端缓存称为临时网络文件（Temporary Internet File）。
浏览器缓存如果有效，就不必再向服务器请求相同的资源了，可以直接从本地磁盘内读取。
另外，和缓存服务器相同的一点是，当判定缓存过期后，会向源服务器确认资源的有效性。若判断浏览器缓存失效，浏览器会再次请求新资源。
![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675673422/blog/4337988-299403c724b8a2e7.png_d0q9yz.png)

## 与控制缓存相关的 HTTP 首部字段

### http1.0 时代的缓存方式

#### Pragma

Pragma 是 HTTP/1.1 之前版本的历史遗留字段，仅作为与 HTTP/1.0 的向后兼容而定义。
规范定义的形式唯一，如下所示。

`Pragma: no-cache`

该首部字段属于通用首部字段，但只用在客户端发送的请求中。客户端会要求所有的中间服务器不返回缓存的资源。

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675673437/blog/4337988-b7cfed33d7dd97aa.png_frm8xr.png)

所有的中间服务器如果都能以 HTTP/1.1 为基准， 那直接采用 Cache-Control: no-cache 指定缓存的处理方式是最为理想的。但要整体掌握全部中间服务器使用的 HTTP 协议版本却是不现实的。因此，发送的请求会同时含有下面两个首部字段。

```
Cache-Control: no-cache
Pragma: no-cache
```

#### Expires

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675673461/blog/4337988-8898bb96dfca4ab5.png_jkdptm.png)

`Expires: Wed, 04 Jul 2012 08:26:05 GMT`

首部字段 Expires 会将资源失效的日期告知客户端。缓存服务器在接收到含有首部字段 Expires 的响应后，会以缓存来应答请求，在 Expires 字段值指定的时间之前，响应的副本会一直被保存。当超过指定的时间后，缓存服务器在请求发送过来时，会转向源服务器请求资源。

源服务器不希望缓存服务器对资源缓存时，最好在 Expires 字段内写入与首部字段 Date 相同的时间值。
但是，当首部字段 Cache-Control 有指定 max-age 指令时，比起首部字段 Expires，会优先处理 max-age 指令。

### Cache-Control

通过指定首部字段 Cache-Control 的指令，就能操作缓存的工作机制。

![首部字段Cache-Control 能够控制缓存的行为](https://res.cloudinary.com/dewu7okpv/image/upload/v1675673477/blog/4337988-c3b31fc74a5d48df.png_sphwu0.png)

指令的参数是可选的，多个指令之间通过“,”分隔。首部字段 Cache-Control 的指令在请求和响应下都适用。

`Cache-Control: private, max-age=0, no-cache`

#### Cache-Control 指令一览：

可用的指令按请求和响应分类如下所示:

#### 缓存请求指令

| 指令                |  参数  |                         说明 |
| ------------------- | :----: | ---------------------------: |
| no-cache            |   无   |       强制向源服务器再次验证 |
| no-store            |   无   |   不缓存请求或响应的任何内容 |
| max-age = [ 秒]     | 必须有 |            响应的最大 Age 值 |
| max-stale( = [ 秒]) | 可省略 |             接收已过期的响应 |
| min-fresh = [ 秒]   | 必须有 | 期望在指定时间内的响应仍有效 |
| no-transform        |   无   |         代理不可更改媒体类型 |
| only-if-cached      |   无   |               从缓存获取资源 |
| cache-extension     |   -    |          新指令标记（token） |

#### 缓存响应指令

| 指令             |  参数  |                                       说明 |
| ---------------- | :----: | -----------------------------------------: |
| public           |   无   |                   可向任意方提供响应的缓存 |
| private          | 可省略 |                       仅向特定用户返回响应 |
| no-cache         | 可省略 |                   缓存前必须先确认其有效性 |
| no-store         |   无   |                 不缓存请求或响应的任何内容 |
| no-transform     |   无   |                       代理不可更改媒体类型 |
| must-revalidate  |   无   |           可缓存但必须再向源服务器进行确认 |
| proxy-revalidate |   无   | 要求缓存服务器对缓存的响应有效性再进行确认 |
| max-age = [ 秒]  | 必须有 |                          响应的最大 Age 值 |
| s-maxage = [ 秒] | 必须有 |            公共缓存服务器响应的最大 Age 值 |
| cache-extension  |   -    |                        新指令标记（token） |

### Cache-Control 指令详细介绍

#### 表示是否能缓存的指令

**public 指令**
`Cache-Control: public`

当指定使用 public 指令时，则明确表明其他用户也可利用缓存。

**private 指令**
![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675673495/blog/4337988-afbcf62c66df5f58.png_pevikh.png)

`Cache-Control: private`

当指定 private 指令后，响应只以特定的用户作为对象，这与 public
指令的行为相反。
缓存服务器会对该特定用户提供资源缓存的服务，对于其他用户发
送过来的请求，代理服务器则不会返回缓存。

**no-cache 指令**
![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675673508/blog/4337988-47544fb4e6259be7.png_bb3yxt.png)

`Cache-Control: no-cache`

使用 no-cache 指令的目的是为了防止从缓存中返回过期的资源。客户端发送的请求中如果包含 no-cache 指令，则表示客户端将不会接收缓存过的响应。于是，“中间”的缓存服务器必须把客户端请求转发给源服务器。
如果服务器返回的响应中包含 no-cache 指令，那么缓存服务器不能对资源进行缓存。源服务器以后也将不再对缓存服务器请求中提出的资源有效性进行确认，且禁止其对响应资源进行缓存操作。

`Cache-Control: no-cache=Location`

由服务器返回的响应中，若报文首部字段 Cache-Control 中对 no-cache 字段名具体指定参数值，那么客户端在接收到这个被指定参数值的首部字段对应的响应报文后，就不能使用缓存。换言之，无参数值的首部字段可以使用缓存。只能在响应指令中指定该参数。

#### 控制可执行缓存的对象的指令

**no-store 指令**

`Cache-Control: no-store`

当使用 no-store 指令时，暗示请求（和对应的响应）或响应中包含机密信息。
因此，该指令规定缓存不能在本地存储请求或响应的任一部分。

**ps:从字面意思上很容易把 no-cache 误解成为不缓存，但事实上 no-cache 代表不缓存过期的资源，缓存会向源服务器进行有效期确认后处理资源，也许称为 do-not-serve-from-cache-without-revalidation 更合适。no-store 才是真正地不进行缓存，请读者注意区别理解。**

#### 指定缓存期限和认证的指令

**s-maxage 指令**

`Cache-Control: s-maxage=604800 //（单位：秒）`

s-maxage 指令的功能和 max-age 指令的功能相同， 它们的不同点是 s-maxage 指令只适用于供多位用户使用的公共缓存服务器(这里指代理服务器)。也就是说，对于向同一用户重复返回响应的服务器来说，这个指令没有任何作用。
另外，当使用 s-maxage 指令后，则直接忽略对 Expires 首部字段及 max-age 指令的处理。

**max-age 指令**

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675673519/blog/4337988-bebb1dd149fa52cd.png_w9vp0f.png)

`Cache-Control: max-age=604800 //（单位：秒）`

当客户端发送的请求中包含 max-age 指令时，如果判定缓存资源的缓存时间数值比指定时间的数值更小，那么客户端就接收缓存的资源。
另外，当指定 max-age 值为 0，那么缓存服务器通常需要将请求转发给源服务器。
当服务器返回的响应中包含 max-age 指令时，缓存服务器将不对资源的有效性再作确认，而 max-age 数值代表资源保存为缓存的最长时间。
应用 HTTP/1.1 版本的缓存服务器遇到同时存在 Expires 首部字段的情况时，会优先处理 max-age 指令，而忽略掉 Expires 首部字段。而 HTTP/1.0 版本的缓存服务器的情况却相反，max-age 指令会被忽略掉。

**min-fresh 指令**

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675673534/blog/4337988-206127d6c4935c12.png_yrmm5c.png)

`Cache-Control: min-fresh=60 //（单位：秒）`

min-fresh 指令要求缓存服务器返回至少还未过指定时间的缓存资源。
比如，当指定 min-fresh 为 60 秒后，过了 60 秒的资源都无法作为响应返回了。

**max-stale 指令**

`Cache-Control: max-stale=3600  //（单位：秒）`

使用 max-stale 可指示缓存资源，即使过期也照常接收。
如果指令未指定参数值，那么无论经过多久，客户端都会接收响应；如果指令中指定了具体数值，那么即使过期，只要仍处于 max-stale 指定的时间内，仍旧会被客户端接收。
**only-if-cached 指令**

`Cache-Control: only-if-cached`

使用 only-if-cached 指令表示客户端仅在缓存服务器本地缓存目标资源的情况下才会要求其返回。换言之，该指令要求缓存服务器不重新加载响应，也不会再次确认资源有效性。若发生请求缓存服务器的本地缓存无响应，则返回状态码 504 Gateway Timeout。
**must-revalidate 指令**

`Cache-Control: must-revalidate`

使用 must-revalidate 指令，代理会向源服务器再次验证即将返回的响应缓存目前是否仍然有效。
若代理无法连通源服务器再次获取有效资源的话，缓存必须给客户端一条 504（Gateway Timeout）状态码。
另外，使用 must-revalidate 指令会忽略请求的 max-stale 指令（即使已经在首部使用了 max-stale，也不会再有效果）。
**proxy-revalidate 指令**

`Cache-Control: proxy-revalidate`

proxy-revalidate 指令要求所有的缓存服务器在接收到客户端带有该指令的请求返回响应之前，必须再次验证缓存的有效性。
**no-transform 指令**

`Cache-Control: no-transform`

使用 no-transform 指令规定无论是在请求还是响应中，缓存都不能改变实体主体的媒体类型。这样做可防止缓存或代理压缩图片等类似操作。

#### Cache-Control 扩展

cache-extension token

`Cache-Control: private, community="UCI"`

通过 cache-extension 标记（token），可以扩展 Cache-Control 首部字段内的指令。
如上例，Cache-Control 首部字段本身没有 community 这个指令。借助 extension tokens 实现了该指令的添加。如果缓存服务器不能理 community 这个新指令，就会直接忽略。因此，extension tokens 仅对能理解它的缓存服务器来说是有意义的。

### Last-Modified

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675673549/blog/4337988-d614e0b635ec075b.png_bgvtmn.png)

`Last-Modified: Wed, 23 May 2012 09:59:55 GMT`

服务器将资源传递给客户端时，会将资源最后更改的时间以“Last-Modified: GMT”的形式加在实体首部上一起返回给客户端。
当客户端对同样的资源发起同样的请求时，会把该信息附带在请求报文中一并带给服务器去做检查。

#### If-Modified-Since

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675673567/blog/4337988-f6990c041841cfc2.png_havk2x.png)

如果在 If-Modified-Since 字段指定的日期时间后，资源发生了更新，服务器会接受请求

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675673579/blog/4337988-64e1bbb040444dce.png_bzqcu5.png)

`If-Modified-Since: Thu, 15 Apr 2004 00:00:00 GMT`

首部字段 If-Modified-Since，属附带条件之一，它会告知服务器若 If-Modified-Since 字段值早于资源的更新时间，则希望能处理该请求。而在指定 If-Modified-Since 字段值的日期时间之后，如果请求的资源都没有过更新，则返回状态码 304 Not Modified 的响应。
If-Modified-Since 用于确认代理或客户端拥有的本地资源的有效性。获取资源的更新日期时间，可通过确认首部字段 Last-Modified 来确定。

#### If-Unmodified-Since

`If-Unmodified-Since: Thu, 03 Jul 2012 00:00:00 GMT`

首部字段 If-Unmodified-Since 和首部字段 If-Modified-Since 的作用相反。它的作用的是告知服务器，指定的请求资源只有在字段值内指定的日期时间之后，未发生更新的情况下，才能处理请求。如果在指定日期时间后发生了更新，则以状态码 412 Precondition Failed 作为响应返回。

**ps:Last-Modified 存在一定问题，如果在服务器上，一个资源被修改了，但其实际内容根本没发生改变，会因为 Last-Modified 时间匹配不上而返回了整个实体给客户端（即使客户端缓存里有个一模一样的资源）。**

### ETag

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675673594/blog/4337988-e8e4f1208281051b.png_mi3jem.png)

`ETag: "82e22293907ce725faf67773957acd12"`

首部字段 ETag 能告知客户端实体标识。它是一种可将资源以字符串形式做唯一性标识的方式。服务器会为每份资源分配对应的 ETag 值。
另外，当资源更新时，ETag 值也需要更新。生成 ETag 值时，并没有统一的算法规则，而仅仅是由服务器来分配。

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675673608/blog/4337988-39c25b16f7370efa.png_g1nioo.png)

资源被缓存时，就会被分配唯一性标识。
例如，当使用中文版的浏览器访问 http : //www.google.com/ 时，就会返回中文版对应的资源，而使用英文版的浏览器访问时，则会返回英文版对应的资源。
两者的 URI 是相同的，所以仅凭 URI 指定缓存的资源是相当困难的。若在下载过程中出现连接中断、再连接的情况，都会依照 ETag 值来指定资源。

#### 强 ETag 值和弱 Tag 值

- 强 ETag 值
  强 ETag 值，不论实体发生多么细微的变化都会改变其值。
  `ETag: "usagi-1234"`

- 弱 ETag 值
  弱 ETag 值只用于提示资源是否相同。只有资源发生了根本改变，产
  生差异时才会改变 ETag 值。这时，会在字段值最开始处附加 W/。
  `ETag: W/"usagi-1234"`

#### 4.2 If-Match

![附带条件请求](https://res.cloudinary.com/dewu7okpv/image/upload/v1675673625/blog/4337988-b0b9688c6da2da41.png_rbocbz.png)
形如 If-xxx 这种样式的请求首部字段，都可称为条件请求。服务器接收到附带条件的请求后，只有判断指定条件为真时，才会执行请求。

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675673641/blog/4337988-7992f2746e34989e.png_bk8zdm.png)

![只有当If-Match 的字段值跟ETag 值匹配一致时，服务器才会接受请求](https://res.cloudinary.com/dewu7okpv/image/upload/v1675673655/blog/4337988-20519a333fc1b1b8.png_j45qtu.png)

`If-Match: "123456"`

首部字段 If-Match，属附带条件之一，它会告知服务器匹配资源所用的实体标记（ETag）值。这时的服务器无法使用弱 ETag 值。
服务器会比对 If-Match 的字段值和资源的 ETag 值，仅当两者一致时，才会执行请求。反之，则返回状态码 412 Precondition Failed 的响应。
还可以使用星号（\*）指定 If-Match 的字段值。针对这种情况，服务器将会忽略 ETag 的值，只要资源存在就处理请求。

#### If-None-Match

只有在 If-None-Match 的字段值与 ETag 值不一致时， 可处理该请求。
与 If-Match 首部字段的作用相反

![](https://res.cloudinary.com/dewu7okpv/image/upload/v1675673694/blog/4337988-2119483682c70515.png_s57gi1.png)

首部字段 If-None-Match 属于附带条件之一。它和首部字段 If-Match 作用相反。用于指定 If-None-Match 字段值的实体标记（ETag）值与请求资源的 ETag 不一致时，它就告知服务器处理该请求。
在 GET 或 HEAD 方法中使用首部字段 If-None-Match 可获取最新的资源。因此，这与使用首部字段 If-Modified-Since 时有些类似。

### 用户刷新/访问行为

#### 在 URI 输入栏中输入然后回车

不与服务器确认，而是直接使用浏览器缓存的内容。其中响应内容和之前的响应内容一模一样，例如其中的 Date 时间是上一次响应的时间。

#### F5/点击工具栏中的刷新按钮/右键菜单重新加载

F5 的作用和直接在 URI 输入栏中输入然后回车是不一样的，F5 会让浏览器无论如何都发一个 HTTP Request 给 Server，即使先前的响应中有 Expires 头部。

#### Ctl+F5

Ctrl+F5 要的是彻底的从 Server 拿一份新的资源过来，所以不光要发送 HTTP request 给 Server，而且这个请求里面连 If-Modified-Since/If-None-Match 都没有，这样就逼着 Server 不能返回 304，而是把整个资源原原本本地返回一份，这样，Ctrl+F5 引发的传输时间变长了，自然网页 Refresh 的也慢一些。

### 缓存实践

#### Expires / Cache-Control

Cache-Control 是 HTTP1.1 才有的，不适用于 HTTP1.0，而 Expires 既适用于 HTTP1.0，也适用于 HTTP1.1，所以说在大多数情况下同时发送这两个头会是一个更好的选择，当客户端两种头都能解析的时候，会优先使用 Cache-Control。

#### Last-Modified / ETag

二者都是通过某个标识值来请求资源， 如果服务器端的资源没有变化，则自动返回 HTTP 304 （Not Changed）状态码，内容为空，这样就节省了传输数据量。当资源变化后则返回新资源。从而保证不向客户端重复发出资源，也保证当服务器有变化时，客户端能够得到最新的资源。
其中 Last-Modified 使用文件最后修改作为文件标识值，它无法处理文件一秒内多次修改的情况，而且只要文件修改了哪怕文件实质内容没有修改，也会重新返回资源内容；ETag 作为“被请求变量的实体值”，其完全可以解决 Last-Modified 头部的问题，但是其计算过程需要耗费服务器资源。

#### from-cache / 304

Expires 和 Cache-Control 都有一个问题就是服务端的修改，如果还在缓存时效里，那么客户端是不会去请求服务端资源的（非刷新），这就存在一个资源版本不符的问题，而强制刷新一定会发起 HTTP 请求并返回资源内容，无论该内容在这段时间内是否修改过；而 Last-Modified 和 Etag 每次请求资源都会发起请求，哪怕是很久都不会有修改的资源，都至少有一次请求响应的消耗。
对于所有可缓存资源，指定一个 Expires 或 Cache-Control max-age 以及一个 Last-Modified 或 ETag 至关重要。同时使用前者和后者可以很好的相互适应。
前者不需要每次都发起一次请求来校验资源时效性，后者保证当资源未出现修改的时候不需要重新发送该资源。而在用户的不同刷新页面行为中，二者的结合也能很好的利用 HTTP 缓存控制特性，无论是在地址栏输入 URI 然后输入回车进行访问，还是点击刷新按钮，浏览器都能充分利用缓存内容，避免进行不必要的请求与数据传输。

##### 避免 304

做法很简单，就是把可能会更新的资源以版本形式发布，常用的方法是在文件名或参数带上一串 md5 或时间标记符：

```
https://hm.baidu.com/hm.js?e23800c454aa573c0ccb16b52665ac26
http://tb1.bdstatic.com/tb/_/tbean_safe_ajax_94e7ca2.js
http://img1.gtimg.com/ninja/2/2016/04/ninja145972803357449.jpg
```

可以看到上面的例子中有不同的做法，有的在 URI 后面加上了 md5 参数，有的将 md5 值作为文件名的一部分，有的将资源放在特性版本的目录中。
那么在文件没有变动的时候，浏览器不用发起请求直接可以使用缓存文件；而在文件有变化的时候，由于文件版本号的变更，导致文件名变化，请求的 url 变了，自然文件就更新了。这样能确保客户端能及时从服务器收取到新修改的文件。通过这样的处理，增长了静态资源，特别是图片资源的缓存时间，避免该资源很快过期，客户端频繁向服务端发起资源请求，服务器再返回 304 响应的情况（有 Last-Modified/Etag）。

## 参考资料

- [《图解 HTTP》](https://book.douban.com/subject/25863515/)
- [HTTP 缓存控制小结](http://imweb.io/topic/5795dcb6fb312541492eda8c)
