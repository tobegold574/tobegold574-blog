---
title: 切蛋糕的最小开销 II
date: 2024-12-31 09:57:48
tags:
    - 贪心算法
    - 每日一题
    - leetcode
mathjax: true
---

## 切蛋糕的最小开销 II(hard)
### 做题过程
数据量变大了，然后试了一下就改数据类型，做I时用的贪心+优先队列也能过，但表现很差。就是其实不用优先队列也行。

### 算法概述
[原题](https://leetcode.cn/problems/minimum-cost-for-cutting-cake-ii/description/)

本题要求为给出对二维矩阵（蛋糕）不同轴线上横切竖切的代价，要求计算分成1*1的最小代价。一样的贪心，但是不用优先队列。
- 时间复杂度为$O(m \times \log{m} + n \times \log{n})$
- 空间复杂度为$O(\log{m}+\log{n})$

### JAVA
```java
class Solution {
    public long minimumCost(int m, int n, int[] horizontalCut, int[] verticalCut) {
        // 一样的操作，排序，但使用数组而不是堆
        Arrays.sort(horizontalCut);
        Arrays.sort(verticalCut);
        int h = 1, v = 1;
        long res = 0;
        // 最大的
        int horizontalIndex = horizontalCut.length - 1, verticalIndex = verticalCut.length - 1;
        while (horizontalIndex >= 0 || verticalIndex >= 0) {
            if (verticalIndex < 0 || (horizontalIndex >= 0 && horizontalCut[horizontalIndex] > verticalCut[verticalIndex])) {
                res += horizontalCut[horizontalIndex--] * h;
                v++;
            } else {
                res += verticalCut[verticalIndex--] * v;
                h++;
            }
        }
        return res;
    }
}
```

### 总结
还以为有什么很高级的算法，其实和I思路没差，就是用不着堆。


