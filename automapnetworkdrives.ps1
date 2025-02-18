$netUseFile = '$($Env:OneDrive)\ProfileBackup\netuse.txt'
$lines = Get-Content -Path $netUseFile

foreach ($line in $lines) {
    if ($line -match '^\s*(Status|-----|$)') {
        continue
    }

    $parts = $line -split '\s+', 4

    if ($parts.Count -ge 3) {
        $status       = $parts[0].Trim()
        $driveLetter  = $parts[1].Trim().TrimEnd(':')
        $uncPath      = $parts[2].Trim()

        if ([string]::IsNullOrWhiteSpace($driveLetter) -or [string]::IsNullOrWhiteSpace($uncPath)) {
            continue
        }

        Write-Host "Mapping drive $driveLetter to $uncPath..."

        if (Get-PSDrive -Name $driveLetter -ErrorAction SilentlyContinue) {
            Remove-PSDrive -Name $driveLetter -Force
        }
        New-PSDrive -Name $driveLetter -PSProvider FileSystem -Root $uncPath -Persist -Scope Global
    }
}