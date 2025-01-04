---
title: 我的日程安排表 III
date: 2025-01-04 10:08:17
tags:
    - 线段树
    - 每日一题
    - leetcode
mathjax: true
---

## 我的日程安排表 III🟨
### 做题过程
用线段树写起来很麻烦，就差分很快写完了，在能不能剪枝上卡了一下，后面还是没有剪枝，好像不能剪枝。

### 算法概述
[原题](https://leetcode.cn/problems/my-calendar-iii/description/)

本题要求为每次加入预定区间后返回预定区间最大重叠次数。差分太简单了，还是以线段树为准。
- 时间复杂度为$O(m \times \log{m} + n \times \log{n})$
- 空间复杂度为$O(\log{m}+\log{n})$

### JAVA
```java
class MyCalendarThree {
    // II用了一个值为数组的哈希表，其实同理
    private Map<Integer, Integer> tree;
    private Map<Integer, Integer> lazy;

    public MyCalendarThree() {
        tree = new HashMap<Integer, Integer>();
        lazy = new HashMap<Integer, Integer>();
    }
    
    public int book(int start, int end) {
        update(start, end - 1, 0, 1000000000, 1);
        return tree.getOrDefault(1, 0);
    }

    public void update(int start, int end, int l, int r, int idx) {
        if (r < start || end < l) {
            return;
        } 
        if (start <= l && r <= end) {
            tree.put(idx, tree.getOrDefault(idx, 0) + 1);
            lazy.put(idx, lazy.getOrDefault(idx, 0) + 1);
        } else {
            int mid = (l + r) >> 1;
            update(start, end, l, mid, 2 * idx);
            update(start, end, mid + 1, r, 2 * idx + 1);
            // 和II一样的，还是子树中的最大标记次数和当前节点自身的标记次数
            tree.put(idx, lazy.getOrDefault(idx, 0) + Math.max(tree.getOrDefault(2 * idx, 0), tree.getOrDefault(2 * idx + 1, 0)));
        }
    }
}
```

### 总结
线段树思路回顾[我的日程安排表 II](https://tobegold574.me/2025/01/03/%E6%88%91%E7%9A%84%E6%97%A5%E7%A8%8B%E5%AE%89%E6%8E%92%E8%A1%A8-II/)。

 
