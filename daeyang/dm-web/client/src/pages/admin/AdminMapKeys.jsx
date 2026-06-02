import { useState, useEffect } from 'react'
import { apiGet, apiSend } from '../../api'

export default function AdminMapKeys() {
  const [form, setForm] = useState({ kakao: '', naver: '', google: '' })
  const [message, setMessage] = useState('')

  useEffect(() => {
    apiGet('/api/admin/map-keys')
      .then((d) => setForm({ kakao: d.kakao || '', naver: d.naver || '', google: d.google || '' }))
      .catch(console.error)
  }, [])

  function upd(key) { return (e) => setForm((p) => ({ ...p, [key]: e.target.value })) }

  async function handleSave(e) {
    e.preventDefault()
    try {
      await apiSend('/api/admin/map-keys', 'PUT', form)
      setMessage('저장되었습니다.')
    } catch (err) {
      setMessage(err.message)
    }
  }

  return (
    <div className="admin-panel">
      <div className="admin-panel-head">
        <span>지도 API 키 관리</span>
      </div>

      <div className="admin-alert">지도 서비스에 사용할 API 키를 입력하세요. 저장 후 즉시 반영됩니다.</div>

      <form onSubmit={handleSave}>
        <div className="admin-form-grid">
          <div className="label">Kakao 키</div>
          <div className="field"><input value={form.kakao} onChange={upd('kakao')} placeholder="Kakao Maps API 키" /></div>
          <div className="label">Naver 키</div>
          <div className="field"><input value={form.naver} onChange={upd('naver')} placeholder="Naver Maps API 키" /></div>
          <div className="label">Google 키</div>
          <div className="field"><input value={form.google} onChange={upd('google')} placeholder="Google Maps API 키" /></div>
        </div>

        {message && (
          <div style={{ margin: '10px 16px', fontSize: '0.85rem', color: message.includes('저장') ? '#10b981' : '#dc2626' }}>
            {message}
          </div>
        )}

        <div className="admin-form-actions">
          <button type="submit" className="btn-admin-primary">저장</button>
        </div>
      </form>
    </div>
  )
}
