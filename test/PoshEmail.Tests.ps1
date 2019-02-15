$Eol = [System.Environment]::NewLine

$ModuleName = Split-Path -Path ($PSCommandPath -replace '\.Tests\.ps1$','') -Leaf
$ModulePath = "$(Split-Path -Path $PSScriptRoot -Parent)\src\$ModuleName.psm1"
Get-Module -Name $ModuleName -All | Remove-Module -Force -ErrorAction Ignore
Import-Module -Name $ModulePath -Force -ErrorAction Stop

InModuleScope $ModuleName {
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

    Write-Host "`Note that all Pending tests are due to MailHog v1.0.0 lacking features needed to do the test." -ForegroundColor Yellow

    $MHCreds = "user:`$2a`$04`$DDYXcbOLmLtq5OJ7Ue.gDe45X1T2cfGtuiwrt4LaxLgUK8zKrCoSq"
    $MHCredFile = "$TempDir\mhcreds.txt"
    Set-Content -Value $MHCreds -Path $MHCredFile -NoNewline
    if ($IsWindows) {
        Start-Process -FilePath "$env:GOPATH\bin\MailHog$ExeSuffix" -ArgumentList "-smtp-bind-addr", "0.0.0.0:25", "-api-bind-addr", "0.0.0.0:8025", "-ui-bind-addr", "0.0.0.0:8025"
        Start-Process -FilePath "$env:GOPATH\bin\MailHog$ExeSuffix" -ArgumentList "-smtp-bind-addr", "0.0.0.0:1025", "-api-bind-addr", "0.0.0.0:9025", "-ui-bind-addr", "0.0.0.0:9025"
        Start-Process -FilePath "$env:GOPATH\bin\MailHog$ExeSuffix" -ArgumentList "-smtp-bind-addr", "0.0.0.0:2025", "-api-bind-addr", "0.0.0.0:10025", "-ui-bind-addr", "0.0.0.0:10025","-auth-file", $MHCredFile
    } else {
        Start-Process -FilePath "sudo" -ArgumentList "$env:GOPATH/bin/MailHog", "-smtp-bind-addr", "0.0.0.0:25", "-api-bind-addr", "0.0.0.0:8025", "-ui-bind-addr", "0.0.0.0:8025" -RedirectStandardOutput "~/output.txt"
        Start-Process -FilePath "sudo" -ArgumentList "$env:GOPATH/bin/MailHog", "-smtp-bind-addr", "0.0.0.0:1025", "-api-bind-addr", "0.0.0.0:9025", "-ui-bind-addr", "0.0.0.0:9025" -RedirectStandardOutput "~/output.txt"
        Start-Process -FilePath "sudo" -ArgumentList "$env:GOPATH/bin/MailHog", "-smtp-bind-addr", "0.0.0.0:2025", "-api-bind-addr", "0.0.0.0:10025", "-ui-bind-addr", "0.0.0.0:10025", "-auth-file", $MHCredFile -RedirectStandardOutput "~/output.txt"

    }
    Start-Sleep -Seconds $ProccessStartSleep

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
            Invoke-RestMethod -Uri http://localhost:8025/api/v1/messages -Method "DELETE"

            $Source = $Response.Items[0].Content.Body

            $NewSource = ""

            foreach ($Line in ($Source -split $Eol)) {
                $NewSource += $Line -replace "=$",""
            }

            $Source = $NewSource -replace "=0D=0A",$Eol
            $Source = $Source -replace "=0A",$Eol
            $Source = $Source -replace "=3D","="

            $Source | Should -Be ("<!doctype html>$Eol" +
                "<html>$Eol" +
                "  <head>$Eol" +
                "    <meta name=`"viewport`" content=`"width=device-width`">$Eol" +
                "    <meta http-equiv=`"Content-Type`" content=`"text/html; charset=UTF-8`">$Eol" +
                "    <title></title>$Eol" +
                "    <style>$Eol" +
                "    /* -------------------------------------$Eol" +
                "        INLINED WITH htmlemail.io/inline$Eol" +
                "    ------------------------------------- */$Eol" +
                "    /* -------------------------------------$Eol" +
                "        RESPONSIVE AND MOBILE FRIENDLY STYLES$Eol" +
                "    ------------------------------------- */$Eol" +
                "    @media only screen and (max-width: 620px) {$Eol" +
                "      table[class=body] h1 {$Eol" +
                "        font-size: 28px !important;$Eol" +
                "        margin-bottom: 10px !important;$Eol" +
                "      }$Eol" +
                "      table[class=body] p,$Eol" +
                "      table[class=body] ul,$Eol" +
                "      table[class=body] ol,$Eol" +
                "      table[class=body] td,$Eol" +
                "      table[class=body] span,$Eol" +
                "      table[class=body] a {$Eol" +
                "        font-size: 16px !important;$Eol" +
                "      }$Eol" +
                "      table[class=body] .preformatted {$Eol" +
                "        font-size: 11px !important;$Eol" +
                "      }$Eol" +
                "      table[class=body] .wrapper,$Eol" +
                "            table[class=body] .article {$Eol" +
                "        padding: 10px !important;$Eol" +
                "      }$Eol" +
                "      table[class=body] .content {$Eol" +
                "        padding: 0 !important;$Eol" +
                "      }$Eol" +
                "      table[class=body] .container {$Eol" +
                "        padding: 0 !important;$Eol" +
                "        width: 100% !important;$Eol" +
                "      }$Eol" +
                "      table[class=body] .main {$Eol" +
                "        border-left-width: 0 !important;$Eol" +
                "        border-radius: 0 !important;$Eol" +
                "        border-right-width: 0 !important;$Eol" +
                "      }$Eol" +
                "      table[class=body] .btn table {$Eol" +
                "        width: 100% !important;$Eol" +
                "      }$Eol" +
                "      table[class=body] .btn a {$Eol" +
                "        width: 100% !important;$Eol" +
                "      }$Eol" +
                "      table[class=body] .img-responsive {$Eol" +
                "        height: auto !important;$Eol" +
                "        max-width: 100% !important;$Eol" +
                "        width: auto !important;$Eol" +
                "      }$Eol" +
                "    }$Eol" +
                "$Eol" +
                "    /* -------------------------------------$Eol" +
                "        PRESERVE THESE STYLES IN THE HEAD$Eol" +
                "    ------------------------------------- */$Eol" +
                "    @media all {$Eol" +
                "      .ExternalClass {$Eol" +
                "        width: 100%;$Eol" +
                "      }$Eol" +
                "      .ExternalClass,$Eol" +
                "      .ExternalClass p,$Eol" +
                "      .ExternalClass span,$Eol" +
                "      .ExternalClass font,$Eol" +
                "      .ExternalClass td,$Eol" +
                "      .ExternalClass div {$Eol" +
                "        line-height: 100%;$Eol" +
                "      }$Eol" +
                "      .btn-primary table td:hover {$Eol" +
                "        background-color: #34495e !important;$Eol" +
                "      }$Eol" +
                "      .btn-primary a:hover {$Eol" +
                "        background-color: #34495e !important;$Eol" +
                "        border-color: #34495e !important;$Eol" +
                "      }$Eol" +
                "    }$Eol" +
                "   </style>$Eol" +
                "  </head>$Eol" +
                "  <body class=`"`" style=`"background-color: #f6f6f6; font-family: sans-serif; -webkit-font-smoothing: antialiased; font-size: 14px; line-height: 1.4; margin: 0; padding: 0; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%;`">$Eol" +
                "    <table border=`"0`" cellpadding=`"0`" cellspacing=`"0`" class=`"body`" style=`"border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%; background-color: #f6f6f6;`">$Eol" +
                "      <tr>$Eol" +
                "        <td style=`"font-family: sans-serif; font-size: 14px; vertical-align: top;`">&nbsp;</td>$Eol" +
                "        <td class=`"container`" style=`"font-family: sans-serif; font-size: 14px; vertical-align: top; display: block; margin: 0 auto; max-width: 580px; padding: 10px;`">$Eol" +
                "          <div class=`"content`" style=`"box-sizing: border-box; display: block; margin: 0 auto; max-width: 100%; padding: 10px;`">$Eol" +
                "$Eol" +
                "            <!-- START CENTERED WHITE CONTAINER -->$Eol" +
                "            <span class=`"preheader`" style=`"color: transparent; display: none; height: 0; max-height: 0; max-width: 0; opacity: 0; overflow: hidden; mso-hide: all; visibility: hidden; width: 0;`"></span>$Eol" +
                "            <table class=`"main`" style=`"border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%; background: #ffffff; border-radius: 3px;`">$Eol" +
                "$Eol" +
                "              <!-- START MAIN CONTENT AREA -->$Eol" +
                "              <tr>$Eol" +
                "                <td class=`"wrapper`" style=`"font-family: sans-serif; font-size: 14px; vertical-align: top; box-sizing: border-box; padding: 20px;`">$Eol" +
                "                  <table border=`"0`" cellpadding=`"0`" cellspacing=`"0`" style=`"border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%;`">$Eol" +
                "                    <tr>$Eol" +
                "                      <td style=`"font-family: sans-serif; font-size: 14px; vertical-align: top;`">$Eol" +
                "                        <h2 style=`"text-align: center;`"></h2>$Eol" +
                "                        <p style=`"font-family: sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 15px; text-align: left;`">Body Text</p>$Eol" +
                "                      </td>$Eol" +
                "                    </tr>$Eol" +
                "                  </table>$Eol" +
                "                </td>$Eol" +
                "              </tr>$Eol" +
                "$Eol" +
                "            <!-- END MAIN CONTENT AREA -->$Eol" +
                "            </table>$Eol" +
                "$Eol" +
                "            <!-- START FOOTER -->$Eol" +
                "            <div class=`"footer`" style=`"clear: both; margin-top: 10px; text-align: center; width: 100%;`">$Eol" +
                "              <table border=`"0`" cellpadding=`"0`" cellspacing=`"0`" style=`"border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%;`">$Eol" +
                "                <tr>$Eol" +
                "                  <td class=`"content-block`" style=`"font-family: sans-serif; vertical-align: top; padding-bottom: 10px; padding-top: 10px; font-size: 12px; color: #999999; text-align: center;`">$Eol" +
                "                  </td>$Eol" +
                "                </tr>$Eol" +
                "                <tr>$Eol" +
                "                  <td class=`"content-block powered-by`" style=`"font-family: sans-serif; vertical-align: top; padding-bottom: 10px; padding-top: 10px; font-size: 12px; color: #999999; text-align: center;`">$Eol" +
                "                    Powered by <a style=`"text-decoration: underline; color: #999999; font-size: 12px; text-align: center;`" href=`"https://github.com/natescherer/PoshEmail`">PoshEmail</a>.$Eol" +
                "                  </td>$Eol" +
                "                </tr>$Eol" +
                "              </table>$Eol" +
                "            </div>$Eol" +
                "            <!-- END FOOTER -->$Eol" +
                "$Eol" +
                "          <!-- END CENTERED WHITE CONTAINER -->$Eol" +
                "          </div>$Eol" +
                "        </td>$Eol" +
                "        <td style=`"font-family: sans-serif; font-size: 14px; vertical-align: top;`">&nbsp;</td>$Eol" +
                "      </tr>$Eol" +
                "    </table>$Eol" +
                "  </body>$Eol" +
                "</html>$Eol")
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
            Invoke-RestMethod -Uri http://localhost:8025/api/v1/messages -Method "DELETE"

            $Source = $Response.Items[0].Content.Body

            $NewSource = ""

            foreach ($Line in ($Source -split $Eol)) {
                $NewSource += $Line -replace "=$",""
            }

            $Source = $NewSource -replace "=0D=0A",$Eol
            $Source = $Source -replace "=0A",$Eol
            $Source = $Source -replace "=3D","="

            $Source | Should -Match "<p style=`"font-family: sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 15px; text-align: center;`">Body Text</p>$Eol"
        }    
        It '-BodyPreformatted' {
            $ShmmParams = @{
                From = "PoshEmail@test.local"
                To = "rcpt@test.local"
                Subject = "PoshEmail Test"
                SmtpServer = "127.0.0.1"
                Body = "Body Text"
                BodyPreformatted = ("$Eol" +
                    "$Eol" +
                    "    Directory: C:\code\PoshEmail$Eol" +
                    "$Eol" +
                    "$Eol" +
                    "Mode                LastWriteTime         Length Name$Eol" +
                    "----                -------------         ------ ----$Eol" +
                    "d-----       10/24/2018   9:27 AM                .vscode$Eol" +
                    "d-----       10/11/2018  11:17 AM                docs$Eol" +
                    "d-----       10/11/2018  11:17 AM                out$Eol" +
                    "d-----       10/25/2018   7:15 AM                src$Eol" +
                    "d-----       10/29/2018  11:47 AM                test$Eol" +
                    "-a----       10/24/2018   9:27 AM            160 .gitignore$Eol" +
                    "-a----       10/29/2018  10:44 AM           6194 appveyor.yml$Eol" +
                    "-a----       10/29/2018  10:44 AM           2113 appveyordeploy.ps1$Eol" +
                    "-a----        10/5/2018   2:39 PM            351 CHANGELOG.md$Eol" +
                    "-a----        10/5/2018   2:51 PM           2095 CONTRIBUTING.md$Eol" +
                    "-a----        9/26/2018   2:18 PM           1080 LICENSE$Eol" +
                    "-a----       10/24/2018   9:27 AM          14016 PoshEmail.build.ps1$Eol" +
                    "-a----       10/24/2018   9:37 AM           1383 README.md")
            }

            Send-HtmlMailMessage @ShmmParams

            Start-Sleep -Seconds $EmailSendSleep

            $Response = Invoke-RestMethod -Uri http://localhost:8025/api/v2/messages
            Invoke-RestMethod -Uri http://localhost:8025/api/v1/messages -Method "DELETE"

            $Source = $Response.Items[0].Content.Body

            $NewSource = ""

            foreach ($Line in ($Source -split $Eol)) {
                $NewSource += $Line -replace "=$",""
            }

            $Source = $NewSource -replace "=0D=0A",$Eol
            $Source = $Source -replace "=0A",$Eol
            $Source = $Source -replace "=3D","="

            $Source | Should -Match ("                      </td>$Eol" +
                "                    </tr>$Eol" +
                "                    <tr>$Eol" +
                "                      <td class=`"preformatted`" width=`"100%`" style=`"font-size: 14px; vertical-align: top; max-width: 100%; overflow: auto; padding-top: 15px; padding-right: 15px;background-color: #F5F5F5; border: 1px solid black;`">$Eol" +
                "                        <ol class=`"preformatted`">$Eol" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`"></span></li>$Eol" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`"></span></li>$Eol" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">&ensp;&ensp;&ensp;&ensp;Directory:&ensp;C:\\code\\PoshEmail</span></li>$Eol" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`"></span></li>$Eol" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`"></span></li>$Eol" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">Mode&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;LastWriteTime&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;Length&ensp;Name</span></li>$Eol" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">----&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;-------------&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;------&ensp;----</span></li>$Eol" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">d-----&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;10/24/2018&ensp;&ensp;&ensp;9:27&ensp;AM&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;.vscode</span></li>$Eol" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">d-----&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;10/11/2018&ensp;&ensp;11:17&ensp;AM&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;docs</span></li>$Eol" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">d-----&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;10/11/2018&ensp;&ensp;11:17&ensp;AM&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;out</span></li>$Eol" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">d-----&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;10/25/2018&ensp;&ensp;&ensp;7:15&ensp;AM&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;src</span></li>$Eol" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">d-----&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;10/29/2018&ensp;&ensp;11:47&ensp;AM&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;test</span></li>$Eol" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">-a----&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;10/24/2018&ensp;&ensp;&ensp;9:27&ensp;AM&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;160&ensp;.gitignore</span></li>$Eol" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">-a----&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;10/29/2018&ensp;&ensp;10:44&ensp;AM&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;6194&ensp;appveyor.yml</span></li>$Eol" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">-a----&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;10/29/2018&ensp;&ensp;10:44&ensp;AM&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;2113&ensp;appveyordeploy.ps1</span></li>$Eol" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">-a----&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;10/5/2018&ensp;&ensp;&ensp;2:39&ensp;PM&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;351&ensp;CHANGELOG.md</span></li>$Eol" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">-a----&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;10/5/2018&ensp;&ensp;&ensp;2:51&ensp;PM&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;2095&ensp;CONTRIBUTING.md</span></li>$Eol" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">-a----&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;9/26/2018&ensp;&ensp;&ensp;2:18&ensp;PM&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;1080&ensp;LICENSE</span></li>$Eol" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">-a----&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;10/24/2018&ensp;&ensp;&ensp;9:27&ensp;AM&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;14016&ensp;PoshEmail.build.ps1</span></li>$Eol" +
                "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">-a----&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;10/24/2018&ensp;&ensp;&ensp;9:37&ensp;AM&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;1383&ensp;README.md</span></li>$Eol" +
                "                        </ol>$Eol" +
                "                      </td>$Eol" +
                "                    </tr>$Eol" +
                "                    <tr>$Eol" +
                "                      <td style=`"font-family: sans-serif; font-size: 14px; vertical-align: top;`">$Eol" +
                "                        <p style=`"font-family: sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 15px; text-align: left;`">&nbsp;</p>$Eol")
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
            Invoke-RestMethod -Uri http://localhost:8025/api/v1/messages -Method "DELETE"

            $Source = $Response.Items[0].Content.Body

            $NewSource = ""

            foreach ($Line in ($Source -split $Eol)) {
                $NewSource += $Line -replace "=$",""
            }

            $Source = $NewSource -replace "=0D=0A",$Eol
            $Source = $Source -replace "=0A",$Eol
            $Source = $Source -replace "=3D","="

            $Source | Should -Match "VGhpcyBpcyBhIGxpbmUgb2YgdGV4dCB3aXRoIG5vIGxpbmUgYnJlYWtzIHNvIHRoZSBiYXNlNjQgaXMgdGhlIHNhbWUgb24gYWxsIHBsYXRmb3Jtcw=="
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
            Invoke-RestMethod -Uri http://localhost:10025/api/v1/messages -Method "DELETE"

            $Source = $Response.Items[0].Content.Body

            $NewSource = ""

            foreach ($Line in ($Source -split $Eol)) {
                $NewSource += $Line -replace "=$",""
            }

            $Source = $NewSource -replace "=0D=0A",$Eol
            $Source = $Source -replace "=0A",$Eol
            $Source = $Source -replace "=3D","="

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
            Invoke-RestMethod -Uri http://localhost:9025/api/v1/messages -Method "DELETE"

            $Source = $Response.Items[0].Content.Body

            $NewSource = ""

            foreach ($Line in ($Source -split $Eol)) {
                $NewSource += $Line -replace "=$",""
            }

            $Source = $NewSource -replace "=0D=0A",$Eol
            $Source = $Source -replace "=0A",$Eol
            $Source = $Source -replace "=3D","="

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
            Invoke-RestMethod -Uri http://localhost:8025/api/v1/messages -Method "DELETE"
    
            $Source = $Response.Items[0].Content.Body
    
            $NewSource = ""
    
            foreach ($Line in ($Source -split $Eol)) {
                $NewSource += $Line -replace "=$",""
            }
    
            $Source = $NewSource -replace "=0D=0A",$Eol
            $Source = $Source -replace "=0A",$Eol
            $Source = $Source -replace "=3D","="
    
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
            Invoke-RestMethod -Uri http://localhost:8025/api/v1/messages -Method "DELETE"
    
            $Source = $Response.Items[0].Content.Body
    
            $NewSource = ""
    
            foreach ($Line in ($Source -split $Eol)) {
                $NewSource += $Line -replace "=$",""
            }
    
            $Source = $NewSource -replace "=0D=0A",$Eol
            $Source = $Source -replace "=0A",$Eol
            $Source = $Source -replace "=3D","="
    
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
            Invoke-RestMethod -Uri http://localhost:8025/api/v1/messages -Method "DELETE"
    
            $Source = $Response.Items[0].Content.Body
    
            $NewSource = ""
    
            foreach ($Line in ($Source -split $Eol)) {
                $NewSource += $Line -replace "=$",""
            }
    
            $Source = $NewSource -replace "=0D=0A",$Eol
            $Source = $Source -replace "=0A",$Eol
            $Source = $Source -replace "=3D","="
    
            $Source | Should -Match ("<td class=`"content-block`" style=`"font-family: sans-serif; vertical-align: top; padding-bottom: 10px; padding-top: 10px; font-size: 12px; color: #999999; text-align: center;`">$Eol" +
                "                    Test Footer$Eol" +
                "                  </td>$Eol")
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
            Invoke-RestMethod -Uri http://localhost:8025/api/v1/messages -Method "DELETE"
    
            $Source = $Response.Items[0].Content.Body
    
            $NewSource = ""
    
            foreach ($Line in ($Source -split $Eol)) {
                $NewSource += $Line -replace "=$",""
            }
    
            $Source = $NewSource -replace "=0D=0A",$Eol
            $Source = $Source -replace "=0A",$Eol
            $Source = $Source -replace "=3D","="
    
            $Source | Should -Match ("<td class=`"content-block powered-by`" style=`"font-family: sans-serif; vertical-align: top; padding-bottom: 10px; padding-top: 10px; font-size: 12px; color: #999999; text-align: center;`">$Eol" +
                "                    Test LastLine$Eol" +
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
            Invoke-RestMethod -Uri http://localhost:8025/api/v1/messages -Method "DELETE"
    
            $Source = $Response.Items[0].Content.Body
    
            $NewSource = ""
    
            foreach ($Line in ($Source -split $Eol)) {
                $NewSource += $Line -replace "=$",""
            }
    
            $Source = $NewSource -replace "=0D=0A",$Eol
            $Source = $Source -replace "=0A",$Eol
            $Source = $Source -replace "=3D","="
    
            $Source | Should -Match ("<table border=`"0`" cellpadding=`"0`" cellspacing=`"0`" class=`"btn btn-primary`" style=`"border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%; box-sizing: border-box;`">$Eol" +
            "                          <tbody>$Eol" +
            "                            <tr>$Eol" +
            "                              <td align=`"center`" style=`"font-family: sans-serif; font-size: 14px; vertical-align: top; padding-bottom: 15px;`">$Eol" +
            "                                <table border=`"0`" cellpadding=`"0`" cellspacing=`"0`" style=`"border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: auto;`">$Eol" +
            "                                  <tbody>$Eol" +
            "                                    <tr>$Eol" +
            "                                      <td style=`"font-family: sans-serif; font-size: 14px; vertical-align: top; background-color: #3498db; border-radius: 5px; text-align: center;`"> <a href=`"https://testbuttonlink.com`" target=`"_blank`" style=`"display: inline-block; color: #ffffff; background-color: #3498db; border: solid 1px #3498db; border-radius: 5px; box-sizing: border-box; cursor: pointer; text-decoration: none; font-size: 14px; font-weight: bold; margin: 0; padding: 12px 25px; text-transform: capitalize; border-color: #3498db;`">Test ButtonText</a> </td>$Eol" +
            "                                    </tr>$Eol" +
            "                                  </tbody>$Eol" +
            "                                </table>$Eol" +
            "                              </td>$Eol" +
            "                            </tr>$Eol" +
            "                          </tbody>$Eol" +
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
            Invoke-RestMethod -Uri http://localhost:8025/api/v1/messages -Method "DELETE"
    
            $Source = $Response.Items[0].Content.Body
    
            $NewSource = ""
    
            foreach ($Line in ($Source -split $Eol)) {
                $NewSource += $Line -replace "=$",""
            }
    
            $Source = $NewSource -replace "=0D=0A",$Eol
            $Source = $Source -replace "=0A",$Eol
            $Source = $Source -replace "=3D","="
    
            $Source | Should -Match ("<table border=`"0`" cellpadding=`"0`" cellspacing=`"0`" class=`"btn btn-primary`" style=`"border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%; box-sizing: border-box;`">$Eol" +
            "                          <tbody>$Eol" +
            "                            <tr>$Eol" +
            "                              <td align=`"left`" style=`"font-family: sans-serif; font-size: 14px; vertical-align: top; padding-bottom: 15px;`">$Eol" +
            "                                <table border=`"0`" cellpadding=`"0`" cellspacing=`"0`" style=`"border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: auto;`">$Eol" +
            "                                  <tbody>$Eol" +
            "                                    <tr>$Eol" +
            "                                      <td style=`"font-family: sans-serif; font-size: 14px; vertical-align: top; background-color: #3498db; border-radius: 5px; text-align: center;`"> <a href=`"https://testbuttonlink.com`" target=`"_blank`" style=`"display: inline-block; color: #ffffff; background-color: #3498db; border: solid 1px #3498db; border-radius: 5px; box-sizing: border-box; cursor: pointer; text-decoration: none; font-size: 14px; font-weight: bold; margin: 0; padding: 12px 25px; text-transform: capitalize; border-color: #3498db;`">Test ButtonText</a> </td>$Eol" +
            "                                    </tr>$Eol" +
            "                                  </tbody>$Eol" +
            "                                </table>$Eol" +
            "                              </td>$Eol" +
            "                            </tr>$Eol" +
            "                          </tbody>$Eol" +
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
            Invoke-RestMethod -Uri http://localhost:8025/api/v1/messages -Method "DELETE"

            Remove-Item $SourcePath -Force -Recurse
            Remove-Item $DestPath -Force -Recurse

            $Source = $Response.Items[0].Content.Body

            $NewSource = ""

            foreach ($Line in ($Source -split $Eol)) {
                $NewSource += $Line -replace "=$",""
            }

            $Source = $NewSource -replace "=0D=0A",$Eol
            $Source = $Source -replace "=0A",$Eol
            $Source = $Source -replace "=3D","="

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

            $Source = $Response.Items[0].Content.Body

            $NewSource = ""

            foreach ($Line in ($Source -split $Eol)) {
                $NewSource += $Line -replace "=$",""
            }

            $Source = $NewSource -replace "=0D=0A",$Eol
            $Source = $Source -replace "=0A",$Eol
            $Source = $Source -replace "=3D","="

            $Source | Should -Match "ROBOCOPY&ensp;&ensp;&ensp;&ensp;&ensp;::&ensp;&ensp;&ensp;&ensp;&ensp;Robust&ensp;File&ensp;Copy&ensp;for&ensp;Windows"

        }
    }
}
