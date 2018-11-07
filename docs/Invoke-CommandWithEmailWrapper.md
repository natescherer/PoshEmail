---
external help file: PoshEmail-help.xml
Module Name: PoshEmail
online version: https://github.com/natescherer/PoshEmail
schema: 2.0.0
---

# Invoke-CommandWithEmailWrapper

## SYNOPSIS
Executes a Script or ScriptBlock via Invoke-Command, and provide email alerts either before or before and after execution.

## SYNTAX

### Script (Default)
```
Invoke-CommandWithEmailWrapper [-ComputerName <String>] [-Script <String>] -JobName <String>
 -SmtpServer <String> [-EmailMode <String>] [-SmtpPort <Int32>] [-EmailFrom <String>] -EmailTo <String[]>
 [-EmailUseSsl] [<CommonParameters>]
```

### ScriptBlock
```
Invoke-CommandWithEmailWrapper [-ComputerName <String>] [-ScriptBlock <ScriptBlock>] -JobName <String>
 -SmtpServer <String> [-EmailMode <String>] [-SmtpPort <Int32>] [-EmailFrom <String>] -EmailTo <String[]>
 [-EmailUseSsl] [<CommonParameters>]
```

## DESCRIPTION
Executes a Script or ScriptBlock either locally on on a remote computer.
Provides output of Script/ScriptBlock
via email after execution completes.
Optionally sends an additional email alert at the start of execution.

## EXAMPLES

### EXAMPLE 1
```
Invoke-CommandWithEmailWrapper -ScriptBlock { robocopy c:\source d:\dest } -JobName "RoboCopy" -SmtpServer "smtp01" -EmailTo "admin@contoso.com"
```

Executes the robocopy command in the ScriptBlock on the local computer, then sends an email with the command's
output once it completes.

### EXAMPLE 2
```
Invoke-CommandWithEmailWrapper -Script "c:\scripts\script1.ps1" -JobName "Script1" -SmtpServer "smtp01" -EmailTo "admin@contoso.com" -ComputerName "serv01" -EmailMode "BeforeAndAfter"
```

Executes the the script c:\scripts\script1.ps1 (on the local computer) on the remote computer "serv01", sending
emails when the script begins and finishes running.

## PARAMETERS

### -ComputerName
Computer to execute the command on.
Defaults to localhost.

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

### -Script
Script to execute.

```yaml
Type: String
Parameter Sets: Script
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ScriptBlock
ScriptBlock to execute.

```yaml
Type: ScriptBlock
Parameter Sets: ScriptBlock
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -JobName
A short job name to include in emails to identify this execution.

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

### -SmtpServer
Specifies SMTP server used to send email

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

### -EmailMode
Specifies to send mail either After or BeforeAndAfter command execution.
Defaults to After.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: After
Accept pipeline input: False
Accept wildcard characters: False
```

### -SmtpPort
TCP Port to connect to SMTP server on.
Defaults to 25.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 25
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmailFrom
Specifies a source address for messages.
Defaults to computername@domain

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: "$($env:computername)@$($env:userdnsdomain)"
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmailTo
Specifies a comma-separated (i.e.
"a@b.com","b@b.com") list of email addresses to email upon job completion

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

### -EmailUseSsl
Indicates that the cmdlet uses the Secure Sockets Layer (SSL) protocol to establish a connection to the remote computer to send mail.
Defaults to $true

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### No inputs
## OUTPUTS

### Outputs whatever the Script/ScriptBlock you are invoking outputs.
## NOTES

## RELATED LINKS

[https://github.com/natescherer/PoshEmail](https://github.com/natescherer/PoshEmail)

