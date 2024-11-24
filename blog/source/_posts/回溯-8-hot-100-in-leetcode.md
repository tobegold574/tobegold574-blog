---
title: 回溯(8) --hot 100 in leetcode
date: 2024-11-24 19:36:24
tags:
    - 回溯
    - hot 100
    - leetcode
---

<script type="text/javascript"
src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>

## 全排列
### 算法概述
[原题](https://leetcode.cn/problems/permutations/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为给出目标数组的所有排列可能。使用 ***n!回溯*** 。
- 时间复杂度为O(n×n!)：需要固定的元素数量，以及它们的回溯
- 空间复杂度为O(n)：栈

### JAVA
```bash
class Solution {
    public List<List<Integer>> permute(int[] nums) {
        List<List<Integer>> res = new ArrayList<List<Integer>>();
        List<Integer> output = new ArrayList<Integer>();
        for (int num : nums) {
            output.add(num);
        }
        int n = nums.length;
        backtrack(n, output, res, 0);
        return res;
    }
    public void backtrack(int n, List<Integer> output, List<List<Integer>> res, int first) {
        // first是回溯的分界点
        if (first == n) {
            res.add(new ArrayList<Integer>(output));
        }
        for (int i = first; i < n; i++) {   
            // 动态维护数组
            Collections.swap(output, first, i);
            // first向右移动，因为i是从first开始的，相当于多了一个固定的位置
            backtrack(n, output, res, first + 1);
            // 回溯
            Collections.swap(output, first, i);
        }
    }
}
```

#### 重要实例方法及属性(JAVA)
`Collections.swap(List<?> list, int i, int j)`：将i和j位置上的元素交换

### C++
```bash
// 也是一样的
```

### 注意
从时间复杂度上可以尝试理解，其实每一次就是 **从左向右固定一个元素** ，而且这个过程用 **自顶向下的递归实现** ，也就意味着，可以把 **不同的栈深度看作对原数组扩大分割的结果** 。

**重要**

## 子集
### 算法概述
[原题](https://leetcode.cn/problems/subsets/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为返回给出数组的所有子集。使用 ***二分类的回溯*** ，或者将直接把这2^n个自己映射到二进制上。
对于回溯：
- 时间复杂度为O(n*n^2)：所有元素和它们的递归深度
- 空间复杂度为O(n)：栈和临时数组最大都是n
对于迭代：
- 时间复杂度为O(n*n^2)：
- 空间复杂度为O(n)：临时数组


### JAVA
```bash
// 回溯（递归）
class Solution {
    List<Integer> t = new ArrayList<Integer>();
    List<List<Integer>> ans = new ArrayList<List<Integer>>();

    public List<List<Integer>> subsets(int[] nums) {
        dfs(0, nums);
        return ans;
    }

    // 深度优先搜索递归
    public void dfs(int cur, int[] nums) {
        // 和上题类似的终止条件
        if (cur == nums.length) {
            ans.add(new ArrayList<Integer>(t));
            return;
        }
        // 加入当前元素
        t.add(nums[cur]);
        dfs(cur + 1, nums);
        // 回溯尾部加入的元素（与之前加入当前元素相互抵消）
        t.remove(t.size() - 1);
        // 不加入当前元素
        dfs(cur + 1, nums);
    }
}

// 迭代
class Solution {
public:
    vector<int> t;
    vector<vector<int>> ans;

    vector<vector<int>> subsets(vector<int>& nums) {
        int n = nums.size();
        // 1<<n就是2的n次方
        for (int mask = 0; mask < (1 << n); ++mask) {
            t.clear();
            for (int i = 0; i < n; ++i) {
                // 检查mask的第i位是不是1
                if (mask & (1 << i)) {
                    t.push_back(nums[i]);
                }
            }
            ans.push_back(t);
        }
        return ans;
    }
};
```

### C++
```bash
// 位运算一样的
```

#### 重要实例方法及属性(C++)
`vector.pop_back()`：删除最后一个元素

### 注意
位运算的算法太逆天了，以后再说吧。

这道题回溯的重点是将递归分成了两类，分别是 **包含当前元素和不包含当前元素** 。回溯法的核心思想依然是 **分而治之** ，而拆解成包含与不包含也正好对应了子集问题中的 **取和舍** ，同时也将原来的一维数组结构变成了 **可用深度优先搜索处理的二叉树** ，这是一种经典的 **回溯建模** ，需要熟练掌握。

## 电话号码的字母组合
### 算法概述
[原题](https://leetcode.cn/problems/letter-combinations-of-a-phone-number/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为按照给出的2-9内的数字字符串返回可能的九键输入法组合。

### JAVA
```bash
class Solution {
    public List<String> letterCombinations(String digits) {
        List<String> combinations = new ArrayList<String>();
        if (digits.length() == 0) {
            return combinations;
        }
        Map<Character, String> phoneMap = new HashMap<Character, String>() {{
            put('2', "abc");
            put('3', "def");
            put('4', "ghi");
            put('5', "jkl");
            put('6', "mno");
            put('7', "pqrs");
            put('8', "tuv");
            put('9', "wxyz");
        }};
        backtrack(combinations, phoneMap, digits, 0, new StringBuffer());
        return combinations;
    }

    public void backtrack(List<String> combinations, Map<Character, String> phoneMap, String digits, int index, StringBuffer combination) {
        // 永远类似的终止条件
        if (index == digits.length()) {
            // index的范围代表多叉树的深度
            combinations.add(combination.toString());
        } else {
            // 就是向下遍历
            char digit = digits.charAt(index);
            // 映射到字符串的角度
            String letters = phoneMap.get(digit);
            int lettersCount = letters.length();
            for (int i = 0; i < lettersCount; i++) {
                combination.append(letters.charAt(i));
                // index+1意味着又多了一层digits和letters的映射
                backtrack(combinations, phoneMap, digits, index + 1, combination);
                combination.deleteCharAt(index);
            }
        }
    }
}
```

#### 重要实例方法及属性(JAVA)
`StringBuffer`：支持多线程操作的可变字符串，相对的，`String`虽然也是线程安全但不可变


### C++ 
```bash
// 没啥不一样的
```

### 注意
这个题目的核心算法思想不复杂，就是一个简单的回溯结构，甚至只需要 **向下遍历** 就可以了。麻烦的是有很多映射，需要处理这些映射之间交互的问题。

梳理一下总体的结构：`char digit = digits.charAt(index);`每个数字对应一个字符串，而组合问题发生在字符串的维度，所以如果将整个回溯的过程类比为一个多叉树，那么 **每一层都代表一个数字** ，虽然实际上组合的是它们的映射，字符串。然后，在回溯真正工作的循环`for (int i = 0; i < lettersCount; i++)`内，回溯的 **外部递归是层的维度** ，也就是`backtrack(combinations, phoneMap, digits, index + 1, combination);` ，而 **内部递归的主体仍然是遍历字符** ，也就是`for (int i = 0; i < lettersCount; i++)`，其实递归类的问题完全可以 **简化到最后一层** ，`index`与数字长度相等的次数应该与`lettersCount`相等。

要记得从 **判断当前深度是否与最大深度相等** ，也就是`if (index == digits.length())`开始。

## 组合总和