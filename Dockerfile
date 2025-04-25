FROM node:6.17.1

WORKDIR /app

# 先复制 package 文件
COPY package.json package-lock.json* ./

# 安装 gulp（全局）
RUN npm install -g gulp@3.9.1

# 安装依赖并跳过 uws 问题
RUN npm install --no-optional

# 再复制全部源码
COPY . .

# 启动时进入 bash，方便你手动运行 gulp
CMD ["bash"]


