---
title: 我的日程安排表 I
date: 2025-01-02 12:22:56
tags:
    - 线段树
    - 每日一题
    - leetcode
mathjax: true
---

## 我的日程安排表 I🟨
### 做题过程
想不到用哈希表存的其他方法，感觉最优的策略就是每次存储然后跟哈希表的每个`entrySet`做比较。

### 算法概述
[原题](https://leetcode.cn/problems/my-calendar-i/description/)

本题要求为用一个类来管理日程安排，每次输入开始时间和结束时间，如果没有时间重叠则可放入类内，如有冲突时间，则返回错误。使用直接遍历（或二分查找优化），或者是 ***线段树*** 。
- 时间复杂度为$O(n \log{C})$：$\log{C}$ 为线段树的最大深度
- 空间复杂度为$O(n \log{C})$

### JAVA
```java
class MyCalendar {
    // 使用两个集合负责查询
    Set<Integer> tree;
    Set<Integer> lazy;

    public MyCalendar() {
        // 负责递归定向
        tree = new HashSet<Integer>();
        // 负责精细的查询操作
        lazy = new HashSet<Integer>();
    }

    public boolean book(int start, int end) {
        // 查到了就返回错误
        if (query(start, end - 1, 0, 1000000000, 1)) {
            return false;
        }
        // 没查到就更新线段树
        update(start, end - 1, 0, 1000000000, 1);
        return true;
    }

    public boolean query(int start, int end, int l, int r, int idx) {
        // 如果没有交集，说明与道歉子树无关
        if (start > r || end < l) {
            return false;
        }
        // lazy提供精细查询的功能，也就是直接和线段树每个节点的序号绑定（匹配小于等于当前范围的匹配）
        if (lazy.contains(idx)) {
            return true;
        }
        // 如果目标区间更大，则通过tree来查询（tree记录了被标记过的区间，更大也意味着也属于被操作区间）
        if (start <= l && r <= end) {
            return tree.contains(idx);
        } else {
            // 二分递归
            int mid = (l + r) >> 1;
            if (end <= mid) {
                // 左子树序号(2*父节点序号)
                return query(start, end, l, mid, 2 * idx);
            } else if (start > mid) {
                // 右子树序号(2*父节点序号+1)
                return query(start, end, mid + 1, r, 2 * idx + 1);
            } else {
                // 左右各占一部分，则两边都要查，按位或（只要有1就返回1）
                return query(start, end, l, mid, 2 * idx) | query(start, end, mid + 1, r, 2 * idx + 1);
            }
        }
    }

    public void update(int start, int end, int l, int r, int idx) {
        // 无交集，不需要操作此区间
        if (r < start || end < l) {
            return;
        } 
        // 完全覆盖当前递归区间
        if (start <= l && r <= end) {
            tree.add(idx);
            lazy.add(idx);
            // 递归，以及存在部分交集的情况下需要加入tree
        } else {
            int mid = (l + r) >> 1;
            update(start, end, l, mid, 2 * idx);
            update(start, end, mid + 1, r, 2 * idx + 1);
            tree.add(idx);
        }
    }
}
```

### 总结
线段树是一种静态的结构，从整个数据的可能存在范围向下二分递归，为可能相关的区间提供标记，虽然没有真的构造出一棵树，但是通过序号之间的关系模拟了树的遍历过程以及节点之间的关系，所以在这种数据结构中，遍历（或者操作）的核心单位是 **序号** ，只有通过遍历到达了某一序号我们才可以进行操作或者查询，序号即区间。

**还是很陌生的，有很多实现细节要注意，需要背记** 。