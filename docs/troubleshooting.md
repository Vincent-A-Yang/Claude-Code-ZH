# 常见故障排查

## MCP server disconnected

优先检查：

1. MCP 命令在普通终端能否启动。
2. 是否需要通过 `cmd /c xxx.cmd` 启动。
3. stdout 是否输出了非 JSON 横幅。
4. GUI app 是否拿不到环境变量。
5. Python / Node 依赖是否装在错误版本里。
6. 远程浏览器、搜索服务、Docker 服务是否可达。

用本仓库脚本测试：

```powershell
.\scripts\Test-McpServer.ps1 -Command "cmd" -McpArgs @("/c", "your-mcp.cmd")
```

## Unexpected token

通常是 MCP 在 stdout 输出了日志，例如：

```text
Starting server...
```

MCP stdio 的 stdout 应只输出 JSON-RPC。解决方式：

- 查 MCP 是否支持 quiet / silent 参数。
- 写 wrapper，把非 JSON 行转到 stderr。
- 不要把这个 MCP 写入 Claude，直到 smoke test 通过。

## Claude 网关不健康

检查：

- base URL 是否 HTTPS。
- 是否多写或少写 `/v1`。
- 模型名是否被网关映射。
- API key 是否传入 Claude。
- `/v1/models` 和 `/v1/messages` 是否分别可用。

## 汉化后 Claude 打不开

立刻恢复备份。常见原因：

- 替换了非字符串逻辑。
- 引号或转义破坏 JS。
- 修改了错误 chunk。
- 未运行 `node --check`。

## Skills 没识别

检查：

- 是否真实目录，不是快捷方式或 junction。
- 是否每个目录都有 `SKILL.md`。
- frontmatter 是否有唯一 `name`。
- 是否复制了测试 fixture 或重复 skills。
