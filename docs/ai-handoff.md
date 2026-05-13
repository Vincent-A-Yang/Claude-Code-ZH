# 把项目交给任意 AI 工具时怎么说

复制下面这段给 AI 工具：

```text
这是我要使用的项目链接：<填入 Claude-Code-ZH 仓库链接>

请先阅读 README.md、AI_AGENT_GUIDE.md、AGENTS.md 和 docs/preparation.md。你的任务是帮我配置 Claude Desktop / Claude Code：检查安装状态、备份配置、按需安装 Claude Code、汉化界面、配置第三方模型网关、迁移可验证 MCP、复制可用 skills，并做验证。

要求：
1. 默认中文回复。
2. 每个高风险步骤先询问我，包括安装软件、写配置、写 API key、修改 Claude app 文件、复制大量 skills、迁移高风险 MCP、重启 Claude、推送 GitHub。
3. 不读取、不输出、不提交 secrets、tokens、.env、credentials、private keys。
4. 所有配置修改前先备份，修改后验证。
5. MCP 必须通过 initialize 和 tools/list，不通过就不要写入正式配置。
6. 汉化只能替换完整字符串字面量，修改后执行 node --check。
7. 最后告诉我做了什么、备份在哪里、验证结果是什么、还有什么没做。
```

如果 AI 工具不能联网，让它先使用本地仓库内容；如果它能联网，让它同时打开官方 Claude 文档确认当前安装和配置方式。
