import { useState, useEffect } from 'react'
import { apiGet, apiSend } from '../api'

export default function Construction() {
  const [sites, setSites] = useState([])
  const [selectedSiteId, setSelectedSiteId] = useState('')
  const [data, setData] = useState(null)
  const [message, setMessage] = useState('')

  useEffect(() => {
    apiGet('/api/sites').then((d) => {
      const list = d.sites || []
      setSites(list)
      if (list[0]) {
        setSelectedSiteId(list[0].id)
        loadConstruction(list[0].id)
      }
    }).catch(console.error)
  }, [])

  function loadConstruction(siteId) {
    apiGet(`/api/construction/${siteId}`).then(setData).catch(console.error)
  }

  function handleSiteChange(e) {
    const id = Number(e.target.value)
    setSelectedSiteId(id)
    loadConstruction(id)
  }

  function updateOperator(key) {
    return (e) => setData((prev) => ({ ...prev, operator: { ...prev.operator, [key]: e.target.value } }))
  }

  function updatePermit(key) {
    return (e) => setData((prev) => ({ ...prev, permit: { ...prev.permit, [key]: e.target.value } }))
  }

  async function handleSave(e) {
    e.preventDefault()
    try {
      await apiSend(`/api/construction/${selectedSiteId}`, 'PUT', data)
      setMessage('저장되었습니다.')
    } catch (err) {
      setMessage(err.message)
    }
  }

  return (
    <div className="wrap-scroll">
      <div className="card settings-card">
        <div style={{ display: 'flex', alignItems: 'center', gap: 12, marginBottom: 16 }}>
          <h2 className="card-title" style={{ margin: 0 }}><span className="card-title-dot" />공사현황</h2>
          <select value={selectedSiteId} onChange={handleSiteChange} style={{ padding: '5px 8px', border: '1px solid var(--line)', borderRadius: 'var(--radius-sm)' }}>
            {sites.map((s) => <option key={s.id} value={s.id}>{s.name}</option>)}
          </select>
        </div>

        {data && (
          <form onSubmit={handleSave}>
            <h3 style={{ fontSize: '0.9rem', marginBottom: 8, color: 'var(--text-muted)' }}>사업자 정보</h3>
            <table className="form-table">
              <tbody>
                <tr className="form-row">
                  <th>상호명</th>
                  <td><input value={data.operator?.businessName || ''} onChange={updateOperator('businessName')} /></td>
                  <th>전화번호</th>
                  <td><input value={data.operator?.phone || ''} onChange={updateOperator('phone')} /></td>
                </tr>
                <tr className="form-row">
                  <th>주소</th>
                  <td colSpan={3}><input value={data.operator?.address || ''} onChange={updateOperator('address')} style={{ width: '100%' }} /></td>
                </tr>
              </tbody>
            </table>

            <h3 style={{ fontSize: '0.9rem', margin: '16px 0 8px', color: 'var(--text-muted)' }}>인허가 정보</h3>
            <table className="form-table">
              <tbody>
                <tr className="form-row">
                  <th>발전소명</th>
                  <td><input value={data.permit?.plantName || ''} onChange={updatePermit('plantName')} /></td>
                  <th>설비용량</th>
                  <td><input value={data.permit?.capacity || ''} onChange={updatePermit('capacity')} /></td>
                </tr>
                <tr className="form-row">
                  <th>설치유형</th>
                  <td><input value={data.permit?.installType || ''} onChange={updatePermit('installType')} /></td>
                  <th>위치</th>
                  <td><input value={data.permit?.location || ''} onChange={updatePermit('location')} /></td>
                </tr>
                <tr className="form-row">
                  <th>허가 접수일</th>
                  <td><input type="date" value={data.permit?.receivedAt || ''} onChange={updatePermit('receivedAt')} /></td>
                  <th>준공 예정일</th>
                  <td><input type="date" value={data.permit?.expectedAt || ''} onChange={updatePermit('expectedAt')} /></td>
                </tr>
              </tbody>
            </table>

            {message && <p style={{ margin: '8px 0', color: message.includes('저장') ? 'var(--success)' : 'var(--danger)' }}>{message}</p>}
            <div style={{ marginTop: 12 }}>
              <button type="submit" className="btn btn-primary">저장</button>
            </div>
          </form>
        )}
      </div>
    </div>
  )
}
