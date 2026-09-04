const fs = require("fs");
const path = require("path");
const pub = path.join(__dirname, "..", "public");

const members = `<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>회원 리스트 — DAEYANG 관리자</title>
<link rel="stylesheet" href="/css/style.css"/>
<link rel="stylesheet" href="/css/admin.css"/>
</head>
<body class="admin-body">
<aside class="admin-sidebar">
<div class="admin-sidebar-brand"><img src="/image/logo-color.png" alt="대양기업"/><span>dy 관리자페이지</span></div>
<nav class="admin-nav">
<a href="/index.html">↗ 홈페이지 이동</a>
<div class="admin-nav-section">회원 관리</div>
<a href="/admin-members.html" class="active">회원리스트</a>
<div class="admin-nav-section">발전소 관리</div>
<a href="/admin-plants.html">발전소 리스트</a>
<div class="admin-nav-section">관리자 설정</div>
<a href="/admin-map-keys.html">API</a>
</nav>
<div class="admin-sidebar-foot"><a href="#" id="admin-logout">로그아웃</a></div>
</aside>
<div class="admin-main">
<header class="admin-topbar">
<div class="admin-breadcrumb">관리자페이지 &gt; <strong>회원 관리</strong> &gt; 회원리스트</div>
<div class="admin-topbar-actions"><a href="/index.html" class="btn btn-ghost">모니터링</a></div>
</header>
<main class="admin-content">
<div class="admin-panel">
<div class="admin-panel-head"><span>회원 리스트</span><span><button type="button" class="btn-admin-outline" id="btn-withdrawn">+ 탈퇴 목록</button><button type="button" class="btn-admin-primary" id="btn-add-member" style="margin-left:6px">+ 회원 등록</button></span></div>
<div class="admin-alert">회원 리스트를 확인합니다.</div>
<div class="admin-toolbar"><span class="meta" id="member-meta">총 0건</span><input type="search" id="member-search" placeholder="모든필드 검색" style="flex:1;max-width:280px"/><button type="button" class="btn-admin-primary" id="btn-member-search">검색</button><select id="member-limit"><option value="25" selected>25</option><option value="50">50</option><option value="100">100</option></select></div>
<div class="admin-table-wrap"><table class="admin-table"><thead><tr><th>번호</th><th>ID</th><th>이름</th><th>권한</th><th>이메일</th><th>전화번호</th><th>가입날짜</th><th>마지막 로그인</th><th>인증여부</th><th>카카오톡 전송</th></tr></thead><tbody id="member-tbody"><tr><td colspan="10">불러오는 중…</td></tr></tbody></table></div>
<div class="admin-pagination" id="member-pagination"></div>
</div>
</main>
</div>
<script src="/js/common.js"></script><script src="/js/admin-common.js"></script><script src="/js/admin-members.js"></script>
</body></html>`;

const plants = `<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>발전소 관리 — DAEYANG 관리자</title>
<link rel="stylesheet" href="/css/style.css"/>
<link rel="stylesheet" href="/css/admin.css"/>
</head>
<body class="admin-body">
<aside class="admin-sidebar">
<div class="admin-sidebar-brand"><img src="/image/logo-color.png" alt="대양기업"/><span>dy 관리자페이지</span></div>
<nav class="admin-nav">
<a href="/index.html">↗ 홈페이지 이동</a>
<div class="admin-nav-section">회원 관리</div>
<a href="/admin-members.html">회원리스트</a>
<div class="admin-nav-section">발전소 관리</div>
<a href="/admin-plants.html" class="active">발전소 리스트</a>
<div class="admin-nav-section">관리자 설정</div>
<a href="/admin-map-keys.html">API</a>
</nav>
<div class="admin-sidebar-foot"><a href="#" id="admin-logout">로그아웃</a></motion>
</aside>
<div class="admin-main">
<header class="admin-topbar"><div class="admin-breadcrumb">관리자페이지 &gt; <strong>발전소 관리</strong> &gt; 발전소 리스트</div><div class="admin-topbar-actions"><a href="/index.html" class="btn btn-ghost">모니터링</a></div></header>
<main class="admin-content"><motion class="admin-split">
<div class="admin-panel">
<div class="admin-panel-head">발전소 리스트</div>
<div class="admin-alert">발전소 리스트를 확인합니다.</div>
<div class="admin-toolbar"><input type="text" id="filter-region" placeholder="지역" style="width:80px"/><input type="text" id="filter-name" placeholder="발전소명" style="flex:1"/><button type="button" class="btn-admin-primary" id="btn-plant-search">검색</button></div>
<div class="admin-table-wrap" style="max-height:520px"><table class="admin-table"><thead><tr><th>번호</th><th>지역</th><th>발전소명</th><th>인버터 갯수</th><th>등록일</th><th>x좌표</th><th>y좌표</th></tr></thead><tbody id="plant-tbody"></tbody></table></div>
<div class="admin-pagination" id="plant-pagination"></div>
</div>
<div class="admin-panel">
<div class="admin-panel-head"><span>발전소 등록</span><span><button type="button" class="btn-admin-primary" id="btn-plant-save">저장</button><button type="button" class="btn-admin-danger" id="btn-plant-cancel" style="margin-left:6px">취소</button></span></div>
<form id="plant-form"><input type="hidden" id="plant-id"/>
<div class="admin-form-grid">
<div class="label">발전소 명</div><div class="field"><input type="text" id="plant-name"/></div>
<div class="label">설치용량</div><div class="field"><input type="text" id="plant-capacity" placeholder="kW"/></div>
<div class="label">유저선택</div><div class="field"><select id="plant-owner"></select></div>
<div class="label">상태</div><div class="field"><select id="plant-grid-status"><option value="미계통">미계통</option><option value="계통">계통</option></select></div>
<div class="label">지역</div><motion class="field"><input type="text" id="plant-region"/></div>
<div class="label">발전소 주소</div><motion class="field"><input type="text" id="plant-address" style="width:100%"/></div>
<div class="label">주소 좌표</div><div class="field"><input type="text" id="plant-lng" placeholder="x" style="width:45%"/><input type="text" id="plant-lat" placeholder="y" style="width:45%"/></div>
<div class="label">지도</div><div class="field"><div class="admin-map-placeholder">지도 영역 (연동 예정)</div></div>
<div class="label">인버터 갯수</div><div class="field"><input type="number" id="plant-inv-count" min="0" value="1"/></div>
<div class="label">S/N</div><div class="field"><input type="text" id="plant-sn"/></div>
<div class="label">개별 용량</div><div class="field"><input type="text" id="plant-inv-cap"/></div>
</div></form>
</div></div></main></div>
<script src="/js/common.js"></script><script src="/js/admin-common.js"></script><script src="/js/admin-plants.js"></script>
</body></html>`;

function clean(html) {
  return html
    .replace(/<\/?motion\b[^>]*>/gi, function (t) {
      return t.replace(/motion/gi, "div");
    });
}

fs.writeFileSync(path.join(pub, "admin-members.html"), clean(members), "utf8");
fs.writeFileSync(path.join(pub, "admin-plants.html"), clean(plants), "utf8");
console.log("written utf8");
