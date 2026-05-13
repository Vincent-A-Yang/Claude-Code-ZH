# Security Policy

This project is designed to avoid publishing personal Claude/Codex state.

Do not commit:

- API keys, bearer tokens, cookies, private keys, certificates, OAuth credentials, or `.env` files.
- Real `claude_desktop_config.json`, `.claude.json`, `.mcp.json`, `settings.local.json`, or local MCP configs.
- Real skill directories copied from a private workstation.
- Claude, Codex, browser, gateway, or MCP logs that may contain local paths, prompts, IDs, hostnames, or tokens.
- Hardcoded private gateway URLs. Use placeholders in documentation and environment variables in local config.

Before publishing, run:

```powershell
.\scripts\Test-ClaudeProjectHygiene.ps1
git status --short
```

If a secret was committed, rotate it. Removing it from the latest commit is not sufficient if it was ever pushed.
