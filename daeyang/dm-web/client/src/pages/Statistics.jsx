import { useState, useEffect, useRef } from 'react'
import { Line } from 'react-chartjs-2'
import { Chart as ChartJS, CategoryScale, LinearScale, PointElement, LineElement, Tooltip, Legend } from 'chart.js'
import zoomPlugin from 'chartjs-plugin-zoom'
import { apiGet, formatNum } from '../api'
import PlantCard from '../components/PlantCard'

ChartJS.register(CategoryScale, LinearScale, PointElement, LineElement, Tooltip, Legend, zoomPlugin)

export default function Statistics() {
  const [sites, setSites] = useState([])
  const [selectedSite, setSelectedSite] = useState(null)
  const [siteDetail, setSiteDetail] = useState(null)
  const [kakaoKey, setKakaoKey] = useState('')
  const [series, setSeries] = useState([])
  const [seriesByInv, setSeriesByInv] = useState([])
  const [dateFrom, setDateFrom] = useState(today())
  const [modal, setModal] = useState(null) // { slot, rows }
  const [modalLoading, setModalLoading] = useState(false)
  const [rawAllModal, setRawAllModal] = useState(false)
  const [rawAllRows, setRawAllRows] = useState([])
  const [rawAllLoading, setRawAllLoading] = useState(false)
  const [rawAllDate, setRawAllDate] = useState('')
  const chartRef = useRef(null)

  useEffect(() => {
    apiGet('/api/config').then((c) => setKakaoKey(c.mapKeys?.kakao || '')).catch(console.error)
    apiGet('/api/sites').then((d) => {
      const list = d.sites || []
      setSites(list)
      if (list[0]) loadSite(list[0], dateFrom)
    }).catch(console.error)
  }, [])


  function loadSite(site, date) {
    setSelectedSite(site)
    Promise.all([
      apiGet(`/api/sites/${site.id}`),
      apiGet(`/api/sites/${site.id}/hourly?date=${date}`),
      apiGet(`/api/sites/${site.id}/hourly-by-inverter?date=${date}`),
    ]).then(([detail, hourlyData, invData]) => {
      setSiteDetail(detail)
      setSeries([...(hourlyData.series || [])].reverse())
      setSeriesByInv(invData.series || [])
    }).catch(console.error)
  }

  function handleSearch() {
    if (selectedSite) loadSite(selectedSite, dateFrom)
  }

  async function openRawAll() {
    if (!selectedSite) return
    setRawAllLoading(true)
    setRawAllModal(true)
    setRawAllRows([])
    try {
      const data = await apiGet(`/api/sites/${selectedSite.id}/inverter-raw-all?date=${dateFrom}`)
      setRawAllRows(data.rows || [])
      setRawAllDate(data.date || dateFrom)
    } catch (e) {
      console.error(e)
    } finally {
      setRawAllLoading(false)
    }
  }

  async function openDetail(slot) {
    setModalLoading(true)
    setModal({ slot, rows: [] })
    try {
      const data = await apiGet(`/api/sites/${selectedSite.id}/inverter-raw?date=${dateFrom}&slot=${slot}`)
      setModal({ slot, rows: data.rows || [] })
    } catch (e) {
      console.error(e)
    } finally {
      setModalLoading(false)
    }
  }

  const site = siteDetail?.site
  const gen = siteDetail?.generation
  const inverters = siteDetail?.inverters || []

  const INV_COLORS = [
    '#1e6bb8','#e05c2a','#2aab5c','#9b3db8','#d4a017',
    '#17a2b8','#e0395a','#5c8a2a','#7b5ea7','#b87333',
    '#0a7373','#c62a85','#3a7ca5','#e07b39','#4caf50',
  ]

  // 05:00 ~ 21:00 10분 단위 고정 라벨 (97개)
  const FIXED_TIMES = []
  for (let h = 5; h <= 21; h++) {
    for (let m = 0; m < 60; m += 10) {
      if (h === 21 && m > 0) break
      FIXED_TIMES.push(`${String(h).padStart(2,'0')}:${String(m).padStart(2,'0')}`)
    }
  }

  const invNames = [...new Set(seriesByInv.map((r) => r.inverter))].sort()
  const invMap = {}
  seriesByInv.forEach((r) => {
    if (!invMap[r.inverter]) invMap[r.inverter] = {}
    invMap[r.inverter][r.time] = r.kw
  })

  const chartData = {
    labels: FIXED_TIMES,
    datasets: invNames.length > 0
      ? invNames.map((name, idx) => ({
          label: name,
          data: FIXED_TIMES.map((t) => invMap[name]?.[t] ?? null),
          borderColor: INV_COLORS[idx % INV_COLORS.length],
          backgroundColor: INV_COLORS[idx % INV_COLORS.length] + '22',
          tension: 0.35,
          fill: false,
          pointRadius: 2,
          spanGaps: true,
        }))
      : [{
          label: 'kW',
          data: FIXED_TIMES.map((t) => {
            const found = series.find((r) => r.time === t)
            return found ? found.kw : null
          }),
          borderColor: '#1e6bb8',
          tension: 0.35,
          fill: false,
          pointRadius: 2,
          spanGaps: true,
        }],
  }

  return (
    <div className="wrap-fill">
      <div className="gen-outer">
        {/* 왼쪽: 발전소 카드 */}
        <PlantCard
          sites={sites}
          selectedSite={selectedSite}
          site={site}
          onSelect={(s) => loadSite(s, dateFrom)}
          appKey={kakaoKey}
        />

        {/* 오른쪽 */}
        <div className="gen-right">
          {/* 요약 */}
          <div className="stats-top">
            <div className="summary-pills">
              <div className="summary-pill"><h4>당일</h4><p className="big">{formatNum(gen?.todayKwh, 2)} kWh</p></div>
              <div className="summary-pill"><h4>누적</h4><p className="big">{formatNum(gen?.cumulativeKwh, 2)} kWh</p></div>
            </div>
            <div className="card" style={{ overflow: 'hidden', minWidth: 0 }}>
              <div style={{ display: 'flex', alignItems: 'center', marginBottom: 6 }}>
                <h2 className="card-title" style={{ margin: 0 }}><span className="card-title-dot" />발전 출력 그래프</h2>
                <button
                  type="button"
                  className="btn"
                  style={{ marginLeft: 'auto', padding: '3px 10px', fontSize: '0.75rem', border: '1px solid var(--line)' }}
                  onClick={() => chartRef.current?.resetZoom()}
                >
                  확대 초기화
                </button>
              </div>
              <div style={{ height: 260, position: 'relative' }}>
                <Line ref={chartRef} data={chartData} options={{
                  responsive: true,
                  maintainAspectRatio: false,
                  plugins: {
                    legend: {
                      display: invNames.length > 0,
                      position: 'bottom',
                      labels: { boxWidth: 12, font: { size: 11 }, padding: 8 },
                    },
                    zoom: {
                      limits: {
                        x: { min: 0, max: FIXED_TIMES.length - 1, minRange: 3 },
                      },
                      pan: {
                        enabled: true,
                        mode: 'x',
                      },
                      zoom: {
                        wheel: { enabled: true },
                        pinch: { enabled: true },
                        mode: 'x',
                      },
                    },
                  },
                  scales: {
                    x: {
                      ticks: {
                        font: { size: 10 },
                        callback: function(val, idx) {
                          const t = FIXED_TIMES[idx]
                          if (!t) return ''
                          const range = this.max - this.min
                          if (range <= 6)  return t                          // 1시간 이하: 10분마다
                          if (range <= 18) return t.endsWith(':00') || t.endsWith(':30') ? t : '' // 3시간 이하: 30분마다
                          return t.endsWith(':00') ? t : ''                  // 기본: 1시간마다
                        },
                        maxRotation: 0,
                        autoSkip: false,
                      },
                    },
                    y: { title: { display: true, text: 'kW', font: { size: 11 } }, beginAtZero: true },
                  },
                }} />
              </div>
            </div>
          </div>

          {/* 통계 테이블 */}
          <section className="card" style={{ display: 'flex', flexDirection: 'column', flex: 1, minHeight: 0 }}>
            <h2 className="card-title"><span className="card-title-dot" />통계분석</h2>
            <div className="filter-bar">
              <div className="seg-btns">
                {['일', '주', '월', '년'].map((p) => (
                  <button key={p} type="button" className={p === '일' ? 'active' : ''}>{p}</button>
                ))}
              </div>
              <input type="date" value={dateFrom} onChange={(e) => setDateFrom(e.target.value)} style={{ padding: '5px 8px', border: '1px solid var(--line)', borderRadius: 'var(--radius-sm)' }} />
              <button type="button" className="btn btn-primary" onClick={handleSearch}>검색</button>
              <button type="button" className="btn btn-success">엑셀 다운로드</button>
              <button type="button" className="btn" style={{ background: 'var(--surface)', border: '1px solid var(--line)' }} onClick={openRawAll}>상세보기</button>
            </div>
            <div className="table-scroll" style={{ flex: 1 }}>
              <table className="data-table">
                <thead>
                  <tr>
                    <th>시간</th>
                    <th>인버터</th>
                    <th className="num">출력(kW)</th>
                    <th className="num">발전량(kWh)</th>
                  </tr>
                </thead>
                <tbody>
                  {seriesByInv.length === 0 ? (
                    <tr><td colSpan={4} className="hint">데이터가 없습니다.</td></tr>
                  ) : (
                    seriesByInv.map((r, i) => (
                      <tr key={i}>
                        <td>{dateFrom} {r.time}</td>
                        <td>{r.inverter}</td>
                        <td className="num">{formatNum(r.kw, 3)}</td>
                        <td className="num">{formatNum(r.kwh, 3)}</td>
                      </tr>
                    ))
                  )}
                </tbody>
              </table>
            </div>

          </section>
        </div>
      </div>

      {/* 전체 시간대 raw 테이블 모달 */}
      {rawAllModal && (
        <div className="modal-backdrop" onClick={() => setRawAllModal(false)}>
          <div className="modal-box" style={{ width: '96vw', maxWidth: '96vw', height: '90vh', display: 'flex', flexDirection: 'column' }} onClick={(e) => e.stopPropagation()}>
            <div className="modal-header">
              <h3>인버터 원시 데이터 — {selectedSite?.name?.replace(/\[.*?\]\s*/, '')} / {rawAllDate}</h3>
              <button type="button" className="modal-close" onClick={() => setRawAllModal(false)}>✕</button>
            </div>
            <div className="modal-body" style={{ flex: 1, overflow: 'hidden', padding: 0, display: 'flex', flexDirection: 'column' }}>
              {rawAllLoading ? (
                <div style={{ textAlign: 'center', padding: 48, color: 'var(--text-muted)' }}>불러오는 중...</div>
              ) : rawAllRows.length === 0 ? (
                <div style={{ textAlign: 'center', padding: 48, color: 'var(--text-muted)' }}>데이터가 없습니다.</div>
              ) : (
                <RawAllTable rows={rawAllRows} />
              )}
            </div>
          </div>
        </div>
      )}

      {/* 상세보기 모달 */}
      {modal && (
        <div className="modal-backdrop" onClick={() => setModal(null)}>
          <div className="modal-box modal-wide" onClick={(e) => e.stopPropagation()}>
            <div className="modal-header">
              <h3>인버터 상세 데이터 — {dateFrom} {modal.slot}</h3>
              <button type="button" className="modal-close" onClick={() => setModal(null)}>✕</button>
            </div>
            <div className="modal-body">
              {modalLoading ? (
                <div style={{ textAlign: 'center', padding: 32, color: 'var(--text-muted)' }}>불러오는 중...</div>
              ) : modal.rows.length === 0 ? (
                <div style={{ textAlign: 'center', padding: 32, color: 'var(--text-muted)' }}>데이터가 없습니다.</div>
              ) : (
                modal.rows.map((inv, i) => (
                  <InverterDetailCard key={`${inv.collected_at}_${inv.inverter_name}_${i}`} inv={inv} />
                ))
              )}
            </div>
          </div>
        </div>
      )}
    </div>
  )
}

function InverterDetailCard({ inv }) {
  const [pvOpen, setPvOpen] = useState(false)

  const pvChannels = []
  for (let i = 1; i <= 24; i++) {
    const v = inv[`vpv${i}`], c = inv[`ipv${i}`], p = inv[`ppv${i}`]
    if (v != null || c != null || p != null) pvChannels.push({ ch: i, v, c, p })
  }
  const strChannels = []
  for (let i = 1; i <= 24; i++) {
    const val = inv[`istr${i}`]
    if (val != null) strChannels.push({ ch: i, val })
  }

  return (
    <div style={{ marginBottom: 16, border: '1px solid var(--line)', borderRadius: 6, overflow: 'hidden' }}>
      <div style={{ background: 'var(--surface)', padding: '6px 12px', fontWeight: 600, fontSize: '0.85rem', borderBottom: '1px solid var(--line)' }}>
        {inv.inverter_name}
        <span style={{ marginLeft: 8, fontWeight: 400, fontSize: '0.78rem', color: 'var(--text-muted)' }}>{inv.collected_at}</span>
      </div>
      <div style={{ padding: '8px 12px', display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(200px, 1fr))', gap: '4px 16px', fontSize: '0.82rem' }}>
        <RawRow label="유효전력" value={inv.active_power} unit="kW" />
        <RawRow label="일발전량" value={inv.daily_gen} unit="kWh" />
        <RawRow label="누적발전량" value={inv.cumulative_gen} unit="kWh" />
        <RawRow label="총발전시간" value={inv.total_gen_hour} unit="h" />
        <RawRow label="작업모드" value={inv.work_mode} />
        <RawRow label="계통주파수" value={inv.grid_frequency} unit="Hz" />
        <RawRow label="내부온도" value={inv.temperature} unit="℃" />
        <RawRow label="내각온도" value={inv.cabinet_temp} unit="℃" />
        <RawRow label="A상 전압" value={inv.volt_a} unit="V" />
        <RawRow label="B상 전압" value={inv.volt_b} unit="V" />
        <RawRow label="C상 전압" value={inv.volt_c} unit="V" />
        <RawRow label="A상 전류" value={inv.curr_a} unit="A" />
        <RawRow label="B상 전류" value={inv.curr_b} unit="A" />
        <RawRow label="C상 전류" value={inv.curr_c} unit="A" />
        <RawRow label="A-B 선간전압" value={inv.volt_ab} unit="V" />
        <RawRow label="B-C 선간전압" value={inv.volt_bc} unit="V" />
        <RawRow label="C-A 선간전압" value={inv.volt_ca} unit="V" />
        <RawRow label="DSP 에러" value={inv.dsp_error} highlight={!!inv.dsp_error && inv.dsp_error !== '0'} />
        <RawRow label="DSP 알람" value={inv.dsp_alarm} />
        <RawRow label="하위DSP 에러" value={inv.slave_dsp_error} />
        <RawRow label="안전코드" value={inv.safety_code} />
      </div>

      {pvChannels.length > 0 && (
        <div style={{ borderTop: '1px solid var(--line)' }}>
          <button
            type="button"
            style={{ width: '100%', padding: '5px 12px', textAlign: 'left', fontSize: '0.8rem', color: 'var(--text-muted)', background: 'none', border: 'none', cursor: 'pointer' }}
            onClick={() => setPvOpen((v) => !v)}
          >
            {pvOpen ? '▲' : '▼'} PV 스트링 데이터 ({pvChannels.length}채널)
          </button>
          {pvOpen && (
            <div style={{ padding: '4px 12px 8px', overflowX: 'auto' }}>
              <table className="data-table" style={{ fontSize: '0.78rem', minWidth: 400 }}>
                <thead>
                  <tr>
                    <th>채널</th>
                    <th className="num">전압(V)</th>
                    <th className="num">전류(A)</th>
                    <th className="num">전력(W)</th>
                  </tr>
                </thead>
                <tbody>
                  {pvChannels.map(({ ch, v, c, p }) => (
                    <tr key={ch}>
                      <td>PV{ch}</td>
                      <td className="num">{v ?? '—'}</td>
                      <td className="num">{c ?? '—'}</td>
                      <td className="num">{p ?? '—'}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
              {strChannels.length > 0 && (
                <>
                  <div style={{ marginTop: 8, marginBottom: 4, fontSize: '0.78rem', color: 'var(--text-muted)' }}>스트링 전류</div>
                  <div style={{ display: 'flex', flexWrap: 'wrap', gap: '4px 12px', fontSize: '0.78rem' }}>
                    {strChannels.map(({ ch, val }) => (
                      <span key={ch}>IStr{ch}: <b>{val}</b> A</span>
                    ))}
                  </div>
                </>
              )}
            </div>
          )}
        </div>
      )}
    </div>
  )
}

function RawRow({ label, value, unit, highlight }) {
  if (value == null || value === '') return null
  return (
    <div style={{ display: 'flex', justifyContent: 'space-between', padding: '2px 0', borderBottom: '1px solid var(--line)' }}>
      <span style={{ color: 'var(--text-muted)' }}>{label}</span>
      <span style={{ fontWeight: 500, color: highlight ? 'var(--error)' : undefined }}>
        {value}{unit ? ` ${unit}` : ''}
      </span>
    </div>
  )
}


function today() {
  return new Date().toISOString().slice(0, 10)
}

const BASE_COLS = [
  { key: 'collected_at',  label: 'Time',     w: 120, fixed: true },
  { key: 'inverter_name', label: 'Inverter', w: 100, fixed: true },
]

const TAB_COLS = {
  basic: [
    { key: 'collected_at',   label: 'Time',          w: 120, fixed: true },
    { key: 'inverter_name',  label: 'Inverter',       w: 100, fixed: true },
    { key: 'active_power',   label: '유효전력(kW)',   w:  80, num: true },
    { key: 'grid_frequency', label: '주파수(Hz)',     w:  72, num: true },
    { key: 'work_mode',      label: 'Mode',           w:  60, },
    { key: 'total_gen_hour', label: 'Hours',          w:  60, num: true },
    { key: 'cumulative_gen', label: '누적발전량(kWh)',w:  96, num: true },
    { key: 'daily_gen',      label: '일일발전량(kWh)',w:  90, num: true },
  ],
  ac: [
    ...BASE_COLS,
    { key: 'volt_ab', label: 'A_B(V)',  w: 60, num: true },
    { key: 'volt_bc', label: 'B_C(V)',  w: 60, num: true },
    { key: 'volt_ca', label: 'C_A(V)',  w: 60, num: true },
    { key: 'volt_a',  label: 'A_N(V)',  w: 60, num: true },
    { key: 'volt_b',  label: 'B_N(V)',  w: 60, num: true },
    { key: 'volt_c',  label: 'C_N(V)',  w: 60, num: true },
    { key: 'curr_a',  label: 'A상(A)',  w: 60, num: true },
    { key: 'curr_b',  label: 'B상(A)',  w: 60, num: true },
    { key: 'curr_c',  label: 'C상(A)',  w: 60, num: true },
    { key: 'freq_a',  label: 'Fa(Hz)',  w: 60, num: true },
    { key: 'freq_b',  label: 'Fb(Hz)',  w: 60, num: true },
    { key: 'freq_c',  label: 'Fc(Hz)',  w: 60, num: true },
  ],
  status: [
    ...BASE_COLS,
    { key: 'temperature',     label: '온도(℃)',   w:  72, num: true },
    { key: 'cabinet_temp',    label: 'Cab.T(℃)',  w:  72, num: true },
    { key: 'dsp_error',       label: 'DSP Err',   w:  90, },
    { key: 'dsp_alarm',       label: 'DSP Alm',   w:  80, },
    { key: 'slave_dsp_error', label: 'Sub Err',   w:  80, },
    { key: 'slave_dsp_alarm', label: 'Sub Alm',   w:  80, },
    { key: 'safety_code',     label: 'Safety',    w:  70, },
  ],
  pv: [
    ...BASE_COLS,
    ...Array.from({ length: 24 }, (_, i) => [
      { key: `vpv${i+1}`, label: `VPv${i+1}`, w: 60, num: true },
      { key: `ipv${i+1}`, label: `IPv${i+1}`, w: 60, num: true, groupEnd: true },
    ]).flat(),
  ],
  istr: [
    ...BASE_COLS,
    ...Array.from({ length: 24 }, (_, i) => ({ key: `istr${i+1}`, label: `IStr${i+1}`, w: 60, num: true })),
  ],
}

const SCROLL_TABS = new Set(['pv', 'istr'])

const TABS = [
  { id: 'basic',  label: '기본 발전' },
  { id: 'ac',     label: 'AC 전기' },
  { id: 'status', label: '온도/에러' },
  { id: 'pv',     label: 'PV 스트링' },
  { id: 'istr',   label: '스트링 전류' },
]

function RawAllTable({ rows }) {
  const [tab, setTab] = useState('basic')
  const cols = TAB_COLS[tab]
  const v = (val) => (val == null || val === '') ? '—' : val
  const isErr = (col, val) => col === 'dsp_error' && val && val !== '0'

  return (
    <div style={{ display: 'flex', flexDirection: 'column', height: '100%' }}>
      {/* 탭 바 */}
      <div style={{ display: 'flex', alignItems: 'center', padding: '0 12px', background: 'var(--surface)', flexShrink: 0, borderBottom: '1px solid var(--line)' }}>
        {TABS.map((t) => (
          <button
            key={t.id}
            type="button"
            onClick={() => setTab(t.id)}
            style={{
              padding: '10px 18px',
              fontSize: '0.82rem',
              fontWeight: tab === t.id ? 700 : 400,
              cursor: 'pointer',
              border: 'none',
              borderBottom: tab === t.id ? '3px solid var(--navy)' : '3px solid transparent',
              background: 'none',
              color: tab === t.id ? 'var(--navy)' : 'var(--text-muted)',
              transition: 'color 0.15s, border-color 0.15s',
            }}
          >
            {t.label}
          </button>
        ))}
        <span style={{ marginLeft: 'auto', fontSize: '0.78rem', color: 'var(--text-muted)' }}>
          {rows.length.toLocaleString()}건 (최신순)
        </span>
      </div>

      {/* 테이블 */}
      <div style={{ flex: 1, overflow: 'auto' }}>
        <table
          className="data-table"
          style={{
            fontSize: '0.68rem',
            borderCollapse: 'collapse',
            whiteSpace: 'nowrap',
            width: SCROLL_TABS.has(tab) ? undefined : '100%',
            tableLayout: SCROLL_TABS.has(tab) ? undefined : 'fixed',
          }}
        >
          <thead>
            <tr>
              {cols.map((c) => (
                <th key={c.key} style={{
                  width: c.fixed ? c.w : undefined,
                  minWidth: c.w,
                  position: 'sticky', top: 0, zIndex: 1,
                  padding: '5px 4px', borderBottom: '2px solid var(--line)',
                  textAlign: 'center',
                  background: 'var(--surface)',
                  borderRight: c.groupEnd ? '2px solid var(--line)' : undefined,
                }}>
                  {c.label}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {rows.map((r, i) => (
              <tr key={i} style={{ background: i % 2 === 0 ? 'var(--bg)' : 'var(--surface)' }}>
                {cols.map((c) => (
                  <td
                    key={c.key}
                    style={{
                      padding: '3px 4px',
                      textAlign: 'center',
                      color: isErr(c.key, r[c.key]) ? 'var(--error)' : undefined,
                      borderRight: c.groupEnd ? '2px solid var(--line)' : undefined,
                    }}
                  >
                    {v(r[c.key])}
                  </td>
                ))}
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  )
}
