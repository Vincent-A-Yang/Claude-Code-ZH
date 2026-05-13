# MCP 迁移与验证

## 分类

迁移前先确认 MCP 属于哪类：

- 本地 stdio：直接由本机命令启动，例如 `cmd /c some-mcp.cmd --transport stdio`。
- 本地 wrapper + 远程依赖：本地 MCP 进程依赖远程浏览器、搜索服务或 SSH 转发。
- 云服务：依赖 GitHub、搜索 API、SaaS token 或组织账号权限。
- 高风险系统工具：能读写文件、控制浏览器、执行命令、签名身份或改账号状态。
- 不适合迁移：Codex-only、协议不兼容、启动慢、权限面过大或 smoke test 失败。

## Claude 配置注意事项

Claude Desktop / Claude Code 的 MCP JSON 通常只需要：

```json
{
  "command": "cmd",
  "args": ["/c", "example-mcp.cmd", "--transport", "stdio"],
  "env": {
    "EXAMPLE_TOKEN": "${EXAMPLE_TOKEN}"
  }
}
```

不要直接复制其他工具里的超时、approval、sandbox 或 Codex-only 字段。

## Windows 命令包装

在 Windows 上，Node/npm 安装的 MCP 经常以 `.cmd` 入口存在。为了让 GUI app 稳定启动，优先使用：

```json
{
  "command": "cmd",
  "args": ["/c", "package-entry.cmd", "--transport", "stdio"]
}
```

如果 MCP 在 stdout 输出非 JSON 启动横幅，需要写一个 wrapper，把非 JSON 行转到 stderr，否则 Claude 可能报 `Unexpected token`。

## 验证标准

最低验证不是“配置文件里有”，而是协议级：

1. 启动进程。
2. 发送 JSON-RPC `initialize`。
3. 发送 `notifications/initialized`。
4. 发送 `tools/list`。
5. 确认没有 stderr 致命错误和进程提前退出。

运行：

```powershell
.\scripts\Test-McpServer.ps1 -Command "cmd" -McpArgs @("/c", "context7-mcp.cmd", "--transport", "stdio")
```

## Claude 日志检查

重启 Claude 后，检查 MCP 日志中每个 server 是否有：

- `Server started and connected successfully`
- `serverInfo`
- `tools`

同时确认没有：

- `Server disconnected`
- `Unexpected token`
- `ENOENT`
- `ModuleNotFound`
- `Traceback`
