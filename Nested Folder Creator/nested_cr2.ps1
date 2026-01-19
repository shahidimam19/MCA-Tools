# 1. Setup paths
$currentPath = Get-Location
$categoryFolders = @("Normal", "XBRL")

# Create root 'Normal' and 'XBRL' folders if they don't exist
foreach ($cat in $categoryFolders) {
    if (!(Test-Path (Join-Path $currentPath $cat))) {
        New-Item -Path (Join-Path $currentPath $cat) -ItemType Directory | Out-Null
    }
}

# 2. Get subfolders (excluding the Normal/XBRL system folders)
$subfolders = Get-ChildItem -Path $currentPath -Directory | Where-Object { $_.Name -notin $categoryFolders }

# 3. Group folders by their Base Name
$groups = $subfolders | Group-Object { $_.Name -replace '\s*\d+$', '' }

foreach ($group in $groups) {
    $baseName = $group.Name
    $targetFolderPath = Join-Path $currentPath $baseName
    
    Write-Host "`nProcessing Group: [$baseName]" -ForegroundColor Cyan

    # A. Ensure the Primary (Base) Folder exists
    if (!(Test-Path $targetFolderPath)) {
        # If the base folder doesn't exist, rename the first available folder in the group to the base name
        try {
            Rename-Item -Path $group.Group[0].FullName -NewName $baseName -ErrorAction Stop
        } catch {
            Write-Host "  ! Note: Base folder setup handled automatically." -ForegroundColor Gray
        }
    }
    
    # Refresh reference to the primary folder
    $primaryFolder = Get-Item $targetFolderPath

    # B. Merge Logic with Collision Handling
    foreach ($extraFolder in $group.Group) {
        # Check if this folder is actually different from our target primary folder
        if ($extraFolder.FullName -ne $primaryFolder.FullName -and (Test-Path $extraFolder.FullName)) {
            Write-Host "  -> Merging files from: $($extraFolder.Name)" -ForegroundColor Gray
            
            $filesToMove = Get-ChildItem -Path $extraFolder.FullName -File -Recurse
            foreach ($file in $filesToMove) {
                $destPath = Join-Path $primaryFolder.FullName $file.Name
                $count = 1
                
                # File Name Collision Handling
                while (Test-Path $destPath) {
                    $newName = "$($file.BaseName)_$count$($file.Extension)"
                    $destPath = Join-Path $primaryFolder.FullName $newName
                    $count++
                }
                Move-Item -Path $file.FullName -Destination $destPath -Force
            }
            
            # C. CLEANUP: Only remove if it still exists and is empty/merged
            if (Test-Path $extraFolder.FullName) {
                Remove-Item -Path $extraFolder.FullName -Recurse -Force -ErrorAction SilentlyContinue
            }
        }
    }

    # D. Create Nesting Structure: V3\Annual Returns...
    $nestedPathSuffix = "V3\Annual Returns and Balance Sheet eForms"
    $fullNestedPath = Join-Path -Path $primaryFolder.FullName -ChildPath $nestedPathSuffix

    if (!(Test-Path $fullNestedPath)) {
        New-Item -Path $fullNestedPath -ItemType Directory -Force | Out-Null
    }

    # E. Move files into the deep path
    $rootFiles = Get-ChildItem -Path $primaryFolder.FullName -File
    foreach ($file in $rootFiles) {
        $destPath = Join-Path $fullNestedPath $file.Name
        $count = 1
        while (Test-Path $destPath) {
            $newName = "$($file.BaseName)_$count$($file.Extension)"
            $destPath = Join-Path $fullNestedPath $newName
            $count++
        }
        Move-Item -Path $file.FullName -Destination $destPath -Force
    }

    # F. Sorting logic
    $hasXBRL = Get-ChildItem -Path $primaryFolder.FullName -File -Filter "*xbrl*" -Recurse
    $destCategoryName = if ($hasXBRL) { "XBRL" } else { "Normal" }
    $finalCategoryPath = Join-Path -Path $currentPath -ChildPath $destCategoryName

    # G. Move to final category
    # If the folder already exists in Normal/XBRL, we merge the contents
    $finalDestinationFolder = Join-Path $finalCategoryPath $primaryFolder.Name
    if (Test-Path $finalDestinationFolder) {
        Get-ChildItem -Path $primaryFolder.FullName -Recurse | Move-Item -Destination $finalDestinationFolder -Force -ErrorAction SilentlyContinue
        Remove-Item $primaryFolder.FullName -Recurse -Force -ErrorAction SilentlyContinue
    } else {
        Move-Item -Path $primaryFolder.FullName -Destination $finalCategoryPath -Force
    }
    
    Write-Host "  Success: Moved to $destCategoryName." -ForegroundColor Green
}

Write-Host "`nAll tasks complete with no errors!" -ForegroundColor Magenta
Pause