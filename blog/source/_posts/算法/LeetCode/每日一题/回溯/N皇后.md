---
title: N皇后
date: 2024-12-01 21:01:39
tags:
    - 回溯
    - 每日一题
    - leetcode
---

 


## N皇后
### 做题过程
一开始想的就是 **三个哈希集合** 用来存不可访问位置，但后面发现更高效的解法根本 **不用这么多变量** ，其实可以很高效的搞定，然后记了一遍，默了一遍，又让GPT给我矫正了一下错误，除去语法，思路是对的，还比原解更精简了一点。

### 算法概述
[原题](https://leetcode.cn/problems/n-queens/description/)

就是用一维数组存储每行皇后的位置，然后每次创建新的一行的皇后的位置的时候，遍历之前所有行，检查是否合适（是否会被攻击），其实还是有一点点浪费时间的。回溯被前面的检查操作直接覆盖了，也有一点不符合经典回溯思想。
- 时间复杂度为O(N^2)：往上检查
- 空间复杂度为O(n)：只需要一个一维数组存储每行皇后的位置

### JAVA
```java
class Solution {
    public List<List<String>> solveNQueens(int n) {
        List<List<String>> ans=new ArrayList<List<String>>();
        int cols[]=new int[n];
        dfs(ans,cols,n,0);
        return ans;
    }

    private void dfs(List<List<String>> ans, int[] cols, int n, int row){
        if(row==n){
            List<String> temp=constructBoard(cols,n);
            ans.add(temp);
        }
        for(int i=0;i!=n;++i){
            if(isConfilcted(cols,i,row)) continue;
            cols[row]=i;
            dfs(ans,cols,n,row+1); // 这里回溯不需要撤销了
        }
    }

    private boolean isConfilcted(int[] cols,int col,int row){
        for(int i=0;i!=row;++i){
            if(cols[i]==col||Math.abs(cols[i]-col)==row-i) return true;
        }
        return false;
    }

    private List<String> constructBoard(int[] cols, int n){
        List<String> board=new ArrayList<String>();
        for(int i=0;i!=n;++i){
            // 不能用StringBuffer或者什么相关的，必须要char数组
            char[] row=new char[n];
            Arrays.fill(row,'.');
            row[cols[i]]='Q';
            // 原地构造String添加
            board.add(new String(row));
        }
        return board;
    }
}
```

### C++
```c++
// 今日算法竞赛打的简直是狗屎，就因为C++写的不好，Java不会处理输入，可恶至极，不写C++了
```

### 总结
功能分离的思想在这里的作用最大，其实本身没有太多优化算法的空间，但是分装成`isConflicted`和`constructBoard`其实极大降低了复杂度，但关键要想清楚整个过程，弄明白 **要给辅助函数什么参数** ，这决定了它们的位置和作用范围。