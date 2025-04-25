
# 🏓 Ping-pong 项目 Docker 协作指南

这是一个基于旧版 Node.js 和 Gulp 构建的前端项目。为了确保任何人都能在任何操作系统上快速运行，我们使用 Docker 容器统一开发环境。

---

## ✅ 第一步：安装 Docker

1. 进入官网下载安装适合你系统的版本：  
   👉 https://www.docker.com/products/docker-desktop/

2. 安装完成后，**重启电脑**，并确保 Docker Desktop 正常运行（右下角托盘有 🐳 图标）。

---

## ✅ 第二步：克隆项目并设置换行符（避免 ESLint 报错）

### 1. 设置 Git 换行符风格（只需做一次）

```powershell
git config --global core.autocrlf input
```

> 📌 此设置让 Windows Git 使用 Unix 风格换行符 LF，避免 ESLint 报 "Expected LF but found CRLF"。

### 2. 删除旧项目（如有），重新克隆

```powershell

git clone https://github.com/Alsoing/Ping-pong.git
cd Ping-pong
```

---

## ✅ 第三步：创建 Dockerfile

在项目根目录创建 `Dockerfile`，**文件名必须为 `Dockerfile`，无扩展名**。内容如下：

```Dockerfile
FROM node:6.17.1

WORKDIR /app

COPY package.json package-lock.json* ./

RUN npm install -g gulp@3.9.1
RUN npm install --no-optional

COPY . .

CMD ["bash"]
```

---

## ✅ 第四步：升级 Babel（解决打包报错）

打开 `package.json`，将 Babel 相关依赖版本改为：

```json
"babel-core": "6.26.0",
"babel-preset-es2015": "6.24.1",
"babel-preset-stage-1": "6.24.1"
```

然后删除旧的依赖锁文件：

```powershell
del package-lock.json
```

---

## ✅ 第五步：构建 Docker 镜像（只需一次）

在项目根目录运行：

```powershell
docker build -t pingpong-legacy .
```

成功后你就拥有了一个可复用的镜像。

---

## 🚀 使用方式说明

### ✅ 只运行项目（适合演示 / 不改代码）

```powershell
docker run -it --rm -p 3000:3000 -p 3001:3001 pingpong-legacy
```

容器内运行：

```bash
gulp
```

然后访问浏览器地址：

- 主页面： http://localhost:3000  
- BrowserSync 控制台： http://localhost:3001

---

### ✅ 开发模式（适合实时修改代码）

```powershell
docker run -it --rm -v "${PWD}:/app" -v pingpong_node_modules:/app/node_modules -p 3000:3000 -p 3001:3001 pingpong-legacy
```

容器内第一次运行：

```bash
npm install --no-optional
gulp
```

之后每次运行只需执行：

```bash
gulp
```

即可实时看到修改效果（支持热更新）。

---

## 🛠 常见问题

| 问题 | 解决方法 |
|------|----------|
| ESLint 报换行错误（CRLF） | 设置 `git config --global core.autocrlf input` 并重新 clone |
| 浏览器打不开页面 | 确保使用了 `-p 3000:3000` 并运行了 `gulp`，然后访问 http://localhost:3000 |
| 修改代码无效 | 请确认使用了挂载命令 `-v "${PWD}:/app"` 并使用开发模式 |
| 安装依赖失败 | 请在容器内使用 `npm install --no-optional`，避免 `uws` 相关错误 |

---

## 🎉 就绪！

至此，您已具备完整开发环境，无需本地配置 Node、npm 或 Gulp，协作更加轻松高效！
