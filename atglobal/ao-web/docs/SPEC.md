# AT Global 종합 관리 시스템 — 개발 명세서

> 작성일: 2026-06-02  
> 버전: v1.0  
> 도메인: www.atglobal.kr

---

## 목차

1. [프로젝트 개요](#1-프로젝트-개요)
2. [기술 스택](#2-기술-스택)
3. [사용자 역할 및 권한](#3-사용자-역할-및-권한)
4. [핵심 비즈니스 흐름](#4-핵심-비즈니스-흐름)
5. [화면 구조 (UI 기획)](#5-화면-구조-ui-기획)
6. [데이터베이스 스키마](#6-데이터베이스-스키마)
7. [API 엔드포인트](#7-api-엔드포인트)
8. [프로젝트 디렉토리 구조](#8-프로젝트-디렉토리-구조)
9. [환경 변수](#9-환경-변수)
10. [배포 가이드](#10-배포-가이드)

---

## 1. 프로젝트 개요

AT Global의 파워뱅크 제품 유통 구조(제조 → 총판 → 대리점)를 통합 관리하는 웹 기반 B2B 업무 시스템.

### 관리 대상 업무
- 발주 흐름 (대리점 → 총판 → 관리자)
- 재고 현황 (관리자, 총판 각각 관리)
- 수주 / 판매 / 출고 현황 조회
- 회원 관리 및 승인

### 주요 제품
- 파워뱅크 (기본 품목)
- 추후 제품 추가 등록 가능한 구조로 설계

---

## 2. 기술 스택

| 구분 | 기술 | 비고 |
|------|------|------|
| 프론트엔드 | Vue 3 + Vite | Composition API 사용 |
| UI 컴포넌트 | PrimeVue 또는 Vuetify | 테이블/폼 위주 |
| 백엔드 | Node.js + Express | REST API 서버 |
| 데이터베이스 | PostgreSQL | |
| 인증 | express-session + bcryptjs | |
| 프로세스 관리 | PM2 | |
| 웹서버 | Nginx | 리버스 프록시 |
| 배포 환경 | 가비아 / 카페24 VPS (Ubuntu Linux) | |

---

## 3. 사용자 역할 및 권한

### 역할 계층

```
관리자 (AT Global 제조업체)
    └── 총판 A, 총판 B, ...
            └── 대리점 A-1, 대리점 A-2, ...
```

### 역할별 권한 상세

| 기능 | 관리자 | 총판 | 대리점 |
|------|:------:|:----:|:------:|
| 로그인 | ✅ | ✅ | ✅ |
| 회원 승인/거부 | ✅ | ❌ | ❌ |
| 대리점에 총판 지정 | ✅ | ❌ | ❌ |
| 수주현황 조회 | ✅ (전체) | ✅ (자기 것) | ❌ |
| 재고현황 조회/수정 | ✅ | ✅ (자기 것) | ❌ |
| 판매현황 조회 | ✅ (전체) | ✅ (자기 것) | ❌ |
| 출고현황 조회 | ✅ (전체) | ✅ (자기 것) | ❌ |
| 회원 목록 관리 | ✅ | ❌ | ❌ |
| 발주서 작성/전송 | ❌ | ❌ | ✅ |
| 발주서 수정 | ❌ | ✅ (수신 후) | ❌ |
| 발주 전환 (관리자로 전송) | ❌ | ✅ | ❌ |
| 발주 현황 조회 | ❌ | ✅ | ✅ (자기 것) |

### 회원 가입 프로세스

```
1. 누구든 회원가입 신청 (이름, ID, 비밀번호, 소속, 역할 선택)
2. 상태: "승인 대기" → 로그인 불가
3. 관리자 페이지에서 승인 또는 거부
4. 승인 시: 관리자가 역할(총판/대리점) 및 소속 총판 지정
5. 승인 후: 로그인 가능
```

> **아이디/비밀번호 찾기**: 직접 제공하지 않고, 관리자에게 문의하는 방식으로 처리.

---

## 4. 핵심 비즈니스 흐름

### 발주 흐름 (핵심)

```
[대리점]
  발주서 작성 (모델명, 수량, 단가, 배송지, 비고 등)
       ↓ 전송
[총판 수신함]
  발주서 확인 → 내용 수정 가능 (수량, 단가 등)
       ↓ "발주 전환" 버튼 클릭
[관리자 수신함]
  수주현황에 발주서 등록
```

### 발주서 상태 값

| 상태 | 설명 |
|------|------|
| `PENDING` | 대리점이 총판으로 전송, 총판 미확인 |
| `RECEIVED` | 총판이 확인함 |
| `CONVERTED` | 총판이 관리자로 전환 완료 |
| `CONFIRMED` | 관리자가 수주 확인 |
| `SHIPPED` | 출고 완료 |
| `CANCELLED` | 취소 |

### 재고 흐름

```
관리자: 전체 제품 재고 등록/수정/조회
총판: 자신이 보유한 재고 등록/수정/조회
(재고는 독립적으로 관리, 연동 없음)
```

---

## 5. 화면 구조 (UI 기획)

### 공통

- 모든 역할이 **동일한 URL**로 접속
- 로그인 후 역할에 따라 자동으로 해당 대시보드로 이동
- 상단 네비게이션 바 + 좌측 사이드바 레이아웃 (관리자/총판)
- 대리점은 단일 페이지 레이아웃

---

### [01] 로그인 페이지 `/login`

```
┌─────────────────────────────────┐
│          AT Global Logo         │
│                                 │
│   ┌─────────────────────────┐   │
│   │         아이디           │   │
│   └─────────────────────────┘   │
│   ┌─────────────────────────┐   │
│   │        비밀번호           │   │
│   └─────────────────────────┘   │
│                                 │
│   [         로그인         ]    │
│                                 │
│   아이디 찾기 | 비밀번호 찾기     │
│   (관리자에게 문의 안내 텍스트)   │
│                                 │
│   회원가입 신청                  │
└─────────────────────────────────┘
```

**회원가입 신청 폼 필드**
- 이름
- 아이디 (영문+숫자, 중복확인)
- 비밀번호 / 비밀번호 확인
- 연락처
- 회사명
- 역할 선택 (총판 / 대리점)
- 가입 신청 버튼

---

### [02] 관리자 대시보드 `/admin`

#### 사이드바 메뉴
- 대시보드 (홈)
- 수주현황
- 재고현황
- 판매현황
- 출고현황
- 회원관리

#### 대시보드 홈 레이아웃

```
┌──────────────────────────────────────────────┐
│  [수주현황]  [재고현황]  [판매현황]  [출고현황]  │  ← KPI 요약 카드 4개
└──────────────────────────────────────────────┘
┌───────────────────────┐ ┌────────────────────┐
│                       │ │                    │
│  LINE UP 제품 현황     │ │  등록 판매대리점     │
│  DASHBOARD            │ │  DASHBOARD         │
│  (제품별 수주/출고 표) │ │  (대리점별 발주현황) │
│                       │ │                    │
└───────────────────────┘ └────────────────────┘
```

**KPI 카드**: 이번 달 수주 건수 / 현재 재고 / 이번 달 판매액 / 이번 달 출고 건수

**LINE UP 제품 현황 테이블**
- 컬럼: 제품명, 모델명, 이번달 수주량, 재고, 출고량, 판매액
- 날짜 필터 (기간 조회)

**등록 판매대리점 DASHBOARD**
- 총판별 / 대리점별 발주 현황 요약
- 컬럼: 대리점명, 소속 총판, 최근 발주일, 발주 건수, 총 금액

---

#### 수주현황 `/admin/orders`
- 필터: 기간, 총판, 대리점, 상태
- 테이블: 발주번호, 발주일, 대리점명, 총판명, 제품명, 수량, 단가, 합계, 상태, 비고
- 상태 변경 가능 (확인 → 출고 완료 등)

#### 재고현황 `/admin/inventory`
- 제품별 재고 등록/수정/삭제
- 컬럼: 제품명, 모델명, 규격, 현재 재고, 최소 재고(알림 기준), 최종 수정일
- 재고 부족 시 하이라이트 표시

#### 판매현황 `/admin/sales`
- 기간별 / 제품별 / 대리점별 판매 집계
- 차트 (월별 판매량 추이)
- 테이블: 날짜, 대리점, 제품, 수량, 단가, 합계

#### 출고현황 `/admin/shipments`
- 출고 내역 목록
- 컬럼: 출고번호, 출고일, 대리점, 제품, 수량, 배송지, 운송장번호

#### 회원관리 `/admin/members`
- 탭: 승인 대기 | 전체 회원
- **승인 대기 목록**: 이름, 아이디, 회사명, 신청일, 역할, [승인] [거부] 버튼
- **승인 시 추가 설정**:
  - 총판 가입: 별도 설정 없음
  - 대리점 가입: 소속 총판 지정 (드롭다운)
- **전체 회원 목록**: 이름, 아이디, 역할, 소속, 가입일, 상태, [수정] [비활성화]

---

### [03] 총판 대시보드 `/distributor`

#### 사이드바 메뉴
- 대시보드 (홈)
- 수주현황 (받은 발주서)
- 재고현황
- 판매현황
- 출고현황

#### 대시보드 홈 레이아웃
관리자 대시보드와 유사하나, 자신의 소속 데이터만 표시.

```
┌──────────────────────────────────────────────┐
│  [수주현황]  [재고현황]  [판매현황]  [출고현황]  │
└──────────────────────────────────────────────┘
┌───────────────────────┐ ┌────────────────────┐
│  LINE UP 제품 현황     │ │  소속 대리점 현황   │
│  DASHBOARD            │ │  DASHBOARD         │
└───────────────────────┘ └────────────────────┘
```

#### 수주현황 (받은 발주서) `/distributor/orders`

이 화면이 총판의 핵심 기능.

```
┌───────────────────────────────────────────────────────────────┐
│ 발주번호 │ 대리점명 │ 제품명 │ 수량 │ 단가 │ 합계 │ 수신일 │ 상태 │ 액션 │
├───────────────────────────────────────────────────────────────┤
│ ORD-001  │ A대리점  │ PB-10K │  50  │ 15,000 │ ... │ 06/01 │ 수신 │ [수정] [발주전환] │
│ ORD-002  │ B대리점  │ PB-20K │ 100  │ 25,000 │ ... │ 06/01 │ 전환완료 │  -  │
└───────────────────────────────────────────────────────────────┘
```

- **[수정] 버튼**: 팝업으로 수량/단가/비고 수정 가능 (상태가 PENDING, RECEIVED일 때만)
- **[발주 전환] 버튼**: 확인 팝업 후 → 현재 내용 그대로 관리자에게 전송 → 상태 `CONVERTED`로 변경

---

### [04] 대리점 페이지 `/dealer`

단일 페이지. 스크롤 구조.

```
┌────────────────────────────────────────────┐
│                                            │
│   ◀ 2026년 6월 ▶                           │
│   일  월  화  수  목  금  토               │   ← 달력 (소형, 발주일 표시)
│   ...                                      │
│                                            │
├────────────────────────────────────────────┤
│                                            │
│   ┌── 발 주 서 ────────────────────────┐   │
│   │                      [AT Global 로고] │   │
│   │  발주일: ____년 __월 __일           │   │
│   │  대리점명: ________________         │   │   ← 발주서 양식 (크게)
│   │  담당자: ________________           │   │
│   │  연락처: ________________           │   │
│   │                                    │   │
│   │  ┌──────┬──────┬────┬──────┬────┐  │   │
│   │  │ 제품명│모델명│수량│단가  │합계│  │   │
│   │  ├──────┼──────┼────┼──────┼────┤  │   │
│   │  │      │      │    │      │    │  │   │
│   │  │      │      │    │      │    │  │   │
│   │  │ [행 추가]                      │  │   │
│   │  └──────┴──────┴────┴──────┴────┘  │   │
│   │                                    │   │
│   │  배송지: ________________________   │   │
│   │  비고:   ________________________   │   │
│   │                                    │   │
│   │  총 합계: ___________________원    │   │
│   │                      [전송]       │   │
│   └────────────────────────────────────┘   │
│                                            │
├────────────────────────────────────────────┤
│  발주 현황                                  │
│  ┌──────────────────────────────────────┐  │
│  │ 발주번호 │ 발주일 │ 제품명 │ 수량 │ 합계 │ 상태 │
│  ├──────────────────────────────────────┤  │   ← 발주 이력 리스트
│  │ ...                                  │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
```

**발주서 필드 상세**

| 필드 | 타입 | 설명 |
|------|------|------|
| 발주일 | Date | 기본값: 오늘 날짜 |
| 대리점명 | Text (자동) | 로그인 정보에서 자동 입력 |
| 담당자 | Text | 자동 입력 (수정 가능) |
| 연락처 | Text | 자동 입력 (수정 가능) |
| 제품명 | Select | 등록된 제품 목록 |
| 모델명 | Select | 제품 선택 시 자동 연동 |
| 수량 | Number | |
| 단가 | Number | 제품 기본 단가 자동 입력 (수정 가능) |
| 합계 | Number (자동) | 수량 × 단가 |
| 배송지 | Text | |
| 비고 | Textarea | |
| 총 합계 | Number (자동) | 전체 행의 합계 합산 |

---

## 6. 데이터베이스 스키마

### 테이블 목록

```
users               회원
products            제품
inventory           재고 (관리자용)
distributor_inventory  재고 (총판용)
orders              발주서
order_items         발주서 항목 (제품별 행)
sales               판매 내역
shipments           출고 내역
```

---

### users

```sql
CREATE TABLE users (
  id            SERIAL PRIMARY KEY,
  username      VARCHAR(50) UNIQUE NOT NULL,
  password      VARCHAR(255) NOT NULL,          -- bcrypt hash
  name          VARCHAR(100) NOT NULL,
  phone         VARCHAR(20),
  company_name  VARCHAR(100),
  role          VARCHAR(20) NOT NULL,            -- 'admin' | 'distributor' | 'dealer'
  status        VARCHAR(20) DEFAULT 'pending',   -- 'pending' | 'active' | 'inactive'
  distributor_id INTEGER REFERENCES users(id),   -- 대리점의 소속 총판 (dealer만 사용)
  created_at    TIMESTAMP DEFAULT NOW(),
  updated_at    TIMESTAMP DEFAULT NOW()
);
```

### products

```sql
CREATE TABLE products (
  id            SERIAL PRIMARY KEY,
  name          VARCHAR(100) NOT NULL,           -- 제품명 (예: 파워뱅크)
  model_name    VARCHAR(100) NOT NULL,           -- 모델명 (예: PB-10000)
  spec          VARCHAR(200),                    -- 규격/사양
  base_price    NUMERIC(15, 2) DEFAULT 0,        -- 기본 단가
  is_active     BOOLEAN DEFAULT true,
  created_at    TIMESTAMP DEFAULT NOW()
);
```

### inventory (관리자 재고)

```sql
CREATE TABLE inventory (
  id            SERIAL PRIMARY KEY,
  product_id    INTEGER REFERENCES products(id) NOT NULL,
  quantity      INTEGER DEFAULT 0,
  min_quantity  INTEGER DEFAULT 0,               -- 최소 재고 알림 기준
  note          TEXT,
  updated_at    TIMESTAMP DEFAULT NOW()
);
```

### distributor_inventory (총판 재고)

```sql
CREATE TABLE distributor_inventory (
  id              SERIAL PRIMARY KEY,
  distributor_id  INTEGER REFERENCES users(id) NOT NULL,
  product_id      INTEGER REFERENCES products(id) NOT NULL,
  quantity        INTEGER DEFAULT 0,
  min_quantity    INTEGER DEFAULT 0,
  note            TEXT,
  updated_at      TIMESTAMP DEFAULT NOW()
);
```

### orders (발주서)

```sql
CREATE TABLE orders (
  id              SERIAL PRIMARY KEY,
  order_number    VARCHAR(30) UNIQUE NOT NULL,   -- ORD-20260601-001
  dealer_id       INTEGER REFERENCES users(id) NOT NULL,
  distributor_id  INTEGER REFERENCES users(id) NOT NULL,
  status          VARCHAR(20) DEFAULT 'PENDING', -- PENDING | RECEIVED | CONVERTED | CONFIRMED | SHIPPED | CANCELLED
  delivery_address TEXT,
  note            TEXT,
  total_amount    NUMERIC(15, 2) DEFAULT 0,
  ordered_at      TIMESTAMP DEFAULT NOW(),       -- 대리점 발주일
  received_at     TIMESTAMP,                     -- 총판 수신일
  converted_at    TIMESTAMP,                     -- 총판→관리자 전환일
  confirmed_at    TIMESTAMP,                     -- 관리자 확인일
  shipped_at      TIMESTAMP,                     -- 출고일
  created_at      TIMESTAMP DEFAULT NOW(),
  updated_at      TIMESTAMP DEFAULT NOW()
);
```

### order_items (발주서 항목)

```sql
CREATE TABLE order_items (
  id          SERIAL PRIMARY KEY,
  order_id    INTEGER REFERENCES orders(id) NOT NULL,
  product_id  INTEGER REFERENCES products(id) NOT NULL,
  quantity    INTEGER NOT NULL,
  unit_price  NUMERIC(15, 2) NOT NULL,
  amount      NUMERIC(15, 2) GENERATED ALWAYS AS (quantity * unit_price) STORED
);
```

### shipments (출고 내역)

```sql
CREATE TABLE shipments (
  id                SERIAL PRIMARY KEY,
  shipment_number   VARCHAR(30) UNIQUE NOT NULL,
  order_id          INTEGER REFERENCES orders(id) NOT NULL,
  dealer_id         INTEGER REFERENCES users(id) NOT NULL,
  distributor_id    INTEGER REFERENCES users(id) NOT NULL,
  delivery_address  TEXT,
  tracking_number   VARCHAR(100),
  shipped_at        TIMESTAMP DEFAULT NOW(),
  note              TEXT
);
```

---

## 7. API 엔드포인트

### 인증 `/api/auth`

| Method | Path | 설명 | 권한 |
|--------|------|------|------|
| POST | `/api/auth/login` | 로그인 | 전체 |
| POST | `/api/auth/logout` | 로그아웃 | 전체 |
| POST | `/api/auth/register` | 회원가입 신청 | 전체 |

### 회원 `/api/users`

| Method | Path | 설명 | 권한 |
|--------|------|------|------|
| GET | `/api/users/pending` | 승인 대기 목록 | 관리자 |
| POST | `/api/users/:id/approve` | 회원 승인 | 관리자 |
| POST | `/api/users/:id/reject` | 회원 거부 | 관리자 |
| PATCH | `/api/users/:id/distributor` | 대리점 소속 총판 변경 | 관리자 |
| GET | `/api/users` | 전체 회원 목록 | 관리자 |
| PATCH | `/api/users/:id` | 회원 정보 수정 | 관리자 |

### 제품 `/api/products`

| Method | Path | 설명 | 권한 |
|--------|------|------|------|
| GET | `/api/products` | 제품 목록 | 전체 |
| POST | `/api/products` | 제품 등록 | 관리자 |
| PATCH | `/api/products/:id` | 제품 수정 | 관리자 |
| DELETE | `/api/products/:id` | 제품 삭제 | 관리자 |

### 재고 `/api/inventory`

| Method | Path | 설명 | 권한 |
|--------|------|------|------|
| GET | `/api/inventory` | 관리자 재고 조회 | 관리자 |
| POST | `/api/inventory` | 재고 등록 | 관리자 |
| PATCH | `/api/inventory/:id` | 재고 수정 | 관리자 |
| GET | `/api/inventory/distributor` | 총판 재고 조회 | 총판 |
| POST | `/api/inventory/distributor` | 총판 재고 등록 | 총판 |
| PATCH | `/api/inventory/distributor/:id` | 총판 재고 수정 | 총판 |

### 발주서 `/api/orders`

| Method | Path | 설명 | 권한 |
|--------|------|------|------|
| POST | `/api/orders` | 발주서 생성 (전송) | 대리점 |
| GET | `/api/orders/dealer` | 내 발주 현황 | 대리점 |
| GET | `/api/orders/distributor` | 받은 발주서 목록 | 총판 |
| PATCH | `/api/orders/:id` | 발주서 수정 | 총판 |
| POST | `/api/orders/:id/convert` | 발주 전환 (→관리자) | 총판 |
| GET | `/api/orders/admin` | 전체 발주 현황 | 관리자 |
| PATCH | `/api/orders/:id/status` | 발주 상태 변경 | 관리자 |

### 출고 `/api/shipments`

| Method | Path | 설명 | 권한 |
|--------|------|------|------|
| POST | `/api/shipments` | 출고 등록 | 관리자 |
| GET | `/api/shipments` | 출고 내역 조회 | 관리자, 총판 |
| PATCH | `/api/shipments/:id` | 운송장 번호 등록 | 관리자 |

### 대시보드 `/api/dashboard`

| Method | Path | 설명 | 권한 |
|--------|------|------|------|
| GET | `/api/dashboard/admin` | 관리자 KPI 요약 | 관리자 |
| GET | `/api/dashboard/distributor` | 총판 KPI 요약 | 총판 |

---

## 8. 프로젝트 디렉토리 구조

```
atglobal/
├── server/
│   ├── server.js               # Express 진입점
│   ├── routes/
│   │   ├── auth.js
│   │   ├── users.js
│   │   ├── products.js
│   │   ├── inventory.js
│   │   ├── orders.js
│   │   ├── shipments.js
│   │   └── dashboard.js
│   ├── middleware/
│   │   ├── auth.js             # 세션 인증 미들웨어
│   │   └── roleCheck.js        # 역할 권한 검사
│   ├── db/
│   │   ├── index.js            # PostgreSQL 연결 풀
│   │   ├── schema.sql          # 테이블 생성 SQL
│   │   └── seed.sql            # 초기 관리자 계정
│   └── lib/
│       └── initDb.js           # 서버 시작 시 DB 초기화
├── client/
│   ├── index.html
│   ├── vite.config.js
│   ├── package.json
│   └── src/
│       ├── main.js
│       ├── App.vue
│       ├── router/
│       │   └── index.js        # Vue Router (역할별 라우팅)
│       ├── stores/
│       │   └── auth.js         # Pinia 인증 스토어
│       ├── api/
│       │   └── index.js        # axios 인스턴스 + API 함수
│       ├── pages/
│       │   ├── LoginPage.vue
│       │   ├── RegisterPage.vue
│       │   ├── admin/
│       │   │   ├── AdminDashboard.vue
│       │   │   ├── AdminOrders.vue
│       │   │   ├── AdminInventory.vue
│       │   │   ├── AdminSales.vue
│       │   │   ├── AdminShipments.vue
│       │   │   └── AdminMembers.vue
│       │   ├── distributor/
│       │   │   ├── DistributorDashboard.vue
│       │   │   ├── DistributorOrders.vue
│       │   │   ├── DistributorInventory.vue
│       │   │   ├── DistributorSales.vue
│       │   │   └── DistributorShipments.vue
│       │   └── dealer/
│       │       └── DealerPage.vue
│       └── components/
│           ├── Layout/
│           │   ├── AppLayout.vue       # 관리자/총판 공통 레이아웃
│           │   ├── Sidebar.vue
│           │   └── Navbar.vue
│           ├── OrderForm.vue           # 발주서 양식 컴포넌트
│           ├── OrderCalendar.vue       # 달력 컴포넌트
│           └── KpiCard.vue             # KPI 요약 카드
├── ecosystem.config.js         # PM2 설정
├── .env.example
├── .gitignore
└── package.json                # 루트 (concurrently 실행용)
```

---

## 9. 환경 변수

`.env` 파일 (`.env.example` 기준)

```env
# 서버
PORT=4000
NODE_ENV=production
SESSION_SECRET=your_session_secret_here
SITE_DOMAIN=https://www.atglobal.kr

# PostgreSQL
PG_HOST=localhost
PG_PORT=5432
PG_USER=atglobal
PG_PASSWORD=your_db_password
PG_DATABASE=atglobal

# DB 초기화 (처음 한 번만 true)
DB_RESET=false

# 초기 관리자 계정 (DB 초기화 시 seed)
ADMIN_USERNAME=admin
ADMIN_PASSWORD=Admin1234!
```

---

## 10. 배포 가이드

### 서버 환경 (Ubuntu 22.04 LTS)

```bash
# 1. 기본 패키지
sudo apt update && sudo apt upgrade -y
sudo apt install -y git curl nginx

# 2. Node.js 20.x
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# 3. PostgreSQL 15
sudo apt install -y postgresql postgresql-contrib
sudo -u postgres createuser --superuser atglobal
sudo -u postgres createdb atglobal

# 4. PM2
sudo npm install -g pm2

# 5. 프로젝트 클론 및 의존성 설치
git clone https://github.com/your-org/project.git /var/www/atglobal
cd /var/www/atglobal/atglobal
cp .env.example .env
# .env 설정 후
npm install
cd client && npm install && npm run build && cd ..

# 6. DB 초기화 (최초 1회)
DB_RESET=true node server/server.js
# 완료 후 .env에서 DB_RESET=false 로 변경

# 7. PM2로 서버 실행
pm2 start ecosystem.config.js
pm2 save
pm2 startup
```

### Nginx 설정

```nginx
# /etc/nginx/sites-available/atglobal
server {
    listen 80;
    server_name www.atglobal.kr atglobal.kr;

    # 정적 파일 (Vue 빌드 결과)
    root /var/www/atglobal/atglobal/client/dist;
    index index.html;

    # Vue Router history mode 지원
    location / {
        try_files $uri $uri/ /index.html;
    }

    # API 프록시
    location /api {
        proxy_pass http://localhost:4000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

```bash
sudo ln -s /etc/nginx/sites-available/atglobal /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

### ecosystem.config.js (PM2)

```js
module.exports = {
  apps: [{
    name: 'atglobal',
    script: 'server/server.js',
    cwd: '/var/www/atglobal/atglobal',
    instances: 1,
    autorestart: true,
    watch: false,
    max_memory_restart: '512M',
    env: {
      NODE_ENV: 'production'
    }
  }]
}
```

---

## 개발 순서 권장

1. **DB 스키마 및 seed** → `server/db/schema.sql`, `seed.sql`
2. **Express 서버 기본 세팅** → 인증 미들웨어, 세션
3. **인증 API** → 로그인, 로그아웃, 회원가입
4. **회원관리 API + 화면** → 관리자 승인 흐름
5. **제품/재고 API + 화면**
6. **발주서 API + 대리점 화면** (핵심)
7. **총판 발주 수신/전환 화면** (핵심)
8. **관리자 수주/출고 화면**
9. **대시보드 KPI 집계**
10. **배포 설정** (Nginx + PM2 + HTTPS)

---

*본 문서는 개발 진행에 따라 지속 업데이트됩니다.*
