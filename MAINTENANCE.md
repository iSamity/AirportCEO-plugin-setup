# Maintenance — game / Unity / toolchain

Personal checklist for when **Airport CEO** or **Unity** moves, or you refresh your dev machine. See also `content/iSamityTemplate/Libs/README.txt` for baseline vs optional DLLs and `Private=false` behavior.

## After a game update (or new install)

1. **Refresh `Libs\`** — Regenerate or recopy **`Assembly-CSharp-publicized.dll`** so compile-time types match the new game build. Update **`AirportCEOModLoader.dll`** when the mod loader ships a new API surface you depend on. Recopy any **optional** Managed DLLs you added (e.g. **`UnityEngine.UI.dll`**, TextMeshPro, **`ShortcutCEO.dll`**) from `…\Airport CEO\Airport CEO_Data\Managed\` if those assemblies changed.

2. **Build and fix breaks** — Game updates can rename or remove APIs; fix compile errors and retest patches.

## When the game’s Unity version changes

1. **`UnityEngine.Modules` (NuGet)** in `TemplateSource.csproj` — The package version (e.g. `2019.4.40`) should match the **Unity version the game ships**. Wrong version can mean wrong or missing Unity API stubs at compile time.

2. **Refresh `Libs\` again** — Unity/game bumps often ship new managed assemblies; refresh the publicized asm and optional Managed copies like a game update above.

## Rare: .NET / BepInEx stack

- **`TargetFramework` (`net46`)** — Only change if BepInEx or the game’s Mono expectations change (unusual).
- **`BepInEx.*` / `Lib.Harmony` package versions** — Bump when you deliberately move to a new BepInEx or Harmony major/minor, not for every game patch.

## Not the game version

- **`<Version>` in `TemplateSource.csproj`** — Your **plugin** release version, not Airport CEO’s.

## Deploy paths (optional)

Override at build time if install locations differ: `dotnet build -p:AirportCeoBepInExPluginsDir=…` or `Directory.Build.props` — see comments in `TemplateSource.csproj`.
