---
title: 回溯(8) --hot 100 in leetcode
date: 2024-11-24 19:36:24
tags:
    - 回溯
    - hot 100
    - leetcode
mathjax: true
---

 

## 全排列
### 算法概述
[原题](https://leetcode.cn/problems/permutations/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为给出目标数组的所有排列可能。使用 ***n!回溯*** 。
- 时间复杂度为O(n×n!)：需要固定的元素数量，以及它们的回溯
- 空间复杂度为O(n)：栈

### JAVA
```java
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
```c++
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
```java
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
```c++
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
- 时间复杂度为O(3^n)：基本上一个数字对应长度为3的字符串
- 空间复杂度为O(n)

### JAVA
```java
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
```c++
// 没啥不一样的
```

### 注意
这个题目的核心算法思想不复杂，就是一个简单的回溯结构，甚至只需要 **向下遍历** 就可以了。麻烦的是有很多映射，需要处理这些映射之间交互的问题。

梳理一下总体的结构：`char digit = digits.charAt(index);`每个数字对应一个字符串，而组合问题发生在字符串的维度，所以如果将整个回溯的过程类比为一个多叉树，那么 **每一层都代表一个数字** ，虽然实际上组合的是它们的映射，字符串。然后，在回溯真正工作的循环`for (int i = 0; i < lettersCount; i++)`内，回溯的 **外部递归是层的维度** ，也就是`backtrack(combinations, phoneMap, digits, index + 1, combination);` ，而 **内部递归的主体仍然是遍历字符** ，也就是`for (int i = 0; i < lettersCount; i++)`，其实递归类的问题完全可以 **简化到最后一层** ，`index`与数字长度相等的次数应该与`lettersCount`相等。

要记得从 **判断当前深度是否与最大深度相等** ，也就是`if (index == digits.length())`开始。

## 组合总和
### 算法概述
[原题](https://leetcode.cn/problems/combination-sum/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为从无重复数字的数组中找出和为目标值的组合，其中同一数字可以任取多次。还是 ***dfs*** ，和子集问题相同。
- 时间复杂度为O(S)：所有可行长度之和，因为有剪枝，所以不用到2^n
- 空间复杂度为O(n)

### JAVA
```java
class Solution {
    public List<List<Integer>> combinationSum(int[] candidates, int target) {
        List<List<Integer>> ans = new ArrayList<List<Integer>>();
        List<Integer> combine = new ArrayList<Integer>();
        dfs(candidates, target, ans, combine, 0);
        return ans;
    }

    public void dfs(int[] candidates, int target, List<List<Integer>> ans, List<Integer> combine, int idx) {
        // 标准的回溯终止判断
        if (idx == candidates.length) {
            return;
        }
        // 递归中不断缩小至0
        if (target == 0) {
            ans.add(new ArrayList<Integer>(combine));
            return;
        }
        // 不重复读取
        dfs(candidates, target, ans, combine, idx + 1);
        // 剪枝，如果重复无效就不重复了
        if (target - candidates[idx] >= 0) {
            combine.add(candidates[idx]);
            // 重复读取
            dfs(candidates, target - candidates[idx], ans, combine, idx);
            // 回溯
            combine.remove(combine.size() - 1);
        }
    }
}
```

### C++
```c++
// 注意STL算法使用
```

### 注意
类似于子集问题，还是构造成二叉树的深度优先搜索。要注意的是结构和另外加入的 **剪枝判断** 。

还要注意的是，回溯的过程是 **不断递归向下生成二叉树** ，并且 **尝试完毕后在空间上撤回** 。对于这道题， **并不需要遍历完所有节点** 。所以 **添加组合的判断与遍历到最大深度的判断不一致** ，是分成两块的，`if (target == 0)`才是主要，还有不要忘记`return;`。

对于这类加和问题，还可以使用剪枝`if (target - candidates[idx] >= 0)`减少复杂度。

这里的二叉树的分支是依赖 **重复不重复读取** 判断。

## 括号生成
### 算法概述
[原题](https://leetcode.cn/problems/generate-parentheses/?envType=study-plan-v2&envId=top-100-liked)

本题要求为按照要求的括号数量，给出所有可能且合理的括号组合。还是和前面几道题一个思路，关键是在 ***回溯的基础上剪枝如何剪枝和分类*** 。
- 时间复杂度为%$O\left(\frac{4^n}{\sqrt{n}}\right)$：卡特兰数（不懂）
- 空间复杂度为O(n)：递归栈
### JAVA
```java
class Solution {
    public List<String> generateParenthesis(int n) {
        List<String> ans=new ArrayList<String>();
        dfs(ans,new StringBuffer(),n,0,0);
        return ans;
    }

    private void dfs(List<String> ans,StringBuffer t,int n,int left,int right){
        // 排列的长度应该为2*n
        if(t.length()==n<<1){
            ans.add(t.toString());
            return;
        }
        if (left < n) {
            t.append('(');          
            dfs(ans, t, n, left + 1, right);
            t.deleteCharAt(t.length() - 1); 
        }

        // 左右括号数要一致
        if (right < left) {
            t.append(')');          
            dfs(ans, t, n, left, right + 1);
            t.deleteCharAt(t.length() - 1); 
        }
    }
}
```

#### 重要实例方法及属性(JAVA)
`new StringBuffer()`可以换成`new StringBuilder()`，后者只支持单线程，但是性能更好。

### C++
```c++
class Solution {
    // 智能指针（底层为引用计数）
    shared_ptr<vector<string>> cache[100] = {nullptr};
public:
    shared_ptr<vector<string>> generate(int n) {
        
        if (cache[n] != nullptr)
            return cache[n];
        if (n == 0) {
            cache[0] = shared_ptr<vector<string>>(new vector<string>{""});
        // else是主要工作部分
        } else {
            auto result = shared_ptr<vector<string>>(new vector<string>);
            for (int i = 0; i != n; ++i) {
                // left和right对应递归生成
                auto lefts = generate(i);
                auto rights = generate(n - i - 1);
                for (const string& left : *lefts)
                    for (const string& right : *rights)
                        result -> push_back("(" + left + ")" + right);
            }
            cache[n] = result;
        }
        return cache[n];
    }
    vector<string> generateParenthesis(int n) {
        // 智能指针解引用结果
        return *generate(n);
    }
};
```

#### 重要实例方法及属性(C++)
`shared_ptr<vector<string>> cache[100] = {nullptr};`：这里使用了线程安全的智能指针
`result -> push_back()`：可以直接这样访问实例方法，无需解引用

### 注意
回溯问题到目前为止都是 **在回溯的框架上实现不同的细节** 。这道题中的C++解法更像广度优先搜索，虽然用的还是递归，但采用了分层思想，不纳入考虑。参考JAVA的解法，回溯的框架，也就是 **改变深度以及撤销操作** 与之前的题目相仿。不同点在于 **分类和剪枝以及如何更新** 。这道题中可以以天然的左括号和右括号搭建深度优先搜索的二叉树，所以剪枝为`if (left < n)`和`if (right < left)`，以及需要像`t.append('(');`这样更新节点。

其实结构并不复杂，关键是要掌握 **如何分离每个部分所属，属于底层回溯，还是当前背景** 。

## 单词搜索
### 算法概述
[原题](https://leetcode.cn/problems/word-search/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求判断在给出的二维字符网格中是否有路径能够练成要搜索的单词。有很多优化的细节操作吧，但是我感觉这个就是很经典的 ***图论深度优先搜索+回溯*** 。
- 时间复杂度为O(n!)：函数递归的栈空间
- 空间复杂度为O(n)：几个集合

### JAVA
```java
class Solution {
    public boolean exist(char[][] board, String word) {
        int h = board.length, w = board[0].length;
        boolean[][] visited = new boolean[h][w];
        // 图论经典标记数组
        for (int i = 0; i < h; i++) {
            for (int j = 0; j < w; j++) {
                boolean flag = check(board, visited, i, j, word, 0);
                if (flag) {
                    return true;
                }
            }
        }
        return false;
    }

    // dfs
    public boolean check(char[][] board, boolean[][] visited, int i, int j, String s, int k) {
        // 类似图相关题目
        if (board[i][j] != s.charAt(k)) {
            return false;
        // 回溯标准判断
        } else if (k == s.length() - 1) {
            return true;
        }
        visited[i][j] = true;
        int[][] directions = {{0, 1}, {0, -1}, {1, 0}, {-1, 0}};
        boolean result = false;
        for (int[] dir : directions) {
            int newi = i + dir[0], newj = j + dir[1];
            if (newi >= 0 && newi < board.length && newj >= 0 && newj < board[0].length) {
                if (!visited[newi][newj]) {
                    // 换个字母搜
                    boolean flag = check(board, visited, newi, newj, s, k + 1);
                    if (flag) {
                        result = true;
                        break;
                    }
                }
            }
        }
        // 回溯
        visited[i][j] = false;
        return result;
    }
}
```

### C++
```c++
// 没区别
```

### 注意
这道题和之前题目的最大区别就是 **回溯的操作对象是图** ，而不是之前的字符串，或者自己拼的哈希表。 **图dfs的特点就是有四个方向和使用标记数组** 。回溯的操作基本还是那样。

## 分割回文串
### 算法概述
[原题](https://leetcode.cn/problems/palindrome-partitioning/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为把一个字符串分成多个回文字符串（单个字符也算）。使用 ***动态切割版本的子集问题解法+一个回文判断*** 。
- 时间复杂度为$O(n \cdot 2^n)$：最多是这样的
- 空间复杂度为$O(n^2)$：所有可能的子串数


### C++
```java
class Solution {
public:
    vector<vector<string>> partition(string s) {
        vector<vector<string>> result;
        vector<string> path;
        backtrack(s, 0, path, result);
        return result;
    }

private:
    void backtrack(const string& s, int start, vector<string>& path, vector<vector<string>>& result) {
        // 终止条件：如果起始位置到达字符串末尾，记录当前路径
        if (start == s.size()) {
            result.push_back(path);
            return;
        }

        // 尝试从起始位置划分不同长度的子串
        for (int end = start; end < s.size(); ++end) {
            // 判断很早，剪枝很有效
            if (isPalindrome(s, start, end)) {
                // 如果子串是回文，加入路径
                path.push_back(s.substr(start, end - start + 1));
                // 继续递归处理剩余部分
                backtrack(s, end + 1, path, result);
                // 回溯，撤销选择
                path.pop_back();
            }
        }
    }

    // 判断子串是否为回文
    bool isPalindrome(const string& s, int left, int right) {
        while (left < right) {
            if (s[left] != s[right]) return false;
            ++left;
            --right;
        }
        return true;
    }
};
```

### JAVA
```c++
// 类似吧
```

### 注意
这里使用的还是求子集的方法，但是是 **动态分割** ，也就是 **起始点在递归中更新，并且更新用的是上一层递归的终点** ，所以是`backtrack(s, end + 1, path, result);`，而终点从起点开始`for (int end = start; end < s.size(); ++end)`。核心是能够 **剪枝** 。但如果是“加入或跳过”，这里做不了判断，就无法剪枝。

## N皇后
### 算法概述
[原题](https://leetcode.cn/problems/n-queens/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为在n*n的棋盘上找出有多少种放置互不攻击的n个皇后的方法。我一开始就想用类似bfs的回溯算法，也就是下方的解法，但又算错了空间复杂度，反而使用了更加复杂的纯dfs回溯。ε=(´ο｀*)))唉。这道题的核心还是 ***套一层外部循环以符合皇后的全局作用，用集合存不可访问的节点*** ，以及底层毫无变化的 ***回溯*** 。

### JAVA
```java
class Solution {
    public List<List<String>> solveNQueens(int n) {
        // 存答案
        List<List<String>> solutions = new ArrayList<List<String>>();
        // 临时数组用来存皇后的列索引
        int[] queens = new int[n];
        Arrays.fill(queens, -1);
        // 存不可访问的对象线和列
        Set<Integer> columns = new HashSet<Integer>();
        Set<Integer> diagonals1 = new HashSet<Integer>();
        Set<Integer> diagonals2 = new HashSet<Integer>();
        backtrack(solutions, queens, n, 0, columns, diagonals1, diagonals2);
        return solutions;
    }

    public void backtrack(List<List<String>> solutions, int[] queens, int n, int row, Set<Integer> columns, Set<Integer> diagonals1, Set<Integer> diagonals2) {
        if (row == n) {
            List<String> board = generateBoard(queens, n);
            solutions.add(board);
        } else {
            // 每次遍历所有列，加入不可访问节点，以及完成回溯
            for (int i = 0; i < n; i++) {
                if (columns.contains(i)) {
                    continue;
                }
                int diagonal1 = row - i;
                if (diagonals1.contains(diagonal1)) {
                    continue;
                }
                int diagonal2 = row + i;
                if (diagonals2.contains(diagonal2)) {
                    continue;
                }
                queens[row] = i;
                columns.add(i);
                diagonals1.add(diagonal1);
                diagonals2.add(diagonal2);
                backtrack(solutions, queens, n, row + 1, columns, diagonals1, diagonals2);
                // 不可访问集合和皇后位置标记都要回溯
                queens[row] = -1;
                columns.remove(i);
                diagonals1.remove(diagonal1);
                diagonals2.remove(diagonal2);
            }
        }
    }

    public List<String> generateBoard(int[] queens, int n) {
        List<String> board = new ArrayList<String>();
        for (int i = 0; i < n; i++) {
            char[] row = new char[n];
            Arrays.fill(row, '.');
            // 当row==n时，所有行应该都有一个皇后，所以不会有越界问题
            row[queens[i]] = 'Q';
            board.add(new String(row));
        }
        return board;
    }
}
```

### C++
```c++
// 类似
```

### 注意
完整的棋盘概念无需再递归的检查中出现，因为检查的功能完全由三个集合承担，而`generateBoard(int[] queens, int n)`只需出现在最后加入答案的时候。

最核心的是：
```java
if (row == n) {
    List<String> board = generateBoard(queens, n);
    solutions.add(board);
}
```
题目要求我们返回的确实是 **一整个棋盘** ，但这并不影响我们以 **棋盘上的每一行作为回溯单位** 。因为我们要求得的是所有的棋盘可能，**排列的单位是什么，我们回溯什么** ，所以`generateBoard(queens, n)`一定要只看作回溯的某个阶段的整合，而不是回溯的目的或者回溯的一部分， **要专注于处理最基本的排列单位** 。
