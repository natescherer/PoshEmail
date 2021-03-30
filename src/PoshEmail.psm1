# NOTE: Don't add any code to this file. Put functions you want to export from this module in the 'Public' directory
# in the format 'This-IsFunctionName.ps1'. Put functions that are only used internally by this module in the 'Private'
# directory in the same name format.

$PrivateFiles = Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -Recurse
foreach ($PrivateFile in $PrivateFiles) {
    . $PrivateFile.FullName
}

$FunctionsToExport = @()
$PublicFiles = Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -Recurse
foreach ($PublicFile in $PublicFiles) {
    . $PublicFile.FullName
    $FunctionsToExport += [io.path]::GetFileNameWithoutExtension($PublicFile.FullName)
}

Export-ModuleMember -Function $FunctionsToExport