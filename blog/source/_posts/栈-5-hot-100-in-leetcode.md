---
title: 栈(5) --hot 100 in leetcode
date: 2024-11-25 21:37:49
tags:
    - 栈
    - hot 100
    - leetcode
---

<script type="text/javascript"
src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>

## 有效的括号
### 算法概述
[原题](https://leetcode.cn/problems/valid-parentheses/submissions/583086191/?envType=study-plan-v2&envId=top-100-liked)

本题要求为判断输入的括号组成的字符串是否有效。所有字符遍历，一半字符串入栈， ***另外一半与此时栈内的进行匹配 ***。
- 时间复杂度为O(n)
- 空间复杂度为O(n+∑)：栈（原字符）和哈希表（字符集）


### JAVA
```bash
class Solution {
    public boolean isValid(String s) {
        int n = s.length();
        // 奇数长度铁错
        if (n % 2 == 1) {
            return false;
        }
        // 用哈希表存储用于比较的右符号
        Map<Character, Character> pairs = new HashMap<Character, Character>() {{
            put(')', '(');
            put(']', '[');
            put('}', '{');
        }};
        Deque<Character> stack = new LinkedList<Character>();
        for (int i = 0; i < n; i++) {
            char ch = s.charAt(i);
            // 先判断是哪个方向的符号入栈
            if (pairs.containsKey(ch)) {
                // 右符号入栈时栈中一定不为空且有相应同类型左符号对应
                if (stack.isEmpty() || stack.peek() != pairs.get(ch)) {
                    return false;
                }
                // 弹出栈顶
                stack.pop();
            // 前半部分入栈
            } else {
                stack.push(ch);
            }
        }
        return stack.isEmpty();
    }
}
```

#### 重要实例方法及属性(JAVA)
再总结一下：
`Deque<Character> stack = new LinkedList<Character>();`：JAVA因为stack较老的原因，一般使用双向队列实现栈
`Deque.isEmpty()`：是否为空
`Deque.peek()`：栈顶
`Deque.pop()`：弹出
`Deque.push()`：压入

### C++
```bash
// 可用stack
```

#### 重要实例方法及属性(C++)
`stack.empty()`：是否为空
`stack.top()`：栈顶
`stack.pop()`：弹出栈顶
`stack.push()`：压入

### 注意
入栈一半元素，与之后的元素匹配，利用的是 **括号分左右** 的特性以及 **二分后彼此匹配** 。
要记得使用 **哈希表存储字符集** ，这里使用栈的主要原因是 **栈的后进先出** 与括号的规律一样。

## 最小栈
### 算法概述
[原题](https://leetcode.cn/problems/min-stack/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为设计一个能在常数时间内检索到最小元素的栈。采用一个 ***辅助栈*** 存储当前实例内状态的最小值。
- 时间复杂度为O(1)：常数时间查找
- 空间复杂度为O(n)：辅助栈

### JAVA
```bash
class MinStack {
    Deque<Integer> xStack;
    Deque<Integer> minStack;

    public MinStack() {
        xStack = new LinkedList<Integer>();
        minStack = new LinkedList<Integer>();
        // 栈底放一个最大元素
        minStack.push(Integer.MAX_VALUE);
    }
    
    public void push(int x) {
        xStack.push(x);
        // 栈顶永远都是当前状态的最小值（迭代）
        minStack.push(Math.min(minStack.peek(), x));
    }
    
    public void pop() {
        xStack.pop();
        minStack.pop();
    }
    
    public int top() {
        return xStack.peek();
    }
    
    public int getMin() {
        return minStack.peek();
    }
}
```

### C++
```bash
// 与之类似
```

### 注意
辅助栈的思路类似于 **迭代** ，因为入栈时从第一个元素开始的，所以最小值永远可以与当前栈顶元素进行比较得到，所以 **能不断重复此过程** 。除了保存每次入栈后栈内最小值，也可以通过更巧妙的方法，避免那么多次的入栈与出栈。

比如，在入栈时加入判断：
```bash
if (minStack.isEmpty() || x <= minStack.peek()) {
    minStack.push(x);
}
```
只有 **比栈顶元素小的时候** 才入栈，同时
```bash
if (popped == minStack.peek()) {
    minStack.pop(); 
}
```
出栈时判断栈内当前最小值（辅助栈栈顶）是不是当前出栈的元素再决定对不对辅助栈进行操作。

这样做避免了在 **升序入栈** 的时候重复入栈的操作，因为 **升序入栈时最小值就是第一个元素** ，无需考虑之后的元素。

## 字符串解码
### 算法概述
[原题](https://leetcode.cn/problems/decode-string/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为对给出的数字+'[]'形式重复前缀数字次数的'[]'内的字符串/字符。使用一个栈便可实现。但是处理字符串等等操作比较复杂。
- 时间复杂度为O(n)：n为解码后的字符串长度
- 空间复杂度为O(n)：

### JAVA
```bash
class Solution {
    int ptr;

    public String decodeString(String s) {
        // 直接用接口实现类（不像之前只使用接口定义方法）
        LinkedList<String> stk = new LinkedList<String>();
        ptr = 0;

        while (ptr < s.length()) {
            char cur = s.charAt(ptr);
            if (Character.isDigit(cur)) {
                // 获取一个数字并进栈
                String digits = getDigits(s);
                stk.addLast(digits);
                // '['和重复字符串统一处理
            } else if (Character.isLetter(cur) || cur == '[') {
                // 获取一个字母并进栈
                stk.addLast(String.valueOf(s.charAt(ptr++))); 
            } else {
                ++ptr;
                LinkedList<String> sub = new LinkedList<String>();
                // 从主栈中读取重复字符串
                while (!"[".equals(stk.peekLast())) {
                    sub.addLast(stk.removeLast());
                }
                // 反向读取，所以需要翻转
                Collections.reverse(sub);
                // 左括号出栈
                stk.removeLast();
                // 此时栈顶为当前 sub 对应的字符串应该出现的次数
                int repTime = Integer.parseInt(stk.removeLast());
                // 临时变量存储当前字符串状态
                StringBuffer t = new StringBuffer();
                String o = getString(sub);
                // 构造字符串
                while (repTime-- > 0) {
                    t.append(o);
                }
                // 将构造好的字符串入栈
                stk.addLast(t.toString());
            }
        }

        return getString(stk);
    }

    // 以String类型返回一个数字
    public String getDigits(String s) {
        StringBuffer ret = new StringBuffer();
        // 循环是保险措施
        while (Character.isDigit(s.charAt(ptr))) {
            ret.append(s.charAt(ptr++));
        }
        return ret.toString();
    }

    // 把LinkedList转换成Strings
    public String getString(LinkedList<String> v) {
        StringBuffer ret = new StringBuffer();
        for (String s : v) {
            ret.append(s);
        }
        return ret.toString();
    }
}
```

#### 重要实例方法及属性(JAVA)
`Character.isDigit()`：静态方法判断数字
`LinkedList.addLast()`：确定添加至末尾
`Character.isLetter()`：判断是否为字符
`LinkedList.removeLast()`：移除末尾元素
`LinkedList.peekLast()`：返回末尾元素
`String.valueOf()`：将各种数据类型转换为`String`
`Collections.reverse()`：翻转数据
`Integer.parseInt()`：将字符串转换为数字

### C++
```bash
// api很不一样，实现思路一样
```

#### 重要实例方法及属性(C++)
`isdigit()`：判断数字
`isalpha()`：判断字符
`reverse(begin(),end())`：面向STL的翻转，有迭代器的重载

### 注意
实现底层较为复杂，需要 **反复训练直至完全掌握** 。



## 每日温度
### 算法概述
[原题](https://leetcode.cn/problems/decode-string/solutions/264391/zi-fu-chuan-jie-ma-by-leetcode-solution/?envType=study-plan-v2&envId=top-100-liked)

本题要求为对于给出温度数组，返回相同索引下记录当天需要多少天温度继续升高的数组（隔多久值变大）。可以使用 ***单调栈*** ，也就是在遍历的同时，只保存 ***未找到后续更大值的温度索引*** 。
- 时间复杂度为O(n)：只需遍历一次
- 空间复杂度为O(n)：最大只需一个和原数组长度相当的栈

### JAVA
```bash
class Solution {
    public int[] dailyTemperatures(int[] temperatures) {
        int length = temperatures.length;
        int[] ans = new int[length];
        // 存索引的栈
        Deque<Integer> stack = new LinkedList<Integer>();
        for (int i = 0; i < length; i++) {
            int temperature = temperatures[i];
            // 比之前（栈顶）温度大
            while (!stack.isEmpty() && temperature > temperatures[stack.peek()]) {
                // 弹出栈顶
                int prevIndex = stack.pop();
                // 求两个天数之间的差额
                ans[prevIndex] = i - prevIndex;
            }
            // 比之前小，天数入栈
            stack.push(i);
        }
        return ans;
    }
}
```

### C++
```bash
// 一样的
```

### 注意
这道题的关键是 **对数据做了预处理** ，也就是 **使用下标而不是数据本身** 来进行统计，这不管对于哪个数据结构都应该有类似的思维，也就是 **通过一层预处理使数据结构特性能够被利用** 。

- `!stack.isEmpty()`：要记得判断栈空的边界情况
- `int[] ans = new int[length];`：初始定义一个数组来存储答案，与预处理的步骤相适配
- `while (!stack.isEmpty() && temperature > temperatures[stack.peek()])`：要用`while`，因为可能有多个栈中元素同时比当前元素小
- `stack.push(i);`：当前元素入栈和之前的`while`无关， **每个元素都要入栈一次**


## 柱状图中最大的矩形
### 算法概述
[原题](https://leetcode.cn/problems/largest-rectangle-in-histogram/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为对给出的表示柱形高度的数组，找到其中能够勾勒出来的最大矩形。也就是说核心还是相邻的柱形的高度 **比较问题** ，和上一题一样，应该使用 ***单调栈*** 。可以使用两次栈来得到左右边界，也可以通过 ***哨兵*** 优化为一次栈的操作。
- 时间复杂度为O(n)
- 空间复杂度为O(n)

### JAVA
```bash
class Solution {
    public int largestRectangleArea(int[] heights) {
        int n = heights.length;
        int[] left = new int[n];
        int[] right = new int[n];
        // 将right用最大索引填满（while中不更新右边界说明没有小于当前索引的值）
        Arrays.fill(right, n);
        
        Deque<Integer> mono_stack = new ArrayDeque<Integer>();
        for (int i = 0; i < n; ++i) {
            while (!mono_stack.isEmpty() && heights[mono_stack.peek()] >= heights[i]) {
                // 当前值大于栈顶（之前的），更新（延长）栈中值对应索引的右边界
                right[mono_stack.peek()] = i;
                // 弹出栈顶
                mono_stack.pop();
            }
            // 当前索引左边界取的是栈顶元素的索引
            left[i] = (mono_stack.isEmpty() ? -1 : mono_stack.peek());
            // 当前元素入栈
            mono_stack.push(i);
        }
        
        int ans = 0;
        for (int i = 0; i < n; ++i) {
            ans = Math.max(ans, (right[i] - left[i] - 1) * heights[i]);
        }
        return ans;
    }
}
```

### C++
```bash
// 一样
```

### 注意
这道题本身是求两个边界索引，相当于 **两个每日温度问题** ，但通过 **使用哨兵填充右边界值** ，将栈操作精简化。

- `while (!mono_stack.isEmpty() && heights[mono_stack.peek()] >= heights[i])`：外部循环是用来找有边界值的，栈中会一直按照索引存放升序排列的元素，直至遍历到比栈顶小的元素
- `right[mono_stack.peek()] = i;`：在遇到比栈顶小的元素时，说明找到了栈顶的右边界
- `while (!mono_stack.isEmpty() && heights[mono_stack.peek()] >= heights[i])`：要用`while`对此时栈中所有升序存储的元素设置右边界，当前值可能 **不止只是当前栈顶的右边界** 
- `left[i] = (mono_stack.isEmpty() ? -1 : mono_stack.peek());`：左边界一直取的都是栈顶，因为经过上面的`while`，栈顶绝对比当前值小，或者为-1
- `ans = Math.max(ans, (right[i] - left[i] - 1) * heights[i]);`：面积计算公式需要自己推导

解法的核心是 **通过栈统一处理升序元素的右边界** ，然后确保左边界更新时只剩下 **栈顶永远比当前元素小** 的情况。也就是说栈在此的功能，就是 **分离一部分有规律的元素** 并使得它们能够被 **统一处理** 。

