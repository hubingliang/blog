---
author: Brian Hu
pubDatetime: 2018-05-09T09:46:49.000Z
title: 排序算法 N 个正整数排序
postSlug: 排序算法 N 个正整数排序
featured: false
draft: false
tags:
  - Arithmetic
ogImage: "https://res.cloudinary.com/dewu7okpv/image/upload/v1675676959/blog/4337988-51788201338ecebb.png_ftqf8h.png"
description: 高德纳在《计算机程序设计艺术》里对算法归纳为以下几点：
---

## 算法

高德纳在《计算机程序设计艺术》里对算法归纳为以下几点：

> 1.  输入: 一个算法必须有零或以上的输入量
> 2.  输出: 一个算法应有一个或以上的输出量
> 3.  明确性: 算法的描述必须无歧义,实际运行结果是确定的
> 4.  有限性: 必须在有限个步骤内结束
> 5.  有效性: 又称可行性,能够被执行者实现

**如果想详细研究算法推荐《数据结构与算法分析》**

![数据结构与算法分析](https://res.cloudinary.com/dewu7okpv/image/upload/v1675676944/blog/4337988-706bb05d7f8e293f.png_keop6m.png)

## 定义问题

数组 array 含有 N 个正整数
输入量为 array
请将 array 中的数字从小到大排列
输出量为排好序的数组

代码例子

```js
var array = [5, 2, 4, 6, 8];
function sort() {
  你的代码;
}
sort(array) === [2, 4, 5, 6, 8];
```

当你遇到思路障碍怎么办?

- 将**抽象的问题**转化为**具体的问题**
- 将**没见过的问题**转化为**见过的问题**

## 排序算法

**[所有算法都可在此查看演示](https://visualgo.net/sorting)**

### 冒泡排序(BUBBLE)

重复地比较要排序的数列，一次比较两个元素，如果他们的顺序错误就把他们交换过来。比较数列的工作是重复地进行直到没有再需要交换，也就是说该数列已经排序完成。每比较一整轮,最大的都会出现在最后故名---**冒泡排序**

流程如下:

1. 我们拿到一个数组
   ![数组](https://res.cloudinary.com/dewu7okpv/image/upload/v1675676959/blog/4337988-51788201338ecebb.png_ftqf8h.png)
2. 开始从前两个开始比较,发现 44>3,所以不用交换
   ![比较](https://res.cloudinary.com/dewu7okpv/image/upload/v1675676973/blog/4337988-27cf4ee44274aebd.png_jxvoit.png)
3. 接着往后比较,发现 38<44,所以交换他们两个的位置
   ![比较](https://res.cloudinary.com/dewu7okpv/image/upload/v1675676984/blog/4337988-b106c8ea4d1e64a4.png_dem7wj.png)
4. 以此类推直到第一轮结束,我们得到了最大的那一个----**50**(冒的第一个泡)
   ![第一轮结束](https://res.cloudinary.com/dewu7okpv/image/upload/v1675676994/blog/4337988-05228b4f061ec01b.png_s9eh8i.png)
5. 接着下一轮,又从头开始两个两个地比较,重复第一轮,我们就得到了第二个最大的------**48**
   ![第二轮结束](https://res.cloudinary.com/dewu7okpv/image/upload/v1675677008/blog/4337988-b3a220becd934a11.png_xmsj7a.png)
6. 如此进行多轮比较我们会得到一个从小到大的数组
   ![从小到大](https://res.cloudinary.com/dewu7okpv/image/upload/v1675677019/blog/4337988-f60c295026eac0f3.png_bdunvw.png)
7. 代码实现：

```js
function bubbleSort(array) {
  for (let i = 0; i < array.length - 1; i++) {
    for (let j = 0; j < array.length - i - 1; j++) {
      if (array[j] > array[j + 1]) {
        let temp = array[j];
        array[j] = array[j + 1];
        array[j + 1] = temp;
      }
    }
  }
}
```

### 2. 选择排序(SELECT)

每一次从待排序的数据元素中选出最小（或最大）的一个元素，存放在序列的起始位置，直到全部待排序的数据元素排完。
流程如下:

1. 拿到一个数组
   ![数组](https://res.cloudinary.com/dewu7okpv/image/upload/v1675677032/blog/4337988-62f83dc193f1978c.png_hpuwwa.png)
2. 我们要选出这个数组中最小的元素然后把它和第一个数交换(放到最前面),所以我们先认为 3 为最小,然后和后面的数依次进行比较.
   ![和最小值比较](https://res.cloudinary.com/dewu7okpv/image/upload/v1675677044/blog/4337988-b44dc333bdadd03b.png_s9cl9d.png)
3. 当比到 2 的时候,我们发现 3>2,所以我们就认为 2 为最小值,后面的数应该都和 2 进行比较.
   ![改变最小值的元素](https://res.cloudinary.com/dewu7okpv/image/upload/v1675677054/blog/4337988-47bda740993e028c.png_eq5vs7.png)
4. 当比较完所有的元素,确定 2 为最小值的时候,把最小值也就是 2 与第一个元素的位置互换.
   ![互换位置](https://res.cloudinary.com/dewu7okpv/image/upload/v1675677065/blog/4337988-549ba8d1e5375edd.png_dttkgm.png)
5. 然后从第二个元素开始新一轮的比较,过程和第一轮一样.把 44 看做最小值和后面的元素进行比较.
   ![第二轮](https://res.cloudinary.com/dewu7okpv/image/upload/v1675677077/blog/4337988-93ae5c6008503d42.png_fhed0a.png)
6. 经过多轮比较得到从小到大的数组.
   ![从小到大](https://res.cloudinary.com/dewu7okpv/image/upload/v1675677087/blog/4337988-10b714a8ceceb65f.png_ovfpy6.png)
7. 代码实现

```js
function selectSort(arr) {
  var minIndex, temp;
  for (let i = 0; i < arr.length - 1; i++) {
    minIndex = i; // 先把第一个看做最小值
    for (let j = i + 1; j < arr.length; j++) {
      if (arr[j] < arr[minIndex]) {
        minIndex = j;
      }
    }
    temp = arr[i];
    arr[i] = arr[minIndex];
    arr[minIndex] = temp;
  }
  return arr;
}
```

### 3, 插入排序(INSERT)

将一个数据插入到已经排好序的有序数据中，从而得到一个新的、个数加一的有序数据，算法适用于少量数据的排序。是稳定的排序方法。
流程如下:

1. 拿到一个数组
   ![数组](https://res.cloudinary.com/dewu7okpv/image/upload/v1675677099/blog/4337988-0fe1ff7bc8912789.png_mxdmg6.png)
2. 把第一个元素看做一个新数组,然后把第二个元素依次和新数组的元素进行比较(虽然只有一个...),然后插入到适当的位置.
   ![与新数组的元素进行比较](https://res.cloudinary.com/dewu7okpv/image/upload/v1675677111/blog/4337988-0b049542a383e8dc.png_z7fxcb.png)
   ![插入到适当的位置](https://res.cloudinary.com/dewu7okpv/image/upload/v1675677122/blog/4337988-b08f38982e74bf87.png_iclujn.png)
3. 然后以此类推,把前两个元素看做是一个新数组,然后把第三个元素依次与新数组进行比较,然后插入到适当的位置.
   ![比较](https://res.cloudinary.com/dewu7okpv/image/upload/v1675677132/blog/4337988-25293f6061257350.png_qdy7bf.png)
   ![插入适当的位置](https://res.cloudinary.com/dewu7okpv/image/upload/v1675677143/blog/4337988-435373ab53226a01.png_cngbs1.png)
4. 把剩下的元素依次插入,最后得到从小到大排列的数组.
   ![从小到大](https://res.cloudinary.com/dewu7okpv/image/upload/v1675677155/blog/4337988-eb5c7cdc2dbe51e3.png_vv9vzu.png)
5. 代码实现

```js
function insertionSort(array) {
  for (let i = 1; i < array.length; i++) {
    let key = array[i];
    let j = i - 1;
    while (j >= 0 && array[j] > key) {
      array[j + 1] = array[j];
      j--;
    }
    array[j + 1] = key;
  }
  return array;
}
```

### 4. 归并排序(MERGE)

将已有序的子序列合并，得到完全有序的序列；即先使每个子序列有序，再使子序列段间有序。
流程如下:

1. 拿到一个数组
   ![数组](https://res.cloudinary.com/dewu7okpv/image/upload/v1675677168/blog/4337988-b7dd0bc29bf1f856.png_nygedk.png)
2. 我们把数组平均分成左右两部分,得到两个新数组,然后再把每个数组平均分成两部分,一直分到每个数组只有两个元素,然后比较第一组
   ![比较第一组](https://res.cloudinary.com/dewu7okpv/image/upload/v1675677179/blog/4337988-f1f922e5fdac37ec.png_ysaxpv.png)
3. 因为 3<44 所以位置不变然后比较第二组,因为 38>5 所以调换位置.
   ![图片.png](https://res.cloudinary.com/dewu7okpv/image/upload/v1675677196/blog/4337988-82e45b17bd304d2f.png_vkn7n4.png)
4. 重点来了,这个时候先不着急比较第三组而是把排好序的一二两组放在一起排序.
   ![图片.png](https://res.cloudinary.com/dewu7okpv/image/upload/v1675677208/blog/4337988-a45b23e96799adbd.png_roubpa.png)
5. 之后就是比较第三组和第四组,然后同样把他们放在一起排好序.
   ![图片.png](https://res.cloudinary.com/dewu7okpv/image/upload/v1675677221/blog/4337988-ada3c8eb5b769b9e.png_e75hk3.png)
6. 然后并不是比较第五组和第六组,而是把第一组和第二组产生的新数组和,第三组和第四组产生的新数组放在一起排序成为新数组.
   ![图片.png](https://res.cloudinary.com/dewu7okpv/image/upload/v1675677232/blog/4337988-7df965288165ac01.png_id2xmi.png)
7. 同样把剩下的按以上步骤重来一遍.我们得到两个排好序的数组.然后给这两个数组排序就完成了.
   ![图片.png](https://res.cloudinary.com/dewu7okpv/image/upload/v1675677243/blog/4337988-3e92a52343a0d8c5.png_lyxg4u.png)
   排序后:
   ![图片.png](https://res.cloudinary.com/dewu7okpv/image/upload/v1675677254/blog/4337988-78eebc9c38d1ba31.png_qgp50h.png)
8. 代码实现

```js
function mergeSort(arr) {
  var len = arr.length;
  if (len < 2) {
    return arr;
  }
  var middle = Math.floor(len / 2),
    left = arr.slice(0, middle),
    right = arr.slice(middle);
  return merge(mergeSort(left), mergeSort(right));
}

function merge(left, right) {
  var result = [];

  while (left.length && right.length) {
    if (left[0] <= right[0]) {
      result.push(left.shift());
    } else {
      result.push(right.shift());
    }
  }

  while (left.length) result.push(left.shift());
  while (right.length) result.push(right.shift());

  return result;
}
```

### 5. 快速排序

每个元素找到自己对应的位置(前面的都比我小,后面的都比我大)
流程如下:

1. 拿到一个数组
   ![数组](https://res.cloudinary.com/dewu7okpv/image/upload/v1675677269/blog/4337988-b7dd0bc29bf1f856.png_o0n0hs.png)
2. 拿第一个元素和后面的元素进行比较,找出所有比第一个元素小的元素,放在第一个元素的右边然后把第一个元素与这些比他小的元素的最后一个互换.
   ![只有2比3小](https://res.cloudinary.com/dewu7okpv/image/upload/v1675677282/blog/4337988-ce0718ea693d000a.png_pxkcok.png)
   ![互换](https://res.cloudinary.com/dewu7okpv/image/upload/v1675677295/blog/4337988-e7742e9a14f46e1a.png_xjd71n.png)
3. 前两个元素的位置已经没错了,然后以第三个元素为标准,和后面的元素进行比较.
   ![比较之后](https://res.cloudinary.com/dewu7okpv/image/upload/v1675677308/blog/4337988-e51bf6b6f28eccf0.png_tnhswf.png)
4. 把比他小的元素放在他的右边(绿色),然后让它和绿色的最后一个交换位置.
   ![交换位置](https://res.cloudinary.com/dewu7okpv/image/upload/v1675677318/blog/4337988-9635a1d9604436b6.png_szfwch.png)
5. 然后从左边没有确定位置的元素(非橙色)开始以上步骤----也就是 19
   ![从19开始](https://res.cloudinary.com/dewu7okpv/image/upload/v1675677329/blog/4337988-b3888a1ab15ac163.png_cmauin.png)
6. 一直到所有元素的位置都正确.
   ![都有了正确的位置](https://res.cloudinary.com/dewu7okpv/image/upload/v1675677342/blog/4337988-782962d8fbda2a3b.png_st4aae.png)
7. 代码实现

```js
function quickSort(array) {
  function quick(array, left, right) {
    let index;
    if (array.length > 1) {
      index = partition(array, left, right);
      if (left < index - 1) {
        quick(array, left, index - 1);
      }
      if (index < right) {
        quick(array, index, right);
      }
    }
    return array;
  }
  function partition(array, left, right) {
    const pivot = array[Math.floor((right + left) / 2)];
    let i = left;
    let j = right;

    while (i <= j) {
      while (array[i] < pivot) {
        i++;
      }
      while (array[j] > pivot) {
        j--;
      }
      if (i <= j) {
        [array[i], array[j]] = [array[j], array[i]];
        i++;
        j--;
      }
    }
    return i;
  }
  quick(array, 0, array.length - 1);
}
```

### 6. 随机快速排序

顾名思义,就是在快速排序的基础上,加入随机的机制.
在快速排序的时候我们是从左到右来选取比较对象,在随机快速排序中我们是随机来选取对象.
流程如下:

1. 拿到一个数组
   ![数组](https://res.cloudinary.com/dewu7okpv/image/upload/v1675677357/blog/4337988-b7dd0bc29bf1f856.png_telq2a.png)
2. 随机选择一个元素.
   ![随机选择到了44](https://res.cloudinary.com/dewu7okpv/image/upload/v1675677376/blog/4337988-068de5de14fbba31.png_wfjwhx.png)
3. 并且把比他小的放在他的右边
   ![把比他小的先放在他的右边](https://res.cloudinary.com/dewu7okpv/image/upload/v1675677391/blog/4337988-903e43f47d9288a3.png_hbw7co.png)
4. 然后把他和比他小的最右边的元素交换位置
   ![交换位置](https://res.cloudinary.com/dewu7okpv/image/upload/v1675677402/blog/4337988-9716186d31f495f7.png_lwmdof.png)
5. 然后在随机选一个元素,重复步骤,知道所有元素都是在正确的位置上.
   ![所有元素都在正确的位置上](https://res.cloudinary.com/dewu7okpv/image/upload/v1675677414/blog/4337988-5eed2e2fa3aaf364.png_dnv2bd.png)
6. 代码实现

```js
function quickSort(array) {
  function quick(array, left, right) {
    let index;
    if (array.length > 1) {
      index = partition(array, left, right);
      if (left < index - 1) {
        quick(array, left, index - 1);
      }
      if (index < right) {
        quick(array, index, right);
      }
    }
    return array;
  }
  function partition(array, left, right) {
    const pivot = array[Math.floor(Math.random() * array.length)];
    let i = left;
    let j = right;

    while (i <= j) {
      while (array[i] < pivot) {
        i++;
      }
      while (array[j] > pivot) {
        j--;
      }
      if (i <= j) {
        [array[i], array[j]] = [array[j], array[i]];
        i++;
        j--;
      }
    }
    return i;
  }
  quick(array, 0, array.length - 1);
}
```
