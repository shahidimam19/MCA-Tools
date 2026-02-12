$destAOC = "AOC"
$destMGT = "MGT"

# Create folders if they don't exist
if (!(Test-Path $destAOC)) { New-Item -ItemType Directory -Path $destAOC | Out-Null }
if (!(Test-Path $destMGT)) { New-Item -ItemType Directory -Path $destMGT | Out-Null }

# Get ALL files from ALL subfolders
# Using -Filter with wildcards is often faster and more reliable
Get-ChildItem -Path "." -Recurse -File | Where-Object {
    # 1. Look for filenames containing AOC or MGT
    ($_.Name -like "*AOC*" -or $_.Name -like "*MGT*") -and
    # 2. Safety: Ignore the destination folders so we don't copy files into themselves
    ($_.FullName -notlike "*\$destAOC\*") -and
    ($_.FullName -notlike "*\$destMGT\*")
} | ForEach-Object {

    $baseName = $_.BaseName
    $ext = if ([string]::IsNullOrEmpty($_.Extension)) { ".pdf" } else { $_.Extension }
    $name = "$baseName$ext"

    # Decide destination folder
    if ($_.Name -like "*AOC*") {
        $targetFolder = $destAOC
    } else {
        $targetFolder = $destMGT
    }

    $targetPath = Join-Path $targetFolder $name

    # Handle duplicates: if "File.pdf" exists, make "File(1).pdf"
    if (Test-Path $targetPath) {
        $i = 1
        while (Test-Path $targetPath) {
            $newName = "{0}({1}){2}" -f $baseName, $i, $ext
            $targetPath = Join-Path $targetFolder $newName
            $i++
        }
    }

    # Copy the file and show progress in the console
    Write-Host "Copying: $($_.Name) -> $targetFolder" -ForegroundColor Cyan
    Copy-Item $_.FullName -Destination $targetPath
}

Write-Host "Done! Check the '$destAOC' and '$destMGT' folders." -ForegroundColor Green