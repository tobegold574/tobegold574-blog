---
title: 多维动态规划(5) --hot 100 in leetcode
date: 2024-11-27 21:22:58
tags:
    - 多维动态规划
    - hot 100
    - leetcode
---

 

## 不同路径
### 算法概述
[原题](https://leetcode.cn/problems/unique-paths/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为统计二维矩阵中从左上角出发到右下角的所有可能。其实没区别的。
- 时间复杂度为O(mn)：一次遍历
- 空间复杂度为O(n)：经过优化

### JAVA
```java
class Solution {
    public int uniquePaths(int m, int n) {
        int[] cur = new int[n];
        // 第一行第一列全都是1
        Arrays.fill(cur,1);
        for (int i = 1; i < m;i++){
            for (int j = 1; j < n; j++){
                // 相当于直接在上一行的基础上加上一列
                cur[j] += cur[j-1] ;
            }
        }
        return cur[n-1];
    }
}
```

### C++
```c++
// 无复杂接口调用
```

### 注意
可以通过在 **上一行遍历结果** 的基础上操作将问题 **降维** 。


## 最小路径和
### 算法概述
[原题](https://leetcode.cn/problems/minimum-path-sum/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为在上题基础上加权值，返回最小路径和。
- 时间复杂度为O(mn)
- 空间复杂度为O(mn)

### JAVA
```java
class Solution {
    public int minPathSum(int[][] grid) {
        if (grid == null || grid.length == 0 || grid[0].length == 0) {
            return 0;
        }
        int rows = grid.length, columns = grid[0].length;
        int[][] dp = new int[rows][columns];
        // 记得处理边界值
        dp[0][0] = grid[0][0];
        // 第一行
        for (int i = 1; i < rows; i++) {
            dp[i][0] = dp[i - 1][0] + grid[i][0];
        }
        // 第一列
        for (int j = 1; j < columns; j++) {
            dp[0][j] = dp[0][j - 1] + grid[0][j];
        }
        // 其他行列
        for (int i = 1; i < rows; i++) {
            for (int j = 1; j < columns; j++) {
                // 从上边来还是左边来的小，再加上当前节点权值
                dp[i][j] = Math.min(dp[i - 1][j], dp[i][j - 1]) + grid[i][j];
            }
        }
        return dp[rows - 1][columns - 1];
    }
}
```

### C++
```c++
// 没区别
```

### 注意
记得处理`[0][0]`这种特殊的边界值。


## 最长回文子串
### 算法概述
[原题](https://leetcode.cn/problems/longest-palindromic-substring/?envType=study-plan-v2&envId=top-100-liked)

本题要求为找出给定字符串的最长回文子串。有很多种高级解法，而动态规划是基于 ***不断扩大回文子串长度*** 的。
- 时间复杂度为O(n^2)
- 空间复杂度为O(n^2)

### JAVA
```java
public class Solution {

    public String longestPalindrome(String s) {
        int len = s.length();
        // 单字符
        if (len < 2) {
            return s;
        }
        int maxLen = 1;
        int begin = 0;
        // dp[i][j] 表示 s[i..j] 是否是回文串
        boolean[][] dp = new boolean[len][len];
        // 初始化：所有长度为 1 的子串都是回文串
        for (int i = 0; i < len; i++) {
            dp[i][i] = true;
        }
        char[] charArray = s.toCharArray();
        // 递推开始
        // 先枚举子串长度
        for (int L = 2; L <= len; L++) {
            // 枚举左边界，左边界的上限设置可以宽松一些（指的是<len）
            for (int i = 0; i < len; i++) {
                // j是右边界，不断移动（有点滑动窗口的感觉）
                int j = L + i - 1;
                // 如果右边界越界，就可以退出当前循环
                if (j >= len) {
                    break;
                }
                // 每次都判断一下一不一样
                if (charArray[i] != charArray[j]) {
                    dp[i][j] = false;
                } else {
                    // 如果就是两个字符，那它俩一样就行了
                    if (j - i < 3) {
                        dp[i][j] = true;
                    } else {
                        // 不然的话，传递它俩内部的子串，此时已经判断过它俩是一样的（状态转移）
                        dp[i][j] = dp[i + 1][j - 1];
                    }
                }

                // 只要 dp[i][L] == true 成立，就表示子串 s[i..L] 是回文，此时记录回文长度和起始位置
                if (dp[i][j] && j - i + 1 > maxLen) {
                    maxLen = j - i + 1;
                    begin = i;
                }
            }
        }
        return s.substring(begin, begin + maxLen);
    }
}
```

### C++
```c++
// 一样的思路
```

### 注意
这道题的思路 **不太一样** ，它 **把一维上的双指针映射成二维形式** 。这样做的好处就是对于动态规划来讲，易于处理。状态转移方程也很不一样，子问题结构 **并不是之前的正序和倒序** ，而是 **内部窗口的双指针** 。这样做就将状态转移方程的更新条件简化为 **两边的新字符一不一样** 的问题。

**较为特别，思路打开，需要多加练习熟练掌握**


## 最长公共子序列
### 算法概述
[原题](https://leetcode.cn/problems/longest-common-subsequence/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求如题所示，子序列指的是可以删除一些元素但不可移动元素位置。像上题一样，使用 **二维映射指针** 。
- 时间复杂度为O(mn)
- 空间复杂度为O(mn)


### JAVA
```java
class Solution {
    public int longestCommonSubsequence(String text1, String text2) {
        int m = text1.length(), n = text2.length();
        // dp用来记录当前索引最长公共子序列长度
        int[][] dp = new int[m + 1][n + 1];
        // 遍历行
        for (int i = 1; i <= m; i++) {
            // 取第一个字符串的字符
            char c1 = text1.charAt(i - 1);
            for (int j = 1; j <= n; j++) {
                // 取第二个字符串的字符
                char c2 = text2.charAt(j - 1);
                if (c1 == c2) {
                    // 有新的公共字符就+1（状态转移）
                    dp[i][j] = dp[i - 1][j - 1] + 1;
                } else {
                    // 不然就取前面的最大值（状态转移）
                    dp[i][j] = Math.max(dp[i - 1][j], dp[i][j - 1]);
                }
            }
        }
        // 对应前面多设置了一行一列（方便处理边界）
        return dp[m][n];
    }
}
```

### C++
```c++
// 可用string.at()索引
```

### 注意
其实没什么特别的，就是双层遍历，像`int[][] dp = new int[m + 1][n + 1];`这种技巧需要掌握。


## 编辑距离
### 算法概述
[原题](https://leetcode.cn/problems/edit-distance/solutions/188223/bian-ji-ju-chi-by-leetcode-solution/?envType=study-plan-v2&envId=top-100-liked)

本题要求为返回将一个字符串转换成另外一个字符串的最少操作数（操作包括：插入、删除、替换）。

### JAVA
```java
class Solution {
    public int minDistance(String word1, String word2) {
        int n = word1.length();
        int m = word2.length();

        // 有一个字符串为空串
        if (n * m == 0) {
            // 另外一个字符串的长度（其中一个为0）
            return n + m;
        }

        // 编辑距离（需要多少操作数）
        int[][] D = new int[n + 1][m + 1];

        // 删除word1的所有字符
        for (int i = 0; i < n + 1; i++) {
            D[i][0] = i;
        }
        // 将空的word1转换成word2
        for (int j = 0; j < m + 1; j++) {
            D[0][j] = j;
        }

        // 计算所有 DP 值
        for (int i = 1; i < n + 1; i++) {
            for (int j = 1; j < m + 1; j++) {
                // 删除
                int left = D[i - 1][j] + 1;
                // 插入
                int down = D[i][j - 1] + 1;
                // 替换（默认字符是相同的）
                int left_down = D[i - 1][j - 1];
                // 字符不同则需要一次操作
                if (word1.charAt(i - 1) != word2.charAt(j - 1)) {
                    left_down += 1;
                }
                // 三种操作的最小值，对应二维矩阵中的三种相邻元素
                D[i][j] = Math.min(left, Math.min(down, left_down));
            }
        }
        return D[n][m];
    }
}
```

### C++
```c++
// 一样的
```

### 注意
看似是列举了所有可能，但其实还是优化了，切记 **不要混淆了操作和子问题** ，`left`、`down`这些只是解决方法，不是子问题的最终答案，核心还是通过`Math.min(left, Math.min(down, left_down));`这个状态方程解决每个子问题的。