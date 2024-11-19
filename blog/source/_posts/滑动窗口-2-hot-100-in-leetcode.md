---
title: 滑动窗口(2) --hot 100 in leetcode
date: 2024-11-19 10:55:52
tags:
    - 滑动窗口
    - hot 100
    - leetcode
---

<script type="text/javascript"
src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>

## 无重复字符的最长子串
### 算法概述
[原题](https://leetcode.cn/problems/longest-substring-without-repeating-characters/?envType=study-plan-v2&envId=top-100-liked)

题目要求是返回给出字符串的最长无重复子串长度。同样要用到双指针，但此时双指针的功能不在于 ***减少遍历*** ，而在于 ***定位*** ，也就是创建滑动窗口。
- 时间复杂度为O(n)：看似有两个循环，但实际上对应滑动窗口两侧，滑动窗口只往 ***一个方向*** 动态变化
- 空间复杂度为O(∣Σ∣)：字符集大小，因为要创建容器类对应字符串映射

### JAVA
```bash
class Solution {
    public int lengthOfLongestSubstring(String s) {
        // 创建空集合
        Set<Character> occ=new HashSet<Character>();
        // 虽然用的是集合，但是还是按照原字符串长度遍历
        int n=s.length();
        // 右指针和答案长度
        int rk=-1,ans=0;
        // 左指针遍历字符串
        for(int i=0;i<n;++i){
            // 当左指针>0，去除左指针左侧字符，避免重复遍历
            if(i!=0){
                occ.remove(s.charAt(i-1));
            }
            // 如果右指针下一个字符不重复，则纳入集合，不然停止循环，更新左指针
            while(rk+1<n&&!occ.contains(s.charAt(rk+1))){
                occ.add(s.charAt(rk+1));
                ++rk;
            }
            // 当前长度为滑动窗口动态变化的长度
            ans=Math.max(ans,rk-i+1);
        }
        return ans;
    }
}
```

#### 重要实例方法及属性(JAVA)
- `Set<Character> occ=new HashSet<Character>()`：JAVA使用`Character`代表基本类型`char`的包装类
- `str.length()`：字符串长度
- `str.charAt(index)`：返回参数索引处的字符
- `set.add(element)`：添加非重复元素（如重复则不再添加），返回true或false
- `set.remove(element)`：删除元素，返回true或false
- `set.contains(element)`：是否存在某元素，返回true或flase

### C++
```bash
class Solution {
public:
    int lengthOfLongestSubstring(string s) {
        // 哈希集合
        unordered_set<char> occ;
        int n = s.size();
        // 右指针，初始值为 -1，相当于我们在字符串的左边界的左侧，还没有开始移动
        int rk = -1, ans = 0;
        // 外层循环，移动左指针
        for (int i = 0; i < n; ++i) {
            // 左指针向右移动一格，滑动窗口缩短，移除集合内的头部元素
            if (i != 0) {
                occ.erase(s[i - 1]);
            }
            // 右指针遇到重复字符退出循环，回到外层循环移动左指针
            while (rk + 1 < n && !occ.count(s[rk + 1])) {
                occ.insert(s[rk + 1]);
                ++rk;
            }
            ans = max(ans, rk - i + 1);
        }
        return ans;
    }
};
```

#### 重要实例方法及属性(C++)
- `str[]`：返回值引用
- `str.size()`：与JAVA访问字符串长度属性的方法不同
- `unordered_set<char>`：C++没有基本类型的包装类
- `set.erase(&element_val)`：按值移除元素（重载），返回删除元素数量（对于集合0或1）
- `set.count(&element_val)`：计数元素出现次数，返回次数（对于集合0或1）
- `set.insert(&element_val)`：插入树或哈希表，具体看实现

### 注意
滑动窗口由左指针负责遍历，右指针负责符合条件的定位，滑动窗口本身只是一个 ***工具*** ，并不是用于存储最终结果的，所以需要变量存储最终结果，这与双指针一样。

## 找到字符串中所有字母异位词
题目要求为找到给出字符串中所有目标字符串的字母改变顺序后的变形，并给出它们起始的索引。使用滑动窗口，这道题比上面一道题海多了一层抽象，因为这个题目的要求是 ***找到所有*** ， 而不是 ***找到某一个特殊的*** 。这也就意味着滑动窗口会用于统计最后结果的工具变量之间仍然不是直接联系，在这里， ***differ*** 是用来统计最终结果的，但与之交互的是 ***count*** ，而不是滑动窗口，后者根据滑动窗口的移动统计所有字符频次，而前者则只关心整体差异是否为0，只有一个变量。
- 时间复杂度为O(n+m+Σ)：n+m为两个字符串的长度，∑为可能字符集的长度
- 空间复杂度为O(∑)：需要存储字符集

### JAVA
```bash
class Solution {
    public List<Integer> findAnagrams(String s, String p) {
        \\ 先算好两个字符串长度
        int sLen=s.length(),pLen=p.length();
        \\ 如果用于匹配的字符串还要长，说明肯定没有了
        if(sLen<pLen){
            return new ArrayList<Integer>();
        }
        \\ 空白答案
        List<Integer> ans=new ArrayList<Integer>();
        \\ 整型数组，用于存储字母出现频次
        int[] count=new int[26];
        \\ 对s和p进行字符出现频次比较，以p的长度作为遍历次数
        for(int i=0;i<pLen;++i){
            \\ 对于每一个遍历到的字母，-'a'会将字符转化成数字，也就对应了26个英文字母
            \\ s中出现的字符对应count数组索引的值+1
            ++count[s.charAt(i)-'a'];
            \\ p中出现的字符对应count数组索引的值-1
            --count[p.charAt(i)-'a'];
        }
        \\ 用于记录差异
        int differ=0;
        \\ count内但凡有一个值不为0，即代表不是异位词
        for(int j=0;j<26;++j){
            if(count[j]!=0){
                ++differ;
            }
        }
        \\ 如果differ没有改变，也就是说明第一组滑动窗口匹配成功
        if(differ==0){
            ans.add(0);
        }
        \\ 滑动窗口从下一组匹配对象开始，起始位置为sLen-pLen（左指针）
        for(int i=0;i<sLen-pLen;++i){
            \\ 移动左指针的预处理
            \\ 如果当前字符出现过，移除字符后就没出现过了，那么差异就变少了
            if(count[s.charAt(i)-'a']==1){
                --differ;
            }else if(count[s.charAt(i)-'a']==0){
                \\ 如果当前字符没出现过，现在出现了，那么差异就增加了
                ++differ;
            }
            \\ 移除左侧字符
            --count[s.charAt(i)-'a'];
            \\ 移动右指针（新增右侧字符）的预处理
            \\ 如果之前缺少，现在就一样了
            if(count[s.charAt(i+pLen)-'a']==-1){
                --differ;
            }else if(count[s.charAt(i+pLen)-'a']==0){
                \\ 如果之前不缺，现在多了
                ++differ;
            }
            \\ 新增右侧字符
            ++count[s.charAt(i+pLen)-'a'];
            \\ 滑动窗口整体移动一位，如果differ为0，则代表当前滑动窗口内为异位词
            if(differ==0){
                ans.add(i+1);
            }
        }

        return ans;
    }
}
```

### C++
```bash
\\ 除了用vector以及vector.emplace_back()，没有区别
...
```

### 注意
在面对不能直接用相应算法直接解决的问题前，要想想有没有可不可以添加一些抽象关系进去，使不合适的输出或者输入转变为合适的输入输出，如滑动窗口、双指针这样的算法其实本身思想非常简单，但如何在此之上搭积木，才是我们要思考的问题。