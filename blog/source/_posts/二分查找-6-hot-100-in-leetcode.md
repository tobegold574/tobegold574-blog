---
title: 二分查找(6) --hot 100 in leetcode
date: 2024-11-25 17:44:38
tags:
    - 二分查找
    - hot 100
    - leetcode
---

<script type="text/javascript"
src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>

## 搜索插入位置
### 算法概述
[原题](https://leetcode.cn/problems/search-insert-position/?envType=study-plan-v2&envId=top-100-liked)

本题要求为找到相应目标值或者返回将其顺序插入的位置。使用二分查找。
- 时间复杂度为O(logn)：二分查找
- 空间复杂度为O(1)：临时变量

### JAVA
```bash
class Solution {
    public int searchInsert(int[] nums, int target) {
        int left = 0, right = nums.length - 1;
        while (left <= right) { 
            // /2或者>>1
            int mid = left + (right - left) / 2; 
            if (nums[mid] == target) { 
                return mid;
            } else if (nums[mid] < target) { 
                left = mid + 1; 
            } else { 
                right = mid - 1; 
            }
        }
        return left; // 返回插入位置
    }
}
```

### C++
```bash
// 没区别
```

### 注意
- `int mid = left + (right - left) / 2; `：记得`mid`算的是 **左边界和左右边界差的一半**
- `while (left <= right)`：注意是小于等于
- `if (nums[mid] == target) `：记得找到了就直接返回


## 搜索二维矩阵
### 算法概述
[原题](https://leetcode.cn/problems/search-a-2d-matrix/?envType=study-plan-v2&envId=top-100-liked)

本题要求为在二维矩阵里找到目标值，二维矩阵行列皆按升序排列。可以两次二分查找，也可以 ***把二维索引映射到一维，再映射回去*** ，成为 ***一次二分查找*** 。
- 时间复杂度为O(log(m*n))：二维
- 空间复杂度为O(1)

### JAVA
```bash
class Solution {
    public boolean searchMatrix(int[][] matrix, int target) {
        int m = matrix.length, n = matrix[0].length;
        // 范围映射到一维
        int low = 0, high = m * n - 1;
        while (low <= high) {
            int mid = (high - low) / 2 + low;
            // 映射回二维
            int x = matrix[mid / n][mid % n];
            if (x < target) {
                low = mid + 1;
            } else if (x > target) {
                high = mid - 1;
            } else {
                return true;
            }
        }
        return false;
    }
}
```

### C++
```bash
// 没区别
```

### 注意
- `int x = matrix[mid / n][mid % n];`：要掌握如何映射回二维，`n`指的是多少列


## 在排序数组中查找元素的第一个和最后一个位置
### 算法概述
[原题](https://leetcode.cn/problems/find-first-and-last-position-of-element-in-sorted-array/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为在非严格递增数组中找到元素的两个出现位置。用二分查找（精装版）。
- 时间复杂度为O(logn)：二分查找
- 空间复杂度为O(1)：临时变量


### JAVA
```bash
class Solution {
    public int[] searchRange(int[] nums, int target) {
        int leftIdx = binarySearch(nums, target, true);
        int rightIdx = binarySearch(nums, target, false) - 1;
        // 检查
        if (leftIdx <= rightIdx && rightIdx < nums.length && nums[leftIdx] == target && nums[rightIdx] == target) {
            return new int[]{leftIdx, rightIdx};
        } 
        return new int[]{-1, -1};
    }

    public int binarySearch(int[] nums, int target, boolean lower) {
        int left = 0, right = nums.length - 1, ans = nums.length;
        while (left <= right) {
            int mid = (left + right) / 2;
            // 当lower为true时，找的是左边界
            // 当lower为false时，找的是右边界后的一个元素
            if (nums[mid] > target || (lower && nums[mid] >= target)) {
                right = mid - 1;
                // 保留可能的左边界
                ans = mid;
            } else {
                left = mid + 1;
            }
        }
        return ans;
    }
}
```

### C++
```bash
// 实现逻辑相同
```

### 注意
- `if (leftIdx <= rightIdx && rightIdx < nums.length && nums[leftIdx] == target && nums[rightIdx] == target)`：要学习这种严谨
- `if (nums[mid] > target || (lower && nums[mid] >= target))`：
    1. 当`lower`为`true`时，检查的是`nuns[mid] >= target`，只要找到一个值，就不断通过`right = mid - 1;`收缩右指针，直到`mid`不再出现在该范围内，那就取上次保留的索引;
    2. 当`lower`为`false`时，检查`nums[mid] > target`，重复上述操作，相当于 **找的就是比目标值稍大的那个值的左边界** 。

二分查找看似简单，但是通过 **包装成函数，和微调指针移动条件** ，可以写出很优雅的代码，还要记得要抓住二分查找目标数组的规律，因为是 **升序** ，所以 **左右元素的关系很紧密** ，应该学会加以利用。


## 搜索螺旋排序数组
### 算法概述
[原题](https://leetcode.cn/problems/search-in-rotated-sorted-array/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为在一个原本升序排列但在某个下标旋转过（就是断开，重新连到开头去）的数组找目标值。需要 ***判断哪一部分有序*** ，在此之后，再移动左右指针。
- 时间复杂度为O(logn)：二分查找，就是叠了层判断
- 空间复杂度为O(1)：临时变量

### JAVA
```bash
class Solution {
    public int search(int[] nums, int target) {
        int n = nums.length;
        int l = 0, r = n - 1;
        while (l <= r) {
            int mid = l + (r - l) / 2;
            if (nums[mid] == target) return mid;

            // 判断左半部分是否有序(l~mid)
            if (nums[l] <= nums[mid]) {
                // 如果目标值在左半部分
                if (nums[l] <= target && target < nums[mid]) {
                    r = mid - 1;
                } else {
                    l = mid + 1;
                }
            } 
            // 否则右半部分有序(mid~r)
            else {
                // 如果目标值在右半部分
                if (nums[mid] < target && target <= nums[r]) {
                    l = mid + 1;
                } else {
                    r = mid - 1;
                }
            }
        }
        return -1; // 如果没有找到目标值
    }
}
```

### C++
```bash
// 一样
```

### 注意
解法的核心思路是抓住了 **永远有半边是有序的** ，二分查找的基础是分成两半，而且 **分完之后左右就是独立无关的了** ，所以应该牢记的是查找的单位永远是 **一半** ，而不应该再从整体数组看待问题，这样只会产生无用的谬见。

还要记得这道题是 **先判断有序无序，再判断在不在该范围内** 。    


## 寻找旋转排序数组中的最小值
### 算法概述
[原题](https://leetcode.cn/problems/find-minimum-in-rotated-sorted-array/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为对经过n次旋转后的数组找出原数组中的最小值，这个旋转就是当成循环链表那样，从末尾向头部移动，和前面那道题的旋转不一样。我前面理解错额，就是说总归怎么转，最小值前面要么什么都没有，要么就是一个升序数组，它后面也是升序的，而且绝对比前面的升序都小。
- 时间复杂度为O(logn)：二分查找
- 空间复杂度为O(1)：临时变量

### JAVA    
```bash
class Solution {
    public int findMin(int[] nums) {
        int low = 0;
        int high = nums.length - 1;
        while (low < high) {
            int pivot = low + (high - low) / 2;
            if (nums[pivot] < nums[high]) {
                high = pivot;
            } else {
                low = pivot + 1;
            }
        }
        return nums[low];
    }
}
```

### C++
```bash
// 没区别
```

### 注意
**一定要理解好题意再做题。**


## 寻找两个正序数组的中位数
### 算法概述
[原题](https://leetcode.cn/problems/median-of-two-sorted-arrays/?envType=study-plan-v2&envId=top-100-liked)

本题要求为找出两个升序数组合并后的中位数。使用 ***二分查找加快逼近*** 的思路。

- 时间复杂度为O(log(min(n,m)))：当最坏情况较短数组用二分查找遍历完，剩下的较长数组是升序，查找时间复杂度为O(1)
- 空间复杂度为O(1)：临时变量

### JAVA
```bash
class Solution {
    public double findMedianSortedArrays(int[] nums1, int[] nums2) {
        int length1 = nums1.length, length2 = nums2.length;
        int totalLength = length1 + length2;
        // 合并后长度为奇
        if (totalLength % 2 == 1) {
            int midIndex = totalLength / 2;
            double median = getKthElement(nums1, nums2, midIndex + 1);
            return median;
        // 合并后长度为偶
        } else {
            int midIndex1 = totalLength / 2 - 1, midIndex2 = totalLength / 2;
            double median = (getKthElement(nums1, nums2, midIndex1 + 1) + getKthElement(nums1, nums2, midIndex2 + 1)) / 2.0;
            return median;
        }
    }

    // 找第几小的元素
    public int getKthElement(int[] nums1, int[] nums2, int k) {
        int length1 = nums1.length, length2 = nums2.length;
        int index1 = 0, index2 = 0;
        int kthElement = 0;

        while (true) {
            // 边界情况
            // 超出nums1，就在nums2
            if (index1 == length1) {
                return nums2[index2 + k - 1];
            }
            // 超出nums2，就在nums1
            if (index2 == length2) {
                return nums1[index1 + k - 1];
            }
            // 找的就是第一小的
            if (k == 1) {
                return Math.min(nums1[index1], nums2[index2]);
            }
            
            // 正常情况
            int half = k / 2;
            int newIndex1 = Math.min(index1 + half, length1) - 1;
            int newIndex2 = Math.min(index2 + half, length2) - 1;
            int pivot1 = nums1[newIndex1], pivot2 = nums2[newIndex2];
            if (pivot1 <= pivot2) {
                k -= (newIndex1 - index1 + 1);
                index1 = newIndex1 + 1;
            } else {
                k -= (newIndex2 - index2 + 1);
                index2 = newIndex2 + 1;
            }
        }
    }
}
```

### C++
```bash
// 一样的
```

### 注意
这道题的思路很复合，简而言之，就是蛮难的。最终目的是通过 **同时遍历两个数组模拟一次二分查找** 来减少时间复杂度。主要的核心实现是 **找第k小的元素** 。而这个辅助函数的实现是通过 **类似二分查找的排除** 完成的。也就是当要查找第k个元素的时候，每次从两个数组中拿出第k/2元素进行比较，因为它们 **都是升序** ，所以谁大谁小就决定了 **哪个数组的前k/2不可能包含第k小的元素** ，不断通过这样的方式（k/2, k/4 ...极限求和为1），可以 **加快逼近第k小的元素的速度** ,同时，每次比较 **只排除一个数组中的相应部分** ，也就是说这个过程是 **交替进行的** ，可以保证最后逼近的就是第k小的元素。

**实现细节也非常值得学习，一定要熟练掌握**