import { useState, useEffect, useRef } from 'react'
import { apiGet, apiSend, formatNum } from '../../api'

// 주소 검색 컴포넌트 (검색 → 주소+좌표 동시 반환)
function AddressSearch({ value, onSelect }) {
  const [query, setQuery] = useState('')
  const [items, setItems] = useState([])
  const [open, setOpen] = useState(false)
  const [rect, setRect] = useState(null)
  const [loading, setLoading] = useState(false)
  const wrapRef = useRef(null)
  const listRef = useRef(null)
  const timerRef = useRef(null)

  useEffect(() => {
    function handler(e) {
      if (
        wrapRef.current && !wrapRef.current.contains(e.target) &&
        listRef.current && !listRef.current.contains(e.target)
      ) setOpen(false)
    }
    document.addEventListener('mousedown', handler)
    return () => document.removeEventListener('mousedown', handler)
  }, [])

  function handleChange(e) {
    const q = e.target.value
    setQuery(q)
    const r = wrapRef.current?.getBoundingClientRect()
    if (r) setRect(r)
    clearTimeout(timerRef.current)
    if (!q.trim()) { setItems([]); setOpen(false); return }
    timerRef.current = setTimeout(async () => {
      setLoading(true)
      try {
        const res = await fetch(`/api/address-search?q=${encodeURIComponent(q)}`, { credentials: 'include' })
        const d = await res.json()
        setItems(d.items || [])
        if (d.items?.length) setOpen(true)
      } catch { setItems([]) }
      setLoading(false)
    }, 300)
  }

  function select(item) {
    onSelect(item)
    setQuery('')
    setItems([])
    setOpen(false)
  }

  return (
    <div ref={wrapRef} style={{ position: 'relative', width: '100%' }}>
      <div style={{ display: 'flex', gap: 6 }}>
        <input
          value={open || !value ? query : value}
          onChange={handleChange}
          onFocus={() => { if (items.length) setOpen(true) }}
          placeholder="주소 검색 (예: 나주시 빛가람로)"
          style={{ flex: 1 }}
        />
        {loading && <span style={{ alignSelf: 'center', fontSize: '0.75rem', color: '#94a3b8' }}>검색중...</span>}
      </div>
      {open && rect && items.length > 0 && (
        <ul ref={listRef} style={{
          position: 'fixed', top: rect.bottom + 2, left: rect.left, width: rect.width,
          zIndex: 9999, background: '#fff', border: '1px solid #cbd5e1', borderRadius: 4,
          maxHeight: 220, overflowY: 'auto', margin: 0, padding: 0,
          listStyle: 'none', boxShadow: '0 6px 16px rgba(0,0,0,0.12)',
        }}>
          {items.map((item, i) => (
            <li key={i} onMouseDown={() => select(item)}
              style={{ padding: '8px 12px', fontSize: '0.82rem', cursor: 'pointer', borderBottom: '1px solid #f1f5f9' }}
              onMouseEnter={(e) => e.currentTarget.style.background = '#f1f5f9'}
              onMouseLeave={(e) => e.currentTarget.style.background = 'transparent'}
            >
              {item.address}
            </li>
          ))}
        </ul>
      )}
    </div>
  )
}

// 통합 드롭다운 컴포넌트
// options: [{ value, label }] 또는 문자열 배열
// searchable: true이면 검색 입력창 포함
function AppSelect({ value, options = [], placeholder = '선택', searchable = false, onChange, emptyLabel }) {
  const [query, setQuery] = useState('')
  const [open, setOpen] = useState(false)
  const [rect, setRect] = useState(null)
  const wrapRef = useRef(null)
  const listRef = useRef(null)
  const searchRef = useRef(null)

  useEffect(() => {
    function handler(e) {
      if (
        wrapRef.current && !wrapRef.current.contains(e.target) &&
        listRef.current && !listRef.current.contains(e.target)
      ) { setOpen(false); setQuery('') }
    }
    document.addEventListener('mousedown', handler)
    return () => document.removeEventListener('mousedown', handler)
  }, [])

  // options 정규화: string[] → {value, label}[]
  const opts = options.map((o) => typeof o === 'string' ? { value: o, label: o } : o)
  const selected = opts.find((o) => String(o.value) === String(value))
  const displayLabel = selected?.label || ''

  const filtered = searchable && query
    ? opts.filter((o) => o.label.includes(query))
    : opts

  function toggle() {
    if (open) { setOpen(false); setQuery(''); return }
    const r = wrapRef.current?.getBoundingClientRect()
    if (r) setRect(r)
    setOpen(true)
    if (searchable) setTimeout(() => searchRef.current?.focus(), 30)
  }

  function select(opt) {
    onChange(opt ? opt.value : '')
    setOpen(false)
    setQuery('')
  }

  const CHEVRON = (
    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5"
      strokeLinecap="round" strokeLinejoin="round" style={{ flexShrink: 0, color: '#94a3b8', transform: open ? 'rotate(180deg)' : 'none', transition: 'transform .15s' }}>
      <polyline points="6 9 12 15 18 9" />
    </svg>
  )

  return (
    <div ref={wrapRef} style={{ position: 'relative', width: '100%' }}>
      {/* 트리거 */}
      <div
        onClick={toggle}
        style={{
          display: 'flex', alignItems: 'center', gap: 6,
          border: '1px solid #cbd5e1', borderRadius: 4,
          background: '#fff', cursor: 'pointer',
          padding: '5px 8px', fontSize: '0.82rem',
          color: displayLabel ? '#1e293b' : '#aaa',
          userSelect: 'none', minHeight: 30,
        }}
      >
        <span style={{ flex: 1, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
          {displayLabel || placeholder}
        </span>
        {CHEVRON}
      </div>

      {/* 드롭다운 리스트 */}
      {open && rect && (
        <ul ref={listRef} style={{
          position: 'fixed', top: rect.bottom + 2, left: rect.left, width: rect.width,
          zIndex: 9999, background: '#fff', border: '1px solid #cbd5e1', borderRadius: 4,
          maxHeight: 220, overflowY: 'auto', margin: 0, padding: 0,
          listStyle: 'none', boxShadow: '0 6px 16px rgba(0,0,0,0.12)',
        }}>
          {/* 검색창 */}
          {searchable && (
            <li style={{ padding: '6px 8px', borderBottom: '1px solid #e2e8f0', position: 'sticky', top: 0, background: '#fff', zIndex: 1 }}>
              <input
                ref={searchRef}
                value={query}
                onChange={(e) => setQuery(e.target.value)}
                placeholder="검색..."
                style={{ width: '100%', border: '1px solid #cbd5e1', borderRadius: 3, padding: '4px 8px', fontSize: '0.8rem', outline: 'none', boxSizing: 'border-box' }}
              />
            </li>
          )}
          {/* 빈 항목 */}
          {emptyLabel && (
            <li
              onMouseDown={() => select(null)}
              style={{ padding: '7px 12px', fontSize: '0.82rem', cursor: 'pointer', color: '#94a3b8', borderBottom: '1px solid #f1f5f9' }}
              onMouseEnter={(e) => e.currentTarget.style.background = '#f8fafc'}
              onMouseLeave={(e) => e.currentTarget.style.background = 'transparent'}
            >{emptyLabel}</li>
          )}
          {/* 옵션 목록 */}
          {filtered.length === 0 ? (
            <li style={{ padding: '10px 12px', color: '#94a3b8', fontSize: '0.82rem', textAlign: 'center' }}>결과 없음</li>
          ) : filtered.map((o, i) => {
            const isSelected = String(o.value) === String(value)
            return (
              <li key={i} onMouseDown={() => select(o)}
                style={{
                  padding: '7px 12px', fontSize: '0.82rem', cursor: 'pointer',
                  background: isSelected ? '#eff6ff' : 'transparent',
                  color: isSelected ? '#1e40af' : '#1e293b',
                  display: 'flex', alignItems: 'center', justifyContent: 'space-between',
                }}
                onMouseEnter={(e) => { if (!isSelected) e.currentTarget.style.background = '#f1f5f9' }}
                onMouseLeave={(e) => { e.currentTarget.style.background = isSelected ? '#eff6ff' : 'transparent' }}
              >
                {o.label}
                {isSelected && <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="#1e40af" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round"><polyline points="20 6 9 17 4 12"/></svg>}
              </li>
            )
          })}
        </ul>
      )}
    </div>
  )
}

const REGIONS = [
  // 특별·광역시
  '서울특별시', '부산광역시', '대구광역시', '인천광역시', '광주광역시',
  '대전광역시', '울산광역시', '세종특별자치시',
  // 경기도
  '수원시', '성남시', '고양시', '용인시', '부천시', '안산시', '안양시',
  '남양주시', '화성시', '평택시', '의정부시', '시흥시', '파주시', '광명시',
  '김포시', '광주시', '군포시', '오산시', '이천시', '양주시', '구리시',
  '안성시', '포천시', '의왕시', '하남시', '여주시', '동두천시', '과천시',
  '양평군', '가평군', '연천군',
  // 강원특별자치도
  '춘천시', '원주시', '강릉시', '동해시', '태백시', '속초시', '삼척시',
  '홍천군', '횡성군', '영월군', '평창군', '정선군', '철원군', '화천군',
  '양구군', '인제군', '고성군(강원)', '양양군',
  // 충청북도
  '청주시', '충주시', '제천시', '보은군', '옥천군', '영동군', '증평군',
  '진천군', '괴산군', '음성군', '단양군',
  // 충청남도
  '천안시', '공주시', '보령시', '아산시', '서산시', '논산시', '계룡시',
  '당진시', '금산군', '부여군', '서천군', '청양군', '홍성군', '예산군', '태안군',
  // 전북특별자치도
  '전주시', '군산시', '익산시', '정읍시', '남원시', '김제시', '완주군',
  '진안군', '무주군', '장수군', '임실군', '순창군', '고창군', '부안군',
  // 전라남도
  '목포시', '여수시', '순천시', '나주시', '광양시', '담양군', '곡성군',
  '구례군', '고흥군', '보성군', '화순군', '장흥군', '강진군', '해남군',
  '영암군', '무안군', '함평군', '영광군', '장성군', '완도군', '진도군', '신안군',
  // 경상북도
  '포항시', '경주시', '김천시', '안동시', '구미시', '영주시', '영천시',
  '상주시', '문경시', '경산시', '의성군', '청송군', '영양군', '영덕군',
  '청도군', '고령군', '성주군', '칠곡군', '예천군', '봉화군', '울진군', '울릉군',
  // 경상남도
  '창원시', '진주시', '통영시', '사천시', '김해시', '밀양시', '거제시',
  '양산시', '의령군', '함안군', '창녕군', '고성군(경남)', '남해군', '하동군',
  '산청군', '함양군', '거창군', '합천군',
  // 제주특별자치도
  '제주시', '서귀포시',
]


const EMPTY_FORM = {
  name: '', address: '', lat: '', lng: '',
  capacityKw: '', inverterCount: '1', gridStatus: '계통', ownerUserId: '',
}

export default function AdminPlants() {
  const [plants, setPlants] = useState([])
  const [total, setTotal] = useState(0)
  const [search, setSearch] = useState('')
  const [modal, setModal] = useState(null)
  const [form, setForm] = useState(EMPTY_FORM)
  const [invList, setInvList] = useState([])
  const [activeInvTab, setActiveInvTab] = useState(0)
  const [members, setMembers] = useState([])

  useEffect(() => {
    loadPlants()
    apiGet('/api/admin/member-options').then((d) => setMembers(d.options || [])).catch(console.error)
  }, [])

  function loadPlants(q = '') {
    const qs = q ? `?q=${encodeURIComponent(q)}` : ''
    apiGet(`/api/admin/plants${qs}`)
      .then((d) => { setPlants(d.plants || []); setTotal(d.total || 0) })
      .catch(console.error)
  }

  function openCreate() {
    setForm(EMPTY_FORM)
    setInvList([{ name: '', model: '', capacityKw: '', memo: '' }])
    setActiveInvTab(0)
    setModal({ mode: 'create' })
  }

  function openEdit(p) {
    setForm({ ...EMPTY_FORM, ...p, ownerUserId: p.ownerUserId || '' })
    setActiveInvTab(0)
    setModal({ mode: 'edit', plant: p })
    apiGet(`/api/admin/inverter-info/${p.id}`).then((d) => {
      const existing = d.inverters || []
      const detected = d.detectedNames || []
      const count = Number(p.inverterCount) || 0
      if (existing.length > 0) {
        setInvList(existing)
      } else {
        setInvList(Array.from({ length: count }, (_, i) => ({
          name: detected[i] || '', model: '', capacityKw: '', memo: '',
        })))
      }
    }).catch(() => {
      const count = Number(p.inverterCount) || 0
      setInvList(Array.from({ length: count }, () => ({ name: '', model: '', capacityKw: '', memo: '' })))
    })
  }

  function upd(key) {
    return (e) => setForm((prev) => ({ ...prev, [key]: e.target.value }))
  }

  function handleAddressSelect(item) {
    setForm((prev) => ({ ...prev, address: item.address, lat: String(item.lat), lng: String(item.lng) }))
  }

  function handleInverterCountChange(e) {
    const val = e.target.value
    setForm((prev) => ({ ...prev, inverterCount: val }))
    const n = Math.max(0, Math.min(50, Number(val) || 0))
    setInvList((prev) => {
      const next = [...prev]
      while (next.length < n) next.push({ name: '', model: '', capacityKw: '', memo: '' })
      return next.slice(0, n)
    })
    if (activeInvTab >= n) setActiveInvTab(Math.max(0, n - 1))
  }

  function updInv(idx, key) {
    return (e) => setInvList((prev) =>
      prev.map((inv, i) => i === idx ? { ...inv, [key]: e.target.value } : inv)
    )
  }

  async function handleSave() {
    try {
      let siteId
      if (modal.mode === 'create') {
        const res = await apiSend('/api/admin/plants', 'POST', form)
        siteId = res.id
      } else {
        await apiSend(`/api/admin/plants/${modal.plant.id}`, 'PUT', form)
        siteId = modal.plant.id
      }
      // 인버터 정보 저장
      if (siteId && invList.length > 0) {
        await apiSend(`/api/admin/inverter-info/${siteId}`, 'PUT', { inverters: invList })
      }
      setModal(null)
      loadPlants(search)
    } catch (err) { alert(err.message) }
  }

  const curInv = invList[activeInvTab]

  return (
    <div className="admin-panel">
      <div className="admin-panel-head">
        <span>발전소 리스트</span>
        <button type="button" className="btn-admin-primary" onClick={openCreate}>+ 발전소 등록</button>
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
              <th>번호</th><th>발전소명</th><th>지역</th>
              <th>설비용량(kW)</th><th>인버터 브랜드</th><th>인버터수량</th><th>계통</th>
            </tr>
          </thead>
          <tbody>
            {plants.length === 0 ? (
              <tr><td colSpan={6} style={{ textAlign: 'center', padding: 20, color: '#94a3b8' }}>데이터가 없습니다.</td></tr>
            ) : (
              plants.map((p) => (
                <tr key={p.id} onClick={() => openEdit(p)}>
                  <td>{p.id}</td>
                  <td>{p.name}</td>
                  <td>{p.region || '—'}</td>
                  <td>{formatNum(p.capacityKw, 1)}</td>
                  <td>{p.invBrand || '—'}</td>
                  <td>{p.inverterCount}</td>
                  <td>{p.gridStatus}</td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>

      {modal && (
        <div className="admin-modal-overlay" onClick={() => setModal(null)}>
          <div className="admin-modal wide" onClick={(e) => e.stopPropagation()}>
            <div className="admin-modal-header">
              <span>{modal.mode === 'create' ? '발전소 등록' : '발전소 수정'}</span>
              <button className="admin-modal-close" onClick={() => setModal(null)}>&times;</button>
            </div>
            <div className="admin-modal-body">

              <p className="modal-section-title">발전소 정보</p>
              <div className="pf-table">
                <div className="pf-row">
                  <div className="pf-label">발전소명 *</div>
                  <div className="pf-field"><input value={form.name || ''} onChange={upd('name')} placeholder="필수" /></div>
                </div>
                <div className="pf-row">
                  <div className="pf-label">주소</div>
                  <div className="pf-field" style={{ flex: 3 }}>
                    <AddressSearch value={form.address} onSelect={handleAddressSelect} />
                  </div>
                </div>
                <div className="pf-row">
                  <div className="pf-label">위도</div>
                  <div className="pf-field"><input value={form.lat || ''} onChange={upd('lat')} placeholder="예) 34.8118" /></div>
                  <div className="pf-label">경도</div>
                  <div className="pf-field"><input value={form.lng || ''} onChange={upd('lng')} placeholder="예) 126.4629" /></div>
                </div>
                <div className="pf-row">
                  <div className="pf-label">설비용량</div>
                  <div className="pf-field"><input value={form.capacityKw || ''} onChange={upd('capacityKw')} placeholder="kW" /></div>
                  <div className="pf-label">인버터 수</div>
                  <div className="pf-field">
                    <input type="number" min={0} max={50} value={form.inverterCount || ''} onChange={handleInverterCountChange} placeholder="입력 시 탭 생성" />
                  </div>
                </div>
                <div className="pf-row">
                  <div className="pf-label">계통</div>
                  <div className="pf-field">
                    <AppSelect
                      value={form.gridStatus || '계통'}
                      options={[{ value: '계통', label: '계통' }, { value: '미계통', label: '미계통' }]}
                      onChange={(v) => setForm((p) => ({ ...p, gridStatus: v }))}
                    />
                  </div>
                  <div className="pf-label">사용자</div>
                  <div className="pf-field">
                    <AppSelect
                      value={form.ownerUserId || ''}
                      placeholder="사용자 선택"
                      options={members.map((m) => ({ value: m.id, label: `${m.username}${m.displayName ? ` (${m.displayName})` : ''}` }))}
                      searchable emptyLabel="선택 안함"
                      onChange={(v) => setForm((p) => ({ ...p, ownerUserId: v }))}
                    />
                  </div>
                </div>
              </div>

              {/* 인버터별 탭 */}
              {invList.length > 0 && (
                <div style={{ marginTop: 16 }}>
                  <p className="modal-section-title" style={{ marginTop: 16 }}>인버터 정보</p>
                  <div className="inv-tab-bar">
                    {invList.map((inv, i) => (
                      <button
                        key={i}
                        type="button"
                        className={`inv-tab${activeInvTab === i ? ' active' : ''}`}
                        onClick={() => setActiveInvTab(i)}
                      >
                        {inv.name || `인버터 ${i + 1}`}
                      </button>
                    ))}
                  </div>
                  {curInv && (
                    <div className="inv-tab-body">
                      <div className="pf-table">
                        <div className="pf-row">
                          <div className="pf-label">인버터명</div>
                          <div className="pf-field"><input value={curInv.name} onChange={updInv(activeInvTab, 'name')} placeholder="예) INV-01" /></div>
                          <div className="pf-label">모델명</div>
                          <div className="pf-field"><input value={curInv.model} onChange={updInv(activeInvTab, 'model')} placeholder="예) SG125HX" /></div>
                        </div>
                        <div className="pf-row">
                          <div className="pf-label">용량(kW)</div>
                          <div className="pf-field"><input type="number" min={0} value={curInv.capacityKw} onChange={updInv(activeInvTab, 'capacityKw')} placeholder="예) 50" /></div>
                          <div className="pf-label">메모</div>
                          <div className="pf-field"><input value={curInv.memo} onChange={updInv(activeInvTab, 'memo')} placeholder="선택 입력" /></div>
                        </div>
                      </div>
                    </div>
                  )}
                </div>
              )}
            </div>

            <div className="admin-modal-footer">
              <button type="button" className="btn-admin-outline" onClick={() => setModal(null)}>취소</button>
              <button type="button" className="btn-admin-primary" onClick={handleSave}>
                {modal.mode === 'create' ? '등록' : '저장'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
