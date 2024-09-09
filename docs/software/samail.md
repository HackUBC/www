# Student Email (SAMail)

The UBC SAMail provides students with `@student.ubc.ca` and `@alum.ubc.ca` email addresses.
For more info on this service, see [UBC Student Email Service](https://it.ubc.ca/services/email-voice-internet/ubc-student-email-service).

## IMAP Access

SAMail does not provide IMAP access. It only provides the Exchange Server OWA. For those who want to use IMAP or their own MUA, use [Davmail](https://davmail.sourceforge.net/).

Configure Davmail as:

```properties
davmail.mode=EWS
davmail.url=https://webmail.student.ubc.ca/EWS/Exchange.asmx
```

Then logon using your credentials.

## Mail routing

## SMTP Server

The inbound SMTP server (MX) is hosted under UBC's IP block, possibly on-prem. Server software unknown.

```
$ host student.ubc.ca
student.ubc.ca has address 52.60.219.22
student.ubc.ca has address 35.182.174.169
student.ubc.ca has address 35.182.59.77
student.ubc.ca mail is handled by 10 esva.mail-relay.ubc.ca.
$ host esva.mail-relay.ubc.ca
esva.mail-relay.ubc.ca has address 206.87.227.4
$ nc esva.mail-relay.ubc.ca 25
220 nesvaprod01.mail-relay.ubc.ca ESMTP
```

Outbound SMTP server unknown.

Printers seem to be configured to use `smtp.mail-relay.ubc.ca:25`, no encryption, from `noreply@ubc.ca`.
