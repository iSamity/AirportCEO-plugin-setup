# Build scripts (optional)

These PowerShell scripts are included when you scaffold with **`--vsc-support true`** (or **`-vsc true`**). They pair with **`.vscode/tasks.json`** for Debug/Release builds and optional Steam launch (Airport CEO app id **673610**).

## Requirements

- [PowerShell](https://github.com/PowerShell/PowerShell) (`pwsh` recommended on all platforms)
- [.NET SDK](https://dotnet.microsoft.com/download) for `dotnet build`

## Usage

From the plugin repository root:

```powershell
pwsh ./scripts/build.ps1
pwsh ./scripts/build-no-launch.ps1
pwsh ./scripts/build-release.ps1
```

Optional: build a specific project file at the repo root: `-Project MyPlugin` → **`MyPlugin.csproj`**.

The build scripts pick the first **`.sln`** in the repo root (alphabetically if several exist).

## VS Code / Cursor

Use **Terminal → Run Task** and choose **Build (Debug) + Launch** (default build task), **Build (Debug, No Launch)**, or **Build (Release) + Launch**.
