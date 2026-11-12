// 발전소 이름 짝짓기: 장부·요청서에 글자로 적힌 이름 → dy_power_plant keyno
// (scripts/import-source.js 와 세팅 요청서 올리기에서 같이 쓴다)

function norm(s) {
  return String(s || '').toLowerCase()
    .replace(/호기/g, '호')
    .replace(/\(유\)|\(주\)|주식회사|유한회사|자가소비형|태양광|발전소/g, '')
    .replace(/[\s·.]/g, '');
}

// "윤서4,5,6,7호" → 윤서4호…윤서7호, "오남매2~3호" → 오남매2호·3호, "봉황,동석" → 봉황·동석,
// "한빛1,2호/5호" → 한빛1호·2호·5호 (앞 이름 이어받기)
function expand(n) {
  if (n.includes('/')) {
    const out = [];
    let base = '';
    for (const part of n.split('/').filter(Boolean)) {
      const p = /^\d/.test(part) && base ? base + part : part;
      const b = /^(\D+)/.exec(p);
      if (b) base = b[1];
      out.push(...expand(p));
    }
    return out;
  }
  const m = /^(\D*?)(\d+호?(?:[,~]\d+호?)+)(\D*)$/.exec(n);
  if (m) {
    const base = m[1];
    const nums = [];
    for (const part of m[2].split(',')) {
      const r = /^(\d+)호?~(\d+)호?$/.exec(part);
      if (r) for (let k = Number(r[1]); k <= Number(r[2]); k++) nums.push(k);
      else nums.push(Number(part.replace('호', '')));
    }
    return nums.map(k => `${base}${k}호${m[3]}`);
  }
  if (n.includes(',')) return n.split(',').filter(Boolean);
  return [n];
}

const NONE_RE = /^(미사용|해지완료|해지|미확인\s*\d*|재고)$/;

// dpp: [{ DPP_KEYNO, DPP_NAME }], extra: [{ name, keyno }] (다른 장부의 이름 표기)
function buildIndex(dpp, extra = []) {
  const idx = new Map();
  idx.whole = new Map();
  const put = (map, k, keyno) => { if (!map.has(k)) map.set(k, new Set()); map.get(k).add(keyno); };
  const add = (name, keyno) => {
    const n = norm(name);
    if (!n) return;
    put(idx.whole, n, keyno);
    for (const k of new Set([n, ...expand(n)])) put(idx, k, keyno);
  };
  for (const p of dpp) add(p.DPP_NAME, p.DPP_KEYNO);
  for (const e of extra) add(e.name, e.keyno);
  return idx;
}

// 결과 verdict: 일치 / 추정(이름 일부) / 후보 여러 개 / 못 찾음 / 연결 안 함
function matchName(idx, raw) {
  if (!raw) return { verdict: '연결 안 함', keynos: [], why: '빈칸' };
  if (NONE_RE.test(raw.trim())) return { verdict: '연결 안 함', keynos: [], why: `"${raw}"는 발전소가 아님` };
  const n = norm(raw);
  if (idx.whole.has(n) && idx.whole.get(n).size === 1) return { verdict: '일치', keynos: [...idx.whole.get(n)] };
  if (idx.has(n) && idx.get(n).size === 1) return { verdict: '일치', keynos: [...idx.get(n)] };
  const parts = expand(n);
  const out = [];
  const amb = [];
  for (const p of parts) {
    const hit = idx.whole.get(p) && idx.whole.get(p).size === 1 ? idx.whole.get(p) : idx.get(p);
    if (hit && hit.size === 1) { out.push(...hit); continue; }
    if (hit && hit.size > 1) { amb.push(`${p}: 후보 ${[...hit].join('/')}`); continue; }
    // 앞부분 일치 후보
    const cand = new Set();
    for (const [k, set] of idx) if (p.length >= 2 && (k.startsWith(p) || p.startsWith(k)) && k.length >= 2) set.forEach(x => cand.add(x));
    if (cand.size === 1) { out.push(...cand); amb.push(`${p}: 이름 일부로 추정`); continue; }
    amb.push(cand.size ? `${p}: 후보 ${[...cand].slice(0, 6).join('/')}` : `${p}: 못 찾음`);
  }
  const keynos = [...new Set(out)];
  if (!amb.length) return { verdict: '일치', keynos };
  if (amb.every(a => a.endsWith('이름 일부로 추정'))) return { verdict: '추정', keynos, why: amb.join(', ') };
  return { verdict: amb.some(a => a.includes('후보')) ? '후보 여러 개' : '못 찾음', keynos, why: amb.join(', ') };
}

module.exports = { norm, expand, NONE_RE, buildIndex, matchName };
