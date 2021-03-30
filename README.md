# PoshEmail

[![Build Status](https://img.shields.io/azure-devops/build/natescherer/poshemail/3.svg?logo=azuredevops)](https://dev.azure.com/natescherer/poshemail/_build/latest?definitionId=3&branchName=master) ![Tests](https://img.shields.io/azure-devops/tests/natescherer/poshemail/3.svg?logo=azuredevops) ![Code Coverage](https://img.shields.io/azure-devops/coverage/natescherer/poshemail/3.svg?logo=azuredevops) ![Open Issues](https://img.shields.io/github/issues-raw/natescherer/poshemail.svg?logo=github)

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
