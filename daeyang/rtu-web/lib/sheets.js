// 화면 시트 정의 (서버 입력 검사와 화면 표시에 같이 쓴다)
// type: text(기본) | date | number | select | textarea | plant(발전소 선택) | device | router
// join: 서버가 JOIN으로 채워주는 읽기 전용 칸 (저장하지 않음)

const PLANT_STATUS = { Y: '개통', N: '미개통', E: '예외' };

const SHEETS = [
  {
    key: 'plant', name: '발전소장비', table: 'rtm_plant', idField: 'plant_id', prefix: 'P',
    note: '발전소 목록은 모니터링 홈페이지 발전소(dy_power_plant) 기준입니다. 이름·용량·주소는 홈페이지 정보이고, 나머지는 RTU 관리 정보입니다.',
    columns: [
      { f: 'keyno', label: '발전소 번호', join: true },
      { f: 'DPP_NAME', label: '발전소명', join: true },
      { f: 'DPP_STATUS', label: '개통', join: true, map: PLANT_STATUS },
      { f: 'DPP_VOLUM', label: '용량 (kW)', join: true },
      { f: 'DPP_INVER', label: '인버터', join: true },
      { f: 'DPP_INVER_COUNT', label: '대수', join: true },
      { f: 'inv_summary', label: '인버터 구성', join: true, hidden: true }, // 목록에는 없고 발전소 창 "인버터 구성" 탭에서 본다. 검색은 된다.
      { f: 'owner_id', label: '회원', join: true },
      { f: 'plant_id', label: '발전소 ID', join: true },
      { f: 'use_yn', label: '사용 여부', type: 'select', opts: ['사용', '미사용'], hidden: true }, // 표에는 없고 "미사용" 필터로 봄
      { f: 'comm_type', label: '통신 방식', type: 'select', opts: ['', '무선', '유선'] },
      { f: 'device_sns', label: 'RTU S/N', join: true },
      // 원격 접속은 목록에 없고 발전소 창(RTU 관리 정보)에서 본다. 검색은 된다.
      { f: 'remote_method', label: '원격 접속 방식', type: 'select', opts: ['', 'tailscale', 'Dataplicity', 'Anydesk', '미사용'], hidden: true },
      { f: 'remote_address', label: '원격 접속 주소', hidden: true },
      { f: 'router_ctn', label: '라우터 CTN', join: true },
      { f: 'jubok_keyno', label: '주복 발전소 번호', onlyFilter: 'jubok' }, // 목록에서는 "주복건설" 필터일 때만 보임
      { f: 'remote_note', label: '원격 비고', type: 'textarea' },
      { f: 'plant_note', label: '발전소 비고', type: 'textarea' },
      { f: 'legacy_inv_count', label: '인버터 수량 (기존)', hidden: true },
      { f: 'legacy_inv_type', label: '인버터 종류 (기존)', hidden: true },
      { f: 'legacy_protocol', label: '프로토콜 (기존)', hidden: true },
      { f: 'legacy_access_id', label: '기존 접속 ID', hidden: true },
    ],
  },
  {
    key: 'setup', name: '세팅출고', table: 'rtm_setup', idField: 'setup_id', prefix: 'S',
    note: 'RTU를 새로 세팅하거나 교체할 때 한 건씩 기록합니다. 예: "해모아 1호 신규, 5/15 오전까지, 담당 김경훈".',
    columns: [
      { f: 'setup_id', label: '작업 ID', readonly: true },
      { f: 'plant_id', label: '발전소', type: 'plant', required: true },
      { f: 'plant_name', label: '발전소명', join: true, formHidden: true },
      // req_name: 원본 장부에 적힌 이름 원문 — DB에만 둔다 (화면에는 DB 발전소 이름을 씀)
      { f: 'kind', label: '신규·교체', type: 'select', opts: ['', '신규', '교체'] },
      { f: 'due_date', label: '세팅 기한', type: 'date' },
      { f: 'due_time', label: '오전·오후' },
      { f: 'owner', label: '담당자' },
      { f: 'status', label: '진행 상태', type: 'select', opts: ['', '세팅 중', '시험 중', '출고', '설치 완료', '취소'] },
      { f: 'device_id', label: 'RTU', type: 'device', allowNew: true },
      { f: 'sw_version', label: '설치 SW 버전' },
      // 시험 완료일(tested_at)·정상 수집 확인일(collect_ok_at)·다음 확인(next_check)은 화면에서 뺌 (DB 칸과 값은 남겨 둠)
      { f: 'shipped_at', label: '출고일', type: 'date' },
      { f: 'installed_at', label: '설치일', type: 'date' },
      { f: 'req_capacity', label: '요청 용량 (kW)', hidden: true },
      { f: 'req_comm', label: '요청 유/무선', type: 'select', opts: ['', '무선', '유선'], hidden: true },
      { f: 'req_address', label: '요청 주소', hidden: true },
      // 원본파일명(src_file)·원본시트명(src_sheet)은 DB에만 둔다 (요청서 중복 등록 확인용, 화면에는 없음)
    ],
  },
  {
    // 왼쪽 메뉴에는 없고, 발전소 창의 "인버터 구성" 탭에서 본다 (엑셀 내려받기에는 시트로 나감)
    key: 'inverter', name: '인버터구성', table: 'rtm_inverter', idField: 'inv_id', prefix: 'I', hideNav: true,
    note: '발전소에 들어가는 인버터를 한 대에 한 줄씩 적습니다. 모델을 몰라도 slave만 알면 그것만 적어도 됩니다. 예: "goodwe GW60KBF-MT, slave 3, 인버터 1호".',
    columns: [
      { f: 'inv_id', label: '구성 ID', readonly: true },
      { f: 'plant_id', label: '발전소', type: 'plant', required: true },
      { f: 'plant_name', label: '발전소명', join: true, formHidden: true },
      { f: 'setup_id', label: '세팅 작업', type: 'setup', help: '고른 발전소의 세팅출고 기록 중에서 고릅니다. 상관없으면 (없음)' },
      { f: 'maker', label: '제조사' },
      { f: 'model', label: '모델' },
      { f: 'inv_sn', label: '인버터 S/N', help: '여러 대를 한 줄에 적었으면 쉼표로 (예: 7060KMTB216W0385, 7060KMTB216W0445)' },
      { f: 'unit_kw', label: '용량 (kW)', type: 'number' },
      { f: 'qty', label: '수량', type: 'number', hidden: true, formHidden: true }, // 한 줄 = 인버터 한 대 (항상 1, 서버가 채움)
      { f: 'device_id', label: 'RTU', type: 'device' },
      { f: 'port', label: '단자' },
      { f: 'slave_id', label: 'slave_id' },
      { f: 'inv_name', label: '인버터명' },
      { f: 'check_note', label: '설정 점검' },
      { f: 'note', label: '비고', type: 'textarea' },
    ],
  },
  {
    key: 'device', name: '장비이력', table: 'rtm_device', idField: 'device_id', prefix: 'D',
    note: 'RTU 실물 한 대가 한 줄입니다. 공용 RTU(한 대로 여러 발전소)나 한 발전소에 여러 대인 경우는 "연결 발전소"에 모두 적습니다.',
    columns: [
      { f: 'device_id', label: '기록 ID', readonly: true },
      { f: 'device_type', label: '장비 구분' },
      { f: 'serial_no', label: 'S/N', type: 'serial' },
      { f: 'linked_plants', label: '연결 발전소', type: 'plants' },
      { f: 'hw_version', label: 'HW 버전·모뎀명' },
      { f: 'board_type', label: '보드', type: 'select', opts: ['', 'Zero2', 'Zero3'] },
      { f: 'sw_version', label: 'SW 버전', help: 'SW 버전 메뉴의 번호 (예: 12 = sw_v12)' },
      { f: 'made_date', label: '제조일', type: 'date' },
      { f: 'install_date', label: '설치일', type: 'date' },
      { f: 'status', label: '장비 상태', type: 'select', opts: ['', '사용중', '회수', '폐기', '미사용'] },
      { f: 'ctn', label: 'LTE·CTN' },
      { f: 'imei', label: 'IMEI', hidden: true },
      { f: 'usim_model', label: '유심 모델', hidden: true },
      { f: 'usim_no', label: '유심 번호', hidden: true },
      { f: 'lte_ip', label: 'LTE IP', hidden: true },
      // legacy_site: 원본 장부에 적힌 이름 원문 — DB에만 둔다 (화면에는 DB 발전소 이름을 씀)
      { f: 'note', label: '비고', type: 'textarea' },
    ],
  },
  {
    key: 'issue', name: '작업장애', table: 'rtm_issue', idField: 'issue_id', prefix: 'H',
    note: '현장 장애와 조치 내용을 기록합니다. 예: "2026-01-13 기기 멈춤 → 오렌지파이 재부팅".',
    columns: [
      { f: 'issue_id', label: '이력 ID', readonly: true },
      { f: 'occurred_at', label: '발생일', type: 'date' },
      { f: 'plant_id', label: '발전소', type: 'plant' },
      { f: 'plant_name', label: '발전소명', join: true, formHidden: true },
      // plant_text: 원본 장부에 적힌 이름 원문 — DB에만 둔다 (화면에는 DB 발전소 이름을 씀)
      { f: 'inverter', label: '인버터' },
      { f: 'symptom', label: '증상·작업 내용', type: 'textarea' },
      { f: 'action_taken', label: '조치 내용', type: 'textarea' },
      { f: 'status', label: '처리 상태', type: 'select', opts: ['', '처리 중', '완료'] },
      { f: 'owner', label: '담당자' },
      { f: 'checked_at', label: '확인일', type: 'date' },
      { f: 'sn_before', label: '교체 전 S/N' },
      { f: 'sn_after', label: '교체 후 S/N' },
      { f: 'note', label: '비고', type: 'textarea' },
    ],
  },
  {
    key: 'router', name: '라우터관리', table: 'rtm_router', idField: 'router_id', prefix: 'L',
    note: 'LTE 라우터와 회선(CTN)을 관리합니다. 공용 라우터는 쓰는 발전소를 모두 연결하고, 한 발전소에 라우터가 여러 대면(예: 민정·영자·재두) 각 라우터에 그 발전소를 연결합니다. 설치처를 모르는 라우터는 비워 둡니다.',
    columns: [
      { f: 'router_id', label: '라우터 ID', readonly: true },
      { f: 'plant_name', label: '사용 발전소 (DB 이름)', join: true, formHidden: true },
      { f: 'linked_plants', label: '연결 발전소', type: 'plants', hidden: true },
      { f: 'modem', label: '모뎀명' },
      { f: 'serial_no', label: '일련번호' },
      { f: 'ctn', label: 'CTN 번호' },
      { f: 'lte_ip', label: 'LTE IP' },
      { f: 'status', label: '사용 상태', type: 'select', opts: ['', '확인', '해지', '재고', '사용 중 (설치처 미확인)'] },
      { f: 'installed_at', label: '설치일', type: 'date' },
      { f: 'removed_at', label: '회수일', type: 'date' },
      { f: 'imei', label: 'IMEI', hidden: true },
      { f: 'usim_model', label: '유심 모델', hidden: true },
      { f: 'usim_no', label: '유심 번호', hidden: true },
      // legacy_site: 원본 장부에 적힌 이름 원문 — DB에만 둔다 (화면에는 DB 발전소 이름을 씀)
      { f: 'note', label: '비고', type: 'textarea' },
    ],
  },
  {
    key: 'swver', name: 'SW 버전', table: 'rtm_sw_version', idField: 'code', manualId: true,
    note: 'RTU에 설치하는 소프트웨어 버전입니다. 장비이력의 "SW 버전" 칸 숫자가 이 표의 번호입니다 (예: 12 = sw_v12, v7.1_261021.img).',
    columns: [
      { f: 'code', label: '코드', required: true, createOnly: true, placeholder: 'sw_v13' },
      { f: 'title', label: '내용' },
      { f: 'detail', label: '상세', type: 'textarea' },
    ],
  },
  {
    key: 'hwver', name: '하드웨어 버전', table: 'rtm_hw_version', idField: 'prefix', manualId: true,
    note: 'RTU S/N 앞부분입니다. 형식은 DR-연도-하드웨어 변경 차수-그 버전의 몇 번째 장비 (예: DR-26-003-0004 = 26년 하드웨어 변경 3번째 버전의 4번째 장비). 보드를 바꾸면 새 버전을 추가하고 "지금 만드는 버전"으로 지정하세요.',
    columns: [
      { f: 'prefix', label: 'S/N 앞부분', required: true, createOnly: true, placeholder: 'DR-26-012' },
      { f: 'title', label: '내용' },
      { f: 'detail', label: '상세 (바뀐 점)', type: 'textarea' },
      { f: 'is_current', label: '지금 만드는 버전', type: 'select', opts: ['0', '1'], map: { 0: '아니오', 1: '● 기본' } },
      { f: 'last_seq', label: '마지막 사용 번호', type: 'number', help: '이 버전에서 마지막으로 쓴 장비 번호. 다음 새 RTU는 이 번호 + 1' },
      { f: 'device_count', label: '사용한 장비 수', join: true },
      { f: 'next_serial', label: '다음 S/N', join: true },
    ],
  },
];

const byKey = Object.fromEntries(SHEETS.map(s => [s.key, s]));

// 저장 가능한 칸 (JOIN·읽기 전용·가상 칸 제외)
function editableFields(sheet) {
  return sheet.columns.filter(c => !c.join && !c.readonly && c.type !== 'plants').map(c => c.f);
}

module.exports = { SHEETS, byKey, editableFields, PLANT_STATUS };
