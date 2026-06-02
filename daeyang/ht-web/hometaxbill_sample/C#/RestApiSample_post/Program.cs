using System;
using System.IO;
using System.Net;
using System.Text;
using Newtonsoft.Json.Linq;
using System.Text.Json;
using System.Collections.Generic;

namespace RestApi
{
    //json타입으로 전송할 변수들 생성
    public class Data
    {
        public string hometaxbill_id { get; set; }                                      
        public string spass { get; set; }
        public string apikey { get; set; }
        public string homemunseo_id { get; set; }
        public string typecode1 { get; set; }
        public string typecode2 { get; set; }
        public string description { get; set; }
        public string issuedate { get; set; }
        public string modifytype { get; set; }
        public string purposetype { get; set; }
        public string originalissueid { get; set; }
        public string si_id { get; set; }
        public string si_hcnt { get; set; }
        public string si_startdt { get; set; }
        public string si_enddt { get; set; }
        public string ir_companynumber { get; set; }
        public string ir_biztype { get; set; }
        public string ir_companyname { get; set; }
        public string ir_bizclassification { get; set; }
        public string ir_taxnumber { get; set; }
        public string ir_ceoname { get; set; }
        public string ir_busename { get; set; }
        public string ir_name { get; set; }
        public string ir_cell { get; set; }
        public string ir_email { get; set; }
        public string ir_companyaddress { get; set; }
        public string ie_companynumber { get; set; }
        public string ie_biztype { get; set; }
        public string ie_companyname { get; set; }
        public string ie_bizclassification { get; set; }
        public string ie_taxnumber { get; set; }
        public string partytypecode { get; set; }
        public string ie_ceoname { get; set; }
        public string ie_busename1 { get; set; }
        public string ie_name1 { get; set; }
        public string ie_cell1 { get; set; }
        public string ie_email1 { get; set; }
        public string ie_busename2 { get; set; }
        public string ie_name2 { get; set; }
        public string ie_cell2 { get; set; }
        public string ie_email2 { get; set; }
        public string ie_companyaddress { get; set; }
        public string su_companynumber { get; set; }
        public string su_biztype { get; set; }
        public string su_companyname { get; set; }
        public string su_bizclassification { get; set; }
        public string su_taxnumber { get; set; }
        public string su_ceoname { get; set; }
        public string su_busename { get; set; }
        public string su_name { get; set; }
        public string su_cell { get; set; }
        public string su_email { get; set; }
        public string su_companyaddress { get; set; }
        public string cash { get; set; }
        public string scheck { get; set; }
        public string draft { get; set; }
        public string uncollected { get; set; }
        public string chargetotal { get; set; }
        public string taxtotal { get; set; }
        public string grandtotal { get; set; }
        public List<taxdetail> taxdetailList { get; set; }
    }
    public class taxdetail
    {
        public string description { get; set; }         // 품목 비고
        public string supplyprice { get; set; }         // 풍목 공급가액
        public string quantity { get; set; }            // 품목 수량
        public string unit { get; set; }                // 품목 규격
        public string subject { get; set; }             // 품목 품목명
        public string gyymmdd { get; set; }             // 품목 공급년월일
        public string tax { get; set; }                 // 품목 세액
        public string unitprice { get; set; }           // 품목 단가

    }

    public class WebRequestPostExample
    {
        public static void Main()
        {
            //api주소 셋팅
            WebRequest request = WebRequest.Create("http://115.68.1.5:8084/homtax/post");

            // POST형식으로 전송설정
            request.Method = "POST";

            // json변수명과 데이터를 입력
            var Data = new Data
            {
                hometaxbill_id = "cmj0633",                                                         // 회사코드
                spass = "Mem12345",                                                                 // 패스워드
                apikey = "SSADFVSDFSDE",                                                            // 인증키
                homemunseo_id = "HTB20210305092725",                                                // 고유번호            
                typecode1 = "01",                                                                   // (세금)계산서 분류
                typecode2 = "01",                                                                   // (세금)계산서 분류
                description = "비고사항입력 랍니다",                                                // 비고 
                issuedate = "20210311",                                                             // 작성일자
                modifytype = "",                                                                    // 수정코드
                purposetype = "02",                                                                 // 영수/청구 구분
                originalissueid = "",                                                               // 당초승인번호
                si_id = "",                                                                         // 수입신고번호
                si_hcnt = "",                                                                       // 수입총건
                si_startdt = "",                                                                    // 일괄발급시작일
                si_enddt = "",                                                                      // 일괄발급종료일
                ir_companynumber = "1358187511",                                                    // 공급자 사업자등록번호
                ir_biztype = "서비스업,도소매",                                                     // 공급자 업태
                ir_companyname = "(주)신안소프트",                                                  // 공급자 상호
                ir_bizclassification = "소프트웨어개발업외하드웨어,쇼핑몰유통사업",                 // 공급자 업종
                ir_taxnumber = "",                                                                  // 공급자 종사업자번호
                ir_ceoname = "김순관",                                                              // 공급자 대표자성명
                ir_busename = "개발",                                                               // 공급자 담당부서명
                ir_name = "김기사",                                                                 // 공급자 담당자명
                ir_cell = "010-1234-4321",                                                          // 공급자 담당자전화번호
                ir_email = "sinit@sinit.co.kr",                                                     // 공급자 담당자이메일
                ir_companyaddress = "수원시 영통구 신원로 88(신동) 102동 713호 ",                   // 공급자 주소
                ie_companynumber = "1358187511",                                                    // 공급받는자 사업자등록번호
                ie_biztype = "서비스업,도소매",                                                     // 공급받는자 업태
                ie_companyname = "(주)공급받는자 회사명",                                           // 공급받는자 상호
                ie_bizclassification = "하드웨어,소핑몰유통사업",                                   // 공급받는자 업종
                ie_taxnumber = "",                                                                  // 공급받는자 종사업장번호
                partytypecode = "01",                                                               // 공급받는자 구분
                ie_ceoname = "김사랑",                                                              // 공급받는자 대표자성명
                ie_busename1 = "개발",                                                              // 공급받는자 담당부서명1
                ie_name1 = "김사랑",                                                                // 공급받는자 담당자명1
                ie_cell1 = "010-9999-1234",                                                         // 공급받는자 담당자번화번호1
                ie_email1 = "sinit@sinit.co.kr",                                                    // 공급받는자 담당자이메일1
                ie_busename2 = "CS",                                                                // 공급받는자 담당부서명2
                ie_name2 = "김시아",                                                                // 공급받는자 담당자명2
                ie_cell2 = "010-2222-4444",                                                         // 공급받는자 담당자전화번호2
                ie_email2 = "sinit1@sinit.co.kr",                                                   // 공급받는자 담당자이메일2
                ie_companyaddress = "수원시 영통구 신원로 88(신동) 102동 713호 ",                   // 공급받는자 주소
                su_companynumber = "",                                                              // 수탁사업자 사업자등록번호
                su_biztype = "",                                                                    // 수탁사업자 업태
                su_companyname = "",                                                                // 수탁사업자 상호
                su_bizclassification = "",                                                          // 수탁사업자 업종
                su_taxnumber = "",                                                                  // 수탁사업자 종사업장번호
                su_ceoname = "",                                                                    // 수탁사업자 대표자성명
                su_busename = "",                                                                   // 수탁사업자 담당부서명
                su_name = "",                                                                       // 수탁사업자 담당자명
                su_cell = "",                                                                       // 수탁사업자 담당자번화번호
                su_email = "",                                                                      // 수탁사업자 담당자이메일
                su_companyaddress = "",                                                             // 수탁사업자 주소
                cash = "1000000",                                                                   // 현금금액
                scheck = "0",                                                                       // 수표금액
                draft = "0",                                                                        // 어음금액
                uncollected = "0",                                                                  // 외상미수금금액
                chargetotal = "1000000",                                                            // 공급가액합계
                taxtotal = "100000",                                                                // 세액합계
                grandtotal = "1100000",                                                             // 총금액

                taxdetailList = new List<taxdetail>()
                {
                    new taxdetail() { description = "품목별비고입력", supplyprice = "500000" , quantity = "0.00", unit = "" ,
                                       subject = "품목명1" , gyymmdd = "20210311" , tax = "50000" , unitprice = "50000" },
                    new taxdetail() { description = "품목별비고입력", supplyprice = "500000" , quantity = "0.00", unit = "" ,
                                       subject = "품목명2" , gyymmdd = "20210311" , tax = "50000" , unitprice = "50000" },
                }
            };

            //json타입 및 utf8로 인코딩
            string postData = JsonSerializer.Serialize(Data);
            JObject json = JObject.Parse(postData);
            byte[] byteArray = Encoding.UTF8.GetBytes(postData);

            // ContentType 속성을 json형식으로 설정
            request.ContentType = "application/json";

            // Set the ContentLength property of the WebRequest.
            request.ContentLength = byteArray.Length;

            // GetRequestStream 메서드를 호출하여 요청 데이터를 포함하는 스트림을 저장
            Stream dataStream = request.GetRequestStream();
            dataStream.Write(byteArray, 0, byteArray.Length);
            dataStream.Close();

            // 응답받은 json값을 저장
            try
            {
                WebResponse response = request.GetResponse();

                // 리턴받은 json데이터 가공
                using (dataStream = response.GetResponseStream())
                {
                    StreamReader reader = new StreamReader(dataStream);
                    string responseFromServer = reader.ReadToEnd();
                    JObject jsont = JObject.Parse(responseFromServer);

                    //(HttpWebResponse)response).StatusCode = 서버상태값 호출 
                    // OK = (200 , 서버연결 성공) , NotFound = (404 , 서버가 없는경우) 
                    // 자세한 내용은 https://docs.microsoft.com/ko-kr/dotnet/api/system.net.httpstatuscode?view=net-6.0 참조
                    if (((HttpWebResponse)response).StatusCode == HttpStatusCode.OK)
                    {
                        Console.WriteLine("code = " + (string)jsont["code"]);                           // MSG CODE
                        Console.WriteLine("msg = " + (string)jsont["msg"]);                             // 메세지
                        Console.WriteLine("jsnumber = " + (string)jsont["jsnumber"]);                   // 접수번호
                        Console.WriteLine("hometaxbill_id = " + (string)jsont["hometaxbill_id"]);       // 거래처code
                        Console.WriteLine("homemunseo_id = " + (string)jsont["homemunseo_id"]);         // 거래처의 고유번호 (중복부여시 error발생함 .이중발행 방지)
                    }
                    
                }

                // Close the response.
                response.Close();
            }
            catch (Exception e)
            {
                Console.WriteLine("서버오류입니다.");
            }
        }
    }
}
