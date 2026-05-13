# 第三方模型网关接入

## 目标

让 Claude Desktop / Claude Code 通过 Anthropic 兼容网关访问自建或第三方模型，同时保持 Claude 侧配置稳定、可诊断、可回滚。

## 基本要求

- 使用 HTTPS 域名，不建议在 Claude 里写裸 IP HTTPS 地址。
- Base URL 是否带 `/v1` 取决于 Claude 当前配置页面和网关实现，必须用实际请求验证，避免出现 `/v1/v1/models`。
- Claude 侧模型名可以是 Anthropic 风格别名，由网关映射到真实模型。
- API key 不写进仓库，用环境变量或本机私有配置。

## 验证请求

无 key 时应返回 `401` 或等价未授权错误：

```powershell
curl.exe https://gateway.example.com/v1/models
```

带 key 时应返回模型列表：

```powershell
curl.exe https://gateway.example.com/v1/models `
  -H "x-api-key: $env:ANTHROPIC_API_KEY"
```

非流式 messages：

```powershell
curl.exe https://gateway.example.com/v1/messages `
  -H "content-type: application/json" `
  -H "x-api-key: $env:ANTHROPIC_API_KEY" `
  -H "anthropic-version: 2023-06-01" `
  -d '{"model":"claude-sonnet-4-5","max_tokens":32,"messages":[{"role":"user","content":"ping"}]}'
```

流式 messages 也应单独验证，因为 UI 和 Claude Code 可能走不同路径。

## 日志判断

Claude 主日志里期望看到：

```text
ConfigHealth recomputed { state: 'healthy', provider: 'gateway' }
```

不应出现：

- `baseUrl must use https`
- `/v1/v1/models`
- `not an Anthropic model`
- 网关 TLS hostname 校验错误

## 不放进仓库的内容

- 真实 gateway hostname。
- 真实 API key。
- 真实模型映射表，如果它暴露私有服务结构。
- 任何本地 Claude 日志和截图中包含的 token 或账号信息。
