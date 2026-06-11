import { useState, useEffect } from 'react'
import { apiGet, apiSend } from '../api'
import PlantSidebar from '../components/PlantSidebar'

const TABS = [
  { id: 'rtu', label: '발전소 RTU' },
  { id: 'hw',  label: 'HW 버전' },
  { id: 'sw',  label: 'SW 버전' },
]
const TAB_COLOR = { rtu: '#2563eb', hw: '#7c3aed', sw: '#0891b2' }

function todayStr() { return new Date().toISOString().slice(0, 10) }

function emptyRtu() {
  return { serial: '', hwVer: '', swVer: '', lineType: '유선', ctn: '', note: '' }
}
function emptyVer() {
  return { version: '', releaseDate: todayStr(), description: '' }
}

const inputSt = {
  width: '100%', padding: '7px 9px', border: '1px solid var(--line)',
  borderRadius: 'var(--radius-sm)', fontSize: '0.82rem',
  background: 'var(--surface)', color: 'var(--text)', boxSizing: 'border-box',
}
const labelSt = {
  fontSize: '0.72rem', color: 'var(--text-muted)', fontWeight: 600, marginBottom: 3,
}

// ── 버전 카드 (HW/SW 공통) ────────────────────────────────────────────────────
function VersionPanel({ apiBase, color }) {
  const [versions, setVersions] = useState([])
  const [form, setForm]         = useState(emptyVer())
  const [editId, setEditId]     = useState(null)
  const [showAdd, setShowAdd]   = useState(false)

  useEffect(() => { load() }, [])

  function load() {
    apiGet(`/api/equipment/${apiBase}`).then(d => setVersions(d.versions || [])).catch(console.error)
  }

  function upd(k) { return e => setForm(p => ({ ...p, [k]: e.target.value })) }

  async function save() {
    if (!form.version.trim()) { alert('버전을 입력하세요.'); return }
    try {
      if (editId) {
        await apiSend(`/api/equipment/${apiBase}/${editId}`, 'PUT', form)
        setEditId(null)
      } else {
        await apiSend(`/api/equipment/${apiBase}`, 'POST', form)
        setShowAdd(false)
      }
      setForm(emptyVer())
      load()
    } catch (e) { alert(e.message) }
  }

  function startEdit(v) {
    setEditId(v.id)
    setShowAdd(false)
    setForm({ version: v.version, releaseDate: v.release_date, description: v.description || '' })
  }

  function cancelEdit() { setEditId(null); setForm(emptyVer()) }

  async function del(id) {
    if (!confirm('삭제하시겠습니까?')) return
    await apiSend(`/api/equipment/${apiBase}/${id}`, 'DELETE')
    load()
  }

  // 인라인 폼 JSX (컴포넌트로 분리하면 매 입력마다 재마운트되어 포커스 해제됨)
  const formJsx = (onCancel) => (
    <div style={{ background: 'var(--surface)', border: `1px solid ${color}`, borderRadius: 8, padding: '14px 16px', marginBottom: 12 }}>
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10, marginBottom: 10 }}>
        <div>
          <div style={labelSt}>버전</div>
          <input value={form.version} onChange={upd('version')} placeholder="예) v1.2.0" style={inputSt} />
        </div>
        <div>
          <div style={labelSt}>출시일</div>
          <input type="date" value={form.releaseDate} onChange={upd('releaseDate')} style={inputSt} />
        </div>
      </div>
      <div style={{ marginBottom: 10 }}>
        <div style={labelSt}>변경사항 · 추가기능</div>
        <textarea
          value={form.description} onChange={upd('description')}
          placeholder={"예)\n- 온도 센서 정밀도 향상\n- 무선 통신 안정화\n- 오류 로그 추가"}
          style={{ ...inputSt, height: 100, resize: 'vertical' }}
        />
      </div>
      <div style={{ display: 'flex', gap: 8, justifyContent: 'flex-end' }}>
        <button className="btn" onClick={onCancel}>취소</button>
        <button className="btn btn-primary" onClick={save}>저장</button>
      </div>
    </div>
  )

  return (
    <div style={{ padding: '20px 24px', flex: 1, minHeight: 0, overflowY: 'auto' }}>
      {/* 추가 버튼 */}
      {!showAdd && !editId && (
        <div style={{ marginBottom: 16 }}>
          <button className="btn btn-primary" onClick={() => { setShowAdd(true); setForm(emptyVer()) }}>
            + 버전 추가
          </button>
        </div>
      )}

      {/* 추가 폼 */}
      {showAdd && formJsx(() => { setShowAdd(false); setForm(emptyVer()) })}

      {/* 버전 카드 목록 */}
      {versions.length === 0 && !showAdd && (
        <div style={{ color: 'var(--text-muted)', fontSize: '0.85rem', textAlign: 'center', marginTop: 60 }}>
          등록된 버전이 없습니다.
        </div>
      )}
      {versions.map(v => (
        editId === v.id ? (
          <div key={v.id}>{formJsx(cancelEdit)}</div>
        ) : (
          <div key={v.id} style={{
            background: 'var(--surface)', border: '1px solid var(--line)',
            borderLeft: `4px solid ${color}`,
            borderRadius: 8, padding: '14px 16px', marginBottom: 12,
          }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 12, marginBottom: v.description ? 10 : 0 }}>
              <span style={{
                fontWeight: 800, fontSize: '1.05rem', color,
                background: color + '15', padding: '3px 10px',
                borderRadius: 6, letterSpacing: '-0.01em',
              }}>{v.version}</span>
              <span style={{ fontSize: '0.78rem', color: 'var(--text-muted)' }}>{v.release_date}</span>
              <div style={{ marginLeft: 'auto', display: 'flex', gap: 6 }}>
                <button onClick={() => startEdit(v)}
                  style={{ background: 'none', border: '1px solid var(--line)', borderRadius: 4, padding: '3px 10px', fontSize: '0.75rem', cursor: 'pointer', color: 'var(--text-muted)' }}>
                  수정
                </button>
                <button onClick={() => del(v.id)}
                  style={{ background: 'none', border: '1px solid #fca5a5', borderRadius: 4, padding: '3px 10px', fontSize: '0.75rem', cursor: 'pointer', color: '#dc2626' }}>
                  삭제
                </button>
              </div>
            </div>
            {v.description && (
              <div style={{
                fontSize: '0.82rem', color: 'var(--text)', whiteSpace: 'pre-wrap',
                lineHeight: 1.7, paddingLeft: 4,
                borderTop: '1px solid var(--line)', paddingTop: 10,
              }}>
                {v.description}
              </div>
            )}
          </div>
        )
      ))}
    </div>
  )
}

// ── RTU 탭 ────────────────────────────────────────────────────────────────────
function RtuPanel() {
  const [rtuList, setRtuList]   = useState([])
  const [selPlant, setSelPlant] = useState(null)
  const [form, setForm]         = useState(emptyRtu())
  const [saving, setSaving]     = useState(false)

  useEffect(() => { load() }, [])

  function load() {
    apiGet('/api/equipment/rtu').then(d => setRtuList(d.rtu || [])).catch(console.error)
  }

  function select(row) {
    setSelPlant(row)
    setForm({
      serial:   row.serial   || '',
      hwVer:    row.hw_ver   || '',
      swVer:    row.sw_ver   || '',
      lineType: row.line_type || '유선',
      ctn:      row.ctn      || '',
      note:     row.note     || '',
    })
  }

  async function save() {
    if (!selPlant) return
    setSaving(true)
    try {
      await apiSend(`/api/equipment/rtu/${selPlant.plant_id}`, 'PUT', form)
      setTimeout(() => {
        apiGet('/api/equipment/rtu').then(d => {
          const updated = (d.rtu || []).find(r => r.plant_id === selPlant.plant_id)
          if (updated) setSelPlant(updated)
          setRtuList(d.rtu || [])
        })
      }, 200)
    } catch (e) { alert(e.message) }
    setSaving(false)
  }

  return (
    <div style={{ display: 'flex', flex: 1, minHeight: 0 }}>
      {/* 발전소 목록 */}
      <PlantSidebar
        items={rtuList}
        getKey={r => r.plant_id}
        getName={r => r.plant_name}
        selectedKey={selPlant?.plant_id ?? null}
        onSelect={r => r && select(r)}
        renderBadge={(r, isSel) => r.rtu_id ? (
          <span style={{
            fontSize: '0.62rem', padding: '1px 5px', borderRadius: 8, flexShrink: 0,
            background: isSel ? 'rgba(255,255,255,0.25)' : '#d1fae5',
            color: isSel ? '#fff' : '#065f46', fontWeight: 700,
          }}>등록</span>
        ) : null}
      />

      {/* RTU 편집 영역 */}
      {!selPlant ? (
        <div style={{ flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'center', color: 'var(--text-muted)', fontSize: '0.9rem' }}>
          왼쪽에서 발전소를 선택하세요.
        </div>
      ) : (
        <div style={{ flex: 1, padding: '20px 24px', overflowY: 'auto' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 12, marginBottom: 20 }}>
            <h2 style={{ margin: 0, fontSize: '1rem', fontWeight: 700, color: 'var(--navy)' }}>
              {selPlant.plant_name.replace(/\[.*?\]\s*/, '')}
            </h2>
            <span style={{ fontSize: '0.78rem', color: 'var(--text-muted)' }}>{selPlant.region}</span>
            {selPlant.updated_at && (
              <span style={{ fontSize: '0.72rem', color: 'var(--text-muted)', marginLeft: 'auto' }}>
                최종수정: {selPlant.updated_by} · {String(selPlant.updated_at).slice(0, 16)}
              </span>
            )}
          </div>

          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: 12, marginBottom: 12 }}>
            <div>
              <div style={labelSt}>시리얼넘버</div>
              <input value={form.serial} onChange={e => setForm(p => ({ ...p, serial: e.target.value }))}
                placeholder="예) SN-123456" style={inputSt} />
            </div>
            <div>
              <div style={labelSt}>하드웨어 버전</div>
              <input value={form.hwVer} onChange={e => setForm(p => ({ ...p, hwVer: e.target.value }))}
                placeholder="예) v1.2" style={inputSt} />
            </div>
            <div>
              <div style={labelSt}>소프트웨어 버전</div>
              <input value={form.swVer} onChange={e => setForm(p => ({ ...p, swVer: e.target.value }))}
                placeholder="예) v3.0.1" style={inputSt} />
            </div>
            <div>
              <div style={labelSt}>유선 / 무선</div>
              <select value={form.lineType} onChange={e => setForm(p => ({ ...p, lineType: e.target.value }))} style={inputSt}>
                <option value="유선">유선</option>
                <option value="무선">무선</option>
              </select>
            </div>
            {form.lineType === '무선' && (
              <div>
                <div style={labelSt}>CTN번호</div>
                <input value={form.ctn} onChange={e => setForm(p => ({ ...p, ctn: e.target.value }))}
                  placeholder="예) 010-1234-5678" style={inputSt} />
              </div>
            )}
          </div>

          <div style={{ marginBottom: 16 }}>
            <div style={labelSt}>비고</div>
            <textarea value={form.note} onChange={e => setForm(p => ({ ...p, note: e.target.value }))}
              placeholder="추가 정보 입력"
              style={{ ...inputSt, height: 80, resize: 'vertical' }} />
          </div>

          <button className="btn btn-primary" onClick={save} disabled={saving}
            style={{ padding: '8px 24px' }}>
            {saving ? '저장 중...' : '저장'}
          </button>
        </div>
      )}
    </div>
  )
}

// ── 메인 컴포넌트 ─────────────────────────────────────────────────────────────
export default function SafetyEquipment() {
  const [activeTab, setActiveTab] = useState('rtu')

  return (
    <div className="wrap-fill" style={{ display: 'flex', flexDirection: 'column', padding: 0, overflow: 'hidden' }}>

      {/* 탭 바 (책갈피 스타일) */}
      <div style={{
        display: 'flex', alignItems: 'flex-end', gap: 0,
        borderBottom: '2px solid var(--line)',
        background: 'var(--surface)', padding: '0 24px', flexShrink: 0,
      }}>
        {TABS.map(tab => {
          const active = activeTab === tab.id
          return (
            <button key={tab.id} type="button"
              onClick={() => setActiveTab(tab.id)}
              style={{
                padding: '12px 22px 10px',
                border: 'none', background: 'transparent', cursor: 'pointer',
                fontWeight: active ? 700 : 500,
                fontSize: '0.88rem',
                color: active ? TAB_COLOR[tab.id] : 'var(--text-muted)',
                borderBottom: active
                  ? `3px solid ${TAB_COLOR[tab.id]}`
                  : '3px solid transparent',
                marginBottom: -2,
                transition: 'color 0.15s, border-color 0.15s',
                whiteSpace: 'nowrap',
              }}>
              {tab.label}
            </button>
          )
        })}

        <div style={{ marginLeft: 'auto', display: 'flex', alignItems: 'center', paddingBottom: 8 }}>
          <span style={{ fontSize: '0.75rem', color: 'var(--text-muted)' }}>
            RTU(다르고스) 장비 관리
          </span>
        </div>
      </div>

      {/* 탭 콘텐츠 */}
      <div style={{ flex: 1, minHeight: 0, display: 'flex', flexDirection: 'column', overflow: 'hidden' }}>
        {activeTab === 'rtu' && <RtuPanel />}
        {activeTab === 'hw'  && <VersionPanel apiBase="hw-versions"  color={TAB_COLOR.hw} />}
        {activeTab === 'sw'  && <VersionPanel apiBase="sw-versions"  color={TAB_COLOR.sw} />}
      </div>
    </div>
  )
}
