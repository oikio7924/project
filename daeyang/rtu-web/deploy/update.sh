#!/bin/bash
# rtu-web 업데이트 (서버에서 root 로 실행)
#   bash update.sh /var/www/rtu-web-YYMMDD.tar.gz
# 1) 현재 폴더를 rtu-web.bak-날짜시각 으로 복사  2) 새 코드 풀기 (.env 는 그대로)
# 3) npm install  4) 문법 검사  5) pm2 재시작  6) 응답 확인 — 실패하면 백업으로 되돌리는 명령을 알려준다
set -euo pipefail
export PATH=/usr/local/bin:$PATH   # root PATH 에 node·pm2 가 없음
export PM2_HOME=/root/.pm2

PKG="${1:-}"
APP=/var/www/rtu-web
NAME=rtu-web

if [ -z "$PKG" ] || [ ! -f "$PKG" ]; then
  echo "사용법: bash update.sh /var/www/rtu-web-YYMMDD.tar.gz"
  exit 1
fi
if [ ! -f "$APP/.env" ]; then
  echo "$APP/.env 가 없습니다. 첫 설치는 docs/배포 방법.md 를 따르세요."
  exit 1
fi

STAMP=$(date +%y%m%d-%H%M%S)
BAK="$APP.bak-$STAMP"
echo "[1/6] 백업: $BAK"
cp -a "$APP" "$BAK"

echo "[2/6] 새 코드 풀기"
tar -xzf "$PKG" -C "$APP" --exclude='.env' --no-same-owner   # 파일 주인은 root (압축한 PC의 사용자 번호를 따라가지 않게)

echo "[3/6] npm install"
cd "$APP"
npm install --omit=dev --no-audit --no-fund

echo "[4/6] 문법 검사"
node --check server.js
node --check public/js/app.js

echo "[5/6] pm2 재시작"
pm2 restart "$NAME" --update-env
sleep 3

echo "[6/6] 응답 확인"
CODE=$(curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:3003/rtuweb/login.html || true)
if [ "$CODE" = "200" ]; then
  echo "완료: 정상 응답 ($CODE). 확인이 끝나면 백업 폴더를 지워도 됩니다: rm -rf $BAK"
else
  echo "경고: 응답 코드 $CODE. 로그 확인: pm2 logs $NAME --lines 50"
  echo "되돌리기: rm -rf $APP && mv $BAK $APP && pm2 restart $NAME"
  exit 1
fi
