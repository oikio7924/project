// ─── 발전소 ↔ NAS 발전소 폴더 추천 ─────────────────────────────────────────────
// NAS 발전소 폴더 이름에는 보통 주소·발전소명·사업자명이 들어 있음
//   예) "DL-25.04 OO시 OO구 OO동 123-4 (햇살6호 태양광발전소 - 홍길동)"
// bd-web에 등록된 발전소명·주소·사업자명과 비교해 점수를 매김
//   발전소명 일치 +3 / 주소(동·리+번지) 일치 +3 (동·리만 같으면 +1) / 사업자명 포함 +1
//   3점 이상만 후보

const norm = s => String(s || '').normalize('NFC').replace(/\s+/g, '');

// 발전소명 핵심: "햇살6호 태양광발전소" → "햇살6호", "(유)푸른3호" → "푸른3호"
function coreName(s) {
  return norm(s)
    .replace(/\((유|주|C|c)\)|㈜|주식회사|유한회사/g, '')
    .replace(/(태양광)?(발전소|발전)$/, '')
    .replace(/태양광$/, '');
}

// 주소에서 "동·리 + 번지": "OO시 OO면 새말리 12-3 외 5필지" → { area:'새말리', lot:'12-3' }
function addrKey(a) {
  const m = String(a || '').normalize('NFC').match(/([가-힣0-9]+(?:동|리|가))\s*(?:산\s*)?(\d+(?:-\d+)?)/);
  return m ? { area: m[1], lot: m[2] } : null;
}

// 폴더 이름 안의 "1~4호" 범위를 펼침 ("햇살1~4호" → 햇살1호|햇살2호|…)
//   "햇살1,2호", "푸른1·2호" 도 펼침, "바람 태양광발전소2호" 처럼 중간의 "태양광발전소"를 뺀 이름도 붙임
function expandRanges(s) {
  const t = norm(s);
  const out = [t, t.replace(/태양광발전소|태양광|발전소/g, '')];
  out[1].replace(/([가-힣A-Za-z]+)(\d+(?:[,~·]\d+)+)호/g, (_, base, nums) => {
    for (const part of nums.split(/[,·]/)) {
      const [a, b] = part.split('~').map(Number);
      for (let i = a; i <= (b || a) && i - a < 30; i++) out.push(`${base}${i}호`);
    }
  });
  return out.join('|');
}

// 발전소명이 폴더 이름에 들어 있는지 (지명은 제외: "동산" 발전소 ↔ "동산리")
function hasName(ex, c) {
  for (let i = ex.indexOf(c); i >= 0; i = ex.indexOf(c, i + 1)) {
    if (!/[리동면읍군시]/.test(ex[i + c.length] || '')) return true;
  }
  return false;
}

// projects: [{ name, path }] (발전소 폴더 목록) → 매칭용으로 한 번만 가공
function prepareProjects(projects) {
  return projects.map(f => ({ name: f.name, path: f.path, n: norm(f.name), ex: expandRanges(f.name) }));
}

// 발전소 1곳의 후보 폴더 (점수 높은 순)
function suggest(plant, prepared, limit = 5) {
  const c = coreName(plant.plant_name);
  const ak = addrKey(plant.address);
  const lotRe = ak ? new RegExp(`(^|[^0-9-])${ak.lot.replace('-', '\\-')}($|[^0-9])`) : null;
  // 같은 본번의 다른 필지 (예: 발전소 246-52, 폴더 "246-34일대") → 한 현장으로 묶인 인근 필지
  const mainRe = ak && ak.lot.includes('-') ? new RegExp(`(^|[^0-9-])${ak.lot.split('-')[0]}-\\d+`) : null;
  const owners = String(plant.owner_name || '').split(/[,·\s]+/).map(coreName)
    .filter(x => x.length >= 2);

  const cands = [];
  for (const f of prepared) {
    let score = 0;
    const why = [];
    if (c.length >= 2 && hasName(f.ex, c)) { score += 3; why.push('발전소명'); }
    if (ak && f.n.includes(ak.area) && lotRe.test(f.name)) { score += 3; why.push('주소'); }
    else if (ak && mainRe && f.n.includes(ak.area) && mainRe.test(f.name)) { score += 2; why.push('인근 번지'); }
    else if (ak && f.n.includes(ak.area)) { score += 1; why.push('동·리'); }
    if (owners.some(o => f.n.includes(o))) { score += 1; why.push('사업자'); }
    if (score >= 3 || why.includes('인근 번지')) cands.push({ path: f.path, name: f.name, score, why });
  }
  cands.sort((a, b) => b.score - a.score || b.path.localeCompare(a.path, 'ko'));   // 같은 점수면 최근 연도 먼저

  const top = cands[0];
  const tie = top ? cands.filter(x => x.score === top.score).length : 0;
  let level;
  if (!top) level = 'none';                         // 못 찾음
  else if (tie > 1) level = 'multi';                // 후보 여러 개
  else if (top.score >= 4) level = 'sure';          // 확실 (발전소명+주소 등 두 가지 이상 일치)
  else level = 'likely';                            // 유력 (한 가지만 일치)
  return { level, cands: cands.slice(0, limit) };
}

// 여러 호기가 한 현장 폴더를 쓰는 경우 "0. 공통서류" 안에 호기별 폴더가 있음
//   예) 0. 공통서류/(유)햇살일호 - 홍길동, 0. 공통서류/푸른2호 - 김철수, 0. 공통서류/푸른 - 김철수(=푸른1호)
// 폴더 이름의 발전소명 부분(" - 사업자" 앞)이 이 발전소와 정확히 같으면 그 폴더를 고름
function pickPlantSubfolder(plant, subfolders) {
  const c = coreName(plant.plant_name);
  if (c.length < 2) return null;
  const c1 = c.replace(/1호$/, '');                       // "푸른1호" → "푸른"
  const visible = subfolders.filter(f => !f.name.startsWith('.'));
  // 하위 폴더가 1개뿐이면 호기별로 나눈 게 아니라 주제별 폴더(예: "OO파워 - 한전시설부담금")라서 안 들어감
  if (visible.length < 2) return null;
  // "발전소명 - 사업자" 모양이면 뒤쪽이 사람 이름일 때만 호기별 폴더로 봄
  //   O "(유)햇살일호 - 홍길동", "푸른2호 - 김철수"  /  X "OO산업 태양광발전소 - 비가림막 설치안"
  const PERSON = /^[가-힣]{2,4}(\s*[,·]\s*[가-힣]{2,4})*$/;
  const cands = [];
  for (const f of visible) {
    const [left, ...rest] = f.name.split(/\s+-\s+/);
    if (rest.length && !PERSON.test(rest.join(' - ').trim())) continue;
    cands.push({ f, k: coreName(left) });
  }
  const exact = cands.filter(x => x.k === c);
  if (exact.length === 1) return exact[0].f;
  if (!exact.length && c1 !== c) {
    const base = cands.filter(x => x.k === c1);
    if (base.length === 1) return base[0].f;
  }
  if (exact.length) return null;

  // 여러 호기를 묶은 폴더: 이름에 든 발전소 목록을 펼쳐서 이 발전소가 들어 있으면 그 폴더
  //   예) "2.햇살1~7" → 햇살1…7, "1.푸른1,2호" → 푸른1호·2호, "4.가람·나래·다솜" → 가람·나래·다솜
  const key = c.replace(/호$/, '');
  const groups = cands.map(x => x.f).filter(f => {
    const ks = groupKeys(f.name);
    return ks.length >= 2 && ks.includes(key);            // 발전소 2곳 이상 묶인 폴더만
  });
  return groups.length === 1 ? groups[0] : null;
}

// 묶음 폴더 이름 → 발전소 이름 목록 (끝의 "호"는 떼고 비교)
function groupKeys(name) {
  let s = norm(String(name).split(/\s+-\s+/)[0]).replace(/\[[^\]]*\]/g, '').replace(/^\d+\./, '');
  const keys = [];
  // "햇살1~7", "바람HP 1~7", "푸른1,2호", "누리1~4호"
  s = s.replace(/([가-힣A-Za-z]+)(\d+(?:[,~·]\d+)+)호?/g, (_, base, nums) => {
    for (const part of nums.split(/[,·]/)) {
      const [a, b] = part.split('~').map(Number);
      for (let i = a; i <= (b || a) && i - a < 30; i++) keys.push(`${base}${i}`);
    }
    return '·';
  });
  for (const t of s.split(/[·,]/)) {
    const k = coreName(t).replace(/호$/, '');
    if (k.length >= 2) keys.push(k);
  }
  return keys;
}

module.exports = { prepareProjects, suggest, pickPlantSubfolder };
