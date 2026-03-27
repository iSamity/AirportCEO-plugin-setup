#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Build the plugin solution or a specific project in Debug configuration.

.DESCRIPTION
    Expects a single .sln next to the scripts folder (typical BepInEx plugin layout).
    Optional -Project builds <Project>.csproj in the repository root.

.PARAMETER Project
    Optional. Base name of the .csproj at repo root (e.g. "MyPlugin" for MyPlugin.csproj).

.PARAMETER Launch
    Optional. Launch Airport CEO via Steam after a successful build.
#>

param(
    [string]$Project = "",
    [bool]$Launch = $true
)

$ErrorActionPreference = "Stop"

$RepoRoot = Split-Path $PSScriptRoot -Parent
$slnFiles = @(Get-ChildItem -LiteralPath $RepoRoot -Filter *.sln -File | Sort-Object Name)
if ($slnFiles.Count -eq 0) {
    Write-Error "No .sln file found in: $RepoRoot"
    exit 1
}
if ($slnFiles.Count -gt 1) {
    Write-Warning "Multiple .sln files found; using: $($slnFiles[0].Name)"
}
$SolutionFile = $slnFiles[0].FullName

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "Building BepInEx plugin (Debug)" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

try {
    if ([string]::IsNullOrEmpty($Project)) {
        Write-Host "Building solution..." -ForegroundColor Yellow
        Write-Host "Command: dotnet build `"$SolutionFile`" --configuration Debug" -ForegroundColor Gray
        Write-Host ""

        dotnet build "$SolutionFile" --configuration Debug
    }
    else {
        $ProjectFile = Join-Path $RepoRoot "$Project.csproj"

        if (-not (Test-Path -LiteralPath $ProjectFile)) {
            Write-Error "Project file not found: $ProjectFile"
            exit 1
        }

        Write-Host "Building project: $Project" -ForegroundColor Yellow
        Write-Host "Command: dotnet build `"$ProjectFile`" --configuration Debug" -ForegroundColor Gray
        Write-Host ""

        dotnet build "$ProjectFile" --configuration Debug
    }

    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "==================================================" -ForegroundColor Green
        Write-Host "Build completed successfully!" -ForegroundColor Green
        Write-Host "==================================================" -ForegroundColor Green

        if ($Launch) {
            Write-Host ""
            $LaunchScript = Join-Path $PSScriptRoot "launch-game.ps1"
            & $LaunchScript
        }
    }
    else {
        Write-Host ""
        Write-Host "==================================================" -ForegroundColor Red
        Write-Host "Build failed with exit code: $LASTEXITCODE" -ForegroundColor Red
        Write-Host "==================================================" -ForegroundColor Red
        exit $LASTEXITCODE
    }
}
catch {
    Write-Host ""
    Write-Host "==================================================" -ForegroundColor Red
    Write-Host "Build failed with error:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host "==================================================" -ForegroundColor Red
    exit 1
}
