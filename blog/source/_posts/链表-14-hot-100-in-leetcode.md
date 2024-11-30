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

题目要求为找到两个链表中相交的元素（存储位置需要相对链表末尾相同，也就是从后往前数有几个节点）。我的想法是尽可能节约时间复杂度，我一开始想的是遍历到末尾再回头遍历，其实和这个方案得到的时间复杂度是一样的，但是我以为还有其他办法。但实际上是必须要这么多次遍历才够的。也就是要用双指针进行同时遍历，不过不是到末尾返回，而是 ***到对方的链表中继续遍历*** 。
- 时间复杂度为O(n+m)：双指针同时遍历，最多遍历完（返回null情况）
- 空间复杂度为O(1)：双指针存储

### JAVA
```java
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
```c++
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
```java
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
```c++
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

本题要求为判断链表是否为互文的。互文的关键特征是链表是否是对称的，也就是说要找到中间节点，再 ***翻转后半部分*** ，再进行比较才行。
- 时间复杂度为O(n)：只需遍历找到中间节点
- 空间复杂度为O(1)：只修改原链表

### JAVA
```java
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
```c++
// 没什么区别
```

### 注意
学会用`fast`和`slow`快慢指针找节点（之前也有双指针题目用过快慢指针）。
牢记 **反转链表** 的思路，可以用作其他题的模块。

## 环形链表
### 算法概述
[原题](https://leetcode.cn/problems/linked-list-cycle/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求判断链表中是否有环。可以用 ***快慢指针*** 解决。
- 时间复杂度为O(n)：就按照慢指针最多移动多远算
- 空间复杂度为O(1)：快慢指针

### JAVA
```java
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
```c++
// 无区别
```

### 注意
像前面的求交点问题一样，都是不可避免的需要一个几乎完整的循环遍历，但怎么让其中的双指针通过 **相遇** 把问题解决，是这类题目的重点。可以为双指针赋予不同的起点、速度等等，来求得不同的目标。

## 环形链表 II
### 算法概述
[原题](https://leetcode.cn/problems/linked-list-cycle-ii/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为返回进入环的那个节点（前一道题只需要判断是否有环）。我想的其实是反转链表，把相遇点之前的链表反转，然后反向遍历，但是还可以通过计算直接得出一个更加方便的方法，也就是在快慢指针相遇的时候， ***再从链表头释放一个指针*** ，这个指针会和不停绕着环转的慢指针相遇在入环点🤨。
- 时间复杂度为O(n)：全部放在一个while的作用就在这里
- 空间复杂度为O(1)：三指针

### JAVA
```java
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
```c++
// 没区别
```

### 注意
![公式](\images\入环点计算公式.png)
其中 *a* 是环外距离， *b* 快慢指针走过的环内距离， *c* 是相遇点顺时针计算离入环点的距离。
可见有时不用很复杂的代码解决问题，和之前的矩阵顺时针旋转类似，用纸笔也可以计算出通用的公式，更方便执行。

## 合并两个有序链表
### 算法概述
[原题](https://leetcode.cn/problems/merge-two-sorted-lists/description/?envType=study-plan-v2&envId=top-100-liked)

题目要求为将给出的有序列表按照升序合并。还是双指针，同时因为链表很灵活，对于输入链表可以在遍历时同时修改，所以不需要创建新的变量。很像矩阵的查找目标值的思路（ ***Z字形移动*** ），因为实际的代码逻辑就是找单次比较中较小的，然后移动相应指针。
- 时间复杂度为O(n+m)：都需要遍历比较
- 空间复杂度为O(1)：只需要一个变量标记目前较大值

### JAVA
```java
class Solution {
    public ListNode mergeTwoLists(ListNode list1, ListNode list2) {
       // 因为双指针会移动，所以还需要一个指针指向起始位置
       ListNode prehead=new ListNode(-1);
       // prev指向上次比较得到的较小值的下一个值
       ListNode prev=prehead;
       // l1和l2不是同时移动，它们只需要指向需要比较的元素
       while(l1!=null&&l2!=null){
        // 谁小谁往前移动（升序）
        if(l1.val<=l2.val){
            prev.next=l1;
            l1=l1.next;
        }else{
            prev.next=l2;
            l2=l2.next;
        }
        // prev指向移动的那个元素
        prev=prev.next;
       }
       // 拼接未比较完的那个链表（升序，无需比较）
       prev.next=l1==null?l2:l1;
       // 返回之前标记的位置
       return prehead.next;
    }
}
```

### C++
```c++
// 无区别
```

### 注意
可以用链表的头结点直接操作，但是需要记得 **标记起始点** 。
因为双指针的操作需要沿着它们各自链表，所以需要一个额外的指针将比较的结果串起来， **它落后于链表遍历指针** 。

## 两数相加
### 算法概述
[原题](https://leetcode.cn/problems/add-two-numbers/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为求出两个以逆序且各个节点用以表示位数的链表表示的数字之和。就是直接相加，同时保留进位。
- 时间复杂度为O(m+n)：都遍历一遍就行
- 空间复杂度为O(1)：返回的链表不算


### JAVA
``` bash
class Solution {
    public ListNode addTwoNumbers(ListNode l1, ListNode l2) {
        // 创建新的链表返回
        ListNode head = null, tail = null;
        // 进位
        int carry = 0;
        while (l1 != null || l2 != null) {
            // next有则移动，无则为0（长度不相同）
            int n1 = l1 != null ? l1.val : 0;
            int n2 = l2 != null ? l2.val : 0;
            int sum = n1 + n2 + carry;
            if (head == null) {
                // 题目要求单节点只保存一位
                head = tail = new ListNode(sum % 10);
            } else {
                // 头结点用于返回，尾节点用于更新返回链表
                tail.next = new ListNode(sum % 10);
                tail = tail.next;
            }
            // 进位计算
            carry = sum / 10;
            // 移动指针
            if (l1 != null) {
                l1 = l1.next;
            }
            if (l2 != null) {
                l2 = l2.next;
            }
        }
        // 如果最后还有进位，就创建新节点
        if (carry > 0) {
            tail.next = new ListNode(carry);
        }
        return head;
    }
}
```

### C++
```java
// 一样
```

### 注意
虽然思路不复杂，但是搭建一个优雅的代码框架还是很困难的。
要注意用`int n1 = l1 != null ? l1.val : 0;`将值与遍历分离（因为每一个节点只能存一个数字，但和会是两位的）。
要常温常新。

## 删除链表的倒数第N个节点
### 算法概述
[原题](https://leetcode.cn/problems/remove-nth-node-from-end-of-list/?envType=study-plan-v2&envId=top-100-liked)

本题要求为删除链表中倒数的第n个节点并返回链表。 ***快慢指针*** ，快指针到头了，恰好慢指针也到该删除的节点前面。
- 时间复杂度为O(n)：一个循环
- 空间复杂度为O(1)：双指针

### JAVA
```c++
class Solution {
    public ListNode removeNthFromEnd(ListNode head, int n) {
        // 头结点之前
        ListNode dummy = new ListNode(0, head);
        ListNode first = head;
        ListNode second = dummy;
        // 快指针先移动n次
        for (int i = 0; i < n; ++i) {
            first = first.next;
        }
        // 一起动
        while (first != null) {
            first = first.next;
            second = second.next;
        }
        // 删除节点
        second.next = second.next.next;
        ListNode ans = dummy.next;
        return ans;
    }
}
```

### C++
```java
// 没区别
```

### 注意
`ListNode dummy = new ListNode(0, head);`： *dummy* 是为了处理边界情况，也就是删除的就是头结点。
`second.next = second.next.next;`：我前面想删除节点得找到前后节点，但实际上只需要找到前一个节点即可，这就是数据结构不熟。
思路很简单，但是怎样优雅的实现需要学习与思考。

## 两两交换链表中的节点
### 算法概述
[原题](https://leetcode.cn/problems/swap-nodes-in-pairs/?envType=study-plan-v2&envId=top-100-liked)

本题要求将链表中的两两相邻节点原地交换位置。就是正常的遍历交换（迭代）。
- 时间复杂度为O(n)：节点要遍历完
- 空间复杂度为O(1)；和上题一样需要哑结点和一些其他的中间变量

### JAVA
```c++
class Solution {
    public ListNode swapPairs(ListNode head) {
        // 哑结点和上题一样，是用来处理边界的，因为一套操作下来需要三个节点，而头两个节点不够
        ListNode dummyHead = new ListNode(0,head);
        // 结构为temp node1 node2
        ListNode temp = dummyHead;
        // 三节点结构完整，符合交换条件
        while (temp.next != null && temp.next.next != null) {
            ListNode node1 = temp.next;
            ListNode node2 = temp.next.next;
            // temp不参与交换，temp的更新是用于判断后面是否符合交换条件
            temp.next = node2;
            node1.next = node2.next;
            node2.next = node1;
            temp = node1;
        }
        return dummyHead.next;
    }
}
```

### C++
```c++
// 相同
```

### 注意
`ListNode dummyHead = new ListNode(0,head);`：链表原地操作往往需要一个哑结点辅助处理边界。
`while (temp.next != null && temp.next.next != null)`： *temp* 只参与判断是否需要交换，交换本身 *node1* 和  *node2* 就能完成。
思路不难，重在实现与全面的考虑。

## K个一组翻转链表
### 算法概述
[原题](https://leetcode.cn/problems/reverse-nodes-in-k-group/?envType=study-plan-v2&envId=top-100-liked)

本题要求为以k为一组翻转子链表。其实思路不复杂，关键是怎么组织需要使用到的中间变量。
- 时间复杂度为O(n)：一次遍历
- 空间复杂度为O(1)；依托中间变量

### JAVA
```java
class Solution {
    public ListNode reverseKGroup(ListNode head, int k) {
        ListNode dummy = new ListNode(0,head);
        // 需要保留当前翻转部分的前一个节点
        ListNode pre = dummy;

        while (head != null) {
            // 使用tail指针从头开始遍历
            ListNode tail = pre;
            // 一个k链表一个k链表的来
            for (int i = 0; i < k; ++i) {
                tail = tail.next;
                if (tail == null) {
                    // 剩余不足k，可返回
                    return dummy.next;
                }
            }
            // 当前翻转链表的后一个节点
            ListNode nex = tail.next;
            // 翻转完了头尾倒置
            ListNode[] reverse = myReverse(head, tail);
            head = reverse[0];
            tail = reverse[1];
            // 相当于一个新的链表需要重新接入原链表
            pre.next = head;
            tail.next = nex;
            // 更新，tail此时为翻转链表中的最后一个元素
            pre = tail;
            head = tail.next;
        }

        return dummy.next;
    }

    // 反转链表
    public ListNode[] myReverse(ListNode head, ListNode tail) {
        ListNode prev = tail.next;
        ListNode curr = head;
        while (prev != tail) {
            ListNode next = curr.next;
            curr.next = prev;
            prev = curr;
            curr = next;
        }
        return new ListNode[]{tail, head};
    }
}
```

### C++
```c++
class Solution {
// public区别不大
public:
    ListNode* reverseKGroup(ListNode* head, int k) {
        ListNode* dummy=new ListNode(0,head);
        ListNode* pre=dummy;
        while(head!=nullptr){
            ListNode* tail=pre;
            for(int i=0;i!=k;++i){
                tail=tail->next;
                if(tail==nullptr){
                    return dummy->next;
                }
            }
            ListNode* nex=tail->next;
            // 这里用tie解包更方便
            tie(head,tail)=myReverse(head,tail);

            pre->next=head;
            tail->next=nex;
            
            pre=tail;
            head=tail->next;
        }
        return dummy->next;
    }
// 这里用了pair容器，
private:
    pair<ListNode*,ListNode*> myReverse(ListNode* head, ListNode* tail){
        ListNode* prev=tail->next;
        ListNode* curr=head;
        while(prev!=tail){
            ListNode* next=curr->next;
            curr->next=prev;
            prev=curr;
            curr=next;
        }
        return {tail,head};

    }
};
```

#### 重要实例方法及属性(C++)
`pair<ListNode*,ListNode*>`：使用pair容器类返回多个值
`tie(head,tail)=myReverse(head,tail)`：std::tie不仅可以解包std::tuple，也可以解包std::pair

### 注意
`ListNode* dummy=new ListNode(0,head);`这种需要操作子单位的题目都需要哑结点。
代码中用到`pre`来存储子链表的前一个节点，这里需要考虑到的是链表本身的特性，即 **必须要有前一个节点，才能插入** 。
以及用到了`tail`来进行遍历，判断是否剩余节点满足翻转条件。这里需要注意的是，`tail`不仅仅可用于遍历，还可用于 **更新** `pre`，这是很重要的。
以及还需要在翻转前保存子链表的下一个节点`nex`，在翻转后重新连接。
1. `pre`用于指向子链表前一个节点。
2. `tail`用于指向子链表的最后一个节点，以及下一组子链表的`pre`。
3. `nex`指向子链表的后一个节点。

还需要注意的是在翻转中：`while(prev!=tail)`是以`tail`为终止条件，而不是`while(curr!=null)`，需要注意翻转对象的性质改变辅助函数。

## 随机链表的复制
### 算法概述
[原题](https://leetcode.cn/problems/copy-list-with-random-pointer/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为深拷贝给出的链表（每个子节点包括后驱和一个随机索引）。难点在于顺序，或者说思路本身并不难，如何组织出一个行之有效的方法才难。
给出的解法是 ***三个循环：新节点（包含next）->random->新表*** 。核心思路就是在原链表上操作，这样会极大减少查询原链表信息的难度，会使所有操作简化为使用几次迭代的问题。
- 时间复杂度为O(n)：遍历三次
- 空间复杂度为O(1)：中间变量，输出不算

### JAVA
```java
class Solution {
    public Node copyRandomList(Node head) {
        if (head == null) {
            return null;
        }
        // 对遍历的当前节点进行深拷贝并放在其后一个位置（等同于上一个节点，无random）
        for (Node node = head; node != null; node = node.next.next) {
            // 深拷贝
            Node nodeNew = new Node(node.val);
            // 前后连接
            nodeNew.next = node.next;
            node.next = nodeNew;
        }
        // 仍然遍历原链表，为新节点创建random指针
        for (Node node = head; node != null; node = node.next.next) {
            // 所有新节点是原节点的next
            Node nodeNew = node.next;
            // （核心）用原节点的random进行拷贝
            nodeNew.random = (node.random != null) ? node.random.next : null;
        }
        // 头结点也变了
        Node headNew = head.next;
        // 遍历整个链表（包含新节点和原节点），进行分离
        for (Node node = head; node != null; node = node.next) {
            // 保存新节点
            Node nodeNew = node.next;
            // 丢弃新节点
            node.next = node.next.next;
            // 生成整个深拷贝新链表
            nodeNew.next = (nodeNew.next != null) ? nodeNew.next.next : null;
        }
        return headNew;
    }
}
```

### C++
```c++
// 没有区别
```

### 注意
第一个循环中把新节点插入节点之间的最大原因，就是可以在第三个循环中的`nodeNew.next = (nodeNew.next != null) ? nodeNew.next.next : null;`直接修改新节点的`next`，而且只需要两次迭代即可。
同时也方便了第二个循环中的`nodeNew.random = (node.random != null) ? node.random.next : null;`用以更新random，这样只需对当前节点的random进行迭代即可。
总而言之，核心的核心就是 **把新节点插入到原链表中** ，这也属于基于原链表使操作更便捷，非常经典，需要牢记和熟练。

还有回溯+哈希表的解法，时间复杂度一样：
```java
class Solution {
public:
    unordered_map<Node*, Node*> cachedNode;

    Node* copyRandomList(Node* head) {
        if (head == nullptr) {
            return nullptr;
        }
        // 判断表里面有没有当前节点，没有就加进去
        if (!cachedNode.count(head)) {
            Node* headNew = new Node(head->val);
            cachedNode[head] = headNew;
            // 递归解决
            headNew->next = copyRandomList(head->next);
            headNew->random = copyRandomList(head->random);
        }
        return cachedNode[head];
    }
};
```


## 排序链表
### 算法概述
[原题](https://leetcode.cn/problems/sort-list/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为升序排列给出的链表。使用 ***自底向上的归并排序*** 。
自底向上的归并排序，就是把原链表以1、2、4、6、8……等sublength的长度分为多个子链表，每次分成两个子链表后，将这两个子链表以“合并两个升序链表”的方式合并，因为是从1开始的，所以这样做没有问题。不断循环这样向上合并的过程，后面即使两个子链表剩的长度不够也没有问题，“合并两个升序链表”给出了解释。
- 时间复杂度为O(nlogn)：归并排序
- 空间复杂度为O(1)：原地操作

### JAVA
```java
class Solution {
    public ListNode sortList(ListNode head) {
        if (head == null) {
            return head;
        }
        int length = 0;
        ListNode node = head;
        // 算链表长度
        while (node != null) {
            length++;
            node = node.next;
        }
        // 哑结点
        ListNode dummyHead = new ListNode(0, head);
        // 归并排序（位运算<<=1就是*=2）
        for (int subLength = 1; subLength < length; subLength <<= 1) {
            ListNode prev = dummyHead, curr = dummyHead.next;
            // 分割
            while (curr != null) {
                // head1为第一个子链表中的头结点（链表中的头结点）
                ListNode head1 = curr;
                // 遍历到尾节点
                for (int i = 1; i < subLength && curr.next != null; i++) {
                    curr = curr.next;
                }
                // head2是第一个子链表后的第一个节点
                ListNode head2 = curr.next;
                // 断开
                curr.next = null;
                // 进入第二个链表（重复上述操作）
                curr = head2;
                for (int i = 1; i < subLength && curr != null && curr.next != null; i++) {
                    curr = curr.next;
                }
                ListNode next = null;
                // 现在curr是第二个链表的最后一个元素
                if (curr != null) {
                    next = curr.next;
                    // 断开，此时next是下一个子链表对的节点
                    curr.next = null;
                }
                // 经历过分割与重新合并且排过序的子链表对
                ListNode merged = merge(head1, head2);
                // 遍历完子链表对
                prev.next = merged;
                while (prev.next != null) {
                    prev = prev.next;
                }
                curr = next;
            }
        }
        return dummyHead.next;
    }

    public ListNode merge(ListNode head1, ListNode head2) {
        // 还要哑结点
        ListNode dummyHead = new ListNode(0);
        // 三个临时变量
        ListNode temp = dummyHead, temp1 = head1, temp2 = head2;
        // 和“合并两个升序链表”的逻辑一样的
        while (temp1 != null && temp2 != null) {
            if (temp1.val <= temp2.val) {
                temp.next = temp1;
                temp1 = temp1.next;
            } else {
                temp.next = temp2;
                temp2 = temp2.next;
            }
            temp = temp.next;
        }
        if (temp1 != null) {
            temp.next = temp1;
        } else if (temp2 != null) {
            temp.next = temp2;
        }
        return dummyHead.next;
    }
}
```

### C++
```c++
// 没啥区别
```

### 注意
自顶向下和自底向上的归并排序 **时间复杂度一样** ，但是 **空间复杂度上后者更优** 。但自顶向上的应用更广泛，自底向上 **适合链表** 。
1. `class Solution`中的`dummyHead`用于处理整个链表的极端边界情况。
2. `merge()`中的`dummyHead`用于处理“合并两个升序链表”中的极端边界情况。
3. `head1`是当前子链表对第一个子链表的头，`head2`是当前子链表对第二个子链表的头。
4. `next`指向下一个子链表对的头结点，`curr`依据它来更新。
5. `prev`用于存储前一个子链表对的最后一个节点，然后将合并完（分割过的）子链表对重新连接回来。

归并排序对于链表极为重要， **务必背记** 。

## 合并k个升序链表
### 算法概述
[原题](https://leetcode.cn/problems/merge-k-sorted-lists/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为合并给出链表中的所有升序子链表。采用的还是和上题一样的 ***分治法*** 。但是这里因为用的是递归，所以隐藏代码写的更深，没有写出来。用的是独立的两个递归函数共同工作。
- 时间复杂度为O(kn×logk)：多组分治遍历的次数求和
- 空间复杂度为O(logk)：栈

### JAVA
```java
class Solution {
    public ListNode mergeKLists(ListNode[] lists) {
        // 直接用函数彻底分装
        return merge(lists, 0, lists.length - 1);
    }
    // 左右指针从左右边界开始
    public ListNode merge(ListNode[] lists, int l, int r) {
        // 这两个判断条件是为递归底部使用的
        if (l == r) {
            return lists[l];
        }
        if (l > r) {
            return null;
        }
        // 除以2
        int mid = (l + r) >> 1;
        // 递归（在栈中是自底向上）
        return mergeTwoLists(merge(lists, l, mid), merge(lists, mid + 1, r));
    }
    // 
    public ListNode mergeTwoLists(ListNode a, ListNode b) {
        // 分治到只剩一个
        if (a == null || b == null) {
            return a != null ? a : b;
        }
        // 这下和前面两道题都是一样的
        ListNode dummy = new ListNode(0);
        // 要记得比较用的三元结构的第一个得从dummy开始
        ListNode tail = dummy, aPtr = a, bPtr = b;
        while (aPtr != null && bPtr != null) {
            if (aPtr.val < bPtr.val) {
                tail.next = aPtr;
                aPtr = aPtr.next;
            } else {
                tail.next = bPtr;
                bPtr = bPtr.next;
            }
            tail = tail.next;
        }
        // 处理末端边界
        tail.next = (aPtr != null ? aPtr : bPtr);
        return dummy.next;
    }
}
```

### C++
```c++
// 没区别，就是java里的!=null可以不用写，直接写指针名会自动判断的
```

### 注意
两道题都用到了基本的排序，说明还是很重要的，“合并两个升序链表”还是要牢记、
把功能分离到两个递归函数里来工作，是比较复杂的，虽然说结构很清晰简单，但是栈内的顺序还是要理清楚，要多练习。

## LRU缓存
### 算法概述
[原题](https://leetcode.cn/problems/lru-cache/?envType=study-plan-v2&envId=top-100-liked)

本题要求设计一个满足getter和setter（get,put,capacity初始化）的类，LRU意为最近访问的数据在实例内优先级更高，且要求get()和put()在O(1)时间内完成。核心是在确保访问操作的时间复杂度的同时，根据capacity动态调整存储的键值对。使用 ***双向链表*** 实现。

### JAVA
```java
class LRUCache {
    // 双向链表节点
    class DLinkedNode {
        int key;
        int value;
        // 前驱和后驱都要有
        DLinkedNode prev;
        DLinkedNode next;

        // 两个构造器
        public DLinkedNode() {}

        public DLinkedNode(int _key, int _value) {key = _key;value = _value;}
    }

    // 数字索引，值为节点实例
    private Map<Integer, DLinkedNode> cache = new HashMap<Integer, DLinkedNode>();
    // 双向链表内部跟踪节点总数
    private int size;
    private int capacity;
    // 头、尾指针
    private DLinkedNode head, tail;

    // capacity初始化
    public LRUCache(int capacity) {
        this.size = 0;
        this.capacity = capacity;
        head = new DLinkedNode();
        tail = new DLinkedNode();
        head.next = tail;
        tail.prev = head;
    }

    public int get(int key) {
        DLinkedNode node = cache.get(key);
        if (node == null) {
            return -1;
        }
        // 移动到头部，即变为“最近使用”
        moveToHead(node);
        return node.value;
    }

    public void put(int key, int value) {
        DLinkedNode node = cache.get(key);
        // 没有就新建一个节点
        if (node == null) {
            DLinkedNode newNode = new DLinkedNode(key, value);
            cache.put(key, newNode);
            // 新建也是“最近使用”
            addToHead(newNode);
            ++size;
            if (size > capacity) {
                // 把“最不最近使用”的节点删去，腾出空间
                DLinkedNode tail = removeTail();
                cache.remove(tail.key);
                --size;
            }
        } else {
            // “最近使用”
            node.value = value;
            moveToHead(node);
        }
    }

    private void addToHead(DLinkedNode node) {
        // 移动节点位置基操，先改node，再改前后驱
        node.prev = head;
        node.next = head.next;
        head.next.prev = node;
        head.next = node;
    }

    private void removeNode(DLinkedNode node) {
        node.prev.next = node.next;
        node.next.prev = node.prev;
    }

    private void moveToHead(DLinkedNode node) {
        // 这里没有真的去遍历移动，而是直接删除和新建，更方便
        removeNode(node);
        addToHead(node);
    }

    private DLinkedNode removeTail() {
        DLinkedNode res = tail.prev;
        removeNode(res);
        return res;
    }
}
```

### C++
```c++
// 一样的思路，除了哈希表的接口不一样
```

### 注意
标准的将自定义数据结构和常用容器复合的类定义，要注意体现数据结构的特征（e.g., `moveToHead`直接删除和插入）。
在这个类中，哈希表和双向链表都存了一次数据，因为 **哈希表是用于快速访问** ，而 **双向链表是用于更新顺序** ，这里需要兼取两者的优势。
两个数据结构之间的交互或者数据结构本身的欠缺需要设置私有变量来弥补（e.g., `size`和`capacity`）。

**常温常新**
