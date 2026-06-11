function onlyNumber()
{
  if ((event.keyCode < 48) || (57 < event.keyCode)) event.returnValue=false;
}

function jsParseInt( varStr ) {
	//var vstr = jsDeleteComma( varStr );
	var vstr = UnComma( varStr );
	
	if ( vstr == null || vstr == "" ) return 0 ;
	else return parseInt(vstr, 10) ;
}

function jsDeleteComma( varNumber ){
	var varLength = varNumber.length ;
	
	varReturnNumber = "" ;
	
	for ( var inx = 0 ; inx < varLength ; inx++ ) {
		if ( varNumber.substring( inx, inx+1 ) != "," ) {
		 varReturnNumber = varReturnNumber + varNumber.substring( inx, inx+1 ) ;
		}
	}
	
	return varReturnNumber ;
}


function logout(){
    var form = document.ReserveForm;
    form.action="./logout_Act.jsp";
    form.submit();
}	

// 문자열 trim
String.prototype.trim = function(){
	return this.replace(/(^\s*)|(\s*$)/gi, "");
}

// 문자열 ReplaceAll
String.prototype.ReplaceAll = function(OrgStr, RepStr){
	return this.split(OrgStr).join(RepStr);
}

function SplitStr(TargetStr, Regex){
	var SplitArray = null;
	
	if(Regex.length == 0){
		SplitArray = new Array(TargetStr);
	}
	else{
		try{
			var SplitSize = 0;
			var TempStr = TargetStr;
			var Temp = "";
			var point = 0;
			
			while(TempStr.length > 0){
				point = TempStr.indexOf(Regex);
				if(point >= 0){
					Temp = TempStr.substring(0, point);
					TempStr = TempStr.substring(point + Regex.length);
				}
				else{
					Temp = TempStr;
					TempStr = "";
				}
				
				if(Temp.length > 0){
					SplitSize++;
				}
			}
			
			SplitArray = new Array(SplitSize);
			SplitSize = 0;
			
			TempStr = TargetStr;
			while(TempStr.length > 0){
				point = TempStr.indexOf(Regex);
				if(point >= 0){
					Temp = TempStr.substring(0, point);
					TempStr = TempStr.substring(point + Regex.length);
				}
				else{
					Temp = TempStr;
					TempStr = "";
				}
				
				if(Temp.length() > 0){
					SplitArray[SplitSize] = Temp;
					SplitSize++;
				}
			}
		}catch(e){
			SplitArray = new Array(TargetStr);
		}
	}
	
	return SplitArray;
}

function SplitAllStr(TargetStr, Regex){
	var SplitArray = null;
	
	if(Regex.length == 0){
		SplitArray = new Array(TargetStr);
	}
	else{
		try{
			var SplitSize = 0;
			var TempStr = TargetStr;
			var Temp = "";
			var point = 0;
			
			while(TempStr.length > 0){
				point = TempStr.indexOf(Regex);
				if(point >= 0){
					Temp = TempStr.substring(0, point);
					TempStr = TempStr.substring(point + Regex.length);
				}
				else{
					Temp = TempStr;
					TempStr = "";
				}
				
				SplitSize++;
			}
			
			SplitArray = new Array(SplitSize);
			SplitSize = 0;
			
			TempStr = TargetStr;
			while(TempStr.length > 0){
				point = TempStr.indexOf(Regex);
				if(point >= 0){
					Temp = TempStr.substring(0, point);
					TempStr = TempStr.substring(point + Regex.length);
				}
				else{
					Temp = TempStr;
					TempStr = "";
				}
				
				SplitArray[SplitSize] = Temp;
				SplitSize++;
			}
		}catch(e){
			SplitArray = new Array(TargetStr);
		}
	}
	
	return SplitArray;
}

function GetObject(ObjectId){
	return document.getElementById(ObjectId);
}

function ObjValueTrim(TargetObj){
	if(TargetObj != null){
		TargetObj.value = TargetObj.value.trim();
	}
}

function ObjValueLength(TargetObj){
	return TargetObj.value.length;
}

function GetRadioValue(TargetObj){
	var RadioValue = "";
	
	try{
		if(TargetObj.checked != null){
			if(TargetObj.checked){
				RadioValue = TargetObj.value;
			}
		}
		else{
			for(var idx = 0; idx < TargetObj.length; idx++){
				if(TargetObj[idx].checked){
					RadioValue = TargetObj[idx].value;
					break;
				}
			}
		}
	}catch(e){
		RadioValue = "";
	}
	
	return RadioValue;
}

function GetXmlNode(NodeObj, TagName, NodeIdx){
	var XmlNode;
	
	if(NodeIdx != null){
		XmlNode = NodeObj.getElementsByTagName(TagName)[NodeIdx];
	}
	else{
		XmlNode = NodeObj.getElementsByTagName(TagName);
	}
	return XmlNode;
}

function GetXmlNodeSize(NodeObj, TagName){
	return NodeObj.getElementsByTagName(TagName).length;
}

function GetXmlNodeValue(NodeObj, TagName){
	var NodeValue = "";
	
	if(NodeObj.getElementsByTagName(TagName)[0].firstChild != null){
		NodeValue = NodeObj.getElementsByTagName(TagName)[0].firstChild.nodeValue;
	}
	
	return NodeValue;
}

// Form Create
function CreateForm(FormName, FormMethod, FormAction, FormTarget){
	var FormObj = document.createElement("form");
	
	FormObj.setAttribute("name", FormName);
	FormObj.setAttribute("method", FormMethod);
	FormObj.setAttribute("action", FormAction);
	FormObj.setAttribute("target", FormTarget);
	
	return FormObj;
}

// Hidden Add
function AddHidden(FormObj, InputName, InputValue){
	var InputObj = document.createElement("input");
	
	InputObj.setAttribute("type", "hidden");
	InputObj.setAttribute("name", InputName);
	InputObj.setAttribute("value", InputValue);
	
	FormObj.appendChild(InputObj);
	
	return FormObj;
}

// 클릭 시 점선없애기
function Bluring(){
	if(event.srcElement.tagName == "A" || event.srcElement.tagName == "IMG"){
		//document.body.focus();
		event.srcElement.blur();
	}
}
//document.onfocusin=Bluring;

// 마우스 오른쪽 클릭
window.onmousedown=right;
function right(e){
	if(navigator.appName == 'Netscape' && (e.which == 3 || e.which == 2)){
		return false;
	}
	else if(navigator.appName == 'Microsoft Internet Explorer' && (event.button == 2 || event.button == 3)){
		//alert("\n 마우스 오른쪽 키는 사용하실수 없습니다.\n\n\n");
		return false;
	}
	
	return true;
}

function InitializeTable(TableObj, LimitIdx){
	if(TableObj != null){
		var RowsCnt = TableObj.rows.length;
		var StartIdx = 0;
	
		if(LimitIdx != null && LimitIdx > 0){
			StartIdx = LimitIdx;
		}
	
		for(var idx = StartIdx; idx < RowsCnt; idx++){
			TableObj.deleteRow(StartIdx);
		}
	}
}

function InitializeSelect(SelectObj, LimitIdx){
	if(SelectObj != null){
		var RowsCnt = SelectObj.options.length;
		var StartIdx = 0;
	
		if(LimitIdx != null && LimitIdx > 0){
			StartIdx = LimitIdx;
		}
	
		for(var idx = StartIdx; idx < RowsCnt; idx++){
			SelectObj.options.remove(StartIdx);
		}
	}
}

function CheckRadio(TargetObj){
	var CheckFlag = true;
	
	if(TargetObj == null){
		return CheckFlag;
	}
	
	if(TargetObj.checked != null){
		if(TargetObj.checked){
			CheckFlag = false;
		}
	}
	else{
		for(var idx = 0; idx < TargetObj.length; idx++){
			if(TargetObj[idx].checked){
				CheckFlag = false;
				break;
			}
		}
	}
	
	return CheckFlag;
}

// 대문자체크
function CheckUpperChar(TargetStr){
	var ChkStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	
	for(var idx = 0; idx < TargetStr.length; idx++){
		if(ChkStr.indexOf(TargetStr.substring(idx, idx + 1)) < 0){
			return true;
			break;
		}
	}
	
	return false;
}

// 소문자체크
function CheckLowerChar(TargetStr){
	var ChkStr = "abcdefghijklmnopqrstuvwxyz";
	
	for(var idx = 0; idx < TargetStr.length; idx++){
		if(ChkStr.indexOf(TargetStr.substring(idx, idx + 1)) < 0){
			return true;
			break;
		}
	}
	
	return false;
}

// 문자열체크
function CheckChar(TargetStr, ChkStr){
	for(var idx = 0; idx < TargetStr.length; idx++){
		if(ChkStr.indexOf(TargetStr.substring(idx, idx + 1)) < 0){
			return true;
			break;
		}
	}
	
	return false;
}

// 숫자체크
function CheckInt(TargetStr){
	var ChkStr = "1234567890";
	
	for(var idx = 0; idx < TargetStr.length; idx++){
		if(ChkStr.indexOf(TargetStr.substring(idx, idx + 1)) < 0){
			return true;
			break;
		}
	}
	
	return false;
}

// 실수 체크
function CheckFloat(TargetStr){
	var ChkStr = "1234567890.";
	var ChkStr = "";
	
	for(var idx = 0; idx < TargetStr.length; idx++){
		ChkStr = TargetStr.substring(idx, idx + 1);
		
		if(ChkStr.indexOf(ChkStr) < 0){
			return true;
			break;
		}
		else if((idx == 0 && ChkStr == ".") || (idx + 1 == TargetStr.length && ChkStr == ".")){
			return true;
			break;
		}
	}
	
	return false;
}

// 전화번호 양식 입력(일괄입력)
function SetTel(TargetObj){
	var ChkStr = "1234567890";
	var StrLength = TargetObj.value.length;
	var StrTemp = "";
	var StrChar = "";
	
	for(var idx = 0; idx < StrLength; idx++){
		StrChar = TargetObj.value.substring(idx, idx + 1);
		
		if(ChkStr.indexOf(StrChar) >= 0){
			StrTemp += StrChar;
		}
	}
	
	if(StrTemp.length > 11){
		StrTemp = StrTemp.substring(0, 11);
	}
	
	if(StrTemp.length > 2){
		var FNum = "";
		var SNum = "";
		var TNum = "";
		
		if(StrTemp.substring(0, 2) == "01"){
			FNum = StrTemp.substring(0, 3);
			
			if(StrTemp.substring(3).length < 4){
				SNum = StrTemp.substring(3);
			}
			else if(StrTemp.substring(3).length < 8){
				SNum = StrTemp.substring(3, 6);
				TNum = StrTemp.substring(6);
			}
			else{
				SNum = StrTemp.substring(3, 7);
				TNum = StrTemp.substring(7);
			}
		}
		else if(StrTemp.substring(0, 2) == "02"){
			if(StrTemp.length > 10){
				StrTemp = StrTemp.substring(0, 10);
			}
	
			FNum = StrTemp.substring(0, 2);
			
			if(StrTemp.substring(2).length < 4){
				SNum = StrTemp.substring(2);
			}
			else if(StrTemp.substring(2).length < 7){
				SNum = StrTemp.substring(2, 4);
				TNum = StrTemp.substring(4);
			}
			else if(StrTemp.substring(2).length < 8){
				SNum = StrTemp.substring(2, 5);
				TNum = StrTemp.substring(5);
			}
			else{
				SNum = StrTemp.substring(2, 6);
				TNum = StrTemp.substring(6);
			}
		}
		else{
			FNum = StrTemp.substring(0, 3);
			
			if(StrTemp.substring(3).length < 4){
				SNum = StrTemp.substring(3);
			}
			else if(StrTemp.substring(3).length < 7){
				SNum = StrTemp.substring(3, 5);
				TNum = StrTemp.substring(5);
			}
			else if(StrTemp.substring(3).length < 8){
				SNum = StrTemp.substring(3, 6);
				TNum = StrTemp.substring(6);
			}
			else{
				SNum = StrTemp.substring(3, 7);
				TNum = StrTemp.substring(7);
			}
		}
		
		if(SNum.length > 0){
			FNum += "-";
		}
		
		if(TNum.length > 0){
			SNum += "-";
		}
		
		StrTemp = FNum + SNum + TNum;
	}
	
	TargetObj.value = StrTemp;
}

// 숫자 입력
function SetNumber(TargetObj){
	var ChkStr = "1234567890";
	var StrLength = TargetObj.value.length;
	var StrTemp = "";
	var StrChar = "";
	
	for(var idx = 0; idx < StrLength; idx++){
		StrChar = TargetObj.value.substring(idx, idx + 1);
		
		if(ChkStr.indexOf(StrChar) >= 0){
			StrTemp += StrChar;
		}
	}
	
	TargetObj.value = StrTemp;
}

// 자연수 입력
function SetNaturalNum(TargetObj){
	var ChkStr = "1234567890";
	var StrLength = TargetObj.value.length;
	var StrTemp = "";
	var StrChar = "";
	
	for(var idx = 0; idx < StrLength; idx++){
		StrChar = TargetObj.value.substring(idx, idx + 1);
		
		if(ChkStr.indexOf(StrChar) >= 0){
			StrTemp += StrChar;
			
			if(StrTemp == "0"){
				StrTemp = "";
			}
		}
	}
	
	TargetObj.value = StrTemp;
}

// 양수(0 포함) 입력
function SetInt(TargetObj){
	var ChkStr = "1234567890";
	var StrLength = TargetObj.value.length;
	var StrTemp = "";
	var StrChar = "";
	
	for(var idx = 0; idx < StrLength; idx++){
		StrChar = TargetObj.value.substring(idx, idx + 1);
		
		if(ChkStr.indexOf(StrChar) >= 0){
			if(StrTemp == "0"){
				StrTemp = "";
			}
			
			StrTemp += StrChar;
		}
	}
	
	TargetObj.value = StrTemp;
}

// 정수 입력
function SetSignInt(TargetObj){
	var StrLength = TargetObj.value.length;
	var StrTemp = "";
	var StrChar = "";
	var Sign = "";
	
	if(StrLength > 0){
		if(TargetObj.value.substring(0, 1) == "-"){
			Sign = "-";
			TargetObj.value = TargetObj.value.substring(1);
		}
	}
	
	SetInt(TargetObj);
	
	if(TargetObj.value != "0"){
		TargetObj.value = Sign + TargetObj.value;
	}
}

// 양의유리수 입력
function SetFloat(TargetObj){
	var ChkStr = '1234567890.';
	var StrLength = TargetObj.value.length;
	var StrTemp = "";
	var StrChar = "";
	
	for(var idx = 0; idx < StrLength; idx++){
		StrChar = TargetObj.value.substring(idx, idx + 1);
		if(ChkStr.indexOf(StrChar) >= 0){
			StrTemp += StrChar;
			
			if(StrTemp == "."){
				StrTemp = "";
			}
			else if(StrTemp.substring(0, 1) == "0" && StrTemp.length == 2 && StrChar != "."){
				StrTemp = StrChar;
			}
			else if(StrChar == "." && StrTemp.indexOf(".") != (StrTemp.length - 1)){
				StrTemp = StrTemp.substring(0, StrTemp.length - 1);
			}
		}
	}
	
	TargetObj.value = StrTemp;
}

// 유리수 입력
function SetSignFloat(TargetObj){
	var StrLength = TargetObj.value.length;
	var StrTemp = "";
	var StrChar = "";
	var Sign = "";
	
	if(StrLength > 0){
		if(obj.value.substring(0, 1) == "-"){
			Sign = "-";
			TargetObj.value = TargetObj.value.substring(1);
		}
	}
	
	SetFloat(TargetObj);
	
	if(TargetObj.value != "0"){
		TargetObj.value = Sign + TargetObj.value;
	}
}

function CheckFile(FileName, TargetFileType){
	var result = true;
	
	if(FileName.length > 0){
		var idx = FileName.lastIndexOf('.');
		
		if(idx > 0 && FileName.length > idx + 1){
			var Suffix = FileName.substring(idx + 1).toUpperCase();
			
			if(Suffix.length > 0){
				if(TargetFileType.toUpperCase().indexOf(Suffix) >= 0){
					result = false;
				}
			}
		}
	}
	else{
		result = false;
	}
	
	if(result){
		alert(TargetFileType + " 파일만 가능합니다.");
	}
	
	return result;
}

function CheckImageFile(FileName){
	var result = CheckFile(FileName, "jpg, jpeg, gif, png, bmp");
	
	return result;
}

// 주민등록번호가 올바른지 check
function CheckRegNo(RegNo){
	var N1 = RegNo.substring(0, 1);
	var N2 = RegNo.substring(1, 2);
	var N3 = RegNo.substring(2, 3);
	var N4 = RegNo.substring(3, 4);
	var N5 = RegNo.substring(4, 5);
	var N6 = RegNo.substring(5, 6);
	var N7 = RegNo.substring(6, 7);
	var N8 = RegNo.substring(7, 8);
	var N9 = RegNo.substring(8, 9);
	var N10 = RegNo.substring(9, 10);
	var N11 = RegNo.substring(10, 11);
	var N12 = RegNo.substring(11, 12);
	var N13 = RegNo.substring(12, 13);
	
	var Verify = (N1 * 2) + (N2 * 3) + (N3 * 4) + (N4 * 5) + (N5 * 6) + (N6 * 7) + (N7 * 8) + (N8 * 9) + (N9 * 2) + (N10 * 3) + (N11 * 4) + (N12 * 5);
	
	Verify = Verify % 11;
	Verify = 11 - Verify;
	Verify = Verify % 10;
	
	if(Verify != N13){
		return true;
	}
	else{
		return false;
	}
}
		
// 외국인등록번호가 올바른지 check
function CheckForeignerNo(ForeignerNo){
	var N1 = ForeignerNo.substring(0, 1);
	var N2 = ForeignerNo.substring(1, 2);
	var N3 = ForeignerNo.substring(2, 3);
	var N4 = ForeignerNo.substring(3, 4);
	var N5 = ForeignerNo.substring(4, 5);
	var N6 = ForeignerNo.substring(5, 6);
	var N7 = ForeignerNo.substring(6, 7);
	var N8 = ForeignerNo.substring(7, 8);
	var N9 = ForeignerNo.substring(8, 9);
	var N10 = ForeignerNo.substring(9, 10);
	var N11 = ForeignerNo.substring(10, 11);
	var N12 = ForeignerNo.substring(11, 12);
	var N13 = ForeignerNo.substring(12, 13);
	
	var Verify = (N8 * 10) + N9;
	
	if(Verify % 2 != 0){
		return true;
	}
	
	Verify = (N1 * 2) + (N2 * 3) + (N3 * 4) + (N4 * 5) + (N5 * 6) + (N6 * 7) + (N7 * 8) + (N8 * 9) + (N9 * 2) + (N10 * 3) + (N11 * 4) + (N12 * 5);
	
	Verify = Verify % 11;
	Verify = 11 - Verify;
	Verify = Verify % 10;
	Verify = Verify + 2;
	Verify = Verify % 10;
	
	if(Verify != N13){
		return true;
	}
	else{
		return false;
	}
}

// 천단위 콤마 입력
function SetComma(TargetObj){
	SetSignInt(TargetObj);
	
	var StrTemp = TargetObj.value;
	var StrLength = StrTemp.length;
	var Sign = "";
	
	if(StrLength > 0){
		if(StrTemp.substring(0, 1) == "-"){
			Sign = "-";
			StrTemp = StrTemp.substring(1);
		}
	}
	
	var ComStr = "";
	var SubLen = StrTemp.length;
	
	while(SubLen > 0){
		SubLen = SubLen - 3;
		
		if(SubLen < 0){
			SubLen = 0;
		}
		
		if(ComStr.length > 0){
			ComStr = StrTemp.substring(SubLen) + "," + ComStr;
		}
		else{
			ComStr = StrTemp.substring(SubLen);
		}
		
		StrTemp = StrTemp.substring(0, SubLen);
	}
	
	if(ComStr.value != "0"){
		TargetObj.value = Sign + ComStr;
	}
	else{
		TargetObj.value = ComStr;
	}
}

// 천단위 콤마 입력
function SetComma_return(TargetObj) {
	
	SetSignInt(TargetObj);
	
	var StrTemp = TargetObj.value;
	var StrLength = StrTemp.length;
	var Sign = "";
	
	if (StrLength > 0) {
		
		if (StrTemp.substring(0, 1) == "-") {
			Sign = "-";
			StrTemp = StrTemp.substring(1);
		}
	}
	
	var ComStr = "";
	var SubLen = StrTemp.length;
	
	while (SubLen > 0) {
		
		SubLen = SubLen - 3;
		
		if (SubLen < 0)
			SubLen = 0;
		
		if (ComStr.length > 0)
			ComStr = StrTemp.substring(SubLen) + "," + ComStr;
		else
			ComStr = StrTemp.substring(SubLen);
		
		StrTemp = StrTemp.substring(0, SubLen);
	}
	
	if (ComStr.value != "0")
		return Sign + ComStr;
	else
		return ComStr;
}

// Textarea Max Length Check
function Limit(TargetObj){
	if(TargetObj.getAttribute("maxlength") == null){
		return;
	}
	
	var MaxLength = parseInt(TargetObj.getAttribute("maxlength"), 10);
	if(TargetObj.value.length > MaxLength){
		alert(MaxLength + "자 까지만 입력가능합니다.");
		TargetObj.value = TargetObj.value.substring(0, MaxLength);
		TargetObj.focus();
	}
}

function AddDate(DateStr, Months, Days){
	var YearInt = parseInt(DateStr.substring(0, 4), 10);
	var MonthInt = parseInt(DateStr.substring(4, 6), 10);
	var DayInt = parseInt(DateStr.substring(6, 8), 10);
	
	var StandDate = new Date(YearInt, MonthInt - 1, DayInt);
	
	if(Months != 0){
		StandDate.setMonth(StandDate.getMonth() + Months);
	}
	
	if(Days != 0){
		StandDate.setDate(StandDate.getDate() + Days);
	}
	
	var AddDate = StandDate.getFullYear() + ConvertStr(StandDate.getMonth() + 1, 2) + ConvertStr(StandDate.getDate(), 2);
	
	return AddDate;
}

function BetweenDate(StartDateStr, EndDateStr){
	var StartDate = new Date(parseInt(StartDateStr.substring(0, 4), 10), parseInt(StartDateStr.substring(4, 6), 10) - 1, parseInt(StartDateStr.substring(6, 8), 10));
	var EndDate = new Date(parseInt(EndDateStr.substring(0, 4), 10), parseInt(EndDateStr.substring(4, 6), 10) - 1, parseInt(EndDateStr.substring(6, 8), 10));
	
	var Days = (EndDate.getTime() - StartDate.getTime()) / (1000 * 60 * 60 * 24);
	
	return Days;
}

function BetweenMonth(StartDateStr, EndDateStr){
	var StartDate = new Date(parseInt(StartDateStr.substring(0, 4), 10), parseInt(StartDateStr.substring(4, 6), 10) - 1, parseInt(StartDateStr.substring(6, 8), 10));
	var EndDate = new Date(parseInt(EndDateStr.substring(0, 4), 10), parseInt(EndDateStr.substring(4, 6), 10) - 1, parseInt(EndDateStr.substring(6, 8), 10));
	
	var Months = ((EndDate.getYear() - StartDate.getYear()) * 12) + (EndDate.getMonth() - StartDate.getMonth());
	
	return Months;
}

function MarkDate(DateStr, Mark){
	var MarkStr = "";
	
	if(DateStr.length == 6){
		MarkStr = DateStr.substring(0, 2) + Mark + DateStr.substring(2, 4) + Mark + DateStr.substring(4);
	}
	else if(DateStr.length == 8){
		MarkStr = DateStr.substring(0, 4) + Mark + DateStr.substring(4, 6) + Mark + DateStr.substring(6);
	}
	else{
		MarkStr = DateStr;
	}
	
	return MarkStr;
}

function MarkTime(TimeStr, Mark){
	var MarkStr = "";
	
	if(TimeStr.length == 4){
		MarkStr = TimeStr.substring(0, 2) + Mark + TimeStr.substring(2);
	}
	else if(TimeStr.length == 6){
		MarkStr = TimeStr.substring(0, 2) + Mark + TimeStr.substring(2, 4) + Mark + TimeStr.substring(4);
	}
	else{
		MarkStr = TimeStr;
	}
	
	return MarkStr;
}

function MarkComma(CommaStr){
	var MarkStr = "";
	
	var BuffStr = CommaStr;
	
	try{
		var Minus = "";
		if(BuffStr.substring(0, 1) == "-"){
			Minus = "-";
			BuffStr = BuffStr.substring(1);
		}

		var DotPoint = BuffStr.indexOf(".");
		
		var Prefix = "";
		var Suffix = "";
		
		if(DotPoint > 0){
			Prefix = BuffStr.substring(0, DotPoint);
			Suffix = BuffStr.substring(DotPoint + 1);
		}
		else{
			Prefix = BuffStr;
		}
		
		for(var idx = Prefix.length; idx > 0; idx = idx - 3){
			if(idx - 3 > 0){
				MarkStr = "," + BuffStr.substring(idx - 3, idx) + MarkStr;
			}
			else{
				MarkStr = BuffStr.substring(0, idx) + MarkStr;
			}
		}
		
		if(DotPoint > 0){
			ReturnStr += "." + Suffix;
		}
		
		MarkStr = Minus + MarkStr;
	}catch(e){
		MarkStr = CommaStr;
	}
	
	return MarkStr;
}


 

/*----------------------------------------------------------
  기능   : Split Code RETURN Splited code by varSplitChar
  INPUT  : varString 문자
     : varSplitChar 구분자
   : varIndex 구분자의 위치
  RETURN : Splited code by varSplitChar
  예     : jsSplitCode( "111^222^333", "^", 2 ) == "222"
-----------------------------------------------------------*/
function jsSplitCode(varString, varSplitChar, varIndex) {
 var varArray = varString.split(varSplitChar) ;

 return varArray[eval(varIndex)-1];
}

function ConvertStr(IntValue, ZeroCnt){
	var IntStr = "";
	
	IntStr = IntValue + "";
	
	for(var idx = IntStr.length; idx < ZeroCnt; idx++){
		IntStr = "0" + IntStr;
	}
	
	return IntStr;
}

// Document Scroll
function DocumentTop(){
	window.scrollTo(0, 0);
}

// Document Scroll
function ClipCopy(CopyStr){
	window.clipboardData.setData("Text", CopyStr);
	alert("복사되었습니다.");
}

// 달력창 팝업
function PopCalendar(CalendarDate, YearMon, ObjectName, PastYears, FutureYears, StandYear, LimitFlag, YearMonMin, YearMonMax){
	if(PastYears == null){
		PastYears = "";
	}
	
	if(FutureYears == null){
		FutureYears = "";
	}
	
	if(StandYear == null){
		StandYear = "";
	}
	
	if(LimitFlag == null){
		LimitFlag = "";
	}
	
	if(YearMonMin == null){
		YearMonMin = "";
	}
	
	if(YearMonMax == null){
		YearMonMax = "";
	}
	
	/*
	 * CALENDAR_DATE : 기준일자(달력 선택일). 기준일자 존재 시 해당 월 Default Display.
	 * YEAR_MON : 기준월. 기준일자 부재 시 해당 월 Default Display.
	 * OBJECT_NAME : 일자 선택 시 입력 값 Return 할 Object Name.
	 * PAST_YEARS : 과거년도 표시 기간. Default 110년.
	 * FUTURE_YEARS : 미래년도 표시 기간. Default 10년.
	 * STAND_YEAR : 표시년도 시작 년도. 표시년도부터 현재년도 + FUTURE_YEARS 까지 표시. 기준일자가 표시년월 범위 내에 없을 시 최대 년월 Default Display.
	 * LIMIT_FLAG : 표시년월 제한 여부. Default N. STAND_YEAR 미사용 시 적용. 기준일자가 표시년월 범위 내에 없을 시 최대 년월 Default Display.
	 * YEAR_MON_MIN : 표시년월 최소 년월
	 * YEAR_MON_MAX : 표시년월 최대 년월
	 * 
	 */
	
	var url = "/comm/Calendar.jsp?CALENDAR_DATE=" + CalendarDate + "&YEAR_MON=" + YearMon + "&OBJECT_NAME=" + ObjectName + "&PAST_YEARS=" + PastYears + "&FUTURE_YEARS=" + FutureYears + "&STAND_YEAR=" + StandYear + "&LIMIT_FLAG=" + LimitFlag + "&YEAR_MON_MIN=" + YearMonMin + "&YEAR_MON_MAX=" + YearMonMax;
	window.open(url, "Calendar", "width=200, height=260, toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, directories=no, status=no");
}

// 우편번호 팝업
function PopZip(ZipCdObjectName, AddrObjectName){
	var url = "/comm/ZipCode.jsp?ZIP_CD_OBJECT_NAME=" + ZipCdObjectName + "&ADDR_OBJECT_NAME=" + AddrObjectName;
	window.open(url, "ZipCode", "width=600, height=400, toolbar=no, menubar=no, scrollbars=yes, resizable=no, location=no, directories=no, status=no");
}


// 파일 다운로드
function FileDown(FilePath, FileName){
	location.href("/comm/FileDown.jsp?FILE_PATH=" + FilePath + "&FILE_NAME=" + FileName);
}

function encodespecialChar(str){
	var txt = str.ReplaceAll("%", " ");
	return encodeURIComponent( txt );
}

function encSpecialChar( str  ){
	
	var SpecalCharCount = 0;
	var StrLength = str.length;
	
	for(var idx = 0; idx < StrLength; idx++){
		StrChar = str.substring(idx, idx + 1);
		if ( StrChar == "%"){
			SpecalCharCount ++; 
		}
	}
	if ( SpecalCharCount > 1){
		return str;
	} else if ( SpecalCharCount == 1){
		var txt = str.ReplaceAll("%", " ");
		return encodeURIComponent( txt );
	} else {
		return encodeURIComponent( str );
	}
	
}

	































