// GET 요청
export async function apiGet(url) {
  const res = await fetch(url, { credentials: 'same-origin' })
  const data = await res.json().catch(() => ({}))
  if (!res.ok) throw new Error(data.error || '요청 실패')
  return data
}

// POST / PUT / DELETE 요청
export async function apiSend(url, method, body) {
  const res = await fetch(url, {
    method,
    credentials: 'same-origin',
    headers: { 'Content-Type': 'application/json' },
    body: body !== undefined ? JSON.stringify(body) : undefined,
  })
  const data = await res.json().catch(() => ({}))
  if (!res.ok) throw new Error(data.error || '요청 실패')
  return data
}

// 숫자 포맷 (한국식)
export function formatNum(n, digits) {
  const x = Number(n)
  if (isNaN(x)) return '0'
  return x.toLocaleString('ko-KR', {
    minimumFractionDigits: digits ?? 0,
    maximumFractionDigits: digits ?? 2,
  })
}

// HTML 이스케이프
export function escapeHtml(s) {
  return String(s)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
}

// 상태 → CSS 클래스
export function statusDotClass(status) {
  if (status === 'normal')  return ''
  if (status === 'no_comm') return 'warn'
  if (status === 'fault')   return 'error'
  return 'off'
}
