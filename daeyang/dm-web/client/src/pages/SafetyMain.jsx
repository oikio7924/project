import { useState, useEffect } from 'react'
import { apiGet, apiSend } from '../api'
import PlantSidebar from '../components/PlantSidebar'

const TYPES = ['안전관리', 'A/S', '정기점검', '안전교육', '기타']
const TYPE_COLOR = {
  '안전관리': '#2563eb',
  'A/S':     '#dc2626',
  '정기점검': '#16a34a',
  '안전교육': '#d97706',
  '기타':    '#7c3aed',
}
const DAYS = ['일','월','화','수','목','금','토']

function todayStr() { return new Date().toISOString().slice(0,10) }

export default function SafetyMain() {
  const today = new Date()
  const [year, setYear]     = useState(today.getFullYear())
  const [month, setMonth]   = useState(today.getMonth() + 1)
  const [records, setRecords] = useState([])
  const [sites, setSites]   = useState([])
  const [selSite, setSelSite] = useState(null)   // 선택된 발전소 (null = 전체)
  const [filterType, setFilterType] = useState('')
  const [dayModal, setDayModal]   = useState(null)
  const [addModal, setAddModal]   = useState(null)
  const [editModal, setEditModal] = useState(null)
  const [form, setForm] = useState({ plantId:'', type:'안전관리', inspectDate: todayStr(), content:'' })

  useEffect(() => { apiGet('/api/sites').then(d => setSites(d.sites||[])).catch(console.error) }, [])
  useEffect(() => { load() }, [year, month])

  function load() {
    apiGet(`/api/safety?year=${year}&month=${month}`)
      .then(d => setRecords(d.records||[]))
      .catch(console.error)
  }

  function prev() { month===1 ? (setYear(y=>y-1),setMonth(12)) : setMonth(m=>m-1) }
  function next() { month===12 ? (setYear(y=>y+1),setMonth(1)) : setMonth(m=>m+1) }

  const firstDay  = new Date(year, month-1, 1).getDay()
  const lastDate  = new Date(year, month, 0).getDate()
  const cells = [...Array(firstDay).fill(null), ...Array.from({length:lastDate},(_,i)=>i+1)]

  function d2s(d) { return `${year}-${String(month).padStart(2,'0')}-${String(d).padStart(2,'0')}` }

  function itemsOn(d) {
    const s = d2s(d)
    return records.filter(r =>
      r.inspect_date===s &&
      (!filterType || r.type===filterType) &&
      (!selSite || r.plant_id === selSite.id)
    )
  }

  async function saveRecord() {
    try {
      if (editModal) {
        await apiSend(`/api/safety/records/${editModal.id}`, 'PUT', form)
      } else {
        await apiSend('/api/safety/records', 'POST', form)
      }
      setAddModal(null); setEditModal(null); load()
    } catch(e) { alert(e.message) }
  }

  async function del(id) {
    if (!confirm('삭제할까요?')) return
    await apiSend(`/api/safety/records/${id}`, 'DELETE')
    setDayModal(null); load()
  }

  const T = todayStr()

  return (
    <div className="wrap-fill" style={{ display:'flex', flexDirection:'row', padding:0, overflow:'hidden' }}>

      {/* ── 왼쪽: 발전소 목록 ── */}
      <PlantSidebar
        items={sites}
        selectedKey={selSite?.id ?? null}
        onSelect={s => setSelSite(s)}
        showAll
      />

      {/* ── 오른쪽: 달력 ── */}
      <div style={{ flex:1, display:'flex', flexDirection:'column', overflow:'hidden', padding:'12px' }}>
        {/* 헤더 */}
        <div style={{ display:'flex', alignItems:'center', gap:10, marginBottom:10, flexShrink:0 }}>
          <h1 style={{ margin:0, fontSize:'1.05rem', fontWeight:700, color:'var(--navy)' }}>
            안전관리 달력
            {selSite && <span style={{ fontSize:'0.85rem', fontWeight:400, color:'var(--text-muted)', marginLeft:8 }}>— {selSite.name.replace(/\[.*?\]\s*/,'')}</span>}
          </h1>
          <select value={filterType} onChange={e=>setFilterType(e.target.value)}
            style={{ marginLeft:'auto', padding:'5px 8px', border:'1px solid var(--line)', borderRadius:'var(--radius-sm)', fontSize:'0.82rem' }}>
            <option value="">전체 유형</option>
            {TYPES.map(t=><option key={t} value={t}>{t}</option>)}
          </select>
          <button className="btn btn-primary" onClick={()=>{ setEditModal(null); setForm({plantId: selSite?.id||'', type:'안전관리', inspectDate:T, content:''}); setAddModal({}) }}>+ 기록 추가</button>
        </div>

        {/* 달력 카드 */}
        <div className="card" style={{ flex:1, display:'flex', flexDirection:'column', minHeight:0 }}>
          {/* 월 이동 */}
          <div style={{ display:'flex', alignItems:'center', justifyContent:'center', gap:16, padding:'10px 16px', borderBottom:'1px solid var(--line)', flexShrink:0 }}>
            <button className="btn" style={{ padding:'4px 14px' }} onClick={prev}>‹</button>
            <span style={{ fontWeight:700, fontSize:'1rem', minWidth:110, textAlign:'center' }}>{year}년 {month}월</span>
            <button className="btn" style={{ padding:'4px 14px' }} onClick={next}>›</button>
          </div>

          {/* 요일 */}
          <div style={{ display:'grid', gridTemplateColumns:'repeat(7,1fr)', borderBottom:'1px solid var(--line)', flexShrink:0 }}>
            {DAYS.map((d,i)=>(
              <div key={d} style={{ padding:'6px 0', textAlign:'center', fontSize:'0.78rem', fontWeight:600,
                color: i===0?'#dc2626':i===6?'#2563eb':'var(--text-muted)',
                borderRight: i<6?'1px solid var(--line)':undefined }}>
                {d}
              </div>
            ))}
          </div>

          {/* 날짜 셀 */}
          <div style={{ display:'grid', gridTemplateColumns:'repeat(7,1fr)', flex:1, overflowY:'auto' }}>
            {cells.map((d, idx) => {
              if (!d) return <div key={`e${idx}`} style={{ minHeight:90, background:'#f8fafc', borderRight:(idx+1)%7!==0?'1px solid var(--line)':undefined, borderBottom:'1px solid var(--line)' }} />
              const items = itemsOn(d)
              const ds = d2s(d)
              const isToday = ds===T
              const col = idx%7
              return (
                <div key={d} onClick={()=>setDayModal({date:ds, items})}
                  style={{ minHeight:90, padding:'4px 4px 4px 6px', cursor:'pointer',
                    borderRight:col<6?'1px solid var(--line)':undefined,
                    borderBottom:'1px solid var(--line)',
                    background:isToday?'#eff6ff':undefined }}
                  onMouseEnter={e=>e.currentTarget.style.background=isToday?'#dbeafe':'#f8fafc'}
                  onMouseLeave={e=>e.currentTarget.style.background=isToday?'#eff6ff':''}>
                  <div style={{ fontSize:'0.78rem', fontWeight:isToday?700:400, marginBottom:2,
                    color:col===0?'#dc2626':col===6?'#2563eb':isToday?'#1d4ed8':'var(--text)' }}>
                    {isToday
                      ? <span style={{ width:20, height:20, borderRadius:'50%', background:'#2563eb', color:'#fff', display:'inline-flex', alignItems:'center', justifyContent:'center', fontSize:'0.72rem', fontWeight:700 }}>{d}</span>
                      : d}
                  </div>
                  <div style={{ display:'flex', flexDirection:'column', gap:2 }}>
                    {items.slice(0,3).map(r=>(
                      <div key={r.id} style={{ fontSize:'0.68rem', padding:'1px 5px', borderRadius:3,
                        background: TYPE_COLOR[r.type]||'#64748b', color:'#fff',
                        overflow:'hidden', whiteSpace:'nowrap', textOverflow:'ellipsis' }}>
                        {r.plant_name?.replace(/\[.*?\]\s*/,'')||'전체'}
                      </div>
                    ))}
                    {items.length>3 && <div style={{ fontSize:'0.66rem', color:'var(--text-muted)', paddingLeft:2 }}>+{items.length-3}개</div>}
                  </div>
                </div>
              )
            })}
          </div>
        </div>

        {/* 범례 */}
        <div style={{ display:'flex', gap:12, flexWrap:'wrap', marginTop:8, flexShrink:0 }}>
          {TYPES.map(t=>(
            <div key={t} style={{ display:'flex', alignItems:'center', gap:4, fontSize:'0.78rem' }}>
              <span style={{ width:10, height:10, borderRadius:2, background:TYPE_COLOR[t] }} />{t}
            </div>
          ))}
        </div>
      </div>

      {/* 날짜 클릭 모달 */}
      {dayModal && (
        <div className="modal-backdrop" onClick={()=>setDayModal(null)}>
          <div className="modal-box" style={{ minWidth:360 }} onClick={e=>e.stopPropagation()}>
            <div className="modal-header">
              <h3>{dayModal.date}</h3>
              <button className="modal-close" onClick={()=>setDayModal(null)}>✕</button>
            </div>
            <div className="modal-body">
              {dayModal.items.length===0
                ? <p style={{ color:'var(--text-muted)', fontSize:'0.85rem' }}>이 날 기록이 없습니다.</p>
                : dayModal.items.map(r=>(
                  <div key={r.id} style={{ marginBottom:10, padding:'8px 12px', border:'1px solid var(--line)', borderRadius:6, borderLeft:`4px solid ${TYPE_COLOR[r.type]||'#64748b'}` }}>
                    <div style={{ fontWeight:600, fontSize:'0.87rem' }}>
                      {r.plant_name?.replace(/\[.*?\]\s*/,'')||'—'}
                    </div>
                    <div style={{ fontSize:'0.75rem', color:'var(--text-muted)', marginTop:2 }}>
                      {r.type} · {r.created_by||'—'}
                    </div>
                    {r.content && <div style={{ fontSize:'0.8rem', marginTop:4 }}>{r.content}</div>}
                    <div style={{ display:'flex', gap:6, marginTop:8 }}>
                      <button className="btn btn-sm" style={{ fontSize:'0.72rem', padding:'2px 8px' }}
                        onClick={()=>{ setEditModal(r); setForm({plantId:r.plant_id,type:r.type,inspectDate:r.inspect_date,content:r.content||''}); setAddModal({}); setDayModal(null) }}>수정</button>
                      <button className="btn btn-sm" style={{ fontSize:'0.72rem', padding:'2px 8px', color:'#dc2626', borderColor:'#dc2626' }}
                        onClick={()=>del(r.id)}>삭제</button>
                    </div>
                  </div>
                ))}
            </div>
            <div className="modal-footer" style={{ justifyContent:'space-between' }}>
              <button className="btn" onClick={()=>{ setDayModal(null); setEditModal(null); setForm({plantId: selSite?.id||'', type:'안전관리', inspectDate:dayModal.date, content:''}); setAddModal({}) }}>+ 이 날 추가</button>
              <button className="btn btn-primary" onClick={()=>setDayModal(null)}>닫기</button>
            </div>
          </div>
        </div>
      )}

      {/* 추가/수정 모달 */}
      {addModal && (
        <div className="modal-backdrop" onClick={()=>{ setAddModal(null); setEditModal(null) }}>
          <div className="modal-box" style={{ minWidth:400 }} onClick={e=>e.stopPropagation()}>
            <div className="modal-header">
              <h3>{editModal ? '기록 수정' : '점검 기록 추가'}</h3>
              <button className="modal-close" onClick={()=>{ setAddModal(null); setEditModal(null) }}>✕</button>
            </div>
            <div className="modal-body">
              <table style={{ width:'100%', borderCollapse:'collapse', fontSize:'0.85rem' }}>
                <tbody>
                  {[
                    ['발전소', <select style={IS} value={form.plantId} onChange={e=>setForm(p=>({...p,plantId:e.target.value}))} disabled={!!editModal}>
                      <option value="">선택</option>
                      {sites.map(s=><option key={s.id} value={s.id}>{s.name.replace(/\[.*?\]\s*/,'')}</option>)}
                    </select>],
                    ['유형', <select style={IS} value={form.type} onChange={e=>setForm(p=>({...p,type:e.target.value}))}>
                      {TYPES.map(t=><option key={t} value={t}>{t}</option>)}
                    </select>],
                    ['점검일', <input type="date" style={IS} value={form.inspectDate} onChange={e=>setForm(p=>({...p,inspectDate:e.target.value}))} />],
                    ['내용', <textarea style={{...IS,height:80,resize:'vertical'}} value={form.content} onChange={e=>setForm(p=>({...p,content:e.target.value}))} placeholder="점검 내용 (선택)" />],
                  ].map(([l,f])=>(
                    <tr key={l}>
                      <td style={{ width:60, padding:'6px 8px 6px 0', color:'var(--text-muted)', fontWeight:600, verticalAlign:'top', paddingTop:10 }}>{l}</td>
                      <td style={{ padding:'4px 0' }}>{f}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
            <div className="modal-footer">
              <button className="btn" onClick={()=>{ setAddModal(null); setEditModal(null) }}>취소</button>
              <button className="btn btn-primary" onClick={saveRecord}>저장</button>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}

const IS = { width:'100%', padding:'6px 8px', border:'1px solid var(--line)', borderRadius:'var(--radius-sm)', fontSize:'0.83rem', background:'var(--surface)', color:'var(--text)' }
