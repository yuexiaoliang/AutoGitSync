#!/bin/bash

# 配置
remote=${1:-"origin"}
branch=${2:-"master"}

echo -e "开始同步：\n  - 目录: $(pwd)\n  - 远程: $remote\n  - 分支: $branch"

# 拉取远程最新信息，以确保后续比较的准确性
git fetch $remote

# 比较本地的HEAD与远程branch的HEAD，如果不同，则拉取远程修改
if [ "$(git rev-parse HEAD)" != "$(git rev-parse $remote/$branch)" ]; then
  echo -e "\n正在拉取远程修改..."
  git pull $remote $branch
fi

# 检测是否有未暂存的修改。如果有，则添加到暂存区并提交
if ! git diff --quiet; then
  echo -e "\n正在提交本地修改..."
  git add .
  git commit -m "auto commit"
fi

# 再次拉取远程最新信息，防止在本地提交后，远程有新的变化
git fetch $remote

# 检查是否有未push的commit。这里修正了原脚本的比较方式，确保正确获取远程分支的HEAD
if [ "$(git rev-parse HEAD)" != "$(git rev-parse $remote/$branch)" ]; then
  echo -e "\n正在推送本地修改..."
  git push $remote $branch
fi

echo -e "\n同步完成"
