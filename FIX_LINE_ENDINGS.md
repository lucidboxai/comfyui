# Fixing Line Ending Issues

## Problem
"cannot execute: required file not found" error occurs because shell scripts have Windows CRLF line endings instead of Linux LF.

## Quick Fix (Recommended)

Run this PowerShell command in the base-image directory to fix all shell scripts:

```powershell
cd C:\Users\User\Documents\Code\base-image

# Fix all .sh files to use LF line endings
Get-ChildItem -Path . -Filter *.sh -Recurse | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    $content = $content -replace "`r`n", "`n"
    [System.IO.File]::WriteAllText($_.FullName, $content, [System.Text.UTF8Encoding]::new($false))
    Write-Host "Fixed: $($_.FullName)"
}
```

## Alternative: Use Git to Fix

If you have git installed:

```powershell
cd C:\Users\User\Documents\Code\base-image

# Configure git to handle line endings
git config core.autocrlf input

# Re-normalize all files
git add --renormalize .
git commit -m "Fix line endings"
```

## Long-term Solution

I've created a `.gitattributes` file that will ensure all shell scripts use LF line endings going forward. 

The Dockerfile has also been updated to fix line endings during the build as a safety measure.

## Verify Fix

After fixing, check a script file:

```powershell
# Check line endings (should show "LF" not "CRLF")
Get-Content build\COPY_ROOT_0\opt\ai-dock\bin\build\layer0\init.sh -Raw | Select-String "`r`n"
# If no output, line endings are correct
```

## Apply Same Fix to Other Repos

You'll need to fix line endings in:
- `base-image` (current issue)
- `python` (will have same issue)
- `comfyui` (will have same issue)

Run the PowerShell fix command in each directory before building.


