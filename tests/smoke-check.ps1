$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$card = Join-Path $root 'dist\casa-luna.js'

& node --check $card
if ($LASTEXITCODE -ne 0) { throw 'JavaScript syntax check failed.' }

$source = Get-Content -Raw $card
$required = @(
  'battery_pack1_voltage',
  'battery_pack2_voltage',
  'battery_pack3_voltage',
  'prefers-reduced-motion',
  '_histInflight',
  '_bgRequest',
  'merged._show_battery2 = false',
  'merged._show_pv_extra = false'
)

foreach ($marker in $required) {
  if (-not $source.Contains($marker)) { throw "Required feature marker missing: $marker" }
}

Write-Host 'Casa Luna smoke check passed.'
