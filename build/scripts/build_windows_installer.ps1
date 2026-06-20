param(
  [switch]$SkipFlutterBuild
)

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$releaseDir = Join-Path $root "build\windows\x64\runner\Release"
$installerScript = Join-Path $root "installer\sase_client.iss"

if (-not $SkipFlutterBuild) {
  Push-Location $root
  try {
    if (Get-Command fvm -ErrorAction SilentlyContinue) {
      fvm flutter build windows --release
    } else {
      flutter build windows --release
    }
  } finally {
    Pop-Location
  }
}

$exePath = Join-Path $releaseDir "sase_client.exe"
$flutterDllPath = Join-Path $releaseDir "flutter_windows.dll"
$dataPath = Join-Path $releaseDir "data"

foreach ($path in @($exePath, $flutterDllPath, $dataPath)) {
  if (-not (Test-Path $path)) {
    throw "Build incompleto. Arquivo ou pasta obrigatoria nao encontrada: $path"
  }
}

$iscc = Get-Command iscc -ErrorAction SilentlyContinue
if (-not $iscc) {
  $defaultIscc = "${env:ProgramFiles(x86)}\Inno Setup 6\ISCC.exe"
  if (Test-Path $defaultIscc) {
    $iscc = Get-Item $defaultIscc
  }
}

if (-not $iscc) {
  throw "Inno Setup 6 nao encontrado. Instale em https://jrsoftware.org/isinfo.php e rode este script de novo."
}

& $iscc.Source $installerScript

$output = Join-Path $root "dist\sase-client-setup.exe"
Write-Host "Instalador gerado em: $output"
