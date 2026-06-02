unit Unit2;

interface

//마지막 JSON은 꼭 추가해야함. (아래서 json관련 선언을 하기위해)
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, REST.Types,
  Data.Bind.Components, Data.Bind.ObjectScope, REST.Client, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,JSON;

type
  TForm2 = class(TForm)
    Button1: TButton;
    Memo2: TMemo;
    Request: TRESTRequest;
    IdHTTP: TIdHTTP;
    Memo1: TMemo;
    StaticText1: TStaticText;
    Button2: TButton;
    Memo3: TMemo;
    Memo4: TMemo;
    StaticText2: TStaticText;
    RESTResponse1: TRESTResponse;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

//전송버튼 클릭 이벤트
procedure TForm2.Button1Click(Sender: TObject);
  var
  URL: String;
  Retorno: String;
  JsonStreamRetorno : TStringStream;
  JsonStreamEnvio : TStringStream;

  var
    JTopObj : TJSONObject;
    JObj : TJSONObject;
    JArr : TJSONArray;
    JPair : TJSONPair;
    i : integer;
    sTemp : String;



  begin
    //기존 결과값 초기화
    memo2.Text := '';
    // 고유번호 조회API주소
    URL := 'http://115.68.1.5:8084/homtax/getpkey';

    var JsonObj: TJSONObject;
    var JsonString: string;


    var homemunseo_id : String;
    homemunseo_id := Trim(Memo1.Text);

    //JTopObj객체를 선언한다.
    JTopObj := TJSONObject.Create;
    //JTopObj객체에 전송값을 하나씩 입력한다.
    JTopObj.AddPair(TJSONPair.Create('hometaxbill_id','cmj0633'));           //회사코드
    JTopObj.AddPair(TJSONPair.Create('spass','Mem12345'));                   //회사비밀번호
    JTopObj.AddPair(TJSONPair.Create('apikey','SSADFVSDFSDE'));              //인증키
    JTopObj.AddPair(TJSONPair.Create('homemunseo_id',homemunseo_id));        //고유번호

    sTemp := JTopObj.ToString;

    //한글로 인코딩하여 전송
    JsonStreamEnvio := TStringStream.Create(sTemp,TEncoding.UTF8);
    JsonStreamRetorno := TStringStream.Create('',TEncoding.UTF8);
    // Init request:
    try
        //결과를 받은 후 한글로 인코딩
        idHttp.Request.ContentType := 'application/json; charset=utf-8';
        idHttp.Request.ContentEncoding := 'utf-8';

        try
          //해당 url주소에 입력한 값을 전송 후 결과는 파라미터 JsonStreamRetorno에 저장
          idHttp.Post(URL, JsonStreamEnvio, JsonStreamRetorno);
        except
          on E:EIdHTTPProtocolException do
          //exception 오류시 memo2컬럼에 메세지 입력
          Memo2.Lines.Add(e.ErrorMessage);
        end;

    finally
      // 오류없이 성공하면 memo2컬럼에 결과값 그대로 입력
      //memo2.Lines.add(JsonStreamRetorno.DataString);

      //결과값을 key와 values값으로 나눠서 출력
      JsonString := JsonStreamRetorno.DataString;
      JsonObj := TJSONObject.ParseJSONValue(JsonString) as TJSONObject;

      memo2.Lines.Add(
                      'code :'+JsonObj.Get('code').JsonValue.Value +#13#10+                         //MSG CODE
                      'msg :'+JsonObj.Get('msg').JsonValue.Value +#13#10+                           //메세지
                      'hometaxbill_id :'+JsonObj.Get('hometaxbill_id').JsonValue.Value +#13#10+     //거래처CODE
                      'homemunseo_id :'+JsonObj.Get('homemunseo_id').JsonValue.Value +#13#10+       //거래처의 고유번호(중복일시 error발생함.이중발행방지)
                      'issueid :'+JsonObj.Get('issueid').JsonValue.Value +#13#10+                   //세금계산서 승인번호
                      'declarestatus :'+JsonObj.Get('declarestatus').JsonValue.Value +#13#10+       //현재 세금계산서발행상태 값을 RETURN합니다.
                      'msg2 :'+JsonObj.Get('msg2').JsonValue.Value                                  //국세청 결과 상세메세지입니다.
                      )

    end;
end;

procedure TForm2.Button2Click(Sender: TObject);
  var
  URL, Retorno: String;
  JsonStreamRetorno, JsonStreamEnvio: TStringStream;

  var
    JTopObj, JObj : TJSONObject;
    JArr : TJSONArray;
    JPair : TJSONPair;
    i : integer;
    sTemp : String;
begin
  JTopObj := TJSONObject.Create;
  JArr := TJSONArray.Create;

  //기존 결과값 초기화
  memo3.Text := '';
  // 고유번호 조회API주소
  URL := 'http://115.68.1.5:8084/homtax/post';

  var JsonObj: TJSONObject;
  var JsonString: string;

  var homemunseo_id : String;
  homemunseo_id := Trim(Memo4.Text);

  for i := 1 to 2 do
    begin
      JObj := TJSONObject.Create;
      JObj.AddPair(TJSONPair.Create('description', '품목별비고입력'));                                          //품목비고
      JObj.AddPair(TJSONPair.Create('supplyprice', '500000'));                                                  //품목 공급가액
      JObj.AddPair(TJSONPair.Create('quantity', '0.00'));                                                       //품목 수량
      JObj.AddPair(TJSONPair.Create('unit', ''));                                                               //품목 구격
      JObj.AddPair(TJSONPair.Create('subject', '품목명'));                                                      //품목 품목명
      JObj.AddPair(TJSONPair.Create('gyymmdd', '20210311'));                                                    //품목 공급년월일
      JObj.AddPair(TJSONPair.Create('tax', '50000'));                                                           //품목 세액
      JObj.AddPair(TJSONPair.Create('unitprice', '50000'));                                                     //품목 단가

      JArr.AddElement(JObj);
    end;
  JPair := TJSONPair.Create( 'taxdetailList', JArr );

  JTopObj.AddPair(TJSONPair.Create('hometaxbill_id', 'cmj0633'));                                              //회사코드
  JTopObj.AddPair(TJSONPair.Create('spass', 'Mem12345' ));                                                     //패스워드
  JTopObj.AddPair(TJSONPair.Create('apikey', 'SSADFVSDFSDE' ));                                                //인증키
  JTopObj.AddPair(TJSONPair.Create('homemunseo_id', homemunseo_id ));                                          //고유번호
  JTopObj.AddPair(TJSONPair.Create('typecode1', '01' ));                                                       //(세금)계산서 분류
  JTopObj.AddPair(TJSONPair.Create('typecode2', '01' ));                                                       //(세금)계산서 종류
  JTopObj.AddPair(TJSONPair.Create('description', '' ));                                                       //비교
  JTopObj.AddPair(TJSONPair.Create('issuedate', '20210819' ));                                                 //작성일자
  JTopObj.AddPair(TJSONPair.Create('modifytype', '' ));                                                        //수정코드
  JTopObj.AddPair(TJSONPair.Create('purposetype', '02' ));                                                     //영수/청구 구분
  JTopObj.AddPair(TJSONPair.Create('originalissueid', '' ));                                                   //당초승인번호
  JTopObj.AddPair(TJSONPair.Create('si_id', '' ));                                                             //수입신고번호
  JTopObj.AddPair(TJSONPair.Create('si_hcnt', '' ));                                                           //수입총건
  JTopObj.AddPair(TJSONPair.Create('si_startdt', '' ));                                                        //일괄발급시작일
  JTopObj.AddPair(TJSONPair.Create('si_enddt', '' ));                                                          //일괄발급종료일
  JTopObj.AddPair(TJSONPair.Create('ir_companynumber', '1358187511' ));                                        //공급자 사업자등록번호
  JTopObj.AddPair(TJSONPair.Create('ir_biztype', '서비스업,도소매' ));                                         //공급자 업태
  JTopObj.AddPair(TJSONPair.Create('ir_companyname', '(주)신안소프트' ));                                      //공급자 상호
  JTopObj.AddPair(TJSONPair.Create('ir_bizclassification', '소프트웨어개발업외하드웨어,쇼핑몰유통사업' ));     //공급자 업종
  JTopObj.AddPair(TJSONPair.Create('ir_taxnumber', '' ));                                                      //공급자 종사업자번호
  JTopObj.AddPair(TJSONPair.Create('ir_ceoname', '김순관' ));                                                  //공급자 대표자성명
  JTopObj.AddPair(TJSONPair.Create('ir_busename', '개발' ));                                                   //공급자 담당부서명
  JTopObj.AddPair(TJSONPair.Create('ir_name', '김기사' ));                                                     //공급자 담당자명
  JTopObj.AddPair(TJSONPair.Create('ir_cell', '010-1234-4321' ));                                              //공급자 담당자전화번호
  JTopObj.AddPair(TJSONPair.Create('ir_email', 'sinit@sinit.co.kr' ));                                         //공급자 담당자이메일
  JTopObj.AddPair(TJSONPair.Create('ir_companyaddress', '수원시 영통구 신원로 88(신동) 102동 713호 ' ));       //공급자 주소
  JTopObj.AddPair(TJSONPair.Create('ie_companynumber', '1358187511' ));                                        //공급받는자 사업자등록번호
  JTopObj.AddPair(TJSONPair.Create('ie_biztype', '서비스업,도소매' ));                                         //공급받는자 업태
  JTopObj.AddPair(TJSONPair.Create('ie_companyname', '(주)공급받는자 회사명' ));                               //공급받는자 상호
  JTopObj.AddPair(TJSONPair.Create('ie_bizclassification', '하드웨어,소핑몰유통사업' ));                       //공급받는자 업종
  JTopObj.AddPair(TJSONPair.Create('ie_taxnumber', '' ));                                                      //공급받는자 종사업장번호
  JTopObj.AddPair(TJSONPair.Create('partytypecode', '01' ));                                                   //공급받는자 구분
  JTopObj.AddPair(TJSONPair.Create('ie_ceoname', '김사랑' ));                                                  //공급받는자 대표자성명
  JTopObj.AddPair(TJSONPair.Create('ie_busename1', '개발' ));                                                  //공급받는자 담당부서명1
  JTopObj.AddPair(TJSONPair.Create('ie_name1', '김사랑' ));                                                    //공금받는자 담당자명1
  JTopObj.AddPair(TJSONPair.Create('ie_cell1', '010-9999-1234' ));                                             //공급받는자 담당자전화번호1
  JTopObj.AddPair(TJSONPair.Create('ie_email1', 'sinit@sinit.co.kr' ));                                        //공급받는자 담당자이메일1
  JTopObj.AddPair(TJSONPair.Create('ie_busename2', 'CS' ));                                                    //공급받는자 담당부서명2
  JTopObj.AddPair(TJSONPair.Create('ie_name2', '김시아' ));                                                    //공급받는자 담당자명2
  JTopObj.AddPair(TJSONPair.Create('ie_cell2', '010-2222-4444' ));                                             //공급받는자 담당자전화번호2
  JTopObj.AddPair(TJSONPair.Create('ie_email2', 'sinit1@sinit.co.kr' ));                                       //공급받는자 담당자이메일2
  JTopObj.AddPair(TJSONPair.Create('ie_companyaddress', '수원시 영통구 신원로 88(신동) 102동 713호' ));        //공급받는자 주소
  JTopObj.AddPair(TJSONPair.Create('su_companynumber', '' ));                                                  //수탁사업자 사업자등록번호
  JTopObj.AddPair(TJSONPair.Create('su_biztype', '' ));                                                        //수탁사업자 업태
  JTopObj.AddPair(TJSONPair.Create('su_companyname', '' ));                                                    //수탁사업자 상호
  JTopObj.AddPair(TJSONPair.Create('su_bizclassification', '' ));                                              //수탁사업자 업종
  JTopObj.AddPair(TJSONPair.Create('su_taxnumber', '' ));                                                      //수탁사업자 종사업장번호
  JTopObj.AddPair(TJSONPair.Create('su_ceoname', '' ));                                                        //수탁사업자 대표자성명
  JTopObj.AddPair(TJSONPair.Create('su_busename', '' ));                                                       //수탁사업자 담당부서명
  JTopObj.AddPair(TJSONPair.Create('su_name', '' ));                                                           //수탁사업자 담당자명
  JTopObj.AddPair(TJSONPair.Create('su_cell', '' ));                                                           //수탁사업자 담당자전화번호
  JTopObj.AddPair(TJSONPair.Create('su_email', '' ));                                                          //수탁사업자 담당자이메일
  JTopObj.AddPair(TJSONPair.Create('su_companyaddress', '' ));                                                 //수탁사업자 주소
  JTopObj.AddPair(TJSONPair.Create('cash', '1000000' ));                                                       //현급금액
  JTopObj.AddPair(TJSONPair.Create('scheck', '0' ));                                                           //수표금액
  JTopObj.AddPair(TJSONPair.Create('draft', '0' ));                                                            //어음금액
  JTopObj.AddPair(TJSONPair.Create('uncollected', '0' ));                                                      //외상미수금금액
  JTopObj.AddPair(TJSONPair.Create('chargetotal', '1000000' ));                                                //공급가액합계
  JTopObj.AddPair(TJSONPair.Create('taxtotal', '100000' ));                                                    //세액합계
  JTopObj.AddPair(TJSONPair.Create('grandtotal', '1100000' ));                                                 //총금액
  JTopObj.AddPair(JPair);

  sTemp := JTopObj.ToString;

  //한글로 인코딩하여 전송
  JsonStreamEnvio := TStringStream.Create(sTemp,TEncoding.UTF8);
  JsonStreamRetorno := TStringStream.Create('',TEncoding.UTF8);
  // Init request:
  try
      //결과를 받은 후 한글로 인코딩
      idHttp.Request.ContentType := 'application/json; charset=utf-8';
      idHttp.Request.ContentEncoding := 'utf-8';

    try
      //해당 url주소에 입력한 값을 전송 후 결과는 파라미터 JsonStreamRetorno에 저장
      idHttp.Post(URL, JsonStreamEnvio, JsonStreamRetorno);
    except
      on E:EIdHTTPProtocolException do
      //exception 오류시 memo2컬럼에 메세지 입력
      Memo3.Lines.Add(e.ErrorMessage);
    end;

  finally
    // 오류없이 성공하면 memo2컬럼에 결과값 그대로 입력
    //memo3.Lines.add(JsonStreamRetorno.DataString);

    //결과값을 key와 values값으로 나눠서 출력
    JsonString := JsonStreamRetorno.DataString;
    JsonObj := TJSONObject.ParseJSONValue(JsonString) as TJSONObject;

    memo3.Lines.Add(
                    'code :'+JsonObj.Get('code').JsonValue.Value +#13#10+                      //코드 "0"=정상접수, "-1"=접수실패
                    'msg :'+JsonObj.Get('msg').JsonValue.Value +#13#10+                        //접수에 대한 결과 메세지
                    'jsnumber :'+JsonObj.Get('jsnumber').JsonValue.Value +#13#10+              //홈택스빌 접수번호
                    'hometaxbill_id :'+JsonObj.Get('hometaxbill_id').JsonValue.Value +#13#10+  //거래처code
                    'homemunseo_id :'+JsonObj.Get('homemunseo_id').JsonValue.Value             //거래처의 고유번호 (중복시 error발생함 .이중발행 방지)
                    );
  end;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  //처음 실행시 메모컬럼들 모두 빈값으로,,
  memo1.Text := '';
  memo2.Text := '';
  memo3.Text := '';
  memo4.Text := '';
end;

end.

//            declarestatus = 세금계산서 발행상태 및 진행상황을  판단 하십시오 (API문서의 상태값입니다).
//             01 =	수기작성	사용회사정보 수동일 경우 전송하기 전 상태(전송 미처리시 국세청 전송불가)
//             10 =	전송대기	국세청 전송 대기 상태(10분 이내 자동전송 처리 예정)
//             03 =	국세청 전송처리중	국세청으로 세금계산서 데이터 전송처리 진행중인 상태
//             04 =	국세청 전송완료(결과수신대기) 국세청으로 세금계산서 데이터를 전송하고 결과 수신 대기인 상태
//             05 =	홈택스빌 처리중 Error	국세청 전송하기 전 작업처리중에 에러가 발생한 상태(재전송 처리예정)
//             06 =	국세청 전송중 Error	국세청 데이터 전송중 에러가 발생한 상태(재전송 처리예정)
//             08 =	발급완료	국세청으로부터 정상적으로 승인처리된 상태
//             09 =	발급실패	국세청으로부터 전자세금계산서 발급 승인이 나지 않는 상태
//             99 =	인증서 검증 Error	인증서 유효기간이 지나거나 폐기 처리된 인증서로 인증서에 문제가 발생한 상태
//
//             EX1)  declarestatus = '08' 라면 code 에는 실패이유 CODE가retrun되고 msg 에는 실패 사유를 RETURN합니다.
//             EX2)  declarestatus = '09' 라면 code 에는 성공한 CODE가 return되고 msg 에는 정상처리 return
