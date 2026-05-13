# 准备清单

## 最小准备

单纯安装、汉化和检查 Claude：

- Windows 10 / 11。
- PowerShell 5.1 或 PowerShell 7。
- Git。
- Node.js 18+。
- Claude Desktop 官方安装包。
- 一个可以回滚的备份目录。

## 第三方模型网关准备

如果要让 Claude Code / Claude Desktop 使用第三方模型，需要额外准备：

- 一个 Anthropic API 兼容网关。
- HTTPS 域名入口。
- API key 或等价认证方式。
- Claude 侧模型别名，例如 `claude-sonnet-4-5`。
- 网关侧模型映射规则。

Docker 不是必需项。只有当你自己部署 NewAPI、LiteLLM、one-api、反代或数据库时，才需要 Docker。

## MCP 准备

按 MCP 类型准备：

- Node MCP：Node.js / npm / npx。
- Python MCP：Python 3.10+ 和对应依赖。
- GitHub MCP：GitHub token，建议最小权限。
- 浏览器 MCP：浏览器或远程 CDP 地址。
- 搜索 MCP：搜索服务 token 或本地服务。
- 系统工具 MCP：明确用户授权和可回滚边界。

## 用户需要提前确认的信息

执行前请让用户确认：

- 是否已经安装 Claude Desktop。
- 是否需要安装 Claude Code。
- 是否只汉化，还是同时接入第三方模型。
- 第三方模型网关 URL、认证方式和模型名。
- 哪些 MCP 允许迁移。
- 哪些工作区目录允许 Claude 访问。
- 是否允许复制 skills。

## 不需要准备的东西

- 不需要把自己的真实 Claude 配置发给别人。
- 不需要把 API key 写进仓库。
- 不需要把整个 Codex / OpenCode skills 目录上传到 GitHub。
- 不需要为了汉化而安装 Docker。
