# PoshEmail

![Open Issues](https://img.shields.io/github/issues-raw/natescherer/poshemail.svg?logo=github)

| Platform | Test Results |
| --- | --- |
| Windows PowerShell 5.1 | [![Windows PowerShell 5.1](https://gist.github.com/natescherer/a2b45064937a7332c60c6cbbdadd61db/raw/b0a47e1106a808c4c90ac872d00acf6600819564/PoshEmail_TestResults_Windows_powershell.md_badge.svg)](https://gist.github.com/natescherer/a2b45064937a7332c60c6cbbdadd61db) |
| PowerShell 7 on Windows |[![PowerShell 7 on Windows](https://gist.github.com/natescherer/797ca586d176e0af436182c772e35c24/raw/cb57765e1582bbe785319b0827edb117d9d061b4/PoshEmail_TestResults_Windows_pwsh.md_badge.svg)](https://gist.github.com/natescherer/797ca586d176e0af436182c772e35c24) |
| PowerShell 7 on Linux | [![PowerShell 7 on Linux](https://gist.github.com/natescherer/3322138e20633eedefb88c22bc27346a/raw/ee6562aa5e35f402889f801c4d7feb59e6fb6a8a/PoshEmail_TestResults_Linux_pwsh.md_badge.svg)](https://gist.github.com/natescherer/3322138e20633eedefb88c22bc27346a) |
| PowerShell 7 on macOS | [![PowerShell 7 on macOS](https://gist.github.com/natescherer/0776b2b971957aa9ef92363e77c470c8/raw/9f4160ffc57f43f714c3188624a75433854c5df6/PoshEmail_TestResults_macOS_pwsh.md_badge.svg)](https://gist.github.com/natescherer/0776b2b971957aa9ef92363e77c470c8) |

[![Build Status](https://img.shields.io/azure-devops/build/natescherer/poshemail/3.svg?logo=azuredevops)](https://dev.azure.com/natescherer/poshemail/_build/latest?definitionId=3&branchName=master) ![Code Coverage](https://img.shields.io/azure-devops/coverage/natescherer/poshemail/3.svg?logo=azuredevops) 

PoshEmail is a PowerShell module designed to send responsive HTML email easily from PowerShell.

## Getting Started

PoshEmail is compatible with Windows PowerShell 5.1+ and PowerShell Core 6.0+ on Windows. Linux/macOS support is currently under development.

### Prerequisites

No prerequisites are required beyond having PowerShell installed.

### Installing

PoshEmail is listed in the PowerShell Gallery [here](https://www.powershellgallery.com/packages/PoshEmail), which means you can install on any internet-connected computer running PowerShell 5+ by running this command:

```PowerShell
Install-Module -Name PoshEmail
```

If you'd prefer to install manually, follow these instructions:

1. Download the latest release from [releases](../../releases).
1. Extract it, then run the following to install

    ```PowerShell
    Install-Module -Path EXTRACTION-PATH-HERE\PoshEmail
    ```

## Usage

### Examples

#### Send-HtmlMailMessage

```PowerShell
$EmailSplat = @{
    To = "admin@contoso.com"
    Cc = "admin2@contoso.com"
    From = "poshemail@contoso.com"
    Subject = "Alert"
    Heading = "Alert"
    Footer = "Sent at $((Get-Date).ToUniversalTime() | Get-Date -format s) UTC"
    LastLine = ""
    Body = "This is an alert message."
    SmtpServer = "smtp.office365.com" 
    UseSsl = $true
    Port = 587
    Credential = $CredentialObject
}
Send-HtmlMailMessage @EmailSplat
```

Sends a message.

#### Wrapping Commands

Previous versions of this module included a command "Invoke-CommandWithEmailWrapper". This has been removed as it didn't work well on Linux and macOS, and it is recommended you use the following to provide the same functionality if you need it:

```PowerShell
$Output = ENTERYOURCOMMANDHERE
$EmailSplat = @{
    To = "admin@contoso.com"
    Cc = "admin2@contoso.com"
    From = "poshemail@contoso.com"
    Subject = "Command Finished"
    Body = "Output:"
    BodyPreformatted = $Output
    SmtpServer = "smtp.office365.com" 
    UseSsl = $true
    Port = 587
    Credential = $CredentialObject
}
Send-HtmlMailMessage @EmailSplat
```

### Documentation

For detailed documentation, [click here on GitHub](docs), see the docs folder in a release, or run Get-Help for the individual function in PowerShell.

## Questions/Comments

If you have questions, comments, etc, please enter a GitHub Issue with the "question" tag.

## Contributing/Bug Reporting

Contributions and bug reports are gladly accepted! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## Building

If you fork into your own repo, you can build through Appveyor by updating the environment section at the top of [appveyor.yml](appveyor.yml).

Local builds can be done via Invoke-Build with the following modules installed:

- InvokeBuild
- platyPs
- MarkdownToHtml
- BuildHelpers

## Authors

**Nate Scherer** - *Initial work* - [natescherer](https://github.com/natescherer)

## License

This project is licensed under The MIT License - see [LICENSE](LICENSE) for details.

## Acknowledgements

[leemunroe](https://github.com/leemunroe/responsive-html-email-template) - The core email formatting of PoshEmail is built on leemunroe's "Really Simple Free Responsive HTML Email Template".
