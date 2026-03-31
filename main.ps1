function cfolder {
    param(
        [Parameter(Position=0)]
        [string]$First,
        [Parameter(Position=1)]
        [string]$Second,
        [switch]$Help,
        [string]$find
    )

    if ($Help) {
        Write-Host "Usage:" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "  " -NoNewline; Write-Host "cfolder <path> <name>" -ForegroundColor Green -NoNewline; Write-Host "   -> Creates a folder with the given name at the specified path."
        Write-Host "  " -NoNewline; Write-Host "cfolder cr <name>" -ForegroundColor Green -NoNewline; Write-Host "   -> Creates a folder with the given name in the current directory."
        Write-Host "  " -NoNewline; Write-Host "cfolder -find <name>" -ForegroundColor Green -NoNewline; Write-Host "   -> Finds all folders with the given name."
        return
    }

  
    if ($find) {
        $results = Get-ChildItem -Path C:\ -Recurse -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -eq $find }
        if (-not $results) {
            Write-Output "No folders found with name: $find"
            return
        }

        $limit = 5
        $shown = $results | Select-Object -First $limit
        foreach ($r in $shown) {
            Write-Output $r.FullName
        }

        if ($results.Count -gt $limit) {
            Write-Output "... see more (type more)"
            $global:cfolder_results = $results
        }
        return
    }


    if ($First -eq "cr") {
        $Path = Get-Location
        $Name = $Second
    }
    else {
        $Path = $First
        $Name = $Second
    }

    if (-not $Path -or -not $Name) {
        Write-Output "Error: You must provide both path and name, or use 'cr' for current directory, or write cfolder -help."
        return
    }

    $FullPath = Join-Path -Path $Path -ChildPath $Name
    New-Item -ItemType Directory -Path $FullPath -Force | Out-Null
    Write-Output "Folder created at: $FullPath"
}

function more {
    if ($global:cfolder_results) {
        foreach ($r in $global:cfolder_results) {
            Write-Output $r.FullName
        }
        $global:cfolder_results = $null
    }
    else {
        Write-Output "No more results stored."
    }
}
