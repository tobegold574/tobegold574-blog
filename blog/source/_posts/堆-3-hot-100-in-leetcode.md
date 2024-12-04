---
title: 堆(3) --hot 100 in leetcode
date: 2024-11-26 21:21:34
tags:
    - 堆
    - hot 100
    - leetcode
---

 

## 数组中的第K个最大元素
### 算法概述
[原题](https://leetcode.cn/problems/kth-largest-element-in-an-array/?envType=study-plan-v2&envId=top-100-liked)

本题要求为返回数组中的第K个最大元素。栈也可以实现。如果需要频繁插入和查询，就用 ***堆排*** ，保持顺序就用栈。
- 时间复杂度为O(nlogn)：建堆需要O(n)，总删除需要O(klogn)，最后应该是O(n+klogn)，但k小于n，大概是这么多
- 空间复杂度为O(logn)：函数栈

### JAVA
```java
class Solution {
    public int findKthLargest(int[] nums, int k) {
        int heapSize = nums.length;
        // 构建最大堆
        buildMaxHeap(nums, heapSize);
        // 堆排
        for (int i = nums.length - 1; i >= nums.length - k + 1; --i) {
            // 与最小值交换位置
            swap(nums, 0, i);
            // 缩小堆（完全二叉树）范围
            --heapSize;
            // 重新堆排
            maxHeapify(nums, 0, heapSize);
        }
        return nums[0];
    }
    // 将数组转化成最大堆
    public void buildMaxHeap(int[] a, int heapSize) {
        // 从最后一个有子节点的节点向左遍历，并且逐渐向上
        for (int i = heapSize / 2 - 1; i >= 0; --i) {
            maxHeapify(a, i, heapSize);
        } 
    }

    public void maxHeapify(int[] a, int i, int heapSize) {
        // 左右子节点，默认最大值为当前节点
        int l = i * 2 + 1, r = i * 2 + 2, largest = i;
        if (l < heapSize && a[l] > a[largest]) {
            largest = l;
        } 
        if (r < heapSize && a[r] > a[largest]) {
            largest = r;
        }
        if (largest != i) {
            // 交换根节点与更大的子节点
            swap(a, i, largest);
            // 这里的递归是为了后续移除堆顶时重新对堆排序
            maxHeapify(a, largest, heapSize);
        }
    }

    public void swap(int[] a, int i, int j) {
        int temp = a[i];
        a[i] = a[j];
        a[j] = temp;
    }
}
```

### C++
```c++
// C++的swap不用自定义
```

### 注意
这道题的解法是基础的 **堆排** 。 **堆** ，是一种和 **完全二叉树紧密联系的数据结构** 。
首先， **完全二叉树** 是一个基于数组的数据结构，特性是：
- 除了最后一层之外，前面的所有层都是满的
- 最后一层向左对齐

这样，就可以轻松的得到：
1. **最后一个非叶子节点** 的索引为`heapsize/2-1`，也就是倒数第二层的最后一个（最左边）的节点
2. **每个节点的左子节点和右子节点** 的索引分别为`i*2+1`和`i*2+2`

那么 **构建最大堆** 只需要使用 **递归** 从 **倒数第二层往上对每个节点比较其与子节点的值，并把大的作为根节点** 。 **自底向上** 确保了排序不会错。

其实最大堆还可以通过 **优先队列的容器类** 实现，但上班一定会 **考** ，所以一定要会。


## 前K个高频元素
### 算法概述
[原题](https://leetcode.cn/problems/top-k-frequent-elements/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为返回给出数组中出现频次最高的K个元素。就是拿个 ***哈希表*** 存一下出现频次，然后直接用 ***最小堆*** 存，重复上一题的更新过程就行了。
- 时间复杂度为O(nlogk)：堆不需要像上题那样容纳所有元素
- 空间复杂度为O(n)：哈希表

### JAVA
```java
class Solution {
    public int[] topKFrequent(int[] nums, int k) {
        Map<Integer, Integer> occurrences = new HashMap<Integer, Integer>();
        // 哈希表存出现频次
        for (int num : nums) {
            occurrences.put(num, occurrences.getOrDefault(num, 0) + 1);
        }

        // 优先队列：int[] 的第一个元素代表数组的值，第二个元素代表了该值出现的次数
        PriorityQueue<int[]> queue = new PriorityQueue<int[]>(new Comparator<int[]>() {
            public int compare(int[] m, int[] n) {
                return m[1] - n[1];
            }
        });
        // 遍历哈希表中每个元素
        for (Map.Entry<Integer, Integer> entry : occurrences.entrySet()) {
            int num = entry.getKey(), count = entry.getValue();
            // 当堆装到k个元素，开始堆排
            if (queue.size() == k) {
                // 如果当前元素频次比堆顶大
                if (queue.peek()[1] < count) {
                    // 弹出堆顶
                    queue.poll();
                    // 加入当前元素（同时重新堆排）
                    queue.offer(new int[]{num, count});
                }
            } else {
                // 每到k个元素时直接往堆里放元素
                queue.offer(new int[]{num, count});
            }
        }
        int[] ret = new int[k];
        // 堆中元素就是答案
        for (int i = 0; i < k; ++i) {
            ret[i] = queue.poll()[0];
        }
        return ret;
    }
}
```

#### 重要实例方法及属性(JAVA)
`Map.Entry<Integer, Integer> entry : occurrences.entrySet()`：`Map.Entry`是一个嵌套接口，允许同时访问键值，`entryset`：返回所有键值对组成的集合
`int num = entry.getKey(), count = entry.getValue();`：`getKey()`得到键，`getValue()`得到值

### C++
```c++
class Solution {
public:
    static bool cmp(pair<int, int>& m, pair<int, int>& n) {
        return m.second > n.second;
    }

    vector<int> topKFrequent(vector<int>& nums, int k) {
        unordered_map<int, int> occurrences;
        for (auto& v : nums) {
            occurrences[v]++;
        }

        // pair 的第一个元素代表数组的值，第二个元素代表了该值出现的次数
        priority_queue<pair<int, int>, vector<pair<int, int>>, decltype(&cmp)> q(cmp);
        for (auto& [num, count] : occurrences) {
            if (q.size() == k) {
                if (q.top().second < count) {
                    q.pop();
                    q.emplace(num, count);
                }
            } else {
                q.emplace(num, count);
            }
        }
        vector<int> ret;
        while (!q.empty()) {
            ret.emplace_back(q.top().first);
            q.pop();
        }
        return ret;
    }
};
```

#### 重要实例方法及属性(C++)
`static bool cmp(pair<int, int>& m, pair<int, int>& n)`：使用静态方法作为比较器
`priority_queue<pair<int, int>, vector<pair<int, int>>, decltype(&cmp)> q(cmp);`：第一个参数代表元素类型，第二个参数代表底层实现类型，`decltype`判断cmp函数的返回值类型(bool)。声明中并未插入比较器，需要在实例化`q(cmp)`中引入比较器

### 注意
这道题与上道题的共同点是 **堆包含顺序排列的答案** ，但不同的是这道题的 **堆就是答案** 。所以在这道题中并不需要把所有元素放入堆，再一个一个读取出来（最大堆），而是使用 **最小堆** ，只要 **不断更替堆顶最小的元素，维持堆的范围** ，即可。

## 数据流的中位数
### 算法概述
[原题](https://leetcode.cn/problems/find-median-from-data-stream/?envType=study-plan-v2&envId=top-100-liked)

本题要求为设计一个类包含加入单个整数元素并能够返回当前实例内所有元素中位数的功能。栈的最后一道题也是类似的要求，但不一样的是，栈需要找到的是两个数组的共同中位数，所以解法是通过 **查找第k大小的元素的辅助函数** 完成的，而对于堆的这道题，只需要找到 **当前实例内的中位数** ，所以采取了了 **最大堆和最小堆动态更新** 的方法。

### JAVA
```java
class MedianFinder {
    PriorityQueue<Integer> queMin;
    PriorityQueue<Integer> queMax;

    public MedianFinder() {
        // 最大堆
        queMin = new PriorityQueue<Integer>((a, b) -> (b - a));
        // 最小堆
        queMax = new PriorityQueue<Integer>((a, b) -> (a - b));
    }
    
    public void addNum(int num) {
        // 如果比最大堆栈顶小，进入最大堆
        if (queMin.isEmpty() || num <= queMin.peek()) {
            queMin.offer(num);
            // 维持两个堆的大小相同（奇数情况最大堆多一个元素，即中位数）
            if (queMax.size() + 1 < queMin.size()) {
                queMax.offer(queMin.poll());
            }
        // 不然进入最小堆
        } else {
            queMax.offer(num);
            // 保持两个堆的大小相同
            if (queMax.size() > queMin.size()) {
                queMin.offer(queMax.poll());
            }
        }
    }
    
    public double findMedian() {
        // 奇数情况，最大堆堆顶始终为中位数
        if (queMin.size() > queMax.size()) {
            return queMin.peek();
        }
        // 偶数情况，中位数为两个堆顶的均值
        return (queMin.peek() + queMax.peek()) / 2.0;
    }
}
```

#### 重要实例方法及属性(JAVA)
`queMin = new PriorityQueue<Integer>((a, b) -> (b - a));`：还可以这样直接初始化

### C++
```c++
// 主要思路一样
```

#### 重要实例方法及属性(C++)
`priority_queue<int, vector<int>, less<int>> queMin`：可以用面向STL的`less<T>`模板类（函数对象）
`priority_queue<int, vector<int>, greater<int>> queMax;`：同上，`greater<T>`也为函数对象

### 注意
这里不用单堆的原因是 **容器类不提供完全二叉树的随机访问** ，以及 **单堆相对于双堆需要更频繁的元素移动** 。在这道题的解法中， **最大堆负责小于等于中位数的部分** ，**最小堆负责大于中位数的部分** ，这样就成功将问题分治，每次添加新的元素后，只需要进行 **半边元素的移动** 即可，相对单堆的操作复杂度减半。

