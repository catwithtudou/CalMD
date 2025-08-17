#!/bin/bash

# CalMD 卸载脚本
# 从系统中移除 CalMD 全局命令

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 目标文件路径
TARGET_SCRIPT="/usr/local/bin/calmd"

echo -e "${BLUE}🗑️  开始卸载 CalMD...${NC}"

# 检查文件是否存在
if [[ ! -f "$TARGET_SCRIPT" ]]; then
    echo -e "${YELLOW}CalMD 未安装或已被移除${NC}"
    exit 0
fi

# 移除文件
echo -e "${YELLOW}移除文件: $TARGET_SCRIPT${NC}"
sudo rm -f "$TARGET_SCRIPT"

# 验证卸载
if [[ ! -f "$TARGET_SCRIPT" ]]; then
    echo -e "${GREEN}✅ CalMD 卸载成功！${NC}"
else
    echo -e "${RED}❌ 卸载失败${NC}"
    exit 1
fi