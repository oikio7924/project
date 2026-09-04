import { useState, useEffect } from 'react'
import { apiGet, apiSend } from '../api'

const CATEGORIES = ['점검', '교육', '보수', '비상훈련', '기타']
const CAT_COLOR = {
  '점검':   '#2563eb',
  '교육':   '#16a34a',
  '보수':   '#d97706',
  '비상훈련':'#dc2626',
  '기타':   '#7c3aed',
}

const DAYS = ['일', '월', '화', '수', '목', '금', '토']

function ymd(date) { return date.toISOString().slice(0, 10) }

function todayYmd() { return ymd(new Date()) }

const EMPTY_FORM = {
  plantId: '', title: '', content: '', startDate: todayYmd(), endDate: todayYmd(), category: '점검',
}

export default function Safety() {
  const today = new Date()
  const [year, setYear]   = useState(today.getFullYear())
  const [month, setMonth] = useState(today.getMonth() + 1)
  const [schedules, setSchedules] = useState([])
  const [sites, setSites] = useState([])
  const [filterPlant, setFilterPlant] = useState('')
  const [modal, setModal] = useState(null) // { mode:'create'|'edit'|'day', date?, item? }
  const [form, setForm] = useState(EMPTY_FORM)

  useEffect(() => {
    apiGet('/api/sites').then((d) => setSites(d.sites || [])).catch(console.error)
  }, [])

  useEffect(() => { loadSchedules() }, [year, month])

  function loadSchedules() {
    apiGet(`/api/safety?year=${year}&month=${month}`)
      .then((d) => setSchedules(d.schedules || []))
      .catch(console.error)
  }

  function prevMonth() {
    if (month === 1) { setYear(y => y - 1); setMonth(12) }
    else setMonth(m => m - 1)
  }
  function nextMonth() {
    if (month === 12) { setYear(y => y + 1); setMonth(1) }
    else setMonth(m => m + 1)
  }

  function openCreate(date) {
    setForm({ ...EMPTY_FORM, startDate: date, endDate: date })
    setModal({ mode: 'create' })
  }
  function openEdit(item) {
    setForm({
      plantId: item.plant_id || '',
      title: item.title, content: item.content || '',
      startDate: item.start_date, endDate: item.end_date,
      category: item.category,
    })
    setModal({ mode: 'edit', item })
  }
  function openDay(date) {
    setModal({ mode: 'day', date })
  }

  function upd(k) { return (e) => setForm(p => ({ ...p, [k]: e.target.value })) }

  async function handleSave() {
    const payload = { ...form, plantId: form.plantId ? Number(form.plantId) : null }
    try {
      if (modal.mode === 'create') await apiSend('/api/safety', 'POST', payload)
      else await apiSend(`/api/safety/${modal.item.id}`, 'PUT', payload)
      setModal(null)
      loadSchedules()
    } catch (e) { alert(e.message) }
  }

  async function handleDelete(id) {
    if (!confirm('삭제하시겠습니까?')) return
    await apiSend(`/api/safety/${id}`, 'DELETE')
    loadSchedules()
    setModal(null)
  }

  // 달력 날짜 계산
  const firstDay = new Date(year, month - 1, 1).getDay()
  const lastDate = new Date(year, month, 0).getDate()
  const cells = []
  for (let i = 0; i < firstDay; i++) cells.push(null)
  for (let d = 1; d <= lastDate; d++) cells.push(d)

  // 날짜별 일정 맵
  const filtered = filterPlant
    ? schedules.filter(s => String(s.plant_id) === filterPlant)
    : schedules

  function schedulesOnDay(d) {
    const dateStr = `${year}-${String(month).padStart(2,'0')}-${String(d).padStart(2,'0')}`
    return filtered.filter(s => s.start_date <= dateStr && s.end_date >= dateStr)
  }

  const todayStr = todayYmd()
  const dayItems = modal?.mode === 'day'
    ? filtered.filter(s => s.start_date <= modal.date && s.end_date >= modal.date)
    : []

  return (
    <div className="wrap-fill" style={{ padding: 16, display: 'flex', flexDirection: 'column', gap: 12, overflow: 'auto' }}>

      {/* 헤더 */}
      <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
        <h1 style={{ margin: 0, fontSize: '1.1rem', fontWeight: 700, color: 'var(--navy)' }}>안전관리 일정</h1>
        <div style={{ marginLeft: 'auto', display: 'flex', gap: 8, alignItems: 'center' }}>
          <select
            value={filterPlant}
            onChange={(e) => setFilterPlant(e.target.value)}
            style={{ padding: '5px 8px', border: '1px solid var(--line)', borderRadius: 'var(--radius-sm)', fontSize: '0.82rem' }}
          >
            <option value="">전체 발전소</option>
            {sites.map(s => <option key={s.id} value={s.id}>{s.name.replace(/\[.*?\]\s*/, '')}</option>)}
          </select>
          <button className="btn btn-primary" onClick={() => openCreate(todayStr)}>+ 일정 추가</button>
        </div>
      </div>

      {/* 달력 */}
      <div className="card" style={{ flex: 1, display: 'flex', flexDirection: 'column', minHeight: 0 }}>
        {/* 월 네비게이션 */}
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 16, padding: '10px 16px', borderBottom: '1px solid var(--line)' }}>
          <button className="btn" style={{ padding: '4px 12px' }} onClick={prevMonth}>‹</button>
          <span style={{ fontWeight: 700, fontSize: '1rem', minWidth: 100, textAlign: 'center' }}>
            {year}년 {month}월
          </span>
          <button className="btn" style={{ padding: '4px 12px' }} onClick={nextMonth}>›</button>
        </div>

        {/* 요일 헤더 */}
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(7, 1fr)', borderBottom: '1px solid var(--line)' }}>
          {DAYS.map((d, i) => (
            <div key={d} style={{
              padding: '6px 0', textAlign: 'center', fontSize: '0.78rem', fontWeight: 600,
              color: i === 0 ? '#dc2626' : i === 6 ? '#2563eb' : 'var(--text-muted)',
              borderRight: i < 6 ? '1px solid var(--line)' : undefined,
            }}>{d}</div>
          ))}
        </div>

        {/* 날짜 셀 */}
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(7, 1fr)', flex: 1 }}>
          {cells.map((d, idx) => {
            if (!d) return (
              <div key={`empty-${idx}`} style={{
                minHeight: 90, background: '#f8fafc',
                borderRight: (idx + 1) % 7 !== 0 ? '1px solid var(--line)' : undefined,
                borderBottom: '1px solid var(--line)',
              }} />
            )
            const dateStr = `${year}-${String(month).padStart(2,'0')}-${String(d).padStart(2,'0')}`
            const isToday = dateStr === todayStr
            const items   = schedulesOnDay(d)
            const col     = idx % 7
            return (
              <div
                key={d}
                onClick={() => openDay(dateStr)}
                style={{
                  minHeight: 90, padding: '4px 4px 4px 6px', cursor: 'pointer',
                  borderRight: col < 6 ? '1px solid var(--line)' : undefined,
                  borderBottom: '1px solid var(--line)',
                  background: isToday ? '#eff6ff' : undefined,
                  transition: 'background 0.1s',
                }}
                onMouseEnter={e => e.currentTarget.style.background = isToday ? '#dbeafe' : '#f8fafc'}
                onMouseLeave={e => e.currentTarget.style.background = isToday ? '#eff6ff' : ''}
              >
                <div style={{
                  fontSize: '0.78rem', fontWeight: isToday ? 700 : 400,
                  color: col === 0 ? '#dc2626' : col === 6 ? '#2563eb' : isToday ? '#1d4ed8' : 'var(--text)',
                  marginBottom: 2,
                  display: 'flex', alignItems: 'center', gap: 4,
                }}>
                  {isToday && <span style={{ width: 20, height: 20, borderRadius: '50%', background: '#2563eb', color: '#fff', display: 'inline-flex', alignItems: 'center', justifyContent: 'center', fontSize: '0.72rem', fontWeight: 700 }}>{d}</span>}
                  {!isToday && d}
                </div>
                <div style={{ display: 'flex', flexDirection: 'column', gap: 2 }}>
                  {items.slice(0, 3).map(s => (
                    <div key={s.id} style={{
                      fontSize: '0.7rem', padding: '1px 5px', borderRadius: 3,
                      background: CAT_COLOR[s.category] || '#64748b',
                      color: '#fff', overflow: 'hidden', whiteSpace: 'nowrap', textOverflow: 'ellipsis',
                    }}>
                      {s.title}
                    </div>
                  ))}
                  {items.length > 3 && (
                    <div style={{ fontSize: '0.68rem', color: 'var(--text-muted)', paddingLeft: 2 }}>
                      +{items.length - 3}개 더
                    </div>
                  )}
                </div>
              </div>
            )
          })}
        </div>
      </div>

      {/* 범례 */}
      <div style={{ display: 'flex', gap: 12, flexWrap: 'wrap' }}>
        {CATEGORIES.map(c => (
          <div key={c} style={{ display: 'flex', alignItems: 'center', gap: 4, fontSize: '0.78rem' }}>
            <span style={{ width: 10, height: 10, borderRadius: 2, background: CAT_COLOR[c] }} />
            {c}
          </div>
        ))}
      </div>

      {/* 날짜 클릭 모달 */}
      {modal?.mode === 'day' && (
        <div className="modal-backdrop" onClick={() => setModal(null)}>
          <div className="modal-box" style={{ minWidth: 360 }} onClick={e => e.stopPropagation()}>
            <div className="modal-header">
              <h3>{modal.date} 일정</h3>
              <button className="modal-close" onClick={() => setModal(null)}>✕</button>
            </div>
            <div className="modal-body">
              {dayItems.length === 0
                ? <p style={{ color: 'var(--text-muted)', fontSize: '0.85rem' }}>등록된 일정이 없습니다.</p>
                : dayItems.map(s => (
                  <div key={s.id} style={{ marginBottom: 10, padding: '8px 12px', border: '1px solid var(--line)', borderRadius: 6, borderLeft: `4px solid ${CAT_COLOR[s.category] || '#64748b'}` }}>
                    <div style={{ fontWeight: 600, fontSize: '0.87rem' }}>{s.title}</div>
                    <div style={{ fontSize: '0.75rem', color: 'var(--text-muted)', marginTop: 2 }}>
                      {s.plant_name || '전체'} · {s.category} · {s.start_date}{s.end_date !== s.start_date ? ` ~ ${s.end_date}` : ''}
                    </div>
                    {s.content && <div style={{ fontSize: '0.8rem', marginTop: 4 }}>{s.content}</div>}
                    <div style={{ display: 'flex', gap: 6, marginTop: 8 }}>
                      <button className="btn btn-sm" style={{ fontSize: '0.72rem', padding: '2px 8px' }} onClick={() => openEdit(s)}>수정</button>
                      <button className="btn btn-sm" style={{ fontSize: '0.72rem', padding: '2px 8px', color: '#dc2626', borderColor: '#dc2626' }} onClick={() => handleDelete(s.id)}>삭제</button>
                    </div>
                  </div>
                ))
              }
            </div>
            <div className="modal-footer" style={{ justifyContent: 'space-between' }}>
              <button className="btn" onClick={() => { setModal(null); openCreate(modal.date) }}>+ 이 날 일정 추가</button>
              <button className="btn btn-primary" onClick={() => setModal(null)}>닫기</button>
            </div>
          </div>
        </div>
      )}

      {/* 생성/수정 모달 */}
      {(modal?.mode === 'create' || modal?.mode === 'edit') && (
        <div className="modal-backdrop" onClick={() => setModal(null)}>
          <div className="modal-box" style={{ minWidth: 400 }} onClick={e => e.stopPropagation()}>
            <div className="modal-header">
              <h3>{modal.mode === 'create' ? '일정 추가' : '일정 수정'}</h3>
              <button className="modal-close" onClick={() => setModal(null)}>✕</button>
            </div>
            <div className="modal-body">
              <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: '0.85rem' }}>
                <tbody>
                  {[
                    ['제목', <input style={inputStyle} value={form.title} onChange={upd('title')} placeholder="일정 제목" />],
                    ['발전소', (
                      <select style={inputStyle} value={form.plantId} onChange={upd('plantId')}>
                        <option value="">전체 (공통)</option>
                        {sites.map(s => <option key={s.id} value={s.id}>{s.name.replace(/\[.*?\]\s*/, '')}</option>)}
                      </select>
                    )],
                    ['카테고리', (
                      <select style={inputStyle} value={form.category} onChange={upd('category')}>
                        {CATEGORIES.map(c => <option key={c} value={c}>{c}</option>)}
                      </select>
                    )],
                    ['시작일', <input type="date" style={inputStyle} value={form.startDate} onChange={upd('startDate')} />],
                    ['종료일', <input type="date" style={inputStyle} value={form.endDate} onChange={upd('endDate')} />],
                    ['내용', <textarea style={{ ...inputStyle, height: 80, resize: 'vertical' }} value={form.content} onChange={upd('content')} placeholder="상세 내용 (선택)" />],
                  ].map(([label, field]) => (
                    <tr key={label}>
                      <td style={{ width: 70, padding: '6px 8px 6px 0', color: 'var(--text-muted)', fontWeight: 600, verticalAlign: 'top', paddingTop: 10 }}>{label}</td>
                      <td style={{ padding: '4px 0' }}>{field}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
            <div className="modal-footer">
              {modal.mode === 'edit' && (
                <button className="btn" style={{ marginRight: 'auto', color: '#dc2626', borderColor: '#dc2626' }} onClick={() => handleDelete(modal.item.id)}>삭제</button>
              )}
              <button className="btn" onClick={() => setModal(null)}>취소</button>
              <button className="btn btn-primary" onClick={handleSave}>저장</button>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}

const inputStyle = {
  width: '100%', padding: '6px 8px', border: '1px solid var(--line)',
  borderRadius: 'var(--radius-sm)', fontSize: '0.83rem',
  background: 'var(--surface)', color: 'var(--text)',
}
