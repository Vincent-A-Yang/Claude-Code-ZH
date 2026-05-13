# Claude Code 汉化、优化与第三方模型接入工具箱

这个项目沉淀了一套在 Windows 上维护 Claude Desktop / Claude Code 的可复用流程：

- 汉化 Claude Desktop 中未覆盖的开发者、MCP、扩展、插件和 Claude Code 相关界面文案。
- 将第三方模型网关接入 Claude Desktop / Claude Code，并用日志和接口检查验证可用性。
- 从其他 agent 工作台迁移高价值 MCP / skills，但不复制本机私有配置、token、个人路径或账号数据。
- 用备份、dry-run、协议级 smoke test 和日志检查降低改坏 Claude 的概率。

> 本仓库只提供通用脚本、模板和文档。不要把自己的 `~/.claude.json`、`claude_desktop_config.json`、`.env`、skills 实体包、MCP token 或本机日志提交到 GitHub。

## 适用场景

- Claude Desktop 已安装，但开发者设置界面还有大量英文。
- Claude Code 需要走自建或第三方 Anthropic 兼容网关。
- 需要给 Claude 接入本地 stdio MCP、远程浏览器 MCP、GitHub、Context7、Repomix、Serena 等工具。
- 需要从 Codex、OpenCode、其他 agent 环境迁移经验，但要避免把私有能力和凭据泄露出去。

## 项目结构

```text
.
├─ docs/
│  ├─ i18n.md
│  ├─ mcp-migration.md
│  ├─ third-party-gateway.md
│  └─ verification.md
├─ examples/
│  ├─ claude-desktop-config.example.json
│  ├─ claude-settings.example.json
│  └─ mcp-inventory.example.json
├─ scripts/
│  ├─ Backup-ClaudeConfig.ps1
│  ├─ Patch-ClaudeI18n.ps1
│  ├─ Sync-ClaudeSkills.ps1
│  ├─ Test-ClaudeProjectHygiene.ps1
│  └─ Test-McpServer.ps1
├─ templates/
│  └─ CLAUDE.example.md
└─ translations/
   └─ zh-CN.sample.json
```

## 快速开始

1. 备份 Claude 配置：

```powershell
.\scripts\Backup-ClaudeConfig.ps1 -BackupRoot .\backups
```

2. 用 dry-run 检查汉化补丁会改哪些 JS 文件：

```powershell
.\scripts\Patch-ClaudeI18n.ps1 `
  -ClaudeAppRoot "C:\Path\To\ClaudeApp" `
  -TranslationFile .\translations\zh-CN.sample.json `
  -DryRun
```

3. smoke test 一个 stdio MCP：

```powershell
.\scripts\Test-McpServer.ps1 -Command "cmd" -McpArgs @("/c", "context7-mcp.cmd", "--transport", "stdio")
```

4. dry-run 同步 Claude skills：

```powershell
.\scripts\Sync-ClaudeSkills.ps1 -Source "$HOME\.codex\skills" -Destination "$HOME\.claude\skills" -DryRun
```

5. 发布前检查仓库是否意外包含私有配置：

```powershell
.\scripts\Test-ClaudeProjectHygiene.ps1
```

## 安全原则

- 第三方模型网关 URL、API key、MCP token 全部通过环境变量或本机私有配置保存。
- skills 只同步到本地 Claude，不提交到本仓库。
- MCP 迁移前先分类：本地 stdio、远程依赖、本地 wrapper、云服务、高风险系统工具。
- MCP 可用性以 JSON-RPC `initialize` 和 `tools/list` 为准，不只看“配置里有”。
- 汉化补丁只替换完整字符串字面量，不改变量名、函数名和业务逻辑。

## 参考资料

- Claude Code settings: https://docs.anthropic.com/en/docs/claude-code/settings
- Claude Code MCP: https://code.claude.com/docs/en/mcp
- Claude Desktop Extensions / MCPB: https://claude.com/docs/connectors/building/mcpb
- Claude 3P extensions / MCP / skills: https://claude.com/docs/cowork/3p/extensions

## 状态

这是一个工程化模板项目。不同 Claude Desktop 版本的打包路径和 JS chunk 名称会变化，使用前必须先备份，再 dry-run，再逐步验证。
