# Send-HtmlMailMessage

## SYNOPSIS
Sends a nicely formatted HTML email.

## SYNTAX

### Default (Default)
```
Send-HtmlMailMessage -From <String> -Subject <String> -To <String[]> -Body <String> [-BodyAlignment <String>]
 [-BodyPreformatted <String>] [-Attachments <String[]>] [-Bcc <String[]>] [-Cc <String[]>]
 [-Credential <PSCredential>] [-DeliveryNotificationOption <String>] [-Encoding <String>] [-Port <Int32>]
 -SmtpServer <String> [-Priority <String>] [-Heading <String>] [-HeadingAlignment <String>] [-Footer <String>]
 [-ColorScheme <Hashtable>] [<CommonParameters>]
```

### Button
```
Send-HtmlMailMessage -From <String> -Subject <String> -To <String[]> -Body <String> [-BodyAlignment <String>]
 [-BodyPreformatted <String>] [-Attachments <String[]>] [-Bcc <String[]>] [-Cc <String[]>]
 [-Credential <PSCredential>] [-DeliveryNotificationOption <String>] [-Encoding <String>] [-Port <Int32>]
 -SmtpServer <String> [-Priority <String>] [-Heading <String>] [-HeadingAlignment <String>] [-Footer <String>]
 -ButtonText <String> -ButtonLink <String> [-ButtonAlignment <String>] [-ColorScheme <Hashtable>]
 [<CommonParameters>]
```

## DESCRIPTION
Sends a nicely formatted HTML email.
This cmdlet is designed to work just like Send-MailMessage, with -Heading, 
-Body, -BodyFormatted, and -Footer replacing the default -Body of Send-MailMessage.

## EXAMPLES

### EXAMPLE 1
```
Send-HtmlMailMessage -From "server01@contoso.com" -To "admin@contoso.com"
```

## PARAMETERS

### -From
Specifies the address from which the mail is sent.
Can either be an email address, or, optionally, a name 
and email address combo in the format 'Someone \<someone@example.com\>'

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Subject
Specifies the subject of the email message.
This parameter is required.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -To
Specifies the addresses to which the mail is sent.
Can either be an email address, or, optionally, a name 
and email address combo in the format 'Someone \<someone@example.com\>'

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Body
Specifies a string to use as the body of the message.
If you have a multi-paragraph body, wrapped each paragraph as follows:
- \<p\>Paragraph 1\</p\>\<p\>Paragraph 2\</p\>
If you want to include preformatted data, it is recommended to use the -BodyPreformatted attribute 
for that.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BodyAlignment
Specifies how the body should be aligned.
The acceptable values for this parameter are:
- Left
- Center
- Right
Left is the default.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Left
Accept pipeline input: False
Accept wildcard characters: False
```

### -BodyPreformatted
Specifies a string of preformmated text (code, cmdlet output, etc) to include below the body of the message.
This will be displayed either in a horizontally-scrolling box or, if Outlook (which can't support 
scrolling) wrapped with line numbers.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Attachments
Specifies the path to files to attach to the message.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Bcc
Specifies the email addresses that receive a copy of the mail but are not listed as recipients of the 
message.
Can either be an email address, or, optionally, a name and email address combo in the format 
'Someone \<someone@example.com\>'

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Cc
Specifies the email addresses to which a carbon copy (CC) of the email message is sent.
Can either be 
an email address, or, optionally, a name and email address combo in the format 
'Someone \<someone@example.com\>'.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
Specifies a PSCredential object, containing credentials used to send the message.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeliveryNotificationOption
Specifies the delivery notification options for the email message.
The acceptable values for this parameter are:
- None.
No notification.
- OnSuccess.
Notify if the delivery is successful.
- OnFailure.
Notify if the delivery is unsuccessful.
- Delay.
Notify if the delivery is delayed.
- Never.
Never notify.
None is the default.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Encoding
Specifies the encoding used for the body and subject.
The acceptable values for this parameter are:
- ASCII
- UTF8
- UTF7
- UTF32
- Unicode
- BigEndianUnicode
- Default
- OEM
UTF8 is the default.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: UTF8
Accept pipeline input: False
Accept wildcard characters: False
```

### -Port
Specifies the port on which to connect to the SMTP server.
Defaults to 587.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -SmtpServer
Specifies the FQDN or IP address of the SMTP server that will send the message.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Priority
Specifies the priority of the email message.
The acceptable values for this parameter are:
- Normal
- High
- Low
Normal is the default.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Heading
Specifies a string (with optional HTML formatting) to include in the heading of the message.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HeadingAlignment
Specifies how the heading should be aligned.
The acceptable values for this parameter are:
- Left
- Center
- Right
Center is the default.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Center
Accept pipeline input: False
Accept wildcard characters: False
```

### -Footer
Specifies a string (with optional HTML formatting) to include in the footer of the message.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ButtonText
Specifies a string to use as label for an optional button.

```yaml
Type: String
Parameter Sets: Button
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ButtonLink
Specifies a link to use as a target for an optional button.

```yaml
Type: String
Parameter Sets: Button
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ButtonAlignment
Specifies how the button should be aligned.
The acceptable values for this parameter are:
- Left
- Center
- Right
Center is the default.

```yaml
Type: String
Parameter Sets: Button
Aliases:

Required: False
Position: Named
Default value: Center
Accept pipeline input: False
Accept wildcard characters: False
```

### -ColorScheme
Specifies a hashtable containing a color scheme if you wish to use non-default colors.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: @{
            BodyTextColor = "#000000"
            BackgroundColor = "#f6f6f6"
            ContainerColor = "#ffffff"
            HeadingTextColor = "#000000"
            FooterTextColor = "#999999"
            LinkColor = "#999999"
            ButtonColor = "#3498db"
            ButtonTextColor = "#ffffff"
        }
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### No inputs
## OUTPUTS

### No outputs
## NOTES

## RELATED LINKS

[https://github.com/natescherer/PoshEmail](https://github.com/natescherer/PoshEmail)

