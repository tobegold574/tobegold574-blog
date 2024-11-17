---
title: Hash(3) --hot 100 in leetcode
date: 2024-11-17 16:20:10
tags:
    - 哈希
    - hot 100
    - leetcode
---

<script type="text/javascript"
src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>

## 两数之和 
### 算法简介
[原题](https://leetcode.cn/problems/two-sum/?envType=study-plan-v2&envId=top-100-liked)

两数之和是hot100中的一道简单题，不管是调用 **java** 中的 ***HashMap*** 的还是 **c++** 中的 ***unordered_map*** 哪种容器类，还是c中的uthash的宏，这道题的核心都是插入与查找，除此之外。还需要注意的是，哈希映射的核心并不只是创建了一种新表通过算法使每个值都变得特殊且好找，而是通过反向插入，使键变为值，由此使查找工作变得简单的。
- 时间复杂度为O(n)：一次遍历用于插入，查找无需遍历
- 空间复杂度为O(n)：存储所有元素的哈希映射结果

### JAVA
```bash
class Solution {
    public int[] twoSum(int[] nums, int target) {
        // 创建哈希表的新实例（Map是接口，HashMap是接口实现）
        Map<Integer,Integer> hashtable=new HashMap<Integer,Integer>();
        // 遍历整个数组
        for(int i=0;i!=nums.length;++i){
            // 判断表内是否已经存在（插入过）与当前元素加起来能得到结果的元素
            if(hashtable.containsKey(target-nums[i])){
                // 存在就直接返回 注意这里get()返回的是索引（反向查找）
                return new int[] {hashtable.get(target-nums[i]),i};
            }
            // 到这里就说明还不存在，此时遍历到的元素还未映射入哈希表，这里将其放入表中
            hashtable.put(nums[i],i);
        }
        // 空白返回
        return new int[0];
    }
}
```

#### 重要实例方法及属性(JAVA)
`Map<Integer,Integer> hashtable=new HashMap<Integer,Integer>()`：使用HashMap接口，记得声明对键值对类型
`hashtable.containsKey(arg)`：查询是否存在对应键
`hashtable.put(key,value)`：将元素放入表中

### C++
```bash
class Solution {
public:
    vector<int> twoSum(vector<int>& nums, int target) {
        // 使用unordered_map容器类
        unordered_map<int,int> hashtable;
        // 遍历整个数组
        for(int i=0;i<nums.size();++i){
            // 判断表内是否已经存在（插入过）与当前元素加起来能得到结果的元素
            auto it = hashtable.find(target-nums[i]);
            // 找到就返回
            if(it !=hashtable.end()){
                return {it->second,i};
            }
            // 不存在就反向插入，以值为键，以键为值
            hashtable[nums[i]]=i;
        }
        return {};
    }
};
```

#### 重要实例方法及属性(C++)
`hashtable.find(key)`：查键，找到了返回对应迭代器，没找到返回end()迭代器（最后一个元素之后的位置）
`hashtable.end()`：最后一个元素再往后的位置
`return {it->second,i}`：`it->second`指向迭代器中的值（first对应键），这样返回会自动传给vector的构造器构造完再返回
`hashtable[nums[i]]=i`：`[]`为键，插入键值对

### 注意
![运行结果](..\images\两数之和运行结果.png)
可以看出尽管代码逻辑一模一样，但是C++在包装容器类时相对java做的更加简单，这样得到的优势是在内存上优于java，但也正是因为容器的方法摈弃了复杂的优化，所以运行速度上稍慢。
同时，使用双循环遍历虽然时间复杂度上大大落后，但由于并不需要使用到容器类，不需要哈希映射的缘故，在内存上更优。