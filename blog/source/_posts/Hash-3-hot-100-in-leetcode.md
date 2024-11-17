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
两数之和是hot100中的一道简单题，不管是调用**java**中的__HashMap__的还是**c++**中的__unordered_map__哪种容器类，还是c中的uthash的宏，这道题的核心都是插入与查找。
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
                // 存在就直接返回
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

#### 重要实例方法(JAVA)
`HashMap<Integer,Integer>`：使用HashMap接口，记得声明对键值对类型
`hashtable.containsKey(arg)`：查询是否存在对应值
`hashtable.put(value,key)`：将元素放入表中
