$dest = "All_Files"

# Create folder if not exist
New-Item -ItemType Directory -Force -Path $dest | Out-Null

# Get every file recursively
Get-ChildItem -Recurse -File | ForEach-Object {

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
