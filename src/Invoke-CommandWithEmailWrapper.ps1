$Eol = [System.Environment]::NewLine

. .\New-HtmlEmailBody.ps1

function Invoke-CommandWithEmailWrapper {
    <#
    .SYNOPSIS
        A brief description of the function.

    .DESCRIPTION
        A longer description.

    .INPUTS
        Description of objects that can be piped to the function

    .OUTPUTS
        Description of objects that are output by the function

    .EXAMPLE
        Example of how to run the function

    .LINK
        Links to further documentation

    .NOTES
        Detail on what the function does, if this is needed
    #>

    [CmdletBinding(DefaultParameterSetName="Script")]
    param (
        [parameter(ParameterSetName="Script",Mandatory=$false)]
        [parameter(ParameterSetName="ScriptBlock",Mandatory=$false)]
        # Computer to execute the command on. Defaults to localhost.
        [string]$ComputerName,

        #[parameter(ParameterSetName="Script",Mandatory=$false)]
        #[parameter(ParameterSetName="ScriptBlock",Mandatory=$false)]
        # Whether or not to use CredSSP to connect to remote computer. CredSSP must have already been configured in
        # your environment for this to work; consult MS documentation. If you use this option, you will be prompted
        # for credentials when you run this script.
        #[switch]$CredSsp,

        [parameter(ParameterSetName="Script",Mandatory=$false)]
        [ValidateScript({Test-Path -Path $_})]
        # Script to execute.
        [string]$Script,

        [parameter(ParameterSetName="ScriptBlock",Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        # ScriptBlock to execute.
        [scriptblock]$ScriptBlock,

        [parameter(ParameterSetName="Script",Mandatory=$true)]
        [parameter(ParameterSetName="ScriptBlock",Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        # A short job name to include in emails to identify this execution.
        [string]$JobName,

        [parameter(ParameterSetName="Script",Mandatory=$true)]
        [parameter(ParameterSetName="ScriptBlock",Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        # Specifies SMTP server used to send email
        [string]$SmtpServer,
    
        [parameter(ParameterSetName="Script",Mandatory=$true)]
        [parameter(ParameterSetName="ScriptBlock",Mandatory=$true)]
        # Specifies to send mail either Before, After, or BeforeAndAfter command execution
        [ValidateSet("Before","After","BeforeAndAfter")] 
        [string]$EmailMode,
    
        [parameter(ParameterSetName="Script",Mandatory=$false)]
        [parameter(ParameterSetName="ScriptBlock",Mandatory=$false)]
        # TCP Port to connect to SMTP server on. Defaults to 25.
        [int]$SmtpPort = 25,
    
        [parameter(ParameterSetName="Script",Mandatory=$false)]
        [parameter(ParameterSetName="ScriptBlock",Mandatory=$false)]
        # Specifies a source address for messages. Defaults to computername@domain
        [string]$EmailFrom = "$($env:computername)@$($env:userdnsdomain)",
    
        [parameter(ParameterSetName="Script",Mandatory=$true)]
        [parameter(ParameterSetName="ScriptBlock",Mandatory=$true)]
        # Specifies a comma-separated (i.e. "a@b.com","b@b.com") list of email addresses to email upon job completion
        [string[]]$EmailTo
    )

    process {
        try {
            $global:ProgressPreference = "SilentlyContinue"
            Test-NetConnection -ComputerName $SmtpServer -Port $SmtpPort -InformationLevel Quiet | Out-Null
            $global:ProgressPreference = "Continue"
        }
        catch {
            throw "Unable to connect to $SmtpServer on port $SmtpPort to send email."
        }

        if ($ComputerName) {
            $FriendlyComputerName = $ComputerName
        } else {
            $FriendlyComputerName = $env:computername
        }

        $StartTime = Get-Date

        if ($EmailMode -like "Before*") {
            $SmtpParamsBefore = @{
                From = $EmailFrom
                To = $EmailTo
                Subject = "'$JobName' Started on $FriendlyComputerName"
                Body = New-HtmlEmailBody -Header "'$JobName' Started on $FriendlyComputerName at $StartTime"
                BodyAsHtml = $true
                SmtpServer = $SmtpServer
                Port = $SmtpPort
                UseSsl = $true
            }
            Send-MailMessage @SMTPParamsBefore
        }

        $InvokeCommandParams = @{
            ErrorVariable = $CommandVariable
            WarningVariable = $CommandWarning
            InformationVariable = $CommandInfo
        }
        if ($ScriptBlock) {
            $InvokeCommandParams += @{ ScriptBlock = { & $ScriptBlock *>&1 } }
        }
        if ($Script) {
            $InvokeCommandParams += @{ ScriptBlock = { & $Script *>&1 } }
        }
        if ($ComputerName) {
            $InvokeCommandParams += @{ ComputerName = $ComputerName }
        }

        [array]$CommandOutput = Invoke-Command @InvokeCommandParams

        if ($EmailMode -like "*After") {
            $EndTime = Get-Date
            $Elapsed = $EndTime - $StartTime
            $ElapsedString = ("$($Elapsed.days) Days $($Elapsed.Hours) Hours $($Elapsed.Minutes) Minutes " +
                "$($Elapsed.Seconds) Seconds")
    
            $HtmlBodyParamsAfter = @{
                Header = "'$JobName' Finished on $FriendlyComputerName at $EndTime"
                Data = ("Output:<br><pre>$($CommandOutput -join $Eol)</pre>")
                Footer = "Time elapsed: $ElapsedString"
            }

            $SmtpParamsAfter = @{
                From = $EmailFrom
                To = $EmailTo
                Subject = "'$JobName' Finished on $FriendlyComputerName"
                Body =  New-HtmlEmailBody @HtmlBodyParamsAfter
                BodyAsHtml = $true
                SmtpServer = $SmtpServer
                Port = $SmtpPort
                UseSsl = $true
            }

            Send-MailMessage @SMTPParamsAfter
        }
    }
}