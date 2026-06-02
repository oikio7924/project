import { useState, useEffect } from 'react'
import { apiGet, apiSend, formatNum, statusDotClass } from '../../api'

const STATUS_LABEL = { normal: '정상', no_comm: '통신없음', fault: '장애', offline: '오프' }

export default function AdminPlants() {
  const [plants, setPlants] = useState([])
  const [total, setTotal] = useState(0)
  const [search, setSearch] = useState('')
  const [modal, setModal] = useState(null)
  const [form, setForm] = useState({})

  useEffect(() => { loadPlants() }, [])

  function loadPlants(q = '') {
    const qs = q ? `?q=${encodeURIComponent(q)}` : ''
    apiGet(`/api/admin/plants${qs}`)
      .then((d) => { setPlants(d.plants || []); setTotal(d.total || 0) })
      .catch(console.error)
  }

  function openEdit(p) {
    setForm({ ...p })
    setModal({ plant: p })
  }

  function upd(key) { return (e) => setForm((p) => ({ ...p, [key]: e.target.value })) }

  async function handleSave() {
    try {
      await apiSend(`/api/admin/plants/${modal.plant.id}`, 'PUT', form)
      setModal(null)
      loadPlants(search)
    } catch (err) { alert(err.message) }
  }

  return (
    <div className="admin-panel">
      <div className="admin-panel-head">
        <span>발전소 리스트</span>
      </div>

      <div className="admin-alert">발전소 목록입니다. 행을 클릭하면 수정할 수 있습니다.</div>

      <div className="admin-toolbar">
        <span className="meta">총 {total}건</span>
        <input
          type="search"
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          onKeyDown={(e) => e.key === 'Enter' && loadPlants(search)}
          placeholder="발전소명 검색"
          style={{ flex: 1, maxWidth: 280 }}
        />
        <button type="button" className="btn-admin-primary" onClick={() => loadPlants(search)}>검색</button>
      </div>

      <div className="admin-table-wrap">
        <table className="admin-table">
          <thead>
            <tr>
              <th>번호</th><th>상태</th><th>발전소명</th><th>지역</th>
              <th>설비용량(kW)</th><th>인버터</th><th>인버터수량</th>
            </tr>
          </thead>
          <tbody>
            {plants.length === 0 ? (
              <tr><td colSpan={7} style={{ textAlign: 'center', padding: 20, color: '#94a3b8' }}>데이터가 없습니다.</td></tr>
            ) : (
              plants.map((p, i) => (
                <tr key={p.id} onClick={() => openEdit(p)}>
                  <td>{i + 1}</td>
                  <td><span className={`status-dot ${statusDotClass(p.status)}`} /> {STATUS_LABEL[p.status] || '—'}</td>
                  <td>{p.name}</td>
                  <td>{p.region || '—'}</td>
                  <td>{formatNum(p.capacityKw, 1)}</td>
                  <td>{p.invBrand || '—'}</td>
                  <td>{p.inverterCount}</td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>

      {modal && (
        <div className="admin-modal-overlay" onClick={() => setModal(null)}>
          <div className="admin-modal" onClick={(e) => e.stopPropagation()}>
            <div className="admin-modal-header">
              <span>발전소 수정</span>
              <button className="admin-modal-close" onClick={() => setModal(null)}>&times;</button>
            </div>
            <div className="admin-modal-body">
              <div className="admin-form-grid">
                <div className="label">발전소명</div>
                <div className="field"><input value={form.name || ''} onChange={upd('name')} /></div>
                <div className="label">지역</div>
                <div className="field"><input value={form.region || ''} onChange={upd('region')} /></div>
                <div className="label">위도</div>
                <div className="field"><input value={form.lat || ''} onChange={upd('lat')} /></div>
                <div className="label">경도</div>
                <div className="field"><input value={form.lng || ''} onChange={upd('lng')} /></div>
                <div className="label">설비용량(kW)</div>
                <div className="field"><input value={form.capacityKw || ''} onChange={upd('capacityKw')} /></div>
                <div className="label">인버터 수량</div>
                <div className="field"><input value={form.inverterCount || ''} onChange={upd('inverterCount')} /></div>
              </div>
            </div>
            <div className="admin-modal-footer">
              <button type="button" className="btn-admin-outline" onClick={() => setModal(null)}>취소</button>
              <button type="button" className="btn-admin-primary" onClick={handleSave}>저장</button>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
