#!/bin/bash

# 创建新的博客文章脚本
# 用法: ./scripts/create-post.sh [filename] [category]
# 或者: npm run new-post [filename] [category]

# 默认值
DEFAULT_CATEGORY="tech"
BLOG_DIR="src/data/blog"

# 获取参数
FILENAME=$1
CATEGORY=${2:-$DEFAULT_CATEGORY}

# 确保分类前面有下划线（如果用户没有输入下划线的话）
if [[ ! "$CATEGORY" == _* ]]; then
    CATEGORY="_${CATEGORY}"
fi

# 检查是否提供了文件名
if [ -z "$FILENAME" ]; then
    echo "❌ 错误: 请提供文件名"
    echo "用法: ./scripts/create-post.sh [filename] [category]"
    echo "示例: ./scripts/create-post.sh my-new-post tech"
    echo "可用分类: tech, jazz, others (脚本会自动添加下划线前缀)"
    exit 1
fi

# 确保文件名以 .md 结尾
if [[ ! "$FILENAME" == *.md ]]; then
    FILENAME="${FILENAME}.md"
fi

# 创建完整路径
FULL_PATH="${BLOG_DIR}/${CATEGORY}/${FILENAME}"

# 检查文件是否已存在
if [ -f "$FULL_PATH" ]; then
    echo "❌ 错误: 文件 $FULL_PATH 已存在"
    exit 1
fi

# 创建目录（如果不存在）
mkdir -p "${BLOG_DIR}/${CATEGORY}"

# 获取当前时间（ISO 8601 格式）
CURRENT_TIME=$(date -u "+%Y-%m-%dT%H:%M:%S.000Z")

# 创建文件内容
cat > "$FULL_PATH" << EOF
---
author: Brian Hu
pubDatetime: $CURRENT_TIME
title: ""
featured: false
draft: true
tags:
  - 
ogImage: ""
description: ""
---

## 写在这里

你的内容...
EOF

echo "✅ 成功创建文件: $FULL_PATH"
echo "📝 请编辑以下字段:"
echo "   - title: 文章标题"
echo "   - tags: 文章标签"
echo "   - description: 文章描述"
echo "   - draft: 完成后改为 false"
echo ""
echo "🎯 当你准备发布时，将 draft 设为 false，pre-commit 钩子会自动处理时间戳。"

# 如果在 VS Code 环境中，尝试打开文件
if command -v code &> /dev/null; then
    code "$FULL_PATH"
fi
