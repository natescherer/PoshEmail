# Line break for readability in Appveyor console
Write-Host -Object ''

# Make sure we're using the Master branch and that it's not a pull request
# Environmental Variables Guide: https://www.appveyor.com/docs/environment-variables/
if ($env:APPVEYOR_REPO_BRANCH -ne 'master') {
    Write-Warning -Message "Branch wasn't master, skipping Publish-Module."
} elseif ($env:DeployMode -eq "true") {
    Write-Host "Starting Deploy to PowerShell Gallery..."
    # Publish the new version to the PowerShell Gallery
    try {
        $PM = @{
            Path = "$PSScriptRoot\out\$env:APPVEYOR_PROJECT_NAME"
            NuGetApiKey = $env:NuGetApiKey
            ErrorAction = "Stop"
        }
        Publish-Module @PM
        Write-Host "$($env:APPVEYOR_PROJECT_NAME) PowerShell Module version $ReleaseVersion published to the PowerShell Gallery." -ForegroundColor Cyan
    }
    catch {
        Write-Warning "Publishing update $ReleaseVersion to the PowerShell Gallery failed."
        throw $_
    }
} else {
    Write-Warning -Message "Branch was master, but commit message did not include '!Deploy', so deploying module to Appveyor NuGet."
    # Publish to AppVeyor NuGet Only
    try {
        Register-PSRepository -Name "AppveyorNuGetFeed" -SourceLocation $env:AppveyorNuGetFeed -PublishLocation $env:AppveyorNuGetFeed
        $PM = @{
            Path = "$PSScriptRoot\out\$env:APPVEYOR_PROJECT_NAME"
            Repository = "AppveyorNuGetFeed"
            NuGetApiKey = $env:AppveyorNuGetApiKey
            ErrorAction = "Stop"
        }
        Publish-Module @PM
        Write-Host "$($env:APPVEYOR_PROJECT_NAME) PowerShell Module version $ReleaseVersion published to the Appveyor NuGet Feed." -ForegroundColor Cyan
    }
    catch {
        Write-Warning "Publishing update $ReleaseVersion to the Appveyor NuGet feed failed."
        throw $_
    }
}