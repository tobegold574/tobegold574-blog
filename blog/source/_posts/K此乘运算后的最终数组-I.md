---
title: K次乘运算后的最终数组 I
date: 2024-12-13 16:04:02
tags:
    - 堆
    - 每日一题
    - leetcode
---

## K此乘运算后的最终数组 I(easy)
### 做题过程
本来觉得easy不应该要用到小根堆，毕竟上一道是hard，但发现还是小根堆，虽然模拟通得过。

### 算法概述
[原题](https://leetcode.cn/problems/final-array-state-after-k-multiplication-operations-i/description/)

本体要求为取当前数组中最前面的最小值，乘以给定数字，对次操作重复K次，返回原地操作的结果。 ***小根堆*** 。

### JAVA
```java
class Solution {
    public int[] getFinalState(int[] nums, int k, int multiplier) {
        int n=nums.length;
        // 当值相同时，要比较索引，靠前的优先级更高
        PriorityQueue<int[]> queue=new PriorityQueue<>((a,b)->{
            if(a[0]==b[0]) return a[1]-b[1];
            return a[0]-b[0];
        });
        for(int i=0;i!=n;++i){
            queue.offer(new int[]{nums[i],i});
        }
        for(int i=0;i!=k;++i){
            int[] top=queue.poll();
            int idx=top[1];
            nums[idx]*=multiplier;
            queue.offer(new int[]{nums[idx],idx});
        }
        return nums;
    }
}
```

### 总结
还是用堆存储数组的思想，把 **值和索引** 插入，和昨天的题的差别无非就是昨天的题是二维的。
 
