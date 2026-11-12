// dy_power_plant(모니터링 홈페이지 발전소) 관련 규칙
// 홈페이지 등록 로직과 같은 결과를 내야 한다:
//   dymonitering AdminPowerController.IveterInsert / ChangeSN, Power_SQL.xml Pw_insert / Pw_update

// 홈페이지 발전소 화면에서 저장하는 칸 (Pw_insert / Pw_update 와 같은 목록)
const DPP_FIELDS = [
  'DPP_NAME', 'DPP_VOLUM', 'DPP_USER', 'DPP_STATUS', 'DPP_IMG',
  'DPP_X_LOCATION', 'DPP_Y_LOCATION', 'DPP_INVER', 'DPP_INVER_COUNT',
  'DPP_AREA', 'DPP_LOCATION', 'DPP_SN', 'DPP_OTHER_VOLUM',
];

// RTU 수집 프로그램(main.py)이 읽는 칸: 바꾸면 현장 수집에 바로 영향
const RTU_READ_FIELDS = ['DPP_NAME', 'DPP_INVER_COUNT', 'DPP_VOLUM'];

// ChangeSN 이식: S/N 목록(쉼표 구분) → DPP_SN_NUM
// Java 원본은 문자 코드의 16진 문자열을 10진수로 parseInt 하므로, 그 값이 숫자로만
// 이뤄지지 않으면(예: 'J' = 0x4a) 예외로 중단된다. 같은 경우 null 을 돌려준다.
function snToSnNum(snCsv) {
  if (snCsv == null) return null;
  const list = String(snCsv).split(',');
  const firstNum = 151;
  const out = [];
  for (let j = 0; j < list.length; j++) {
    const l = list[j];
    let temp = '';
    let num = 0;
    for (let i = 0; i < l.length; i++) {
      const hex = l.charCodeAt(i).toString(16);
      temp += hex;
      if (i < 4 || (7 < i && i < 11) || (11 < i && i < 16)) {
        if (!/^\d+$/.test(hex)) return null;
        num += parseInt(hex, 10);
      }
    }
    // Java Integer.toHexString: 음수는 32비트 2의 보수
    const tail = ((num + (j + 1) - firstNum) >>> 0).toString(16);
    out.push('AA55807F000111' + temp + '0' + (j + 1) + '05' + tail);
  }
  return out.join(',');
}

// 인버터 구성(모델별 대당 용량·수량)으로 홈페이지 칸 값을 만든다
//   DPP_INVER: 대표 제조사(소문자, 여러 개면 '/'), DPP_INVER_COUNT: 총 대수,
//   DPP_OTHER_VOLUM: 인버터별 용량 쉼표 목록, DPP_SN: S/N 미입력이면 대수만큼 '00'
function fromInverters(items, snList) {
  const makers = [];
  const vols = [];
  for (const it of items) {
    const maker = String(it.maker || '').trim().toLowerCase();
    if (maker && !makers.includes(maker)) makers.push(maker);
    const qty = Number(it.qty) || 0;
    for (let k = 0; k < qty; k++) vols.push(it.unit_kw == null || it.unit_kw === '' ? '' : String(it.unit_kw));
  }
  const count = vols.length;
  const sns = [];
  for (let k = 0; k < count; k++) {
    const v = snList && snList[k] != null ? String(snList[k]).trim() : '';
    sns.push(v || '00');
  }
  return {
    DPP_INVER: makers.join('/'),
    DPP_INVER_COUNT: count,
    DPP_OTHER_VOLUM: vols.join(','),
    DPP_SN: sns.join(','),
  };
}

module.exports = { DPP_FIELDS, RTU_READ_FIELDS, snToSnNum, fromInverters };
