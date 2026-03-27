# BepInEx plugin (Airport CEO)

C# BepInEx 5 plugin template: **Harmony** patches, optional **BepInEx** config wiring (`Config/` when enabled), optional **Airport CEO** mod-loader watermark (debug), and post-build copy into the game’s BepInEx plugins folder (and Apoapsis Mods layout on Release). Optional **`.vscode`** tasks and **`scripts/`** build helpers are included only if you scaffold with **`--vsc-support true`** or **`-vsc true`** (off by default). **`dotnet new iSamityTemplate -h`** shows **`-vsc`, `--vsc-support`** and **`-wc`, `--with-config`**.

**Prerequisites:** Airport CEO with **BepInEx 5** installed, [.NET SDK](https://dotnet.microsoft.com/download) (to build `net46`), and the baseline **`Libs\`** pair described below (publicized game asm + mod loader — no extra game DLLs required unless you add features).

## First-time setup

1. Ensure **`Libs\`** contains **`Assembly-CSharp-publicized.dll`** and **`AirportCEOModLoader.dll`** (compile-time only; they are not copied next to your plugin). You do not need vanilla `Assembly-CSharp` / firstpass from the game unless you switch the project to use them. Optional references (e.g. **`UnityEngine.UI.dll`**, TextMeshPro, **`ShortcutCEO.dll`**) are only for extra UI or integration — see **`Libs/README.txt`**.
2. From this project directory:
   ```bash
   dotnet restore
   dotnet build
   ```
3. By default, **Debug** and **Release** builds copy **`<AssemblyName>.dll`** (and `.pdb` if present) to:
   - `…\Airport CEO\BepInEx\plugins\`
   - **Release** also copies to `%AppData%\Roaming\Apoapsis Studios\Airport CEO\Mods\<AssemblyName>\plugins\` for packaging / uploader layout.

`<AssemblyName>` is the value in your **`.csproj`** (`<AssemblyName>…</AssemblyName>`). If you omit it, it defaults to the project file name without `.csproj`.

Override folders if needed: `dotnet build -p:AirportCeoBepInExPluginsDir=...` or **`Directory.Build.props`** (see comments in the **`.csproj`**). For CI, use `-p:DisableAirportCeoPostCopy=true` to skip copying.

## Project layout

| Path            | Purpose                                                                                                 |
| --------------- | ------------------------------------------------------------------------------------------------------- |
| **`Plugin.cs`** | Entry point: `Awake` / `Start`, optional config `Setup`, Harmony `PatchAll`, mod-loader watermark hook. |
| **`Config/`**   | Present when **`--with-config`** is left at default (**true**): `DefaultConfig` + BepInEx `Bind` — see **`Config/README.md`**. Omitted if **`--with-config false`** (or **`-wc false`**). |
| **`Libs/`**     | **`Assembly-CSharp-publicized.dll`** + **`AirportCEOModLoader.dll`** (baseline); optional Managed DLLs if you extend UI or use ShortcutCEO — see **`Libs/README.txt`**. |
| **`.vscode/`**, **`scripts/`** | Only when **`--vsc-support true`** (or **`-vsc true`**): tasks for Debug/Release build and optional Steam launch — see **`scripts/README.md`**. |

Plugin identity (**GUID**, **name**, **version**) comes from **BepInEx.PluginInfoProps** (`MyPluginInfo` generated at build). The **`.csproj`** `<Product>` line is a separate, human-readable label (set when you scaffold with **`--mod-name`**, or it defaults to the same value as **`-n`**).

## Game / Unity upgrades

When the game or Unity version changes, refresh **`Assembly-CSharp-publicized.dll`** (and any optional **`Libs\`** copies you added), align **`UnityEngine.Modules`** in your **`.csproj`**, and retest. Template authors: see **`MAINTENANCE.md`** in the template repository.

## Scaffolding this template

The template’s internal **source name** is `TemplateSource` (project file, root namespace, etc.). When you instantiate the template, that string is replaced by your chosen name.

If the template is installed (`dotnet new install <path-or-package>`):

```bash
dotnet new iSamityTemplate -n YourPluginName -o YourPluginName --mod-name "Your Display Name"
```

- **`YourPluginName`** replaces `TemplateSource` in file names, namespaces, and the default `<AssemblyName>`.
- **`--mod-name`** (`-mn`) fills `<Product>` via `__PLUGIN_DISPLAY_NAME__`. If omitted, the template uses the same string as **`-n`**.
- **`--with-config`** (default **true**): include **`Config/`** and config wiring in **`Plugin.cs`**. Use **`--with-config false`** or **`-wc false`** for a minimal plugin without `DefaultConfig`.
- **`--vsc-support`** (default **false**): include **`.vscode/tasks.json`** and **`scripts/`** for build + optional Steam launch from the editor. Use **`--vsc-support true`** or **`-vsc true`**.

```bash
dotnet new iSamityTemplate -n MyMod -o MyMod --vsc-support true
dotnet new iSamityTemplate -n MyMod -o MyMod -vsc true
dotnet new iSamityTemplate -n MyMod -o MyMod --with-config false
dotnet new iSamityTemplate -n MyMod -o MyMod -wc false
```

**`dotnet new iSamityTemplate -h`** prints **`-wc`, `--with-config`** and **`-vsc`, `--vsc-support`** (same meaning as in this section).
