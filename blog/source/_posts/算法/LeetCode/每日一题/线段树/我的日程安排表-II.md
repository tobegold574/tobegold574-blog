---
title: 我的日程安排表 II
date: 2025-01-03 13:09:25
tags:
    - 线段树
    - 每日一题
    - leetcode
mathjax: true
---

## 我的日程安排表 II🟨
### 做题过程
本来以为把I中的哈希集合改成哈希表就行了，但是懒标记不能像I中那么处理了。

### 算法概述
[原题](https://leetcode.cn/problems/my-calendar-ii/description/)

本题要求为用一个类来管理日程安排（区间单位），当交叉或者重叠的区间超过三次，则不再插入，返回错误。还是使用 ***线段树*** 或者说 ***差分数组*** 。
线段树：
- 时间复杂度为$O(n \log{C})$：$\log{C}$ 为线段树的最大深度
- 空间复杂度为$O(n \log{C})$

差分数组：
- 时间复杂度为$O(n \log{n})$：元素最大个数是2n，2略了，然后是红黑树的操作需要
- 空间复杂度为$O(n)$：就2n，常数不看

### JAVA
```java
// 线段树
class MyCalendarTwo {
    Map<Integer, int[]> tree;

    public MyCalendarTwo() {
        tree = new HashMap<Integer, int[]>();
    }

    public boolean book(int start, int end) {
        // 更新在前没有关系，因为update内部有创建哈希表实例
        update(start, end - 1, 1, 0, 1000000000, 1);
        // 处理边界情况
        tree.putIfAbsent(1, new int[2]);
        if (tree.get(1)[0] > 2) {
            // 撤销操作
            update(start, end - 1, -1, 0, 1000000000, 1);
            return false;
        }
        return true;
    }

    public void update(int start, int end, int val, int l, int r, int idx) {
        if (r < start || end < l) {
            return;
        } 
        // 每个节点都需要有一个标记数组，其中第0个元素代表一般标记，第1个元素代表懒标记(safeguard)
        tree.putIfAbsent(idx, new int[2]);
        // 完全覆盖的情况（这块代码在隐式栈的栈顶）
        if (start <= l && r <= end) {
            tree.get(idx)[0] += val;
            tree.get(idx)[1] += val;
        } else {
            int mid = (l + r) >> 1;
            update(start, end, val, l, mid, 2 * idx);
            update(start, end, val, mid + 1, r, 2 * idx + 1);
            // 注意这里才添加哈希表内的实例，这里在栈顶以下
            tree.putIfAbsent(2 * idx, new int[2]);
            tree.putIfAbsent(2 * idx + 1, new int[2]);
            // 懒标记和子区间最大标记次数的和
            tree.get(idx)[0] = tree.get(idx)[1] + Math.max(tree.get(2 * idx)[0], tree.get(2 * idx + 1)[0]);
        }
    }
}

// 差分数组
class MyCalendarTwo {
    TreeMap<Integer, Integer> cnt;

    public MyCalendarTwo() {
        // 用于存放时间边界的频次
        cnt = new TreeMap<Integer, Integer>();
    }

    public boolean book(int start, int end) {
        // 最大预约次数
        int maxBook = 0;
        // 一个独立区间顺序遍历时正好+1-1抵消掉，也就代表开始和结束
        cnt.put(start, cnt.getOrDefault(start, 0) + 1);
        cnt.put(end, cnt.getOrDefault(end, 0) - 1);
        // 暴力遍历
        for (Map.Entry<Integer, Integer> entry : cnt.entrySet()) {
            // 如果有重叠则maxBook会在-1之前大于2
            int freq = entry.getValue();
            maxBook += freq;
            // 注意这里是在for内部每轮都要检查，这是核心
            if (maxBook > 2) {
                cnt.put(start, cnt.getOrDefault(start, 0) - 1);
                cnt.put(end, cnt.getOrDefault(end, 0) + 1);
                return false;
            }
        }
        return true;
    }
}
```

#### 重要实例方法及属性(JAVA)
`tree.putIfAbsent(key,value)`：有还是没有

### 总结
线段树的核心思路在这道题中的体现即用lazy标记，也就是数组中的第1个元素来记录当前区间是否与目标区间完美匹配（被目标区间完全包含），而第0个元素则用来在查询的过程中向上传递子节点的状态，一直到栈底，也就是面向整个数据有效范围的查询。总的来说：
- 一般标记的用途是记录在该节点（区间）下方（包括自身）的子节点有多少次标记，由子节点向上传递标记来更新。
- 懒标记的用途是记录该节点（区间）被目标区间包含（标记）的次数。
- 一般标记需要向上传播，可以看作一种媒介，而懒标记则可以看作实际向上传播的主体。

还需要注意的细节：
- 完全二叉树式的序号关系。
- 栈顶是最小的匹配节点，更新的搜索是自顶向下的，而更新是自底向上的。

相对来说，差分数组的思路很直观：
1. 先将预约加入
2. 通过`TreeMap`有序遍历所有预约从开始到结束（这里利用了`TreeMap`的特性： **有序** ）
3. 每个时间点的遍历都会检查`maxBook`是否超出了条件，超出则撤销

这里的优化点就是`TreeMap`基于红黑树实现，复杂度较低，且有序，不然标记数组其实也行（如果有效数据范围小的话）。关键是 **保证时间顺序** 的同时记录频次。
