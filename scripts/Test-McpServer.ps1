param(
  [Parameter(Mandatory=$true)][string]$Command,
  [string[]]$McpArgs = @(),
  [hashtable]$Env = @{},
  [int]$TimeoutSeconds = 20
)

$ErrorActionPreference = "Stop"

$psi = [System.Diagnostics.ProcessStartInfo]::new()
$psi.FileName = $Command
foreach ($a in $McpArgs) { [void]$psi.ArgumentList.Add($a) }
$psi.RedirectStandardInput = $true
$psi.RedirectStandardOutput = $true
$psi.RedirectStandardError = $true
$psi.UseShellExecute = $false
$psi.CreateNoWindow = $true
foreach ($k in $Env.Keys) { $psi.Environment[$k] = [string]$Env[$k] }

$proc = [System.Diagnostics.Process]::new()
$proc.StartInfo = $psi

[void]$proc.Start()
$stderrTask = $proc.StandardError.ReadToEndAsync()
$stdoutTask = $null

function Send-JsonLine($obj) {
  $json = $obj | ConvertTo-Json -Depth 20 -Compress
  $proc.StandardInput.WriteLine($json)
  $proc.StandardInput.Flush()
}

function Wait-JsonResponse([int]$Id, [int]$DeadlineMs) {
  $sw = [Diagnostics.Stopwatch]::StartNew()
  while ($sw.ElapsedMilliseconds -lt $DeadlineMs) {
    if ($null -eq $script:stdoutTask) {
      $script:stdoutTask = $proc.StandardOutput.ReadLineAsync()
    }
    if ($script:stdoutTask.Wait(50)) {
      $line = $script:stdoutTask.Result
      $script:stdoutTask = $null
      if ($null -eq $line) { throw "MCP stdout closed before response id=$Id" }
      $trim = $line.Trim()
      if (-not ($trim.StartsWith("{") -or $trim.StartsWith("["))) { continue }
      try {
        $msg = $trim | ConvertFrom-Json -ErrorAction Stop
        if ($msg.id -eq $Id) { return $msg }
      } catch {
        throw "Invalid JSON from MCP stdout: $trim"
      }
    }
    if ($proc.HasExited) { throw "MCP exited before response id=$Id with code $($proc.ExitCode)" }
  }
  throw "Timed out waiting for MCP response id=$Id"
}

try {
  Send-JsonLine @{
    jsonrpc = "2.0"
    id = 1
    method = "initialize"
    params = @{
      protocolVersion = "2024-11-05"
      capabilities = @{}
      clientInfo = @{ name = "claude-maintenance-smoke"; version = "0.1.0" }
    }
  }
  $init = Wait-JsonResponse 1 ($TimeoutSeconds * 1000)
  Send-JsonLine @{ jsonrpc = "2.0"; method = "notifications/initialized"; params = @{} }
  Send-JsonLine @{ jsonrpc = "2.0"; id = 2; method = "tools/list"; params = @{} }
  $tools = Wait-JsonResponse 2 ($TimeoutSeconds * 1000)
  $toolCount = @($tools.result.tools).Count
  [pscustomobject]@{
    ok = $true
    command = $Command
    args = $McpArgs
    serverInfo = $init.result.serverInfo
    toolCount = $toolCount
    stderrTail = @(
      if ($stderrTask.IsCompleted) {
        ($stderrTask.Result -split "`r?`n") | Where-Object { $_ } | Select-Object -Last 20
      }
    )
  } | ConvertTo-Json -Depth 10
} finally {
  if (-not $proc.HasExited) {
    $proc.Kill()
    $proc.WaitForExit(2000) | Out-Null
  }
}
