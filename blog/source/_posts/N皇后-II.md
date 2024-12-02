---
title: N皇后 II
date: 2024-12-02 12:49:19
tags:
    - 回溯
    - 每日一题
    - leetcode
---

<script type="text/javascript"
src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>

## N皇后 II
### 做题过程
和N皇后思路一模一样，甚至还不需要构建棋盘，简单了很多，还是N皇后的思路，直接手撕了。

### 算法概述
[原题](https://leetcode.cn/problems/n-queens-ii/description/)

时间和空间复杂度都与N皇后一致，N皇后也不会把棋盘纳入复杂度考虑。

### JAVA
```java
class Solution {
    int res=0;

    public int totalNQueens(int n) {
        int cols[]=new int[n];
        dfs(cols,n,0);
        return res;
    }

    private void dfs(int[] cols,int n,int row){
        if(row==n){
            res+=1;
            return;
        }
        for(int i=0;i!=n;++i){
            if(isConflicted(cols,i,row)) continue;
            cols[row]=i;
            dfs(cols,n,row+1);
        }
    }

    private boolean isConflicted(int[] cols,int i,int row){
        for(int j=0;j!=row;++j){
            // 这里用j，要避免参数冲突
            if((cols[j]==i)||Math.abs(cols[j]-i)==row-j) return true;
        }
        return false;
    }
}
```

### 总结
这种题做了两三次就可以手撕了，因为本身思路其实不难理解。