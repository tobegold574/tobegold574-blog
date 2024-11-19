---
title: 双指针(4) --hot 100 in leetcode
date: 2024-11-18 08:58:28
tags:
    - 双指针
    - hot 100
    - leetcode
---

<script type="text/javascript"
src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>

## 移动零
### 算法概述
[原题](https://leetcode.cn/problems/move-zeroes/?envType=study-plan-v2&envId=top-100-liked)

题目要求为将给定数组中的零值重新排序到数组末尾。用一个左指针指向非零值，一个右指针用于遍历数组，遇见零值时会将左指针停住，等到右指针找到非零值与其交换。
- 时间复杂度为O(n)：只有右指针在遍历
- 空间复杂度为O(1)：存放两个指针，但实际都指向参数数组中的值

### JAVA
```bash
class Solution {
    public void moveZeroes(int[] nums) {
        int n=nums.length,left=0,right=0;
        // 右指针遍历
        while(right<n){
            // 当遇见非零值，右指针和左指针同步移动（此时交换不影响）
            if(nums[right]!=0){
                swap(nums,left,right);
                left++;
            }
            // 当遇见非零值，右指针将超过左指针，跳过零值，直到下一个非零值与此时指向零值的左指针交换
            right++;
        }
    }

    // 左指针与右指针交换
    public void swap(int[] nums, int left, int right){
        int temp=nums[left];
        nums[left]=nums[right];
        nums[right]=temp;
    }
}
```
#### 重要实例方法及属性(JAVA)
`public void swap()`：辅助函数建议直接操作原数组（模拟指针）

### C++
```bash
\\ 基本上一模一样
class Solution {
public:
    void moveZeroes(vector<int>& nums) {
        int right=0,left=0;
        while(right<nums.size()){
            if(nums[right]!=0){
                swap(nums[right],nums[left]);
                left++;
            }
            right++;

        }
    }
};
```

#### 重要实例方法及属性(C++)
`swap()`：面向STL容器的泛型算法，比Java更简便，如果Java要实现类似效果，需要使用视图

### 注意
***快慢指针***：无需交换，只提取非零值，剩下的全是零值。
```bash
class Solution {
    public void moveZeroes(int[] nums) {
        if(nums == null){
            return;
        }
        
        int j = 0;
        // 快指针遍历（提取非零值）
        for(int i = 0;i <nums.length; ++i){
            if(nums[i] != 0){
                nums[j++] = nums[i];
            }
        }
        // 剩下的数组末尾用零值填补
        for(int i = j; i< nums.length;++i){
            nums[i] = 0;
        }
    }
}
```

## 盛最多水的容器
### 算法概述
[原题](https://leetcode.cn/problems/container-with-most-water/?envType=study-plan-v2&envId=top-100-liked)

题目要求为在给定高度数组中找到面积（*距离X最小高度*）最大的两个元素。先将双指针放在数组的左右边界，此时确保距离已经最大，然后不断缩小距离，使高度增大，探寻在不同高度的情况下，是否可能面积更大，每次结果都要与当前最优比较。
- 时间复杂度为O(n)：只遍历一次数组
- 空间复杂度为O(1)：只存储双指针的值

### JAVA
```bash
class Solution {
    public int maxArea(int[] height) {
        // 双指针指向数组边界
        int l=0,r=height.length-1;
        // 最大面积
        int ans=0;
        while(l<r){
            // 表示当前面积，初始值为最大距离的情况
            int area=Math.min(height[l],height[r])*(r-l);
            // 每次都进行比较
            ans=Math.max(ans,area);
            // 哪个高度小移动谁，找到更高的高度
            if(height[l]<=height[r]){
                ++l;
            }else{
                --r;
            }
        }
    return ans;
    }   
}
```

### C++
```bash
\\ 没区别
class Solution {
public:
    int maxArea(vector<int>& height) {
        int l = 0, r = height.size() - 1;
        int ans = 0;
        while (l < r) {
            int area = min(height[l], height[r]) * (r - l);
            ans = max(ans, area);
            if (height[l] <= height[r]) {
                ++l;
            }
            else {
                --r;
            }
        }
        return ans;
    }
};
```
#### 重要实例方法及属(C++)
`max()`：面向STL
`min()`：面向STL

## 三数之和
[原题](https://leetcode.cn/problems/3sum/?envType=study-plan-v2&envId=top-100-liked)

题目要求在给出数组中找到三个不同且和为零的元素。设定三个指针，将此问题转为两数之和。使用左指针作为目标值，中、右指针为双指针。
- 时间复杂度为O(n2)：外层左指针需要基本遍历完整个目标数组，需要n，中层和内层循环为两数之和，也为n
- 空间复杂度为O(log n)或O(n)：前者直接在原数组进行排序，需要存储每个可能的三元数组结果，而后者考虑了在原数组副本上进行排序

### JAVA
```bash
class Solution {
    public List<List<Integer>> threeSum(int[] nums) {
        int n = nums.length;
        // 先对原数组进行排序，目的在于使得到的三元按照一定顺序，免于重复遍历
        Arrays.sort(nums);
        List<List<Integer>> ans = new ArrayList<List<Integer>>();
        // 外层循环，左指针正常移动
        for (int first = 0; first < n; ++first) {
            // 先判断是否是重复值，是则回到外层循环
            if (first > 0 && nums[first] == nums[first - 1]) {
                continue;
            }
            // 右指针从数组右边界开始
            int third = n - 1;
            // 将三数之和变为两数之和，将左指针作为目标值，中指针和右指针作为两数之和中的双指针
            int target = -nums[first];
            // 中指针从左指针右侧开始
            for (int second = first + 1; second < n; ++second) {
                // 先判断是否是重复值，是则回到中层循环
                if (second > first + 1 && nums[second] == nums[second - 1]) {
                    continue;
                }
                // 如果中指针较小且和大于目标值则使右指针内移（右指针的初始值本就是最大值）
                while (second < third && nums[second] + nums[third] > target) {
                    --third;
                }
                // 如果指针重合，说明已经遍历完了，未找到
                if (second == third) {
                    break;
                }
                // 找到了
                if (nums[second] + nums[third] == target) {
                    List<Integer> list = new ArrayList<Integer>();
                    list.add(nums[first]);
                    list.add(nums[second]);
                    list.add(nums[third]);
                    ans.add(list);
                }
            }
        }
        return ans;
    }
}
```

### C++
```bash
// 除使用vector.push_back()和sort()外没有语法结构上的差别
```

## 接雨水
### 算法概述
[原题](https://leetcode.cn/problems/trapping-rain-water/?envType=study-plan-v2&envId=top-100-liked)

这道题要求计算出数组大于1的元素之间的差值。这里用到双指针减少遍历次数，双向同时遍历，独立计算，使一侧指针停在
最大高度，另一个指针继续前进直至两个指针相遇。
- 时间复杂度为O(n)：虽然看似计算是同步的，但实际上只遍历了一次，每次只执行一次计算
- 空间复杂度为O(1)：只需要存储指针指向的值

### JAVA
```bash
class Solution {
    public int trap(int[] height) {
        int ans=0;
        \\ 双指针指向左右边界
        int left=0, right=height.length-1;
        \\ 用于将左右侧的积水量分开独立计算
        int leftMax=0,rightMax=0;
        \\ 双向遍历
        while(left<right){
            \\ 每次移动指针都会尝试更新最大高度，用于之后计算积水
            leftMax=Math.max(leftMax,height[left]);
            rightMax=Math.max(rightMax,height[right]);
            \\ 这个判断和积水量计算无关，只是为了优化遍历
            if(height[left]<height[right]){
                \\ 计算还是独立的
                ans+=leftMax-height[left];
                ++left;
            }else{
                ans+=rightMax-height[right];
                --right;
            }
        }
        return ans;
    }
}
```

### C++
```bash
\\ 除了使用max以外无差别
class Solution {
public:
    int trap(vector<int>& height) {
        int ans = 0;
        int left = 0, right = height.size() - 1;
        int leftMax = 0, rightMax = 0;
        while (left < right) {
            leftMax = max(leftMax, height[left]);
            rightMax = max(rightMax, height[right]);
            if (height[left] < height[right]) {
                ans += leftMax - height[left];
                ++left;
            } else {
                ans += rightMax - height[right];
                --right;
            }
        }
        return ans;
    }
};
```

### 注意
双指针的作用并不是能够使计算 ***更加便捷*** ，而是在于能够找到一个替代双循环的点，所以在进行双向计算的时候应该
使用if判断使每次只执行一次计算，如果仍然执行两次计算，能够得到 ***相同效果*** ，但是本质不符合使用双指针的考虑。