# Script to automatically install the project fonts for the local user.

$FontFolder = Get-Item -Path "../fonts"
$FontDestination = Get-Item -Path "$env:USERPROFILE\Appdata\Local\Microsoft\Windows\Fonts"

# Get all font files
$FontList = Get-ChildItem -Path "$FontFolder\*" -Recurse -Include ('*.otf','*.ttf')

foreach ($FontFile in $FontList) {
  $DestinationPath = Join-Path $FontDestination $FontFile.Name

  # Check to see if the path exists
  If (-not(Test-Path $DestinationPath)) {
    Write-Host 'Installing font -' $FontFile.Name

    # Install the font in the directory
    Copy-Item -Path $FontFile.FullName -Destination $FontDestination

    # Create registry value referencing font filename
    New-ItemProperty -Name $FontFile.BaseName -Path "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -PropertyType string -Value $DestinationPath -Force -ErrorAction stop | Out-Null
  }
}
