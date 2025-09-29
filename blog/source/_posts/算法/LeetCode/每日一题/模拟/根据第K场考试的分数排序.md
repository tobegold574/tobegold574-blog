---
title: 根据第K场考试的分数排序
date: 2024-12-21 11:17:27
tags:
    - 模拟
    - 每日一题
    - leetcode
---

## 根据第K场考试的分数排序(medium)
### 做题过程
感觉就是模拟，想不到可以用语言特性。

### 算法概述
[原题](https://leetcode.cn/problems/sort-the-students-by-their-kth-score/description/)

本题要求为对一个二维矩阵中的某一列进行排序。
- 复杂度根据语言

### JAVA
```java
class Solution {
    public int[][] sortTheStudents(int[][] score, int k) {
        // 返回正值，第一个参数的优先级低，所以要交换顺序
        Arrays.sort(score,(u,v)->v[k]-u[k]);;
        return score;
    }
}
```

### C++
```C++
class Solution {
public:
    vector<vector<int>> sortTheStudents(vector<vector<int>>& score, int k) {
        sort(score.begin(), score.end(), [&](const vector<int>& u, const vector<int>& v) {
            // 返回true，则第一个元素优先级高
            return u[k] > v[k];
        });
        return score;
    }
};
```

### 总结
要熟悉这些基本的api的参数和使用。

 
