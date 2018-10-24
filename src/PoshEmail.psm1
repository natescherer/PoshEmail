function Send-HtmlMailMessage {
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
        [string]$BodyData,

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
        # Specifies a string (with optional HTML formatting) to include in the header of the message.
        [string]$HeaderData = "",

        [parameter(ParameterSetName="Default",Mandatory=$false)]
        [parameter(ParameterSetName="Button",Mandatory=$false)]
        [ValidateNotNull()]
        # Specifies a string (with optional HTML formatting) to include in the body of the message.
        [string]$FooterData = "",

        [parameter(ParameterSetName="Button",Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        # Specifies a string to use as label for an optional button.
        [switch]$ButtonText,

        [parameter(ParameterSetName="Button",Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        # Specifies a link to use as a target for an optional button.
        [string]$ButtonLink      
    )
    process {
        $HtmlTop = ("<!doctype html>$Eol" +
            "<html>$Eol" +
            "  <head>$Eol" +
            "    <meta name=`"viewport`" content=`"width=device-width`" />$Eol" +
            "    <meta http-equiv=`"Content-Type`" content=`"text/html; charset=UTF-8`" />$Eol" +
            "    <title>Simple Transactional Email</title>$Eol" +
            "    <style>$Eol" +
            "      /* -------------------------------------$Eol" +
            "          GLOBAL RESETS$Eol" +
            "      ------------------------------------- */$Eol" +
            "      img {$Eol" +
            "        border: none;$Eol" +
            "        -ms-interpolation-mode: bicubic;$Eol" +
            "        max-width: 100%; }$Eol" +
            "$Eol" +
            "      body {$Eol" +
            "        background-color: #f6f6f6;$Eol" +
            "        font-family: sans-serif;$Eol" +
            "        -webkit-font-smoothing: antialiased;$Eol" +
            "        font-size: 14px;$Eol" +
            "        line-height: 1.4;$Eol" +
            "        margin: 0;$Eol" +
            "        padding: 0;$Eol" +
            "        -ms-text-size-adjust: 100%;$Eol" +
            "        -webkit-text-size-adjust: 100%; }$Eol" +
            "$Eol" +
            "      table {$Eol" +
            "        border-collapse: separate;$Eol" +
            "        mso-table-lspace: 0pt;$Eol" +
            "        mso-table-rspace: 0pt;$Eol" +
            "        width: 100%; }$Eol" +
            "        table td {$Eol" +
            "          font-family: sans-serif;$Eol" +
            "          font-size: 14px;$Eol" +
            "          vertical-align: top; }$Eol" +
            "$Eol" +
            "      /* -------------------------------------$Eol" +
            "          BODY & CONTAINER$Eol" +
            "      ------------------------------------- */$Eol" +
            "$Eol" +
            "      .body {$Eol" +
            "        background-color: #f6f6f6;$Eol" +
            "        width: 100%; }$Eol" +
            "$Eol" +
            "      /* Set a max-width, and make it display as block so it will automatically stretch to that width, but will also shrink down on a phone or something */$Eol" +
            "      .container {$Eol" +
            "        display: block;$Eol" +
            "        Margin: 0 auto !important;$Eol" +
            "        /* makes it centered */$Eol" +
            "        max-width: 580px;$Eol" +
            "        padding: 10px;$Eol" +
            "        width: 580px; }$Eol" +
            "$Eol" +
            "      /* This should also be a block element, so that it will fill 100% of the .container */$Eol" +
            "      .content {$Eol" +
            "        box-sizing: border-box;$Eol" +
            "        display: block;$Eol" +
            "        Margin: 0 auto;$Eol" +
            "        max-width: 580px;$Eol" +
            "        padding: 10px; }$Eol" +
            "$Eol" +
            "      /* -------------------------------------$Eol" +
            "          HEADER, FOOTER, MAIN$Eol" +
            "      ------------------------------------- */$Eol" +
            "      .main {$Eol" +
            "        background: #ffffff;$Eol" +
            "        border-radius: 3px;$Eol" +
            "        width: 100%; }$Eol" +
            "$Eol" +
            "      .wrapper {$Eol" +
            "        box-sizing: border-box;$Eol" +
            "        padding: 20px; }$Eol" +
            "$Eol" +
            "      .content-block {$Eol" +
            "        padding-bottom: 10px;$Eol" +
            "        padding-top: 10px;$Eol" +
            "      }$Eol" +
            "$Eol" +
            "      .footer {$Eol" +
            "        clear: both;$Eol" +
            "        Margin-top: 10px;$Eol" +
            "        text-align: center;$Eol" +
            "        width: 100%; }$Eol" +
            "        .footer td,$Eol" +
            "        .footer p,$Eol" +
            "        .footer span,$Eol" +
            "        .footer a {$Eol" +
            "          color: #999999;$Eol" +
            "          font-size: 12px;$Eol" +
            "          text-align: center; }$Eol" +
            "$Eol" +
            "      /* -------------------------------------$Eol" +
            "          TYPOGRAPHY$Eol" +
            "      ------------------------------------- */$Eol" +
            "      h1,$Eol" +
            "      h2,$Eol" +
            "      h3,$Eol" +
            "      h4 {$Eol" +
            "        color: #000000;$Eol" +
            "        font-family: sans-serif;$Eol" +
            "        font-weight: 400;$Eol" +
            "        line-height: 1.4;$Eol" +
            "        margin: 0;$Eol" +
            "        Margin-bottom: 30px; }$Eol" +
            "$Eol" +
            "      h1 {$Eol" +
            "        font-size: 35px;$Eol" +
            "        font-weight: 300;$Eol" +
            "        text-align: center;$Eol" +
            "        text-transform: capitalize; }$Eol" +
            "$Eol" +
            "      p,$Eol" +
            "      ul,$Eol" +
            "      ol {$Eol" +
            "        font-family: sans-serif;$Eol" +
            "        font-size: 14px;$Eol" +
            "        font-weight: normal;$Eol" +
            "        margin: 0;$Eol" +
            "        Margin-bottom: 15px; }$Eol" +
            "        p li,$Eol" +
            "        ul li,$Eol" +
            "        ol li {$Eol" +
            "          list-style-position: inside;$Eol" +
            "          margin-left: 5px; }$Eol" +
            "$Eol" +
            "      a {$Eol" +
            "        color: #3498db;$Eol" +
            "        text-decoration: underline; }$Eol" +
            "$Eol" +
            "      /* -------------------------------------$Eol" +
            "          BUTTONS$Eol" +
            "      ------------------------------------- */$Eol" +
            "      .btn {$Eol" +
            "        box-sizing: border-box;$Eol" +
            "        width: 100%; }$Eol" +
            "        .btn > tbody > tr > td {$Eol" +
            "          padding-bottom: 15px; }$Eol" +
            "        .btn table {$Eol" +
            "          width: auto; }$Eol" +
            "        .btn table td {$Eol" +
            "          background-color: #ffffff;$Eol" +
            "          border-radius: 5px;$Eol" +
            "          text-align: center; }$Eol" +
            "        .btn a {$Eol" +
            "          background-color: #ffffff;$Eol" +
            "          border: solid 1px #3498db;$Eol" +
            "          border-radius: 5px;$Eol" +
            "          box-sizing: border-box;$Eol" +
            "          color: #3498db;$Eol" +
            "          cursor: pointer;$Eol" +
            "          display: inline-block;$Eol" +
            "          font-size: 14px;$Eol" +
            "          font-weight: bold;$Eol" +
            "          margin: 0;$Eol" +
            "          padding: 12px 25px;$Eol" +
            "          text-decoration: none;$Eol" +
            "          text-transform: capitalize; }$Eol" +
            "$Eol" +
            "      .btn-primary table td {$Eol" +
            "        background-color: #3498db; }$Eol" +
            "$Eol" +
            "      .btn-primary a {$Eol" +
            "        background-color: #3498db;$Eol" +
            "        border-color: #3498db;$Eol" +
            "        color: #ffffff; }$Eol" +
            "$Eol" +
            "      /* -------------------------------------$Eol" +
            "          OTHER STYLES THAT MIGHT BE USEFUL$Eol" +
            "      ------------------------------------- */$Eol" +
            "      .last {$Eol" +
            "        margin-bottom: 0; }$Eol" +
            "$Eol" +
            "      .first {$Eol" +
            "        margin-top: 0; }$Eol" +
            "$Eol" +
            "      .align-center {$Eol" +
            "        text-align: center; }$Eol" +
            "$Eol" +
            "      .align-right {$Eol" +
            "        text-align: right; }$Eol" +
            "$Eol" +
            "      .align-left {$Eol" +
            "        text-align: left; }$Eol" +
            "$Eol" +
            "      .clear {$Eol" +
            "        clear: both; }$Eol" +
            "$Eol" +
            "      .mt0 {$Eol" +
            "        margin-top: 0; }$Eol" +
            "$Eol" +
            "      .mb0 {$Eol" +
            "        margin-bottom: 0; }$Eol" +
            "$Eol" +
            "      .preheader {$Eol" +
            "        color: transparent;$Eol" +
            "        display: none;$Eol" +
            "        height: 0;$Eol" +
            "        max-height: 0;$Eol" +
            "        max-width: 0;$Eol" +
            "        opacity: 0;$Eol" +
            "        overflow: hidden;$Eol" +
            "        mso-hide: all;$Eol" +
            "        visibility: hidden;$Eol" +
            "        width: 0; }$Eol" +
            "$Eol" +
            "      .powered-by a {$Eol" +
            "        text-decoration: none; }$Eol" +
            "$Eol" +
            "      hr {$Eol" +
            "        border: 0;$Eol" +
            "        border-bottom: 1px solid #f6f6f6;$Eol" +
            "        Margin: 20px 0; }$Eol" +
            "$Eol" +
            "      /* -------------------------------------$Eol" +
            "          RESPONSIVE AND MOBILE FRIENDLY STYLES$Eol" +
            "      ------------------------------------- */$Eol" +
            "      @media only screen and (max-width: 620px) {$Eol" +
            "        table[class=body] h1 {$Eol" +
            "          font-size: 28px !important;$Eol" +
            "          margin-bottom: 10px !important; }$Eol" +
            "        table[class=body] p,$Eol" +
            "        table[class=body] ul,$Eol" +
            "        table[class=body] ol,$Eol" +
            "        table[class=body] td,$Eol" +
            "        table[class=body] span,$Eol" +
            "        table[class=body] a {$Eol" +
            "          font-size: 16px !important; }$Eol" +
            "        table[class=body] .wrapper,$Eol" +
            "        table[class=body] .article {$Eol" +
            "          padding: 10px !important; }$Eol" +
            "        table[class=body] .content {$Eol" +
            "          padding: 0 !important; }$Eol" +
            "        table[class=body] .container {$Eol" +
            "          padding: 0 !important;$Eol" +
            "          width: 100% !important; }$Eol" +
            "        table[class=body] .main {$Eol" +
            "          border-left-width: 0 !important;$Eol" +
            "          border-radius: 0 !important;$Eol" +
            "          border-right-width: 0 !important; }$Eol" +
            "        table[class=body] .btn table {$Eol" +
            "          width: 100% !important; }$Eol" +
            "        table[class=body] .btn a {$Eol" +
            "          width: 100% !important; }$Eol" +
            "        table[class=body] .img-responsive {$Eol" +
            "          height: auto !important;$Eol" +
            "          max-width: 100% !important;$Eol" +
            "          width: auto !important; }}$Eol" +
            "$Eol" +
            "      /* -------------------------------------$Eol" +
            "          PRESERVE THESE STYLES IN THE HEAD$Eol" +
            "      ------------------------------------- */$Eol" +
            "      @media all {$Eol" +
            "        .ExternalClass {$Eol" +
            "          width: 100%; }$Eol" +
            "        .ExternalClass,$Eol" +
            "        .ExternalClass p,$Eol" +
            "        .ExternalClass span,$Eol" +
            "        .ExternalClass font,$Eol" +
            "        .ExternalClass td,$Eol" +
            "        .ExternalClass div {$Eol" +
            "          line-height: 100%; }$Eol" +
            "        .apple-link a {$Eol" +
            "          color: inherit !important;$Eol" +
            "          font-family: inherit !important;$Eol" +
            "          font-size: inherit !important;$Eol" +
            "          font-weight: inherit !important;$Eol" +
            "          line-height: inherit !important;$Eol" +
            "          text-decoration: none !important; }$Eol" +
            "        .btn-primary table td:hover {$Eol" +
            "          background-color: #34495e !important; }$Eol" +
            "        .btn-primary a:hover {$Eol" +
            "          background-color: #34495e !important;$Eol" +
            "          border-color: #34495e !important; } }$Eol" +
            "$Eol" +
            "    </style>$Eol" +
            "  </head>$Eol" +
            "  <body class=`"`">$Eol" +
            "    <table border=`"0`" cellpadding=`"0`" cellspacing=`"0`" class=`"body`">$Eol" +
            "      <tr>$Eol" +
            "        <td>&nbsp;</td>$Eol" +
            "        <td class=`"container`">$Eol" +
            "          <div class=`"content`">$Eol" +
            "$Eol" +
            "            <!-- START CENTERED WHITE CONTAINER -->$Eol" +
            "            <table class=`"main`">$Eol" +
            "$Eol" +
            "              <!-- START MAIN CONTENT AREA -->$Eol" +
            "              <tr>$Eol" +
            "                <td class=`"wrapper`">$Eol" +
            "                  <table border=`"0`" cellpadding=`"0`" cellspacing=`"0`">$Eol" +
            "                    <tr>$Eol" +
            "                      <td>$Eol")

        $HtmlButton = ("                        <table border=`"0`" cellpadding=`"0`" cellspacing=`"0`" class=`"btn btn-primary`">$Eol" +
            "                          <tbody>$Eol" +
            "                            <tr>$Eol" +
            "                              <td align=`"left`">$Eol" +
            "                                <table border=`"0`" cellpadding=`"0`" cellspacing=`"0`">$Eol" +
            "                                  <tbody>$Eol" +
            "                                    <tr>$Eol" +
            "                                      <td> <a href=`"$ButtonLink`" target=`"_blank`">$ButtonText</a> </td>$Eol" +
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
            "            <div class=`"footer`">$Eol" +
            "              <table border=`"0`" cellpadding=`"0`" cellspacing=`"0`">$Eol" +
            "                <tr>$Eol" +
            "                  <td class=`"content-block`">$Eol" +
            "                    <span class=`"apple-link`">")

        $HtmlBottom = ("</span>$Eol" +
            "                  </td>$Eol" +
            "                </tr>$Eol" +
            "                <tr>$Eol" +
            "                  <td class=`"content-block powered-by`">$Eol" +
            "                    Powered by Invoke-CommandWithEmailWrapper$Eol" +
            "                  </td>$Eol" +
            "                </tr>$Eol" +
            "              </table>$Eol" +
            "            </div>$Eol" +
            "            <!-- END FOOTER -->$Eol" +
            "$Eol" +
            "          <!-- END CENTERED WHITE CONTAINER -->$Eol" +
            "          </div>$Eol" +
            "        </td>$Eol" +
            "        <td>&nbsp;</td>$Eol" +
            "      </tr>$Eol" +
            "    </table>$Eol" +
            "  </body>$Eol" +
            "</html>")

        if (!$ButtonText) {
            $HtmlButton = ""
        }

        $CompleteBody = $HtmlTop + $HeaderData + $BodyData + $HtmlButton +
            $HtmlDataToFooter + $FooterData + $HtmlBottom

        $SmmParams = @{
            From = $From
            To = $To
            Subject = $Subject
            Body = $CompleteBody
            BodyAsHtml = $true
            UseSsl = $true
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

        Send-MailMessage @SmmParams
    }
}

# Export only the functions using PowerShell standard verb-noun naming.
# Be sure to list each exported functions in the FunctionsToExport field of the module manifest file.
# This improves performance of command discovery in PowerShell.
Export-ModuleMember -Function Send-HtmlMailMessage