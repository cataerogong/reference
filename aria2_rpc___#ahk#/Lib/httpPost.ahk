httpPost(URL, ByRef In_POST__Out_Data) {
	static nothing := ComObjError(0)
	static oHTTP   := ComObjCreate("WinHttp.WinHttpRequest.5.1")

	oHTTP.Open("POST", URL, True)
	oHTTP.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")
	oHTTP.Send(In_POST__Out_Data)
	oHTTP.WaitForResponse(-1)

	In_POST__Out_Data := oHTTP.ResponseText
}