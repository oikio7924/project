<!-- #include virtual="JSON_2.0.4.asp" -->
<!-- #include virtual="JSON_UTIL_0.1.1.asp" -->
<!--#include virtual="/aspJSON1.17.asp" -->
<%
Dim json

Set json = jsObject()

json("hometaxbill_id") = "cmj0633"	        '회사아이디   
json("spass") =	"Mem12345"					'비밀번호
json("apikey") = "SSADFVSDFSDE"				'APIKEY
json("homemunseo_id") = "330333333271"		'회사고유번호

'Response.Write toJSON(json) 
'Response.End


dim url
dim DataToSend
dim xmlhttp
dim xmlhttp_result


'REST API 전송 URL  TEST 서버
url = "http://115.68.1.5:8084/homtax/getpkey"

'REST API 전송
set xmlhttp = server.Createobject("MSXML2.ServerXMLHTTP.3.0")
xmlhttp.Open "POST", url ,false
xmlhttp.setRequestHeader "Content-Type", "application/json"
xmlhttp.setRequestHeader "Accept","application/json"
xmlhttp.send toJSON(json)

'결과값을 가져오기
xmlhttp_result = xmlhttp.responseText

'response.write xmlhttp_result


If Trim(xmlhttp_result)<>"" Then
 Set oJSON = New aspJSON

 xmlhttp_result = "{""list"" : " & xmlhttp_result & "}"

 oJSON.loadJSON(xmlhttp_result)

 Response.write "<br />code : "  & oJSON.data("list").item("code")
 Response.write "<br />msg : "  & oJSON.data("list").item("msg")
 Response.write "<br />msg2 : "  & oJSON.data("list").item("msg2")
 Response.write "<br />hometaxbill_id : "  & oJSON.data("list").item("hometaxbill_id")
 Response.write "<br />homemunseo_id : "  & oJSON.data("list").item("homemunseo_id")
 Response.write "<br />issueid : "  & oJSON.data("list").item("issueid")
 Response.write "<br />declarestatus : "  & oJSON.data("list").item("declarestatus")

End If

Set oJSON = Nothing
set xmlhttp = nothing



%>