---
title: 二叉树(15) --hot 100 in leetcode
date: 2024-11-22 22:15:51
tags:
    - 二叉树
    - hot 100
    - leetcode
---

<script type="text/javascript"
src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>

## 二叉树的中序遍历
### 算法概述
[原题](https://leetcode.cn/problems/binary-tree-inorder-traversal/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为中序遍历。三种解法： ***递归*** ， ***迭代*** ， ***Morris*** 。
对于递归：
- 时间复杂度为O(n)：全部遍历一次
- 空间复杂度为O(n)：隐式的栈空间
对于迭代：
- 时间复杂度为O(n)
- 空间复杂度为O(n)：双向队列实现栈，只是变得显式
对于Morris：
- 时间复杂度为O(n)
- 空间复杂度为O(1)：通过判断左节点的情况，和将右节点与根节点相连接等算法，避免栈


### JAVA
```bash
// 递归
class Solution {
    public List<Integer> inorderTraversal(TreeNode root) {
        List<Integer> res = new ArrayList<Integer>();
        inorder(root, res);
        return res;
    }
    // 工作都在这里面
    public void inorder(TreeNode root, List<Integer> res) {
        if (root == null) {
            return;
        }
        // 一直找到最左下，然后到根节点
        inorder(root.left, res);
        // 到了根节点之后加上
        res.add(root.val);
        // 找到右子树，至此一个完整的树结构遍历完了，加入右节点，回到根节点，继续往上
        inorder(root.right, res);
    }
}

// 迭代
class Solution {
    public List<Integer> inorderTraversal(TreeNode root) {
        List<Integer> res = new ArrayList<Integer>();
        // 用双向队列模拟栈
        Deque<TreeNode> stk = new LinkedList<TreeNode>();
        // 当root为null（栈不为空）时要回溯到根节点
        while (root != null || !stk.isEmpty()) {
            // 遍历到左下
            while (root != null) {
                stk.push(root);
                root = root.left;
            }
            // 栈顶元素
            root = stk.pop();
            res.add(root.val);
            // 当root是左子节点时，不可避免root为null
            root = root.right;
        }
        return res;
    }
}

// Morris中序遍历
class Solution {
    public List<Integer> inorderTraversal(TreeNode root) {
        List<Integer> res = new ArrayList<Integer>();
        // 当前节点的左子树上最右的节点，也是在中序遍历中当前节点的前驱
        TreeNode predecessor = null;
        while (root != null) {
            // 当前节点有左节点/左子树
            if (root.left != null) {
                // 从左子树根节点开始向右找
                predecessor = root.left;
                while (predecessor.right != null && predecessor.right != root) {
                    predecessor = predecessor.right;
                }
                
                // 让predecessor与当前节点相连接，继续遍历左子树
                if (predecessor.right == null) {
                    predecessor.right = root;
                    // 最后遍历到最左下的节点停止
                    root = root.left;
                }
                // （准备工作完成）保存根节点，移动至右子节点
                else {
                    res.add(root.val);
                    predecessor.right = null;
                    root = root.right;
                }
            }
            // （准备工作完成）所有根节点与右子节点的连接已完成/树没有左子树
            else {
                res.add(root.val);
                root = root.right;
            }
        }
        return res;
    }
}
```

### C++
```bash
// 对于C++，迭代可以用stack容器类(push(),pop())，而不是双向队列，其他一样
```

### 注意
![递归](\images\中序遍历递归.png)
对于一个树根为1，1的右子树为3,3的左子树为2的树，函数调用栈如上所示。

对于迭代，代码的执行过程是差不多的，但内在逻辑的差别较大。迭代中`root`用右子节点刷新，所以不可避免会为null，所以循环条件特意这么设置` while (root != null || !stk.isEmpty())`，同时，`root`还从模拟栈中取值刷新`root = stk.pop();`，
```bash
while (root != null) {
    stk.push(root);
    root = root.left;
}
```
此时右子节点又会被初始时用于遍历到左下的循环 **压入栈中** ， 很巧妙。

对于Morris，代码的核心逻辑是将所有节点用中序遍历的逻辑连接起来， **对于左子结点，将其右子节点设为根节点** ，而 **对于右子节点，将其右子节点设置为根节点的根节点** ，这样就得到了本质为中序遍历的 **右序遍历** 。每次遍历的时候，核心是 **找到当前节点在中序遍历中的前驱并成为其右子节点** 。

最后就是
```bash
else {
    res.add(root.val);
    root = root.right;
}
```
右序遍历。

**常温常新**

## 二叉树的最大深度
### 算法概述
[原题](https://leetcode.cn/problems/maximum-depth-of-binary-tree/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为求出给出二叉树的最大深度。可使用 ***深度优先搜索(DFS)*** ，或者 ***广度优先搜索(BFS)*** ，前者更佳。
对于DFS：
- 时间复杂度为O(n)
- 空间复杂度为O(height)：递归深度为二叉树高度
对于BFS：
- 时间复杂度为O(n)
- 空间复杂度为O(n)：取决于需要存储多少个元素

### JAVA
```bash
// DFS
class Solution {
    public int maxDepth(TreeNode root) {
        // 没有的话设置为0
        if(root==null){return 0;}
        else{
            // 递归
            int leftHeight=maxDepth(root.left);
            int rightHeight=maxDepth(root.right);
            // 这个+1是递归能够计数的核心
            return Math.max(leftHeight,rightHeight)+1;
        }
    }
}

// BFS
class Solution {
    public int maxDepth(TreeNode root) {
        if (root == null) {
            return 0;
        }
        // 用队列存储元素（以层为单位）
        Queue<TreeNode> queue = new LinkedList<TreeNode>();
        queue.offer(root);
        int ans = 0;
        while (!queue.isEmpty()) {
            // 当前层有多少元素
            int size = queue.size();
            // 前进一层
            while (size > 0) {
                // 根据移除头部，也就是上一层遗留的节点
                TreeNode node = queue.poll();
                size--;
                // 加入下一层的节点
                if (node.left != null) {
                    queue.offer(node.left);
                }
                if (node.right != null) {
                    queue.offer(node.right);
                }
            }
            // 相应的深度加一
            ans++;
        }
        return ans;
    }
}
```

#### 重要实例方法及属性(JAVA)
`Queue.poll()`：移除并返回头元素
`Queue.size()`：返回队列长度

### C++
```bash
// 其实DFS可以写的更简单
class Solution {
public:
    int maxDepth(TreeNode* root) {
        if (root == nullptr) return 0;
        return max(maxDepth(root->left), maxDepth(root->right)) + 1;
    }
};

// BFS
// 几个方法要改一下怎么用
```

#### 重要实例方法及属性(C++)
`Queue.front()`：返回头元素
`Queue.pop()`：不返回任何值，只删除头元素

### 注意
都是非常经典的算法， **必须熟练掌握** 。

## 翻转二叉树
### 算法概述
[原题](https://leetcode.cn/problems/invert-binary-tree/?envType=study-plan-v2&envId=top-100-liked)

本题要求为将给出的二叉树翻转后返回。对二叉树操作不像对链表操作那么便捷，所以需要一个栈（函数调用栈）作为辅助来帮助翻转，同时，对于二叉树而言，因为每个子树的结构都很清晰，所以递归比较适合统一处理整个树。
- 时间复杂度为O(n)
- 空间复杂度为O(n)：栈

### JAVA
```bash
class Solution {
    public TreeNode invertTree(TreeNode root) {
        if (root == null) {
            return null;
        }
        // 在交换之前要通过递归得到左右子节点/树
        TreeNode left = invertTree(root.left);
        TreeNode right = invertTree(root.right);
        root.left = right;
        root.right = left;
        return root;
    }
}
```

### C++
```bash
// 没区别
```

### 注意
二叉树的很多操作要通过递归完成，所以熟悉递归下的函数调用栈的顺序是很重要的。
这道题中的`TreeNode left = invertTree(root.left);`和`TreeNode right = invertTree(root.right);`一定要记得是要在对左右子节点的操作之前运行，还有`if (root == null)`底部情况也要处理。
总而言之：
- 先是null处理
- 再是递归
- 再是具体工作的代码

**一定要熟练掌握**

## 对称二叉树
### 算法概述
[原题](https://leetcode.cn/problems/invert-binary-tree/solutions/415160/fan-zhuan-er-cha-shu-by-leetcode-solution/?envType=study-plan-v2&envId=top-100-liked)

本题要求为判断二叉树是否对称。还是使用 ***递归*** 分别判断左右子节点。

### JAVA
```bash
class Solution {
    public boolean isSymmetric(TreeNode root) {
        return check(root.left,root.right);
    }

    public boolean check(TreeNode p, TreeNode q){
        // 判断底部值的两种情况
        if(p==null&&q==null){
            return true;
        }
        if(p==null||q==null){
            return false;
        }
        // 每个子树的结构相同，都是三个节点，所以需要两个&&
        return p.val==q.val&&check(p.left,q.right)&&check(p.right,q.left);
    }
}
```

### C++
```bash
// 一样
```

### 注意
在使用递归的时候，一定要注意二叉树的基本单位（子树）是 **三个节点** 。

## 二叉树的直径
### 算法概述
[原题](https://leetcode.cn/problems/diameter-of-binary-tree/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为求出二叉树中隔得最远的两个节点的距离。还是需要使用深度优先搜索的思路，应该以 ***“求最大深度”*** 的思路求这道题。
- 时间复杂度为O(n)
- 空间复杂度为O(height)：栈的深度最坏情况可能还是最大深度

### JAVA
```bash
class Solution {
    // 使用全局变量追踪
    int ans=0;
    public int diameterOfBinaryTree(TreeNode root) {
        depth(root);
        return ans;
    }
    // 和“求最大深度”的思路没有区别
    public int depth(TreeNode node) {
        if (node == null) {
            return 0; 
        }
        int L = depth(node.left); 
        int R = depth(node.right); 
        // 但是在这里更新了ans，因为树中节点的最长路径可能比根节点的大
        ans = Math.max(ans, L+R); 
        return Math.max(L, R) + 1; 
    }
}
```

### C++
```bash
// 没区别
```

### 注意
计算的路径的时候是不应该包含节点本身的，所以应该`ans = Math.max(ans, L+R); `这么更新，与递归更新深度的`return Math.max(L, R) + 1; `不一样。还要记得用全局变量追踪，以免作用域冲突。

## 二叉树的层序遍历
### 算法概述
[原题](https://leetcode.cn/problems/binary-tree-level-order-traversal/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为把二叉树每一层的元素提取成一个列表，然后按照顺序组合成一个完整的列表返回。其实 ***只要在“二叉树的最大深度”那道题上稍微改一点*** 就可以了。

### JAVA
```bash
class Solution {
    public List<List<Integer>> levelOrder(TreeNode root) {
        if (root == null) return new ArrayList<>(); 

        List<List<Integer>> ans = new ArrayList<>(); 
        Queue<TreeNode> queue = new LinkedList<>(); 
        queue.offer(root); 

        while (!queue.isEmpty()) {
            int size = queue.size(); 
            // 加个临时列表
            List<Integer> temp = new ArrayList<>(); 

            while (size > 0) {
                TreeNode node = queue.poll(); 
                // 存入临时列表
                temp.add(node.val); 
                size--;
                if (node.left != null) {
                    queue.offer(node.left);
                }
                if (node.right != null) {
                    queue.offer(node.right);
                }
            }
            // 把临时列表加入答案列表中
            ans.add(temp); 
        }

        return ans; 
    }
}
```

### C++
```bash
// 一样是微调
```

### 注意
之前的BFS和DFS精通了之后，对这种题型就会信手拈来。所以 **一定要完全掌握BFS和DFS** 。

## 将有序数组转换为二叉搜索树
### 算法概述
[原题](https://leetcode.cn/problems/convert-sorted-array-to-binary-search-tree/solutions/312607/jiang-you-xu-shu-zu-zhuan-huan-wei-er-cha-sou-s-33/?envType=study-plan-v2&envId=top-100-liked)

本题要求为将有序数组转换为平衡的二叉搜索树(BST)，平衡即所有节点的子树高度差不超过1，二叉搜索树意为 **左子树只包含小于当前节点的数，右子树只包含大于当前节点的数** 。给出的解法使用的是 ***递归的二分法*** ，随机选取mid节点，然后直接生成就好。
- 时间复杂度为O(n)
- 空间复杂度为O(logn)：平均，因为栈的使用空间会回退，如果退化成链表或者单边树，那就还是O(n)

### JAVA
```bash
class Solution {
    Random rand = new Random();

    public TreeNode sortedArrayToBST(int[] nums) {
        return helper(nums, 0, nums.length - 1);
    }
    // 二分法递归
    public TreeNode helper(int[] nums, int left, int right) {
        // 当左指针大于右指针说明递归完毕
        if (left > right) {
            return null;
        }
        // 选择任意一个中间位置数字作为根节点
        int mid = (left + right + rand.nextInt(2)) / 2;
        // 使当前数组元素变为树节点
        TreeNode root = new TreeNode(nums[mid]);
        // 分别递归处理第一个mid的左侧和右侧
        root.left = helper(nums, left, mid - 1);
        root.right = helper(nums, mid + 1, right);
        return root;
    }
}
```

#### 重要实例方法及属性(JAVA)
`Random.nextInt(Integer)`：生成一个[0,Integer]范围的整数


### C++
```bash
// 没有区别，除了用的是rand()
```

#### 重要实例方法及属性(C++)
`rand()%2`：能达到`Random.nextInt(2)`相同的效果

### 注意
这道题使用了 **二分** 来确保树的 **平衡性** 。
要记住的是，二分法一般要采用`if (left > right)`这样的判断条件来终止递归，而能达到这样的终止条件是由于递归中的右指针`mid - 1`和左指针`mid+1`达到的，同时，因为是二分法处理，所以是 **先处理再递归** 。


## 验证二叉搜索树
### 算法概述
[原题](https://leetcode.cn/problems/validate-binary-search-tree/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为验证给出的树是否为二叉搜索树（定义上题有）。递归可以完成，或者使用中序遍历（迭代）模拟一个栈，其实空间复杂度一样，那还不如用前者。
- 时间复杂度为O(n)
- 空间复杂度为O(height)：最坏还是n

### JAVA
```bash
class Solution {
    public boolean isValidBST(TreeNode root) {
    // 用常量设置函数栈底层，防止整数溢出
        return isValidBST(root, Long.MIN_VALUE, Long.MAX_VALUE);
    }
    // 主体
    public boolean isValidBST(TreeNode node, long lower, long upper) {
        // 底部
        if (node == null) {
            return true;
        }
        // 判断工作
        if (node.val <= lower || node.val >= upper) {
            return false;
        }
        return isValidBST(node.left, lower, node.val) && isValidBST(node.right, node.val, upper);
    }
}
```

### C++
```bash
// 没啥区别吧
```

### 注意
java里的防溢出常量是`Long.MIN_VALUE, Long.MAX_VALUE`这俩，而C++中的是`LONG_MIN, LONG_MAX`这俩。
无论是判断还是操作（这里是操作）， **递归的作用是定位** ，这 **与题目要求是分离的** 。

## 二叉搜索树中第K小的元素
### 算法概述
[原题](https://leetcode.cn/problems/kth-smallest-element-in-a-bst/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为找出二叉搜索树（定义上题有）中第k小的元素。

### JAVA
```bash
class Solution {
    public int kthSmallest(TreeNode root, int k) {
        // 用双向队列来存储节点（模拟栈）
        Deque<TreeNode> stack = new ArrayDeque<TreeNode>();
        while (root != null || !stack.isEmpty()) {
            while (root != null) {
                stack.push(root);
                root = root.left;
            }
            root = stack.pop();
            // 和中序遍历一模一样，只多了一个弹出k个节点的操作，而且不用转换成数组
            --k;
            if (k == 0) {
                break;
            }
            root = root.right;
        }
        return root.val;
    }
}
```

### C++
```bash
// 没区别
```

### 注意
对于二叉平衡树(AVL)， **中序遍历很重要** 。要理解`root = stack.pop();`这里得到的就是按照中序遍历的节点。

## 二叉树的右视图
### 算法概述
[原题](https://leetcode.cn/problems/binary-tree-right-side-view/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为按照根节点向下的顺序返回所有节点的右子节点。

### JAVA
```bash
// 还是BFS
class Solution {
    public List<Integer> rightSideView(TreeNode root) {
        if (root == null) {
            return new ArrayList<>();
        }

        List<Integer> result = new ArrayList<>();
        Queue<TreeNode> queue = new LinkedList<>();
        queue.offer(root);

        while (!queue.isEmpty()) {
            // 记录单层长度
            int size = queue.size(); 
            for (int i = 0; i < size; i++) {
                TreeNode node = queue.poll();
                // 删除到只剩最右边的元素
                if (i == size - 1) {
                    result.add(node.val);
                }
                // 将下一层的节点加入队列
                if (node.left != null) {
                    queue.offer(node.left);
                }
                if (node.right != null) {
                    queue.offer(node.right);
                }
            }
        }

        return result;
    }
}
```

### C++
```bash
// 类似，除了c++有stack以外
```

### 注意
正如 **栈（双向队列）很适合这类问题** ，**BFS也很适合操作具有层内关系的单层节点** 。

## 二叉树展开为链表
### 算法概述
[原题](https://leetcode.cn/problems/flatten-binary-tree-to-linked-list/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为将二叉树按照先序遍历展开成链表。除了先序遍历以外，根据先序遍历的规律，还可以通过不断将遍历节点的右子树 ***向左子树的尾部拼接*** 。
- 时间复杂度为O(n)
- 空间复杂度为O(1)：在原二叉树上操作

### JAVA
```bash
class Solution {
    public void flatten(TreeNode root) {
        TreeNode curr = root;
        while (curr != null) {
            if (curr.left != null) {
                // 当前节点的左子树
                TreeNode next = curr.left;
                // 当前节点的左子树的最右下节点
                TreeNode predecessor = next;
                while (predecessor.right != null) {
                    predecessor = predecessor.right;
                }
                // 将当前节点的右子树拼接上去
                predecessor.right = curr.right;
                // 把当前节点的左子树转移到右子树上去
                curr.left = null;
                curr.right = next;
            }
            // 从下一个右子树开始
            curr = curr.right;
        }
    }
}
```

### C++
```bash
// 一样
```

### 注意
其实本质上还是一个 **找前驱后驱** 的工作，先序遍历是 **根->左->右** ，也就是说这样相当于为每个子树（三个节点的结构）找到后驱，把所有左子结点转移到右子树上去，所以当`if (curr.left != null)`再也没有左子节点的时候，就成功了。而且符合先序遍历的顺序。

当然还是要了解先序遍历的实现方式：
```bash
class Solution {
    public void flatten(TreeNode root) {
        List<TreeNode> list = new ArrayList<TreeNode>();
        preorderTraversal(root, list);
        int size = list.size();
        // 把属于二叉树的特征清除（没有左子节点）
        for (int i = 1; i < size; i++) {
            TreeNode prev = list.get(i - 1), curr = list.get(i);
            prev.left = null;
            prev.right = curr;
        }
    }

    public void preorderTraversal(TreeNode root, List<TreeNode> list) {
        if (root != null) {
            // 根
            list.add(root);
            // 左
            preorderTraversal(root.left, list);
            // 右
            preorderTraversal(root.right, list);
        }
    }
}
```
就是说白了根在哪都是`list.add(root);`直接就能处理，但左子树和右子树的遍历需要用递归，顺序改改就行。

## 从前序与中序遍历构造二叉树
### 算法概述
[原题](https://leetcode.cn/problems/construct-binary-tree-from-preorder-and-inorder-traversal/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为给出两种方式遍历得到的列表，返回一个确定的二叉树。关键是题目保证无重复元素，所以用哈希表能够很便捷地求出必要信息，从两个遍历本身的特性上。
- 时间复杂度为O(n)
- 空间复杂度为O(n)

### JAVA
```bash
class Solution {
    // 哈希表辅助找根节点
    private Map<Integer, Integer> indexMap;

    private TreeNode myBuildTree(int[] preorder, int[] inorder, int preorder_left, int preorder_right, int inorder_left, int inorder_right) {
        // 前序遍历列表的双指针比较
        if (preorder_left > preorder_right) {
            return null;
        }
        // 前序遍历中的第一个节点就是根节点
        int preorder_root = preorder_left;
        // 在中序遍历中定位根节点
        int inorder_root = indexMap.get(preorder[preorder_root]);
        // 得到左子树中的节点数目（中序遍历种根节点在结果列表中间）
        int size_left_subtree = inorder_root - inorder_left;
        // 先把根节点建立出来
        TreeNode root = new TreeNode(preorder[preorder_root]);
        // 递归构造左子树
        root.left = myBuildTree(preorder, inorder, preorder_left + 1, preorder_left + size_left_subtree, inorder_left, inorder_root - 1);
        // 递归构造右子树
        root.right = myBuildTree(preorder, inorder, preorder_left + size_left_subtree + 1, preorder_right, inorder_root + 1, inorder_right);
        return root;
    }

    public TreeNode buildTree(int[] preorder, int[] inorder) {
        int n = preorder.length;
        indexMap = new HashMap<Integer, Integer>();
        for (int i = 0; i < n; i++) {
            indexMap.put(inorder[i], i);
        }
        return myBuildTree(preorder, inorder, 0, n - 1, 0, n - 1);
    }
}
```

### C++
```bash
// 哈希操作可以用重载[]，基本一样
```

### 注意
其实重点还是是否了解 **先序遍历和中序遍历的特点** ，正因为中序遍历是左根右，所以能够从中序遍历的结果得到 **左右子树的边界信息** ，而也正是因为先序遍历根左右，所以在逐层遍历的时候更加直观，也就 **更易于创建二叉树** 。

代码中的顺序也可以自然地这样写： **先创建根节点，再递归创建左子树，再是右子树** 。

`if (preorder_left > preorder_right)`注意这里不是大于等于，而是大于，等于时也就意味着有一个独立的节点。

迭代，也就是外显函数调用栈，也可以实现，大致的思路也是如此，主要的核心还是在于 **中序遍历和先序遍历的特性** 。


## 路径总和 III
### 算法概述
[原题](https://leetcode.cn/problems/path-sum-iii/?envType=study-plan-v2&envId=top-100-liked)

本题要求为求出所有总和为目标值的方向向下的路径。可以直接用深度优先搜索直接每个节点算一次，也可以用 ***前缀和+回溯法*** 。
- 时间复杂度为O(n)：前缀和只需遍历一次
- 空间复杂度为O(n)：哈希表存储前缀和

### JAVA
```bash
class Solution {
    public int pathSum(TreeNode root, int targetSum) {
        // 哈希表存储前缀和(key)和对应路径出现频次(value)
        Map<Long, Integer> prefix = new HashMap<Long, Integer>();
        // 答案键
        prefix.put(0L, 1);
        return dfs(root, prefix, 0, targetSum);
    }

    public int dfs(TreeNode root, Map<Long, Integer> prefix, long curr, int targetSum) {
        if (root == null) {
            return 0;
        }
        // 答案数量
        int ret = 0;
        // 前缀和
        curr += root.val;
        // 从哈希表中招现有路径有没有符合条件的
        ret = prefix.getOrDefault(curr - targetSum, 0);
        // 更新哈希表
        prefix.put(curr, prefix.getOrDefault(curr, 0) + 1);
        // 统计根节点左子树的所有符合路径
        ret += dfs(root.left, prefix, curr, targetSum);
        // 统计根节点右子树的所有符合路径
        ret += dfs(root.right, prefix, curr, targetSum);
        // 回溯的关键，清除当前节点的影响
        prefix.put(curr, prefix.getOrDefault(curr, 0) - 1);

        return ret;
    }
}
```

### C++
```bash
// 可以用重载[]，不用put、getOrDefault这些，会方便很多
```

### 注意
求多个节点的和的时候如果无法用DFS或者BFS直接得到O(n)，就应该想到前缀和，这个算法最大的优点就是 **只需遍历一次** 。
但同时，还需要考虑到的是，因为操作对象是二叉树，所以需要用到 **回溯** 。 **回溯** 的关键是要在隐式的函数递归回到当前节点的根节点时， **消除当前节点（子树）** 的影响。

`prefix.put(0L, 1);`还要记住，因为是前缀和，所以 **最后的答案应该是0** ,不设置这个答案键值对，路径总和也更新不了。
`prefix.put(curr, prefix.getOrDefault(curr, 0) - 1);`这里是把哈希表中的统计清除了，但并不是清除`curr`当前前缀和，因为 **回溯之后前缀和自然保持的是上一层根节点的前缀和** 。这就是要把 **前缀和更新以及路径匹配放在递归之前，而回溯更新放在递归之后** 的原因。 

还要会的是时间复杂度为O(n^2)的深度优先搜索的算法：
```bash
class Solution {
    public int pathSum(TreeNode root, long targetSum) {
        if (root == null) {
            return 0;
        }

        int ret = rootSum(root, targetSum);
        // 每个节点都来一趟
        ret += pathSum(root.left, targetSum);
        ret += pathSum(root.right, targetSum);
        return ret;
    }

    public int rootSum(TreeNode root, long targetSum) {
        int ret = 0;

        if (root == null) {
            return 0;
        }
        int val = root.val;
        if (val == targetSum) {
            ret++;
        } 
        // 没有回溯，从底部向上匹配一直当当前节点
        ret += rootSum(root.left, targetSum - val);
        ret += rootSum(root.right, targetSum - val);
        return ret;
    }
}
```
要注意的是:
- `targetSum - val`，看似左右并行，但实际上是独立的，对每个子树来说，只是先算左边还是右边的问题，匹配的减法是独立的。
- `ret += pathSum(root.left, targetSum);`这里相当于对每个节点都用递归循环一遍路径匹配的递归过程，所以是双递归，所以时间复杂度为O(n^2)。

## 二叉树的最近公共祖先
### 算法概述
[原题](https://leetcode.cn/problems/lowest-common-ancestor-of-a-binary-tree/?envType=study-plan-v2&envId=top-100-liked)

本题要求为找出给定两个节点的最近公共祖先，公共祖先的定义是在是祖先的同时深度尽可能大（深度越大，也就是离两个节点更近），还可以是自身。还是 ***深度优先搜索递归*** ，从底向上，判断子树中包不包含两个要的节点。
- 时间复杂度为O(n)
- 空间复杂度为O(height)：最坏还是n
### JAVA
```bash
class Solution {
    private TreeNode ans=null;

    public TreeNode lowestCommonAncestor(TreeNode root, TreeNode p, TreeNode q) {
        dfs(root,p,q);
        return ans;
    }

    private boolean dfs(TreeNode root, TreeNode p, TreeNode q){
        if(root==null) return false;
        // 当前节点左右子树是否带有目标节点
        boolean lson=dfs(root.left,p,q);
        boolean rson=dfs(root.right,p,q);
        // 两种情况
        if((lson&&rson)||((root.val==p.val||root.val==q.val)&&(lson||rson))){
            ans=root;
        }
        // 是否和节点有关
        return lson||rson||(root.val==p.val||root.val==q.val);
    }
}
```

### C++
```bash
// 没区别
```

### 注意
核心的底层实现思路肯定还是 **深度优先搜索** ，在此之上要搞清楚 **怎么把判断放入递归** 。

`if((lson&&rson)||((root.val==p.val||root.val==q.val)&&(lson||rson)))`可见 **判断应该放在递归取值之后** 。同时要考虑两种情况，即`(lson&&rson)`包含两个节点和`(root.val==p.val||root.val==q.val)&&(lson||rson)`包含其中一个节点，而 **另外一个节点也是最近共同祖先** 。

`return lson||rson||(root.val==p.val||root.val==q.val)`递归函数的返回只需要证明当前节点与目标节点相关即可，可以是 **包含左或右目标节点** ，也可以是 **本身就是左或有目标节点** 。

`ans=root;`因为是从底向上（最大深度）的，所以第一个就是我们要的，然后这个算法最妙的点就在于当`ans`第一次更新之后，即使它的上层根节点其实也符合条件，但是对于上层根节点来说，**只会有lson和rson中的一个是true，但条件要求必须两个都为true** ，所以上层根节点不会再被用来更新`root`。

## 二叉树中的最大路径和
### 算法概述
[原题](https://leetcode.cn/problems/binary-tree-maximum-path-sum/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为求出二叉树中的最大路径和（路径即以边连接的节点序列）。就是把“路径总和 III”那道题拿过来改一改就行了。
- 时间复杂度为O(n)
- 空间复杂度为O(height)：最坏为n

### JAVA    
```bash
class Solution {
    private int maxPath = Integer.MIN_VALUE; 

    public int maxPathSum(TreeNode root) {
        dfs(root); 
        return maxPath;
    }

    // dfs 返回从当前节点向下的最大路径和（可以为 0 表示不选该路径）
    private int dfs(TreeNode root) {
        // 空节点当0
        if (root == null) {
            return 0; 
        }
        // 递归计算左、右子树的最大路径和，负数贡献直接视为 0
        int left = Math.max(dfs(root.left), 0);
        int right = Math.max(dfs(root.right), 0);

        // 更新全局最大路径和：当前节点值 + 左右子树贡献
        maxPath = Math.max(maxPath, root.val + left + right);

        // 返回从当前节点向下的最大单路径和（左右子树中选择一个）
        return root.val + Math.max(left, right);
    }
}
```

### C++
```bash
// 没啥区别
```

### 注意
`maxPath = Math.max(maxPath, root.val + left + right)`全局最大路径和是一个 **缺了一条边的三角形** ，所以在函数调用栈弹出栈顶时，也就是为上一层根节点计算提供`left`和`right`时，应该是`return root.val + Math.max(left, right)`，也就是 **只返回一条边** 。
