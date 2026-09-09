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
  '_navViews',
  'nav_custom1_enabled',
  'nav_custom2_enabled',
  'merged._show_battery2 = false',
  'merged._show_pv_extra = false',
  '_populateDemoEntities',
  '_demoEntityId',
  "const objectId = parts.length > 1",
  'DEFAULT_TEXT_OVERRIDES',
  'VIEW_TEXT_DEFAULTS',
  'custom:slider-button-card',
  'light1_card_type',
  'Slider Light Cards',
  'id="dc12Gauge"',
  'boolConfigValue',
  'const showPhaseCard = c._show_phase !== false',
  'id="phaseFlip"',
  '12V current gauge stays visible',
  'dcPhaseBatteryV',
  "isDay ? sun.rise : sun.set",
  'text_overrides',
  'AC 3-Phase Monitor',
  'Start Here',
  'dc12_max_current',
  'label_grid_indicator',
  'Left-navigation detail panels are standalone cards'
)

foreach ($marker in $required) {
  if (-not $source.Contains($marker)) { throw "Required feature marker missing: $marker" }
}

$forbidden = @(
  'id="dc12System"',
  "switchRow('dc12_enabled'",
  'label_inv_title',
  'id="tpRing"',
  'id="tpSvg"',
  'id="invRowP"',
  'id="invRowV"',
  'border-left:none'
)

foreach ($marker in $forbidden) {
  if ($source.Contains($marker)) { throw "Obsolete feature marker is still present: $marker" }
}

Write-Host 'Casa Luna smoke check passed.'
