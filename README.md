# PoshEmail

![Appveyor Build Status](https://ci.appveyor.com/api/projects/status/github/natescherer/PoshEmail?svg=true&branch=master)

PoshEmail is a PowerShell module designed to provide useful email tasks, including the following:

- Wrapping of commands and scripts to provide email alerts when they start/finish, via Invoke-CommandWithEmailWrapper
- Easy sending of responsive HTML emails via Send-HtmlMailMessage

## Getting Started

PoshEmail is designed to be cross-platform and fully compatible with Windows PowerShell 5.0+ and PowerShell Core 6.0+.

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

Examples Here

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
