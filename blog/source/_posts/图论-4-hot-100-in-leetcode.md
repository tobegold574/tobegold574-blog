---
title: 图论(4) --hot 100 in leetcode
date: 2024-11-24 14:41:27
tags:
    - 图论
    - hot 100
    - leetcode
---

<script type="text/javascript"
src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>

## 岛屿数量
### 算法概述
[原题](https://leetcode.cn/problems/number-of-islands/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为计数给出矩阵中有多少个岛屿（连在一起的1）。dfs和bfs的基础实现。
- 时间复杂度为O(mn)：全部遍历一次
- 空间复杂度为O(mn)：隐式栈或显式栈或队列

### JAVA
```bash
// 深度优先搜索
class Solution {
    void dfs(char[][] grid, int r, int c) {
        // 矩阵行数
        int nr = grid.length;
        // 矩阵列数
        int nc = grid[0].length;
        // 四个方向是否超出边界或已经把该方向全部转换完
        if (r < 0 || c < 0 || r >= nr || c >= nc || grid[r][c] == '0') {
            return;
        }
        // 将当前元素转化成0，用以标记
        grid[r][c] = '0';
        // 上
        dfs(grid, r - 1, c);
        // 下
        dfs(grid, r + 1, c);
        // 左
        dfs(grid, r, c - 1);
        // 右
        dfs(grid, r, c + 1);
    }

    public int numIslands(char[][] grid) {
        if (grid == null || grid.length == 0) {
            return 0;
        }
        int nr = grid.length;
        int nc = grid[0].length;
        int num_islands = 0;
        // 是1就dfs转化
        for (int r = 0; r < nr; ++r) {
            for (int c = 0; c < nc; ++c) {
                if (grid[r][c] == '1') {
                    ++num_islands;
                    dfs(grid, r, c);
                }
            }
        }
        return num_islands;
    }   
}

// 广度优先搜索
class Solution {
    public int numIslands(char[][] grid) {
        if (grid == null || grid.length == 0) {
            return 0;
        }

        int nr = grid.length;
        int nc = grid[0].length;
        int num_islands = 0;

        for (int r = 0; r < nr; ++r) {
            for (int c = 0; c < nc; ++c) {
                if (grid[r][c] == '1') {
                    ++num_islands;
                    grid[r][c] = '0';
                    // 队列，只负责当前层，所以为临时变量
                    Queue<Integer> neighbors = new LinkedList<>();
                    // 当前元素映射到一维的索引
                    neighbors.add(r * nc + c);
                    while (!neighbors.isEmpty()) {
                        // 加一层，删根元素
                        int id = neighbors.remove();
                        int row = id / nc;
                        int col = id % nc;
                        if (row - 1 >= 0 && grid[row-1][col] == '1') {
                            neighbors.add((row-1) * nc + col);
                            grid[row-1][col] = '0';
                        }
                        if (row + 1 < nr && grid[row+1][col] == '1') {
                            neighbors.add((row+1) * nc + col);
                            grid[row+1][col] = '0';
                        }
                        if (col - 1 >= 0 && grid[row][col-1] == '1') {
                            neighbors.add(row * nc + col-1);
                            grid[row][col-1] = '0';
                        }
                        if (col + 1 < nc && grid[row][col+1] == '1') {
                            neighbors.add(row * nc + col+1);
                            grid[row][col+1] = '0';
                        }
                    }
                }
            }
        }

        return num_islands;
    }
}


```

### C++
```bash
// 对于深度优先搜索（递归）用不着容器类
// 对于广度优先搜索可以用pair来表示坐标
```

### 注意
也就是说，对于图而言，深度优先搜索，就是深入每个方向，**边走边置零，直至三个方向全都堵死，才回头** 。而广度优先搜索就相当于 **每次循环向外扩张一层，并删除生成上一层的节点** 。

还可以用并查集🤨。


## 腐烂的橘子
### 算法概述
[原题](https://leetcode.cn/problems/rotting-oranges/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为在每分钟挨着图中'2'元素的'1'元素都会自增的情况下，最少需要多久时间只剩'0'和'1'（新鲜的橘子受腐烂的橘子影响腐烂）。关键是传递性。

### JAVA
```bash
class Solution {
    // 成对的方向变化先声明好
    int[] dr = new int[]{-1, 0, 1, 0};
    int[] dc = new int[]{0, -1, 0, 1};

    public int orangesRotting(int[][] grid) {
        int R = grid.length, C = grid[0].length;
        Queue<Integer> queue = new ArrayDeque<Integer>();
        Map<Integer, Integer> depth = new HashMap<Integer, Integer>();
        // 队列内存腐烂橘子的一维索引，哈希表也以一维索引为键，扩散次数为值存腐烂橘子
        for (int r = 0; r < R; ++r) {
            for (int c = 0; c < C; ++c) {
                if (grid[r][c] == 2) {
                    int code = r * C + c;
                    queue.add(code);
                    depth.put(code, 0);
                }
            }
        }
        int ans = 0;
        while (!queue.isEmpty()) {
            int code = queue.remove();
            int r = code / C, c = code % C;
            // 逐层扩散
            for (int k = 0; k < 4; ++k) {
                int nr = r + dr[k];
                int nc = c + dc[k];
                // 新鲜橘子转化为腐烂橘子，进入哈希表和队列
                if (0 <= nr && nr < R && 0 <= nc && nc < C && grid[nr][nc] == 1) {
                    grid[nr][nc] = 2;
                    int ncode = nr * C + nc;
                    queue.add(ncode);
                    // 值用之前累积的扩散次数更新
                    depth.put(ncode, depth.get(code) + 1);
                    // 扩散次数也就是答案
                    ans = depth.get(ncode);
                }
            }
        }
        // 是否还有剩下的新鲜橘子
        for (int[] row: grid) {
            for (int v: row) {
                if (v == 1) {
                    return -1;
                }
            }
        }
        return ans;
    }
}
```

### C++
```bash
class Solution {
    // 默认为private
    int cnt;
    int dis[10][10];
    int dir_x[4] = {0, 1, 0, -1};
    int dir_y[4] = {1, 0, -1, 0};
public:
    int orangesRotting(vector<vector<int>>& grid) {
        queue<pair<int, int>>Q;
        // 初始化数组全部元素为-1（标记数组）
        memset(dis, -1, sizeof(dis));
        cnt = 0;
        int n = (int)grid.size(), m = (int)grid[0].size(), ans = 0;
        // 把腐烂的橘子的坐标加入队列，将标记数组相应值转换为0（访问过了）
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < m; ++j) {
                if (grid[i][j] == 2) {
                    Q.emplace(i, j);
                    dis[i][j] = 0;
                }
                else if (grid[i][j] == 1) {
                    // 统计新鲜橘子数量
                    cnt += 1;
                }
            }
        }
        while (!Q.empty()){
            auto [r, c] = Q.front();
            Q.pop();
            for (int i = 0; i < 4; ++i) {
                int tx = r + dir_x[i];
                int ty = c + dir_y[i];
                // 如果访问过了（腐烂的橘子）就跳过
                if (tx < 0|| tx >= n || ty < 0|| ty >= m || ~dis[tx][ty] || !grid[tx][ty]) {
                    continue;
                }
                // 标记数组还用于统计扩散次数
                dis[tx][ty] = dis[r][c] + 1;
                Q.emplace(tx, ty);
                if (grid[tx][ty] == 1) {
                    // 新鲜变腐烂，但是不改值了，直接存坐标
                    cnt -= 1;
                    // 更新答案
                    ans = dis[tx][ty];
                    if (!cnt) {
                        break;
                    }
                }
            }
        }
        return cnt ? -1 : ans;
    }
};
```

#### 重要实例方法及属性(C++)
- `memset(dis, -1, sizeof(dis));`：将`dis`数组全部初始化为-1

### 注意
C++和JAVA的差别还是蛮大的，由于容器类的不同。JAVA使用了 **哈希表** 和 **队列** ，而C++使用了 **原生数组标记** 和 **队列** ，虽然两个用来标记的数据结构的作用还是一样的，但是在使用细节上是有差别的，需要注意。

关键的是使用`depth.put(ncode, depth.get(code) + 1);`哈希表来追踪扩散次数，`depth.get(code) + 1`以 **前一次的扩散次数** 为下一层更新扩散次数。同时，不断更新所用时间`ans = depth.get(ncode);`，直至最外层，即是答案。

## 课程表
### 算法概述
[原题](https://leetcode.cn/problems/course-schedule/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为判断含有先修后修关系的课程对是否能排序成一个有效的课程表，也就是拓扑排序问题。对于拓扑排序，如果是有向无环图，即可生成多个拓扑排序的可能，但如果有环，就不能进行拓扑排序。可以用 ***深度优先搜索递归*** 完成，也可以用 ***广度优先搜索维护显式队列*** 完成。
对于深度优先搜索：
- 时间复杂度为O(n+m)：不仅所有课程要遍历，先修课程还要单拎出来遍历
- 空间复杂度为O(n+m)：邻接表和隐栈
对于广度优先搜索：
- 时间复杂度为O(n+m)
- 空间复杂度为O(n+m)：领接表和队列


### JAVA
```bash
// 深度优先搜索
class Solution {
    // 邻接表（存后续课程）
    List<List<Integer>> edges;
    // 访问状态记录
    int[] visited;
    // 结果
    boolean valid = true;

    public boolean canFinish(int numCourses, int[][] prerequisites) {
        edges = new ArrayList<List<Integer>>();
        for (int i = 0; i < numCourses; ++i) {
            // 把每门课都当做先修课程
            edges.add(new ArrayList<Integer>());
        }
        // 每门课的状态都要记录
        visited = new int[numCourses];
        // 在课程对应索引加入它们的先修可成
        for (int[] info : prerequisites) {
            // 前者（[1]）为后续，后者（[0]）为先修
            edges.get(info[1]).add(info[0]);
        }
        // 对每一门课程进行深度优先搜索
        for (int i = 0; i < numCourses && valid; ++i) {
            // 未访问
            if (visited[i] == 0) {
                dfs(i);
            }
        }
        return valid;
    }

    public void dfs(int u) {
        // 访问中
        visited[u] = 1;
        for (int v: edges.get(u)) {
            if (visited[v] == 0) {
                dfs(v);
                if (!valid) {
                    // 有环了直接终止
                    return;
                }
            } else if (visited[v] == 1) {
                // 如果不止一个访问中，说明有环
                valid = false;
                return;
            }
        }
        visited[u] = 2;
    }
}

// 广度优先搜索
class Solution {
    List<List<Integer>> edges;
    // 入度数组
    int[] indeg;
    public boolean canFinish(int numCourses, int[][] prerequisites) {
        edges = new ArrayList<List<Integer>>();
        for (int i = 0; i < numCourses; ++i) {
            edges.add(new ArrayList<Integer>());
        }
        // 不是状态数组，而是入度数组
        indeg = new int[numCourses];
        for (int[] info : prerequisites) {
            edges.get(info[1]).add(info[0]);
            // 记录每个先修课程的入度
            ++indeg[info[0]];
        }
        // 记录可修课程
        Queue<Integer> queue = new LinkedList<Integer>();
        // 入度为0直接可修
        for (int i = 0; i < numCourses; ++i) {
            if (indeg[i] == 0) {
                queue.offer(i);
            }
        }
        int visited = 0;
        while (!queue.isEmpty()) {
            // 每次从可修的队列中读出一个课程
            ++visited;
            int u = queue.poll();
            // 遍历当前可修课程的后续课程
            for (int v: edges.get(u)) {
                // 当前可修，说明后续也可修，入度自减
                --indeg[v];
                // 如果入度为0，则可加入队列，维护此类递归过程
                if (indeg[v] == 0) {
                    queue.offer(v);
                }
            }
        }
        // 最后比较所有队列中弹出的可修课程数和课程总数
        return visited == numCourses;
    }
}
```

### C++
```bash
// 代码逻辑上无差别
```

#### 重要实例方法及属性(C++)
`vector.resize(int)`：调整元素数量

### 注意
深度优先搜索的核心是 **检查三种状态是否会冲突** ，这利用了深度优先搜索 **易于递归** 的特性。而广度优先搜索的核心是 **逐层缩减** ，不断更新入度， **通过入度数判断当前层课程是否可修** ，然后记录可修课程总数，利用的是广度优先搜索 **层层相关** 的特性。

**拓扑排序，需要熟练掌握**


## 实现Trie（前缀树）
### 算法概述
[原题](https://leetcode.cn/problems/implement-trie-prefix-tree/description/?envType=study-plan-v2&envId=top-100-liked)

本题要求为实现一个字典树类（就是能存词，还能找前缀和词）。
- 时间复杂度为O(|s|)：看输入
- 空间复杂度为O(∣T∣⋅Σ)：看输入字符所属字符集和存了多少

### JAVA
```bash
// 多叉树或者一种特殊的图
class Trie {
    // 当前节点的所有子节点
    private Trie[] children;
    // 是不是单词结尾
    private boolean isEnd;

    public Trie() {
        // 多叉（最多26个叉）
        children=new Trie[26];
        // 默认不是单词结尾
        isEnd=false;
    }
    
    public void insert(String word) {
        Trie node=this;
        // 一个字母对应一层，构造出word.length()层的深度的树结构
        for(int i=0;i<word.length();i++){
            char ch=word.charAt(i);
            int index=ch-'a';
            if(node.children[index]==null){
                node.children[index]=new Trie();
            }
            node=node.children[index];
        }
        // 最后一个节点是字符串末尾
        node.isEnd=true;
    }
    
    public boolean search(String word) {
        Trie node=searchPrefix(word);
        // 存在且为完整单词
        return node!=null&&node.isEnd;
    }
    
    public boolean startsWith(String prefix) {
        // 不完整没关系
        return searchPrefix(prefix)!=null;
    }

    // 迭代
    private Trie searchPrefix(String prefix){
        Trie node=this;
        // 一个一个字符向下找
        for(int i=0;i<prefix.length();i++){
            char ch=prefix.charAt(i);
            int index=ch-'a';
            // 中间没有就是没有了
            if(node.children[index]==null){
                return null;
            }
            node=node.children[index];
        }
        return node;
    }
}
```

### C++
```bash
// 一样的
```

### 注意
其实这道题最后不难，甚至用不着什么复杂的操作，但这也正是得益于结构设计的好。
- `private Trie[] children;`：多叉树的结构支持了直接迭代查找
- `private boolean isEnd;`：其实每个节点就存了这么一个信息，和一个扩展的next指针，即`children`
- `node.isEnd=true;`：构造函数中使默认`isEnd`为`false`，字符串末尾的`isEnd`需要自己记得设置
- `if(node.children[index]==null)`：查找过程中可以进行判断，无需等到最后返回

解法抓住了查找单词和查找迭代的共性，那就是 **查找** ，而它俩也是整个题目唯二要求的后续功能，所以可以直接使用 **多叉树的结构和迭代的底层逻辑** ，所以要注意的就还是 **从需求出发，而不是从技术出发** 。




