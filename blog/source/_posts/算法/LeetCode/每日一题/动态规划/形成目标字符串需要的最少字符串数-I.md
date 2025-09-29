---
title: 形成目标字符串需要的最少字符串数 I
date: 2024-12-17 09:50:24
tags:
    - 动态规划
    - 每日一题
    - leetcode
mathjax: true
---

## 形成目标字符串需要的最少字符串数 I(medium)
### 做题过程
想到了KMP，也想到了DP，但是因为都不是非常熟悉，所以没有实现出来。

### 算法概述
[原题](https://leetcode.cn/problems/minimum-number-of-valid-strings-to-form-target-i/description/)

本题要求为给出目标字符串，要求从给出的字符串数组中取各字符串的前缀拼接成目标字符串，返回需要最少的字符串（前缀）数量。 ***KMP+动态规划*** 。
- 时间复杂度为$O(k /times (m+n))$：k为单词数量，构造KMP
- 空间复杂度为$O(m + n)$：最大为KMP

### JAVA
```java
class Solution {
    public int minValidStrings(String[] words, String target) {
        int n=target.length();
        int[] back=new int[n];
        for(String word:words){
            int[] pi=kmp(word,target);
            int m=word.length();
            // back用来存储当前子问题结构的最优解
            for(int i=0;i!=n;i++){
                back[i]=Math.max(back[i],pi[m+1+i]);
            }
        }
        // 保留0处理边界
        int[] dp=new int[n+1];
        
        // 不能用Integer.MAX_VALUE作为哨兵值，加1就变成它的complement了
        Arrays.fill(dp,1,n+1,(int)1e9);
        for(int i=0;i!=n;++i){
            // 状态转移方程就相当于从上个填充进来的前缀处再填充一个新的前缀
            dp[i+1]=dp[i+1-back[i]]+1;
            // 如果判断条件成立，也就意味着已有字符串无法组成当前目标字符串
            if(dp[i+1]>n) return -1;
        }
        return dp[n];
    }

    // kmp 一定要背下来
    private int[] kmp(String word, String target){
        String s=word+"#"+target;
        int n=s.length();
        int[] pi=new int[n];
        for(int i=1;i!=n;++i){
            int j=pi[i-1];
            while(j>0&&s.charAt(i)!=s.charAt(j)){
                j=pi[j-1];
            }
            if(s.charAt(i)==s.charAt(j)){
                j++;
            }
            pi[i]=j;
        }
        return pi;
    }
}
```

### 总结
首先， **KMP** 一定要背下来。其次，要记住这里的动态规划的结构实际上把最优解的求解过程从状态转移方程中分离了出去，也就是`back[]`和之前`words`的遍历放在了一起，状态转移方程就只需要处理起始边界了。

## 12.18的II也是一样的题，加了一个数量级，没区别了就

 
