using System;
using System.IO;
using System.Net;
using System.Text;
using Newtonsoft.Json.Linq;
using System.Text.Json;

namespace RestApi2
{
    //json타입으로 전송할 변수들 생성
    public class Data
    {
        public string hometaxbill_id { get; set; }
        public string spass { get; set; }
        public string apikey { get; set; }
        public string homemunseo_id { get; set; }
    }

    public class WebRequestPostExample
    {
        public static void Main()
        {
            //api주소 셋팅
            WebRequest request = WebRequest.Create("http://115.68.1.5:8084/homtax/getpkey");

            // POST형식으로 전송설정
            request.Method = "POST";
            
            // json변수명과 데이터를 입력
            var Data = new Data
            {
                hometaxbill_id = "cmj0633",         // 회사코드
                spass = "Mem12345",                 // 회사비밀번호
                apikey = "SSADFVSDFSDE",            // api인증코드
                homemunseo_id = "33033333323"       // 고유번호
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
                        Console.WriteLine("hometaxbill_id = " + (string)jsont["hometaxbill_id"]);       // 거래처code
                        Console.WriteLine("homemunseo_id = " + (string)jsont["homemunseo_id"]);         // 거래처의 고유번호 (중복부여시 error발생함 .이중발행 방지)
                        Console.WriteLine("issueid = " + (string)jsont["issueid"]);                     // 세금계산서 승인번호
                        Console.WriteLine("declarestatus = " + (string)jsont["declarestatus"]);         // 현재 세금계산서발행 상태 값을 RETURN
                        Console.WriteLine("msg2 = " + (string)jsont["msg2"]);                           // 상세메세지
                    }
                }

                // declarestatus = 세금계산서 발행상태 및 진행상황을  판단 하십시오 (API문서의 상태값입니다).
                //  01 =	수기작성	사용회사정보 수동일 경우 전송하기 전 상태(전송 미처리시 국세청 전송불가)
                //  10 =	전송대기	국세청 전송 대기 상태(10분 이내 자동전송 처리 예정)
                //  03 =	국세청 전송처리중	국세청으로 세금계산서 데이터 전송처리 진행중인 상태
                //  04 =	국세청 전송완료(결과수신대기) 국세청으로 세금계산서 데이터를 전송하고 결과 수신 대기인 상태
                //  05 =	홈택스빌 처리중 Error	국세청 전송하기 전 작업처리중에 에러가 발생한 상태(재전송 처리예정)
                //  06 =	국세청 전송중 Error	국세청 데이터 전송중 에러가 발생한 상태(재전송 처리예정)
                //  08 =	발급완료	국세청으로부터 정상적으로 승인처리된 상태
                //  09 =	발급실패	국세청으로부터 전자세금계산서 발급 승인이 나지 않는 상태
                //  99 =	인증서 검증 Error	인증서 유효기간이 지나거나 폐기 처리된 인증서로 인증서에 문제가 발생한 상태
                //
                // EX1)  declarestatus = '08' 라면 code 에는 실패이유 CODE가retrun되고 msg 에는 실패 사유를 RETURN합니다.
                // EX2)  declarestatus = '09' 라면 code 에는 성공한 CODE가 return되고 msg 에는 정상처리 return

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
