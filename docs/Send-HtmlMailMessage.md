---
external help file: PoshEmail-help.xml
Module Name: PoshEmail
online version: https://github.com/natescherer/PoshEmail
schema: 2.0.0
---

# Send-HtmlMailMessage

## SYNOPSIS
Sends a nicely formatted HTML email.

## SYNTAX

### Default (Default)
```
Send-HtmlMailMessage -From <String> -Subject <String> -To <String[]> -Body <String> [-BodyAlignment <String>]
 [-BodyPreformatted <String>] [-Attachments <String[]>] [-Bcc <String[]>] [-Cc <String[]>]
 [-Credential <PSCredential>] [-DeliveryNotificationOption <String>] [-Encoding <String>] [-Port <Int32>]
 [-SmtpServer <String>] [-UseSsl] [-Priority <String>] [-Heading <String>] [-HeadingAlignment <String>]
 [-Footer <String>] [-LastLine <String>] [<CommonParameters>]
```

### Button
```
Send-HtmlMailMessage -From <String> -Subject <String> -To <String[]> -Body <String> [-BodyAlignment <String>]
 [-BodyPreformatted <String>] [-Attachments <String[]>] [-Bcc <String[]>] [-Cc <String[]>]
 [-Credential <PSCredential>] [-DeliveryNotificationOption <String>] [-Encoding <String>] [-Port <Int32>]
 [-SmtpServer <String>] [-UseSsl] [-Priority <String>] [-Heading <String>] [-HeadingAlignment <String>]
 [-Footer <String>] [-LastLine <String>] -ButtonText <String> -ButtonLink <String> [-ButtonAlignment <String>]
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
Enter a name (optional) and email address, such as Name \<someone@example.com\>.
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
Enter names (optional) and the email address, such as Name \<someone@example.com\>.
This parameter is required.

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
Specifies a string (with optional HTML formatting) to include in the body of the message.
This parameter is required.
Multiple paragraphs should have each paragraph wrapped as follows:
- \<p\>Paragraph 1\</p\>\<p\>Paragraph 2\</p\>
If you need to include preformatted data, you should use the -BodyPreformatted attribute as well

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
This will be displayed either in a horizontally-scrolling box or, if Outlook (which can't support scrolling) wrapped with line numbers.

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
Specifies the path and file names of files to be attached to the email message.
You can use this parameter or pipe the paths and file names to Send-HtmlMailMessage.

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
Specifies the email addresses that receive a copy of the mail but are not listed as recipients of the message.
Enter names (optional) and the email address, such as Name \<someone@example.com\>.

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
Enter names (optional) and the email address, such as Name \<someone@example.com\>.

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
Specifies a user account that has permission to perform this action.
The default is the current user.
Type a user name, such as User01 or Domain01\User01.
Or, enter a PSCredential object, such as one from the Get-Credential cmdlet.

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
You can specify multiple values.
None is the default value.
The alias for this parameter is dno.
The delivery notifications are sent in an email message to the address specified in the value of the From parameter.
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
ASCII is the default.

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

### -Port
Specifies an alternate port on the SMTP server.
The default value is 25, which is the default SMTP port.

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
Specifies the name of the SMTP server that sends the email message.
The default value is the value of the $PSEmailServer preference variable.
If the preference variable is not set and this parameter is omitted, the command fails.

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

### -UseSsl
Indicates that the cmdlet uses the Secure Sockets Layer (SSL) protocol to establish a connection to the remote computer to send mail.
By default, SSL is not used.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
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

### -LastLine
Specifies a string (with optional HTML formatting) to include in the last line of the message.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Powered by <a href="https://github.com/natescherer/PoshEmail">PoshEmail</a>.
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### No inputs
## OUTPUTS

### No outputs
## NOTES
Detail on what the function does, if this is needed

## RELATED LINKS

[https://github.com/natescherer/PoshEmail](https://github.com/natescherer/PoshEmail)

