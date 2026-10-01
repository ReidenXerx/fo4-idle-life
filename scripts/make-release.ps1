<#
.SYNOPSIS
  Builds the release zip build\dist\IdleLife-<VERSION>.zip: IdleLife.esp, its scripts, the MCM page and
  F4SE\Plugins\IdleLife.dll, docs under Docs\IdleLife, and the FOMOD (tools\fomod_pack.py); then nexus-tools'
  fomod-check and the sha256. Refuses uncommitted sources, and a dll that names this machine. -Draft builds the
  FOMOD without the cards (a check run, never a release). Never the dev dump switch (IdleLife_dump.txt).
#>
[CmdletBinding()]
param([switch] $Draft, [switch] $NoBuild)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$version = (Get-Content (Join-Path $root 'VERSION') -Raw).Trim()
if ($version -notmatch '^[0-9]+\.[0-9]+\.[0-9]+$') { throw "VERSION must hold a plain x.y.z, not '$version'" }
$cmake = 'C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe'
$check = Join-Path $root '..\nexus-tools\scripts\fomod-check.py'

Push-Location $root
try {
    $dirty = @(git status --porcelain -- papyrus tools plugin/src plugin/CMakeLists.txt scripts VERSION CHANGELOG.md README.md LICENSE 2>$null)
    if ($dirty.Count -gt 0 -and -not $Draft) { throw ("Commit the sources first:`n  " + ($dirty -join "`n  ")) }
    if (-not $NoBuild) {
        python tools\make_esp.py; if ($LASTEXITCODE) { throw 'make_esp failed' }
        python tools\make_mcm.py; if ($LASTEXITCODE) { throw 'make_mcm failed' }
        powershell -NoProfile -File scripts\build-papyrus.ps1; if ($LASTEXITCODE) { throw 'build-papyrus failed' }
        & $cmake --build plugin\build-rd --config Release; if ($LASTEXITCODE) { throw 'the plugin build failed' }
    }
} finally { Pop-Location }

$data = Join-Path $root 'build\data'
$dll = Join-Path $root 'plugin\build-rd\Release\IdleLife.dll'
if (Select-String -Path $dll -Pattern $env:USERNAME -SimpleMatch -Quiet) { throw "$dll names this machine's user folder" }
$out = Join-Path $root "build\dist\IdleLife-$version"
$zip = "$out.zip"
if (Test-Path $out) { Remove-Item -Recurse -Force $out }
New-Item -ItemType Directory -Force $out | Out-Null
foreach ($item in 'IdleLife.esp', 'Scripts', 'MCM') { Copy-Item -Recurse (Join-Path $data $item) $out }
New-Item -ItemType Directory -Force (Join-Path $out 'F4SE\Plugins') | Out-Null
Copy-Item $dll (Join-Path $out 'F4SE\Plugins\IdleLife.dll')
if (Get-ChildItem $out -Recurse -Filter '*dump*') { throw 'a dev dump file reached the release folder' }

$docs = Join-Path $out 'Docs\IdleLife'
New-Item -ItemType Directory -Force $docs | Out-Null
Copy-Item (Join-Path $root 'README.md'), (Join-Path $root 'CHANGELOG.md'), (Join-Path $root 'LICENSE') $docs

$packArgs = @((Join-Path $root 'tools\fomod_pack.py'), $out, $version)
if ($Draft) { $packArgs += '--draft' }
python @packArgs
if ($LASTEXITCODE) { throw 'tools\fomod_pack.py refused - nothing was packed' }

if (Test-Path $zip) { Remove-Item -Force $zip }
python -c "import pathlib,sys,zipfile; o=pathlib.Path(sys.argv[1]); z=zipfile.ZipFile(sys.argv[2],'w',zipfile.ZIP_DEFLATED); [z.write(p, p.relative_to(o).as_posix()) for p in sorted(o.rglob('*')) if p.is_file()]; z.close()" $out $zip
if ($LASTEXITCODE) { throw 'zipping failed' }

python $check $zip
if ($LASTEXITCODE -and -not $Draft) { Remove-Item -Force $zip; throw 'fomod-check failed - the zip is removed' }
$hash = (Get-FileHash -Algorithm SHA256 $zip).Hash.ToLower()
$dllHash = (Get-FileHash -Algorithm SHA256 $dll).Hash.ToLower()
Write-Host ("{0}  {1:N2} MB  sha256 {2}{3}`n  IdleLife.dll sha256 {4} (VirusTotal)" -f $zip, ((Get-Item $zip).Length / 1MB), $hash, $(if ($Draft) { '  (DRAFT)' } else { '' }), $dllHash)
