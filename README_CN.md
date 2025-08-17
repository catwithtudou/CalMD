# CalMD - 日历 Markdown 导出工具

📅 **CalMD** (Calendar to Markdown) 是一个用于从 macOS 日历应用导出日程安排的 Shell 脚本工具，支持自定义时间范围和日历过滤，输出格式化的 Markdown 文本到剪贴板。

[🇨🇳 中文文档](README_CN.md) | [🇺🇸 English](README.md)

## 功能特性

- 📅 **灵活的时间范围**：支持导出指定日期范围的日程
- 🚫 **日历黑名单**：可排除不需要的日历（如生日、节假日等）
- 📝 **Markdown 格式**：输出美观的 Markdown 格式，便于文档编写
- ⏰ **时间排序**：自动按时间顺序排列所有日程
- 📋 **剪贴板集成**：直接复制到剪贴板，方便粘贴使用
- 🔔 **完成通知**：任务完成后显示系统通知
- 📊 **日历标识**：每个事件显示所属日历名称，支持对齐格式

## 系统要求

- macOS 系统
- 日历应用 (Calendar.app)
- Bash Shell

## 文件说明

- `export_calendar.sh` - 主要的导出脚本
- `calendar_data_output.applescript` - AppleScript 版本（可选）

## 使用方法

### 全局命令使用（推荐）

如果你已经通过 `install.sh` 安装了 CalMD，可以直接使用 `calmd` 命令：

```bash
# 导出今天的日程
calmd

# 导出从今天开始7天的日程
calmd 0 7

# 导出昨天的日程
calmd -1 1

# 导出明天开始3天的日程，并排除特定日历
calmd 1 3 "测试日历,垃圾邮件"
```

### 本地脚本使用

如果你选择本地使用方式：

```bash
# 导出今天的日程
./export_calendar.sh

# 导出从今天开始7天的日程
./export_calendar.sh 0 7

# 导出昨天的日程
./export_calendar.sh -1 1

# 导出明天开始3天的日程，并排除特定日历
./export_calendar.sh 1 3 "测试日历,垃圾邮件"
```

### 参数说明

脚本接受三个可选参数：

1. **DAYS_FROM_TODAY** (默认: 0)
   - `0`: 今天
   - `1`: 明天
   - `-1`: 昨天
   - 其他数字: 相对今天的天数

2. **DAY_RANGE** (默认: 1)
   - `1`: 1天
   - `7`: 一周
   - 其他数字: 导出的天数范围

3. **CALENDAR_BLACKLIST** (默认: "生日,节假日,垃圾邮件,个人隐私")
   - 用逗号分隔的日历名称列表
   - 这些日历中的事件将被排除

### 使用示例

```bash
# 导出今天的日程
./export_calendar.sh

# 导出明天的日程
./export_calendar.sh 1 1

# 导出本周的日程（从今天开始的7天）
./export_calendar.sh 0 7

# 导出下周的日程（从明天开始的7天）
./export_calendar.sh 1 7

# 导出昨天的日程
./export_calendar.sh -1 1

# 导出今天的日程，但排除特定日历
./export_calendar.sh 0 1 "工作日历,个人隐私"

# 导出未来3天的日程，不排除任何日历
./export_calendar.sh 0 3 ""
```

## 输出格式

脚本会生成如下格式的 Markdown 文本：

```markdown
**2024年1月15日周一**：

-   **09:00 - 10:00** `[工作日历]`：团队会议
-   **14:00 - 15:30** `[个人日历]`：医生预约
-   **19:00 - 20:00** `[家庭日历]`：晚餐聚会

**2024年1月16日周二**：

-   **10:00 - 11:00** `[工作日历]`：项目评审
```

## 安装和设置

### 方法一：全局安装（推荐）

1. 克隆项目：
   ```bash
   git clone <repository-url>
   cd CalMD
   ```

2. 运行安装脚本：
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

3. 安装完成后，你可以在任何地方使用 `calmd` 命令：
   ```bash
   calmd                           # 导出今天的日程
   calmd 0 7                       # 导出从今天开始7天的日程
   calmd -1 1 '测试日历,垃圾邮件'    # 导出昨天的日程，排除指定日历
   ```

### 方法二：本地使用

1. 下载脚本文件：
   ```bash
   git clone <repository-url>
   cd CalMD
   ```

2. 给脚本添加执行权限：
   ```bash
   chmod +x export_calendar.sh
   ```

3. 首次运行时，macOS 可能会要求授权访问日历应用，请点击"允许"。

## 故障排除

### 常见问题

1. **权限问题**：如果遇到权限错误，请确保：
   - 脚本有执行权限 (`chmod +x export_calendar.sh`)
   - 已授权访问日历应用

2. **编码问题**：如果出现字符编码问题，请确保：
   - 文件使用 UTF-8 编码
   - 没有 BOM 标记

3. **AppleScript 错误**：如果 AppleScript 执行失败：
   - 确保日历应用已安装并可正常使用
   - 检查系统的 AppleScript 权限设置

### 调试模式

如需调试，可以在脚本开头添加 `set -x` 来查看详细执行过程：

```bash
#!/bin/bash
set -x  # 添加这行进行调试
```

## 自定义配置

### 修改默认黑名单

编辑脚本中的默认黑名单设置：

```bash
CALENDAR_BLACKLIST=${3:-"你的默认黑名单1,你的默认黑名单2"}
```

### 修改输出格式

可以修改 AppleScript 部分的 `markdownLine` 变量来自定义输出格式。

## 贡献

欢迎提交 Issue 和 Pull Request 来改进这个工具！

## 许可证

MIT License

## 卸载

如果你通过全局安装方式安装了 CalMD，可以使用卸载脚本移除：

```bash
./uninstall.sh
```

## 更新日志

- **v1.2.0**: 添加了全局安装功能，支持 `calmd` 命令
- **v1.1.0**: 添加了命令行参数支持，可自定义日历黑名单
- **v1.0.0**: 初始版本，支持基本的日历导出功能