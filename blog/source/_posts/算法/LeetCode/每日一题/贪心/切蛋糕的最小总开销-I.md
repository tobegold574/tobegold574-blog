---
title: 切蛋糕的最小总开销 I
date: 2024-12-25 09:38:23
tags:
    - 贪心算法
    - 每日一题
    - leetcode
---

## 切蛋糕的最小总开销 I(medium)
### 做题过程
用贪心+优先队列的思路过了一半的用例，又小修了一下，过了，复杂度上应该优于动态规划的，但是测试用例给出比动态规划慢，不知道为什么。

### 算法概述
[原题](https://leetcode.cn/problems/minimum-cost-for-cutting-cake-i/description/)

本题要求为给出对二维矩阵（蛋糕）不同轴线上横切竖切的代价，要求计算分成1*1的最小代价。我选择用  ***贪心+优先队列*** 。
- 时间复杂度为O(nlogn+mlogm)：遍历每个切法，然后存到堆里面排序，再拿出来
- 空间复杂度为O(n+m)：两个堆


### JAVA
```java
import java.util.*;

class Solution {
    public int minimumCost(int m, int n, int[] horizontalCut, int[] verticalCut) {
        // 使用降序的优先队列来管理切割点
        PriorityQueue<Integer> x = new PriorityQueue<>(Comparator.reverseOrder());
        PriorityQueue<Integer> y = new PriorityQueue<>(Comparator.reverseOrder());

        // 把横向和纵向切割点分别放入优先队列
        for (int h : horizontalCut) {
            x.offer(h);
        }
        for (int v : verticalCut) {
            y.offer(v);
        }

        int i = 1;  // 横向部分数
        int j = 1;  // 纵向部分数
        int ans = 0;

        // 循环，直到所有的切割点都被用完
        while (!x.isEmpty() || !y.isEmpty()) {
            int xt = (x.isEmpty()) ? Integer.MIN_VALUE : x.peek();
            int yt = (y.isEmpty()) ? Integer.MIN_VALUE : y.peek();

            // 选择当前最有价值的切割点
            if (xt >= yt) {
                // 横向切割
                x.poll();
                ans += xt * j;  // 增加横向切割的成本，乘以当前纵向部分数
                i++;  // 横向部分数增加
            } else {
                // 纵向切割
                y.poll();
                ans += yt * i;  // 增加纵向切割的成本，乘以当前横向部分数
                j++;  // 纵向部分数增加
            }
        }
        return ans;
    }
}
```

### 总结
可能记忆化搜索的剪枝非常给力，但复杂度上应该比贪心差的。






 
