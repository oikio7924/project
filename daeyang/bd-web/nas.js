// ─── 시놀로지 NAS(File Station API) 읽기 전용 연결 ─────────────────────────────
// bd-web은 NAS에 있는 발전소 서류를 "보여주기·내려받기"만 함 (NAS에 쓰거나 지우지 않음)
//
// .env 설정
//   NAS_URL   : NAS 웹 주소 (예: http://192.168.0.10:5000) — 비어 있으면 NAS 기능 꺼짐
//   NAS_USER  : NAS 계정 (읽기 권한만 있으면 됨)
//   NAS_PASS  : NAS 비밀번호
//   NAS_ROOT  : 연결할 수 있는 최상위 폴더 (예: /공유폴더/8. 발전소) — 이 밖은 탐색·다운로드 불가
const http = require('http');
const https = require('https');
const querystring = require('querystring');

const NAS_URL  = (process.env.NAS_URL || '').replace(/\/$/, '');
const NAS_USER = process.env.NAS_USER || '';
const NAS_PASS = process.env.NAS_PASS || '';
const NAS_ROOT = (process.env.NAS_ROOT || '').replace(/\/$/, '');

const enabled = !!(NAS_URL && NAS_USER && NAS_PASS && NAS_ROOT);

// 세션 만료·무효 계열 오류코드 → 다시 로그인 후 1회 재시도
const RELOGIN_CODES = new Set([105, 106, 107, 119]);

const NAS_ERROR_TEXT = {
  400: '잘못된 요청입니다.',
  401: 'NAS 계정 정보가 맞지 않습니다.',
  402: 'NAS 권한이 없습니다.',
  407: 'NAS 접속이 차단되었습니다.',
  408: 'NAS에서 폴더나 파일을 찾을 수 없습니다.',
  105: 'NAS 권한이 없습니다.',
  119: 'NAS 세션이 만료되었습니다.',
};

let sid = null;
let loginPromise = null;

function client() { return NAS_URL.startsWith('https') ? https : http; }

// GET 요청 → JSON
function getJson(cgi, params, timeoutMs = 15000) {
  const url = `${NAS_URL}/webapi/${cgi}?${querystring.stringify(params)}`;
  return new Promise((resolve, reject) => {
    const req = client().get(url, { timeout: timeoutMs }, res => {
      let body = '';
      res.setEncoding('utf8');
      res.on('data', c => { body += c; });
      res.on('end', () => {
        try { resolve(JSON.parse(body)); }
        catch (e) { reject(new Error('NAS 응답을 읽을 수 없습니다.')); }
      });
    });
    req.on('timeout', () => req.destroy(new Error('NAS 응답 시간이 초과되었습니다.')));
    req.on('error', e => reject(new Error(`NAS에 연결할 수 없습니다. (${e.message})`)));
  });
}

async function login() {
  const d = await getJson('auth.cgi', {
    api: 'SYNO.API.Auth', version: 3, method: 'login',
    account: NAS_USER, passwd: NAS_PASS, session: 'FileStation', format: 'sid',
  });
  if (!d.success) {
    const code = d.error && d.error.code;
    throw new Error(`NAS 로그인 실패 (${NAS_ERROR_TEXT[code] || `오류코드 ${code}`})`);
  }
  sid = d.data.sid;
  return sid;
}

async function ensureLogin() {
  if (sid) return sid;
  if (!loginPromise) loginPromise = login().finally(() => { loginPromise = null; });
  return loginPromise;
}

function nasError(d) {
  const code = d.error && d.error.code;
  // 여러 경로 요청 시 상세 코드는 error.errors[0].code 에 들어옴
  const sub = d.error && d.error.errors && d.error.errors[0] && d.error.errors[0].code;
  const c = sub || code;
  const err = new Error(NAS_ERROR_TEXT[c] || `NAS 오류 (코드 ${c})`);
  err.nasCode = c;
  return err;
}

// File Station API 호출 (세션 만료 시 1회 재로그인)
async function call(params) {
  for (let attempt = 0; attempt < 2; attempt++) {
    const s = await ensureLogin();
    const d = await getJson('entry.cgi', { ...params, _sid: s });
    if (d.success) return d.data;
    const code = d.error && d.error.code;
    if (attempt === 0 && RELOGIN_CODES.has(code)) { sid = null; continue; }
    throw nasError(d);
  }
}

// ─── 경로 검사: NAS_ROOT 밖이나 '..' 이 들어간 경로는 거부 ─────────────────────
function isAllowedPath(p) {
  if (typeof p !== 'string' || !p.startsWith('/')) return false;
  if (p.split('/').some(seg => seg === '..' || seg === '.')) return false;
  return p === NAS_ROOT || p.startsWith(NAS_ROOT + '/');
}

function assertAllowed(p) {
  if (!isAllowedPath(p)) {
    const e = new Error('허용되지 않은 NAS 경로입니다.');
    e.status = 400;
    throw e;
  }
}

// 폴더 안의 하위 폴더 목록 (폴더 선택 화면용)
async function listFolders(folderPath) {
  assertAllowed(folderPath);
  const data = await call({
    api: 'SYNO.FileStation.List', version: 2, method: 'list',
    folder_path: folderPath, filetype: 'dir', sort_by: 'name', limit: 1000,
  });
  return data.files
    .filter(f => f.isdir && !f.name.startsWith('#') && !f.name.startsWith('@'))
    .map(f => ({ name: f.name, path: f.path }));
}

// ─── 폴더 검색용 목록 (NAS_ROOT 아래 연도 / 진행단계 / 발전소(현장) 폴더) ──────────
// NAS 자체 검색은 색인이 없어 오래 걸림 → 연도·진행단계·현장 폴더까지 미리 읽어 두고(몇 초) 10분간 재사용
// (그보다 깊은 곳은 하위 폴더 전체 검색 searchStart/searchList 로 찾음)
const INDEX_DEPTH = 3;
const INDEX_TTL_MS = 10 * 60 * 1000;
let folderIndex = null;        // { folders: [{name, path}], builtAt }
let folderIndexPromise = null;

// 연도·진행단계처럼 발전소 폴더를 담는 폴더인지
//   맨 위 폴더(2025년, ~2022년, 준공 발전소[미사용] …), "2017년", "1. 견적진행", "2. 공사완료(…)", ".미진행"
//   (~2022년 아래는 2022년/1. 견적진행/현장 처럼 한 단계 더 깊고, 2017년/현장 처럼 단계 폴더가 없는 해도 있음)
const isContainer = (name, depth) => depth === 1
  || /^~?\d{4}년$/.test(name)                        // "2018년 현장사진" 같은 폴더는 제외
  || /^\.?(\d+\.\s*)?(견적|공사|미진행)/.test(name);

async function buildFolderIndex() {
  const out = [];
  let level = [{ path: NAS_ROOT, depth: 0 }];
  // 담는 폴더만 따라 내려가고, 그 안의 나머지 폴더는 발전소(현장) 폴더로 기록
  while (level.length) {
    const next = [];
    const queue = [...level];
    // NAS 부담을 줄이려고 동시에 4개까지만 요청
    await Promise.all([0, 1, 2, 3].map(async () => {
      while (queue.length) {
        const p = queue.shift();
        try {
          for (const f of await listFolders(p.path)) {
            const depth = p.depth + 1;
            const box = depth < 5 && isContainer(f.name, depth);
            out.push({ ...f, project: !box && depth >= 2 });
            if (box) next.push({ path: f.path, depth });
          }
        } catch (e) { /* 권한 없는 폴더 등은 건너뜀 */ }
      }
    }));
    level = next;
  }
  out.sort((a, b) => a.path.localeCompare(b.path, 'ko'));
  return { folders: out, builtAt: Date.now() };
}

async function getFolderIndex(force) {
  const fresh = folderIndex && (Date.now() - folderIndex.builtAt < INDEX_TTL_MS);
  if (fresh && !force) return folderIndex;
  if (!folderIndexPromise) {
    folderIndexPromise = buildFolderIndex()
      .then(idx => { folderIndex = idx; return idx; })
      .finally(() => { folderIndexPromise = null; });
  }
  return folderIndexPromise;
}

// 발전소(현장) 폴더 목록 (연도·진행단계 폴더 바로 안의 폴더)
async function getProjectFolders(force) {
  const idx = await getFolderIndex(force);
  return idx.folders.filter(f => f.project);
}

// ─── 하위 폴더 전체 검색 (NAS File Station 검색, 색인이 없어 오래 걸림 → 찾는 대로 받아 감) ──
//   이름에 띄어쓰기가 달라도 찾도록 "햇살1호" → "*햇*살*1*호*" 로 넓게 찾고, 띄어쓰기를 뺀 이름으로 다시 거름
async function searchStart(folderPath, terms) {
  assertAllowed(folderPath);
  const longest = [...terms].sort((a, b) => b.length - a.length)[0];
  const pattern = `*${[...longest.replace(/[*?\[\]]/g, '')].join('*')}*`;
  const data = await call({
    api: 'SYNO.FileStation.Search', version: 2, method: 'start',
    folder_path: JSON.stringify([folderPath]), pattern, recursive: true, filetype: 'all',
  });
  return data.taskid;
}

async function searchList(taskid, offset) {
  const data = await call({
    api: 'SYNO.FileStation.Search', version: 2, method: 'list',
    taskid, offset, limit: 500, additional: JSON.stringify(['size', 'time']),
  });
  const files = (data.files || []).map(f => ({
    name: f.name, path: f.path, isdir: !!f.isdir,
    size: f.additional && f.additional.size, mtime: f.additional && f.additional.time && f.additional.time.mtime,
  }));
  return { finished: !!data.finished, total: data.total || 0, files };
}

async function searchStop(taskid) {
  for (const method of ['stop', 'clean']) {
    try { await call({ api: 'SYNO.FileStation.Search', version: 2, method, taskid }); } catch (_) { /* 이미 끝난 작업 */ }
  }
}

// 여러 폴더가 NAS에 아직 있는지 한 번에 확인 → 없어진 경로 Set
//   (이름이 바뀌었거나 옮겨진 폴더 찾기용. 한글 경로는 주소가 길어져서 주소 길이 6000자 안쪽으로 나눠 요청)
async function findMissing(paths) {
  const missing = new Set();
  const chunks = [];
  let chunk = [], len = 0;
  for (const p of new Set(paths)) {
    const l = encodeURIComponent(p).length + 3;
    if (chunk.length && len + l > 6000) { chunks.push(chunk); chunk = []; len = 0; }
    chunk.push(p); len += l;
  }
  if (chunk.length) chunks.push(chunk);
  for (const chunk of chunks) {
    const data = await call({
      api: 'SYNO.FileStation.List', version: 2, method: 'getinfo', path: JSON.stringify(chunk),
    });
    const found = new Map((data.files || []).map(f => [f.path, f]));
    for (const p of chunk) {
      const f = found.get(p);
      if (!f || f.code || !f.isdir) missing.add(p);
    }
  }
  return missing;
}

// 발전소 폴더 안에서 서류 폴더 찾기
//   1) "0. 공통서류" 가 있으면 그 폴더 (없으면 발전소 폴더 그대로)
//   2) 그 안에 이 발전소 이름의 호기별 폴더가 있으면 그 폴더 (pickSub(하위폴더목록) → 폴더 | null)
async function resolveDocsFolder(projectPath, pickSub) {
  assertAllowed(projectPath);
  const subs = await listFolders(projectPath);
  const docs = subs.find(f => /^0\.\s*공통\s*서류/.test(f.name)) || subs.find(f => f.name.includes('공통서류'));
  if (!docs) return projectPath;
  if (!pickSub) return docs.path;
  // 호기별 폴더를 고르고, 고른 폴더 안이 또 호기별로 나뉘어 있으면 한 번 더 들어감
  let cur = docs.path;
  for (let i = 0; i < 2; i++) {
    const own = pickSub(await listFolders(cur));
    if (!own) break;
    cur = own.path;
  }
  return cur;
}

// 폴더 안 파일을 하위 폴더까지 펼쳐서 목록 (최대 깊이·개수 제한)
const MAX_DEPTH = 4;
const MAX_FILES = 1000;
const SKIP_FILES = new Set(['Thumbs.db', 'desktop.ini', '.DS_Store']);

async function listFilesDeep(rootPath) {
  assertAllowed(rootPath);
  const out = [];
  let truncated = false;

  async function walk(dirPath, rel, depth) {
    if (out.length >= MAX_FILES) { truncated = true; return; }
    const data = await call({
      api: 'SYNO.FileStation.List', version: 2, method: 'list',
      folder_path: dirPath, sort_by: 'name', limit: 1000,
      additional: JSON.stringify(['size', 'time']),
    });
    const dirs = [];
    for (const f of data.files) {
      if (f.name.startsWith('#') || f.name.startsWith('@')) continue;
      if (f.isdir) { dirs.push(f); continue; }
      if (SKIP_FILES.has(f.name)) continue;
      if (out.length >= MAX_FILES) { truncated = true; break; }
      out.push({
        rel: rel ? `${rel}/${f.name}` : f.name,
        folder: rel,
        name: f.name,
        size: f.additional && f.additional.size,
        mtime: f.additional && f.additional.time && f.additional.time.mtime,
      });
    }
    if (depth >= MAX_DEPTH) { if (dirs.length) truncated = true; return; }
    for (const d of dirs) {
      await walk(d.path, rel ? `${rel}/${d.name}` : d.name, depth + 1);
    }
  }

  await walk(rootPath, '', 1);
  return { files: out, truncated };
}

// 폴더 안 내용 한 단계 (폴더 + 파일, 파일 열기 창의 오른쪽 목록용)
async function listEntries(folderPath) {
  assertAllowed(folderPath);
  const data = await call({
    api: 'SYNO.FileStation.List', version: 2, method: 'list',
    folder_path: folderPath, sort_by: 'name', limit: 2000,
    additional: JSON.stringify(['size', 'time']),
  });
  return data.files
    .filter(f => !f.name.startsWith('#') && !f.name.startsWith('@') && !SKIP_FILES.has(f.name))
    .map(f => ({
      name: f.name, path: f.path, isdir: !!f.isdir,
      size: f.isdir ? null : (f.additional && f.additional.size),
      mtime: f.additional && f.additional.time && f.additional.time.mtime,
    }));
}

// 파일 1개를 NAS에서 받아 그대로 응답으로 흘려보냄 (bd-web 서버에 저장하지 않음)
async function pipeFile(filePath, res, { disposition, contentType, filename }) {
  assertAllowed(filePath);

  for (let attempt = 0; attempt < 2; attempt++) {
    const s = await ensureLogin();
    const url = `${NAS_URL}/webapi/entry.cgi?${querystring.stringify({
      api: 'SYNO.FileStation.Download', version: 2, method: 'download',
      path: filePath, mode: 'download', _sid: s,
    })}`;

    const upstream = await new Promise((resolve, reject) => {
      const req = client().get(url, { timeout: 30000 }, resolve);
      req.on('timeout', () => req.destroy(new Error('NAS 응답 시간이 초과되었습니다.')));
      req.on('error', e => reject(new Error(`NAS에 연결할 수 없습니다. (${e.message})`)));
    });

    // 실패 시 NAS는 파일 대신 JSON 오류를 돌려줌
    const ct = upstream.headers['content-type'] || '';
    if (upstream.statusCode !== 200 || ct.includes('json') || ct.includes('text/html')) {
      let body = '';
      upstream.setEncoding('utf8');
      for await (const c of upstream) body += c;
      let d = null;
      try { d = JSON.parse(body); } catch (_) { /* 무시 */ }
      const code = d && d.error && d.error.code;
      if (attempt === 0 && RELOGIN_CODES.has(code)) { sid = null; continue; }
      // 없는 파일이면 NAS가 JSON 없이 오류 상태코드만 돌려줌
      throw d ? nasError(d) : new Error('NAS에서 파일을 찾을 수 없습니다. 파일이 옮겨졌거나 이름이 바뀌었을 수 있습니다.');
    }

    res.setHeader('Content-Type', contentType || 'application/octet-stream');
    res.setHeader('Content-Disposition', `${disposition}; filename*=UTF-8''${encodeURIComponent(filename)}`);
    if (upstream.headers['content-length']) res.setHeader('Content-Length', upstream.headers['content-length']);
    await new Promise((resolve, reject) => {
      upstream.pipe(res);
      upstream.on('end', resolve);
      upstream.on('error', reject);
    });
    return;
  }
}

module.exports = { enabled, NAS_ROOT, INDEX_DEPTH, isAllowedPath, listFolders, listEntries, getFolderIndex, getProjectFolders, resolveDocsFolder, findMissing, searchStart, searchList, searchStop, listFilesDeep, pipeFile };
