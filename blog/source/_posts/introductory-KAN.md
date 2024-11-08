---
title: introductory KAN
date: 2024-11-08 09:06:51
tags:
    - 机器学习
    - 新模型
    - KAN
---
[kaggle notebook(我自己写的)](https://www.kaggle.com/code/tobegold574/introductory-kan)
[github repo](https://github.com/KindXiaoming/pykan)

这是一篇整合了新模型**KAN**的基础API的教程。KAN是一种基于Kolmogorov-Arnold theorem的新型神经网络模型，旨在替代传统的前馈神经网络MLP。**KAN**的创新点在于在原本线性方程的基础上加入了spline，并且通过spline的应用替代了原non-linearity激活函数，这样既节省了计算资源，并且在一定数量级的训练上能够更加高效的进行学习。

## 安装

```bash
> pip install pykan
```

如果使用的是独立环境，请用

```bash
> !pip install pykan
```


