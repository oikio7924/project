'use strict';
const {
  Document, Packer, Paragraph, Table, TableRow, TableCell, TextRun,
  HeadingLevel, AlignmentType, BorderStyle, WidthType, ShadingType,
  PageBreak, Header, Footer, ImageRun, convertMillimetersToTwip
} = require('docx');
const fs = require('fs');

// ─── 색상 상수 ───────────────────────────────
const NAVY   = '1C2B3A';
const NAVY2  = '253447';
const BLUE   = '2450A0';
const GREEN  = '1A6630';
const ORANGE = '8A5000';
const GRAY   = 'F4F5F7';
const LGRAY  = 'E0E4E8';
const WHITE  = 'FFFFFF';
const RED    = 'A01010';

// ─── 헬퍼 함수 ───────────────────────────────
const twip = convertMillimetersToTwip;

function H1(text) {
  return new Paragraph({
    text,
    heading: HeadingLevel.HEADING_1,
    spacing: { before: twip(8), after: twip(4) },
    border: { bottom: { style: BorderStyle.SINGLE, size: 8, color: NAVY } },
    run: { color: NAVY, font: 'Malgun Gothic' }
  });
}

function H2(text) {
  return new Paragraph({
    text,
    heading: HeadingLevel.HEADING_2,
    spacing: { before: twip(6), after: twip(3) },
    border: { left: { style: BorderStyle.SINGLE, size: 12, color: NAVY } },
    indent: { left: twip(3) },
    run: { color: NAVY, font: 'Malgun Gothic' }
  });
}

function H3(text) {
  return new Paragraph({
    text,
    heading: HeadingLevel.HEADING_3,
    spacing: { before: twip(4), after: twip(2) },
    run: { color: NAVY, font: 'Malgun Gothic' }
  });
}

function P(runs, spacing = {}) {
  const children = typeof runs === 'string'
    ? [new TextRun({ text: runs, font: 'Malgun Gothic', size: 20 })]
    : runs;
  return new Paragraph({ children, spacing: { before: twip(1), after: twip(2), ...spacing } });
}

function Bold(text, color) {
  return new TextRun({ text, bold: true, font: 'Malgun Gothic', size: 20, color: color || NAVY });
}

function Norm(text, opts = {}) {
  return new TextRun({ text, font: 'Malgun Gothic', size: 20, ...opts });
}

function Code(text) {
  return new TextRun({ text, font: 'Consolas', size: 18, color: NAVY });
}

function codeBlock(lines) {
  return lines.split('\n').map(line =>
    new Paragraph({
      children: [new TextRun({ text: line || ' ', font: 'Consolas', size: 17 })],
      shading: { type: ShadingType.SOLID, fill: 'F4F5F7', color: 'F4F5F7' },
      border: { left: { style: BorderStyle.SINGLE, size: 12, color: NAVY } },
      spacing: { before: 0, after: 0 },
      indent: { left: twip(4) }
    })
  );
}

function noteBox(text, color = 'FFFBEA', border = 'E8A800') {
  return new Paragraph({
    children: [new TextRun({ text, font: 'Malgun Gothic', size: 18 })],
    shading: { type: ShadingType.SOLID, fill: color, color },
    border: { left: { style: BorderStyle.SINGLE, size: 12, color: border } },
    spacing: { before: twip(2), after: twip(2) },
    indent: { left: twip(4), right: twip(4) }
  });
}

function infoBox(text) {
  return noteBox(text, 'EDF2FB', BLUE);
}

function bullet(text, level = 0) {
  return new Paragraph({
    text,
    bullet: { level },
    spacing: { before: twip(1), after: twip(1) },
    run: { font: 'Malgun Gothic', size: 20 }
  });
}

function pageBreak() {
  return new Paragraph({ children: [new PageBreak()] });
}

function createTable(headers, rows, widths) {
  const cellOpts = (text, isHead = false) => new TableCell({
    children: [new Paragraph({
      children: [new TextRun({
        text: String(text),
        bold: isHead,
        font: 'Malgun Gothic',
        size: 18,
        color: isHead ? WHITE : '333333'
      })],
      spacing: { before: twip(1), after: twip(1) }
    })],
    shading: isHead ? { type: ShadingType.SOLID, fill: NAVY, color: NAVY } : undefined,
    margins: { top: twip(1.5), bottom: twip(1.5), left: twip(2), right: twip(2) },
    width: widths ? { size: widths[headers.indexOf(text)] || 2000, type: WidthType.DXA } : undefined
  });

  const dataCell = (text, idx, isEven) => new TableCell({
    children: [new Paragraph({
      children: [new TextRun({ text: String(text ?? ''), font: 'Malgun Gothic', size: 18, color: '333333' })],
      spacing: { before: twip(1), after: twip(1) }
    })],
    shading: isEven ? { type: ShadingType.SOLID, fill: 'F7F8FA', color: 'F7F8FA' } : undefined,
    margins: { top: twip(1.5), bottom: twip(1.5), left: twip(2), right: twip(2) }
  });

  return new Table({
    width: { size: 100, type: WidthType.PERCENTAGE },
    rows: [
      new TableRow({ children: headers.map(h => cellOpts(h, true)), tableHeader: true }),
      ...rows.map((row, ri) =>
        new TableRow({ children: row.map((cell, ci) => dataCell(cell, ci, ri % 2 === 1)) })
      )
    ],
    margins: { top: twip(1), bottom: twip(3) }
  });
}

// ─── 문서 조립 ───────────────────────────────
const children = [];

// ═══════════════════════════════════════════
// 표지
// ═══════════════════════════════════════════
children.push(
  new Paragraph({ spacing: { before: twip(50) } }),
  new Paragraph({
    children: [new TextRun({ text: 'AT Global', font: 'Malgun Gothic', size: 72, bold: true, color: NAVY })],
    alignment: AlignmentType.CENTER,
    spacing: { before: twip(40), after: twip(4) }
  }),
  new Paragraph({
    children: [new TextRun({ text: 'www.atglobal.kr', font: 'Malgun Gothic', size: 22, color: '888888' })],
    alignment: AlignmentType.CENTER,
    spacing: { after: twip(18) }
  }),
  new Paragraph({
    children: [new TextRun({ text: '종합 유통 관리 시스템', font: 'Malgun Gothic', size: 48, bold: true, color: '111111' })],
    alignment: AlignmentType.CENTER,
    spacing: { after: twip(3) }
  }),
  new Paragraph({
    children: [new TextRun({ text: '개발 명세서', font: 'Malgun Gothic', size: 48, bold: true, color: '111111' })],
    alignment: AlignmentType.CENTER,
    spacing: { after: twip(8) }
  }),
  new Paragraph({
    children: [new TextRun({ text: '파워뱅크 발주·재고·판매·출고 통합 관리', font: 'Malgun Gothic', size: 24, color: '555555' })],
    alignment: AlignmentType.CENTER,
    spacing: { after: twip(20) }
  }),
  createTable(
    ['항목', '내용'],
    [
      ['문서 버전', 'v1.0'],
      ['작성일', '2026년 6월 2일'],
      ['시스템명', 'ATGlobal 종합 관리 시스템'],
      ['개발 언어', 'Vue 3 / Node.js / PostgreSQL'],
      ['배포 환경', '가비아 / 카페24 VPS (Ubuntu Linux)'],
    ]
  ),
  pageBreak()
);

// ═══════════════════════════════════════════
// 1. 프로젝트 개요
// ═══════════════════════════════════════════
children.push(
  H1('1. 프로젝트 개요'),
  H2('1.1 시스템 목적 및 대상'),
  P('AT Global의 파워뱅크 제품 유통 구조(제조 → 총판 → 대리점)를 통합 관리하는 웹 기반 B2B 업무 시스템입니다. 하나의 URL에 세 역할이 접속하며, 로그인 후 역할에 따라 각자의 화면으로 자동 이동합니다.'),
  P([Bold('관리자 (제조업체)'), Norm(' — 수주현황 전체 조회 / 재고 등록 및 관리 / 판매·출고 현황 / 회원 승인 및 관리 / 대리점 소속 총판 지정')]),
  P([Bold('총판'), Norm(' — 수주현황 (자기 것) / 재고 관리 (자기 것) / 판매·출고 현황 / 발주서 수정 및 전환')]),
  P([Bold('대리점'), Norm(' — 발주서 작성 및 전송 / 발주 현황 조회 / 달력 기반 일정 확인')]),
  infoBox('주요 제품: 파워뱅크 (기본 품목). 추후 제품 추가 등록이 가능한 구조로 설계합니다.'),
  H2('1.2 기술 스택'),
  createTable(
    ['구분', '기술', '용도 및 비고'],
    [
      ['프론트엔드', 'Vue 3 + Vite', 'Composition API 사용. 기업용 업무 시스템 구조'],
      ['UI 컴포넌트', 'PrimeVue', 'DataTable, Calendar, Dialog 등 기업용 컴포넌트'],
      ['상태 관리', 'Pinia', '로그인 세션 및 전역 상태 관리'],
      ['백엔드', 'Node.js + Express', 'REST API 서버'],
      ['인증', 'express-session + bcryptjs', '세션 기반 로그인, 비밀번호 bcrypt 암호화'],
      ['데이터베이스', 'PostgreSQL 15', '복잡한 집계 쿼리 및 통계에 적합'],
      ['프로세스 관리', 'PM2', '서버 자동 재시작, 로그 관리'],
      ['웹서버', 'Nginx', '리버스 프록시, 정적 파일 서빙'],
      ['배포 환경', '가비아/카페24 VPS', 'Ubuntu 22.04 LTS 기준'],
    ]
  ),
  pageBreak()
);

// ═══════════════════════════════════════════
// 2. 사용자 역할 및 권한
// ═══════════════════════════════════════════
children.push(
  H1('2. 사용자 역할 및 권한'),
  H2('2.1 역할 계층 구조'),
  P(''),
  ...codeBlock(
`관리자 (AT Global 제조업체)
    ├── 총판 A
    ├── 총판 B  ...
    │     ├── 대리점 A-1
    │     ├── 대리점 A-2  ...
    └── 총판 C`
  ),
  P(''),
  noteBox('각 대리점은 소속 총판이 지정되어 있으며, 소속 총판 변경은 관리자만 가능합니다.'),
  H2('2.2 역할별 기능 권한'),
  createTable(
    ['기능', '관리자', '총판', '대리점'],
    [
      ['로그인', '✔', '✔', '✔'],
      ['회원 승인 / 거부', '✔ 전체', '✘', '✘'],
      ['대리점 소속 총판 지정/변경', '✔', '✘', '✘'],
      ['수주현황 조회', '✔ 전체', '✔ 자기 것', '✘'],
      ['재고현황 조회 및 수정', '✔ 전체', '✔ 자기 것', '✘'],
      ['판매현황 조회', '✔ 전체', '✔ 자기 것', '✘'],
      ['출고현황 조회', '✔ 전체', '✔ 자기 것', '✘'],
      ['발주서 작성 및 전송', '✘', '✘', '✔'],
      ['발주서 수정 (수신 후)', '✘', '✔', '✘'],
      ['발주 전환 (관리자로 전송)', '✘', '✔', '✘'],
      ['발주 현황 조회', '✘', '✔ 자기 것', '✔ 자기 것'],
      ['출고 등록 / 운송장 입력', '✔', '✘', '✘'],
    ]
  ),
  H2('2.3 회원 가입 및 승인 프로세스'),
  bullet('신청자가 회원가입 양식 작성 (이름, 아이디, 비밀번호, 연락처, 회사명, 역할 선택)'),
  bullet('계정 상태 「승인 대기」 — 이 상태에서는 로그인 불가'),
  bullet('관리자가 회원관리 페이지에서 승인 또는 거부'),
  bullet('승인 시: 역할이 대리점이면 소속 총판을 지정 (드롭다운 선택)'),
  bullet('승인 완료 후 로그인 가능. 로그인 시 역할에 따라 해당 대시보드로 자동 이동'),
  P(''),
  noteBox('아이디/비밀번호 분실: 별도 찾기 기능 미제공. 관리자에게 직접 문의하여 초기화합니다.'),
  pageBreak()
);

// ═══════════════════════════════════════════
// 3. 핵심 비즈니스 흐름
// ═══════════════════════════════════════════
children.push(
  H1('3. 핵심 비즈니스 흐름'),
  H2('3.1 발주 흐름 (대리점 → 총판 → 관리자)'),
  createTable(
    ['주체', '행동', '결과'],
    [
      ['대리점', '발주서 양식 작성 후 전송 클릭 (제품명, 모델명, 수량, 단가, 배송지, 비고)', '총판 수신함 등록 / 상태: PENDING'],
      ['총판', '발주서 확인 → 필요 시 수량/단가/비고 수정', '상태: RECEIVED'],
      ['총판', '「발주 전환」 클릭 → 확인 팝업 → 관리자로 전송', '관리자 수주현황 등록 / 상태: CONVERTED'],
      ['관리자', '수주 확인 → 출고 처리', '상태: CONFIRMED → SHIPPED'],
    ]
  ),
  H2('3.2 발주서 상태 정의'),
  createTable(
    ['상태 값', '설명'],
    [
      ['PENDING', '대리점이 총판으로 전송, 총판 미확인'],
      ['RECEIVED', '총판이 발주서 확인함'],
      ['CONVERTED', '총판이 관리자로 전환 완료'],
      ['CONFIRMED', '관리자가 수주 확인'],
      ['SHIPPED', '출고 완료'],
      ['CANCELLED', '모든 단계에서 취소 가능 (관리자만 가능)'],
    ]
  ),
  H2('3.3 재고 관리 흐름'),
  createTable(
    ['주체', '관리 범위', '기능'],
    [
      ['관리자', '전체 제품 재고 (제조 출고 기준)', '재고 등록 / 수정 / 삭제, 최소 재고 알림 설정'],
      ['총판', '자신이 보유한 재고', '재고 등록 / 수정, 최소 재고 알림 설정'],
    ]
  ),
  noteBox('관리자 재고와 총판 재고는 독립적으로 관리됩니다. 자동 연동(차감)은 이번 버전에서 제외됩니다.'),
  pageBreak()
);

// ═══════════════════════════════════════════
// 4. 화면 구조
// ═══════════════════════════════════════════
children.push(
  H1('4. 화면 구조 (UI 기획)'),

  H2('4.1 로그인 화면  /login'),
  P('모든 역할(관리자/총판/대리점)이 동일한 로그인 화면을 사용합니다. 로그인 성공 시 역할에 따라 자동 이동합니다.'),
  createTable(
    ['항목', '설명'],
    [
      ['아이디 입력', '영문+숫자 입력 필드'],
      ['비밀번호 입력', '마스킹 처리'],
      ['로그인 버튼', '클릭 시 세션 발급 후 역할별 대시보드로 이동'],
      ['아이디/비밀번호 찾기', '관리자 문의 안내 팝업 표시'],
      ['회원가입 신청', '신청 폼 페이지로 이동'],
    ]
  ),

  H2('4.2 회원가입 화면  /register'),
  createTable(
    ['필드', '타입', '필수', '비고'],
    [
      ['이름', '텍스트', '필수', ''],
      ['아이디', '텍스트', '필수', '영문+숫자, 중복 확인 버튼'],
      ['비밀번호', '비밀번호', '필수', '8자 이상, 영문+숫자 조합'],
      ['비밀번호 확인', '비밀번호', '필수', '일치 여부 실시간 체크'],
      ['연락처', '텍스트', '필수', ''],
      ['회사명', '텍스트', '필수', ''],
      ['역할', '라디오', '필수', '총판 / 대리점 선택'],
    ]
  ),
  infoBox('가입 신청 후 계정 상태는 「승인 대기」. 관리자 승인 전까지 로그인 불가.'),

  H2('4.3 관리자 대시보드  /admin'),
  P([Bold('네비게이션 구조: '), Norm('상단 브랜드바(AT GLOBAL) + 가로형 네비바(대시보드/수주/재고/판매/출고/회원관리)')]),
  createTable(
    ['메뉴', '경로', '주요 기능'],
    [
      ['대시보드', '/admin', 'KPI 카드 4개 + LINE UP 제품 현황 + 등록 판매대리점 현황'],
      ['수주현황', '/admin/orders', '발주번호/대리점/총판/제품/수량/상태 조회, 상태 변경, 엑셀 다운로드'],
      ['재고현황', '/admin/inventory', '제품별 재고 등록/수정/삭제, 최소 재고 알림'],
      ['판매현황', '/admin/sales', '기간/제품/대리점별 판매 집계, 차트'],
      ['출고현황', '/admin/shipments', '출고 내역, 운송장 번호 입력'],
      ['회원관리', '/admin/members', '승인 대기 처리, 소속 총판 지정, 회원 목록'],
    ]
  ),

  H2('4.4 총판 수주현황  /distributor/orders  — 핵심 기능'),
  P([Bold('총판의 핵심 화면:'), Norm(' 대리점으로부터 받은 발주서를 확인하고, 수정 후 관리자로 전환합니다.')]),
  createTable(
    ['버튼', '동작', '조건'],
    [
      ['수정', '팝업으로 수량/단가/비고 수정 가능', '상태가 PENDING 또는 RECEIVED일 때만 표시'],
      ['발주 전환 ▶', '확인 팝업 → 현재 내용 그대로 관리자에게 전송', '상태가 PENDING 또는 RECEIVED일 때만 표시'],
    ]
  ),

  H2('4.5 대리점 발주 페이지  /dealer'),
  P('단일 페이지. ① 달력 + 요약 → ② 발주서 양식 → ③ 발주 현황 리스트 순으로 구성됩니다.'),
  createTable(
    ['섹션', '구성 요소', '비고'],
    [
      ['① 달력', '월별 캘린더, 발주일에 점 표시', '이번달 발주/출고완료/처리중 요약 카드 함께 표시'],
      ['② 발주서 양식', '발주일/대리점명(자동)/담당자/연락처/제품선택/수량/단가/배송지/비고', '총합계 자동 계산, 행 추가 가능'],
      ['③ 발주 현황', '발주번호/날짜/제품/수량/합계/상태 리스트', '전체보기 클릭 시 필터 가능'],
    ]
  ),
  pageBreak()
);

// ═══════════════════════════════════════════
// 5. DB 스키마
// ═══════════════════════════════════════════
children.push(
  H1('5. 데이터베이스 스키마'),
  H2('5.1 테이블 목록'),
  createTable(
    ['테이블명', '용도', '주요 관계'],
    [
      ['users', '회원 (관리자/총판/대리점)', 'self-reference (dealer → distributor)'],
      ['products', '제품 목록', 'inventory, order_items 참조'],
      ['inventory', '관리자 재고', 'products 참조'],
      ['distributor_inventory', '총판별 재고', 'users(총판), products 참조'],
      ['orders', '발주서 헤더', 'users(대리점), users(총판) 참조'],
      ['order_items', '발주서 행 (제품별)', 'orders, products 참조'],
      ['shipments', '출고 내역', 'orders, users 참조'],
    ]
  ),
  H2('5.2 users 테이블'),
  ...codeBlock(
`CREATE TABLE users (
  id              SERIAL PRIMARY KEY,
  username        VARCHAR(50)  UNIQUE NOT NULL,
  password        VARCHAR(255) NOT NULL,          -- bcrypt 해시
  name            VARCHAR(100) NOT NULL,
  phone           VARCHAR(20),
  company_name    VARCHAR(100),
  role            VARCHAR(20)  NOT NULL,           -- 'admin' | 'distributor' | 'dealer'
  status          VARCHAR(20)  DEFAULT 'pending',  -- 'pending' | 'active' | 'inactive'
  distributor_id  INTEGER REFERENCES users(id),    -- 대리점 전용: 소속 총판 ID
  created_at      TIMESTAMP DEFAULT NOW(),
  updated_at      TIMESTAMP DEFAULT NOW()
);`
  ),
  P(''),
  H2('5.3 products 테이블'),
  ...codeBlock(
`CREATE TABLE products (
  id          SERIAL PRIMARY KEY,
  name        VARCHAR(100) NOT NULL,    -- 예: 파워뱅크
  model_name  VARCHAR(100) NOT NULL,    -- 예: PB-10000
  spec        VARCHAR(200),             -- 규격/사양
  base_price  NUMERIC(15,2) DEFAULT 0, -- 기본 단가
  is_active   BOOLEAN DEFAULT true,
  created_at  TIMESTAMP DEFAULT NOW()
);`
  ),
  P(''),
  H2('5.4 orders / order_items 테이블'),
  ...codeBlock(
`CREATE TABLE orders (
  id               SERIAL PRIMARY KEY,
  order_number     VARCHAR(30) UNIQUE NOT NULL,  -- 예: ORD-20260601-001
  dealer_id        INTEGER REFERENCES users(id) NOT NULL,
  distributor_id   INTEGER REFERENCES users(id) NOT NULL,
  status           VARCHAR(20) DEFAULT 'PENDING',
  delivery_address TEXT,
  note             TEXT,
  total_amount     NUMERIC(15,2) DEFAULT 0,
  ordered_at       TIMESTAMP DEFAULT NOW(),
  received_at      TIMESTAMP,
  converted_at     TIMESTAMP,
  confirmed_at     TIMESTAMP,
  shipped_at       TIMESTAMP,
  created_at       TIMESTAMP DEFAULT NOW(),
  updated_at       TIMESTAMP DEFAULT NOW()
);

CREATE TABLE order_items (
  id          SERIAL PRIMARY KEY,
  order_id    INTEGER REFERENCES orders(id) NOT NULL,
  product_id  INTEGER REFERENCES products(id) NOT NULL,
  quantity    INTEGER NOT NULL,
  unit_price  NUMERIC(15,2) NOT NULL,
  amount      NUMERIC(15,2) GENERATED ALWAYS AS (quantity * unit_price) STORED
);`
  ),
  P(''),
  H2('5.5 inventory / distributor_inventory 테이블'),
  ...codeBlock(
`CREATE TABLE inventory (
  id           SERIAL PRIMARY KEY,
  product_id   INTEGER REFERENCES products(id) NOT NULL,
  quantity     INTEGER DEFAULT 0,
  min_quantity INTEGER DEFAULT 0,
  note         TEXT,
  updated_at   TIMESTAMP DEFAULT NOW()
);

CREATE TABLE distributor_inventory (
  id              SERIAL PRIMARY KEY,
  distributor_id  INTEGER REFERENCES users(id) NOT NULL,
  product_id      INTEGER REFERENCES products(id) NOT NULL,
  quantity        INTEGER DEFAULT 0,
  min_quantity    INTEGER DEFAULT 0,
  note            TEXT,
  updated_at      TIMESTAMP DEFAULT NOW()
);`
  ),
  P(''),
  H2('5.6 shipments 테이블'),
  ...codeBlock(
`CREATE TABLE shipments (
  id                SERIAL PRIMARY KEY,
  shipment_number   VARCHAR(30) UNIQUE NOT NULL,
  order_id          INTEGER REFERENCES orders(id) NOT NULL,
  dealer_id         INTEGER REFERENCES users(id) NOT NULL,
  distributor_id    INTEGER REFERENCES users(id) NOT NULL,
  delivery_address  TEXT,
  tracking_number   VARCHAR(100),
  shipped_at        TIMESTAMP DEFAULT NOW(),
  note              TEXT
);`
  ),
  P(''),
  pageBreak()
);

// ═══════════════════════════════════════════
// 6. API 엔드포인트
// ═══════════════════════════════════════════
children.push(
  H1('6. API 엔드포인트'),
  H2('6.1 인증  /api/auth'),
  createTable(
    ['Method', '경로', '설명', '권한'],
    [
      ['POST', '/api/auth/login', '로그인 (세션 발급)', '전체'],
      ['POST', '/api/auth/logout', '로그아웃 (세션 삭제)', '전체'],
      ['POST', '/api/auth/register', '회원가입 신청', '전체'],
    ]
  ),
  H2('6.2 회원  /api/users'),
  createTable(
    ['Method', '경로', '설명', '권한'],
    [
      ['GET', '/api/users/pending', '승인 대기 목록', '관리자'],
      ['POST', '/api/users/:id/approve', '회원 승인', '관리자'],
      ['POST', '/api/users/:id/reject', '회원 거부', '관리자'],
      ['PATCH', '/api/users/:id/distributor', '대리점 소속 총판 변경', '관리자'],
      ['GET', '/api/users', '전체 회원 목록', '관리자'],
    ]
  ),
  H2('6.3 제품 · 재고  /api/products · /api/inventory'),
  createTable(
    ['Method', '경로', '설명', '권한'],
    [
      ['GET', '/api/products', '제품 목록 조회', '전체'],
      ['POST', '/api/products', '제품 등록', '관리자'],
      ['PATCH', '/api/products/:id', '제품 수정', '관리자'],
      ['GET', '/api/inventory', '관리자 재고 조회', '관리자'],
      ['PATCH', '/api/inventory/:id', '관리자 재고 수정', '관리자'],
      ['GET', '/api/inventory/distributor', '총판 재고 조회', '총판'],
      ['PATCH', '/api/inventory/distributor/:id', '총판 재고 수정', '총판'],
    ]
  ),
  H2('6.4 발주 · 출고  /api/orders · /api/shipments'),
  createTable(
    ['Method', '경로', '설명', '권한'],
    [
      ['POST', '/api/orders', '발주서 생성 (전송)', '대리점'],
      ['GET', '/api/orders/dealer', '내 발주 현황', '대리점'],
      ['GET', '/api/orders/distributor', '받은 발주서 목록', '총판'],
      ['PATCH', '/api/orders/:id', '발주서 수정', '총판'],
      ['POST', '/api/orders/:id/convert', '발주 전환 (→관리자)', '총판'],
      ['GET', '/api/orders/admin', '전체 발주 현황', '관리자'],
      ['PATCH', '/api/orders/:id/status', '발주 상태 변경', '관리자'],
      ['POST', '/api/shipments', '출고 등록', '관리자'],
      ['GET', '/api/shipments', '출고 내역 조회', '관리자, 총판'],
      ['GET', '/api/dashboard/admin', '관리자 KPI 요약', '관리자'],
      ['GET', '/api/dashboard/distributor', '총판 KPI 요약', '총판'],
    ]
  ),
  pageBreak()
);

// ═══════════════════════════════════════════
// 7. 프로젝트 디렉토리 구조
// ═══════════════════════════════════════════
children.push(
  H1('7. 프로젝트 디렉토리 구조'),
  ...codeBlock(
`atglobal/
├── server/
│   ├── server.js                # Express 진입점 (포트: 4000)
│   ├── routes/
│   │   ├── auth.js              # 로그인, 로그아웃, 회원가입
│   │   ├── users.js             # 회원 관리
│   │   ├── products.js          # 제품 CRUD
│   │   ├── inventory.js         # 재고 관리
│   │   ├── orders.js            # 발주서 (생성/수정/전환)
│   │   ├── shipments.js         # 출고 내역
│   │   └── dashboard.js         # KPI 집계
│   ├── middleware/
│   │   ├── auth.js              # 세션 인증 검사
│   │   └── roleCheck.js         # 역할 권한 검사
│   └── db/
│       ├── index.js             # PostgreSQL 연결 풀
│       ├── schema.sql           # 테이블 생성 DDL
│       └── seed.sql             # 초기 관리자 계정
├── client/
│   └── src/
│       ├── pages/
│       │   ├── LoginPage.vue / RegisterPage.vue
│       │   ├── admin/           # 관리자 페이지 6개
│       │   ├── distributor/     # 총판 페이지 5개
│       │   └── dealer/          # 대리점 단일 페이지
│       └── components/
│           ├── OrderForm.vue    # 발주서 양식
│           └── KpiCard.vue      # KPI 카드
├── ecosystem.config.js          # PM2 설정
├── .env.example
└── package.json`
  ),
  P(''),
  H1('8. 환경 변수 (.env)'),
  ...codeBlock(
`PORT=4000
NODE_ENV=production
SESSION_SECRET=랜덤_문자열_입력

PG_HOST=localhost
PG_PORT=5432
PG_USER=atglobal
PG_PASSWORD=DB_비밀번호
PG_DATABASE=atglobal

DB_RESET=false          # 최초 설치 시 true, 이후 반드시 false
ADMIN_USERNAME=admin
ADMIN_PASSWORD=Admin1234!`
  ),
  P(''),
  H1('9. 배포 순서 (Ubuntu 22.04)'),
  bullet('Node.js 20, PostgreSQL 15, Nginx, PM2 설치', 0),
  bullet('PostgreSQL DB 및 사용자 생성: createdb atglobal', 0),
  bullet('프로젝트 클론 → .env 설정 → npm install', 0),
  bullet('Vue 빌드: cd client && npm run build', 0),
  bullet('DB_RESET=true 설정 후 서버 1회 실행 → DB 초기화 → DB_RESET=false로 복구', 0),
  bullet('PM2 실행: pm2 start ecosystem.config.js && pm2 save', 0),
  bullet('Nginx 설정: 정적파일(/client/dist) + /api → localhost:4000 프록시', 0),
  bullet('도메인 연결 및 SSL 인증서: certbot --nginx', 0),
  P(''),
  H1('10. 개발 순서 (권장)'),
  createTable(
    ['순서', '작업 항목', '비고'],
    [
      ['1', 'DB 스키마 + seed (초기 관리자 계정)', 'schema.sql, seed.sql'],
      ['2', 'Express 서버 기본 세팅 (세션, 미들웨어)', 'server.js, middleware/'],
      ['3', '인증 API + 로그인/회원가입 화면', '핵심 선행 작업'],
      ['4', '회원 관리 API + 관리자 회원관리 화면', '승인 흐름 완성'],
      ['5', '제품 / 재고 API + 화면', '발주서 제품 선택 연동'],
      ['6', '발주서 API + 대리점 화면', '핵심 기능 1'],
      ['7', '총판 발주 수신/전환 화면', '핵심 기능 2'],
      ['8', '관리자 수주/출고 화면', ''],
      ['9', '대시보드 KPI 집계 및 차트', '마무리 단계'],
      ['10', 'Nginx + PM2 배포, 도메인/SSL 설정', '납품 전 최종'],
    ]
  )
);

// ═══════════════════════════════════════════
// 문서 생성
// ═══════════════════════════════════════════
const doc = new Document({
  styles: {
    default: {
      document: {
        run: { font: 'Malgun Gothic', size: 20, color: '1A1A1A' },
        paragraph: { spacing: { line: 360 } }
      }
    },
    paragraphStyles: [
      {
        id: 'Heading1', name: 'Heading 1',
        basedOn: 'Normal',
        next: 'Normal',
        run: { bold: true, size: 32, color: NAVY, font: 'Malgun Gothic' },
        paragraph: { spacing: { before: twip(8), after: twip(4) } }
      },
      {
        id: 'Heading2', name: 'Heading 2',
        basedOn: 'Normal',
        next: 'Normal',
        run: { bold: true, size: 26, color: NAVY, font: 'Malgun Gothic' },
        paragraph: { spacing: { before: twip(6), after: twip(3) } }
      },
      {
        id: 'Heading3', name: 'Heading 3',
        basedOn: 'Normal',
        next: 'Normal',
        run: { bold: true, size: 22, color: NAVY, font: 'Malgun Gothic' },
        paragraph: { spacing: { before: twip(4), after: twip(2) } }
      }
    ]
  },
  sections: [{
    properties: {
      page: {
        margin: {
          top: twip(25),
          bottom: twip(20),
          left: twip(25),
          right: twip(20)
        }
      }
    },
    headers: {
      default: new Header({
        children: [new Paragraph({
          children: [
            new TextRun({ text: 'AT Global 종합 관리 시스템 개발 명세서 v1.0', font: 'Malgun Gothic', size: 16, color: '999999' })
          ],
          border: { bottom: { style: BorderStyle.SINGLE, size: 4, color: LGRAY } },
          spacing: { after: twip(2) }
        })]
      })
    },
    footers: {
      default: new Footer({
        children: [new Paragraph({
          children: [
            new TextRun({ text: 'AT Global  |  www.atglobal.kr', font: 'Malgun Gothic', size: 16, color: '999999' })
          ],
          border: { top: { style: BorderStyle.SINGLE, size: 4, color: LGRAY } },
          spacing: { before: twip(2) }
        })]
      })
    },
    children
  }]
});

Packer.toBuffer(doc).then(buf => {
  fs.writeFileSync('./SPEC.docx', buf);
  console.log('✅  SPEC.docx 생성 완료');
}).catch(err => {
  console.error('❌  오류:', err.message);
});
