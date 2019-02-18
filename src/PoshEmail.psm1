$Eol = [System.Environment]::NewLine

function Send-HtmlMailMessage {
    <#
    .SYNOPSIS
        Sends a nicely formatted HTML email.

    .DESCRIPTION
        Sends a nicely formatted HTML email. This cmdlet is designed to work just like Send-MailMessage, with -Heading, 
        -Body, -BodyFormatted, and -Footer replacing the default -Body of Send-MailMessage.

    .INPUTS
        No inputs

    .OUTPUTS
        No outputs

    .EXAMPLE
        Send-HtmlMailMessage -From "server01@contoso.com" -To "admin@contoso.com"

    .LINK
        https://github.com/natescherer/PoshEmail
    #>
    [CmdletBinding(DefaultParameterSetName="Default")]
    param (
        [parameter(ParameterSetName="Default",Mandatory=$true)]
        [parameter(ParameterSetName="Button",Mandatory=$true)]
        # Specifies the address from which the mail is sent. Enter a name (optional) and email address, such as Name <someone@example.com>. This parameter is required.
        [string]$From,

        [parameter(ParameterSetName="Default",Mandatory=$true)]
        [parameter(ParameterSetName="Button",Mandatory=$true)]
        # Specifies the subject of the email message. This parameter is required.
        [string]$Subject,

        [parameter(ParameterSetName="Default",Mandatory=$true)]
        [parameter(ParameterSetName="Button",Mandatory=$true)]
        # Specifies the addresses to which the mail is sent. Enter names (optional) and the email address, such as Name <someone@example.com>. This parameter is required.
        [string[]]$To,

        [parameter(ParameterSetName="Default",Mandatory=$true)]
        [parameter(ParameterSetName="Button",Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        # Specifies a string (with optional HTML formatting) to include in the body of the message. This parameter is required.
        # Multiple paragraphs should have each paragraph wrapped as follows:
        # - <p>Paragraph 1</p><p>Paragraph 2</p>
        # If you need to include preformatted data, you should use the -BodyPreformatted attribute as well
        [string]$Body,

        [parameter(ParameterSetName="Default",Mandatory=$false)]
        [parameter(ParameterSetName="Button",Mandatory=$false)]
        [ValidateSet("Left", "Center", "Right")]
        # Specifies how the body should be aligned. The acceptable values for this parameter are:
        # - Left
        # - Center
        # - Right
        # Left is the default.
        [string]$BodyAlignment = "Left",

        [parameter(ParameterSetName="Default",Mandatory=$false)]
        [parameter(ParameterSetName="Button",Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        # Specifies a string of preformmated text (code, cmdlet output, etc) to include below the body of the message.
        # This will be displayed either in a horizontally-scrolling box or, if Outlook (which can't support scrolling) wrapped with line numbers.
        [string]$BodyPreformatted = "",

        [parameter(ParameterSetName="Default",Mandatory=$false)]
        [parameter(ParameterSetName="Button",Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        # Specifies the path and file names of files to be attached to the email message. You can use this parameter or pipe the paths and file names to Send-HtmlMailMessage.
        [string[]]$Attachments,

        [parameter(ParameterSetName="Default",Mandatory=$false)]
        [parameter(ParameterSetName="Button",Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        # Specifies the email addresses that receive a copy of the mail but are not listed as recipients of the message. Enter names (optional) and the email address, such as Name <someone@example.com>.
        [string[]]$Bcc,

        [parameter(ParameterSetName="Default",Mandatory=$false)]
        [parameter(ParameterSetName="Button",Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        # Specifies the email addresses to which a carbon copy (CC) of the email message is sent. Enter names (optional) and the email address, such as Name <someone@example.com>.
        [string[]]$Cc,

        [parameter(ParameterSetName="Default",Mandatory=$false)]
        [parameter(ParameterSetName="Button",Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        # Specifies a user account that has permission to perform this action. The default is the current user.
        # Type a user name, such as User01 or Domain01\User01. Or, enter a PSCredential object, such as one from the Get-Credential cmdlet.
        [pscredential]$Credential,

        [parameter(ParameterSetName="Default",Mandatory=$false)]
        [parameter(ParameterSetName="Button",Mandatory=$false)]
        [ValidateSet("None", "OnSuccess", "OnFailure", "Delay", "Never")]
        # Specifies the delivery notification options for the email message. You can specify multiple values. None is the default value. The alias for this parameter is dno.
        # The delivery notifications are sent in an email message to the address specified in the value of the From parameter. The acceptable values for this parameter are:
        # - None. No notification.
        # - OnSuccess. Notify if the delivery is successful.
        # - OnFailure. Notify if the delivery is unsuccessful.
        # - Delay. Notify if the delivery is delayed.
        # - Never. Never notify.
        [string]$DeliveryNotificationOption,

        [parameter(ParameterSetName="Default",Mandatory=$false)]
        [parameter(ParameterSetName="Button",Mandatory=$false)]
        [ValidateSet("ASCII", "UTF8", "UTF7", "UTF32", "Unicode", "BigEndianUnicode", "Default", "OEM")]
        # Specifies the encoding used for the body and subject. The acceptable values for this parameter are:
        # - ASCII
        # - UTF8
        # - UTF7
        # - UTF32
        # - Unicode
        # - BigEndianUnicode
        # - Default
        # - OEM
        # ASCII is the default.
        [string]$Encoding,

        [parameter(ParameterSetName="Default",Mandatory=$false)]
        [parameter(ParameterSetName="Button",Mandatory=$false)]
        [ValidateNotNull()]
        # Specifies an alternate port on the SMTP server. The default value is 25, which is the default SMTP port.
        [int]$Port,

        [parameter(ParameterSetName="Default",Mandatory=$false)]
        [parameter(ParameterSetName="Button",Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        # Specifies the name of the SMTP server that sends the email message.
        # The default value is the value of the $PSEmailServer preference variable. If the preference variable is not set and this parameter is omitted, the command fails.
        [string]$SmtpServer,

        [parameter(ParameterSetName="Default",Mandatory=$false)]
        [parameter(ParameterSetName="Button",Mandatory=$false)]
        # Indicates that the cmdlet uses the Secure Sockets Layer (SSL) protocol to establish a connection to the remote computer to send mail. By default, SSL is not used.
        [switch]$UseSsl,

        [parameter(ParameterSetName="Default",Mandatory=$false)]
        [parameter(ParameterSetName="Button",Mandatory=$false)]
        [ValidateSet("High", "Normal", "Low")]
        # Specifies the priority of the email message. The acceptable values for this parameter are:
        # - Normal
        # - High
        # - Low
        # Normal is the default.
        [string]$Priority,

        [parameter(ParameterSetName="Default",Mandatory=$false)]
        [parameter(ParameterSetName="Button",Mandatory=$false)]
        [ValidateNotNull()]
        # Specifies a string (with optional HTML formatting) to include in the heading of the message.
        [string]$Heading = "",

        [parameter(ParameterSetName="Default",Mandatory=$false)]
        [parameter(ParameterSetName="Button",Mandatory=$false)]
        [ValidateSet("Left", "Center", "Right")]
        # Specifies how the heading should be aligned. The acceptable values for this parameter are:
        # - Left
        # - Center
        # - Right
        # Center is the default.
        [string]$HeadingAlignment = "Center",

        [parameter(ParameterSetName="Default",Mandatory=$false)]
        [parameter(ParameterSetName="Button",Mandatory=$false)]
        [ValidateNotNull()]
        # Specifies a string (with optional HTML formatting) to include in the footer of the message.
        [string]$Footer = "",

        [parameter(ParameterSetName="Default",Mandatory=$false)]
        [parameter(ParameterSetName="Button",Mandatory=$false)]
        [ValidateNotNull()]
        # Specifies a string (with optional HTML formatting) to include in the last line of the message.
        [string]$LastLine = "",

        [parameter(ParameterSetName="Button",Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        # Specifies a string to use as label for an optional button.
        [string]$ButtonText,

        [parameter(ParameterSetName="Button",Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        # Specifies a link to use as a target for an optional button.
        [string]$ButtonLink,

        [parameter(ParameterSetName="Button",Mandatory=$false)]
        [ValidateSet("Left", "Center", "Right")]
        # Specifies how the button should be aligned. The acceptable values for this parameter are:
        # - Left
        # - Center
        # - Right
        # Center is the default.
        [string]$ButtonAlignment = "Center"
    )
    process {
        if ($BodyPreformatted) {
            $BodyWidth = "1800"
        } else {
            $BodyWidth = "580"
        }

        $HtmlTop = ("<!doctype html>$Eol" +
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
            "        <td class=`"container`" style=`"font-family: sans-serif; font-size: 14px; vertical-align: top; display: block; margin: 0 auto; max-width: $($BodyWidth)px; padding: 10px;`">$Eol" +
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
            "                      <td style=`"font-family: sans-serif; font-size: 14px; vertical-align: top;`">$Eol")

        $HtmlButton = ("                        <table border=`"0`" cellpadding=`"0`" cellspacing=`"0`" class=`"btn btn-primary`" style=`"border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%; box-sizing: border-box;`">$Eol" +
            "                          <tbody>$Eol" +
            "                            <tr>$Eol" +
            "                              <td align=`"$($ButtonAlignment.ToLower())`" style=`"font-family: sans-serif; font-size: 14px; vertical-align: top; padding-bottom: 15px;`">$Eol" +
            "                                <table border=`"0`" cellpadding=`"0`" cellspacing=`"0`" style=`"border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: auto;`">$Eol" +
            "                                  <tbody>$Eol" +
            "                                    <tr>$Eol" +
            "                                      <td style=`"font-family: sans-serif; font-size: 14px; vertical-align: top; background-color: #3498db; border-radius: 5px; text-align: center;`"> <a href=`"$ButtonLink`" target=`"_blank`" style=`"display: inline-block; color: #ffffff; background-color: #3498db; border: solid 1px #3498db; border-radius: 5px; box-sizing: border-box; cursor: pointer; text-decoration: none; font-size: 14px; font-weight: bold; margin: 0; padding: 12px 25px; text-transform: capitalize; border-color: #3498db;`">$ButtonText</a> </td>$Eol" +
            "                                    </tr>$Eol" +
            "                                  </tbody>$Eol" +
            "                                </table>$Eol" +
            "                              </td>$Eol" +
            "                            </tr>$Eol" +
            "                          </tbody>$Eol" +
            "                        </table>$Eol")

        $HtmlDataToFooter = ("                      </td>$Eol" +
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
            "                  <td class=`"content-block`" style=`"font-family: sans-serif; vertical-align: top; padding-bottom: 10px; padding-top: 10px; font-size: 12px; color: #999999; text-align: center;`">$Eol")

        $HtmlFooterToLastLine = ("                  </td>$Eol" +
            "                </tr>$Eol" +
            "                <tr>$Eol" +
            "                  <td class=`"content-block powered-by`" style=`"font-family: sans-serif; vertical-align: top; padding-bottom: 10px; padding-top: 10px; font-size: 12px; color: #999999; text-align: center;`">$Eol")

        $HtmlBottom = ("                  </td>$Eol" +
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

        if (!$ButtonText) {
            $HtmlButton = ""
        }

        $Heading = "                        <h2 style=`"text-align: $($HeadingAlignment.ToLower());`">$Heading</h2>$Eol"

        if ($Body -notlike "*<p>*") {
            $Body = "<p>$Body</p>"
        }

        if ($Body -like "*<table>*") {
            $Body = $Body -replace '<table>', '<table cellpadding="5" style="border-collapse: collapse; border: 1px solid black;">'
            $Body = $Body -replace '<th>', '<th style="background-color: gray; border: 1px solid black;">'
            $Body = $Body -replace '<td>', '<td style="border: 1px solid black;">'
        }

        if ($Footer) {
            $Footer = "                    $Footer$Eol"
        }

        $LastLine = "                    $LastLine$Eol"

        $Body = $Body -replace "<p>","                        <p style=`"font-family: sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 15px; text-align: $($BodyAlignment.ToLower());`">"
        $Body = $Body -replace "</p>","</p>$Eol"
        if ($BodyPreformatted -ne "") {
            $BodyReformatted = ""
            foreach ($Line in $BodyPreformatted -split $Eol) {
                $Line = $Line -replace " ","&ensp;"
                $BodyReformatted += "                          <li style=`"color: #4169E1; font-family: monospace; font-size: 11px;`"><span class=`"preformatted`" style=`"color: black; font-family: monospace; font-size: 11px; white-space: pre-wrap;`">$Line</span></li>$Eol"
            }

            $BodyPreformatted = ("                      </td>$Eol" +
                "                    </tr>$Eol" +
                "                    <tr>$Eol" +
                "                      <td class=`"preformatted`" width=`"100%`" style=`"font-size: 14px; vertical-align: top; max-width: 100%; overflow: auto; padding-top: 15px; padding-right: 15px;background-color: #F5F5F5; border: 1px solid black;`">$Eol" + 
                "                        <ol class=`"preformatted`">$Eol" +
                "$BodyReformatted" +
                "                        </ol>$Eol")
            $BodyPreformatted = $BodyPreformatted + ("                      </td>$Eol" +
                "                    </tr>$Eol" +
                "                    <tr>$Eol" +
                "                      <td style=`"font-family: sans-serif; font-size: 14px; vertical-align: top;`">$Eol" +
                "                        <p style=`"font-family: sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 15px; text-align: $($BodyAlignment.ToLower());`">&nbsp;</p>$Eol")
        }
        $Footer = $Footer -replace "<a ","<a style=`"text-decoration: underline; color: #999999; font-size: 12px; text-align: center;`" "
        $LastLine = $LastLine -replace "<a ","<a style=`"text-decoration: underline; color: #999999; font-size: 12px; text-align: center;`" "

        $CompleteBody = $HtmlTop + $Heading + $Body + $BodyPreformatted + $HtmlButton +
            $HtmlDataToFooter + $Footer + $HtmlFooterToLastLine + $LastLine + $HtmlBottom

        $SmmParams = @{
            From = $From
            To = $To
            Subject = $Subject
            Body = $CompleteBody
            BodyAsHtml = $true
        }

        if ($Attachments) {
            $SmmParams += @{Attachments = $Attachments}
        }

        if ($Bcc) {
            $SmmParams += @{Bcc = $Bcc}
        }

        if ($Cc) {
            $SmmParams += @{Cc = $Cc}
        }

        if ($Credential) {
            $SmmParams += @{Credential = $Credential}
        }

        if ($DeliveryNotificationOption) {
            $SmmParams += @{DeliveryNotificationOption = $DeliveryNotificationOption}
        }

        if ($Encoding) {
            $SmmParams += @{Encoding = $Encoding}
        }

        if ($Port) {
            $SmmParams += @{Port = $Port}
        }

        if ($Priority) {
            $SmmParams += @{Priority = $Priority}
        }

        if ($SmtpServer) {
            $SmmParams += @{SmtpServer = $SmtpServer}
        }

        if ($UseSsl) {
            $SmmParams += @{UseSsl = $UseSsl}
        }

        # Using Start-Job prevents issues described here: https://stackoverflow.com/questions/43349726/send-mailmessage-closes-every-2nd-connection-when-using-attachments
        Start-Job -ScriptBlock { Send-MailMessage @using:SmmParams } | Wait-Job | Receive-Job
    }
}

function Invoke-CommandWithEmailWrapper {
    <#
    .SYNOPSIS
        Executes a Script or ScriptBlock via Invoke-Command, and provide email alerts either before or before and after execution.

    .DESCRIPTION
        Executes a Script or ScriptBlock either locally on on a remote computer. Provides output of Script/ScriptBlock
        via email after execution completes. Optionally sends an additional email alert at the start of execution.

    .INPUTS
        No inputs

    .OUTPUTS
        Outputs whatever the Script/ScriptBlock you are invoking outputs.

    .EXAMPLE
        Invoke-CommandWithEmailWrapper -ScriptBlock { robocopy c:\source d:\dest } -JobName "RoboCopy" -SmtpServer "smtp01" -EmailTo "admin@contoso.com"

        Executes the robocopy command in the ScriptBlock on the local computer, then sends an email with the command's
        output once it completes.
    
    .EXAMPLE
        Invoke-CommandWithEmailWrapper -Script "c:\scripts\script1.ps1" -JobName "Script1" -SmtpServer "smtp01" -EmailTo "admin@contoso.com" -ComputerName "serv01" -EmailMode "BeforeAndAfter"

        Executes the the script c:\scripts\script1.ps1 (on the local computer) on the remote computer "serv01", sending
        emails when the script begins and finishes running.

    .LINK
        https://github.com/natescherer/PoshEmail
    #>

    [CmdletBinding(DefaultParameterSetName="Script")]
    param (
        [parameter(ParameterSetName="Script",Mandatory=$false)]
        [parameter(ParameterSetName="ScriptBlock",Mandatory=$false)]
        # Computer to execute the command on. Defaults to localhost.
        [string]$ComputerName,

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
    
        [parameter(ParameterSetName="Script",Mandatory=$false)]
        [parameter(ParameterSetName="ScriptBlock",Mandatory=$false)]
        # Specifies to send mail either After or BeforeAndAfter command execution. Defaults to After.
        [ValidateSet("After","BeforeAndAfter")] 
        [string]$EmailMode = "After",
    
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
        [string[]]$EmailTo,

        [parameter(ParameterSetName="Script",Mandatory=$false)]
        [parameter(ParameterSetName="ScriptBlock",Mandatory=$false)]
        # Indicates that the cmdlet uses the Secure Sockets Layer (SSL) protocol to establish a connection to the remote computer to send mail. Defaults to $true
        [switch]$EmailUseSsl = $true
    )

    process {
        if ($ComputerName) {
            $FriendlyComputerName = $ComputerName
        } else {
            $FriendlyComputerName = $env:computername
        }

        $StartTime = Get-Date

        if ($EmailMode -like "BeforeAndAfter") {
            $SmtpParamsBefore = @{
                From = $EmailFrom
                To = $EmailTo
                Subject = "'$JobName' Started on $FriendlyComputerName"
                Heading = "'$JobName' Started on $FriendlyComputerName at $StartTime"
                Body = "'$JobName' Started on $FriendlyComputerName at $StartTime"
                SmtpServer = $SmtpServer
                Port = $SmtpPort
                UseSsl = $EmailUseSsl
            }
            Send-HtmlMailMessage @SMTPParamsBefore
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

        $CommandOutput = Invoke-Command @InvokeCommandParams

        if ($EmailMode -like "*After") {
            $EndTime = Get-Date
            $Elapsed = $EndTime - $StartTime
            $ElapsedString = ("$($Elapsed.days) Days $($Elapsed.Hours) Hours $($Elapsed.Minutes) Minutes " +
                "$($Elapsed.Seconds) Seconds")

            $SmtpParamsAfter = @{
                From = $EmailFrom
                To = $EmailTo
                Subject = "'$JobName' Finished on $FriendlyComputerName"
                Heading =  "'$JobName' Finished on $FriendlyComputerName at $EndTime"
                Body = "Output:"
                BodyPreformatted = $CommandOutput | Out-String
                Footer = "Time elapsed: $ElapsedString"
                SmtpServer = $SmtpServer
                Port = $SmtpPort
                UseSsl = $EmailUseSsl
            }

            Send-HtmlMailMessage @SMTPParamsAfter
        }

        $CommandOutput
    }
}


Export-ModuleMember -Function Send-HtmlMailMessage
Export-ModuleMember -Function Invoke-CommandWithEmailWrapper