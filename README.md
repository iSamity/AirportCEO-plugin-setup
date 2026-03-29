# ModTemplates

NuGet **template pack** (`iSamity.Template`) for BepInEx 5 plugins targeting Airport CEO (Unity 2019.4, `net46`). The generated project includes Harmony setup, BepInEx config wiring (`Config/`), optional mod-loader watermark (debug), and post-build copy into BepInEx and Apoapsis Mods folders. After you scaffold, see the generated `README.md` for first-time `Libs/` setup.

**Install** uses the NuGet **package id** `iSamity.Template` (for example `dotnet new install iSamity.Template::1.0.1`). **Scaffold** still uses the template **short name** `iSamityTemplate`.

## Use the template (recommended)

Install the template **package** once (by **package id**). Create projects with the template **short name** `iSamityTemplate`—these are two different identifiers.

1. **Install** the pack from NuGet.org (or your feed):
  ```powershell
   dotnet new install iSamity.Template
  ```
   To install the latest published version without pinning, use `dotnet new install iSamity.Template`.
2. **Generate** a new mod project:
  ```powershell
   dotnet new iSamityTemplate -n MyPlugin -o "C:\path\to\MyPlugin"
  ```
   Optional: human-readable product title and template switches (see [Options reference](#options-reference)):
3. **Help** for flags and shorthands:
  ```powershell
   dotnet new iSamityTemplate -h
  ```

## Prerequisites

- [.NET SDK](https://dotnet.microsoft.com/download) (8.0 or newer is fine for consumers and for packing; generated projects target `net46`)
- For **building** the generated plugin: Airport CEO with **BepInEx 5** installed (for play-testing), and baseline `Libs\` files (`Assembly-CSharp-publicized.dll`, `AirportCEOModLoader.dll`) — no extra game DLLs unless you add optional UI or ShortcutCEO integration (see `Libs/README.txt` in the generated project)

Generated projects restore **BepInEx** packages from the feeds declared in the template `.csproj` (`nuget.bepinex.dev`, `nuget.samboy.dev`, plus nuget.org). If restore fails behind a firewall, allow those sources or mirror the packages internally.

## Options reference

Shorthands are the short CLI flags accepted by `dotnet new` for this template. `dotnet new iSamityTemplate -h` lists `-mn` / `--mod-name`, `-wc` / `--with-config`, and `-vsc` / `--vsc-support`. They map via `dotnetcli.host.json` to the symbols `mod-name`, `WithConfig`, and `VscSupport` in `template.json` (conditions and `sources` modifiers use those symbol names, not the hyphenated CLI long names).


| Long option     | Shorthand | Default                                               | Description                                                                                                                                                                            |
| --------------- | --------- | ----------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `--name`        | `-n`      | Output directory name if omitted.                     | Project name: assembly name, root namespace, folder rename from `TemplateSource`.                                                                                                      |
| `--output`      | `-o`      | Current directory behavior per `dotnet new`.          | Directory for generated files.                                                                                                                                                         |
| `--force`       | —         | `false`                                               | Overwrite existing files in the output path.                                                                                                                                           |
| `--dry-run`     | —         | `false`                                               | Print what would be created without writing files.                                                                                                                                     |
| `--mod-name`    | `-mn`     | Same as `--name` / `-n` if omitted.                   | Human-readable title written to `<Product>` in the `.csproj`. Does not change assembly name, namespace, or the Apoapsis `Mods\$(AssemblyName)\` layout (those follow `--name` / `-n`).   |
| `--with-config` | `-wc`     | `true` (usual BepInEx config pattern for new mods).   | Include `Config/` (`DefaultConfig`, BepInEx binds) and the matching code in `Plugin.cs`. Pass `false` for a minimal plugin without that folder or wiring.                              |
| `--vsc-support` | `-vsc`    | `false` (no `.vscode` / `scripts/` unless requested). | Include `.vscode/tasks.json` and `scripts/` (PowerShell: build + optional Steam launch for Airport CEO). Pass `true` to opt in when using VS Code / Cursor.                            |


`**--name` vs `--mod-name`:** Use `--name` / `-n` for the technical identity: assembly name, root namespace, and replacement of the template’s `TemplateSource` placeholder. Use `--mod-name` / `-mn` for a friendlier title in the project file (spaces, branding) while keeping a valid C# / file name in `-n`—for example `-n MyAirportMod -mn "My Airport Mod"`. Omitting `--mod-name` is fine; the template then uses `-n` for `<Product>` as well.

- Template **short name** (scaffold command): `iSamityTemplate`
- Package id (**install** / **uninstall**): `iSamity.Template`

## Generated project: Libs and deploy copy

After `dotnet new iSamityTemplate`, the default `Libs\` layout is `Assembly-CSharp-publicized.dll` plus `AirportCEOModLoader.dll` (see `Libs/README.txt`). You do **not** need to copy vanilla `Assembly-CSharp` / firstpass from the game for the stock template. Add more DLLs from `Airport CEO_Data\Managed\` only when you need them — for example `UnityEngine.UI.dll` or TextMeshPro for UI, or `ShortcutCEO.dll` for shortcut integration. References use `Private=false` (compile-only) and are wired in `TemplateSource.csproj` for the baseline pair; optional assemblies need their own `<Reference>` entries.

**Post-build** copies your plugin into Airport CEO folders (override paths with MSBuild properties if needed):


| Configuration           | Where `$(TargetName).dll` / `.pdb` go                                                                                                                                                           |
| ----------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Debug** (and Release) | Steam BepInEx `plugins` folder (default under `C:\Program Files (x86)\Steam\steamapps\common\Airport CEO\BepInEx\plugins`).                                                                     |
| **Release** only        | Also `%USERPROFILE%\AppData\Roaming\Apoapsis Studios\Airport CEO\Mods\$(AssemblyName)\plugins` — `$(AssemblyName)` matches your project/assembly (from `-n` / output folder), not `--mod-name`. |


Skip all copies in CI or when testing: `dotnet build -p:DisableAirportCeoPostCopy=true`. Customize folders: `-p:AirportCeoBepInExPluginsDir=...` and/or `-p:AirportCeoModsPublishDir=...`.

When the game or Unity version changes, refresh `Libs\`, align `UnityEngine.Modules` in the generated `.csproj`, and retest. A longer checklist for template maintainers is in `MAINTENANCE.md` at the root of this repository.