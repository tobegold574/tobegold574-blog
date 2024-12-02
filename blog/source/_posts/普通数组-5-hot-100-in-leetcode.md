---
title: 普通数组(5) --hot 100 in leetcode
date: 2024-11-20 21:14:16
tags:
    - 普通数组
    - hot 100
    - leetcode
---

 

## 最大子数组和
### 算法概述
[原题](https://leetcode.cn/problems/maximum-subarray/description/?envType=study-plan-v2&envId=top-100-liked)

此题要求为找到最大的子数组的和。因为这个题目只要求一个最终的和，所以完全不需要双指针和滑动窗口这样相对负责的结构，简单的dp（动态规划）就能做出来。
- 时间复杂度为O(n)：遍历一次
- 空间复杂度为O(1)：只需要存储中间常数

### JAVA
```java
class Solution {
    public int maxSubArray(int[] nums) {
        // 存当前子数组和和当前最大和
        int pre = 0, maxAns = nums[0];
        for (int x : nums) {
            // 更新前缀和（dp分化：把最大子数组和分为无数个可能的子数组 状态转移方程：哪个子数组和更大）
            pre = Math.max(pre + x, x);
            maxAns = Math.max(maxAns, pre);
        }
        return maxAns;
    }
}
```

### C++
```c++
class Solution {
public:
    int maxSubArray(vector<int>& nums) {
       int pre=0,max_=nums[0];
       for(const auto &num:nums){
        pre=max(pre+num,num);
        max_=max(pre,max_);
       }
       return max_;
    }
};
```

#### 重要实例方法及属性(C++)
`max_=nums[0]`：注意不要和关键字重名

## 注意
`max(pre+num,num)`：`max()`应该作用在前缀和和当前值之上，因为前缀和不一定是最大的，甚至可能为负值，而取单值作为最终子数组也未尝不可，要注意考虑到这个关键的可能性。

还有分治法（线段树）可用，后面再更新。

## 合并区间
### 算法概述
[原题](https://leetcode.cn/problems/merge-intervals/description/?envType=study-plan-v2&envId=top-100-liked)

这道题要求把给出的大数组中的小数组范围交叠的合并起来。可以通过遍历（还需要加上不少判断）解决，但也可以通过排序，判断永远会存在，但排序的开销应该不是数据集要多大就会产生多大的。
- 时间复杂度为O(nlogn)：排序和一次线性扫描（遍历的时间）
- 空间复杂度为O(logn)：排序

### JAVA
```java
class Solution {
    public int[][] merge(int[][] intervals) {
        // 题目无效
        if (intervals.length == 0) {
            return new int[0][2];
        }
        // 排序（使用比较器接口）
        Arrays.sort(intervals, new Comparator<int[]>() {
            public int compare(int[] interval1, int[] interval2) {
                return interval1[0] - interval2[0];
            }
        });
        // 答案
        List<int[]> merged = new ArrayList<int[]>();
        // 双指针分别指向小区间的两个边界（和遍历分离）
        for (int i = 0; i < intervals.length; ++i) {
            int L = intervals[i][0], R = intervals[i][1];
            // 初始情况或前一个小区间的右边界小于目前遍历到的小区间的左边界，则不合并
            if (merged.size() == 0 || merged.get(merged.size() - 1)[1] < L) {
                merged.add(new int[]{L, R});
            } else {
                // 不然，合并（还需比较谁的右边界更大，可能下一个小区间被上一个小区间所包含
                merged.get(merged.size() - 1)[1] = Math.max(merged.get(merged.size() - 1)[1], R);
            }
        }
        // 输出为二维数组
        return merged.toArray(new int[merged.size()][]);
    }
}
```

#### 重要实例方法及属性(JAVA)
`toArray(T[] a)`：返回特定类型的数组
`Arrays.sort(intervals, new Comparator<int[]>())`：使用比较器`Comparator`进行比较，比较器是需要实现的接口，当比较器返回负值，则第一个参数在前

### C++
```c++
class Solution {
public:
    vector<vector<int>> merge(vector<vector<int>>& intervals) {
        // 无效题目情况
        if (intervals.size() == 0) {
            return {};
        }
        // sort默认升序排序（默认比较每个子数组中的第一个元素）
        sort(intervals.begin(), intervals.end());
        vector<vector<int>> merged;
        for (int i = 0; i < intervals.size(); ++i) {
            int L = intervals[i][0], R = intervals[i][1];
            // 初始化或前一元素右边界小于下一元素左边界
            if (!merged.size() || merged.back()[1] < L) {
                merged.push_back({L, R});
            }
            else { 
                merged.back()[1] = max(merged.back()[1], R);
            }
        }
        return merged;
    }
};
```

#### 重要实例方法及属性(C++)
`vector.back()`：返回最后一个元素（不需要像java那样使用getter）
`sort()`：默认升序排列，且默认比较每个子数组中的第一个元素，如相同，则比较后续元素

### 注意
即使题目解答思路简单，但仍然需要考虑如何灵活使用STL algorithm或实例方法使代码更加优雅与清晰。
在可以使用更加高效的内置工具解决问题的时候，应该尽量避免使用简单的if来模拟相似的效果。

## 轮转数组
### 算法概述
[原题](https://leetcode.cn/problems/rotate-array/description/?envType=study-plan-v2&envId=top-100-liked)

题目要求为将给定数组轮转指定次数。创建一个新数组存储新索引下的旧数组的值，会消耗较大空间，所以可以使用
中间变量代替。
- 时间复杂度为O(n)：遍历一次
- 空间复杂度为O(1)：中间变量存储

### JAVA
```java
class Solution {
    public void rotate(int[] nums, int k) {
        int n = nums.length;
        // 得出最少需要轮转的次数
        k = k % n;
        // 求最大公约数
        int count = gcd(k, n);
        // 遍历最大公约数次，保证可以达到要求的轮转效果
        for (int start = 0; start < count; ++start) {
            // 当前索引
            int current = start;
            // 当前值
            int prev = nums[start];
            // 不断轮转到初始位置为止，再从新的位置开始轮转
            do {
                // 轮转到的位置
                int next = (current + k) % n;
                // 中间变量存储轮转位置的值
                int temp = nums[next];
                // 交换值
                nums[next] = prev;
                prev = temp;
                // 从被轮转到的位置重新开始
                current = next;
            } while (start != current);
        }
    }

    // 辗转相除法求最大公约数（基于当a=k*b+r时，整除a,b的数同时整除b,r，当y=0时终止递归）
    private int gcd(int x, int y) {
        return y > 0 ? gcd(y, x % y) : x;
    }
}
```

### C++
```c++
class Solution {
public:
    void rotate(vector<int>& nums, int k) {
        int n = nums.size();
        k = k % n;
        // gcd不需要自己定义，有numeric
        int count = gcd(k, n);
        for (int start = 0; start < count; ++start) {
            int current = start;
            int prev = nums[start];
            do {
                int next = (current + k) % n;
                // 交换也不需要temp，有algorithm
                swap(nums[next], prev);
                current = next;
            } while (start != current);
        }
    }
};
```

#### 重要实例方法及属性(C++)
`gcd(a,b)`：使用欧几里得算法求最大公约数


### 注意
C++在较新版本的 **numeric** 中有很多新方法，可以活用。其实这个算法每个while还是将整个数组遍历完了，只不过是跳着来的， **do-while** 是必须的，确保最后一个遍历的有效运行。这其实是一个一直往后跳，到最后再跳回每跳过的，再往后跳的循环过程，依照最大公约数来划定外层循环次数能够有效减少总循环。

## 除自身以外数组的乘积
### 算法概述
[原题](https://leetcode.cn/problems/product-of-array-except-self/description/?envType=study-plan-v2&envId=top-100-liked)

题目要求在相同索引处返回除相同索引元素外其他元素的乘积（不能使用除法）。使用两个左右数组对当前遍历索引的左右侧的元素分别求前缀积和后缀积，通过改善算法，也可以将输出数组作为左数组，选择中间变量作为右数组直接和输出数组交互，也就是右缀积直接和左缀积相乘（也可以用双指针替代，还更简单）。
- 时间复杂度为O(n)：两次遍历
- 空间复杂度为O(1)：只有中间变量存储

### JAVA
```java
class Solution {
    public int[] productExceptSelf(int[] nums) {
        int length=nums.length;
        int[] answer=new int[length];
        // 以answer为左数组
        // 左侧无元素，默认为1
        answer[0]=1;
        // 相应元素左侧元素的前缀积
        for(int i=1;i<length;i++){
            answer[i]=nums[i-1]*answer[i-1];
        }
        // 右边界外无元素，默认为1
        int R=1;
        // 从右开始遍历
        for(int i=length-1;i>=0;i--){
            // 更新answer
            answer[i]=answer[i]*R;
            // 更新潜在的右数组
            R*=nums[i];
        }
        return answer;
    }
}
```

### C++
```c++
// 一模一样
class Solution {
public:
    vector<int> productExceptSelf(vector<int>& nums) {
        int length = nums.size();
        vector<int> answer(length);
        answer[0] = 1;
        for (int i = 1; i < length; i++) {
            answer[i] = nums[i - 1] * answer[i - 1];
        }
        int R = 1;
        for (int i = length - 1; i >= 0; i--) {
            answer[i] = answer[i] * R;
            R *= nums[i];
        }
        return answer;
    }
};
```

### 注意
要思考如何用输出数组对空间复杂度进行优化，在同一个循环内完成更新和操作两个工作。
注意本题内首尾是特殊的，一个前缀积默认为1，一个后缀积默认为1，需要设置好左右数组的默认值。

## 缺失的第一个正数
### 算法概述
[原题](https://leetcode.cn/studyplan/top-100-liked/)

题目要求为找出数组中缺失的最小正数。我第一反应是哈希秒了，但原地直接使用哈希是最慢的。哈希是没有错的，但是应该换一种思路

### JAVA
```java
class Solution {
    public int firstMissingPositive(int[] nums) {
        int n = nums.length;
        // 把所有负数换成大于n的整数
        for (int i = 0; i < n; ++i) {
            if (nums[i] <= 0) {
                nums[i] = n + 1;
            }
        }
        // 最小正整数绝对出现在[1,n]内，这里将所有在这个区间内的正整数转换成负数同时用索引标记它们的顺序
        for (int i = 0; i < n; ++i) {
            int num = Math.abs(nums[i]);
            if (num <= n) {
                // 将值转化成索引，便于之后从索引找缺失的最小正整数
                nums[num - 1] = -Math.abs(nums[num - 1]);
            }
        }
        // 此时空出的正数（小于n）的索引就代表此索引+1的数不存在原区间
        for (int i = 0; i < n; ++i) {
            if (nums[i] > 0) {
                return i + 1;
            }
        }
        return n + 1;
    }
}
```

### C++
```c++
class Solution {
public:
    int firstMissingPositive(vector<int>& nums) {
        int n = nums.size();
        // 用for-each
        for (int& num: nums) {
            if (num <= 0) {
                num = n + 1;
            }
        }
        for (int i = 0; i < n; ++i) {
            int num = abs(nums[i]);
            if (num <= n) {
                nums[num - 1] = -abs(nums[num - 1]);
            }
        }
        for (int i = 0; i < n; ++i) {
            if (nums[i] > 0) {
                return i + 1;
            }
        }
        return n + 1;
    }
};
```

### 注意
`nums[num - 1] = -abs(nums[num - 1]);`：这一行不能直接改为任意负数，因为这一行的功能不仅包含把正整数改为相应索引的负数，而且还将该负数的值确定为原值的负值，也就意味着对于当循环遍历到了这些被修改过的索引值时，只需取绝对值（`int num = abs(nums[i])`）就仍然按照正常流程工作。

还需要学习的是这种 **借助索引** 和 **添加标记** 的能力。 


