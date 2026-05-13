param(
  [Parameter(Mandatory=$true)][string]$Source,
  [Parameter(Mandatory=$true)][string]$Destination,
  [switch]$DryRun,
  [switch]$Overwrite
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -Path $Source)) { throw "Source not found: $Source" }
if (-not $DryRun -and -not (Test-Path -Path $Destination)) {
  New-Item -ItemType Directory -Force -Path $Destination | Out-Null
}

$skills = Get-ChildItem -Path $Source -Directory -Force | Where-Object {
  -not (($_.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) -and
  (Test-Path -Path (Join-Path $_.FullName "SKILL.md"))
}

$actions = foreach ($skill in $skills) {
  $target = Join-Path $Destination $skill.Name
  $exists = Test-Path -Path $target
  $action = if ($exists -and -not $Overwrite) { "skip-existing" } elseif ($DryRun) { "would-copy" } else { "copy" }
  if ($action -eq "copy") {
    if ($exists) { Remove-Item -Path $target -Recurse -Force }
    Copy-Item -Path $skill.FullName -Destination $target -Recurse -Force
  }
  [pscustomobject]@{ name = $skill.Name; action = $action; source = $skill.FullName; destination = $target }
}

$destDirs = if (Test-Path -Path $Destination) { Get-ChildItem -Path $Destination -Directory -Force } else { @() }
$junctions = @($destDirs | Where-Object { ($_.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0 })
$missing = @($destDirs | Where-Object { -not (Test-Path -Path (Join-Path $_.FullName "SKILL.md")) })

[pscustomobject]@{
  dryRun = [bool]$DryRun
  source = (Resolve-Path $Source).Path
  destination = $Destination
  considered = @($skills).Count
  actions = $actions
  destinationJunctions = $junctions.Count
  destinationMissingSkillMd = $missing.Count
} | ConvertTo-Json -Depth 6
