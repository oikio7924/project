'use strict';

async function callOdcloud(path, body) {
  const serviceKey = process.env.BUSINESS_API_KEY;
  if (!serviceKey) throw new Error('BUSINESS_API_KEY가 설정되지 않았습니다.');

  const url = `https://api.odcloud.kr/api/nts-businessman/v1/${path}?serviceKey=${encodeURIComponent(serviceKey)}`;
  const res = await fetch(url, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(body)
  });
  const data = await res.json();
  return { status: res.status, body: data };
}

// 사업자등록 상태조회: 번호만으로 실존 여부 및 계속/휴업/폐업 상태 확인
async function checkStatus(businessNumber) {
  const bNo = String(businessNumber || '').replace(/\D/g, '');
  if (bNo.length !== 10) {
    return { ok: false, message: '사업자등록번호 10자리를 정확히 입력해주세요.' };
  }

  const result = await callOdcloud('status', { b_no: [bNo] });
  if (result.status !== 200) {
    return { ok: false, message: '국세청 조회에 실패했습니다. 잠시 후 다시 시도해주세요.' };
  }
  const item = result.body.data && result.body.data[0];
  if (!item || !item.b_stt_cd) {
    return { ok: true, found: false, message: '등록된 정보를 찾을 수 없습니다.' };
  }
  return {
    ok: true,
    found: true,
    status_code: item.b_stt_cd,
    status: item.b_stt,
    tax_type: item.tax_type,
    end_dt: item.end_dt || null
  };
}

// 사업자등록정보 진위확인: 사업자번호+개업일자+대표자성명 일치 여부 확인
async function validateBusiness({ business_number, open_date, ceo_name }) {
  const bNo = String(business_number || '').replace(/\D/g, '');
  const startDt = String(open_date || '').replace(/\D/g, '');
  const pNm = String(ceo_name || '').trim();

  if (bNo.length !== 10) return { ok: false, valid: false, message: '사업자등록번호 10자리를 정확히 입력해주세요.' };
  if (startDt.length !== 8) return { ok: false, valid: false, message: '개업일자를 정확히 입력해주세요.' };
  if (!pNm) return { ok: false, valid: false, message: '대표자성명을 입력해주세요.' };

  const result = await callOdcloud('validate', {
    businesses: [{ b_no: bNo, start_dt: startDt, p_nm: pNm, p_nm2: '' }]
  });
  if (result.status !== 200) {
    return { ok: false, valid: false, message: '국세청 조회에 실패했습니다. 잠시 후 다시 시도해주세요.' };
  }
  const item = result.body.data && result.body.data[0];
  if (!item || item.valid !== '01') {
    return { ok: true, valid: false, message: '입력하신 사업자등록번호·개업일자·대표자성명이 국세청 정보와 일치하지 않습니다.' };
  }
  return {
    ok: true,
    valid: true,
    status: item.status?.b_stt,
    status_code: item.status?.b_stt_cd,
    tax_type: item.status?.tax_type
  };
}

module.exports = { checkStatus, validateBusiness };
