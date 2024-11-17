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
### 算法概述
[原题](https://leetcode.cn/problems/two-sum/?envType=study-plan-v2&envId=top-100-liked)

两数之和是hot100中的一道简单题，要求从给出的数组中找到可以作为给出的目标值的两个加数的组合。不管是调用 **java** 中的 ***HashMap*** 的还是 **c++** 中的 ***unordered_map*** 哪种容器类，还是c中的uthash的宏，这道题的核心都是插入与查找。除此之外，还需要注意的是，哈希映射的核心并不只是创建了一种新表通过算法使每个值都变得特殊且好找，而是通过反向插入，使键变为值，由此使查找工作变得简单的。
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
- `Map<Integer,Integer> hashtable=new HashMap<Integer,Integer>()`：使用HashMap接口，记得声明对键值对类型
- `hashtable.containsKey(arg)`：查询是否存在对应键
- `hashtable.put(key,value)`：将元素放入表中

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
- `hashtable.find(key)`：查键，找到了返回对应迭代器，没找到返回end()迭代器（最后一个元素之后的位置）
- `hashtable.end()`：最后一个元素再往后的位置
- `return {it->second,i}`：`it->second`指向迭代器中的值（first对应键），这样返回会自动传给vector的构造器构造完再返回
- `hashtable[nums[i]]=i`：`[]`为键，插入键值对

### 注意
![运行结果](/images/两数之和运行结果.png)
可以看出尽管代码逻辑一模一样，但是C++在包装容器类时相对java做的更加简单，这样得到的优势是在内存上优于java，但也正是因为容器的方法摈弃了复杂的优化，所以运行速度上稍慢。
同时，使用双循环遍历虽然时间复杂度上大大落后，但由于并不需要使用到容器类，不需要哈希映射的缘故，在内存上更优。

## 字母异位词分组
### 算法概述
[原题](https://leetcode.cn/problems/group-anagrams/?envType=study-plan-v2&envId=top-100-liked)

与两数之和一样，都需要熟悉如何使用哈希表作为工具解决查找的问题，但区别在于这道题多了一层需要考虑用什么来作键，用什么来作为值的问题，这道题要求找出在字符串数组中存在的含有相同字母的字符串并分组。这里采用的就是通过排序解决此问题。

- 时间复杂度为O(nklogk)：k是字符串元素的最大长度，n是字符串数量，klogk用于排序，n*1用于遍历字符串数组构建哈希表
- 空间复杂度为O(nk)：k是字符串元素的最大长度，n是字符串数量

### Java
```bash
class Solution {
    public List<List<String>> groupAnagrams(String[] strs) {
        Map<String,List<String>> map=new HashMap<String,List<String>>();
        // 遍历所有字符串
        for (String str:strs){
            // 将字符串分割成字符数组
            char[] array=str.toCharArray();
            // 按unicode排序
            Arrays.sort(array);
            // 将排序后的字符串作为键，
            String key=new String(array);
            // 从哈希表中查找对应键的值的列表，不存在就生成一个空的返回
            List<String> list =map.getOrDefault(key,new ArrayList<String>());
            // 将新的字符串加入到值的列表中
            list.add(str);
            // 为已有的键值添加新值后放回哈希表或者初始化键值对
            map.put(key,list);
        }
        // 返回一个包含所有各个值的分类的列表的列表，
        return new ArrayList<List<String>>(map.values());
    }
}
```
#### 重要实例方法及属性(JAVA)
- `for (String str:strs)`：for-each访问，快但只读
- `str.toCharArray()`：String的实例方法，将字符串转为字符数组
- `Arrays.sort(str)`：Arrays是静态方法工具类，sort()使str按照unicode排序，直接修改，不返回
- `map.getOrDefault(key,defaultvalue)`：查键，查不到返回默认值（由第二个参数指定）
- `new ArrayList<List<String>>()`：`List<String>`作为ArrayList的元素类型
- `map.values()`：返回`Collection<V>`，也就是可读可写的视图

### C++
```bash
class Solution {
public:
    vector<vector<string>> groupAnagrams(vector<string>& strs) {
        unordered_map<string,vector<string>> mp;
        for (string& str:strs){
            string key=str;
            // 排序
            sort(key.begin(),key.end());
            // 对当前字符串生成的键插入当前字符串的值
            mp[key].emplace_back(str);
        }
        // 重新创建一个列表的列表用于放置答案
        vector<vector<string>> ans;
        // 通过循环将每个键值对的值逐个插入
        for(auto it=mp.begin();it!=mp.end();++it){
            ans.emplace_back(it->second);
        }
        return ans;
}
};
```

#### 重要实例方法及属性(C++)
- `sort(container.begin(),container.end())`：面向STL的排序算法
- `vector.emplace_back`：直接在vector末尾创建新对象
- `for(auto it=mp.begin();it!=mp.end();++it)`：迭代器遍历

### 注意
此处java和C++的差别就在于，java拥有视图(`map.values()`)可以直接访问哈希表内部属性，但C++必须依靠迭代器(`for(auto it=mp.begin();it!=mp.end();++it)`)进行访问。

## 最长连续序列
### 算法概述
[原题](https://leetcode.cn/problems/longest-consecutive-sequence/?envType=study-plan-v2&envId=top-100-liked)

用哈希表不是很好的解法，所以不作例子了。建议直接排序。