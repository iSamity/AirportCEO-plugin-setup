# iSamity.Template

NuGet **template pack** for BepInEx 5 plugins targeting Airport CEO (Unity 2019.4, `net46`). The generated project includes Harmony setup, BepInEx config wiring (`Config/`), optional mod-loader watermark (debug), and post-build copy into BepInEx and Apoapsis Mods folders. After you scaffold, see the generated `**README.md`** for first-time `Libs/` setup.

## Use the template (recommended)

Install the template **package** once (by **package id**). After that, create projects with the template **short name** `iSamityTemplate`—these are two different identifiers.

1. **Install** the pack from NuGet.org (or your feed), using the package id below:
  ```powershell
   dotnet new install iSamity.Template
  ```
2. **Generate** a new mod project:
  ```powershell
   dotnet new iSamityTemplate -n MyPlugin -o "C:\path\to\MyPlugin"
  ```
   With display name:
   Optional scaffolding (see **Options reference**):
3. **Help** for flags and shorthands:
  ```powershell
   dotnet new iSamityTemplate -h
  ```
   For this template, `**dotnet new iSamityTemplate -h**` lists the optional switches as `**-wc`, `--with-config**` (include `**Config/**` and config code; default **true**) and `**-vsc`, `--vsc-support**` (include `**.vscode/**` and `**scripts/**`; default **false**). Those match **Options reference** below.
4. **Remove** the installed pack when you no longer want it:
  ```powershell
   dotnet new uninstall iSamity.Template
  ```

**Summary:** `dotnet new install iSamity.Template` registers templates; `dotnet new iSamityTemplate` scaffolds a project. You do not run `dotnet new iSamity.Template` to create a mod.

## Prerequisites

- [.NET SDK](https://dotnet.microsoft.com/download) (8.0 or newer is fine for consumers and for packing; generated projects target `net46`)
- For **building** the generated plugin: Airport CEO with **BepInEx 5** installed (for play-testing), and the baseline `**Libs\`** files (**`Assembly-CSharp-publicized.dll`**, **`AirportCEOModLoader.dll`**) — no extra game DLLs unless you add optional UI or ShortcutCEO integration (see **`Libs/README.txt`** in the generated project)

Generated projects restore **BepInEx** packages from the feeds declared in the template `**.csproj`** (`nuget.bepinex.dev`, `nuget.samboy.dev`, plus nuget.org). If restore fails behind a firewall, allow those sources or mirror the packages internally.

## Options reference

Shorthands are the short CLI flags accepted by `dotnet new` for this template. `**dotnet new iSamityTemplate -h**` prints `**-mn`, `--mod-name**`, `**-wc`, `--with-config**`, and `**-vsc`, `--vsc-support**` (see **dotnetcli.host.json** in the template).


| Long option  | Shorthand | Applies to    | Description                                                                                                                                                                               | Default / notes                                                                                                  |
| ------------ | --------- | ------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| `--name`     | `-n`      | `dotnet new`  | Project name: assembly name, root namespace, folder rename from `TemplateSource`.                                                                                                         | If omitted, the name of the output directory is used.                                                            |
| `--output`   | `-o`      | `dotnet new`  | Directory for generated files.                                                                                                                                                            | Optional; defaults to current directory behavior per `dotnet new`.                                               |
| `--force`    | —         | `dotnet new`  | Overwrite existing files in the output path.                                                                                                                                              | Off by default.                                                                                                  |
| `--dry-run`  | —         | `dotnet new`  | Print what would be created without writing files.                                                                                                                                        | Off by default.                                                                                                  |
| `--mod-name`     | `-mn`  | This template | Human-readable title written to `<Product>` in the `.csproj`. Does not change assembly name, namespace, or the Apoapsis `Mods\$(AssemblyName)\` layout (those follow `--name` / `-n`). | If omitted, defaults to the same value as `--name` / `-n`.                                                                 |
| `--with-config`  | `-wc`  | This template | Include `**Config/**` (`DefaultConfig`, BepInEx binds) and the matching code in `**Plugin.cs**`.                                                                                     | `**true**` (default). Use `**--with-config false**` or `**-wc false**` for a minimal plugin without that folder or wiring. |
| `--vsc-support`  | `-vsc` | This template | Include `**.vscode/tasks.json**` and `**scripts/**` (PowerShell: build + optional Steam launch for Airport CEO).                                                                      | `**false**` (default). Use `**--vsc-support true**` or `**-vsc true**` to add them.                                         |


`**--name` vs `--mod-name`:** Use `**--name` / `-n**` for the technical identity: assembly name, root namespace, and replacement of the template’s `TemplateSource` placeholder. Use `**--mod-name` / `-mn**` when you want a friendlier title in the project file (spaces, branding) while keeping a valid C# / file name in `-n`—for example `-n MyAirportMod -mn "My Airport Mod"`. Omitting `--mod-name` is fine; the template then uses `-n` for `<Product>` as well.

**CLI vs template symbols:** `**dotnetcli.host.json**` maps CLI flags to the symbols `**mod-name**`, `**WithConfig**`, and `**VscSupport**` in `**template.json**`. Conditions and `**sources**` modifiers still use those symbol names (for example `(WithConfig == false)`), not the hyphenated CLI long names.

`**--with-config`:** Default **true** so new mods get the usual BepInEx config pattern.

`**--vsc-support`:** Default **false** so consumers who do not use VS Code / Cursor are not given `**.vscode**` or `**scripts/**` unless they opt in.

- Template **short name** (scaffold command): `**iSamityTemplate**`
- Package id (**install** / **uninstall**): `**iSamity.Template**`

## Generated project: `Libs` and deploy copy

After `dotnet new iSamityTemplate`, the default `**Libs\`** layout is **`Assembly-CSharp-publicized.dll`** plus **`AirportCEOModLoader.dll`** (see **`Libs/README.txt`**). You do **not** need to copy vanilla `Assembly-CSharp` / firstpass from the game for the stock template. Add more DLLs from `Airport CEO_Data\Managed\` only when you need them — for example `**UnityEngine.UI.dll`** or TextMeshPro for UI, or `**ShortcutCEO.dll**` for shortcut integration. References use `Private=false` (compile-only) and are wired in **TemplateSource.csproj** for the baseline pair; optional assemblies need their own `<Reference>` entries.

**Post-build** copies your plugin into Airport CEO folders (override paths with MSBuild properties if needed):


| Configuration           | Where `$(TargetName).dll` / `.pdb` go                                                                                                                                                           |
| ----------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Debug** (and Release) | Steam BepInEx `plugins` folder (default under `C:\Program Files (x86)\Steam\steamapps\common\Airport CEO\BepInEx\plugins`).                                                                     |
| **Release** only        | Also `%USERPROFILE%\AppData\Roaming\Apoapsis Studios\Airport CEO\Mods\$(AssemblyName)\plugins` — `$(AssemblyName)` matches your project/assembly (from `-n` / output folder), not `--mod-name`. |


Skip all copies in CI or when testing: `dotnet build -p:DisableAirportCeoPostCopy=true`. Customize folders: `-p:AirportCeoBepInExPluginsDir=...` and/or `-p:AirportCeoModsPublishDir=...`.

When the game or Unity version changes, refresh `Libs\`, align `UnityEngine.Modules` in the generated `.csproj`, and retest. A longer checklist for template maintainers is in `**MAINTENANCE.md`** at the root of this repository.

## Maintain this template (authors)

### Build the package

From the repository root:

```powershell
dotnet pack -c Release
```

This produces `bin\Release\iSamity.Template.<version>.nupkg` (version comes from `PackageVersion` in `**iSamity.Template.csproj**`).

### Publish to NuGet.org (recommended distribution)

1. Create a [nuget.org](https://www.nuget.org/) account and an **API key** scoped to `**iSamity.Template`** (or a new-package scope for the first publish).
2. Store the key only in an environment variable or CI secret (never commit it).
  ```powershell
   $env:NUGET_API_KEY = "<paste in your terminal only>"
  ```
3. Pack and push:
  ```powershell
   dotnet pack -c Release
   dotnet nuget push ".\bin\Release\iSamity.Template.1.0.0.nupkg" --api-key $env:NUGET_API_KEY --source https://api.nuget.org/v3/index.json
  ```
   Adjust the `.nupkg` file name if you change `PackageVersion`. Indexing on NuGet can take a few minutes; then consumers can use **Use the template (recommended)** above.

### Install from a local `.nupkg` (testing only)

```powershell
dotnet new install ".\bin\Release\iSamity.Template.1.0.0.nupkg"
```

After template changes, pack again and reinstall, or bump `PackageVersion` if installs are cached oddly.