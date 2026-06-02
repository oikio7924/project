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
		echo "http://115.68.1.5:8084/homtax/getpkey 서버에 문제가 발생했습니다.";
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

	세금계산서 결과 조회 API

	hometaxbill_id					회사코드		
	spass							패스워드						홈택스빌 코드관리 > 사업장정보 > 프로그램 비밀번호
	apikey							인증키							홈택스빌 기초코드관리 > 사업장정보 > 연동API-KEY
	homemunseo_id					고유번호						회사에서 정의한 세금계산서 고유번호(중복불가)	사업자관리번호

*/

$url = "http://115.68.1.5:8084/homtax/getpkey";
//$url = "http://115.68.1.5:8084/homtax/getpkeyAll"; //세금계산서 전체항목 RETURN시 사용

$json = '{"hometaxbill_id": "cmj0633", 
		  "spass"		  :	"Mem12345"	,
		  "apikey"		  : "SSADFVSDFSDE",       
		  "homemunseo_id" : "33033333323"   
		  }	';

$ret = Curl($url, $json);

//리턴받을때 한글깨짐 방지를 위한 한글인코딩
echo iconv("UTF-8", "EUC-KR", $ret);

/*
	결과 리턴값($ret)
	
	code			:	결과코드
	msg				:	결과메세지
	msg2			:	결과상세 메세지
	hometaxbill_id	:	회사코드
	homemunseo_id	:	업체고유번호
	homemunseo_id	:	승인번호
	declarestatus	:	세금계산서 발행상태 
	
	declarestatus = 세금계산서 발행상태 및 진행상황을  판단 하십시오 (API문서의 상태값입니다).
	 01 =	수기작성	사용회사정보 수동일 경우 전송하기 전 상태(전송 미처리시 국세청 전송불가)
	 10 =	전송대기	국세청 전송 대기 상태(10분 이내 자동전송 처리 예정)
	 03 =	국세청 전송처리중	국세청으로 세금계산서 데이터 전송처리 진행중인 상태
	 04 =	국세청 전송완료(결과수신대기) 국세청으로 세금계산서 데이터를 전송하고 결과 수신 대기인 상태
	 05 =	홈택스빌 처리중 Error	국세청 전송하기 전 작업처리중에 에러가 발생한 상태(재전송 처리예정)
	 06 =	국세청 전송중 Error	국세청 데이터 전송중 에러가 발생한 상태(재전송 처리예정)
	 08 =	발급완료	국세청으로부터 정상적으로 승인처리된 상태
	 09 =	발급실패	국세청으로부터 전자세금계산서 발급 승인이 나지 않는 상태
	 99 =	인증서 검증 Error	인증서 유효기간이 지나거나 폐기 처리된 인증서로 인증서에 문제가 발생한 상태
   
	 EX1)  declarestatus = '08' 라면 code 에는 성공한 CODE가 return되고 msg 에는 정상처리 return
	 EX2)  declarestatus = '09' 라면 code 에는 실패이유 CODE가retrun되고 msg 에는 실패 사유를 RETURN합니다.
	
*/

?>




