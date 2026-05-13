# 安装 Claude Desktop / Claude Code

## Claude Desktop

1. 打开官方下载页：[https://claude.com/download](https://claude.com/download)
2. 下载 Windows 版本。
3. 使用官方安装器安装。
4. 启动 Claude Desktop，完成登录或第三方模型配置前置步骤。
5. 如果要使用开发者设置、MCP、extensions 或 Claude Code tab，请在 Claude 的设置中确认相关入口已经可见。

不要用来源不明的重打包安装器覆盖官方版本。汉化和优化应建立在可验证的官方安装基础上。

## Claude Code

Claude Code 的安装方式会随官方版本变化。请以官方文档为准：

- Claude Code 文档：[https://docs.anthropic.com/en/docs/claude-code](https://docs.anthropic.com/en/docs/claude-code)
- Claude Code settings：[https://docs.anthropic.com/en/docs/claude-code/settings](https://docs.anthropic.com/en/docs/claude-code/settings)
- Claude Code MCP：[https://docs.anthropic.com/en/docs/claude-code/mcp](https://docs.anthropic.com/en/docs/claude-code/mcp)

安装后建议检查：

```powershell
claude --version
```

如果命令不存在：

- 重新打开终端，刷新 PATH。
- 检查 Claude Code 是否安装在当前用户可访问路径。
- 回到官方文档确认当前推荐安装命令。

## 安装后第一轮检查

```powershell
git --version
node --version
npm --version
claude --version
```

如果后续需要 GitHub 自动化：

```powershell
gh --version
gh auth status
```

如果 `gh` 不是官方 GitHub CLI，或命令输出异常，请安装官方 GitHub CLI：

```powershell
winget install --id GitHub.cli -e
```

## 常见问题

### Claude Desktop 提示必须用现代安装器

优先重新安装官方 Claude Desktop。不要继续修补旧安装目录，因为扩展、MCP 和开发者设置可能依赖官方安装形态。

### Claude Code 命令能运行但 Desktop 里不可见

检查 Claude Desktop 的开发者设置中是否允许 Claude Code tab。不同版本入口可能不同，先看当前 UI 和日志，不要直接改配置。

### 安装后 MCP 不启动

先用本仓库的 `scripts/Test-McpServer.ps1` 单独测试 MCP 命令。单独测试失败时，不要写入 Claude 配置。
