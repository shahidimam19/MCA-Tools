$destAOC = "AOC"
$destMGT = "MGT"

# Create folders if not exist
New-Item -ItemType Directory -Force -Path $destAOC | Out-Null
New-Item -ItemType Directory -Force -Path $destMGT | Out-Null

# Get files recursively
Get-ChildItem -Recurse -File | Where-Object {
    ($_.DirectoryName -match "Annual Returns and Balance Sheet eForms") -and
    (($_.Name -match 'Form AOC*' -or $_.Name -match 'Form MGT*')) -and
    ($_.Name -match "2024" -or $_.Name -match "2025") -and
    ($_.DirectoryName -notlike "*$destAOC*") -and
    ($_.DirectoryName -notlike "*$destMGT*")
} | ForEach-Object {
    # If file has no extension, treat it as .pdf
    $baseName = $_.BaseName
    $ext = if ([string]::IsNullOrEmpty($_.Extension)) { ".pdf" } else { $_.Extension }
    $name = "$baseName$ext"

    # Decide destination folder based on form type
    if ($_.Name -match "Form AOC*") {
        $target = Join-Path $destAOC $name
    } else {
        $target = Join-Path $destMGT $name
    }

    # Handle duplicates
    if (Test-Path $target) {
        $i = 1
        do {
            $newName = "{0}({1}){2}" -f $baseName, $i, $ext
            $target = Join-Path (Split-Path $target -Parent) $newName
            $i++
        } while (Test-Path $target)
    }

    Copy-Item $_.FullName $target
}
