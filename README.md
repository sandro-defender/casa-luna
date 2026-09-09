# Casa Luna

Casa Luna is a full-screen Home Assistant Lovelace dashboard for a wall-mounted tablet. It combines solar production, grid use, one battery system, three battery-pack voltage readings, weather, and home controls in a single custom card.

The card is a standalone JavaScript module: no Node.js build or additional runtime dependencies are required.

## Highlights

- One PV input with live power and voltage.
- One battery system with SOC, power, current, voltage, capacity, temperatures, and cell-voltage health.
- Three individual battery-pack voltage sensors, visible in the Battery view and the battery tile’s reverse side.
- Grid and inverter monitoring, optional three-phase/inverter flip tile, energy-history charts, weather-aware backgrounds, cameras, smart plugs, climate, lighting, security, and automations.
- A visual editor for entity selection, labels, visibility, thresholds, and theme settings.
- Live Home Assistant updates with cached history requests, throttled auto-discovery, keyboard operation, visible focus, and reduced-motion support.

## Installation

### HACS custom repository

1. In Home Assistant, open **HACS** → **⋮** → **Custom repositories**.
2. Add `https://github.com/sandro-defender/casa-luna` as a **Dashboard** repository.
3. Download Casa Luna from HACS.
4. Add the card to a panel dashboard:

```yaml
type: custom:casa-luna
```

HACS registers the JavaScript resource automatically.

### Manual installation

Copy the contents of `dist/` to `/config/www/community/casa-luna/`, then add this resource in **Settings → Dashboards → Resources**:

```yaml
url: /local/community/casa-luna/casa-luna.js
type: module
```

Add the card in panel mode:

```yaml
type: custom:casa-luna
```

The sky images must stay in `/config/www/community/casa-luna/sky/`.

## Basic configuration

Open the card editor and select your Home Assistant entities. The main dashboard uses these essential fields:

```yaml
type: custom:casa-luna
pv1_power: sensor.solar_power
pv1_voltage: sensor.solar_voltage
battery_soc: sensor.battery_soc
battery_power: sensor.battery_power
battery_current: sensor.battery_current
battery_voltage: sensor.battery_voltage
battery_pack1_voltage: sensor.battery_pack_1_voltage
battery_pack2_voltage: sensor.battery_pack_2_voltage
battery_pack3_voltage: sensor.battery_pack_3_voltage
grid_active_power: sensor.grid_power
consump: sensor.house_power
weather_entity: weather.home
wled_entity: light.wled_strip
wled_name: Living Room LEDs
dc12_solar_voltage: sensor.dc_solar_voltage
dc12_supply_voltage: sensor.dc_power_supply_voltage
dc12_battery_voltage: sensor.dc_battery_voltage
dc12_current: sensor.dc_current
```

All entity fields are optional. Empty fields render as `--` or hide the related optional tile.

Every entity row in the visual editor includes a **Display Title** field. Use it to rename the entity anywhere it appears in Casa Luna’s reusable view tiles, controls, and popups.

## Edit all card text in YAML

Use `text_overrides` to replace the built-in dashboard captions in one searchable YAML block. The card keeps the current text unless you change a value. Entity-specific names remain in `title_<field>` or `label_<field>`.

```yaml
text_overrides:
  HEADER_SUBTITLE: "ENERGY • AUTOMATION • SECURITY • by the Khan"
  DASHBOARD: "DASHBOARD"
  ENERGY: "ENERGY"
  BATTERY: "BATTERY"
  SECURITY: "SECURITY"
  LIGHTING: "LIGHTING"
  "Production & Flow": "Production & Flow"
  "TODAY'S CONSUMPTION": "TODAY'S CONSUMPTION"
  "TODAY'S PRODUCTION": "TODAY'S PRODUCTION"
  "RECENT EVENTS": "RECENT EVENTS"
  "GRID PHASES": "GRID PHASES"
  "DC CURRENT": "DC CURRENT"
```

The full starter map is included automatically in a new card’s defaults and is written to the WallPanel configuration. It covers dashboard labels, section headings, control captions, buttons, and the main-card text. Keep the left-hand text exactly as shown; replace only the value on the right. You can also add a missing visible caption as a new key using its current text.

## WLED

Set `wled_entity` to your WLED `light.*` entity in the **Lighting View** editor. It uses your installed `custom:slider-button-card` with the same compact gradient-slider configuration shown below. `wled_name` changes the displayed name.

For multiple WLEDs, select any Light or Extra Light entity in the Lighting View and set its **card type** to **Slider button card (WLED)**. You can use this for two, three, or more WLED entities; normal lights can remain Casa Luna light tiles.

## Left navigation and custom cards

The editor’s **Left Navigation** section lets you show or hide each built-in left-side card. It also includes **Custom Card 1** and **Custom Card 2**. Enable either card, set its title, subtitle, and icon, then add a comma-separated list of Home Assistant entity IDs. The custom card opens a live list of those entities.

Available custom icon names: `gear`, `home`, `bolt`, `plug`, `batt`, `therm`, `shield`, `bulb`, `sun`, `pump`, `irrig`, and `warn`.

## Separate 12V DC system

The lower-right **12V DC System** indicator shows DC current in amps and fills as the current approaches its configured maximum. The Grid Phases card rotates: its front shows grid L1–L3 power and voltage, while its reverse side shows your separate 12V readings. Configure these sensors in the editor:

- `dc12_solar_voltage`
- `dc12_supply_voltage`
- `dc12_battery_voltage`
- `dc12_current`
- `dc12_power` (optional; shown as the gauge status line)

This system is separate from your 220V/AC monitoring. The editor lets you rename the 12V system, each sensor label, and the current gauge; set its maximum current for the gauge scale. The top grid indicator uses `grid_active_power` and has its own editable label and maximum-power scale in the Grid section. The pre-change module is preserved as `dist/casa-luna.backup.js`.

## Editor layout and demo mode

The editor begins with **Start Here** and keeps the most common sections clear: **12V DC System**, **Main Energy**, **Grid Phases**, and **Battery**. Optional AC-source L1/L2/L3 sensors remain available for AC load and flow calculations.

Demo Mode now creates safe, local mock entities for all empty card slots, including navigation views, lights, security, controls, battery packs, and 12V readings. Existing configured entities continue to show their real state, and demo controls never send commands to real devices.

## Battery packs

Casa Luna supports one battery system with up to three pack-voltage sensors:

- `battery_pack1_voltage`
- `battery_pack2_voltage`
- `battery_pack3_voltage`

They appear under **Battery View → Pack Voltages**. The reverse side of the main battery-stat tile shows the same three values. Optional `bat_pack1_voltage`, `bat_pack2_voltage`, and `bat_pack3_voltage` editor fields override the corresponding main sensor only inside the Battery view.

## Solar input

The card uses one PV input:

- `pv1_power`
- `pv1_voltage`

`pv_total_power` remains available as a fallback for charts and flow calculations when `pv1_power` is not configured.

## Notes

- Battery sign convention: by default, positive battery power means discharging and negative means charging. Enable `invert_battery_power` if your sensor is reversed.
- Power entities in W, kW, or MW are normalized internally.
- The layout is designed for a 1500 × 1000 wall tablet and scales to the card width while retaining that aspect ratio.
- When updating manually, hard-refresh the Home Assistant browser after replacing `casa-luna.js`.

## Troubleshooting

**“Custom element doesn't exist: casa-luna”**

Check that the Lovelace resource points to `casa-luna.js` and uses type **JavaScript Module**, then hard-refresh the browser.

**Pack voltages show `--`**

Verify each entity in Home Assistant **Developer Tools → States** and select it in the editor under **Battery View**. The sensor must report a numeric state.

**Background images are missing**

Confirm that the `sky/` directory was copied with the module and that `background_path` points to it.

**Dashboard feels slow**

Disable **History charts** in the card editor if your Home Assistant instance has a slow recorder database. Auto-discovery is cached and refreshed periodically rather than on every state update.

## Development checks

```powershell
node --check dist/casa-luna.js
```

Before publishing, test the card with missing entities, all three battery-pack sensors, a rapid weather change, a config edit, and reduced-motion enabled.
