# Config — `DefaultConfig`

`DefaultConfig.cs` starts **empty** on purpose: you add [BepInEx `Config.Bind`](https://docs.bepinex.dev/articles/dev_guide/plugin/4_configuration.html) calls and matching `ConfigEntry<T>` properties as you need them.

## Where values live

After you add at least one `Bind`, BepInEx creates a **`.cfg`** file under the game’s `BepInEx/config/` folder (name is tied to your plugin GUID). Players can edit it when the game is not running.

## How to fill in `DefaultConfig`

Prefer **`Setup(ConfigFile config)`** (instance method): keep binding logic in one place and call it from `Plugin.Awake` when the plugin’s `Config` is ready.

1. Add a property for each `ConfigEntry<T>` (use `private set` if you assign inside `Setup`).
2. In `Setup`, call `config.Bind` once per setting (section name, key, default, description).
3. Hold a `DefaultConfig` instance on your plugin (or create one in `Awake`) and call `Setup(base.Config)`.
4. Use `yourDefaultConfig.YourProperty.Value` anywhere in the mod, or subscribe to `SettingChanged`.

`Plugin.Awake` already creates a `DefaultConfig` and calls `Setup(Config)` so bindings run at startup.

## Example — `DefaultConfig.cs`

```csharp
using BepInEx.Configuration;

namespace TemplateSource.Config;

public sealed class DefaultConfig
{
    public ConfigEntry<bool> EnableFeature { get; private set; } = null!;
    public ConfigEntry<float> Intensity { get; private set; } = null!;

    public void Setup(ConfigFile config)
    {
        EnableFeature = config.Bind(
            "General",
            "EnableFeature",
            true,
            "Master toggle for the feature.");

        Intensity = config.Bind(
            "General",
            "Intensity",
            1f,
            new ConfigDescription(
                "Strength of the effect.",
                new AcceptableValueRange<float>(0f, 2f)));
    }
}
```

## Example — generated `.cfg` (shape)

Your keys appear under **sections** in INI style. After the example above, the file will look roughly like this (header lines vary by BepInEx version):

```ini
## Settings file was created by plugin TemplateSource v1.0.0
## Plugin GUID: <your-guid>

[General]

## Master toggle for the feature.
# Setting type: Boolean
# Default value: true
EnableFeature = true

## Strength of the effect.
# Setting type: Single
# Default value: 1
# Acceptable value range: From 0 to 2 (inclusive)
Intensity = 1
```

Exact comments and formatting may differ slightly; the important part is **`[Section]`** and **`Key = value`**.

## Optional: Harmony self-test log

`HarmonyPatcher.LogHarmonySelfTestResult()` logs the result of the internal `HarmonySelfTest` patch (useful once while wiring Harmony). Call it from `Awake` after `HarmonyPatcher.Apply()` only if you want that log line; you can gate it behind your own config flag once you add one.
