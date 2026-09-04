# 배포 안내

## 1. 압축 해제

```bash
tar -xzf ao-web-*.tar.gz -C /path/to/atglobal
cd /path/to/atglobal
```

## 2. 의존성 설치

```bash
npm install
npm --prefix client install
```

## 3. 환경변수 설정

```bash
cp .env.example .env
nano .env   # PG_PASSWORD, SESSION_SECRET, ADMIN_USERNAME/PASSWORD, BUSINESS_API_KEY 등 실제 값 입력
```

`.env`는 비밀번호 등 민감 정보를 담고 있어 배포 패키지에 포함하지 않습니다. 서버에서 직접 생성하세요.

## 4. 클라이언트 빌드

```bash
npm run build
```

`NODE_ENV=production`일 때 Express가 `client/dist`를 정적 파일로 직접 서빙합니다 (별도 nginx 정적 서빙 불필요, TLS 종료용 리버스 프록시만 있으면 됨).

## 5. DB 초기화 / 갱신

`DB_RESET` 값에 따라 서버 기동 시 동작이 달라집니다 (`server/lib/initDb.js`, `server/lib/migrateDb.js`).

- **`DB_RESET=true`**: 기존 테이블을 전부 삭제하고 처음부터 다시 생성합니다. **기존 데이터가 전부 사라집니다.** 완전히 새로운 DB에 최초 설치할 때만 사용하세요.
- **`DB_RESET=false`** (기본값, 권장): 기존 테이블/데이터는 그대로 두고, 아직 없는 테이블·컬럼·인덱스만 새로 생성합니다. 기존 서버를 최신 코드로 갱신 배포할 때는 항상 이 값을 사용하세요.

최초 설치:

1. PostgreSQL에 `PG_DATABASE`(기본 atglobal) 데이터베이스와 계정을 미리 생성해둡니다.
2. `.env`에서 `DB_RESET=true`로 설정 후 서버를 1회 실행합니다: `node server/server.js` (로그에서 정상 기동 확인 후 Ctrl+C)
3. `.env`를 다시 `DB_RESET=false`로 되돌립니다. (true로 둔 채 재기동하면 매번 데이터가 초기화됩니다)

갱신 배포(기존 데이터 유지):

- `.env`의 `DB_RESET`이 `false`인지만 확인하고 그대로 서버를 재기동하면, 새로 추가된 테이블/컬럼이 자동으로 반영됩니다.

## 6. SSL 인증서

`cert.pem` / `chain.pem` / `fullchain.pem` / `privkey.pem`은 민감한 키 자료라 배포 패키지에서 제외했습니다. Certbot 등으로 서버에 이미 발급되어 있다면 그대로 사용하고, 없다면 별도로 발급/전달받아 nginx 등 리버스 프록시 설정에 연결하세요.

## 7. PM2로 기동

```bash
pm2 start ecosystem.config.js
pm2 save
```

갱신 배포 시:

```bash
pm2 restart atglobal
```

## 8. 확인

```bash
curl http://localhost:$PORT/api/health
```

`{"ok":true,"name":"AT Global API"}` 응답을 확인합니다.
