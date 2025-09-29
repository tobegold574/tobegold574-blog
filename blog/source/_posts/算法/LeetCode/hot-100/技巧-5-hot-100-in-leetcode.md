---
title: 技巧(5) --hot 100 in leetcode
date: 2024-11-28 00:19:45
tags:
    - 技巧
    - hot 100
    - leetcode
---

 

## 只出现一次的数字
### 算法概述
[原题](https://leetcode.cn/problems/single-number/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为在给出的由一个出现一次的数字和其他出现两次的数字中找到那个出现一次的（要求时间复杂度为O(n)，空间复杂度为O(1)）。使用 ***位运算*** 解决。

### JAVA
```java
class Solution {
    public int singleNumber(int[] nums) {
        int single = 0;
        for (int num : nums) {
            // 所有数进行异或运算
            single ^= num;
        }
        return single;
    }
}
```

### C++
```c++
// 异或运算是一样的
```

### 注意
异或运算`^`的运算规律如下：
- 与相同数异或，得到0
- 与0异或，得到自身（ **等同于二进制的数中的每一位都与0异或，那么每一位异或得到的就是原本的0或1** ）

**位运算也很重要**


## 多数元素
### 算法概述
[原题](https://leetcode.cn/problems/majority-element/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为返回其中多数元素（出现频次大于一半），要求时间复杂度和空间复杂度与上题一致。使用Boyer-Moore 投票算法。

### JAVA
```java
class Solution {
    public int majorityElement(int[] nums) {
        int count = 0;
        // 候选众数为空
        Integer candidate = null;

        for (int num : nums) {
            if (count == 0) {
                // 初始化或动态频次为0时，更新候选众数
                candidate = num;
            }
            // count随每个当前遍历的元素是否为当前众数而增加/减少
            count += (num == candidate) ? 1 : -1;
        }

        return candidate;
    }
}
```

### C++
```c++
// 总体思路一致
```

### 注意
众数的频次绝对会比其他所有的数频次加起来高（大于一半），所以不管怎么排列，只要存在众数，`count`本质上是众数的频次减去其他所有数的频次，一定为正，且所属的`candidate`也会在遍历完后成为众数。


## 颜色分类
### 算法概述
[原题](https://leetcode.cn/problems/sort-colors/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求将相同颜色 **原地** 排列相邻，不同颜色之间遵照顺序（一共三种颜色，用012表示）,复杂度要求与上题一致。使用 ***双指针*** 解决。

### JAVA
```java
class Solution {
    public void sortColors(int[] nums) {
        int n = nums.length;
        // 双指针同时从开头出发
        int p0 = 0, p1 = 0;
        for (int i = 0; i < n; ++i) {
            // 碰到1就交换p1指针和当前索引
            if (nums[i] == 1) {
                int temp = nums[i];
                nums[i] = nums[p1];
                nums[p1] = temp;
                ++p1;
                // 碰到0和p0指针交换位置
            } else if (nums[i] == 0) {
                int temp = nums[i];
                nums[i] = nums[p0];
                nums[p0] = temp;
                // 如果p1位置先于p0位置，交换p1和当前索引
                if (p0 < p1) {
                    temp = nums[i];
                    nums[i] = nums[p1];
                    nums[p1] = temp;
                }
                // p0和p1一起向前移动
                ++p0;
                ++p1;
            }
        }
    }
}
```

### C++
```c++
// 思路一致，用vector，不用指针，数字索引就行
```

### 注意
也就是说`p1` **始终指向最后一个1的位置** ，`p0` **始终指向最后一个0** 。代码中，只有 **碰到0才会交换并移动p0指针** ，所以`p0`始终指向最后一个0，而因为 **碰到1和0都需要移动p1指针** ，但是 **1的排序是乱的**，所以`p1`始终指向的是 **最后一个1应该在的位置** ，而不是 **真正的最后一个1** ，这是因为 **碰到0移动产生的偏差** ，那就还需要 **交换当前索引和p1** 来补齐，因为 **p1随p0一起移动的次数就是p1少交换的次数** ，所以只需要`if (p0 < p1)`一个判断再做交换就足够了。

这道题的核心就是 **管理不同指针之间的相对关系** ，需要着重理解增强代码设计能力。


## 下一个排列
### 算法概述
[原题](https://leetcode.cn/problems/next-permutation/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为找出给出数组的下一个排列（就是比当前数大的其他排列中最小的那个排列），要求原地，空间复杂度要求常数。也就是要 **找最靠右的一个顺序对，左边的是小的，右边的是大的，然后交换它们** 。
- 时间复杂度为O(n)：两次遍历

### JAVA
```java
class Solution {
    public void nextPermutation(int[] nums) {
        // 从倒数第二个元素开始（因为要和后一个元素比较）
        int i = nums.length - 2;
        // 去找最靠右的降序外的元素
        while (i >= 0 && nums[i] >= nums[i + 1]) {
            i--;
        }
        if (i >= 0) {
            // 比i要大的最靠右的元素
            int j = nums.length - 1;
            while (j >= 0 && nums[i] >= nums[j]) {
                j--;
            }
            swap(nums, i, j);
        }
        // 这两个目标元素间的元素都是降序的，要反转成升序的
        reverse(nums, i + 1);
    }

    public void swap(int[] nums, int i, int j) {
        int temp = nums[i];
        nums[i] = nums[j];
        nums[j] = temp;
    }

    public void reverse(int[] nums, int start) {
        int left = start, right = nums.length - 1;
        while (left < right) {
            swap(nums, left, right);
            left++;
            right--;
        }
    }
}
```

### C++
```c++
// 一样的思路
```

### 注意
主要难点是理解题目。还有要记得 **反转** 。
- `while (i >= 0 && nums[i] >= nums[i + 1])`：这个循环是用于 **将升序遍历完**
- `while (j >= 0 && nums[i] >= nums[j])`：这个循环是用于 **将小于i值的元素遍历完**
**非常神奇的写法**


## 寻找重复数
### 算法概述
[原题](https://leetcode.cn/problems/find-the-duplicate-number/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为在给定的只有一个重复数的数组中找到那个重复数，不修改原数组且空间复杂度为常数级。可以用位运算解决，但更快的还是 ***快慢指针*** 。但这个 ***快慢指针*** 是基于 **索引** 的，还不是基于速度的。
- 时间复杂度为O(n)

### JAVA
```java
class Solution {
    public int findDuplicate(int[] nums) {
        int slow = 0, fast = 0;
        // 以索引为基础移动
        do {
            // 慢指针每次跳转一个索引
            slow = nums[slow];
            // 快指针每次跳转两个索引
            fast = nums[nums[fast]];
        } while (slow != fast);
        // 现在快慢指针相遇，意味着找到了环的存在
        slow = 0;
        // 现在找环的入口
        while (slow != fast) {
            // 慢指针从0起点出发找快指针
            slow = nums[slow];
            // 快指针在环内循环移动等待慢指针
            fast = nums[fast];
        }
        return slow;
    }
}
```

### C++
```c++
// 一样的
```

### 注意
解法核心在于 **基于索引移动跳转** ，因为有重复元素，所以一定能通过跳转索引的方式找到环。然后，可以确定的是，快慢指针此时相遇时 **是在环内** ，因为值一样，但不能确定入环点。此时需要 **将慢指针放回起始点，不动快指针** ，让它们 **同频移动** ，就会在入环点相遇（可参考“环形链表II”的计算）。注意，第一个循环 **不能确定重复值** ，因为是 **索引形成的环** 。

