const DIGITS = ['', '일', '이', '삼', '사', '오', '육', '칠', '팔', '구'];
const BIG_UNITS = ['', '만', '억', '조', '경'];

function fourDigitToKorean(n) {
  if (n === 0) return '';
  const cheon = Math.floor(n / 1000);
  const baek = Math.floor((n % 1000) / 100);
  const sip = Math.floor((n % 100) / 10);
  const il = n % 10;
  let r = '';
  if (cheon) r += (cheon === 1 ? '' : DIGITS[cheon]) + '천';
  if (baek) r += (baek === 1 ? '' : DIGITS[baek]) + '백';
  if (sip) r += (sip === 1 ? '' : DIGITS[sip]) + '십';
  if (il) r += DIGITS[il];
  return r;
}

// 숫자를 한글 금액 표기로 변환 (예: 170000 → "십칠만원", 1000000 → "백만원")
export function numberToKoreanMoney(value) {
  let num = Math.floor(Math.abs(Number(value) || 0));
  if (!Number.isFinite(num) || num === 0) return '영원';

  const groups = [];
  while (num > 0) {
    groups.push(num % 10000);
    num = Math.floor(num / 10000);
  }

  let result = '';
  for (let i = groups.length - 1; i >= 0; i--) {
    const g = groups[i];
    if (g === 0) continue;
    let part = fourDigitToKorean(g);
    if (g === 1 && i === 1) part = ''; // "일만원" 대신 "만원"
    result += part + BIG_UNITS[i];
  }
  return result + '원';
}
