$dest = "AOC"
New-Item -ItemType Directory -Force -Path $dest | Out-Null

# Get only files from "Annual Returns and Balance Sheet eForms" folders (and their subfolders)
Get-ChildItem -Recurse -File | Where-Object {
    ($_.DirectoryName -match "Annual Returns and Balance Sheet eForms") -and
    ($_.Name -like 'Form AOC*' -or $_.Name -like 'Form MGT*') -and
    ($_.DirectoryName -notlike "*\$dest*")  # Exclude target folder
} | ForEach-Object {
    # If file has no extension, treat it as .pdf
    $baseName = $_.BaseName
    $ext = if ([string]::IsNullOrEmpty($_.Extension)) { ".pdf" } else { $_.Extension }

    $name = "$baseName$ext"
    $target = Join-Path $dest $name

    # Handle duplicates
    if (Test-Path $target) {
        $i = 1
        do {
            $newName = "{0}({1}){2}" -f $baseName, $i, $ext
            $target = Join-Path $dest $newName
            $i++
        } while (Test-Path $target)
    }

    Copy-Item $_.FullName $target
}
