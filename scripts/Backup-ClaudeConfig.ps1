param(
  [string]$BackupRoot = ".\backups",
  [string[]]$Paths = @(
    "$env:USERPROFILE\.claude.json",
    "$env:APPDATA\Claude\claude_desktop_config.json",
    "$env:LOCALAPPDATA\Claude-3p\claude_desktop_config.json",
    "$env:USERPROFILE\.claude\settings.json",
    "$env:USERPROFILE\.claude\CLAUDE.md"
  )
)

$ErrorActionPreference = "Stop"
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$dest = Join-Path $BackupRoot "claude-config-$stamp"
New-Item -ItemType Directory -Force -Path $dest | Out-Null

$copied = @()
foreach ($path in $Paths) {
  if (Test-Path -Path $path) {
    $item = Get-Item -Path $path -Force
    $safeName = ($item.FullName -replace '^[A-Za-z]:\\','' -replace '[\\/:*?"<>|]', '_')
    $target = Join-Path $dest $safeName
    if ($item.PSIsContainer) {
      Copy-Item -Path $item.FullName -Destination $target -Recurse -Force
    } else {
      New-Item -ItemType Directory -Force -Path (Split-Path -Parent $target) | Out-Null
      Copy-Item -Path $item.FullName -Destination $target -Force
    }
    $copied += $item.FullName
  }
}

[pscustomobject]@{
  BackupDirectory = (Resolve-Path $dest).Path
  CopiedCount = $copied.Count
  Copied = $copied
} | ConvertTo-Json -Depth 4
