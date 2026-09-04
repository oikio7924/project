import json
from io import StringIO

import requests

# json형태로 변환해주기 전 key 정보생성
class getpkey:
    def __init__(self, hometaxbill_id, spass, apikey, homemunseo_id):

        self.hometaxbill_id = hometaxbill_id        # 회사코드
        self.spass = spass                          # 회사비밀번호
        self.apikey = apikey                        # api인증코드
        self.homemunseo_id = homemunseo_id          # 고유번호

def Start_Rtn():
    # key값과 매칭되는 value값 입력
    post_value = getpkey('cmj0633', 'Mem12345', 'SSADFVSDFSDE', 'ccal20223655660041')

    # key값과 매칭되는 value값 입력
    # json 파싱
    json_object = post_value.__dict__
    json_object = json.dumps(json_object, ensure_ascii=False, indent=4)  # 한글 깨짐 해결
    json_object = StringIO(json_object)
    json_object = json.load(json_object)

    print(json_object)  # 최종완성된 json

    # 리턴해줄 서버url과 class에 담은 데이터 json으로 변환
    try:

        resp = requests.post('http://115.68.1.5:8084/homtax/getpkey', json=json_object)
        #resp = requests.post('http://115.68.1.5:8084/homtax/getpkeyAll', json=json_object) #세금계산서 전체항목 RETURN시 사용

        #홈택스빌과 정상적인 통신을 하였다면....
        if resp.status_code == 200:
           jsontoarray = resp.text  #홈택스빌 return 값

           print(jsontoarray)


           print("code : "+json.loads(jsontoarray)['code'])                        #MSG CODE
           print("msg : "+json.loads(jsontoarray)['msg'])                          #메세지
           print("hometaxbill_id : " + json.loads(jsontoarray)['hometaxbill_id'])  #거래처code
           print("homemunseo_id : " + json.loads(jsontoarray)['homemunseo_id'])    #거래처의 고유번호 (중복부여시 error발생함 .이중발행 방지)
           print("issueid : " + json.loads(jsontoarray)['issueid'])                #세금계산서 승인번호
           print("declarestatus : " + json.loads(jsontoarray)['declarestatus'])    #현재 세금계산서발행 상태 값을 RETURN합니다.
           print("msg2 : " + json.loads(jsontoarray)['msg2'])                      #declarestatus 상세메세지


           '''
           # declarestatus = 세금계산서 발행상태 및 진행상황을  판단 하십시오 (API문서의 상태값입니다).
           #  01 =	수기작성	사용회사정보 수동일 경우 전송하기 전 상태(전송 미처리시 국세청 전송불가)
           #  10 =	전송대기	국세청 전송 대기 상태(10분 이내 자동전송 처리 예정)
           #  03 =	국세청 전송처리중	국세청으로 세금계산서 데이터 전송처리 진행중인 상태
           #  04 =	국세청 전송완료(결과수신대기) 국세청으로 세금계산서 데이터를 전송하고 결과 수신 대기인 상태
           #  05 =	홈택스빌 처리중 Error	국세청 전송하기 전 작업처리중에 에러가 발생한 상태(재전송 처리예정)
           #  06 =	국세청 전송중 Error	국세청 데이터 전송중 에러가 발생한 상태(재전송 처리예정)
           #  08 =	발급완료	국세청으로부터 정상적으로 승인처리된 상태
           #  09 =	발급실패	국세청으로부터 전자세금계산서 발급 승인이 나지 않는 상태
           #  99 =	인증서 검증 Error	인증서 유효기간이 지나거나 폐기 처리된 인증서로 인증서에 문제가 발생한 상태
           #
           #  EX1)  declarestatus = '08' 라면 code 에는 성공한 CODE가 return되고 msg 에는 정상처리 return
           #  EX2)  declarestatus = '09' 라면 code 에는 실패이유 CODE가retrun되고 msg 에는 실패 사유를 RETURN합니다.
           '''

           return 0  # 접수성공 return
        else:
           print("서버와의 통신이 비정상적 입니다.")
           return -1

    except:
        print('except ... 문제가 발생했습니다.')
        return -1


# 프로그램 start.....
if __name__ == "__main__":
       Start_Rtn()




