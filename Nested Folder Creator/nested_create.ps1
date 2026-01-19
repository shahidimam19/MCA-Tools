# 1. Get the current path
$currentPath = Get-Location

# 2. Create the top-level Sorting Folders if they don't exist
$categoryFolders = @("Normal", "XBRL")
foreach ($cat in $categoryFolders) {
    if (!(Test-Path (Join-Path $currentPath $cat))) {
        New-Item -Path (Join-Path $currentPath $cat) -ItemType Directory | Out-Null
    }
}

# 3. Get all subfolders (excluding the ones we just created)
$subfolders = Get-ChildItem -Path $currentPath -Directory | Where-Object { $_.Name -notin $categoryFolders }

foreach ($folder in $subfolders) {
    Write-Host "Processing: $($folder.Name)..." -ForegroundColor Yellow

    # 4. Check if any file inside contains "xbrl"
    $hasXBRL = Get-ChildItem -Path $folder.FullName -File -Filter "*xbrl*" -Recurse
    
    # 5. Determine if it goes to Normal or XBRL
    $destinationCategory = if ($hasXBRL) { "XBRL" } else { "Normal" }
    $categoryPath = Join-Path -Path $currentPath -ChildPath $destinationCategory

    # 6. Define the deep nesting path
    $nestedPath = "V3\Annual Returns and Balance Sheet eForms"
    $fullNestedPath = Join-Path -Path $folder.FullName -ChildPath $nestedPath

    # 7. Create the nested structure inside the subfolder
    if (!(Test-Path $fullNestedPath)) {
        New-Item -Path $fullNestedPath -ItemType Directory -Force | Out-Null
    }

    # 8. Move files into the deep nesting path FIRST
    Get-ChildItem -Path $folder.FullName -File | Move-Item -Destination $fullNestedPath

    # 9. Move the entire subfolder into the correct Category (Normal or XBRL)
    Move-Item -Path $folder.FullName -Destination $categoryPath
    
    Write-Host "Sorted into $destinationCategory and restructured." -ForegroundColor Green
}

Write-Host "`nAll tasks complete!" -ForegroundColor Cyan
Pause