from io  import StringIO
import requests
import json

# json형태로 변환해주기 전 key 정보생성
class tax_master:
    def __init__(self, hometaxbill_id, spass, apikey, homemunseo_id, typecode1, typecode2, description, issuedate, modifytype,
                        purposetype, originalissueid, si_id, si_hcnt, si_startdt, si_enddt, ir_companynumber, ir_biztype, ir_companyname, ir_bizclassification,
                        ir_ceoname, ir_busename, ir_name, ir_cell, ir_email, ir_companyaddress, ie_companynumber, ie_biztype, ie_companyname, ie_bizclassification,
                        ie_taxnumber, partytypecode, ie_ceoname, ie_busename1, ie_name1, ie_cell1, ie_email1, ie_busename2, ie_name2, ie_cell2, ie_email2, ie_companyaddress,
                        su_companynumber, su_biztype, su_companyname, su_bizclassification, su_taxnumber, su_ceoname, su_busename, su_name, su_cell, su_email,
                        su_companyaddress, cash, scheck, draft, uncollected, chargetotal, taxtotal, grandtotal, taxdetailList):

        self.hometaxbill_id = hometaxbill_id                    # 회사코드
        self.spass = spass                                      # 패스워드
        self.apikey = apikey                                    # 인증키
        self.homemunseo_id = homemunseo_id                      # 고유번호(거래처 세금계산서 고유번호입니다 중복부여시 error발생.이중발행 방지)
        self.typecode1 = typecode1                              # (세금)계산서 종류1
        self.typecode2 = typecode2                              # (세금)계산서 종류2
        self.description = description                          # 비고
        self.issuedate = issuedate                              # 작성일자
        self.modifytype = modifytype                            # 수정사유
        self.purposetype = purposetype                          # 영수/청구 구분
        self.originalissueid = originalissueid                  # 당초전자(세금)계산서 승인번호
        self.si_id = si_id                                      # 수입신고번호
        self.si_hcnt = si_hcnt                                  # 수입총건
        self.si_startdt = si_startdt                            # 일괄발급시작일
        self.si_enddt = si_enddt                                # 일괄발급종료일
        self.ir_companynumber = ir_companynumber                # 공급자사업자등록번호
        self.ir_biztype = ir_biztype                            # 공급자 업태
        self.ir_companyname = ir_companyname                    # 공급자 상호
        self.ir_bizclassification = ir_bizclassification        # 공급자 업종
        self.ir_ceoname = ir_ceoname                            # 공급자 대표자성명
        self.ir_busename = ir_busename                          # 공급자 담당부서명
        self.ir_name = ir_name                                  # 공급자 담당자명
        self.ir_cell = ir_cell                                  # 공급자 담당자전화번호
        self.ir_email = ir_email                                # 공급자 담당자이메일
        self.ir_companyaddress = ir_companyaddress              # 공급자 주소
        self.ie_companynumber = ie_companynumber                # 공급받는자 사업자등록번호
        self.ie_biztype = ie_biztype                            # 공급받는자 업태
        self.ie_companyname = ie_companyname                    # 공급받는자 사업체명
        self.ie_bizclassification = ie_bizclassification        # 공급받는자 업종
        self.ie_taxnumber = ie_taxnumber                        # 공급받는자 종사업장번호
        self.partytypecode = partytypecode                      # 공급받는자 구분 01=사업자등록번호 02=주민등록번호 03=외국인
        self.ie_ceoname = ie_ceoname                            # 공급받는자 대표자명
        self.ie_busename1 = ie_busename1                        # 공급받는자 담당부서1
        self.ie_name1 = ie_name1                                # 공급받는자 담당자명1
        self.ie_cell1 = ie_cell1                                # 공급받는자 담당자연락처1
        self.ie_email1 = ie_email1                              # 공급받는자 담당자이메일1
        self.ie_busename2 = ie_busename2                        # 공급받는자 담당부서2
        self.ie_name2 = ie_name2                                # 공급받는자 담당자명2
        self.ie_cell2 = ie_cell2                                # 공급받는자 담당자연락처2
        self.ie_email2 = ie_email2                              # 공급받는자 담당자이메일2
        self.ie_companyaddress = ie_companyaddress              # 공급받는자 회사주소
        self.su_companynumber = su_companynumber                # 수탁사업자 사업자등록번호
        self.su_biztype = su_biztype                            # 수탁사업자 업태
        self.su_companyname = su_companyname                    # 수탁사업자 상호명
        self.su_bizclassification = su_bizclassification        # 수탁사업자 업종
        self.su_taxnumber = su_taxnumber                        # 수탁사업자 종사업장번호
        self.su_ceoname = su_ceoname                            # 수탁사업자 대표자명
        self.su_busename = su_busename                          # 수탁사업자 담당부서명
        self.su_name = su_name                                  # 수탁사업자 담당자명
        self.su_cell = su_cell                                  # 수탁사업자 담당자전화번호
        self.su_email = su_email                                # 수탁사업자 담당자이메일
        self.su_companyaddress = su_companyaddress              # 수탁사업자 회사주소
        self.cash = cash                                        # 현금
        self.scheck = scheck                                    # 수표
        self.draft = draft                                      # 어음
        self.uncollected = uncollected                          # 외상 미수금
        self.chargetotal = chargetotal                          # 총 공급가액
        self.taxtotal = taxtotal                                # 총 세액
        self.grandtotal = grandtotal                            # 총 금액
        self.taxdetailList = taxdetailList                      # ### post_detail 참고 ###


# json형태로 변환해주기 전 key 정보생성(상세내역정보입력)
class tax_detail:
    def __init__(self, description, supplyprice, quantity, unit, subject, gyymmdd, tax, unitprice):

        self.description = description                          # 품목별 비고입력
        self.supplyprice = supplyprice                          # 품목별 공급가액
        self.quantity = quantity                                # 품목수량
        self.unit = unit                                        # 품목규격
        self.subject = subject                                  # 품목명
        self.gyymmdd = gyymmdd                                  # 공급연원일
        self.tax = tax                                          # 세액
        self.unitprice = unitprice                              # 단가


def Start_Rtn():

        taxdetail = []
        #class tax_master 변수와 순서를 정확하게 일치 시키십시오 .
        for i in range(0, 4):  #상세품목개수만큼 배열에 추가해야함 (최대 99row 까지 입력가능)
            # class tax_detail 변수와 정확하게 일치 시키십시오
            taxdetail.append(tax_detail("품목별비고입력", "500", "1", "", "품목", "20010501", "50", "0").__dict__)

        #class tax_master 변수와 순서를 정확하게 일치 시키십시오
        #세금계산서 마스터 항목을 셋팅한다. 마스터항목과 디테일항목(taxdetail) 가지고간다.
        post_value = tax_master("cmj0633", "Mem12345", "SSADFVSDFSDE", "ccal2202323655660041", "01", "01", "",
                            "20210819", "",
                            "02", "", "", "0", "", "", "1358187511", "서비스업", "홈택스빌", "소프트웨어개발",
                            "홍길동", "", "업체담당자", "01033334444", "irabc@sinit.co.kr", "경기도 수원시 영통구", "44455666666", "판매업",
                            "오케이뱅크", "서비스업",
                            "", "01", "이나영", "", "공급담당자", "01011112222", "ieabc@sinit.co.kr", "", "", "", "",
                            "서울시 금천구 가산디지털로",
                            "", "", "", "", "", "", "", "", "", "",
                            "", "2200", "0", "0", "0", "2000", "200", "2200", taxdetail)

        # key값과 매칭되는 value값 입력
        #json 파싱
        json_object = post_value.__dict__  #객체의 변수를 dict형태로 변경할 수 있다.

        json_object = json.dumps(json_object , ensure_ascii=False , indent=4) # 한글 깨짐 해결
        json_object = StringIO(json_object)
        json_object = json.load(json_object)

        print(json_object) #최종완성된 json

        try:
            resp = requests.post('http://115.68.1.5:8084/homtax/post', json=json_object)
            #resp = requests.post('http://115.68.1.5:8084/homtax/postAll', json=json_object)  # post 값 전체를 return받을시 사용.

            print(resp.status_code)

            #홈택스빌과 정상적인 통신을 하였다면....
            if resp.status_code == 200:
               jsontoarray = resp.text  #홈택스빌 return 값
               print(jsontoarray)

               if json.loads(jsontoarray)['code'] == '-1': #접수실패
                  print(json.loads(jsontoarray)['msg'])   #실패이유
                  return -1

               # 접수에 성공했다면
               print("code : "+json.loads(jsontoarray)['code'])                       #코드 "0"=정상접수, "-1"=접수실패
               print("msg : "+json.loads(jsontoarray)['msg'])                         #접수에 대한 결과 메세지
               print("jsnumber : " + json.loads(jsontoarray)['jsnumber'])             #홈택스빌 접수번호
               print("hometaxbill_id : " + json.loads(jsontoarray)['hometaxbill_id']) #거래처code
               print("homemunseo_id : " + json.loads(jsontoarray)['homemunseo_id'])   #거래처의 고유번호 (중복부여시 error발생함 .이중발행 방지)
               return 0  # 접수성공 return
            else:
               print("서버와의 통신이 비정상적 입니다.")
               return -1

        except:
            print("서버와의 통신은 정상이나 로직처리중 except...error 입니다.")
            return -1

# 프로그램 start.....
if __name__ == "__main__":
       Start_Rtn()
