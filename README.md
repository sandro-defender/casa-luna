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

## WLED

Set `wled_entity` to your WLED `light.*` entity in the **Lighting View** editor. It appears in its own WLED section in the Lighting popup, with a direct on/off button and a brightness slider. `wled_name` changes the displayed name.

## Left navigation and custom cards

The editor’s **Left Navigation** section lets you show or hide each built-in left-side card. It also includes **Custom Card 1** and **Custom Card 2**. Enable either card, set its title, subtitle, and icon, then add a comma-separated list of Home Assistant entity IDs. The custom card opens a live list of those entities.

Available custom icon names: `gear`, `home`, `bolt`, `plug`, `batt`, `therm`, `shield`, `bulb`, `sun`, `pump`, `irrig`, and `warn`.

## Separate 12V DC system

The former inverter area keeps its original two-card visual layout, repurposed as a dedicated **12V DC System**. The right circular indicator shows the 12V power-supply voltage, while the left card shows the separate DC readings. Configure it in the editor with your separate DC sensors:

- `dc12_solar_voltage`
- `dc12_supply_voltage`
- `dc12_battery_voltage`
- `dc12_current`
- `dc12_power` (optional)

This card is separate from your 220V/AC monitoring. Set `dc12_enabled: false` to hide it. The pre-change module is preserved as `dist/casa-luna.backup.js`.

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
