Mail(from, to, cc, bcc, subject, content, attach*) ;�����ˣ��ռ��ˣ����⣬���ģ������ļ�·������ eg:["d:\a.xls","d:\b.doc"]
{
	NameSpace := "http://schemas.microsoft.com/cdo/configuration/"
	Email := ComObjCreate("CDO.Message")
	Email.From := from
	Email.To := to
	Email.Cc := cc ;����
	Email.Bcc := bcc ;����
	Email.Subject := subject
	;Email.Htmlbody := content ;html��ʽ������
	Email.Textbody := content ;���ı���ʽ������
	for k,v in attach
	{
		IfExist, % v
			Email.AddAttachment(v)
	}
	Email.Configuration.Fields.Item(NameSpace "sendusing") := 2
	Email.Configuration.Fields.Item(NameSpace "smtpserver") := "192.168.16.136" ;SMTP��������ַ
	Email.Configuration.Fields.Item(NameSpace "smtpserverport") := 25 ;smtp���Ͷ˿� qq��465
	Email.Configuration.Fields.Item(NameSpace "smtpauthenticate") := 1 ;��Ҫ��֤
	;Email.Configuration.Fields.Item(NameSpace "smtpusessl") := true ;ʹ��ssl qq����Ҫ
	Email.Configuration.Fields.Item(NameSpace "sendusername") := "noreply@zhfund.com" ;�����˺�
	Email.Configuration.Fields.Item(NameSpace "sendpassword") := "pass" ;��������
	Email.Configuration.Fields.update()

	;Email.Fields.Item("urn:schemas:mailheader:disposition-notification-to") := from ;���á��Ѷ�����ִ
	;Email.Fields.Item("urn:schemas:mailheader:return-receipt-to") := from ;���á����ʹ��ִ
	;Email.Fields.Update()

	Email.Send
}

from := ""
to := ""
cc := ""
bcc := ""
sub := "���� " . A_YYYY . "-" . A_MM . "-" . A_DD
con := "����`n"
. "`t`t���ģ�ɶ��û�У���������`n"
. "`n`n"
. "`t`tǩ��`n"
. "�绰`n"
. "��ַ`n"

Mail(from, to, cc, bcc, sub, con)
