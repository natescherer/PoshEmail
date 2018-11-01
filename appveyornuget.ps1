# Line break for readability in Appveyor console
Write-Host -Object ''

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Function Register-PSRepositoryFix {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)]
        [string]$Name,
    
        [Parameter(Mandatory=$true)]
        [string]$SourceLocation,
    
        [ValidateSet('Trusted', 'Untrusted')]
        [string]$InstallationPolicy = 'Trusted'
    )
    
    $ErrorActionPreference = 'Stop'
    
    Try {
        Write-Host 'Trying to register via ​Register-PSRepository'
        ​Register-PSRepository -Name $Name -SourceLocation $SourceLocation -InstallationPolicy $InstallationPolicy
        Write-Host 'Registered via Register-PSRepository'
    } Catch {
        Write-Host 'Register-PSRepository failed, registering via workaround'
    
        # Adding PSRepository directly to file
        Register-PSRepository -name $Name -SourceLocation $env:TEMP -InstallationPolicy $InstallationPolicy
        $PSRepositoriesXmlPath = "$env:LOCALAPPDATA\Microsoft\Windows\PowerShell\PowerShellGet\PSRepositories.xml"
        $repos = Import-Clixml -Path $PSRepositoriesXmlPath
        $repos[$Name].SourceLocation = $SourceLocation
        $repos[$Name].PublishLocation = $SourceLocation + "package/"
        $repos[$Name].ScriptSourceLocation = $SourceLocation + "items/psscript/"
        $repos[$Name].ScriptPublishLocation = $SourceLocation + "package/"
        $repos | Export-Clixml -Path $PSRepositoriesXmlPath
    
        # Reloading PSRepository list
        Set-PSRepository -Name $Name -InstallationPolicy Untrusted
        Write-Host 'Registered via workaround'
    }

    Get-PSRepository | fl
}

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

        Register-PSRepositoryFix -Name "AppveyorNuGetFeed" -SourceLocation $env:AppveyorNuGetFeed
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