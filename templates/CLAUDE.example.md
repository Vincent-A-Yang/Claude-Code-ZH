# Claude 工作规则模板

请默认使用中文回复。

## 修改前

- 先确认当前文件和配置路径，不要凭记忆修改。
- 修改配置前先备份。
- 不读取或输出 `.env*`、`secrets/**`、token、credential、private key。

## 修改中

- Windows 路径使用 PowerShell 兼容写法。
- 优先做最小可逆改动。
- 不把 Codex、OpenCode 或其他工具的私有配置原样复制到 Claude。

## 修改后

- 对 JSON 做解析验证。
- 对 JS 做 `node --check`。
- 对 MCP 做 `initialize` 和 `tools/list` smoke test。
- 对 Claude Desktop 检查日志，不只看界面是否出现。
