---
title: 子串(3) --hot 100 in leetcode
date: 2024-11-19 22:27:08
tags:
    - 子串
    - hot 100
    - leetcode
---

<script type="text/javascript"
src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>

## 和为K的子数组
### 算法概述
[原题](https://leetcode.cn/problems/subarray-sum-equals-k/description/?envType=study-plan-v2&envId=top-100-liked)

题目要求为给定数组中有多少个子数组的加和为k。使用前缀和和哈希表，实际上也是把问题从“串”的维度降为“数”的维度，从“和为k的子数组”变为了两数之和，但是中间加了一层抽象，可以参考一下[两数之和](https://tobegold574.me/2024/11/17/Hash-3-hot-100-in-leetcode/)。
- 时间复杂度为O(n)：只遍历一次
- 空间复杂度为O(n)：需要另外创建哈希表，最坏情况需要n的空间大小

### JAVA
```bash
class Solution {
    public int subarraySum(int[] nums, int k) {
        // 计数答案和前缀
        int count=0,pre=0;
        // 哈希表用于存储前缀和（键）和前缀和出现次数（值）
        HashMap<Integer,Integer> mp=new HashMap<>();
        // 开始时都是空的，相当于0出现了一次，也就是[]也可以是答案
        mp.put(0,1);
        // 遍历数组
        for(int i=0;i<nums.length;i++){
            // 前缀累和
            pre+=nums[i];
            // 类似两数之和
            // 如果哈希表中存在当前累和与目标值的差值，就意味着另一个加数（子串），也就是匹配的子串，也存在   
            if(mp.containsKey(pre-k)){
                // 添加那个数的统计频次，也就是说子串的出现频次
                count+=mp.get(pre-k);
            }
            // 将当前累和作为键放入，值是更新之前这个累和的出现频次自增，或者初始为1
            mp.put(pre,mp.getOrDefault(pre,0)+1);
        }
        return count;
    }
}
```

### C++
```bash
class Solution {
public:
    int subarraySum(vector<int>& nums, int k) {
        // 哈希表
        unordered_map<int, int> mp;
        // 直接用重载[]索引
        mp[0] = 1;
        int count = 0, pre = 0;
        // for-each遍历
        for (auto& x:nums) {
            pre += x;
            if (mp.find(pre - k) != mp.end()) {
                count += mp[pre - k];
            }
            mp[pre]++;
        }
        return count;
    }
};
```

#### 重要实例方法及属性(C++)
主要是用了`[]`索引和 ***for-each*** 遍历更加方便，主要还是要记住之前记过的`find()`找不到返回`end()`。

### 注意
这道题需要考虑如何把子串转换成能够计算的单位，这里用到的是“前缀和”的思想，通过前缀和将不同长度的符合条件的子串变为了字典类型，而键作为匹配条件，值用于计数，要善于思考将复杂问题“放缩”。

## 滑动窗口最大值
### 算法概述
[原题](https://leetcode.cn/problems/sliding-window-maximum/description/?envType=study-plan-v2&envId=top-100-liked)

这道题目要求在实现基本的滑动窗口的基础上找到滑动窗口内的最大值。在求最大值这类窗口内部的某个特殊的值，而非整个窗口的整体性质时，要考虑的就是窗口移动时的特性，即 **每次移动** 都共用了 **k-1个元素** ，只有 **一个元素** 在变化，由此找到优化的方法，也就是把在滑动窗口整体中寻找最大值降为 **窗口首尾** 的变化。

使用双向队列来解决，通过只存储一系列单调排列的值，在滑动窗口移动的时候，只会读取新值和抛弃可能超出边界的队首，关键点在于不仅 **队列内部的值是单调排列的，而且索引也是从小到大** ，这就是为什么用两个while，而不是if。

### JAVA
```bash
class Solution {
    public int[] maxSlidingWindow(int[] nums, int k) {
        int n=nums.length;
        \\ 创建双向队列（以双向链表linkedLsit为实现，随机访问慢，插入高效）
        Deque<Integer> deque=new LinkedList<Integer>();
        \\ 初始化滑动窗口
        for(int i=0;i<k;++i){
            \\ 如果当前遍历元素>=队列末端元素，移除末端元素（相当于排序，队首元素最大）
            while(!deque.isEmpty()&&nums[i]>=nums[deque.peekLast()]){
                deque.pollLast();
            }
            \\ 当前元素索引入队列末端
            deque.offerLast(i);
        }
        \\ 答案
        int[] ans=new int[n-k+1];
        \\ 第一个滑动窗口已经处理完，当前队首元素作为第一个答案
        ans[0]=nums[deque.peekFirst()];
        \\ 从滑动窗口右侧开始遍历
        for(int i=k;i<n;++i){
            \\ 重复初始化时的入队预处理
            while(!deque.isEmpty()&&nums[i]>=nums[deque.peekLast()]){
                deque.pollLast();
            }
            deque.offerLast(i);
            \\ 当队首元素索引小于i-k，也就是在滑动窗口左边界之外的元素被移除
            while(deque.peekFirst()<=i-k){
                deque.pollFirst();
            }
            \\ 队首元素始终是最大值
            ans[i-k+1]=nums[deque.peekFirst()];
        }
        return ans;

    }
}
```

#### 重要实例方法及实现(JAVA)
`Deque<Integer> deque=new LinkedList<Integer>()`：双向队列(double-ended queue)接口及实现实例化
`deque.peekLast()`：查看队尾元素
`deque.peekFirst()`：查看队首元素
`deque.pollFirst()`：移除并返回队首元素
`deque.pollLast()`：移除并返回队尾元素
`deque.offerLast()`：添加元素入队尾
`deque.isEmpty()`：检查队列是否为空

### C++
```bash
class Solution {
public:
    vector<int> maxSlidingWindow(vector<int>& nums, int k) {
        int n = nums.size();
        \\ 双向队列
        deque<int> q;
        for (int i = 0; i < k; ++i) {
            \\ 空或不在单调排列
            while (!q.empty() && nums[i] >= nums[q.back()]) {
                q.pop_back();
            }
            \\ 读取
            q.push_back(i);
        }
        \\ 列表初始化
        vector<int> ans = {nums[q.front()]};
        for (int i = k; i < n; ++i) {
            \\ 同上
            while (!q.empty() && nums[i] >= nums[q.back()]) {
                q.pop_back();
            }
            q.push_back(i);
            \\ 索引超出，丢弃
            while (q.front() <= i - k) {
                q.pop_front();
            }
            \\ 读取
            ans.push_back(nums[q.front()]);
        }
        return ans;
    }
};
```

#### 重要实例方法及属性(C++)
`deque.pop_back()`：删除队尾元素（deque特有）
`deque.pop_front()`：删除队首元素（deque特有）
`deque.empty()`：检查是否为空
`deque.front()`：返回队首元素引用
`deque.back()`：返回队尾元素引用
`deque.at()`：（带边界检查）索引
`[]`：（不带边界检查）索引

### 注意
这里的基础结构还是滑动窗口，但其实只表现为 ***i*** 和 ***i+k*** 这两个索引罢了。真正的内核就是在滑动窗口之上用单调队列来管理一些真正有用的属性，一定要学会像这样分离然后分层的思想。