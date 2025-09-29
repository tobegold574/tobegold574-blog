---
title: K次乘运算后的最终数组 II
date: 2024-12-14 14:14:31
tags:
    - 堆
    - 每日一题
    - leetcode
mathjax: true
---

## K次乘运算后的最终数组 II(hard)
### 做题过程
本来以为可以直接用昨天的解法加一个取模就结束了，但实际上还需要对操作做更精细的算法优化，不懂。

### 算法概述
[原题](https://leetcode.cn/problems/final-array-state-after-k-multiplication-operations-ii/description/)

本题要求与I无异，主要问题在于输入将会很大。 ***最小堆+快速幂*** 。
- 时间复杂度为$O\left(n \times \left(\log n \log m_x + \log \left(\frac{n}{k}\right) \right)\right)
$：$m_x$指的是最大值，右括号内的第一个参数是出堆入堆，二个参数是快速幂
- 空间复杂度为O(n)

### JAVA
```java
class Solution {
    // 二分法指数法则
    private long quickMul(long x, long y, long m) {
        long res = 1;
        while (y > 0) {
            // 只有到了1位才更新res
            if ((y & 1) == 1) {
                res = (res * x) % m;
            }
            y >>= 1;
            // 每次都进行平方
            x = (x * x) % m;
        }
        return res;
    }

    // 避免重复对堆进行计算（优化处理较大K）
    public int[] getFinalState(int[] nums, int k, int multiplier) {
        if (multiplier == 1) {
            return nums;
        }
        int n = nums.length, mx = 0;
        long m = 1000000007L;
        PriorityQueue<long[]> v = new PriorityQueue<>((x, y) -> {
            if (x[0] != y[0]) {
                return Long.compare(x[0], y[0]);
            } else {
                return Long.compare(x[1], y[1]);
            }
        });
        for (int i = 0; i < n; i++) {
            mx = Math.max(mx, nums[i]);
            v.offer(new long[]{nums[i], i});
        }
        for (; v.peek()[0] < mx && k > 0; k--) {
            long[] x = v.poll();
            x[0] *= multiplier;
            v.offer(x);
        }
        for (int i = 0; i < n; i++) {
            // 还是从堆中取元素出来
            long[] x = v.poll();
            // 计算第一次乘完之后那些重复计算的次数
            int t = k / n + (i < k % n ? 1 : 0);
            nums[(int)x[1]] = (int)((x[0] % m) * quickMul(multiplier, t, m) % m);
        }
        return nums;
    }
}
```

### 总结
非常非常 **缜密** 的代码，都是一环扣一环的，需要 **非常熟练地掌握** 。

 
