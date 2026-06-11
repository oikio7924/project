import { useState, useEffect } from 'react'
import { apiGet, apiSend } from '../../api'

const GROUPS = [
  {
    id: 'kakao',
    title: 'Kakao',
    badge: { bg: '#FEE500', color: '#1a1a1a' },
    desc: '카카오 지도 표시 및 주소 검색',
    fields: [
      { key: 'kakao',     label: 'Maps SDK 키',  desc: '지도 표시 (JavaScript SDK)',       placeholder: '예) 0574f2c484f4797a...' },
      { key: 'kakaoRest', label: 'REST API 키',  desc: '주소 검색 / 지오코딩 (서버 사용)', placeholder: '예) 7f4e028a8411c65f...' },
    ],
  },
  {
    id: 'naver',
    title: 'Naver',
    badge: { bg: '#03C75A', color: '#fff' },
    desc: '네이버 지도 서비스',
    fields: [
      { key: 'naver', label: 'Maps 클라이언트 ID', desc: '네이버 지도 표시에 사용', placeholder: '예) SVKJaUG3uA5YCEcc...' },
    ],
  },
  {
    id: 'google',
    title: 'Google',
    badge: { bg: '#4285F4', color: '#fff' },
    desc: 'Google Maps / Places API',
    fields: [
      { key: 'google', label: 'API 키', desc: 'Google Maps 및 Places API', placeholder: '예) AlzaSyC3vQqYBy9T...' },
    ],
  },
]

const EMPTY = { kakao: '', kakaoRest: '', naver: '', google: '' }

export default function AdminMapKeys() {
  const [keys, setKeys]     = useState(EMPTY)
  const [status, setStatus] = useState({}) // { [groupId]: 'saving'|'ok'|'err' }

  useEffect(() => {
    apiGet('/api/admin/settings/maps')
      .then((d) => setKeys({
        kakao:     d.kakao     || '',
        kakaoRest: d.kakaoRest || '',
        naver:     d.naver     || '',
        google:    d.google    || '',
      }))
      .catch(console.error)
  }, [])

  function upd(key) {
    return (e) => setKeys((p) => ({ ...p, [key]: e.target.value }))
  }

  async function saveGroup(groupId) {
    setStatus((p) => ({ ...p, [groupId]: 'saving' }))
    try {
      await apiSend('/api/admin/settings/maps', 'PUT', keys)
      setStatus((p) => ({ ...p, [groupId]: 'ok' }))
      setTimeout(() => setStatus((p) => ({ ...p, [groupId]: null })), 2500)
    } catch {
      setStatus((p) => ({ ...p, [groupId]: 'err' }))
    }
  }

  return (
    <div className="admin-panel">
      <div className="admin-panel-head">
        <span>API 키 관리</span>
      </div>
      <div className="admin-alert">
        서비스에 사용하는 API 키를 카드별로 관리합니다. 각 카드의 저장 버튼을 누르면 즉시 반영됩니다.
      </div>

      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(400px, 1fr))', gap: 20, padding: '20px 0' }}>
        {GROUPS.map((group) => {
          const st = status[group.id]
          return (
            <div key={group.id} style={{
              background: '#fff', border: '1px solid #e2e8f0',
              borderRadius: 10, overflow: 'hidden',
              boxShadow: '0 1px 4px rgba(15,40,71,0.06)',
            }}>
              {/* 헤더 */}
              <div style={{
                display: 'flex', alignItems: 'center', gap: 10,
                padding: '13px 18px', borderBottom: '1px solid #e2e8f0',
                background: '#f8fafc',
              }}>
                <span style={{
                  padding: '3px 12px', borderRadius: 20,
                  fontSize: '0.78rem', fontWeight: 800, letterSpacing: '0.03em',
                  background: group.badge.bg, color: group.badge.color,
                }}>
                  {group.title}
                </span>
                <span style={{ fontSize: '0.82rem', color: '#64748b' }}>{group.desc}</span>
              </div>

              {/* 필드 */}
              <div style={{ padding: '16px 18px', display: 'flex', flexDirection: 'column', gap: 14 }}>
                {group.fields.map((f) => (
                  <div key={f.key}>
                    <div style={{ display: 'flex', alignItems: 'baseline', gap: 8, marginBottom: 5 }}>
                      <label style={{ fontSize: '0.82rem', fontWeight: 600, color: '#0f2847' }}>{f.label}</label>
                      <span style={{ fontSize: '0.72rem', color: '#94a3b8' }}>{f.desc}</span>
                    </div>
                    <input
                      value={keys[f.key]}
                      onChange={upd(f.key)}
                      placeholder={f.placeholder}
                      style={{
                        width: '100%', padding: '8px 10px',
                        border: '1px solid #cbd5e1', borderRadius: 6,
                        fontSize: '0.82rem', color: '#1e293b',
                        fontFamily: 'ui-monospace, monospace',
                        background: '#fafafa', boxSizing: 'border-box',
                      }}
                      onFocus={e => e.target.style.borderColor = '#2563eb'}
                      onBlur={e => e.target.style.borderColor = '#cbd5e1'}
                    />
                  </div>
                ))}
              </div>

              {/* 푸터 */}
              <div style={{
                display: 'flex', alignItems: 'center', justifyContent: 'flex-end', gap: 10,
                padding: '11px 18px', borderTop: '1px solid #e2e8f0', background: '#f8fafc',
              }}>
                {st === 'ok'  && <span style={{ fontSize: '0.8rem', color: '#10b981', fontWeight: 600 }}>✓ 저장되었습니다</span>}
                {st === 'err' && <span style={{ fontSize: '0.8rem', color: '#dc2626', fontWeight: 600 }}>저장 실패</span>}
                <button
                  type="button"
                  className="btn-admin-primary"
                  disabled={st === 'saving'}
                  onClick={() => saveGroup(group.id)}
                >
                  {st === 'saving' ? '저장 중...' : '저장'}
                </button>
              </div>
            </div>
          )
        })}
      </div>
    </div>
  )
}
