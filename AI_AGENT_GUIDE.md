# AI Agent 执行指南

本文件是给 AI 编程工具、桌面自动化工具和运维 agent 看的。用户把本仓库链接发给你时，请按这里执行，不要直接照搬你自己的默认习惯。

## 目标

帮助用户完成 Claude Desktop / Claude Code 的安装、中文化、优化、第三方模型网关接入、MCP 迁移、skills 同步和验证。

完成标准不是“配置写进去了”，而是：

- 关键配置有备份。
- JSON / JS / TOML 等格式通过解析或语法检查。
- MCP 通过协议级 `initialize` 和 `tools/list`。
- Claude 重启后日志没有新增断线或致命错误。
- 用户的 secrets、私有 skills、私有 MCP 配置没有被上传或泄露。

## 必须先问用户的步骤

遇到以下动作，必须先暂停并向用户确认：

- 安装或卸载 Claude Desktop / Claude Code / GitHub CLI / Node / Docker 等软件。
- 修改 Claude app 安装目录中的 JS / asar / chunk 文件。
- 写入或覆盖 `~/.claude.json`、`claude_desktop_config.json`、`settings.json`、`.mcp.json`。
- 配置第三方模型网关、API key、base URL、模型别名。
- 迁移能执行命令、读写文件、控制浏览器、访问 GitHub、签名身份或访问云服务的 MCP。
- 复制大量 skills 到 Claude。
- 删除、覆盖、重命名已有配置或 skills。
- 重启 Claude、停止服务、启动 Docker、修改网络入口。
- 创建、重命名或推送 GitHub 仓库。

如果用户已经明确授权当前批次动作，可以继续，但仍要在高风险点前说明范围和回滚方式。

## 禁止行为

- 不读取、输出或提交 `.env*`、token、cookie、private key、credential、secrets。
- 不把用户本机真实 skills、MCP 配置、Claude 配置、日志或内网地址提交到 GitHub。
- 不把失败的 MCP 写进正式 Claude 配置。
- 不把 Windows junction / shortcut 当成 Claude skills。
- 不在没有备份时修改 Claude app 文件。
- 不用变量名级替换做汉化，只替换完整字符串字面量。

## 建议执行顺序

1. 读取 `README.md`、`docs/preparation.md`、`docs/install-claude.md`。
2. 盘点当前环境：Claude 是否安装、Claude Code 是否安装、Node/Git/PowerShell 是否可用。
3. 运行或等价执行 `scripts/Backup-ClaudeConfig.ps1`。
4. 如果要接入第三方模型，按 `docs/third-party-gateway.md` 验证 HTTPS、`/v1/models`、`/v1/messages`。
5. 如果要迁移 MCP，先做 inventory，再用 `scripts/Test-McpServer.ps1` 逐个 smoke test。
6. 如果要同步 skills，用 `scripts/Sync-ClaudeSkills.ps1 -DryRun`，确认没有 junction、缺失 `SKILL.md` 或重复项。
7. 如果要汉化，先 dry-run `scripts/Patch-ClaudeI18n.ps1`，再应用，之后对修改的 JS 跑 `node --check`。
8. 重启 Claude，检查日志。
9. 运行 `scripts/Test-ClaudeProjectHygiene.ps1`，确认没有私有内容进入项目。
10. 向用户报告做了什么、验证了什么、还剩什么。

## 关键确认问题模板

第三方模型：

```text
请确认：Claude 侧要使用哪个 HTTPS base URL？是否需要带 /v1？模型名在 Claude 侧显示为什么？API key 通过哪个环境变量提供？
```

MCP：

```text
这个 MCP 会获得哪些权限？是否允许我把它写入 Claude 配置？我会先单独 smoke test，失败则不写入正式配置。
```

skills：

```text
是否允许我把这些 skills 复制为真实目录到 Claude skills 目录？我不会使用快捷方式或 junction，并会检查重复项。
```

汉化：

```text
是否允许我修改 Claude app 的 JS 文件？我会先备份，dry-run 命中字符串，应用后执行 node --check。
```

发布：

```text
是否允许我创建或推送 GitHub 仓库？推送前我会运行敏感信息检查，不上传真实配置、skills、MCP token 或日志。
```

## 验证输出要求

报告时至少说明：

- 修改了哪些文件或配置面。
- 备份放在哪里。
- 哪些命令验证通过。
- 哪些 MCP 已通过 `tools/list`。
- 哪些动作没有做，原因是什么。
