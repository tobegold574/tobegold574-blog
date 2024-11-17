---
title: introductory KAN
date: 2024-11-08 09:06:51
tags:
    - 机器学习
    - 新模型
    - KAN
---
<script type="text/javascript"
src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>

[kaggle notebook](https://www.kaggle.com/code/tobegold574/introductory-kan)
[github repo](https://github.com/KindXiaoming/pykan)

这是一篇整合了新模型**KAN**的基础API的教程。**KAN**是一种基于Kolmogorov-Arnold theorem的新型神经网络模型，旨在替代传统的前馈神经网络**MLP**。**KAN**的创新点在于在原本线性方程的基础上加入了spline，并且通过spline的应用替代了原non-linearity激活函数，这样既节省了计算资源，并且在一定数量级的训练上能够更加高效的进行学习。

# 准备阶段

## 安装

```bash
pip install pykan
```

如果使用的是独立环境，请用

```bash
!pip install pykan
```
## 引入
本文主要在于展示，如果想要练手建议直接
```bash
from kan import *
```
如要使用模型叠加，建议更精细化管理，避免各个模型的方法间混淆

## 创建数据集
### `create_dataset_from_data`
这个方法适用于已经拥有了处理好的输入输出，也就是一般的数据集的使用方式
```bash
dataset = create_dataset_from_data(x, y, device=device)
# device指的是用于训练的硬件，可以为cpu或者gpu
```

### `create_dataset`
而这个方法可以从公式中创造数据，也就是说接受公式（函数）作为参数，同时确定***n_vars***，即输出数量，它将会自动构造数据
```bash
f = lambda x: torch.exp(torch.sin(torch.pi*x[:,[0]]) + x[:,[1]]**2)
dataset = create_dataset(f, n_var=2, device=device)
```

# 训练
## KAN的基础认识
(latex有转译问题，建议跳过)
这是**KAN**的激活函数：$$\phi(x)={\rm scale\_base}*b(x) + {\rm scale\_sp}*{\rm spline}(x)$$
+ $b(x)$ 是最基础的部分，默认为 'silu' ($x/(1+e^{-x})$), 可以通过设置${\rm base\_fun}$更改
+ scale_sp 从 N(0,$\text{noise_scale}^2$)中取样
+ scale_base 从N(scale_base_mu,$\text{scale_base_sigma}^2$)
+ sparse initialization: 如果 sparse_init = True, 那么 scale_base and scale_sp 将会被设置为0

## Grid(interval) and K(degree&extened girds)
grid是**KAN**中非常重要的一个参数，它主要用于在一定的范围内，该将所有基础的曲线单元如何划分（**KAN**所使用的曲线为b-spline），该值越大，那么就有更多的单元，可以类比为随机森林中的决策树数量等等。

还有一个重要的参数为K，主要用于确定曲线的最高次，同时也可以用于扩大原有的grid,作为一种训练技巧。

```bash
grid = extend_grid(grid, k_extend=k)
# 基于k对grid进行扩充
model = KAN(width=[1,1], grid=G, k=k, grid_eps = 0.01)
# 基础的模型定义如上，grid_eps可以用于构造各个grid之间的间隙，使曲线之间不会因为必须在grid之间连接而易发过拟合问题
```

## 训练中的超参（辅助稀疏化）
###  $\lambda$
 $\lambda$的默认值为0.001，该超参的用处为降低曲线复杂度，避免模型在单一数据上死磕，影响后续学习。

 ```bash
 model.fit(dataset, opt="LBFGS", steps=20, lamb=0.01);
 # 通过lamb可以修改其值
 ```

###  $\lambda_{\rm ent}$
严格来讲$\lambda\lambda_{\rm ent}$共同用于惩罚复杂性，后者默认值为2.0，可以通过调整后者，在一个更大的数字范围内对惩罚进行调整，进行更精细化的管理。

## 正则化
正则化有很多种选择，基于edge和spline以及symbolic，可以对三者是否进行正则化的选择排列组合，通过尝试选取最佳的选项。
```bash
model.fit(dataset, opt="LBFGS", steps=20, lamb=0.01, reg_metric='edge_forward_spline_n'); 
```
在这里不过多赘述，如要详细了解，请跳转[kaggle notebook](https://www.kaggle.com/code/tobegold574/introductory-kan)或者[github repo](https://github.com/KindXiaoming/pykan)

## 可视化
可视化是KAN提供的一种新颖的特性，我们可以通过不断地可视化训练过程，手动调整底层曲线单元（如果知道有更符合的经典曲线），以及手动剪枝等操作。

但可视化必须基于模型至少已经进行了一次前馈，否则不能可视化。
```bash
model.fit(dataset, opt="LBFGS", steps=20, lamb=0.01, reg_metric='edge_forward_spline_n'); 
model.plot()
# 类似于这样
```

```bash
model.plot(metric='forward_n')
# 或者在plot内定义metric（集成可视化和前馈或者反向传播）
```

## 剪枝
KAN内部对于每个edge、隐藏层神经元都有权重，正如之前给出的公式$$\phi(x)={\rm scale\_base}*b(x) + {\rm scale\_sp}*{\rm spline}(x)$$
可以通过设定阈值自动剪枝，或者也可以通过可视化学习过程，手动剪去看的出来有问题的。

### 剪神经元
```bash
model = model.prune_node(threshold=1e-2) 
# 通过阈值（自动）
model = model.prune_node(active_neurons_id=[[0]])
# 通过定位（手动）
```

### 剪边
```bash
model.prune_edge()
# 也可以加参数来精细化此过程
```
但实际上在**KAN**学习过程中，边数会极快地被创建和删除，我自己感觉只有训练结束调整模型时才需要。那时一般建议手动。

## 版本管理和回溯
**KAN**还提供每次训练时记录版本的功能，这实际上节约了计算资源，是一个很好的特性，但如果只是稍微稍微试一下，建议关闭。、
```bash
model = KAN(width=[2,5,1], grid=3, k=3, seed=42, device=device,auto_save=False)
# 在模型定义时可以设置auto_save的值，默认为True，改为False可以关闭设置checkpoint
model.rewind()
# 可用rewind()进行回溯
```

# 更进一步
在这篇文章中，其实我只是简单介绍了一些基本的api，但是实际上模型提供了很多的方法与属性进行微调，在这里不一一展现。
可以到我的[kaggle notebook](https://www.kaggle.com/code/tobegold574/introductory-kan)再随便看一看
或者MIT的刘子鸣大佬（原文一作）的[github repo](https://github.com/KindXiaoming/pykan)深入学习