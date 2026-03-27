Libs folder — compile-time references (this template)
=====================================================

Baseline (what this template expects)
-------------------------------------

You do **not** need vanilla `Assembly-CSharp.dll` / `Assembly-CSharp-firstpass.dll` from the game for the default setup. Keep these two files in **`Libs\`** (see **TemplateSource.csproj** — each reference is conditional on `Exists(...)`):

  Libs\Assembly-CSharp-publicized.dll   — publicized game assembly (Harmony-friendly accessors).
  Libs\AirportCEOModLoader.dll            — official mod loader API (e.g. watermark helpers used in **Plugin.cs**).

They are **compile-time** only (`Private=false`): MSBuild does not copy them next to your plugin; the game (and mod loader) already provide the real assemblies at runtime.

Optional — only if you add features that need more types
---------------------------------------------------------

Copy the DLLs you need from **`Airport CEO_Data\Managed\`** (paths vary slightly with install), then add matching `<Reference>` entries in **TemplateSource.csproj** (same pattern: `HintPath` under `Libs\`, `Private=false`). Examples:

- **uGUI / Unity UI** — `UnityEngine.UI.dll`
- **TextMeshPro UI** — often `Unity.TextMeshPro.dll` (some installs use a name like `UnityTextMeshPro.dll`; use whatever appears in **Managed**)
- **ShortcutCEO shortcuts** — `ShortcutCEO.dll` (if you integrate with that mod’s API)

You only add these when your code actually references those assemblies; the baseline template does not require them.

Licensing / git
---------------

Do not commit or redistribute binaries unless your situation allows it. The project **`.gitignore`** ignores `Libs\*.dll` by default so clones stay clean; keep your copies locally or distribute them through a channel that matches the license for each file.

Other notes
-----------

- Anything you must **ship beside** your plugin (not already in the game) needs `<None … CopyToOutputDirectory>` or your own packaging step — not the same as the `Private=false` references above.
- Override deploy folders when building: `dotnet build -p:AirportCeoBepInExPluginsDir=...` or `AirportCeoBepInExPluginsDir` / `AirportCeoModsPublishDir` in **Directory.Build.props**.
