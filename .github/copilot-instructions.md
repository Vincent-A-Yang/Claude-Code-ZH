# Copilot / AI Agent Instructions

This repository is Chinese-first. Reply in Chinese unless the user asks otherwise.

Before acting, read:

- `AI_AGENT_GUIDE.md`
- `README.md`
- The relevant file under `docs/`

Never commit real Claude/Codex configs, private skills, MCP tokens, logs, gateway hostnames, `.env*`, credentials, or private keys.

Ask the user before installing software, modifying Claude app files, writing API keys, changing Claude config, migrating high-risk MCP servers, copying large skill trees, restarting Claude, or pushing to GitHub.

After edits, run the relevant validation:

```powershell
.\scripts\Test-ClaudeProjectHygiene.ps1
git diff --check
```
