# AGENTS.md

本仓库用于 Claude Desktop / Claude Code 中文化、优化和第三方模型接入。

所有 AI agent 进入本仓库后，必须先阅读：

1. `AI_AGENT_GUIDE.md`
2. `README.md`
3. 与当前任务相关的 `docs/*.md`

默认使用中文回复。执行前保护用户隐私，不提交本地真实配置、skills、MCP token、日志、截图或内网地址。

修改脚本后运行：

```powershell
Get-ChildItem .\scripts -Filter *.ps1 | ForEach-Object {
  $tokens=$null; $errs=$null
  $null=[System.Management.Automation.Language.Parser]::ParseFile($_.FullName,[ref]$tokens,[ref]$errs)
  if($errs){ throw "$($_.Name): $($errs[0].Message)" }
}
.\scripts\Test-ClaudeProjectHygiene.ps1
git diff --check
```
