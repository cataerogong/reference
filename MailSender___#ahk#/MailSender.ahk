Mail(from, to, cc, bcc, subject, content, attach*) ;发件人，收件人，标题，正文，附件文件路径数组 eg:["d:\a.xls","d:\b.doc"]
{
	NameSpace := "http://schemas.microsoft.com/cdo/configuration/"
	Email := ComObjCreate("CDO.Message")
	Email.From := from
	Email.To := to
	Email.Cc := cc ;抄送
	Email.Bcc := bcc ;暗送
	Email.Subject := subject
	;Email.Htmlbody := content ;html格式的正文
	Email.Textbody := content ;纯文本格式的正文
	for k,v in attach
	{
		IfExist, % v
			Email.AddAttachment(v)
	}
	Email.Configuration.Fields.Item(NameSpace "sendusing") := 2
	Email.Configuration.Fields.Item(NameSpace "smtpserver") := "192.168.16.136" ;SMTP服务器地址
	Email.Configuration.Fields.Item(NameSpace "smtpserverport") := 25 ;smtp发送端口 qq：465
	Email.Configuration.Fields.Item(NameSpace "smtpauthenticate") := 1 ;需要验证
	;Email.Configuration.Fields.Item(NameSpace "smtpusessl") := true ;使用ssl qq等需要
	Email.Configuration.Fields.Item(NameSpace "sendusername") := "noreply@zhfund.com" ;邮箱账号
	Email.Configuration.Fields.Item(NameSpace "sendpassword") := "pass" ;邮箱密码
	Email.Configuration.Fields.update()

	;Email.Fields.Item("urn:schemas:mailheader:disposition-notification-to") := from ;设置“已读”回执
	;Email.Fields.Item("urn:schemas:mailheader:return-receipt-to") := from ;设置“已送达”回执
	;Email.Fields.Update()

	Email.Send
}

from := ""
to := ""
cc := ""
bcc := ""
sub := "标题 " . A_YYYY . "-" . A_MM . "-" . A_DD
con := "正文`n"
. "`t`t正文，啥都没有，布拉布拉`n"
. "`n`n"
. "`t`t签名`n"
. "电话`n"
. "地址`n"

Mail(from, to, cc, bcc, sub, con)
