---
title: k3s安装记录
date: 2025-09-30 10:35:36
tags:
    - 开发
    - k8s/k3s/docker
    - tips
---

### cURL安装shell脚本

Rancher中国社区给的网址是 **错的**，仓库网址是(https://mirror.rancher.cn/#k3s/)，但实际上真的要获取，应该走的是(https://rancher-mirror.rancher.cn/k3s/k3s-install.sh)。所以实际上需要这么写：

```bash
curl -sfL https://rancher-mirror.rancher.cn/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn sh -
```

1. `curl -sfL`：确保静默下载（`-s`）、失败不报错（`-f`）、自动跟随重定向（`-L`），避免无关输出干扰。
    
2. `INSTALL_K3S_MIRROR=cn`：强制所有资源（二进制文件、镜像）从国内镜像拉取，解决网络问题。
    
3. `sh -`：直接执行脚本，不传递 `--channel` 等可能被误写入服务配置的参数。

当然`-sfL`这三个参数如果没把握应该不加，不然有什么问题都不知道。

| 参数   | 全称           | 作用说明                                                                             | 为什么默认加它？                                                               |
| ---- | ------------ | -------------------------------------------------------------------------------- | ---------------------------------------------------------------------- |
| `-s` | `--silent`   | 静默模式：不输出 `curl` 的进度条、连接信息等 “非关键日志”，只返回目标内容（脚本）。                                  | 避免终端被进度条刷屏，让安装过程更 “干净”，适合 “确认网络没问题” 的常规场景。                             |
| `-f` | `--fail`     | 失败时不返回错误内容：如果请求失败（如 404、500 错误、网络超时），`curl` 直接退出，不把错误页面（如 HTML 错误页）传给后面的 `sh -`。 | 防止 “错误页面被当作脚本执行”—— 比如链接失效时，`curl` 若不 `-f`，会把 404 页面传给 `sh`，导致执行一堆乱码报错。 |
| `-L` | `--location` | 自动跟随重定向：如果目标 URL 被重定向（比如官方换了脚本地址），`curl` 会自动跳转到新地址下载。                            | 适配 k3s 官方可能的 URL 变更，避免 “因为重定向导致下载失败”，提高命令兼容性。                          |

#### 管道的作用

- 管道前：下载脚本，输出脚本的文本内容
- 管道后：接收文本内容，`sh -`代表让新的shell从标准输入里获取执行的命令，`INSTALL_K3S_MIRROR`是给新的shell设定的临时环境变量（再脚本中有识别分支），用于强制指定从国内下载。

#### 出现的问题及解决

- 在安装的时候输入的指令是`curl -sfL https://rancher-mirror.rancher.cn/k3s/k3s-install.sh | sh -s - --channel stable`，其中`-s`让shell从标准输入获取脚本内容，同时也接收了后续的命令行参数，所以导致`--channel stable`被误写入脚本。

___
### 修改镜像源

在`/etc/rancher/k3c`目录下新建`registries.yaml`文件，然后在文件中按照官方实例填写，如下：

```yaml
mirrors:
  docker.io:
    endpoint:
      - "你的镜像加速源（带https://)"  # 阿里云腾讯云可在控制台申请，或者购买轩辕镜像

configs:
  "你的镜像加速元":  # 注意：官方示例中此处无需带 https://（关键修正！）
    auth: {}       # 轩辕镜像免登录
    tls:
      insecure_skip_verify: false
```

然后`systemctl restart k3c`进行重启，使`/var/lib/rancher/k3s/agent/etc/containerd`下的`config.toml`得到更新（加入新的镜像源），同时使`/var/lib/rancher/k3s/agent/etc/containerd/certs.d/docker.io`中的`hosts.toml`加入了新的镜像源。


 
