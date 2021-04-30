# PoshEmail

[![Windows PowerShell 5.1](https://gist.github.com/natescherer/a2b45064937a7332c60c6cbbdadd61db/raw/b0a47e1106a808c4c90ac872d00acf6600819564/PoshEmail_TestResults_Windows_powershell.md_badge.svg)](https://gist.github.com/natescherer/a2b45064937a7332c60c6cbbdadd61db) [![PowerShell 7 on Windows](https://gist.github.com/natescherer/797ca586d176e0af436182c772e35c24/raw/4602f1d3e83979875f7be256f4d71d8a9bddb909/PoshEmail_TestResults_Windows_pwsh.md_badge.svg)](https://gist.github.com/natescherer/797ca586d176e0af436182c772e35c24) [![PowerShell 7 on Linux](https://gist.github.com/natescherer/3322138e20633eedefb88c22bc27346a/raw/faa3032c6c78202defaec43b1c183a98b769a86a/PoshEmail_TestResults_Linux_pwsh.md_badge.svg)](https://gist.github.com/natescherer/3322138e20633eedefb88c22bc27346a) [![PowerShell 7 on macOS](https://gist.github.com/natescherer/0776b2b971957aa9ef92363e77c470c8/raw/9f4160ffc57f43f714c3188624a75433854c5df6/PoshEmail_TestResults_macOS_pwsh.md_badge.svg)](https://gist.github.com/natescherer/0776b2b971957aa9ef92363e77c470c8) [![Code Coverage](https://gist.github.com/natescherer/797ca586d176e0af436182c772e35c24/raw/04ecd27a7b150e87015cbd1523d19cd318538a35/PoshEmail_TestResults_Windows_pwsh_Coverage_badge.svg)](https://gist.github.com/natescherer/797ca586d176e0af436182c772e35c24)

<!-- REPLACER START: desc -->
A PowerShell module for sending responsive HTML email.
<!-- REPLACER END: desc -->

## Getting Started

PoshEmail is supported on with Windows PowerShell 5.1 and PowerShell 7 on Windows/Linux/macOS.

### Prerequisites

No prerequisites are required beyond having PowerShell installed.

### Installing

PoshEmail is listed in the PowerShell Gallery [here](https://www.powershellgallery.com/packages/PoshEmail), which means you can install on any internet-connected computer running PowerShell 5.1+ by running this command:

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
    Body = "This is an alert message."
    SmtpServer = "smtp.office365.com" 
    Port = 587
    Credential = $CredentialObject
}
Send-HtmlMailMessage @EmailSplat
```

Sends a message.

### Send-HtmlMailMessage with custom colors

```PowerShell
$EmailSplat = @{
    To = "admin@contoso.com"
    From = "poshemail@contoso.com"
    Subject = "Alert"
    Heading = "Alert"
    Body = "This is an alert message."
    SmtpServer = "smtp.office365.com" 
    Port = 587
    Credential = $CredentialObject
    $ColorScheme = @{
            BodyTextColor = "#000000"
            BackgroundColor = "#f6f6f6"
            ContainerColor = "#ffffff"
            HeadingTextColor = "#000000"
            FooterTextColor = "#999999"
            LinkColor = "#999999"
            ButtonColor = "#3498db"
            ButtonTextColor = "#ffffff"
        }
}
Send-HtmlMailMessage @EmailSplat
```

Note that the colors shown are the default colors, and you must specify all shown colors if you wish to use a custom ColorScheme.

### Documentation

For detailed documentation, [click here on GitHub](docs), see the docs folder in a release, or run Get-Help for the individual function in PowerShell.

## Questions/Comments

If you have questions, comments, etc, please enter a GitHub Issue with the "question" tag.

## Contributing/Bug Reporting

Contributions and bug reports are gladly accepted! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## Building

If you fork into your own repo, you can build and test via GitHub Actions.

## Authors

**Nate Scherer** - *Initial work* - [natescherer](https://github.com/natescherer)

## License

This project is licensed under The MIT License - see [LICENSE](LICENSE) for details.

## Acknowledgements

[leemunroe](https://github.com/leemunroe/responsive-html-email-template) - The core email formatting of PoshEmail is built on leemunroe's "Really Simple Free Responsive HTML Email Template".
