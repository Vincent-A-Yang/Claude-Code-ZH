param(
  [string]$Root = (Resolve-Path ".").Path
)

$ErrorActionPreference = "Stop"

$forbiddenNames = @(
  "claude_desktop_config.json",
  ".claude.json",
  ".env",
  ".env.local",
  "settings.local.json"
)

$forbiddenPatterns = @(
  "sk-ant-",
  "ghp_",
  "github_pat_",
  "BEGIN PRIVATE KEY",
  "Authorization: Bearer"
)

$self = $MyInvocation.MyCommand.Path
$files = Get-ChildItem -Path $Root -Recurse -File -Force | Where-Object {
  $_.FullName -notmatch '\\.git\\' -and
  $_.FullName -notmatch '\\node_modules\\' -and
  $_.FullName -ne $self
}

$nameHits = @($files | Where-Object { $forbiddenNames -contains $_.Name } | Select-Object FullName)
$contentHits = @()

foreach ($file in $files) {
  if ($file.Length -gt 2MB) { continue }
  $text = Get-Content -Raw -Path $file.FullName -ErrorAction SilentlyContinue
  foreach ($pattern in $forbiddenPatterns) {
    if ($text -and $text.Contains($pattern)) {
      $contentHits += [pscustomobject]@{ file = $file.FullName; pattern = $pattern }
    }
  }
}

$ok = ($nameHits.Count -eq 0 -and $contentHits.Count -eq 0)
[pscustomobject]@{
  ok = $ok
  checkedFiles = @($files).Count
  forbiddenNameHits = $nameHits
  forbiddenContentHits = $contentHits
} | ConvertTo-Json -Depth 6

if (-not $ok) { exit 1 }
