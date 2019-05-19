# Panabit App - frpc

## 功能说明

> frp 是一个可用于内网穿透的高性能的反向代理应用，支持 tcp, udp 协议，为 http 和 https 应用协议提供了额外的能力，且尝试性支持了点对点穿透。

将 [frp](https://github.com/fatedier/frp) 客户端打包为 Panabit 应用，通过应用商店即可安装使用。配合 frp 服务端可以实现 Panabit 公网访问功能，或者为内网其他服务提供公网访问，关于 frp 的具体信息可以阅读 [frp 中文文档](https://github.com/fatedier/frp/blob/master/README_zh.md)。

## 版本信息

`PanabitApp-frpc` 包的文件名为 `PanabiApp-frpc_20190503_9_32_0.27.0.apx` 格式，有以下三部分组成：

* `PanabitApp-frpc`

    表示该文件是 Panabit-frpc 应用

* `20190503`

    表示构建日期，**尽量使用最新版本，但并不限制安装版本。**

* `9_32`

    表示支持 FreeBSD 9.x 32位系统，**由于执行文件区分平台，因此不同平台的包无法混用。**
    
* `0.27.0`

    表示使用的 frp 客户端版本，**使用 frp 时需要保证客户端与服务端版本一致**。
    
## 服务端安装

**注意：下载的 frp 版本要与 `PanabitApp-frpc` 中使用的版本一致。**

### 下载 frp 服务端

在 frp Github 发布页面 [https://github.com/fatedier/frp/releases](https://github.com/fatedier/frp/releases) 可以下载编译好的二进制包，下载的版本需要与 Panabit-frpc 使用的版本一致，并根据服务器的平台选择。

以 `PanabiApp-frpc_20190503_9_32_0.27.0.apx` 为例，使用的是 frp 0.27.0 版本的客户端，再根据服务器操作系统来选择。

* Windows

    * 32 位 `frp_0.27.0_windows_amd64.zip`
    * 64 位 `frp_0.27.0_windows_386.zip`
    
* Linux

    * 32 位 `frp_0.27.0_linux_386.tar.gz`
    * 64 位 `frp_0.27.0_linux_amd64.tar.gz`

* FreeBSD

    * 32 位 `frp_0.27.0_freebsd_386.tar.gz`
    * 64 位 `frp_0.27.0_freebsd_amd64.tar.gz`

### 部署 frp 服务端

解压下载的压缩包，在文件夹中可以看到有以下文件：

```
.
├── frpc
├── frpc_full.ini
├── frpc.ini
├── frps
├── frps_full.ini
├── frps.ini
```

`frpc` 是客户端， `frps` 是服务端，对应的 `.ini` 是示例配置文件。根据服务器平台不同，部署方式有差异，请参考对应的 `服务器部署手册.pdf`。

### 配置服务端

**注意：不要使用 Windows 记事本，安装 Notepad++ 、Sublime 或 VSCode 进行编辑。**

* [Notepad++](https://notepad-plus-plus.org/download)
* [VS Code](https://code.visualstudio.com/#alt-downloads)
* [Sublime](https://www.sublimetext.com/3)

以最基本的 `fprs.ini` 文件做为示例：

```ini
[common]
bind_addr = 0.0.0.0
bind_port = 7000
token = 12345678
```

* `bind_addr`

   frp 服务端绑定 ip，如果有多网卡或多 ip 时想单独监听则需要指定。
   
* `bind_port`

    frp 服务端监听端口，默认为 7000，建议修改默认端口，比如：`37000`
    
* `token`

    frp 客户端与服务端鉴权令牌，建议使用密码生成器生成一个高强度密码。
    
    [密码生成器|LastPass](https://1password.com/zh-cn/password-generator/)
    
#### 防火墙设置

本机或云平台防火墙需要开启除了 frp 服务端监听端口之外，还有后续映射使用的端口。具体操作请参考云平台文档，或联系云平台客服。
    
### 配置客户端

假设服务器 ip 为 `192.168.33.100`，后续出现访问方式中出现该 IP 请按自身实际情况修改。

**注意：客户端配置中出现的 `remote_port` 都需要在服务端所在服务器开启防火墙端口，否则无法访问。**

其他配置以 `配置服务端` 内容为基础，那么客户端 `[common]` 节的配置如下：

```ini
[common]
server_addr = 192.168.33.100
server_port = 7000
token = 12345678
```

**`[common]` 是客户端的基本配置节点，只有该节点配置正确才能进行穿透配置。后续添加穿透配置时，要将配置加入到 `[common]` 节点之后。**

打开 PanabitApp-frpc 应用页面，将以上配置信息粘贴到 `fprc 配置` 的文本框中，并通过点击 `上传配置` 按钮上传并应用配置。

如果正常的话，右侧运行状态会显示 `frpc is running as pid xxxxx`，否则会显示 `frpc is not running` 或错误信息。

注意：*可以在本地计算机运行对应的客户端来调试配置，使用 `frpc -c frpc.ini` 或 `./frpc -c frpc.ini` 即可运行客户端程序。*

#### 添加映射穿透端口

需要注意，由于 Panabit 的管理页面功能,SSH 默认配置并非为公网环境设计，不要直接暴露到公网，以免产生安全问题。

关于安全配置，请参考 `安全配置指导手册.pdf` 进行设置。

##### Panabit SSH 端口

**注意：Panabit SSH 默认为 root 用户，并且通过 `panaos` 简单口令登录，直接映射到公网会有安全隐患。**

在配置中添加 `[panabit-ssh]` 节点，并加入以下内容。

```ini
[panabit-ssh]
type = tcp
local_port = 22
local_ip = 127.0.0.1
remote_port = 10022
use_compression = true
```

* `type = tcp`

    表示映射协议为 TCP 协议
    
* `local_port = 22`

    表示映射本地端口为 22
    
* `local_ip = 127.0.0.1`

    表示映射本地的端口，如果运行的服务不是本机，则需要修改 ip 为服务所在 ip。
    
* `remote_port = 10022`

    表示服务端使用 10022 端口映射，最终可以通过 服务器 ip + 100022 访问。
    
* `use_compression`

    可选参数，表示开启压缩，如果产生问题，可以删除。

正常运行的前提下，即可通过 `ssh://192.168.33.100:10022` 登录内网中的 Panabit SSH。

##### Panabit 管理页

在配置中添加 `[panabit-web]` 节点，并加入以下内容。

```ini
[panabit-web]
type = tcp
local_port = 443
local_ip = 127.0.0.1
remote_port = 10443
use_compression = true
```
* `type = tcp`

    表示映射协议为 TCP 协议
    
* `local_port = 443`

    表示映射本地端口为 443
    
* `local_ip = 127.0.0.1`

    表示映射本地的端口，如果运行的服务不是本机，则需要修改 ip 为服务所在 ip。
    
* `remote_port = 10443`

    表示服务端使用 10022 端口映射，最终可以通过 服务器 ip + 10443 访问。
    
正常运行的前提下，即可在浏览器中通过 `https://192.168.33.100:10443` 访问内网中的 Panabit 管理页面。

注意：需要增加 Web 登录密码强度。
    
###### 使用域名访问

frp 支持同端口复用，用子域名区分访问不同 http/https 内网服务。使用该功能有以下前提条件：

* 只支持 http/https 协议
* 需要将域名泛解析到服务端所在服务器

首先将服务端配置修改如下：

```ini
[common]
bind_addr = 0.0.0.0
bind_port = 7000
token = 12345678
subdomain_host = frps.com
vhost_http_port = 20080
vhost_https_port = 20443
```
* `subdomain_host`

    表示使用主域名，需要设置泛解析到服务端所在服务器 IP

* `vhost_https_port`

    表示 https 协议在服务端使用的端口
    
* `vhost_http_port`

    表示 http 协议在服务端使用的端口
    
客户端配置如下：

* Panabit A

```ini
[panabit-web]
type = https
local_port = 443
subdomain = panabit-a
```

* Panabit B

```ini
[panabit-web]
type = https
local_port = 443
subdomain = panabit-b
```

然后可以通过 `https://panabit-a.frps.com:20443` 访问 Panabit A，通过 `https://panabit-b.frps.com:20443` 访问 Panabit B。