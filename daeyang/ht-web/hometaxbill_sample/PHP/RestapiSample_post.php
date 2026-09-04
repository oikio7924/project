<!--
php파일 생성시 인코딩 방식을 utf-8로 설정해야함.(전송시 한글깨짐방지)
-->
<?php
function Curl($url, $post_data, &$header = null) {

	//curl 초기화
    $ch=curl_init();

    //===============curl에 url 셋팅================

	//URL 지정하기
	curl_setopt($ch, CURLOPT_URL, $url); 
	//0이 default 값이며 POST 통신을 위해 1로 설정해야 함
	curl_setopt($ch, CURLOPT_POST, true); 
	//POST로 보낼 데이터 지정하기
	curl_setopt($ch, CURLOPT_POSTFIELDS, $post_data); 
	//이 값을 0으로 해야 알아서 &post_data 크기를 측정
	curl_setopt($ch, CURLOPT_POSTFIELDSIZE, 0); 
    if (!is_null($header)) {
        curl_setopt($ch, CURLOPT_HEADER, true);
    }
	//header 지정하기
	curl_setopt($ch, CURLOPT_HTTPHEADER, array('Accept: application/json', 'Content-Type: application/json','charset=utf-8"')); 
	//이 옵션이 0으로 지정되면 curl_exec의 결과값을 브라우저에 바로 보여줌. 이 값을 true로 하면 결과값을 return하게 되어 변수에 저장 가능
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true); 

	//curl_exec로 전송과 동시에 결과값 리턴받음
    $response = curl_exec($ch);

    $body = null;
    // 통신에 문제가 생겼을시 예외처리
    if (!$response) {
        $body = curl_error($ch);
        $http_status = -1;
		echo "http://115.68.1.5:8084/homtax/post 서버에 문제가 발생했습니다.";
		exit;
    } 

	// api서버의 상태를 http_code변수에 선언
	$http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);

	// 홈택스빌과 정상적인 통신을 하였다면....
	if($http_code == 200){
		$body = $response;
	}else{
		if($http_code == 404) {
			$message = ' 해당페이지가 존재하지 않습니다. 새로고침 후 다시 시도해주세요.';
			echo $message;
			exit;
		}else if($http_code == 500) {
			$message = ' 해당페이지가 원활하지 않습니다. 잠시후에 다시 시도해주세요.';
			echo $message;
			exit;
		}else{
			$message = ' 통신 오류로 인해 잠시후에 다시 시도해주세요.';
			echo $message;		
			exit;		
		}
	}
 
    curl_close($ch);
    return $body;
}


/*
	세금계산서 전송 API
	* 필수값 표기
	
	*hometaxbill_id					회사코드	
	*spass							패스워드						대문자+소문자+숫자	
	*apikey							인증키							taxbill에서 발급	
	*homemunseo_id					고유번호						회사에서 정의한 세금계산서 고유번호(중복불가)	사업자관리번호
	*typecode1						(세금)계산서 종류1				01=세금계산서 02=수정세금계산서 03=계산서 04=수정계산서	(세금)계산서 분류
	*typecode2						(세금)계산서 종류2				01=일반 02=영세율 03=위수탁 04=수입 05=영세율위수탁 06=수입납부유예	(세금)계산서 종류
	description						비고							수정(세금)계산서와 관련된 내용은 첫 번째 비고에 기재해야한다	비고
	*issuedate						작성일자						YYYYMMDD(-없이)	작성일자
	modifytype						수정사유						01=기재사항의 착오.정정 02=공급가액변동 03=환입 04=계약의 해제 05=내국신용장 사후개설	수정코드
	*purposetype					영수/청구 구분					01=영수 02=청구	영수/청구 구분
	originalissueid					당초전자(세금)계산서 승인번호			
	si_id							수입신고번호						
	si_hcnt							수입총건	
	si_startdt						일괄발급시작일	
	si_enddt						일괄발급종료일	
	*ir_companynumber				공급자사업자등록번호				사업자등록번호(-없이)	
	*ir_biztype						공급자 업태	
	*ir_companyname					공급자 상호	
	*ir_bizclassification			공급자 업종	
	ir_taxnumber					공급자 종사업자 식별코드			(사업자단위과세제도에 따라 국세청에서 부여한코드)	
	*ir_ceoname						공급자 대표자성명					
	ir_busename						공급자 담당부서명	
	ir_name							공급자 담당자명	
	ir_cell							공급자 담당자전화번호	
	*ir_email						공급자 담당자이메일	
	*ir_companyaddress				공급자 주소	
	*ie_companynumber				공급받는자 사업자등록번호			주민번호,사업자등록번호(-없이)	
	*ie_biztype						공급받는자 업태	
	*ie_companyname					공급받는자 사업체명	
	*ie_bizclassification			공급받는자 업종	
	ie_taxnumber					공급받는자 종사업장번호				사업자단위과세제도에 따라 국세청에서 부여한 코드	종사업장번호
	*partytypecode					공급받는자 구분					01=사업자등록번호 02=주민등록번호 03=외국인	사업자등록번호 구분코드
	ie_ceoname						공급받는자 대표자명	
	ie_busename1					공급받는자 담당부서1	
	ie_name1						공급받는자 담당자명1	
	ie_cell1						공급받는자 담당자연락처1	
	ie_email1						공급받는자 담당자이메일1	
	ie_busename2					공급받는자 담당부서2	
	ie_name2						공급받는자 담당자명2	
	ie_cell2						공급받는자 담당자연락처2	
	ie_email2						공급받는자 담당자이메일2	
	ie_companyaddress				공급받는자 회사주소	
	*su_companynumber				수탁사업자 사업자등록번호	
	su_biztype						수탁사업자 업태	
	*su_companyname					수탁사업자 상호명	
	su_bizclassification			수탁사업자 업종	
	su_taxnumber					수탁사업자 종사업장번호				사업자단위과세제도에 따라 국세청에서 부여항코드	종사업장번호
	*su_ceoname						수탁사업자 대표자명	
	su_busename						수탁사업자 담당부서명	
	su_name							수탁사업자 담당자명	
	su_cell							수탁사업자 담당자전화번호	
	su_email						수탁사업자 담당자이메일	
	su_companyaddress				수탁사업자 회사주소	
	*cash	현금	string(18)			결제방법코드/금액
	*scheck	수표	string(18)			결제방법코드/금액
	*draft	어음	string(18)			결제방법코드/금액
	*uncollected					외상 미수금	
	*chargetotal					총 공급가액	
	*taxtotal						총 세액	
	grandtotal						총 금액
	
	[* 품목 등록 1 ~ 99개까지 가능(반복)]
	taxdetailList[description]		품목별 비고입력					품목과 관련된 자유기술문(비고)	
	*taxdetailList[supplyprice]		품목공급가액						공급가액
	taxdetailList[quantity]			품목수량						소숫점 2자리까지 허용 "-"값을 허용	
	taxdetailList[unit]				품목규격	
	taxdetailList[subject]			품목명	
	taxdetailList[gyymmdd]			공급연월일						YYYYMMDD형식	
	*taxdetailList[tax]				세액			
	taxdetailList[unitprice]		단가							소숫점 2자리까지 허용 "-"값을 허용		
*/


$url = "http://115.68.1.5:8084/homtax/post";
//$url = "http://115.68.1.5:8084/homtax/postAll"; //post 값 전체를 return받을시 사용.


$json = '{
    "hometaxbill_id": "itsinit3",	        
    "spass":	"Mem12345"	,		
    "apikey": "SSADFVSDFSDE",		
    "homemunseo_id": "1000545465",	
    "pcode" : "companymanage",		
    "typecode1": "01",              
    "typecode2": "01",				
    "description": "비고사항입력 랍니다", 
    "issuedate": "20010524",		
    "modifytype": "01",				
    "purposetype": "01",			
    "originalissueid": "",			
    "si_id": "2",					
    "si_hcnt": "10",				
    "si_startdt": "",				
    "si_enddt": "",				    
    "ir_companynumber": "1358187511",
    "ir_biztype": "소프트웨어개발",		
    "ir_companyname": "(주)신안소프트",	
    "ir_bizclassification": "",		
    "ir_taxnumber": "",              
    "ir_ceoname": "",				
    "ir_busename": "",				
    "ir_name": "",					 
    "ir_cell": "",					 
    "ir_email": "",					 
    "ir_companyaddress": "",				 
    "ie_companynumber": "1118812544",		
    "ie_biztype": "",				         
    "ie_companyname": "(주)공급받는자 주식회사",	
    "ie_bizclassification": "",				 
    "ie_taxnumber": "",					
    "partytypecode": "01",				
    "ie_ceoname": "",					
    "ie_busename1": "",					
    "ie_name1": "",					  
    "ie_cell1": "",				
    "ie_email1": "",			
    "ie_busename2": "",			
    "ie_name2": "",				
    "ie_cell2": "",				
    "ie_email2": "",			
    "ie_companyaddress": "",	
    "su_companynumber": "",		
    "su_biztype": "",			
    "su_companyname": "",		
    "su_bizclassification": "",	
    "su_taxnumber": "",			
    "su_ceoname": "",			
    "su_busename": "",			
    "su_name": "",				
    "su_cell": "",				
    "su_email": "",				
    "su_companyaddress": "",	
    "cash": "0",				
    "scheck": "0",				
    "draft": "0",				
    "uncollected": "0",			
    "chargetotal": "1000000",	
    "taxtotal": "100000",		
    "grandtotal": "1100000",	
    "taxdetailList": [				
        {
            "description": "품목별비고입력",	 	
            "supplyprice": "500000",	
            "quantity": "0.00",			
            "unit": "",					
            "subject": "",				
            "gyymmdd": "20010501",		
            "tax": "50000",             
            "unitprice": "50000"		
        },
        {
            "description": "품목별비고입력",
            "supplyprice": "500000",
            "quantity": "0.00",
            "unit": "",
            "subject": "",
            "gyymmdd": "20010501",
            "tax": "50000",
            "unitprice": "50000"
        }
    ]
}';

$ret = Curl($url, $json);

//리턴받을때 한글깨짐 방지를 위한 한글인코딩
echo iconv("UTF-8", "EUC-KR", $ret);

/*
	전송시 리턴값($ret)

	code			:	코드(0:접수성공, -1:접수에러)
	msg				:	결과메시지
	jsnumber		:	접수번호
	hometaxbill_id	:	회사코드
	homemunseo_id	:	업체고유번호	
*/

?>

