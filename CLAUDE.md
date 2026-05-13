# Claude-Code-ZH 项目指令

本仓库是 Claude Desktop / Claude Code 中文化、优化、MCP 迁移和第三方模型网关接入指南。

执行任何任务前先阅读：

1. `AI_AGENT_GUIDE.md`
2. `README.md`
3. 当前任务相关的 `docs/*.md`

默认中文回复。修改用户本机 Claude 配置、安装软件、写入 API key、修改 Claude app 文件、复制 skills、迁移高风险 MCP、重启服务或推送 GitHub 前，必须先确认。

不要读取、输出或提交 secrets、tokens、`.env*`、credentials、private keys、本机真实 Claude 配置、私有 skills、私有 MCP 配置或日志。

修改脚本后运行：

```powershell
.\scripts\Test-ClaudeProjectHygiene.ps1
git diff --check
```
