function Invoke-CommandWithEmailWrapper {
    <#
    .SYNOPSIS
        Executes a Script or Command via Invoke-Command, and provide email alerts either before or before and after execution.

    .DESCRIPTION
        Executes a Script or Command either locally on on a remote computer. Provides output of Script/Command
        via email after execution completes. Optionally sends an additional email alert at the start of execution.

    .INPUTS
        No inputs

    .OUTPUTS
        Outputs whatever the Script/Command you are invoking outputs.

    .EXAMPLE
        Invoke-CommandWithEmailWrapper -Command "robocopy c:\source d:\dest" -JobName "RoboCopy" -SmtpServer "smtp01" -EmailTo "admin@contoso.com"

        Executes the robocopy command in the Command on the local computer, then sends an email with the command's
        output once it completes.
    
    .EXAMPLE
        Invoke-CommandWithEmailWrapper -Script "c:\scripts\script1.ps1" -JobName "Script1" -SmtpServer "smtp01" -EmailTo "admin@contoso.com" -ComputerName "serv01" -EmailMode "BeforeAndAfter"

        Executes the the script c:\scripts\script1.ps1 (on the local computer) on the remote computer "serv01", sending
        emails when the script begins and finishes running.

    .LINK
        https://github.com/natescherer/PoshEmail
    #>

    [CmdletBinding()]
    param(
        [parameter(ParameterSetName = "Script", Mandatory = $false)]
        [parameter(ParameterSetName = "Command", Mandatory = $false)]
        # Computer to execute the command on. Defaults to localhost.
        [string]$ComputerName,

        [parameter(ParameterSetName = "Script", Mandatory = $true)]
        [ValidateScript( { Test-Path -Path $_ })]
        # Script to execute.
        [string]$Script,

        [parameter(ParameterSetName = "Command", Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        # Command to execute.
        [string]$Command,

        [parameter(ParameterSetName = "Script", Mandatory = $true)]
        [parameter(ParameterSetName = "Command", Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        # A short job name to include in emails to identify this execution.
        [string]$JobName,

        [parameter(ParameterSetName = "Script", Mandatory = $true)]
        [parameter(ParameterSetName = "Command", Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        # Specifies SMTP server used to send email
        [string]$SmtpServer,

        [parameter(ParameterSetName = "Script", Mandatory = $false)]
        [parameter(ParameterSetName = "Command", Mandatory = $false)]
        # Specifies to send mail either After or BeforeAndAfter command execution. Defaults to After.
        [ValidateSet("After", "BeforeAndAfter")] 
        [string]$EmailMode = "After",

        [parameter(ParameterSetName = "Script", Mandatory = $false)]
        [parameter(ParameterSetName = "Command", Mandatory = $false)]
        # TCP Port to connect to SMTP server on. Defaults to 25.
        [int]$SmtpPort = 25,

        [parameter(ParameterSetName = "Script", Mandatory = $true)]
        [parameter(ParameterSetName = "Command", Mandatory = $true)]
        # Specifies a source address for messages.
        [string]$EmailFrom,

        [parameter(ParameterSetName = "Script", Mandatory = $true)]
        [parameter(ParameterSetName = "Command", Mandatory = $true)]
        # Specifies a comma-separated (i.e. "a@b.com","b@b.com") list of email addresses to email upon job completion
        [string[]]$EmailTo,

        [parameter(ParameterSetName = "Script", Mandatory = $false)]
        [parameter(ParameterSetName = "Command", Mandatory = $false)]
        # Indicates that the cmdlet uses the Secure Sockets Layer (SSL) protocol to establish a connection to the remote computer to send mail. Defaults to $true
        [bool]$EmailUseSsl = $true,

        [parameter(ParameterSetName = "Script", Mandatory = $false)]
        [parameter(ParameterSetName = "Command", Mandatory = $false)]
        # Some non-PowerShell commands send non-error output to PowerShell's error or warning streams. Adding this option will redirect all streams to output to prevent this.
        [bool]$RedirectStreams = $false
    )

    if ($ComputerName) {
        $FriendlyComputerName = $ComputerName
    }
    else {
        $FriendlyComputerName = $env:computername
    }

    $StartTime = Get-Date

    if ($EmailMode -like "BeforeAndAfter") {
        $SmtpParamsBefore = @{
            From       = $EmailFrom
            To         = $EmailTo
            Subject    = "'$JobName' Started on $FriendlyComputerName"
            Heading    = "'$JobName' Started on $FriendlyComputerName at $StartTime"
            Body       = "'$JobName' Started on $FriendlyComputerName at $StartTime"
            SmtpServer = $SmtpServer
            Port       = $SmtpPort
            UseSsl     = $EmailUseSsl
        }
        Send-HtmlMailMessage @SMTPParamsBefore
    }

    $InvokeCommandParams = @{
        ErrorVariable       = $CommandVariable
        WarningVariable     = $CommandWarning
        InformationVariable = $CommandInfo
    }
    if ($Command) {
        if ($IsWindows -or ($PSVersionTable.PSVersion.Major -le 5)) {
            $TempFilePath = "$env:TMP\EmailWrappedCommand.ps1"
        }
        else {
            $TempFilePath = "$env:TMPDIR/EmailWrappedCommand.ps1"
        }
        Out-File -FilePath $TempFilePath -InputObject $Command
        if ($RedirectStreams) {
            $InvokeCommandParams += @{ ScriptBlock = { & $TempFilePath *>&1 } }
        }
        else {
            $InvokeCommandParams += @{ FilePath = $TempFilePath }
        }
    }
    if ($Script) {
        if ($RedirectStreams) {
            $InvokeCommandParams += @{ ScriptBlock = { & $Script *>&1 } }
        }
        else {
            $InvokeCommandParams += @{ FilePath = $Script }
        }
    }
    if ($ComputerName) {
        $InvokeCommandParams += @{ ComputerName = $ComputerName }
    }

    $CommandOutput = Invoke-Command @InvokeCommandParams
    Write-Host $CommandOutput
    $CommandString = $CommandOutput | Out-String

    if ($EmailMode -like "*After") {
        $EndTime = Get-Date
        $Elapsed = $EndTime - $StartTime
        $ElapsedString = ("$($Elapsed.days) Days $($Elapsed.Hours) Hours $($Elapsed.Minutes) Minutes " +
            "$($Elapsed.Seconds) Seconds")

        $SmtpParamsAfter = @{
            From             = $EmailFrom
            To               = $EmailTo
            Subject          = "'$JobName' Finished on $FriendlyComputerName"
            Heading          = "'$JobName' Finished on $FriendlyComputerName at $EndTime"
            Body             = "Output:"
            BodyPreformatted = $CommandString
            Footer           = "Time elapsed: $ElapsedString"
            SmtpServer       = $SmtpServer
            Port             = $SmtpPort
            UseSsl           = $EmailUseSsl
        }

        Send-HtmlMailMessage @SMTPParamsAfter
    }

    $CommandOutput
}