#Requires -Version 5.1
<#
.SYNOPSIS
  Sync iHelp API doc from Obsidian vault into MkDocs docs/.
.PARAMETER VaultRoot
  Root of the Obsidian vault. Default: C:\Users\Gian Peres\Documents\myvault
.PARAMETER SourceFile
  Path to source markdown, relative to VaultRoot.
.PARAMETER MediaDir
  Folder name(s) inside vault to search for images (recursive).
#>
param(
  [string]$VaultRoot   = 'C:\Users\Gian Peres\Documents\myvault',
  [string]$SourceFile  = 'ihelp api\A_src_Docs API iHelp.md',
  [string]$MediaDir    = 'z_Media'
)

$ErrorActionPreference = 'Stop'
$RepoRoot   = Split-Path -Parent $PSScriptRoot
$DocsDir    = Join-Path $RepoRoot 'docs'
$AssetsDir  = Join-Path $DocsDir  'assets'
$OutFile    = Join-Path $DocsDir  'index.md'
$SrcPath    = Join-Path $VaultRoot $SourceFile
$MediaRoot  = Join-Path $VaultRoot $MediaDir

if (-not (Test-Path $SrcPath))   { throw "Source not found: $SrcPath" }
if (-not (Test-Path $MediaRoot)) { throw "Media dir not found: $MediaRoot" }

New-Item -ItemType Directory -Force -Path $AssetsDir | Out-Null

Write-Host "Reading  $SrcPath"
$content = Get-Content -Path $SrcPath -Raw -Encoding UTF8

# 1. Strip YAML frontmatter
$content = $content -replace '(?s)^---.*?---\r?\n', ''

# 2. Strip Obsidian table-of-contents block (Material renders TOC natively)
$content = $content -replace '(?s)```table-of-contents\r?\n```\r?\n?', ''

# 3. Collect + rewrite Obsidian wikilink images: ![[name.png]] -> ![](assets/name.png)
$imageNames = New-Object System.Collections.Generic.HashSet[string]
$content = [regex]::Replace($content, '!\[\[([^\]]+)\]\]', {
    param($m)
    $name = $m.Groups[1].Value.Trim()
    [void]$imageNames.Add($name)
    $enc = [uri]::EscapeDataString($name)
    return "![](assets/$enc)"
})

# 4. Copy referenced images from vault media dir (recursive search)
$copied = 0; $missing = @()
foreach ($name in $imageNames) {
    $hit = Get-ChildItem -Path $MediaRoot -Filter $name -Recurse -File -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($null -eq $hit) {
        $missing += $name
        continue
    }
    Copy-Item -Path $hit.FullName -Destination (Join-Path $AssetsDir $name) -Force
    $copied++
}

# 5. Write transformed markdown
Set-Content -Path $OutFile -Value $content -Encoding utf8
Write-Host ("Wrote    {0}" -f $OutFile)
Write-Host ("Images   {0} copied, {1} missing" -f $copied, $missing.Count)
if ($missing.Count -gt 0) {
    Write-Warning "Missing images (not found under '$MediaRoot'):"
    $missing | ForEach-Object { Write-Warning "  - $_" }
}

# 6. Prune assets no longer referenced
$keep = $imageNames
Get-ChildItem -Path $AssetsDir -File | Where-Object { -not $keep.Contains($_.Name) } | ForEach-Object {
    Write-Host "Pruning  $($_.Name)"
    Remove-Item $_.FullName -Force
}

Write-Host "Done."
