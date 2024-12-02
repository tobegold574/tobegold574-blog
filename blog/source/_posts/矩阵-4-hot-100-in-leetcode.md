---
title: 矩阵(4) --hot 100 in leetcode
date: 2024-11-21 12:58:43
tags:
    - 矩阵
    - hot 100
    - leetcode
---

 

## 矩阵置零
### 算法概述
[原题](https://leetcode.cn/problems/set-matrix-zeroes/description/?envType=study-plan-v2&envId=top-100-liked)

题目要求为将矩阵中0元素的同行同列都转化为0。避免不了矩阵每个元素都要遍历一次，没有什么优化空间，但是空间复杂度上可以通过使用矩阵内部的空间用以标记减少空间消耗。在这里，使用了第一行第一列作为需要置零的行列标记，但实际上第一行置零与否也被包含在第一列的标记内，所以只需创造标记之后，将对第一行的遍历放在最后（第一行是否需要遍历只看[0][0]），第一列是否置零用另外的标记变量标记。
- 时间复杂度为O(mn)：遍历矩阵
- 空间复杂度为O(1)：一个标记变量

### JAVA
```java
class Solution {
    public void setZeroes(int[][] matrix) {
        // m为行数，n为列数
        int m = matrix.length, n = matrix[0].length;
        // 标记变量用于记录第一列是否需要置零
        boolean flagCol0 = false;
        for (int i = 0; i < m; i++) {
            // 是否有行首为0
            if (matrix[i][0] == 0) {
                flagCol0 = true;
            }
            // 遍历整个矩阵（全部行首已遍历过）
            for (int j = 1; j < n; j++) {
                if (matrix[i][j] == 0) {
                    // 如某一元素为0，则对应行首和列首为0
                    matrix[i][0] = matrix[0][j] = 0;
                }
            }
        }
        // 反向遍历行，避免标记被覆盖
        for (int i = m - 1; i >= 0; i--) {
            // 遍历列，跳过第一列，避免标记被覆盖
            for (int j = 1; j < n; j++) {
                // 处理后的矩阵内任意行首或列首为0，则全行全列为0
                if (matrix[i][0] == 0 || matrix[0][j] == 0) {
                    matrix[i][j] = 0;
                }
            }
            // 任意行首为0，第一列全部为0
            if (flagCol0) {
                matrix[i][0] = 0;
            }
        }
    }
}
```

### C++
```c++
class Solution {
public:
    void setZeroes(vector<vector<int>>& matrix) {
        int m = matrix.size();
        int n = matrix[0].size();
        // 这个标记变量是专门留给第一列的
        int flag_col0 = false;
        for (int i = 0; i < m; i++) {
            if (!matrix[i][0]) {
                flag_col0 = true;
            }
            for (int j = 1; j < n; j++) {
                if (!matrix[i][j]) {
                    matrix[i][0] = matrix[0][j] = 0;
                }
            }
        }
        for (int i = m - 1; i >= 0; i--) {
            for (int j = 1; j < n; j++) {
                if (!matrix[i][0] || !matrix[0][j]) {
                    matrix[i][j] = 0;
                }
            }
            if (flag_col0) {
                matrix[i][0] = 0;
            }
        }
    }
};
```

### 注意
在尝试原地解决空间，最优化空间使用的时候，一定要确定好 **用谁做标记** ，以及如何 **避免标记被覆盖** ，还有 **如何标记标记本身** ，需要慎重思考如何安排空间的利用，以及代码的顺序。

## 螺旋矩阵
### 算法概述
[原题](https://leetcode.cn/problems/spiral-matrix/description/?envType=study-plan-v2&envId=top-100-liked)

题目要求为将矩阵按照顺时针方向扁平化得到一维数组。可以把矩阵看成一层一层从内向外的扩散，而每一层都是个大长方形，可以用相同的方法遍历，这样矩阵本身的其他属性就不重要了，也就意味着不需要额外做标记避免越界之类的问题，而是直接原地操作。
- 时间复杂度为O(mn)：遍历矩阵
- 空间复杂度为O(1)：原地操作

### JAVA
```java
class Solution {
    public List<Integer> spiralOrder(int[][] matrix) {
        List<Integer> order = new ArrayList<Integer>();
        // 无效题目判断
        if (matrix == null || matrix.length == 0 || matrix[0].length == 0) {
            return order;
        }
        int rows = matrix.length, columns = matrix[0].length;
        // 上下左右四指针
        int left = 0, right = columns - 1, top = 0, bottom = rows - 1;
        // 四指针之间的范围在同一个循环内遍历
        while (left <= right && top <= bottom) {
            // 上指针
            for (int column = left; column <= right; column++) {
                order.add(matrix[top][column]);
            }
            // 右指针
            for (int row = top + 1; row <= bottom; row++) {
                order.add(matrix[row][right]);
            }
            // 避免下、左跑出去
            if (left < right && top < bottom) {
                // 下指针
                for (int column = right - 1; column > left; column--) {
                    order.add(matrix[bottom][column]);
                }
                // 左指针
                for (int row = bottom; row > top; row--) {
                    order.add(matrix[row][left]);
                }
            }
            // 四个指针同时动
            left++;
            right--;
            top++;
            bottom--;
        }
        return order;
    }
}
```

### C++
```c++
// 除了push_back以外一模一样
class Solution {
public:
    vector<int> spiralOrder(vector<vector<int>>& matrix) {
        if (matrix.size() == 0 || matrix[0].size() == 0) {
            return {};
        }

        int rows = matrix.size(), columns = matrix[0].size();
        vector<int> order;
        int left = 0, right = columns - 1, top = 0, bottom = rows - 1;
        while (left <= right && top <= bottom) {
            for (int column = left; column <= right; column++) {
                order.push_back(matrix[top][column]);
            }
            for (int row = top + 1; row <= bottom; row++) {
                order.push_back(matrix[row][right]);
            }
            if (left < right && top < bottom) {
                for (int column = right - 1; column > left; column--) {
                    order.push_back(matrix[bottom][column]);
                }
                for (int row = bottom; row > top; row--) {
                    order.push_back(matrix[row][left]);
                }
            }
            left++;
            right--;
            top++;
            bottom--;
        }
        return order;
    }
};
```

### 注意
虽然说着简单但实现起来还是有难度的。主要难度在于要想到使用 **四指针（上右下左）所框定的单位层同时向内层移动** ，以及如何遍历它们之间的范围且不引起冲突。
`while (left <= right && top <= bottom)`：最外层循环管理的是四指针逐渐走向矩阵中心的过程
`if (left < right && top < bottom)`：还需要注意的是，矩阵的结构 **不一定是正方形** ，也就意味着，到最后的最后，可能只有上右或者下左可以遍历最中心那几个一维的元素，也就是说必须要多这一层if判断，否则就会重复遍历。
所以说要考虑的还是蛮多的，虽然解法思路简单，但是各种可能的情况还是都要考虑。

## 旋转图像
### 算法概述
[原题](https://leetcode.cn/problems/rotate-image/?envType=study-plan-v2&envId=top-100-liked)

本题要求把矩阵顺时针旋转90度。可以通过计算得出每个元素在旋转90度之后的索引变化，用中间变量存储变化位置的元素值，然后循环旋转即可。
- 时间复杂度为O(n^2)：遍历矩阵
- 空间复杂度为O(1)：中间变量

### JAVA
```java
class Solution {
    public void rotate(int[][] matrix) {
        int n = matrix.length;
        // 需要把整个矩阵分为均匀四块（n为偶数正常分，n为奇数保留中心元素不动）
        for (int i = 0; i < n / 2; ++i) {
            for (int j = 0; j < (n + 1) / 2; ++j) {
                // 存储当前元素
                int temp = matrix[i][j];
                // 顺时针旋转，但在赋值时方向相反，应为逆时针，分为四个部分，所以有四次
                matrix[i][j] = matrix[n - j - 1][i];
                matrix[n - j - 1][i] = matrix[n - i - 1][n - j - 1];
                matrix[n - i - 1][n - j - 1] = matrix[j][n - i - 1];
                // 最后一次是顺时针方向的第一次
                matrix[j][n - i - 1] = temp;
            }
        }
    }
}
```

### C++
```c++
class Solution {
public:
    void rotate(vector<vector<int>>& matrix) {
        int n = matrix.size();
        for (int i = 0; i < n / 2; ++i) {
            for (int j = 0; j < (n + 1) / 2; ++j) {
                // 使用c++17的新std接口，就不需要temp了
                tie(matrix[i][j], matrix[n - j - 1][i], matrix[n - i - 1][n - j - 1], matrix[j][n - i - 1]) \
                    = make_tuple(matrix[n - j - 1][i], matrix[n - i - 1][n - j - 1], matrix[j][n - i - 1], matrix[i][j]);
            }
        }
    }
};
```

#### 重要实例方法及属性(C++)
`std::tie(...variables)`：用于解包元组（类似于python的自动解包）
`std::make_tuple(...args)`：打包多个变量成元组

### 注意
![公式](\images\顺时针旋转90度公式.png)
公式本质是逆时针的，和题目要求的顺时针旋转是相反的。
要注意 **代码本身逻辑可以与题目要求相反** ，同时达到相同效果。

## 搜素二维矩阵 II
### 算法概述
[原题](https://leetcode.cn/problems/search-a-2d-matrix-ii/?envType=study-plan-v2&envId=top-100-liked)

题目要求为搜索矩阵中的某个目标值，且每行矩阵从左到右、从上到下升序排列。使用Z字形查找，从中间值开始，逐次比较移动。
- 时间复杂度为O(m+n)：如果运气不好会多绕一圈
- 空间复杂度为O(1)：行、列指针

### JAVA
```java
class Solution {
    public boolean searchMatrix(int[][] matrix, int target) {
        int m = matrix.length, n = matrix[0].length;
        // 初始为右上角
        int x = 0, y = n - 1;
        while (x < m && y >= 0) {
            if (matrix[x][y] == target) {
                return true;
            }
            // 如果较小，行方向向内移动
            if (matrix[x][y] > target) {
                --y;
            } else {
                // 较大，则行方向向下移动
                ++x;
            }
        }
        return false;
    }
}
```

### C++
```c++
// 一样的
class Solution {
public:
    bool searchMatrix(vector<vector<int>>& matrix, int target) {
        int m = matrix.size(), n = matrix[0].size();
        int x = 0, y = n - 1;
        while (x < m && y >= 0) {
            if (matrix[x][y] == target) {
                return true;
            }
            if (matrix[x][y] > target) {
                --y;
            }
            else {
                ++x;
            }
        }
        return false;
    }
};
```

### 注意
我一开始想的是两层二叉查找，但实际上行内排序和列内排序本身是没有关联的，所以必须 **一个一个移动查找** ，也就是给出的Z字形查找，因为 **左边与上面的总是小的，右边和下面总是更大的** ，即使可能会稍微小绕一下，但也相对最简便了。要学会 **从最基本的规律出发，从中间值开始** 。