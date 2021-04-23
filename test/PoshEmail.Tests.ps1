# NOTE: All pending tests are due to lack of support in MailHog for that specific feature.

$global:ModuleName = Split-Path -Path ($PSCommandPath -replace '\.Tests\.ps1$','') -Leaf
$global:ModulePath = "$(Split-Path -Path $PSScriptRoot -Parent)\src\$ModuleName.psm1"
$global:ModuleManifestPath = "$(Split-Path -Path $PSScriptRoot -Parent)\src\$ModuleName.psd1"
$global:EmailSendSleep = 1

Get-Module -Name $ModuleName -All | Remove-Module -Force -ErrorAction Ignore
Import-Module -Name $ModulePath -Force -ErrorAction Stop

InModuleScope $ModuleName {
    Describe 'Module Manifest Tests' {
        It 'Passes Test-ModuleManifest' {
            Test-ModuleManifest -Path $ModuleManifestPath | Should -Not -BeNullOrEmpty
            $? | Should -Be $true
        }
    }

    Describe 'Send-HtmlMailMessage' {
        It 'Mandatory Params' {
            $ShmmParams = @{
                From = "PoshEmail@test.local"
                To = "rcpt@test.local"
                Subject = "PoshEmail Test"
                SmtpServer = "127.0.0.1"
                Port = 1025
                Body = "Body Text"
            }

            Send-HtmlMailMessage @ShmmParams

            Start-Sleep -Seconds $EmailSendSleep

            $Response = Invoke-RestMethod -Uri http://localhost:8025/api/v2/messages
            Invoke-RestMethod -Uri http://localhost:8025/api/v1/messages -Method "DELETE" | Out-Null

            $Response.Items[0].Content.Body | Should -Be ("<!doctype html>`r`n" +
                "<html>`r`n" +
                "  <head>`r`n" +
                "    <meta name=`"viewport`" content=`"width=device-width`">`r`n" +
                "    <meta http-equiv=`"Content-Type`" content=`"text/html; charset=UTF-8`">`r`n" +
                "    <title></title>`r`n" +
                "    <style>`r`n" +
                "    /* -------------------------------------`r`n" +
                "        INLINED WITH htmlemail.io/inline`r`n" +
                "    ------------------------------------- */`r`n" +
                "    /* -------------------------------------`r`n" +
                "        RESPONSIVE AND MOBILE FRIENDLY STYLES`r`n" +
                "    ------------------------------------- */`r`n" +
                "    @media only screen and (max-width: 620px) {`r`n" +
                "      table[class=body] h1 {`r`n" +
                "        font-size: 28px !important;`r`n" +
                "        margin-bottom: 10px !important;`r`n" +
                "      }`r`n" +
                "      table[class=body] p,`r`n" +
                "      table[class=body] ul,`r`n" +
                "      table[class=body] ol,`r`n" +
                "      table[class=body] td,`r`n" +
                "      table[class=body] span,`r`n" +
                "      table[class=body] a {`r`n" +
                "        font-size: 16px !important;`r`n" +
                "      }`r`n" +
                "      table[class=body] .preformatted {`r`n" +
                "        font-size: 11px !important;`r`n" +
                "      }`r`n" +
                "      table[class=body] .wrapper,`r`n" +
                "            table[class=body] .article {`r`n" +
                "        padding: 10px !important;`r`n" +
                "      }`r`n" +
                "      table[class=body] .content {`r`n" +
                "        padding: 0 !important;`r`n" +
                "      }`r`n" +
                "      table[class=body] .container {`r`n" +
                "        padding: 0 !important;`r`n" +
                "        width: 100% !important;`r`n" +
                "      }`r`n" +
                "      table[class=body] .main {`r`n" +
                "        border-left-width: 0 !important;`r`n" +
                "        border-radius: 0 !important;`r`n" +
                "        border-right-width: 0 !important;`r`n" +
                "      }`r`n" +
                "      table[class=body] .btn table {`r`n" +
                "        width: 100% !important;`r`n" +
                "      }`r`n" +
                "      table[class=body] .btn a {`r`n" +
                "        width: 100% !important;`r`n" +
                "      }`r`n" +
                "      table[class=body] .img-responsive {`r`n" +
                "        height: auto !important;`r`n" +
                "        max-width: 100% !important;`r`n" +
                "        width: auto !important;`r`n" +
                "      }`r`n" +
                "    }`r`n" +
                "`r`n" +
                "    /* -------------------------------------`r`n" +
                "        PRESERVE THESE STYLES IN THE HEAD`r`n" +
                "    ------------------------------------- */`r`n" +
                "    @media all {`r`n" +
                "      .ExternalClass {`r`n" +
                "        width: 100%;`r`n" +
                "      }`r`n" +
                "      .ExternalClass,`r`n" +
                "      .ExternalClass p,`r`n" +
                "      .ExternalClass span,`r`n" +
                "      .ExternalClass font,`r`n" +
                "      .ExternalClass td,`r`n" +
                "      .ExternalClass div {`r`n" +
                "        line-height: 100%;`r`n" +
                "      }`r`n" +
                "      .btn-primary table td:hover {`r`n" +
                "        background-color: #3498db !important;`r`n" +
                "      }`r`n" +
                "      .btn-primary a:hover {`r`n" +
                "        background-color: #3498db !important;`r`n" +
                "        border-color: #3498db !important;`r`n" +
                "      }`r`n" +
                "    }`r`n" +
                "   </style>`r`n" +
                "  </head>`r`n" +
                "  <body class=`"`" style=`"background-color: #f6f6f6; font-family: sans-serif; -webkit-font-smoothing: antialiased; font-size: 14px; line-height: 1.4; margin: 0; padding: 0; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%;`">`r`n" +
                "    <table border=`"0`" cellpadding=`"0`" cellspacing=`"0`" class=`"body`" style=`"border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%; background-color: #f6f6f6;`">`r`n" +
                "      <tr>`r`n" +
                "        <td style=`"font-family: sans-serif; font-size: 14px; vertical-align: top;`">&nbsp;</td>`r`n" +
                "        <td class=`"container`" style=`"font-family: sans-serif; font-size: 14px; vertical-align: top; display: block; margin: 0 auto; max-width: 580px; padding: 10px;`">`r`n" +
                "          <div class=`"content`" style=`"box-sizing: border-box; display: block; margin: 0 auto; max-width: 100%; padding: 10px;`">`r`n" +
                "`r`n" +
                "            <!-- START CENTERED CONTAINER -->`r`n" +
                "            <span class=`"preheader`" style=`"color: transparent; display: none; height: 0; max-height: 0; max-width: 0; opacity: 0; overflow: hidden; mso-hide: all; visibility: hidden; width: 0;`"></span>`r`n" +
                "            <table class=`"main`" style=`"border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%; background: #ffffff; border-radius: 3px;`">`r`n" +
                "`r`n" +
                "              <!-- START MAIN CONTENT AREA -->`r`n" +
                "              <tr>`r`n" +
                "                <td class=`"wrapper`" style=`"font-family: sans-serif; font-size: 14px; vertical-align: top; box-sizing: border-box; padding: 20px;`">`r`n" +
                "                  <table border=`"0`" cellpadding=`"0`" cellspacing=`"0`" style=`"border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%;`">`r`n" +
                "                    <tr>`r`n" +
                "                      <td style=`"font-family: sans-serif; font-size: 14px; vertical-align: top;`">`r`n" +
                "                        <h2 style=`"text-align: center; color: #000000;`"></h2>`r`n" +
                "                        <p style=`"font-family: sans-serif; font-size: 14px; font-weight: normal; color: #000000; margin: 0; margin-bottom: 15px; text-align: left;`">Body Text</p>`r`n" +
                "                      </td>`r`n" +
                "                    </tr>`r`n" +
                "                  </table>`r`n" +
                "                </td>`r`n" +
                "              </tr>`r`n" +
                "`r`n" +
                "            <!-- END MAIN CONTENT AREA -->`r`n" +
                "            </table>`r`n" +
                "`r`n" +
                "            <!-- START FOOTER -->`r`n" +
                "            <div class=`"footer`" style=`"clear: both; margin-top: 10px; text-align: center; width: 100%;`">`r`n" +
                "              <table border=`"0`" cellpadding=`"0`" cellspacing=`"0`" style=`"border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%;`">`r`n" +
                "                <tr>`r`n" +
                "                  <td class=`"content-block`" style=`"font-family: sans-serif; vertical-align: top; padding-bottom: 10px; padding-top: 10px; font-size: 12px; color: #999999; text-align: center;`">`r`n" +
                "                  </td>`r`n" +
                "                </tr>`r`n" +
                "              </table>`r`n" +
                "            </div>`r`n" +
                "            <!-- END FOOTER -->`r`n" +
                "`r`n" +
                "          <!-- END CENTERED CONTAINER -->`r`n" +
                "          </div>`r`n" +
                "        </td>`r`n" +
                "        <td style=`"font-family: sans-serif; font-size: 14px; vertical-align: top;`">&nbsp;</td>`r`n" +
                "      </tr>`r`n" +
                "    </table>`r`n" +
                "  </body>`r`n" +
                "</html>")
        }
        It '-BodyAlignment' {
            $ShmmParams = @{
                From = "PoshEmail@test.local"
                To = "rcpt@test.local"
                Subject = "PoshEmail Test"
                SmtpServer = "127.0.0.1"
                Port = 1025
                Body = "Body Text"
                BodyAlignment = "Center"
            }

            Send-HtmlMailMessage @ShmmParams

            Start-Sleep -Seconds $EmailSendSleep

            $Response = Invoke-RestMethod -Uri http://localhost:8025/api/v2/messages
            Invoke-RestMethod -Uri http://localhost:8025/api/v1/messages -Method "DELETE" | Out-Null

            $Response.Items[0].Content.Body | Should -Match "<p style=`"font-family: sans-serif; font-size: 14px; font-weight: normal; color: #000000; margin: 0; margin-bottom: 15px; text-align: center;`">Body Text</p>`r`n"
        }    
        It '-BodyPreformatted' {
            $ShmmParams = @{
                From = "PoshEmail@test.local"
                To = "rcpt@test.local"
                Subject = "PoshEmail Test"
                SmtpServer = "127.0.0.1"
                Port = "1025"
                Body = "Body Text"
                BodyPreformatted = ("`r`n" +
                    "`r`n" +
                    "    Directory: C:\code\PoshEmail`r`n" +
                    "`r`n" +
                    "`r`n" +
                    "Mode                LastWriteTime         Length Name`r`n" +
                    "----                -------------         ------ ----`r`n" +
                    "d-----       10/24/2018   9:27 AM                .vscode`r`n" +
                    "d-----       10/11/2018  11:17 AM                docs`r`n" +
                    "d-----       10/11/2018  11:17 AM                out`r`n" +
                    "d-----       10/25/2018   7:15 AM                src`r`n" +
                    "d-----       10/29/2018  11:47 AM                test`r`n" +
                    "-a----       10/24/2018   9:27 AM            160 .gitignore`r`n" +
                    "-a----       10/29/2018  10:44 AM           6194 appveyor.yml`r`n" +
                    "-a----       10/29/2018  10:44 AM           2113 appveyordeploy.ps1`r`n" +
                    "-a----        10/5/2018   2:39 PM            351 CHANGELOG.md`r`n" +
                    "-a----        10/5/2018   2:51 PM           2095 CONTRIBUTING.md`r`n" +
                    "-a----        9/26/2018   2:18 PM           1080 LICENSE`r`n" +
                    "-a----       10/24/2018   9:27 AM          14016 PoshEmail.build.ps1`r`n" +
                    "-a----       10/24/2018   9:37 AM           1383 README.md")
            }

            Send-HtmlMailMessage @ShmmParams

            Start-Sleep -Seconds $EmailSendSleep

            $Response = Invoke-RestMethod -Uri http://localhost:8025/api/v2/messages
            Invoke-RestMethod -Uri http://localhost:8025/api/v1/messages -Method "DELETE" | Out-Null

            $Response.Items[0].Content.Body | Should -Match ("                      </td>`r`n" +
                "                    </tr>`r`n" +
                "                    <tr>`r`n" +
                "                      <td class=`"preformatted`" width=`"100%`" style=`"font-size: 14px; vertical-align: top; max-width: 100%; overflow: auto; padding-top: 15px; padding-right: 15px;background-color: #F5F5F5; border: 1px solid black;`">`r`n" +
                "                        <ol class=`"preformatted`">`r`n" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`"></span></li>`r`n" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`"></span></li>`r`n" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">&ensp;&ensp;&ensp;&ensp;Directory:&ensp;C:\\code\\PoshEmail</span></li>`r`n" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`"></span></li>`r`n" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`"></span></li>`r`n" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">Mode&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;LastWriteTime&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;Length&ensp;Name</span></li>`r`n" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">----&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;-------------&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;------&ensp;----</span></li>`r`n" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">d-----&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;10/24/2018&ensp;&ensp;&ensp;9:27&ensp;AM&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;.vscode</span></li>`r`n" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">d-----&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;10/11/2018&ensp;&ensp;11:17&ensp;AM&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;docs</span></li>`r`n" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">d-----&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;10/11/2018&ensp;&ensp;11:17&ensp;AM&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;out</span></li>`r`n" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">d-----&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;10/25/2018&ensp;&ensp;&ensp;7:15&ensp;AM&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;src</span></li>`r`n" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">d-----&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;10/29/2018&ensp;&ensp;11:47&ensp;AM&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;test</span></li>`r`n" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">-a----&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;10/24/2018&ensp;&ensp;&ensp;9:27&ensp;AM&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;160&ensp;.gitignore</span></li>`r`n" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">-a----&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;10/29/2018&ensp;&ensp;10:44&ensp;AM&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;6194&ensp;appveyor.yml</span></li>`r`n" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">-a----&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;10/29/2018&ensp;&ensp;10:44&ensp;AM&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;2113&ensp;appveyordeploy.ps1</span></li>`r`n" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">-a----&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;10/5/2018&ensp;&ensp;&ensp;2:39&ensp;PM&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;351&ensp;CHANGELOG.md</span></li>`r`n" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">-a----&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;10/5/2018&ensp;&ensp;&ensp;2:51&ensp;PM&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;2095&ensp;CONTRIBUTING.md</span></li>`r`n" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">-a----&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;9/26/2018&ensp;&ensp;&ensp;2:18&ensp;PM&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;1080&ensp;LICENSE</span></li>`r`n" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">-a----&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;10/24/2018&ensp;&ensp;&ensp;9:27&ensp;AM&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;14016&ensp;PoshEmail.build.ps1</span></li>`r`n" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">-a----&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;10/24/2018&ensp;&ensp;&ensp;9:37&ensp;AM&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;1383&ensp;README.md</span></li>`r`n" +
                "                        </ol>`r`n" +
                "                      </td>`r`n" +
                "                    </tr>`r`n" +
                "                    <tr>`r`n" +
                "                      <td style=`"font-family: sans-serif; font-size: 14px; vertical-align: top;`">`r`n" +
                "                        <p style=`"font-family: sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 15px; text-align: left;`">&nbsp;</p>`r`n")
        }
        It '-Attachments' {
            $ShmmParams = @{
                From = "PoshEmail@test.local"
                To = "rcpt@test.local"
                Subject = "PoshEmail Test"
                SmtpServer = "127.0.0.1"
                Port = 1025
                Body = "Body Text"
                Attachments = "$PSScriptRoot\image.png"
            }

            Send-HtmlMailMessage @ShmmParams

            Start-Sleep -Seconds $EmailSendSleep

            $Response = Invoke-RestMethod -Uri http://localhost:8025/api/v2/messages
            Invoke-RestMethod -Uri http://localhost:8025/api/v1/messages -Method "DELETE" | Out-Null

            $Response.Items[0].Content.Body | Should -Match "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABGdBTUEAALGPC/xhBQAAACBj"
        }
        It '-Bcc' -Pending {
        }
        It '-Cc' -Pending {
        }
        It '-Credential' {
            $PSCreds = New-Object System.Management.Automation.PSCredential("test", (ConvertTo-SecureString "test" -AsPlainText -Force))

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
                $Response = Invoke-RestMethod -Uri http://localhost:9025/api/v2/messages -Credential $PSCreds -AllowUnencryptedAuthentication
                Invoke-RestMethod -Uri http://localhost:9025/api/v1/messages -Method "DELETE" -Credential $PSCreds -AllowUnencryptedAuthentication | Out-Null
            } else {
                $Response = Invoke-RestMethod -Uri http://localhost:9025/api/v2/messages -Credential $PSCreds
                Invoke-RestMethod -Uri http://localhost:9025/api/v1/messages -Method "DELETE" -Credential $PSCreds | Out-Null
            }

            $Response.Items[0].Content.Body | Should -Match "<p style=`"font-family: sans-serif; font-size: 14px; font-weight: normal; color: #000000; margin: 0; margin-bottom: 15px; text-align: left;`">Body Text</p>"
        }
        It '-DeliveryNotificationOption' -Pending {
        }
        It '-Encoding' -Pending {
        }
        It '-Priority' -Pending {
        }
        It '-Heading' {
            $ShmmParams = @{
                From = "PoshEmail@test.local"
                To = "rcpt@test.local"
                Subject = "PoshEmail Test"
                SmtpServer = "127.0.0.1"
                Port = 1025
                Body = "Body Text"
                Heading = "Test Heading"
            }

            Send-HtmlMailMessage @ShmmParams

            Start-Sleep -Seconds $EmailSendSleep

            $Response = Invoke-RestMethod -Uri http://localhost:8025/api/v2/messages
            Invoke-RestMethod -Uri http://localhost:8025/api/v1/messages -Method "DELETE" | Out-Null

            $Response.Items[0].Content.Body | Should -Match "<h2 style=`"text-align: center; color: #000000;`">Test Heading</h2>"
        }
        It '-HeadingAlignment' {
            $ShmmParams = @{
                From = "PoshEmail@test.local"
                To = "rcpt@test.local"
                Subject = "PoshEmail Test"
                SmtpServer = "127.0.0.1"
                Port = 1025
                Body = "Body Text"
                Heading = "Test Heading"
                HeadingAlignment = "Left"
            }

            Send-HtmlMailMessage @ShmmParams

            Start-Sleep -Seconds $EmailSendSleep

            $Response = Invoke-RestMethod -Uri http://localhost:8025/api/v2/messages
            Invoke-RestMethod -Uri http://localhost:8025/api/v1/messages -Method "DELETE" | Out-Null

            $Response.Items[0].Content.Body | Should -Match "<h2 style=`"text-align: left; color: #000000;`">Test Heading</h2>"
        }
        It '-Footer' {
            $ShmmParams = @{
                From = "PoshEmail@test.local"
                To = "rcpt@test.local"
                Subject = "PoshEmail Test"
                SmtpServer = "127.0.0.1"
                Port = 1025
                Body = "Body Text"
                Footer = "Test Footer"
            }

            Send-HtmlMailMessage @ShmmParams

            Start-Sleep -Seconds $EmailSendSleep

            $Response = Invoke-RestMethod -Uri http://localhost:8025/api/v2/messages
            Invoke-RestMethod -Uri http://localhost:8025/api/v1/messages -Method "DELETE" | Out-Null

            $Response.Items[0].Content.Body | Should -Match ("<td class=`"content-block`" style=`"font-family: sans-serif; vertical-align: top; padding-bottom: 10px; padding-top: 10px; font-size: 12px; color: #999999; text-align: center;`">`r`n" +
                "                    Test Footer`r`n" +
                "                  </td>`r`n")
        }
        It '-ButtonText and -ButtonLink' {
            $ShmmParams = @{
                From = "PoshEmail@test.local"
                To = "rcpt@test.local"
                Subject = "PoshEmail Test"
                SmtpServer = "127.0.0.1"
                Port = 1025
                Body = "Body Text"
                ButtonText = "Test ButtonText"
                ButtonLink = "https://testbuttonlink.com"
            }

            Send-HtmlMailMessage @ShmmParams

            Start-Sleep -Seconds $EmailSendSleep

            $Response = Invoke-RestMethod -Uri http://localhost:8025/api/v2/messages
            Invoke-RestMethod -Uri http://localhost:8025/api/v1/messages -Method "DELETE" | Out-Null

            $Response.Items[0].Content.Body | Should -Match ("<table border=`"0`" cellpadding=`"0`" cellspacing=`"0`" class=`"btn btn-primary`" style=`"border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%; box-sizing: border-box;`">`r`n" +
            "                          <tbody>`r`n" +
            "                            <tr>`r`n" +
            "                              <td align=`"center`" style=`"font-family: sans-serif; font-size: 14px; vertical-align: top; padding-bottom: 15px;`">`r`n" +
            "                                <table border=`"0`" cellpadding=`"0`" cellspacing=`"0`" style=`"border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: auto;`">`r`n" +
            "                                  <tbody>`r`n" +
            "                                    <tr>`r`n" +
            "                                      <td style=`"font-family: sans-serif; font-size: 14px; vertical-align: top; background-color: #3498db; border-radius: 5px; text-align: center;`"> <a href=`"https://testbuttonlink.com`" target=`"_blank`" style=`"display: inline-block; color: #ffffff; background-color: #3498db; border: solid 1px #3498db; border-radius: 5px; box-sizing: border-box; cursor: pointer; text-decoration: none; font-size: 14px; font-weight: bold; margin: 0; padding: 12px 25px; text-transform: capitalize; border-color: #3498db;`">Test ButtonText</a> </td>`r`n" +
            "                                    </tr>`r`n" +
            "                                  </tbody>`r`n" +
            "                                </table>`r`n" +
            "                              </td>`r`n" +
            "                            </tr>`r`n" +
            "                          </tbody>`r`n" +
            "                        </table>")
        }
        It '-ButtonAlignment' {
            $ShmmParams = @{
                From = "PoshEmail@test.local"
                To = "rcpt@test.local"
                Subject = "PoshEmail Test"
                SmtpServer = "127.0.0.1"
                Port = 1025
                Body = "Body Text"
                ButtonText = "Test ButtonText"
                ButtonLink = "https://testbuttonlink.com"
                ButtonAlignment = "Left"
            }

            Send-HtmlMailMessage @ShmmParams

            Start-Sleep -Seconds $EmailSendSleep

            $Response = Invoke-RestMethod -Uri http://localhost:8025/api/v2/messages
            Invoke-RestMethod -Uri http://localhost:8025/api/v1/messages -Method "DELETE" | Out-Null

            $Response.Items[0].Content.Body | Should -Match ("<table border=`"0`" cellpadding=`"0`" cellspacing=`"0`" class=`"btn btn-primary`" style=`"border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%; box-sizing: border-box;`">`r`n" +
            "                          <tbody>`r`n" +
            "                            <tr>`r`n" +
            "                              <td align=`"left`" style=`"font-family: sans-serif; font-size: 14px; vertical-align: top; padding-bottom: 15px;`">`r`n" +
            "                                <table border=`"0`" cellpadding=`"0`" cellspacing=`"0`" style=`"border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: auto;`">`r`n" +
            "                                  <tbody>`r`n" +
            "                                    <tr>`r`n" +
            "                                      <td style=`"font-family: sans-serif; font-size: 14px; vertical-align: top; background-color: #3498db; border-radius: 5px; text-align: center;`"> <a href=`"https://testbuttonlink.com`" target=`"_blank`" style=`"display: inline-block; color: #ffffff; background-color: #3498db; border: solid 1px #3498db; border-radius: 5px; box-sizing: border-box; cursor: pointer; text-decoration: none; font-size: 14px; font-weight: bold; margin: 0; padding: 12px 25px; text-transform: capitalize; border-color: #3498db;`">Test ButtonText</a> </td>`r`n" +
            "                                    </tr>`r`n" +
            "                                  </tbody>`r`n" +
            "                                </table>`r`n" +
            "                              </td>`r`n" +
            "                            </tr>`r`n" +
            "                          </tbody>`r`n" +
            "                        </table>")
        }
        IT '-ColorScheme' {
            $ShmmParams = @{
                From = "PoshEmail@test.local"
                To = "rcpt@test.local"
                Subject = "PoshEmail Test"
                SmtpServer = "127.0.0.1"
                Port = 1025
                Body = "Body Text"
                ColorScheme = @{
                    BodyTextColor = "#000000"
                    BackgroundColor = "#f7f2ed"
                    ContainerColor = "#ffffff"
                    HeadingTextColor = "#000000"
                    FooterTextColor = "#999999"
                    LinkColor = "#999999"
                    ButtonColor = "#3498db"
                    ButtonTextColor  = "#ffffff"
                }
            }

            Send-HtmlMailMessage @ShmmParams

            Start-Sleep -Seconds $EmailSendSleep

            $Response = Invoke-RestMethod -Uri http://localhost:8025/api/v2/messages
            Invoke-RestMethod -Uri http://localhost:8025/api/v1/messages -Method "DELETE" | Out-Null

            $Response.Items[0].Content.Body | Should -Be ("<!doctype html>`r`n" +
                "<html>`r`n" +
                "  <head>`r`n" +
                "    <meta name=`"viewport`" content=`"width=device-width`">`r`n" +
                "    <meta http-equiv=`"Content-Type`" content=`"text/html; charset=UTF-8`">`r`n" +
                "    <title></title>`r`n" +
                "    <style>`r`n" +
                "    /* -------------------------------------`r`n" +
                "        INLINED WITH htmlemail.io/inline`r`n" +
                "    ------------------------------------- */`r`n" +
                "    /* -------------------------------------`r`n" +
                "        RESPONSIVE AND MOBILE FRIENDLY STYLES`r`n" +
                "    ------------------------------------- */`r`n" +
                "    @media only screen and (max-width: 620px) {`r`n" +
                "      table[class=body] h1 {`r`n" +
                "        font-size: 28px !important;`r`n" +
                "        margin-bottom: 10px !important;`r`n" +
                "      }`r`n" +
                "      table[class=body] p,`r`n" +
                "      table[class=body] ul,`r`n" +
                "      table[class=body] ol,`r`n" +
                "      table[class=body] td,`r`n" +
                "      table[class=body] span,`r`n" +
                "      table[class=body] a {`r`n" +
                "        font-size: 16px !important;`r`n" +
                "      }`r`n" +
                "      table[class=body] .preformatted {`r`n" +
                "        font-size: 11px !important;`r`n" +
                "      }`r`n" +
                "      table[class=body] .wrapper,`r`n" +
                "            table[class=body] .article {`r`n" +
                "        padding: 10px !important;`r`n" +
                "      }`r`n" +
                "      table[class=body] .content {`r`n" +
                "        padding: 0 !important;`r`n" +
                "      }`r`n" +
                "      table[class=body] .container {`r`n" +
                "        padding: 0 !important;`r`n" +
                "        width: 100% !important;`r`n" +
                "      }`r`n" +
                "      table[class=body] .main {`r`n" +
                "        border-left-width: 0 !important;`r`n" +
                "        border-radius: 0 !important;`r`n" +
                "        border-right-width: 0 !important;`r`n" +
                "      }`r`n" +
                "      table[class=body] .btn table {`r`n" +
                "        width: 100% !important;`r`n" +
                "      }`r`n" +
                "      table[class=body] .btn a {`r`n" +
                "        width: 100% !important;`r`n" +
                "      }`r`n" +
                "      table[class=body] .img-responsive {`r`n" +
                "        height: auto !important;`r`n" +
                "        max-width: 100% !important;`r`n" +
                "        width: auto !important;`r`n" +
                "      }`r`n" +
                "    }`r`n" +
                "`r`n" +
                "    /* -------------------------------------`r`n" +
                "        PRESERVE THESE STYLES IN THE HEAD`r`n" +
                "    ------------------------------------- */`r`n" +
                "    @media all {`r`n" +
                "      .ExternalClass {`r`n" +
                "        width: 100%;`r`n" +
                "      }`r`n" +
                "      .ExternalClass,`r`n" +
                "      .ExternalClass p,`r`n" +
                "      .ExternalClass span,`r`n" +
                "      .ExternalClass font,`r`n" +
                "      .ExternalClass td,`r`n" +
                "      .ExternalClass div {`r`n" +
                "        line-height: 100%;`r`n" +
                "      }`r`n" +
                "      .btn-primary table td:hover {`r`n" +
                "        background-color: #3498db !important;`r`n" +
                "      }`r`n" +
                "      .btn-primary a:hover {`r`n" +
                "        background-color: #3498db !important;`r`n" +
                "        border-color: #3498db !important;`r`n" +
                "      }`r`n" +
                "    }`r`n" +
                "   </style>`r`n" +
                "  </head>`r`n" +
                "  <body class=`"`" style=`"background-color: #f7f2ed; font-family: sans-serif; -webkit-font-smoothing: antialiased; font-size: 14px; line-height: 1.4; margin: 0; padding: 0; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%;`">`r`n" +
                "    <table border=`"0`" cellpadding=`"0`" cellspacing=`"0`" class=`"body`" style=`"border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%; background-color: #f7f2ed;`">`r`n" +
                "      <tr>`r`n" +
                "        <td style=`"font-family: sans-serif; font-size: 14px; vertical-align: top;`">&nbsp;</td>`r`n" +
                "        <td class=`"container`" style=`"font-family: sans-serif; font-size: 14px; vertical-align: top; display: block; margin: 0 auto; max-width: 580px; padding: 10px;`">`r`n" +
                "          <div class=`"content`" style=`"box-sizing: border-box; display: block; margin: 0 auto; max-width: 100%; padding: 10px;`">`r`n" +
                "`r`n" +
                "            <!-- START CENTERED CONTAINER -->`r`n" +
                "            <span class=`"preheader`" style=`"color: transparent; display: none; height: 0; max-height: 0; max-width: 0; opacity: 0; overflow: hidden; mso-hide: all; visibility: hidden; width: 0;`"></span>`r`n" +
                "            <table class=`"main`" style=`"border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%; background: #ffffff; border-radius: 3px;`">`r`n" +
                "`r`n" +
                "              <!-- START MAIN CONTENT AREA -->`r`n" +
                "              <tr>`r`n" +
                "                <td class=`"wrapper`" style=`"font-family: sans-serif; font-size: 14px; vertical-align: top; box-sizing: border-box; padding: 20px;`">`r`n" +
                "                  <table border=`"0`" cellpadding=`"0`" cellspacing=`"0`" style=`"border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%;`">`r`n" +
                "                    <tr>`r`n" +
                "                      <td style=`"font-family: sans-serif; font-size: 14px; vertical-align: top;`">`r`n" +
                "                        <h2 style=`"text-align: center; color: #000000;`"></h2>`r`n" +
                "                        <p style=`"font-family: sans-serif; font-size: 14px; font-weight: normal; color: #000000; margin: 0; margin-bottom: 15px; text-align: left;`">Body Text</p>`r`n" +
                "                      </td>`r`n" +
                "                    </tr>`r`n" +
                "                  </table>`r`n" +
                "                </td>`r`n" +
                "              </tr>`r`n" +
                "`r`n" +
                "            <!-- END MAIN CONTENT AREA -->`r`n" +
                "            </table>`r`n" +
                "`r`n" +
                "            <!-- START FOOTER -->`r`n" +
                "            <div class=`"footer`" style=`"clear: both; margin-top: 10px; text-align: center; width: 100%;`">`r`n" +
                "              <table border=`"0`" cellpadding=`"0`" cellspacing=`"0`" style=`"border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%;`">`r`n" +
                "                <tr>`r`n" +
                "                  <td class=`"content-block`" style=`"font-family: sans-serif; vertical-align: top; padding-bottom: 10px; padding-top: 10px; font-size: 12px; color: #999999; text-align: center;`">`r`n" +
                "                  </td>`r`n" +
                "                </tr>`r`n" +
                "              </table>`r`n" +
                "            </div>`r`n" +
                "            <!-- END FOOTER -->`r`n" +
                "`r`n" +
                "          <!-- END CENTERED CONTAINER -->`r`n" +
                "          </div>`r`n" +
                "        </td>`r`n" +
                "        <td style=`"font-family: sans-serif; font-size: 14px; vertical-align: top;`">&nbsp;</td>`r`n" +
                "      </tr>`r`n" +
                "    </table>`r`n" +
                "  </body>`r`n" +
                "</html>")
        }
    }
}
