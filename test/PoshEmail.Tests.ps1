$ModuleName = Split-Path -Path ($PSCommandPath -replace '\.Tests\.ps1$','') -Leaf
$ModulePath = "$(Split-Path -Path $PSScriptRoot -Parent)\src\$ModuleName.psm1"
Get-Module -Name $ModuleName -All | Remove-Module -Force -ErrorAction Ignore
Import-Module -Name $ModulePath -Force -ErrorAction Stop

InModuleScope $ModuleName {
    $NL = [System.Environment]::NewLine
    $ModuleName = Split-Path -Path ($PSCommandPath -replace '\.Tests\.ps1$','') -Leaf
    $ModulePath = "$(Split-Path -Path $PSScriptRoot -Parent)\src\$ModuleName.psm1"
    $ModuleManifestPath = "$(Split-Path -Path $PSScriptRoot -Parent)\src\$ModuleName.psd1"
    if ($IsWindows -eq $null) {$IsWindows = $true}
    if ($IsWindows) {$TempDir = $env:TEMP}
    if ($IsLinux) {$TempDir = "/tmp"}
    if ($IsMacOS) {$TempDir = $env:TMPDIR}
    $IsntWindows = !$IsWindows
    $ProccessStartSleep = 3
    $EmailSendSleep = 1

    function ConvertTo-NormalBody {
        params (
            [string]$InputObject
        )

        $Output = ""
        $Output = $InputObject -replace "=$NL",""

        $Output = $Output -replace "=0D=0A",$NL
        $Output = $Output -replace "=0A",$NL
        $Output = $Output -replace "=3D","="

        $Output
    }

    Write-Host "`Note that all Pending tests are due to MailHog v1.0.0 lacking features needed to do the test." -ForegroundColor Yellow

    Describe 'Module Manifest Tests' {
        It 'Passes Test-ModuleManifest' {
            Test-ModuleManifest -Path $ModuleManifestPath | Should Not BeNullOrEmpty
            $? | Should Be $true
        }
    }

    Describe 'Send-HtmlMailMessage' {
        It 'Mandatory Params' {

            $ShmmParams = @{
                From = "PoshEmail@test.local"
                To = "rcpt@test.local"
                Subject = "PoshEmail Test"
                SmtpServer = "127.0.0.1"
                Body = "Body Text"
            }

            Send-HtmlMailMessage @ShmmParams

            Start-Sleep -Seconds $EmailSendSleep

            $Response = Invoke-RestMethod -Uri http://localhost:8025/api/v2/messages
            Invoke-RestMethod -Uri http://localhost:8025/api/v1/messages -Method "DELETE" | Out-Null

            $Source = ConvertTo-NormalBody -InputObject $Response.Items[0].Content.Body

            Write-Host $Response.Items[0].Content.Body

            $Source | Should -Be ("<!doctype html>$NL" +
                "<html>$NL" +
                "  <head>$NL" +
                "    <meta name=`"viewport`" content=`"width=device-width`">$NL" +
                "    <meta http-equiv=`"Content-Type`" content=`"text/html; charset=UTF-8`">$NL" +
                "    <title></title>$NL" +
                "    <style>$NL" +
                "    /* -------------------------------------$NL" +
                "        INLINED WITH htmlemail.io/inline$NL" +
                "    ------------------------------------- */$NL" +
                "    /* -------------------------------------$NL" +
                "        RESPONSIVE AND MOBILE FRIENDLY STYLES$NL" +
                "    ------------------------------------- */$NL" +
                "    @media only screen and (max-width: 620px) {$NL" +
                "      table[class=body] h1 {$NL" +
                "        font-size: 28px !important;$NL" +
                "        margin-bottom: 10px !important;$NL" +
                "      }$NL" +
                "      table[class=body] p,$NL" +
                "      table[class=body] ul,$NL" +
                "      table[class=body] ol,$NL" +
                "      table[class=body] td,$NL" +
                "      table[class=body] span,$NL" +
                "      table[class=body] a {$NL" +
                "        font-size: 16px !important;$NL" +
                "      }$NL" +
                "      table[class=body] .preformatted {$NL" +
                "        font-size: 11px !important;$NL" +
                "      }$NL" +
                "      table[class=body] .wrapper,$NL" +
                "            table[class=body] .article {$NL" +
                "        padding: 10px !important;$NL" +
                "      }$NL" +
                "      table[class=body] .content {$NL" +
                "        padding: 0 !important;$NL" +
                "      }$NL" +
                "      table[class=body] .container {$NL" +
                "        padding: 0 !important;$NL" +
                "        width: 100% !important;$NL" +
                "      }$NL" +
                "      table[class=body] .main {$NL" +
                "        border-left-width: 0 !important;$NL" +
                "        border-radius: 0 !important;$NL" +
                "        border-right-width: 0 !important;$NL" +
                "      }$NL" +
                "      table[class=body] .btn table {$NL" +
                "        width: 100% !important;$NL" +
                "      }$NL" +
                "      table[class=body] .btn a {$NL" +
                "        width: 100% !important;$NL" +
                "      }$NL" +
                "      table[class=body] .img-responsive {$NL" +
                "        height: auto !important;$NL" +
                "        max-width: 100% !important;$NL" +
                "        width: auto !important;$NL" +
                "      }$NL" +
                "    }$NL" +
                "$NL" +
                "    /* -------------------------------------$NL" +
                "        PRESERVE THESE STYLES IN THE HEAD$NL" +
                "    ------------------------------------- */$NL" +
                "    @media all {$NL" +
                "      .ExternalClass {$NL" +
                "        width: 100%;$NL" +
                "      }$NL" +
                "      .ExternalClass,$NL" +
                "      .ExternalClass p,$NL" +
                "      .ExternalClass span,$NL" +
                "      .ExternalClass font,$NL" +
                "      .ExternalClass td,$NL" +
                "      .ExternalClass div {$NL" +
                "        line-height: 100%;$NL" +
                "      }$NL" +
                "      .btn-primary table td:hover {$NL" +
                "        background-color: #34495e !important;$NL" +
                "      }$NL" +
                "      .btn-primary a:hover {$NL" +
                "        background-color: #34495e !important;$NL" +
                "        border-color: #34495e !important;$NL" +
                "      }$NL" +
                "    }$NL" +
                "   </style>$NL" +
                "  </head>$NL" +
                "  <body class=`"`" style=`"background-color: #f6f6f6; font-family: sans-serif; -webkit-font-smoothing: antialiased; font-size: 14px; line-height: 1.4; margin: 0; padding: 0; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%;`">$NL" +
                "    <table border=`"0`" cellpadding=`"0`" cellspacing=`"0`" class=`"body`" style=`"border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%; background-color: #f6f6f6;`">$NL" +
                "      <tr>$NL" +
                "        <td style=`"font-family: sans-serif; font-size: 14px; vertical-align: top;`">&nbsp;</td>$NL" +
                "        <td class=`"container`" style=`"font-family: sans-serif; font-size: 14px; vertical-align: top; display: block; margin: 0 auto; max-width: 580px; padding: 10px;`">$NL" +
                "          <div class=`"content`" style=`"box-sizing: border-box; display: block; margin: 0 auto; max-width: 100%; padding: 10px;`">$NL" +
                "$NL" +
                "            <!-- START CENTERED WHITE CONTAINER -->$NL" +
                "            <span class=`"preheader`" style=`"color: transparent; display: none; height: 0; max-height: 0; max-width: 0; opacity: 0; overflow: hidden; mso-hide: all; visibility: hidden; width: 0;`"></span>$NL" +
                "            <table class=`"main`" style=`"border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%; background: #ffffff; border-radius: 3px;`">$NL" +
                "$NL" +
                "              <!-- START MAIN CONTENT AREA -->$NL" +
                "              <tr>$NL" +
                "                <td class=`"wrapper`" style=`"font-family: sans-serif; font-size: 14px; vertical-align: top; box-sizing: border-box; padding: 20px;`">$NL" +
                "                  <table border=`"0`" cellpadding=`"0`" cellspacing=`"0`" style=`"border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%;`">$NL" +
                "                    <tr>$NL" +
                "                      <td style=`"font-family: sans-serif; font-size: 14px; vertical-align: top;`">$NL" +
                "                        <h2 style=`"text-align: center;`"></h2>$NL" +
                "                        <p style=`"font-family: sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 15px; text-align: left;`">Body Text</p>$NL" +
                "                      </td>$NL" +
                "                    </tr>$NL" +
                "                  </table>$NL" +
                "                </td>$NL" +
                "              </tr>$NL" +
                "$NL" +
                "            <!-- END MAIN CONTENT AREA -->$NL" +
                "            </table>$NL" +
                "$NL" +
                "            <!-- START FOOTER -->$NL" +
                "            <div class=`"footer`" style=`"clear: both; margin-top: 10px; text-align: center; width: 100%;`">$NL" +
                "              <table border=`"0`" cellpadding=`"0`" cellspacing=`"0`" style=`"border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%;`">$NL" +
                "                <tr>$NL" +
                "                  <td class=`"content-block`" style=`"font-family: sans-serif; vertical-align: top; padding-bottom: 10px; padding-top: 10px; font-size: 12px; color: #999999; text-align: center;`">$NL" +
                "                  </td>$NL" +
                "                </tr>$NL" +
                "                <tr>$NL" +
                "                  <td class=`"content-block powered-by`" style=`"font-family: sans-serif; vertical-align: top; padding-bottom: 10px; padding-top: 10px; font-size: 12px; color: #999999; text-align: center;`">$NL" +
                "                    Powered by <a style=`"text-decoration: underline; color: #999999; font-size: 12px; text-align: center;`" href=`"https://github.com/natescherer/PoshEmail`">PoshEmail</a>.$NL" +
                "                  </td>$NL" +
                "                </tr>$NL" +
                "              </table>$NL" +
                "            </div>$NL" +
                "            <!-- END FOOTER -->$NL" +
                "$NL" +
                "          <!-- END CENTERED WHITE CONTAINER -->$NL" +
                "          </div>$NL" +
                "        </td>$NL" +
                "        <td style=`"font-family: sans-serif; font-size: 14px; vertical-align: top;`">&nbsp;</td>$NL" +
                "      </tr>$NL" +
                "    </table>$NL" +
                "  </body>$NL" +
                "</html>$NL")
        }
        It '-BodyAlignment' {
            $ShmmParams = @{
                From = "PoshEmail@test.local"
                To = "rcpt@test.local"
                Subject = "PoshEmail Test"
                SmtpServer = "127.0.0.1"
                Body = "Body Text"
                BodyAlignment = "Center"
            }

            Send-HtmlMailMessage @ShmmParams

            Start-Sleep -Seconds $EmailSendSleep

            $Response = Invoke-RestMethod -Uri http://localhost:8025/api/v2/messages
            Invoke-RestMethod -Uri http://localhost:8025/api/v1/messages -Method "DELETE" | Out-Null

            $Source = ConvertTo-NormalBody -InputObject $Response.Items[0].Content.Body

            $Source | Should -Match "<p style=`"font-family: sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 15px; text-align: center;`">Body Text</p>$NL"
        }    
        It '-BodyPreformatted' {
            $ShmmParams = @{
                From = "PoshEmail@test.local"
                To = "rcpt@test.local"
                Subject = "PoshEmail Test"
                SmtpServer = "127.0.0.1"
                Body = "Body Text"
                BodyPreformatted = ("$NL" +
                    "$NL" +
                    "    Directory: C:\code\PoshEmail$NL" +
                    "$NL" +
                    "$NL" +
                    "Mode                LastWriteTime         Length Name$NL" +
                    "----                -------------         ------ ----$NL" +
                    "d-----       10/24/2018   9:27 AM                .vscode$NL" +
                    "d-----       10/11/2018  11:17 AM                docs$NL" +
                    "d-----       10/11/2018  11:17 AM                out$NL" +
                    "d-----       10/25/2018   7:15 AM                src$NL" +
                    "d-----       10/29/2018  11:47 AM                test$NL" +
                    "-a----       10/24/2018   9:27 AM            160 .gitignore$NL" +
                    "-a----       10/29/2018  10:44 AM           6194 appveyor.yml$NL" +
                    "-a----       10/29/2018  10:44 AM           2113 appveyordeploy.ps1$NL" +
                    "-a----        10/5/2018   2:39 PM            351 CHANGELOG.md$NL" +
                    "-a----        10/5/2018   2:51 PM           2095 CONTRIBUTING.md$NL" +
                    "-a----        9/26/2018   2:18 PM           1080 LICENSE$NL" +
                    "-a----       10/24/2018   9:27 AM          14016 PoshEmail.build.ps1$NL" +
                    "-a----       10/24/2018   9:37 AM           1383 README.md")
            }

            Send-HtmlMailMessage @ShmmParams

            Start-Sleep -Seconds $EmailSendSleep

            $Response = Invoke-RestMethod -Uri http://localhost:8025/api/v2/messages
            Invoke-RestMethod -Uri http://localhost:8025/api/v1/messages -Method "DELETE" | Out-Null

            $Source = ConvertTo-NormalBody -InputObject $Response.Items[0].Content.Body

            $Source | Should -Match ("                      </td>$NL" +
                "                    </tr>$NL" +
                "                    <tr>$NL" +
                "                      <td class=`"preformatted`" width=`"100%`" style=`"font-size: 14px; vertical-align: top; max-width: 100%; overflow: auto; padding-top: 15px; padding-right: 15px;background-color: #F5F5F5; border: 1px solid black;`">$NL" +
                "                        <ol class=`"preformatted`">$NL" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`"></span></li>$NL" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`"></span></li>$NL" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">&ensp;&ensp;&ensp;&ensp;Directory:&ensp;C:\\code\\PoshEmail</span></li>$NL" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`"></span></li>$NL" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`"></span></li>$NL" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">Mode&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;LastWriteTime&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;Length&ensp;Name</span></li>$NL" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">----&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;-------------&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;------&ensp;----</span></li>$NL" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">d-----&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;10/24/2018&ensp;&ensp;&ensp;9:27&ensp;AM&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;.vscode</span></li>$NL" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">d-----&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;10/11/2018&ensp;&ensp;11:17&ensp;AM&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;docs</span></li>$NL" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">d-----&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;10/11/2018&ensp;&ensp;11:17&ensp;AM&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;out</span></li>$NL" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">d-----&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;10/25/2018&ensp;&ensp;&ensp;7:15&ensp;AM&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;src</span></li>$NL" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">d-----&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;10/29/2018&ensp;&ensp;11:47&ensp;AM&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;test</span></li>$NL" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">-a----&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;10/24/2018&ensp;&ensp;&ensp;9:27&ensp;AM&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;160&ensp;.gitignore</span></li>$NL" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">-a----&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;10/29/2018&ensp;&ensp;10:44&ensp;AM&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;6194&ensp;appveyor.yml</span></li>$NL" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">-a----&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;10/29/2018&ensp;&ensp;10:44&ensp;AM&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;2113&ensp;appveyordeploy.ps1</span></li>$NL" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">-a----&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;10/5/2018&ensp;&ensp;&ensp;2:39&ensp;PM&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;351&ensp;CHANGELOG.md</span></li>$NL" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">-a----&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;10/5/2018&ensp;&ensp;&ensp;2:51&ensp;PM&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;2095&ensp;CONTRIBUTING.md</span></li>$NL" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">-a----&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;9/26/2018&ensp;&ensp;&ensp;2:18&ensp;PM&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;1080&ensp;LICENSE</span></li>$NL" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">-a----&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;10/24/2018&ensp;&ensp;&ensp;9:27&ensp;AM&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;14016&ensp;PoshEmail.build.ps1</span></li>$NL" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">-a----&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;10/24/2018&ensp;&ensp;&ensp;9:37&ensp;AM&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;1383&ensp;README.md</span></li>$NL" +
                "                        </ol>$NL" +
                "                      </td>$NL" +
                "                    </tr>$NL" +
                "                    <tr>$NL" +
                "                      <td style=`"font-family: sans-serif; font-size: 14px; vertical-align: top;`">$NL" +
                "                        <p style=`"font-family: sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 15px; text-align: left;`">&nbsp;</p>$NL")
        }
        It '-Attachments' {
            # TestDrive doesn't work here because of the module running Send-MailMessage as a Job
            $TestPath = "$TempDir\attachment.txt"
            $FileContents = "This is a line of text with no line breaks so the base64 is the same on all platforms"
            Set-Content -Value $FileContents -Path $TestPath -NoNewline

            $ShmmParams = @{
                From = "PoshEmail@test.local"
                To = "rcpt@test.local"
                Subject = "PoshEmail Test"
                SmtpServer = "127.0.0.1"
                Body = "Body Text"
                Attachments = $TestPath
            }

            Send-HtmlMailMessage @ShmmParams

            Start-Sleep -Seconds $EmailSendSleep

            $Response = Invoke-RestMethod -Uri http://localhost:8025/api/v2/messages
            Invoke-RestMethod -Uri http://localhost:8025/api/v1/messages -Method "DELETE" | Out-Null

            $Source = ConvertTo-NormalBody -InputObject $Response.Items[0].Content.Body

            $Source | Should -Match "VGhpcyBpcyBhIGxpbmUgb2YgdGV4dCB3aXRoIG5vIGxpbmUgYnJlYWtzIHNvIHRoZSBiYXNlNjQgaXMgdGhlIHNhbWUgb24gYWxsIHBsYXRmb3Jtcw="
        }
        It '-Bcc' -Pending {
        }
        It '-Cc' -Pending {
        }
        It '-Credential' -Skip {
            $PSCreds = New-Object System.Management.Automation.PSCredential ("user", (ConvertTo-SecureString "testpassword" -AsPlainText -Force))

            $ShmmParams = @{
                From = "PoshEmail@test.local"
                To = "rcpt@test.local"
                Subject = "PoshEmail Test"
                SmtpServer = "127.0.0.1"
                Body = "Body Text"
                Port = 2025
                Credential = $PSCreds
            }

            Send-HtmlMailMessage @ShmmParams

            Start-Sleep -Seconds $EmailSendSleep

            if ($PSVersionTable.PSVersion -ge "6.0") {
                $Response = Invoke-RestMethod -Uri http://localhost:10025/api/v2/messages -Credential $PSCreds -AllowUnencryptedAuthentication
            } else {
                $Response = Invoke-RestMethod -Uri http://localhost:10025/api/v2/messages -Credential $PSCreds 
            }
            Invoke-RestMethod -Uri http://localhost:10025/api/v1/messages -Method "DELETE" | Out-Null

            $Source = ConvertTo-NormalBody -InputObject $Response.Items[0].Content.Body

            $Source | Should -Match "<p style=`"font-family: sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 15px; text-align: left;`">Body Text</p>"
        }
        It '-DeliveryNotificationOption' -Pending {
        }
        It '-Encoding' -Pending {
        }
        It '-Port' {
            Start-Sleep -Seconds $ProccessStartSleep

            $ShmmParams = @{
                From = "PoshEmail@test.local"
                To = "rcpt@test.local"
                Subject = "PoshEmail Test"
                SmtpServer = "127.0.0.1"
                Body = "Body Text"
                Port = "1025"
            }

            Send-HtmlMailMessage @ShmmParams

            Start-Sleep -Seconds $EmailSendSleep

            $Response = Invoke-RestMethod -Uri http://localhost:9025/api/v2/messages
            Invoke-RestMethod -Uri http://localhost:9025/api/v1/messages -Method "DELETE" | Out-Null

            $Source = ConvertTo-NormalBody -InputObject $Response.Items[0].Content.Body

            $Source | Should -Match "<p style=`"font-family: sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 15px; text-align: left;`">Body Text</p>"
        }
        It '-UseSsl' -Pending {
        }
        It '-Priority' -Pending {
        }
        It '-Heading' {
            $ShmmParams = @{
                From = "PoshEmail@test.local"
                To = "rcpt@test.local"
                Subject = "PoshEmail Test"
                SmtpServer = "127.0.0.1"
                Body = "Body Text"
                Heading = "Test Heading"
            }
    
            Send-HtmlMailMessage @ShmmParams
    
            Start-Sleep -Seconds $EmailSendSleep
    
            $Response = Invoke-RestMethod -Uri http://localhost:8025/api/v2/messages
            Invoke-RestMethod -Uri http://localhost:8025/api/v1/messages -Method "DELETE" | Out-Null
    
            $Source = ConvertTo-NormalBody -InputObject $Response.Items[0].Content.Body
    
            $Source | Should -Match "<h2 style=`"text-align: center;`">Test Heading</h2>"
        }
        It '-HeadingAlignment' {
            $ShmmParams = @{
                From = "PoshEmail@test.local"
                To = "rcpt@test.local"
                Subject = "PoshEmail Test"
                SmtpServer = "127.0.0.1"
                Body = "Body Text"
                Heading = "Test Heading"
                HeadingAlignment = "Left"
            }
    
            Send-HtmlMailMessage @ShmmParams
    
            Start-Sleep -Seconds $EmailSendSleep
    
            $Response = Invoke-RestMethod -Uri http://localhost:8025/api/v2/messages
            Invoke-RestMethod -Uri http://localhost:8025/api/v1/messages -Method "DELETE" | Out-Null
    
            $Source = ConvertTo-NormalBody -InputObject $Response.Items[0].Content.Body
    
            $Source | Should -Match "<h2 style=`"text-align: left;`">Test Heading</h2>"
        }
        It '-Footer' {
            $ShmmParams = @{
                From = "PoshEmail@test.local"
                To = "rcpt@test.local"
                Subject = "PoshEmail Test"
                SmtpServer = "127.0.0.1"
                Body = "Body Text"
                Footer = "Test Footer"
            }
    
            Send-HtmlMailMessage @ShmmParams
    
            Start-Sleep -Seconds $EmailSendSleep
    
            $Response = Invoke-RestMethod -Uri http://localhost:8025/api/v2/messages
            Invoke-RestMethod -Uri http://localhost:8025/api/v1/messages -Method "DELETE" | Out-Null
    
            $Source = ConvertTo-NormalBody -InputObject $Response.Items[0].Content.Body
    
            $Source | Should -Match ("<td class=`"content-block`" style=`"font-family: sans-serif; vertical-align: top; padding-bottom: 10px; padding-top: 10px; font-size: 12px; color: #999999; text-align: center;`">$NL" +
                "                    Test Footer$NL" +
                "                  </td>$NL")
        }
        It '-LastLine' {
            $ShmmParams = @{
                From = "PoshEmail@test.local"
                To = "rcpt@test.local"
                Subject = "PoshEmail Test"
                SmtpServer = "127.0.0.1"
                Body = "Body Text"
                LastLine = "Test LastLine"
            }
    
            Send-HtmlMailMessage @ShmmParams
    
            Start-Sleep -Seconds $EmailSendSleep
    
            $Response = Invoke-RestMethod -Uri http://localhost:8025/api/v2/messages
            Invoke-RestMethod -Uri http://localhost:8025/api/v1/messages -Method "DELETE" | Out-Null
    
            $Source = ConvertTo-NormalBody -InputObject $Response.Items[0].Content.Body
    
            $Source | Should -Match ("<td class=`"content-block powered-by`" style=`"font-family: sans-serif; vertical-align: top; padding-bottom: 10px; padding-top: 10px; font-size: 12px; color: #999999; text-align: center;`">$NL" +
                "                    Test LastLine$NL" +
                "                  </td>")
        }
        It '-ButtonText and -ButtonLink' {
            $ShmmParams = @{
                From = "PoshEmail@test.local"
                To = "rcpt@test.local"
                Subject = "PoshEmail Test"
                SmtpServer = "127.0.0.1"
                Body = "Body Text"
                ButtonText = "Test ButtonText"
                ButtonLink = "https://testbuttonlink.com"
            }
    
            Send-HtmlMailMessage @ShmmParams
    
            Start-Sleep -Seconds $EmailSendSleep
    
            $Response = Invoke-RestMethod -Uri http://localhost:8025/api/v2/messages
            Invoke-RestMethod -Uri http://localhost:8025/api/v1/messages -Method "DELETE" | Out-Null
    
            $Source = ConvertTo-NormalBody -InputObject $Response.Items[0].Content.Body
    
            $Source | Should -Match ("<table border=`"0`" cellpadding=`"0`" cellspacing=`"0`" class=`"btn btn-primary`" style=`"border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%; box-sizing: border-box;`">$NL" +
            "                          <tbody>$NL" +
            "                            <tr>$NL" +
            "                              <td align=`"center`" style=`"font-family: sans-serif; font-size: 14px; vertical-align: top; padding-bottom: 15px;`">$NL" +
            "                                <table border=`"0`" cellpadding=`"0`" cellspacing=`"0`" style=`"border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: auto;`">$NL" +
            "                                  <tbody>$NL" +
            "                                    <tr>$NL" +
            "                                      <td style=`"font-family: sans-serif; font-size: 14px; vertical-align: top; background-color: #3498db; border-radius: 5px; text-align: center;`"> <a href=`"https://testbuttonlink.com`" target=`"_blank`" style=`"display: inline-block; color: #ffffff; background-color: #3498db; border: solid 1px #3498db; border-radius: 5px; box-sizing: border-box; cursor: pointer; text-decoration: none; font-size: 14px; font-weight: bold; margin: 0; padding: 12px 25px; text-transform: capitalize; border-color: #3498db;`">Test ButtonText</a> </td>$NL" +
            "                                    </tr>$NL" +
            "                                  </tbody>$NL" +
            "                                </table>$NL" +
            "                              </td>$NL" +
            "                            </tr>$NL" +
            "                          </tbody>$NL" +
            "                        </table>")
        }
        It '-ButtonAlignment' {
            $ShmmParams = @{
                From = "PoshEmail@test.local"
                To = "rcpt@test.local"
                Subject = "PoshEmail Test"
                SmtpServer = "127.0.0.1"
                Body = "Body Text"
                ButtonText = "Test ButtonText"
                ButtonLink = "https://testbuttonlink.com"
                ButtonAlignment = "Left"
            }
    
            Send-HtmlMailMessage @ShmmParams
    
            Start-Sleep -Seconds $EmailSendSleep
    
            $Response = Invoke-RestMethod -Uri http://localhost:8025/api/v2/messages
            Invoke-RestMethod -Uri http://localhost:8025/api/v1/messages -Method "DELETE" | Out-Null
    
            $Source = ConvertTo-NormalBody -InputObject $Response.Items[0].Content.Body
    
            $Source | Should -Match ("<table border=`"0`" cellpadding=`"0`" cellspacing=`"0`" class=`"btn btn-primary`" style=`"border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%; box-sizing: border-box;`">$NL" +
            "                          <tbody>$NL" +
            "                            <tr>$NL" +
            "                              <td align=`"left`" style=`"font-family: sans-serif; font-size: 14px; vertical-align: top; padding-bottom: 15px;`">$NL" +
            "                                <table border=`"0`" cellpadding=`"0`" cellspacing=`"0`" style=`"border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: auto;`">$NL" +
            "                                  <tbody>$NL" +
            "                                    <tr>$NL" +
            "                                      <td style=`"font-family: sans-serif; font-size: 14px; vertical-align: top; background-color: #3498db; border-radius: 5px; text-align: center;`"> <a href=`"https://testbuttonlink.com`" target=`"_blank`" style=`"display: inline-block; color: #ffffff; background-color: #3498db; border: solid 1px #3498db; border-radius: 5px; box-sizing: border-box; cursor: pointer; text-decoration: none; font-size: 14px; font-weight: bold; margin: 0; padding: 12px 25px; text-transform: capitalize; border-color: #3498db;`">Test ButtonText</a> </td>$NL" +
            "                                    </tr>$NL" +
            "                                  </tbody>$NL" +
            "                                </table>$NL" +
            "                              </td>$NL" +
            "                            </tr>$NL" +
            "                          </tbody>$NL" +
            "                        </table>")
        }
    }
    Describe 'Invoke-CommandWithEmailWrapper' {
        It 'PowerShell ScriptBlock' {
            $SourcePath = "$TempDir\icwew_source"
            $DestPath = "$TempDir\icwew_dest"
            New-Item -Path $SourcePath -ItemType Directory
            New-Item -Path $DestPath -ItemType Directory

            [System.Security.Cryptography.RNGCryptoServiceProvider] $Rng = New-Object System.Security.Cryptography.RNGCryptoServiceProvider
            $RndBytes = New-Object byte[] 10MB
            $Rng.GetBytes($rndbytes)
            [System.IO.File]::WriteAllBytes("$($SourcePath)\test1.txt", $rndbytes)

            $RndBytes = New-Object byte[] 100MB
            $Rng.GetBytes($rndbytes)
            [System.IO.File]::WriteAllBytes("$($SourcePath)\test2.txt", $rndbytes)

            $RndBytes = New-Object byte[] 1MB
            $Rng.GetBytes($rndbytes)
            [System.IO.File]::WriteAllBytes("$($SourcePath)\test3.txt", $rndbytes)

            $ShmmParams = @{
                EmailFrom = "PoshEmail@test.local"
                EmailTo = "rcpt@test.local"
                SmtpServer = "127.0.0.1"
                ScriptBLock = { Get-ChildItem $SourcePath | Select-Object Length, Name }
                JobName = "Test 1"
                EmailUseSsl = $false
            }

            Invoke-CommandWithEmailWrapper @ShmmParams

            Start-Sleep -Seconds $EmailSendSleep

            $Response = Invoke-RestMethod -Uri http://localhost:8025/api/v2/messages
            Invoke-RestMethod -Uri http://localhost:8025/api/v1/messages -Method "DELETE" | Out-Null

            Remove-Item $SourcePath -Force -Recurse
            Remove-Item $DestPath -Force -Recurse

            $Source = ConvertTo-NormalBody -InputObject $Response.Items[0].Content.Body

            $Source | Should -Match "104857600&ensp;test2.txt"

        }
        It 'Cmd ScriptBlock' -Skip:$IsntWindows {
            $SourcePath = "$TempDir\icwew_source"
            $DestPath = "$TempDir\icwew_dest"
            New-Item -Path $SourcePath -ItemType Directory
            New-Item -Path $DestPath -ItemType Directory

            [System.Security.Cryptography.RNGCryptoServiceProvider] $Rng = New-Object System.Security.Cryptography.RNGCryptoServiceProvider
            $RndBytes = New-Object byte[] 10MB
            $Rng.GetBytes($rndbytes)
            [System.IO.File]::WriteAllBytes("$($SourcePath)\test1.txt", $rndbytes)

            $RndBytes = New-Object byte[] 100MB
            $Rng.GetBytes($rndbytes)
            [System.IO.File]::WriteAllBytes("$($SourcePath)\test2.txt", $rndbytes)

            $RndBytes = New-Object byte[] 1MB
            $Rng.GetBytes($rndbytes)
            [System.IO.File]::WriteAllBytes("$($SourcePath)\test3.txt", $rndbytes)

            $ShmmParams = @{
                EmailFrom = "PoshEmail@test.local"
                EmailTo = "rcpt@test.local"
                SmtpServer = "127.0.0.1"
                ScriptBLock = { robocopy $SourcePath $DestPath }
                JobName = "Test 1"
                EmailUseSsl = $false
            }

            Invoke-CommandWithEmailWrapper @ShmmParams

            Start-Sleep -Seconds $EmailSendSleep

            $Response = Invoke-RestMethod -Uri http://localhost:8025/api/v2/messages
            
            Remove-Item $SourcePath -Force -Recurse
            Remove-Item $DestPath -Force -Recurse

            $Source = ConvertTo-NormalBody -InputObject $Response.Items[0].Content.Body

            $Source | Should -Match "ROBOCOPY&ensp;&ensp;&ensp;&ensp;&ensp;::&ensp;&ensp;&ensp;&ensp;&ensp;Robust&ensp;File&ensp;Copy&ensp;for&ensp;Windows"

        }
    }
}
