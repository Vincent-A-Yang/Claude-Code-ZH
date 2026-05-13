# 验证清单

## 修改前

- 目标文件已备份。
- 目标路径确实是当前 Claude Desktop 使用的路径。
- 没有把真实配置复制到仓库。
- dry-run 输出符合预期。

## 汉化后

- 所有修改过的 `.js` 文件通过 `node --check`。
- Claude 能正常启动。
- 目标页面能打开。
- 关键按钮和输入框仍可操作。
- 日志没有新增语法错误或 renderer 崩溃。

## MCP 后

- 每个 MCP 都通过 `initialize` 和 `tools/list`。
- Claude 重启后 `mcp.log` 没有断线和错误。
- 高风险 MCP 的权限范围已明确。
- 失败 MCP 不进入正式配置。

## 第三方模型后

- `/v1/models` 无 key 返回未授权。
- `/v1/models` 带 key 返回 200。
- `/v1/messages` 非流式可用。
- `/v1/messages` 流式可用。
- Claude 日志显示 gateway health 为 healthy。

## 发布前

```powershell
.\scripts\Test-ClaudeProjectHygiene.ps1
git status --short
git diff --check
```

确认没有：

- 私有 URL。
- 私有 key。
- 本地 Claude/Codex config。
- 本地 skills 内容。
- 日志、备份、截图或缓存。
