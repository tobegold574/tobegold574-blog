---
title: 链表(14) --hot 100 in leetcode
date: 2024-11-21 17:15:48
tags:
    - 链表
    - hot 100
    - leetcode
---

<script type="text/javascript"
src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>

## 相交链表
### 算法概述
[原题](https://leetcode.cn/problems/intersection-of-two-linked-lists/description/?envType=study-plan-v2&envId=top-100-liked)

题目要求为找到两个链表中相交的元素（存储位置需要相对链表末尾相同，也就是从后往前数有几个节点）。我的想法是尽可能节约时间复杂度，我一开始想的是遍历到末尾再回头遍历，其实和这个方案得到的时间复杂度是一样的，但是我以为还有其他办法。但实际上是必须要这么多次遍历才够的。也就是要用双指针进行同时遍历，不过不是到末尾返回，而是到对方的链表中继续遍历。
- 时间复杂度为O(n+m)：双指针同时遍历，最多遍历完（返回null情况）
- 空间复杂度为O(1)：双指针存储

### JAVA
```bash
public class Solution {
    public ListNode getIntersectionNode(ListNode headA, ListNode headB) {
        // 无效题目
        if (headA == null || headB == null) {
            return null;
        }
        ListNode pA = headA, pB = headB;
        // 遍历直至两个指针相遇
        while (pA != pB) {
            // 先判断指针是为空，然后根据三元运算符判断是换表还是继续更新
            pA = pA == null ? headB : pA.next;
            pB = pB == null ? headA : pB.next;
        }
        // 最后两个指针分别把两个链表都遍历完，最后返回的也是表外的空节点，也就是null（无交点）
        return pA;
    }
}
```

### C++
```bash
// 没有区别
class Solution {
public:
    ListNode *getIntersectionNode(ListNode *headA, ListNode *headB) {
        if (headA == nullptr || headB == nullptr) {
            return nullptr;
        }
        ListNode *pA = headA, *pB = headB;
        while (pA != pB) {
            pA = pA == nullptr ? headB : pA->next;
            pB = pB == nullptr ? headA : pB->next;
        }
        return pA;
    }
};
```

### 注意
`pA = pA == nullptr ? headB : pA->next;`：可以使用这样的语句在单句代码中完成判断和赋值更新（先判断`=`右边，再到`=`）
这道题对 **寻找交点** 这种任务提供了一种新的思路，即从整体上，双指针的遍历次数已经确定的情况下， **如何安排遍历** 是重点，也就是怎样能够使双指针 **在不同的起点，抵达同步的终点** 。

## 反转链表
### 算法概述
[原题](https://leetcode.cn/problems/reverse-linked-list/description/?envType=study-plan-v2&envId=top-100-liked)

本题目要求反转链表。链表的结构是拥有灵活的前驱和后驱，非常便于插入，所以应该以重新插入为重点，把每个节点想象成三个节点（前驱-当前节点-后驱）的联合结构。
- 时间复杂度为O(n)：遍历链表
- 空间复杂度为O(1)：三个变量（存在于不同作用域）存储这个三元关系

### JAVA
```bash
class Solution {
    public ListNode reverseList(ListNode head) {
        // 原链表中的前驱
        ListNode prev = null;
        ListNode curr = head;
        while (curr != null) {
            // 原链表中的后驱（中间变量保存）
            ListNode next = curr.next;
            // 将前驱转变为后驱
            curr.next = prev;
            // 前驱向前移动
            prev = curr;
            // 当前节点和前驱保持相对位置
            curr = next;
        }
        // 当curr达到null，即边界外，前驱指向最后一个节点
        return prev;
    }
}
```

### C++
```bash
// 一样
class Solution {
public:
    ListNode* reverseList(ListNode* head) {
        ListNode* prev = nullptr;
        ListNode* curr = head;
        while (curr) {
            ListNode* next = curr->next;
            curr->next = prev;
            prev = curr;
            curr = next;
        }
        return prev;
    }
};
```

### 注意
链表的特性便在于灵活的插入与复杂的遍历，所以必须要在遍历的同时利用灵活的插入改变前驱和后驱来调整链表的顺序，不仅对于链表的顺序，在面对任何操作链表的问题时，应该记住它的灵活性所在，并加以利用。

代码中难以理解的就是，虽然可以用空节点填补头结点的前驱空缺，但实际上链表只包含了自己的信息和下一个节点的信息，所以 *prev* 在这里的作用只是一个为了循环遍历服务的中间变量，就看的很奇怪，实际上只有 *next* 和 *curr* 是实际操作的主体，而且 *next* 因为可以通过当前节点访问，所以每次循环都会重新生成，是临时的。

## 回文链表
### 算法概述
[原题](https://leetcode.cn/problems/palindrome-linked-list/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为判断链表是否为互文的。互文的关键特征是链表是否是对称的，也就是说要找到中间节点，再翻转后半部分，再进行比较才行。
- 时间复杂度为O(n)：只需遍历找到中间节点
- 空间复杂度为O(1)：只修改原链表

### JAVA
```bash
class Solution {
    public boolean isPalindrome(ListNode head) {
        if(head==null){
            return true;
        }
        // 中间节点
        ListNode firstHalfEnd=endOfFirstHalf(head);
        // 翻转后半段链表
        ListNode secondHalfStart=reverseList(firstHalfEnd.next);

        ListNode p1=head;
        ListNode p2=secondHalfStart;
        boolean result=true;
        // 两部分链表并行比较
        while(result&&p2!=null){
            if(p1.val!=p2.val){
                result=false;
            }
            p1=p1.next;
            p2=p2.next;
        }
        
        return result;
        
    }
    // 翻转链表（同上一题）
    private ListNode reverseList(ListNode head){
        ListNode prev=null;
        ListNode curr=head;
        while(curr!=null){
            ListNode nextTemp=curr.next;
            curr.next=prev;
            prev=curr;
            curr=nextTemp;
        }
        return prev;
    }
    // 获取中间节点
    private ListNode endOfFirstHalf(ListNode head){
        // 快慢指针
        ListNode fast=head;
        ListNode slow=head;
        // 快指针速度是慢指针两倍
        while(fast.next!=null&&fast.next.next!=null){
            fast=fast.next.next;
            slow=slow.next;
        }
        // 慢指针在快指针到达链表末尾的时候达到中段
        return slow;
    }
}
```

### C++
```bash
// 没什么区别
```

### 注意
学会用`fast`和`slow`快慢指针找节点（之前也有双指针题目用过快慢指针）。
牢记 **反转链表** 的思路，可以用作其他题的模块。

## 环形链表
### 算法概述
[原题](https://leetcode.cn/problems/linked-list-cycle/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求判断链表中是否有环。可以用快慢指针解决。
- 时间复杂度为O(n)：就按照慢指针最多移动多远算
- 空间复杂度为O(1)：快慢指针

### JAVA
```bash
public class Solution {
    public boolean hasCycle(ListNode head) {
        // 无效题目
        if (head == null || head.next == null) {
            return false;
        }
        // 不能重合，因为while需要靠这个判断（或者do-while）
        ListNode slow = head;
        ListNode fast = head.next;
        while (slow != fast) {
            // 快指针到null就肯定没环了
            if (fast == null || fast.next == null) {
                return false;
            }
            // 快指针遍历速度比慢指针快一倍
            slow = slow.next;
            fast = fast.next.next;
        }
        return true;
    }
}
```

### C++
```bash
// 无区别
```

### 注意
像前面的求交点问题一样，都是不可避免的需要一个几乎完整的循环遍历，但怎么让其中的双指针通过 **相遇** 把问题解决，是这类题目的重点。可以为双指针赋予不同的起点、速度等等，来求得不同的目标。

## 环形链表 II
### 算法概述
[原题](https://leetcode.cn/problems/linked-list-cycle-ii/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为返回进入环的那个节点（前一道题只需要判断是否有环）。我想的其实是反转链表，把相遇点之前的链表反转，然后反向遍历，但是还可以通过计算直接得出一个更加方便的方法，也就是在快慢指针相遇的时候，再从链表头释放一个指针，这个指针会和不停绕着环转的慢指针相遇在入环点🤨。
- 时间复杂度为O(n)：全部放在一个while的作用就在这里
- 空间复杂度为O(1)：三指针

### JAVA
```bash
public class Solution {
    public ListNode detectCycle(ListNode head) {
        if (head == null) {
            return null;
        }
        ListNode slow = head, fast = head;
        // 其实和上题是一样的
        while (fast != null) {
            slow = slow.next;
            if (fast.next != null) {
                fast = fast.next.next;
            } else {
                return null;
            }
            if (fast == slow) {
                ListNode ptr = head;
                // 当快慢指针相遇，释放ptr指针
                while (ptr != slow) {
                    // 同频移动ptr和慢指针
                    ptr = ptr.next;
                    slow = slow.next;
                }
                return ptr;
            }
        }
        return null;
    }
}
```

### C++
```bash
// 没区别
```

### 注意
![公式](\images\入环点计算公式.png)
其中 *a* 是环外距离， *b* 快慢指针走过的环内距离， *c* 是相遇点顺时针计算离入环点的距离。
可见有时不用很复杂的代码解决问题，和之前的矩阵顺时针旋转类似，用纸笔也可以计算出通用的公式，更方便执行。
