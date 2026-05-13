param(
  [Parameter(Mandatory=$true)][string]$ClaudeAppRoot,
  [Parameter(Mandatory=$true)][string]$TranslationFile,
  [string]$BackupRoot = ".\backups",
  [switch]$DryRun
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -Path $ClaudeAppRoot)) { throw "ClaudeAppRoot not found: $ClaudeAppRoot" }
if (-not (Test-Path -Path $TranslationFile)) { throw "TranslationFile not found: $TranslationFile" }

$map = Get-Content -Raw -Path $TranslationFile | ConvertFrom-Json
$pairs = $map.PSObject.Properties | Where-Object { $_.Name -and $_.Value -and $_.Name -ne $_.Value }
if (@($pairs).Count -eq 0) { throw "No translation pairs found." }

$jsFiles = Get-ChildItem -Path $ClaudeAppRoot -Recurse -File -Include *.js
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backupDir = Join-Path $BackupRoot "claude-i18n-$stamp"
$changed = @()

foreach ($file in $jsFiles) {
  $text = Get-Content -Raw -Path $file.FullName
  $new = $text
  $hits = @()
  foreach ($p in $pairs) {
    $from = [string]$p.Name
    $to = [string]$p.Value
    $quotedDouble = '"' + ($from -replace '\\','\\' -replace '"','\"') + '"'
    $quotedSingle = "'" + ($from -replace '\\','\\' -replace "'","\'") + "'"
    if ($new.Contains($quotedDouble)) {
      $new = $new.Replace($quotedDouble, '"' + ($to -replace '\\','\\' -replace '"','\"') + '"')
      $hits += $from
    }
    if ($new.Contains($quotedSingle)) {
      $new = $new.Replace($quotedSingle, "'" + ($to -replace '\\','\\' -replace "'","\'") + "'")
      $hits += $from
    }
  }
  if ($new -ne $text) {
    $changed += [pscustomobject]@{ file = $file.FullName; replacements = @($hits | Select-Object -Unique) }
    if (-not $DryRun) {
      $relative = Resolve-Path -Path $file.FullName -Relative
      $backupPath = Join-Path $backupDir (($file.FullName -replace '^[A-Za-z]:\\','' -replace '[\\/:*?"<>|]', '_'))
      New-Item -ItemType Directory -Force -Path (Split-Path -Parent $backupPath) | Out-Null
      Copy-Item -Path $file.FullName -Destination $backupPath -Force
      Set-Content -Path $file.FullName -Value $new -Encoding UTF8
      $check = & node --check $file.FullName 2>&1
      if ($LASTEXITCODE -ne 0) {
        Copy-Item -Path $backupPath -Destination $file.FullName -Force
        throw "node --check failed for $($file.FullName). Restored backup. $check"
      }
    }
  }
}

[pscustomobject]@{
  dryRun = [bool]$DryRun
  changedFileCount = @($changed).Count
  changed = $changed
  backupDirectory = if($DryRun -or @($changed).Count -eq 0){ $null } else { (Resolve-Path $backupDir).Path }
} | ConvertTo-Json -Depth 8
