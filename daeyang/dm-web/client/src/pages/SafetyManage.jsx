import { useState, useEffect } from 'react'
import { apiGet, apiSend, formatNum } from '../api'
import PlantSidebar from '../components/PlantSidebar'

const TYPES = ['안전관리', 'A/S', '정기점검', '안전교육', '기타']
const TYPE_COLOR = {
  '안전관리': '#2563eb', 'A/S': '#dc2626',
  '정기점검': '#16a34a', '안전교육': '#d97706', '기타': '#7c3aed',
}
const AS_SUB_COLOR = { '다르고스': '#7c3aed', '인버터': '#0891b2' }

function todayStr() { return new Date().toISOString().slice(0, 10) }

function emptyForm() {
  return {
    type: '안전관리', inspectDate: todayStr(), content: '',
    asType: '다르고스',
    // 다르고스
    serial: '', hwVer: '', swVer: '', lineType: '유선', ctn: '',
    // 인버터
    invIdx: '', invBrand: '', invName: '', invModel: '',
  }
}

function parseAsContent(raw) {
  try {
    const d = JSON.parse(raw)
    if (!d || typeof d !== 'object') return null
    if (d.asType || d.serial !== undefined || d.hwVer !== undefined ||
        d.invBrand !== undefined || d.invName !== undefined) return d
  } catch {}
  return null
}

const inputSt = {
  width: '100%', padding: '6px 8px', border: '1px solid var(--line)',
  borderRadius: 'var(--radius-sm)', fontSize: '0.8rem',
  background: 'var(--surface)', color: 'var(--text)', boxSizing: 'border-box',
}
const labelSt = { fontSize: '0.72rem', color: 'var(--text-muted)', marginBottom: 3, fontWeight: 600 }

export default function SafetyManage() {
  const [sites, setSites]           = useState([])
  const [selSite, setSelSite]       = useState(null)
  const [siteDetail, setSiteDetail] = useState(null)
  const [records, setRecords]       = useState([])
  const [form, setForm]             = useState(emptyForm())
  const [editId, setEditId]         = useState(null)

  useEffect(() => {
    apiGet('/api/sites').then(d => setSites(d.sites || [])).catch(console.error)
  }, [])

  useEffect(() => {
    if (!selSite) return
    apiGet(`/api/sites/${selSite.id}`).then(d => setSiteDetail(d)).catch(console.error)
    loadRecords()
  }, [selSite])

  function loadRecords() {
    apiGet(`/api/safety/plant/${selSite.id}?year=0&month=0`)
      .then(d => setRecords(d.records || []))
      .catch(console.error)
  }

  // 인버터 이름 선택 시 브랜드·모델 자동 채움
  function handleInvSelect(name) {
    if (!name) {
      setForm(p => ({ ...p, invName: '', invBrand: '', invModel: '' }))
      return
    }
    const inv = inverters.find(v => (v.name || '') === name)
    setForm(p => ({
      ...p,
      invName:  name,
      invBrand: site?.invBrand || '',
      invModel: inv?.model || '',
    }))
  }

  async function submit() {
    if (!form.inspectDate) { alert('날짜를 입력하세요.'); return }
    let content = form.content

    if (form.type === 'A/S') {
      if (form.asType === '다르고스') {
        content = JSON.stringify({
          asType: '다르고스',
          serial: form.serial, hwVer: form.hwVer, swVer: form.swVer,
          lineType: form.lineType,
          ctn: form.lineType === '무선' ? form.ctn : '',
          note: form.content,
        })
      } else {
        if (!form.invName) { alert('인버터를 선택하세요.'); return }
        content = JSON.stringify({
          asType: '인버터',
          invBrand: form.invBrand, invName: form.invName, invModel: form.invModel,
          note: form.content,
        })
      }
    } else if (!form.content.trim()) {
      alert('내용을 입력하세요.'); return
    }

    try {
      if (editId) {
        await apiSend(`/api/safety/records/${editId}`, 'PUT', { type: form.type, content })
        setEditId(null)
      } else {
        await apiSend('/api/safety/records', 'POST', {
          plantId: selSite.id, type: form.type,
          inspectDate: form.inspectDate, content,
        })
      }
      setForm(emptyForm())
      loadRecords()
    } catch (e) { alert(e.message) }
  }

  async function del(id) {
    if (!confirm('이 기록을 삭제할까요?')) return
    await apiSend(`/api/safety/records/${id}`, 'DELETE')
    loadRecords()
  }

  function startEdit(r) {
    const base = { ...emptyForm(), type: r.type, inspectDate: r.inspect_date }
    if (r.type === 'A/S') {
      const parsed = parseAsContent(r.content || '')
      if (parsed) {
        const sub = parsed.asType || (parsed.invBrand !== undefined ? '인버터' : '다르고스')
        base.asType = sub
        if (sub === '인버터') {
          base.invBrand = parsed.invBrand || ''
          base.invName  = parsed.invName  || ''
          base.invModel = parsed.invModel || ''
          base.invIdx   = ''
          base.content  = parsed.note || ''
        } else {
          base.serial   = parsed.serial   || ''
          base.hwVer    = parsed.hwVer    || ''
          base.swVer    = parsed.swVer    || ''
          base.lineType = parsed.lineType || '유선'
          base.ctn      = parsed.ctn      || ''
          base.content  = parsed.note     || ''
        }
      } else {
        base.content = r.content || ''
      }
    } else {
      base.content = r.content || ''
    }
    setForm(base)
    setEditId(r.id)
  }

  const site      = siteDetail?.site || selSite
  const inverters = siteDetail?.inverters || []
  const sorted    = [...records].reverse()

  return (
    <div className="wrap-fill" style={{ display: 'flex', flexDirection: 'row', padding: 0, overflow: 'hidden', background: 'var(--bg)' }}>

      {/* ── 왼쪽: 발전소 목록 ── */}
      <PlantSidebar
        items={sites}
        selectedKey={selSite?.id ?? null}
        onSelect={s => { setSelSite(s); setEditId(null); setForm(emptyForm()) }}
      />

      {/* ── 오른쪽 ── */}
      {!selSite ? (
        <div style={{ flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'center', color: 'var(--text-muted)', fontSize: '0.9rem' }}>
          왼쪽에서 발전소를 선택하세요.
        </div>
      ) : (
        <div style={{ flex: 1, display: 'flex', flexDirection: 'column', overflow: 'hidden', minWidth: 0 }}>

          {/* ① 발전소 정보 */}
          <div style={{ flexShrink: 0, padding: '14px 20px', background: 'var(--surface)', borderBottom: '1px solid var(--line)' }}>
            <div style={{ display: 'flex', alignItems: 'flex-start', gap: 20 }}>
              <div style={{ flex: 1 }}>
                <div style={{ fontWeight: 700, fontSize: '1rem', color: 'var(--navy)', marginBottom: 8 }}>
                  {site?.name?.replace(/\[.*?\]\s*/, '')}
                </div>
                <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3,1fr)', gap: '4px 16px', fontSize: '0.8rem' }}>
                  {[
                    ['지역',      site?.region || '—'],
                    ['주소',      site?.address?.replace(/^\d{5}\s*/, '') || '—'],
                    ['설비용량',  site?.capacityKw ? `${formatNum(site.capacityKw, 1)} kW` : '—'],
                    ['인버터',    site?.invBrand || '—'],
                    ['인버터 수', site?.inverterCount ? `${site.inverterCount}대` : '—'],
                    ['최종수신',  site?.lastReceivedAt || '—'],
                  ].map(([l, v]) => (
                    <div key={l} style={{ display: 'flex', gap: 6 }}>
                      <span style={{ color: 'var(--text-muted)', flexShrink: 0 }}>{l}</span>
                      <span style={{ fontWeight: 500, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>{v}</span>
                    </div>
                  ))}
                </div>
              </div>
              <div style={{ textAlign: 'right', flexShrink: 0 }}>
                <div style={{ fontSize: '0.75rem', color: 'var(--text-muted)' }}>총 기록</div>
                <div style={{ fontSize: '1.4rem', fontWeight: 700, color: 'var(--navy)' }}>{records.length}</div>
              </div>
            </div>
          </div>

          {/* ② 입력 폼 */}
          <div style={{ flexShrink: 0, padding: '12px 20px', background: '#f8fafc', borderBottom: '2px solid var(--line)' }}>
            {editId && (
              <div style={{ fontSize: '0.78rem', color: '#d97706', fontWeight: 600, marginBottom: 8 }}>
                ✏️ 수정 중 —{' '}
                <button onClick={() => { setEditId(null); setForm(emptyForm()) }}
                  style={{ background: 'none', border: 'none', cursor: 'pointer', color: '#dc2626', fontSize: '0.75rem' }}>
                  취소
                </button>
              </div>
            )}

            {/* 유형 + A/S 토글(인라인) + 날짜 */}
            <div style={{ display: 'flex', gap: 8, marginBottom: 8, alignItems: 'center' }}>
              <select value={form.type}
                onChange={e => setForm(p => ({ ...p, type: e.target.value }))}
                style={{ padding: '6px 8px', border: '1px solid var(--line)', borderRadius: 'var(--radius-sm)', fontSize: '0.8rem', background: 'var(--surface)', color: 'var(--text)' }}>
                {TYPES.map(t => <option key={t} value={t}>{t}</option>)}
              </select>

              {/* A/S 하위 토글 — A/S 선택 시만 표시 */}
              {form.type === 'A/S' && (
                <div style={{ display: 'flex', gap: 0, borderRadius: 'var(--radius-sm)', overflow: 'hidden', border: '1px solid var(--line)', flexShrink: 0 }}>
                  {['다르고스', '인버터'].map(sub => (
                    <button key={sub} type="button"
                      onClick={() => setForm(p => ({ ...p, asType: sub }))}
                      style={{
                        padding: '5px 16px', border: 'none', cursor: 'pointer', fontSize: '0.82rem', fontWeight: 600,
                        background: form.asType === sub ? AS_SUB_COLOR[sub] : 'var(--surface)',
                        color: form.asType === sub ? '#fff' : 'var(--text-muted)',
                        transition: 'background 0.15s',
                      }}>
                      {sub}
                    </button>
                  ))}
                </div>
              )}

              <input type="date" value={form.inspectDate}
                onChange={e => setForm(p => ({ ...p, inspectDate: e.target.value }))}
                disabled={!!editId}
                style={{ padding: '6px 8px', border: '1px solid var(--line)', borderRadius: 'var(--radius-sm)', fontSize: '0.8rem', background: editId ? 'var(--bg)' : 'var(--surface)', color: 'var(--text)' }}
              />
            </div>

            {/* A/S 전용 영역 */}
            {form.type === 'A/S' && (
              <div style={{ marginBottom: 8 }}>
                {/* 다르고스 필드 */}
                {form.asType === '다르고스' && (
                  <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 8 }}>
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
                      <div style={{ gridColumn: 'span 2' }}>
                        <div style={labelSt}>CTN번호</div>
                        <input value={form.ctn} onChange={e => setForm(p => ({ ...p, ctn: e.target.value }))}
                          placeholder="예) 010-1234-5678" style={inputSt} />
                      </div>
                    )}
                  </div>
                )}

                {/* 인버터 필드 */}
                {form.asType === '인버터' && (
                  <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 8 }}>
                    <div>
                      <div style={labelSt}>인버터 이름 (호기)</div>
                      {inverters.length > 0 ? (
                        <select value={form.invName} onChange={e => handleInvSelect(e.target.value)} style={inputSt}>
                          <option value="">— 선택 —</option>
                          {inverters.map((inv, i) => (
                            <option key={i} value={inv.name || `인버터 ${i + 1}`}>
                              {inv.name || `인버터 ${i + 1}`}
                            </option>
                          ))}
                        </select>
                      ) : (
                        <input value={form.invName} onChange={e => setForm(p => ({ ...p, invName: e.target.value }))}
                          placeholder="예) INV-01" style={inputSt} />
                      )}
                    </div>
                    <div>
                      <div style={labelSt}>인버터 브랜드</div>
                      <input value={form.invBrand} onChange={e => setForm(p => ({ ...p, invBrand: e.target.value }))}
                        placeholder="예) SMA" style={inputSt} />
                    </div>
                    <div>
                      <div style={labelSt}>인버터 모델</div>
                      <input value={form.invModel} onChange={e => setForm(p => ({ ...p, invModel: e.target.value }))}
                        placeholder="예) SG125HX" style={inputSt} />
                    </div>
                  </div>
                )}
              </div>
            )}

            {/* 내용 + 저장 */}
            <div style={{ display: 'flex', gap: 8 }}>
              <textarea
                value={form.content}
                onChange={e => setForm(p => ({ ...p, content: e.target.value }))}
                onKeyDown={e => { if (e.key === 'Enter' && (e.ctrlKey || e.metaKey)) submit() }}
                placeholder={form.type === 'A/S' ? '추가 내용 (선택) — Ctrl+Enter로 저장' : '내용을 입력하세요 — Ctrl+Enter로 저장'}
                style={{ flex: 1, padding: '8px 10px', border: '1px solid var(--line)', borderRadius: 'var(--radius-sm)', fontSize: '0.83rem', resize: 'none', height: 60, background: 'var(--surface)', color: 'var(--text)' }}
              />
              <button className="btn btn-primary" onClick={submit}
                style={{ height: 60, padding: '0 20px', fontSize: '0.85rem' }}>
                {editId ? '수정' : '저장'}
              </button>
            </div>
          </div>

          {/* ③ 이력 목록 */}
          <div style={{ flex: 1, minHeight: 0, overflowY: 'auto', padding: '16px 20px', display: 'flex', flexDirection: 'column', gap: 10 }}>
            {sorted.length === 0 ? (
              <div style={{ color: 'var(--text-muted)', fontSize: '0.85rem', textAlign: 'center', marginTop: 40 }}>
                등록된 이력이 없습니다.
              </div>
            ) : sorted.map(r => {
              const asData = r.type === 'A/S' ? parseAsContent(r.content || '') : null
              const sub    = asData?.asType || (asData?.invBrand !== undefined ? '인버터' : asData ? '다르고스' : null)
              return (
                <div key={r.id} style={{ display: 'flex', gap: 10 }}>
                  {/* 뱃지 */}
                  <div style={{ flexShrink: 0, paddingTop: 2, display: 'flex', flexDirection: 'column', gap: 4, alignItems: 'flex-end' }}>
                    <span style={{
                      display: 'inline-block', padding: '3px 8px', borderRadius: 10,
                      fontSize: '0.7rem', fontWeight: 700, color: '#fff',
                      background: TYPE_COLOR[r.type] || '#64748b',
                    }}>{r.type}</span>
                    {sub && (
                      <span style={{
                        display: 'inline-block', padding: '2px 7px', borderRadius: 10,
                        fontSize: '0.67rem', fontWeight: 700, color: '#fff',
                        background: AS_SUB_COLOR[sub] || '#64748b',
                      }}>{sub}</span>
                    )}
                  </div>

                  {/* 말풍선 */}
                  <div style={{ flex: 1, background: 'var(--surface)', border: '1px solid var(--line)', borderRadius: '0 8px 8px 8px', padding: '8px 12px' }}>
                    <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 6 }}>
                      <span style={{ fontWeight: 700, fontSize: '0.85rem', color: 'var(--navy)' }}>{r.inspect_date}</span>
                      <span style={{ fontSize: '0.72rem', color: 'var(--text-muted)' }}>{r.created_by || '—'}</span>
                      <div style={{ marginLeft: 'auto', display: 'flex', gap: 4 }}>
                        <button onClick={() => startEdit(r)} style={{ background: 'none', border: 'none', cursor: 'pointer', fontSize: '0.72rem', color: 'var(--text-muted)', padding: '1px 4px' }}>수정</button>
                        <button onClick={() => del(r.id)} style={{ background: 'none', border: 'none', cursor: 'pointer', fontSize: '0.72rem', color: '#dc2626', padding: '1px 4px' }}>삭제</button>
                      </div>
                    </div>

                    {/* 다르고스 표시 */}
                    {asData && sub !== '인버터' && (
                      <>
                        <div style={{ display: 'grid', gridTemplateColumns: 'auto 1fr auto 1fr', gap: '4px 16px', fontSize: '0.8rem', padding: '6px 10px', background: '#f8fafc', borderRadius: 6, border: '1px solid var(--line)', marginBottom: asData.note ? 6 : 0 }}>
                          <span style={{ color: 'var(--text-muted)', fontWeight: 500 }}>시리얼넘버</span>
                          <span style={{ fontWeight: 600, color: 'var(--navy)' }}>{asData.serial || '—'}</span>
                          <span style={{ color: 'var(--text-muted)', fontWeight: 500 }}>HW 버전</span>
                          <span style={{ fontWeight: 600, color: 'var(--navy)' }}>{asData.hwVer || '—'}</span>
                          <span style={{ color: 'var(--text-muted)', fontWeight: 500 }}>SW 버전</span>
                          <span style={{ fontWeight: 600, color: 'var(--navy)' }}>{asData.swVer || '—'}</span>
                          <span style={{ color: 'var(--text-muted)', fontWeight: 500 }}>연결방식</span>
                          <span style={{ fontWeight: 600, color: 'var(--navy)' }}>
                            {asData.lineType || '—'}
                            {asData.lineType === '무선' && asData.ctn ? ` / CTN: ${asData.ctn}` : ''}
                          </span>
                        </div>
                        {asData.note && <div style={{ fontSize: '0.83rem', color: 'var(--text)', whiteSpace: 'pre-wrap', paddingTop: 4 }}>{asData.note}</div>}
                      </>
                    )}

                    {/* 인버터 표시 */}
                    {asData && sub === '인버터' && (
                      <>
                        <div style={{ display: 'grid', gridTemplateColumns: 'auto 1fr auto 1fr', gap: '4px 16px', fontSize: '0.8rem', padding: '6px 10px', background: '#f0f9ff', borderRadius: 6, border: '1px solid #bae6fd', marginBottom: asData.note ? 6 : 0 }}>
                          <span style={{ color: 'var(--text-muted)', fontWeight: 500 }}>브랜드</span>
                          <span style={{ fontWeight: 600, color: 'var(--navy)' }}>{asData.invBrand || '—'}</span>
                          <span style={{ color: 'var(--text-muted)', fontWeight: 500 }}>인버터 이름</span>
                          <span style={{ fontWeight: 600, color: 'var(--navy)' }}>{asData.invName || '—'}</span>
                          <span style={{ color: 'var(--text-muted)', fontWeight: 500 }}>모델</span>
                          <span style={{ fontWeight: 600, color: 'var(--navy)' }}>{asData.invModel || '—'}</span>
                        </div>
                        {asData.note && <div style={{ fontSize: '0.83rem', color: 'var(--text)', whiteSpace: 'pre-wrap', paddingTop: 4 }}>{asData.note}</div>}
                      </>
                    )}

                    {/* 일반 텍스트 */}
                    {!asData && (
                      <div style={{ fontSize: '0.83rem', color: r.content ? 'var(--text)' : 'var(--text-muted)', whiteSpace: 'pre-wrap' }}>
                        {r.content || '(내용 없음)'}
                      </div>
                    )}
                  </div>
                </div>
              )
            })}
          </div>

        </div>
      )}
    </div>
  )
}
