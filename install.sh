#!/bin/bash

# CalMD 安装脚本
# 将 CalMD 安装为全局命令

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 检查是否为 macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}错误: CalMD 仅支持 macOS 系统${NC}"
    exit 1
fi

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_SCRIPT="$SCRIPT_DIR/export_calendar.sh"

# 检查源脚本是否存在
if [[ ! -f "$SOURCE_SCRIPT" ]]; then
    echo -e "${RED}错误: 找不到 export_calendar.sh 文件${NC}"
    exit 1
fi

# 目标安装路径
INSTALL_DIR="/usr/local/bin"
TARGET_SCRIPT="$INSTALL_DIR/calmd"

echo -e "${BLUE}🚀 开始安装 CalMD...${NC}"

# 检查 /usr/local/bin 是否存在，不存在则创建
if [[ ! -d "$INSTALL_DIR" ]]; then
    echo -e "${YELLOW}创建目录: $INSTALL_DIR${NC}"
    sudo mkdir -p "$INSTALL_DIR"
fi

# 复制脚本到目标位置
echo -e "${YELLOW}复制脚本到: $TARGET_SCRIPT${NC}"
sudo cp "$SOURCE_SCRIPT" "$TARGET_SCRIPT"

# 设置执行权限
echo -e "${YELLOW}设置执行权限${NC}"
sudo chmod +x "$TARGET_SCRIPT"

# 验证安装
if [[ -f "$TARGET_SCRIPT" ]] && [[ -x "$TARGET_SCRIPT" ]]; then
    echo -e "${GREEN}✅ CalMD 安装成功！${NC}"
    echo -e "${GREEN}现在你可以在任何地方使用 'calmd' 命令${NC}"
    echo ""
    echo -e "${BLUE}使用方法:${NC}"
    echo "  calmd                           # 导出今天的日程"
    echo "  calmd 0 7                       # 导出从今天开始7天的日程"
    echo "  calmd -1 1 '测试日历,垃圾邮件'    # 导出昨天的日程，排除指定日历"
    echo ""
    echo -e "${YELLOW}提示: 首次使用时，系统可能会要求授权访问日历应用${NC}"
else
    echo -e "${RED}❌ 安装失败${NC}"
    exit 1
fi