---
title: 动态规划(10) --hot 100 in leetcode
date: 2024-11-27 13:53:00
tags:
    - 动态规划
    - hot 100
    - leetcode
---

 

## 爬楼梯
### 算法概述
[原题](https://leetcode.cn/problems/climbing-stairs/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为在给定每次只能上一层或二层楼梯时，上n层楼梯有多少种选择。解法采取 ***动态规划*** ，子问题结构为 ***前一次跨了一次楼梯和跨了两次楼梯代表的排列的和*** 。
- 时间复杂度为O(n)：一共n级阶梯，每次都被当作为一个子问题
- 空间复杂度为O(1)：无额外数据结构

### JAVA
```java
class Solution {
    public int climbStairs(int n) {
        int p = 0, q = 0, r = 1;
        for (int i = 1; i <= n; ++i) {
            // 一步
            p = q; 
            // 两步
            q = r; 
            // 总方案数
            r = p + q;
        }
        return r;
    }
}
```

### C++
```c++
// 一样
```

### 注意
这里使用的是 **滑动数组** 。也就是`r`代表当前阶梯的总方案数，由 **前两级的方案数的加和** 得到。也就是说在循环内存在 **三级阶梯的方案数** ，然后随着循环前进， **第二级的方案数向第一级转移，第三级向第二级转移，第三级本身还是前二者的加和** 。

`p`一开始在边界之外，所以设置为0。

## 杨辉三角
### 算法概述
[原题](https://leetcode.cn/problems/pascals-triangle/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为填充生成杨辉三角。就是和上面一样的，不过这次取的是 ***前一行的后一个索引和当前索引的和*** ，每次还要记得在行首行尾加1。
- 时间复杂度为O(n^2)：三角形
- 空间复杂度为O(1)

### JAVA
```java
class Solution {
    public List<List<Integer>> generate(int numRows) {
        List<List<Integer>> ret = new ArrayList<List<Integer>>();
        for (int i = 0; i < numRows; ++i) {
            List<Integer> row = new ArrayList<Integer>();
            for (int j = 0; j <= i; ++j) {
                // 行首行尾加1
                if (j == 0 || j == i) {
                    row.add(1);
                } else {
                    // 不然取上一行求均值
                    row.add(ret.get(i - 1).get(j - 1) + ret.get(i - 1).get(j));
                }
            }
            ret.add(row);
        }
        return ret;
    }
}
```

### C++
```c++
// 一样
```

### 注意
记得行首行尾的处理， **学习如何组织循环，穿插预处理** 。


## 打家劫舍
### 算法概述
[原题](https://leetcode.cn/problems/house-robber/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为在给出数组中每次只能取不相邻的两个值（不能偷两个邻居的），返回取得的所有数的最大和。以三个为一组，两种可能，偷中间的还是两边的，每个子问题中还要 ***判断最大和*** ，其余和爬楼梯一样，。
- 时间复杂度为O(n)
- 空间复杂度为O(1)

### JAVA
```java
class Solution {
    public int rob(int[] nums) {
        if (nums == null || nums.length == 0) {
            return 0;
        }
        int length = nums.length;
        if (length == 1) {
            return nums[0];
        }
        int[] dp = new int[length];
        dp[0] = nums[0];
        dp[1] = Math.max(nums[0], nums[1]);
        for (int i = 2; i < length; i++) {
            // 偷两边的多还是偷中间的多
            dp[i] = Math.max(dp[i - 2] + nums[i], dp[i - 1]);
        }
        return dp[length - 1];
    }
}
```

### C++
```c++
// 一样
```

### 注意
边界值要像`dp[0] = nums[0];`和`dp[1] = Math.max(nums[0], nums[1]);`这样处理好，从2开始循环，正好 **三个一次循环** 。


## 完全平方数
### 算法概述
[原题](https://leetcode.cn/problems/perfect-squares/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为给出一个数，返回以平方数为加数最少需要几个平方数。从0开始遍历到目标值， ***每个数都是子问题*** ，求出每个数当前需要多少加数，然后遍历到目标值时可以选用之前遍历的值，也就是 ***记忆化搜索*** 。
- 时间复杂度为O($n \cdot \sqrt{n}$)：对每个数求平方数加数个数时用到平方根次遍历
- 空间复杂度为O(n)：用一个数组保存前n-1个数的可能，供记忆化搜索使用

### JAVA
```java
class Solution {
    public int numSquares(int n) {
        int[] f = new int[n + 1];
        for (int i = 1; i <= n; i++) {
            int minn = Integer.MAX_VALUE;
            // 对每个数求最小加数数量
            for (int j = 1; j * j <= i; j++) {
                // 记忆化搜索：只用求和不同平方数的差的最小加数数量
                minn = Math.min(minn, f[i - j * j]);
            }
            // 这边+1补上前面减去的j*j
            f[i] = minn + 1;
        }
        return f[n];
    }
}
```

### C++
```c++
// 没区别
```

### 注意
这道题的核心是 **记忆化搜索** 。通过使用 **额外数组** 保存前面的结果，再通过从1（`int j = 1`）开始的和平方数的差使用过去的结果，体现了动态规划中 **利用过去状态** 的思想。


## 零钱兑换
### 算法概述
[原题](https://leetcode.cn/problems/coin-change/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为给出一个整数数组，利用其中的整数（可重复）加成目标值，返回最少需要多少个整数。要不就是 ***自顶而下的记忆化搜索*** ， 要不就是 ***自底向上的动态规划*** ，和上题其实差别不大。
- 时间复杂度为O(sn)：s是目标值（总额），还是向上题那样每个值都遍历
- 空间复杂度为O(s)

### JAVA
```java
public class Solution {
    public int coinChange(int[] coins, int amount) {
        int max = amount + 1;   
        int[] dp = new int[amount + 1];
        Arrays.fill(dp, max);
        dp[0] = 0;
        for (int i = 1; i <= amount; i++) {
            for (int j = 0; j < coins.length; j++) {
                if (coins[j] <= i) {
                    // 这次直接把+1放进来了
                    dp[i] = Math.min(dp[i], dp[i - coins[j]] + 1);
                }
            }
        }
        return dp[amount] > amount ? -1 : dp[amount];
    }
}
```

### C++
```c++
// 没区别
```

### 注意
- `int max = amount + 1;`：这样设置 **哨兵值** 的原因是零钱再少也不会是0，全是一块钱总不可能比`amount+1`还多。
- `int[] dp = new int[amount + 1];`：多设置一位是解决0的边界问题
- `return dp[amount] > amount ? -1 : dp[amount];`：对应前面用哨兵值填充`dp`


## 单词拆分
### 算法概述
[原题](https://leetcode.cn/problems/word-break/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为判断是否能用给出的字典中的字符串拼接成目标单词。还是和前面一样，不同的就是这里是字符串。
- 时间复杂度为O(n^2)：对于每个子问题（目标字符串的子字符串）都要和字典对照一遍，每次只移动一位
- 空间复杂度为O(n)：布尔数组或者哈希集合

### JAVA
```java
public class Solution {
    public boolean wordBreak(String s, List<String> wordDict) {
        Set<String> wordDictSet = new HashSet(wordDict);
        // 为了处理边界值设置的长一点
        boolean[] dp = new boolean[s.length() + 1];
        dp[0] = true;
        for (int i = 1; i <= s.length(); i++) {
            // 每次只移动一位
            for (int j = 0; j < i; j++) {
                if (dp[j] && wordDictSet.contains(s.substring(j, i))) {
                    dp[i] = true;
                    break;
                }
            }
        }
        return dp[s.length()];
    }
}
```

### C++
```c++
// 对哈希集合要用find() end() string.str什么的
```

### 注意
对于所有`j`，只要`if (dp[j] && wordDictSet.contains(s.substring(j, i)))`判断成功一次就是`true`，但是必须 **一点一点移动指针** 。


## 最长递增子序列
### 算法概述
[原题](https://leetcode.cn/problems/longest-increasing-subsequence/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求如题所示，可以删去一些元素，但不能移动元素位置。可以用贪心做（我一开始也这么想的），还更好。但还是用 ***动态规划*** 吧。
- 时间复杂度为O(n^2)
- 空间复杂度为O(n)

### JAVA
```java
class Solution {
    public int lengthOfLIS(int[] nums) {
        if (nums.length == 0) {
            return 0;
        }
        // 不用多加容量，因为边界值直接设1是合理的
        int[] dp = new int[nums.length];
        dp[0] = 1;
        int maxans = 1;
        for (int i = 1; i < nums.length; i++) {
            // 默认值为1
            dp[i] = 1;
            // 每次遍历整个子序列的所有数字
            for (int j = 0; j < i; j++) {
                // 碰到更小的值就用它的加1（把自己算进去）
                if (nums[i] > nums[j]) {
                    dp[i] = Math.max(dp[i], dp[j] + 1);
                }
            }
            maxans = Math.max(maxans, dp[i]);
        }
        return maxans;
    }
}
```

### C++
```c++
// 没有区别
```

### 注意
`dp[]`数组是用来存 **当前索引的最长子序列的长度的** ，一定要把前面的元素全部遍历一遍是因为 **每个元素的最长子序列不同，不存在顺序** ，循环的任务是要找到 **前面元素中最长的那个再把自己加上** 。所以贪心直接重构数组肯定会比这个快。

**后一个元素和前面所有元素的相对关系都有作用，所以整个过程都是动态的，所有遍历都是必须的**


## 乘积最大数组
### 算法概述
[原题](https://leetcode.cn/problems/maximum-product-subarray/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为求出给定数组中最大子数组积（子数组必须是连续的）。还是 ***动态规划*** 。但是要考虑的是 **负数不一定会让积变得更小，因为负负得正会让积更大** 。
- 时间复杂度为O(n)
- 空间复杂度为O(n)

### JAVA
```java
class Solution {
    public int maxProduct(int[] nums) {
        int length = nums.length;
        long[] maxF = new long[length];
        long[] minF = new long[length];
        for (int i = 0; i < length; i++) {
            maxF[i] = nums[i];
            minF[i] = nums[i];
        }
        for (int i = 1; i < length; ++i) {
            // 考虑负负得正的情况或者只和当前数比较（maxF只包含正数）
            maxF[i] = Math.max(maxF[i - 1] * nums[i], Math.max(nums[i], minF[i - 1] * nums[i]));
            // 负的情况
            minF[i] = Math.min(minF[i - 1] * nums[i], Math.min(nums[i], maxF[i - 1] * nums[i]));
            // -1<<31表示一个极小的负数
            if (minF[i] < (-1 << 31)) {
                minF[i] = nums[i];
            }
        }
        int ans = (int) maxF[0];
        for (int i = 1; i < length; ++i) {
            ans = Math.max(ans, (int) maxF[i]);
        }
        return ans;
    }
}
```

### C++
```c++
// 思路一样，操作更加精简
```

#### 重要实例方法及属性(C++)
`max_element()`：面向容器查找最大元素，时间复杂度为O(n)


### 注意
- `maxF`用来存储正数情况的最大值，`minF`用来存储最小值（之后可能负负得正）
- 像`maxF[i] = nums[i];`填充哨兵是在假设当前值就是最大积（单个）
- `if (minF[i] < (-1 << 31))`：用来防止最小值小的溢出
- `maxF[i] = Math.max(maxF[i - 1] * nums[i], Math.max(nums[i], minF[i - 1] * nums[i]))`：通过内嵌`max()`比较三种情况的积
- `minF[i] = Math.min(minF[i - 1] * nums[i], Math.min(nums[i], maxF[i - 1] * nums[i]));`：与上式相同，但求得是最小值

**结构很清晰，需要好好学习，熟练掌握**
**可以用滚动数组**


## 分割等和子集
### 算法概述
[原题](https://leetcode.cn/problems/partition-equal-subset-sum/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为判断给出数组能否分成和相同的两个子集（子集可以不连续）。就是找有没有子集能够 ***加出来整个数组和的一半*** 。
- 时间复杂度为O(nk)：k是整体和的一半
- 空间复杂度为O(k)：可优化为一个一维数组

### JAVA
```java
class Solution {
    public boolean canPartition(int[] nums) {
        int n = nums.length;
        // 一个数不行
        if (n < 2) {
            return false;
        }
        int sum = 0, maxNum = 0;
        // 算总和
        for (int num : nums) {
            sum += num;
            maxNum = Math.max(maxNum, num);
        }
        // 奇数个数不行
        if (sum % 2 != 0) {
            return false;
        }
        int target = sum / 2;
        // 最大数超过一半不行
        if (maxNum > target) {
            return false;
        }
        // 默认是false
        boolean[] dp = new boolean[target + 1];
        dp[0] = true;
        for (int i = 0; i < n; i++) {
            int num = nums[i];
            // 从半值递减
            for (int j = target; j >= num; --j) {
                // 逻辑运算符也可以这么写
                dp[j] |= dp[j - num];
            }
        }
        return dp[target];
    }
}
```

### C++
```c++
// 没区别
```

### 注意
`dp[j]`代表是否有子集的和为j。解法这么安排`i`和`j`非常 **巧妙** ，在节省了空间的同时保持了完整的逻辑思路。也就是说虽然 **外层循环仍然控制状态数组** ，但是内部循环对状态数组的更新是通过 **倒序遍历** 的，这样避免了重复使用`num`进行更新。因为这里用状态数组 **不涉及复杂的相对关系** ，所以可以使用 **倒序遍历** 。


## 最长有效括号
### 算法概述
[原题](https://leetcode.cn/problems/longest-valid-parentheses/solutions/314683/zui-chang-you-xiao-gua-hao-by-leetcode-solution/?envType=study-plan-v2&envId=top-100-liked)

本题要求为返回有效括号子串的长度。这道题本来用栈来做的。现在就是用动态规划，而且只能一个一个遍历。
- 时间复杂度为O(n)
- 空间复杂度为O(n)

### JAVA
```java
class Solution {
    public int longestValidParentheses(String s) {
        int maxans = 0;
        // dp用来装当前索引有效括号子串的长度
        int[] dp = new int[s.length()];
        for (int i = 1; i < s.length(); i++) {
            // 只用判断右括号
            if (s.charAt(i) == ')') {
                // 前面直接就是左括号
                if (s.charAt(i - 1) == '(') {
                    // 如果前面还有有效子串则可以累加（状态转移）
                    dp[i] = (i >= 2 ? dp[i - 2] : 0) + 2;
                    // 左括号和右括号包含了一个有效子串
                } else if (i - dp[i - 1] > 0 && s.charAt(i - dp[i - 1] - 1) == '(') {
                    // 如果前面还有有效子串则可以累加（状态转移）
                    dp[i] = dp[i - 1] + ((i - dp[i - 1]) >= 2 ? dp[i - dp[i - 1] - 2] : 0) + 2;
                }
                maxans = Math.max(maxans, dp[i]);
            }
        }
        return maxans;
    }
}
```

### C++
```c++
// 一样的
```

### 注意
这里看上去比较奇怪的原因就是 **状态转移方程要分成两类** ，分别是 **前面一个就是括号** 和 **和前面的括号之间还包含了有效子串** 。也就是说，当`i - dp[i - 1] > 0 `时可以得出匹配的左括号离当前右括号有一段距离，并且当前右括号 **前面有一个有效子串** ，然后就是通过`s.charAt(i - dp[i - 1] - 1) == '('`找匹配的左括号。这里`dp[i] = dp[i - 1] + ((i - dp[i - 1]) >= 2 ? dp[i - dp[i - 1] - 2] : 0) + 2;`进行状态转移和`if`的区别无非就是减去了中间有效子串的长度罢了。

之所以代码如此简单清晰，就是在预处理时理解了在用 **动态规划一次遍历解决问题** 的一个核心特征，根本 **不会有无效子串的可能** ，只可能会多一个少一个括号找不到匹配，这样每个都遍历时绝对不会出现无效括号的（除了开头右括号以外）。

所以面对相对复杂问题的时候一定要 **先对问题有基本的思考和转化** 。

