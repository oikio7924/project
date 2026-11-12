# rtu-web — 대양모니터링 RTU 통합관리

발전소별 RTU 세팅·장비·장애·라우터 정보를 관리하는 웹입니다.
예전에 쓰던 `D:\rtu\대양모니터링 RTU 통합관리.xlsx` 장부(시트 6개)를 여러 사람이 함께 쓰는 서버 웹으로 옮겼습니다.

- 주소: `http://<회사 도메인>/rtuweb/`
- 서버: `<운영 서버>`, `/var/www/rtu-web`, root pm2 이름 `rtu-web`, 포트 3003 (127.0.0.1에서만 받음), Apache `ProxyPass /rtuweb`
- 구성: Node 16+ · Express · mysql2 · express-session (ht-web·bd-web과 같은 방식)

## 데이터 기준

| 구분 | 테이블 | 비고 |
|---|---|---|
| 발전소 기본 정보 (이름·용량·주소·회원·개통 상태·인버터 수) | `monitering.dy_power_plant` | **원본.** 홈페이지·앱·RTU 수집이 같이 씀 |
| RTU 관리 정보 | `monitering.rtm_*` | rtu-web 전용, 구조는 [db/schema.sql](db/schema.sql) (모든 컬럼에 COMMENT) |
| 회원 목록 | `monitering.u_userinfo` | 읽기만 |

- 발전소 목록은 `dy_power_plant` 기준입니다. 엑셀에 없던 발전소도 보이고, 이름은 DB 이름을 씁니다.
- `rtm_plant`는 RTU 정보가 있는 발전소에만 있고, 처음 입력할 때 만들어집니다 (`dpp_keyno` 하나에 한 행).
- keyno와 RTU·라우터는 일대일이 아닙니다. `rtm_device_plant`, `rtm_router_plant`로 연결합니다 (공용: 윤서 4~7호·한빛 1·2·5호 / 한 keyno에 여러 대: 145 민정·영자·재두는 RTU·라우터가 각 3대).

## 화면

| 메뉴 | 내용 |
|---|---|
| 발전소장비 | 발전소별 사용 여부, 통신 방식, 원격 접속, 라우터, RTU S/N. 개통/미개통/예외 필터 |
| 　└ 모니터링 발전소 정보 탭 | `dy_power_plant` 수정 (홈페이지에 바로 반영) |
| 　└ 발전소 묶음 등록 | 모니터링 발전소 등록 + RTU 정보 + 세팅 작업 + 인버터 구성을 한 트랜잭션으로 |
| 　└ 인버터 구성 탭 | 그 발전소의 인버터 모델 줄 추가·수정·삭제 (목록에는 요약 칸) |
| 세팅출고 / 장비이력 / 작업장애 / 라우터관리 | 엑셀 시트와 같은 칸, 추가·수정·삭제. **최근 것이 맨 위**: 세팅출고는 등록 역순, 작업장애는 발생일 최신순, 장비이력은 설치일(없으면 제조일) 최신순(날짜 없는 행은 아래). 라우터관리는 라우터 ID 순 |
| 　└ 세팅 요청서 올리기 | 세팅 양식 엑셀을 읽어 기존 발전소에 세팅·인버터 추가, 또는 새 발전소로 모니터링 등록까지 ([lib/setupForm.js](lib/setupForm.js)) |
| 하드웨어 버전 | RTU S/N 앞부분, 버전별 마지막 사용 번호와 다음 S/N |
| 변경 이력 | 누가 언제 무엇을 바꿨는지 (`rtm_change_log`, 바뀌기 전·후 값) |
| 엑셀 내려받기 | 전체 시트를 xlsx로 |

## RTU S/N 규칙

형식은 `DR-연도-하드웨어 변경 차수-그 버전의 몇 번째 장비`입니다. 예를 들어 `DR-26-003-0004`는 26년 하드웨어 변경 3번째 버전의 4번째 장비입니다.

- 하드웨어 버전은 `rtm_hw_version`(화면 "하드웨어 버전")에서 관리합니다. 버전마다 **마지막 사용 번호(last_seq)**가 있습니다.
- 새 RTU의 S/N은 고른 버전의 `last_seq + 1`입니다. 이미 쓰인 번호면 건너뜁니다.
  S/N만 미리 적어 둔 빈 행이 있으면 새로 만들지 않고 그 행을 씁니다 (예: DR-26-010-0038~0053).
- 새 RTU는 세 곳에서 만들 수 있습니다: 장비이력 "새 행", 세팅출고 RTU 칸의 "＋ 새 RTU", 발전소 묶음 등록의 "새 RTU 만들기".
- 이미 다른 장비에 쓰인 S/N은 저장되지 않습니다. 단, 엑셀에서 넘어온 중복(DR-26-010-0007, 0008)은 그대로 두었습니다.
- 처음 값(2026-11-02): DR-26-010은 0037까지 사용했고 "지금 만드는 버전"입니다. 011은 아직 0대입니다.

## dy_power_plant 쓰기 규칙

홈페이지 발전소 등록(`dymonitering` AdminPowerController `Inverter_insert.do` / Power_SQL.xml `Pw_insert`)과 같은 결과를 냅니다.

- 저장하는 칸은 홈페이지와 같습니다: `DPP_NAME, DPP_VOLUM, DPP_USER, DPP_STATUS, DPP_IMG, DPP_X/Y_LOCATION, DPP_INVER, DPP_INVER_COUNT, DPP_AREA, DPP_LOCATION, DPP_SN, DPP_OTHER_VOLUM`
- `DPP_SN_NUM`은 홈페이지 `ChangeSN`을 그대로 옮긴 [lib/dpp.js](lib/dpp.js) `snToSnNum`으로 계산합니다. 실제 DB 값과 같은지 확인했습니다.
  홈페이지는 새로 등록할 때 keyno가 없어 이 값이 빠지지만, rtu-web은 keyno를 받은 뒤 계산하므로 처음부터 들어갑니다.
- 묶음 등록 때 인버터 구성에서 자동으로 채우는 값: `DPP_INVER`(제조사 소문자, 여러 개면 `/`), `DPP_INVER_COUNT`(총 대수), `DPP_OTHER_VOLUM`(인버터별 용량), `DPP_SN`(입력 없으면 대수만큼 `00`)
- 주소는 `우편번호//주소` 형식(다음 우편번호), 좌표는 카카오 지도로 찾습니다 (`KAKAO_JS_KEY` = 홈페이지 `DAUM_APPKEY`).
- RTU 수집 프로그램이 읽는 칸(`DPP_NAME`, `DPP_INVER_COUNT`, `DPP_VOLUM`)을 바꾸면 화면에서 경고합니다.
- 삭제는 하지 않습니다 (DB 계정에도 삭제 권한이 없음).

## DB 계정

전용 계정 `rtuweb@localhost`, 권한은 [db/grant.sql](db/grant.sql)에 있습니다.
`rtm_*` 읽기·쓰기, `dy_power_plant` 읽기·추가·수정, `u_userinfo` 읽기만 됩니다.

## 파일

```
server.js               API·로그인·트랜잭션
lib/sheets.js           시트·칸 정의 (서버 검사와 화면에 같이 사용)
lib/dpp.js              dy_power_plant 규칙 (ChangeSN 이식)
lib/match.js            발전소 이름 짝짓기 (장부·요청서 글자 → keyno)
lib/setupForm.js        다르고스 세팅 요청서 엑셀 읽기
public/                 화면 (index.html, login.html, js/app.js, css/app.css)
db/schema.sql           rtm_* 테이블 (IF NOT EXISTS, 기존 테이블은 건드리지 않음)
db/grant.sql            전용 DB 계정
scripts/import-source.js 원본 장부 → rtm_* 1회 이관 (match: 발전소 연결 확인표 만들기 → preview → apply)
scripts/create-user.js  로그인 계정 만들기·비밀번호 재설정·목록
deploy/rtuweb.conf      Apache 설정
deploy/update.sh        업데이트 스크립트 (백업 → 풀기 → npm install → 재시작 → 확인)
docs/배포 방법.md        첫 설치·업데이트·계정 관리 안내
```

서버가 시작할 때 테이블이 없으면 만들지 않고 멈춥니다. 운영 DB라서 `db/schema.sql`은 사람이 확인한 뒤 직접 실행합니다.
