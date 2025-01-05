---
title: 设计一个ATM机器
date: 2025-01-05 16:24:35
tags:
    - 普通数组
    - 每日一题
    - leetcode
---

## 设计一个ATM机器🟨
### 做题过程
本来觉得维护一个普通数组就可以了，其实确实也是这样的，但是我写的依托💩。

### 算法概述
[原题](https://leetcode.cn/problems/design-an-atm-machine/description/)

本题要求为设计一个ATM类，会读取不同面额的钞票，每次吐钞票的时候优先吐面额大的，还会判断够不够吐。
- 时间复杂度为O(nk)：k指的是钞票的面额种类数
- 空间复杂度为O(k)

### JAVA
```java
class ATM {
    // 普通数组用于维护足矣
    private long[] cnt;   
    private long[] value; 

    public ATM() {
        cnt = new long[]{0, 0, 0, 0, 0};
        value = new long[]{20, 50, 100, 200, 500};
    }

    public void deposit(int[] banknotesCount) {
        for (int i = 0; i < 5; ++i) {
            cnt[i] += banknotesCount[i];
        }
    }

    public int[] withdraw(int amount) {
        int[] res = new int[5];

        // 不够就全部取出来
        for (int i = 4; i >= 0; --i) {
            res[i] = (int) Math.min(cnt[i], amount / value[i]);
            amount -= res[i] * value[i];
        }
        // 还剩下没取完的，也就是全取完了也不够
        if (amount > 0) {
            return new int[]{-1};
        } else {
            // 更新cnt
            for (int i = 0; i < 5; ++i) {
                cnt[i] -= res[i];
            }
            return res;
        }
    }
}
```

### 总结
我用的是一个变量来代表剩余金额来进行维护。
 
