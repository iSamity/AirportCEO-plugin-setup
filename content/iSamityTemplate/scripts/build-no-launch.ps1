#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Build in Debug without launching the game.
#>

param(
    [string]$Project = ""
)

$ErrorActionPreference = "Stop"

$BuildScript = Join-Path $PSScriptRoot "build.ps1"

if ([string]::IsNullOrEmpty($Project)) {
    & $BuildScript -Launch $false
}
else {
    & $BuildScript -Project $Project -Launch $false
}
