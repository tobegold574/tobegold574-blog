---
title: 贪心算法(4) --hot 100 in leetcode
date: 2024-11-27 12:33:45
tags:
    - 贪心算法
    - hot 100
    - leetcode
---

<script type="text/javascript"
src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>

## 买卖股票的最佳时机
### 算法概述
[原题](https://leetcode.cn/problems/best-time-to-buy-and-sell-stock/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为在给出数组中找出两个差值最大的元素。就是拿两个临时变量存当前的最小值和最大差值，然后 ***动态更新*** 它俩。
- 时间复杂度为O(n)
- 空间复杂度为O(1)

### JAVA
```java
public class Solution {
    public int maxProfit(int prices[]) {
        int minprice = Integer.MAX_VALUE;
        int maxprofit = 0;
        for (int i = 0; i < prices.length; i++) {
            if (prices[i] < minprice) {
                minprice = prices[i];
            // 当当前价格比最小值大时，更新最大利润
            } else if (prices[i] - minprice > maxprofit) {
                maxprofit = prices[i] - minprice;
            }
        }
        return maxprofit;
    }
}
```

### C++
```c++
// 没区别
```

### 注意
在解法中，使用了`else if (prices[i] - minprice > maxprofit)`这样巧妙的细节 **节约了判断的开销** ，因为`maxprofit`一定大于等于0，所以直接用`else if`即可，无需再写一个`else`+内部`if`的形式更新最大差值。


## 跳跃游戏
### 算法概述
[原题](https://leetcode.cn/problems/jump-game/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为给定当前索引可跳跃的距离，判断能否跳到数组末尾。就和上面那道题一样，不断 ***动态更新*** 当前最优解。
- 时间复杂度为O(n)
- 空间复杂度为O(1)

### JAVA
```java
public class Solution {
    public boolean canJump(int[] nums) {
        int n = nums.length;
        int rightmost = 0;
        for (int i = 0; i < n; ++i) {
            if (i <= rightmost) {
                // 当前能达到的最远就是用之前的最远和当前已走过的距离加当前索引上能走的距离作比较
                rightmost = Math.max(rightmost, i + nums[i]);
                if (rightmost >= n - 1) {
                    return true;
                }
            }
        }
        return false;
    }
}
```

### C++
```c++
// 一样的
```

### 注意
但要注意的是，动态更新的 **重点应该直接是目标量，而不是辅助量** 。贪心的最优选择是直接面向目标的。


## 跳跃游戏 II
### 算法概述
[原题](https://leetcode.cn/problems/jump-game-ii/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为在上题背景下，返回到达边界的最少跳跃次数。和上面一道题一样的，区别就是 ***动态更新*** 现在哪一步能跳的多远，每次都选跳的最远的跳。
- 时间复杂度为O(n)：还是要遍历完
- 空间复杂度为O(1)

### JAVA
```java
class Solution {
    public int jump(int[] nums) {
        int length = nums.length;
        int end = 0;
        int maxPosition = 0; 
        int steps = 0;
        for (int i = 0; i < length - 1; i++) {
            // 当前能到的最远距离
            maxPosition = Math.max(maxPosition, i + nums[i]); 
            if (i == end) {
                // 一直遍历到当前能到的最远距离，再算作下一步
                end = maxPosition;
                steps++;
            }
        }
        return steps;
    }
}
```

### C++
```c++
// 能用max()
```

### 注意
都是一样的，主要是要学会怎么组织好代码结构。解法中使用`if (i == end)`来更新步数以及下一个最远距离，需要学会像这样的在贪心基础之上的 **额外判断逻辑** 。


## 划分字母区间
### 算法概述
[原题](https://leetcode.cn/problems/partition-labels/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为将给定字符串划为尽可能多的片段，且某一片段中的字符不可出现在其他片段中，但可以在当前片段重复出现。关键是要更新的是 ***最远边界*** 。
- 时间复杂度为O(n)：还是要遍历完
- 空间复杂度为O(1)

### JAVA
```java
class Solution {
    public List<Integer> partitionLabels(String s) {
        // 记录所有字符的最后出现位置
        int[] last = new int[26];
        int length = s.length();
        for (int i = 0; i < length; i++) {
            last[s.charAt(i) - 'a'] = i;
        }
        List<Integer> partition = new ArrayList<Integer>();
        int start = 0, end = 0;
        for (int i = 0; i < length; i++) {
            // 用当前遍历到的字符的最后出现位置更新片段边界
            end = Math.max(end, last[s.charAt(i) - 'a']);
            if (i == end) {
                // 到了边界就开一个新片段
                partition.add(end - start + 1);
                start = end + 1;
            }
        }
        return partition;
    }
}
```

### C++
```c++
// 没去呗
```

### 注意
最关键的是要用 **最后出现位置** 更新`end`。在贪心中， **至少有一次完整遍历** ，这就意味着并不需要做过多的预处理节省空间，而是要把工作交给遍历。只需要用当前字符的最后出现位置来更新 **当前片段终点** ，那就是 **当前的最优选择** 。

**贪心指的当前最优，是过去与现在的当前**