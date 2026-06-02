import { useState, useEffect, useRef } from 'react'
import { Line } from 'react-chartjs-2'
import { Chart as ChartJS, CategoryScale, LinearScale, PointElement, LineElement, Tooltip, Legend } from 'chart.js'
import { apiGet, formatNum, statusDotClass } from '../api'

ChartJS.register(CategoryScale, LinearScale, PointElement, LineElement, Tooltip, Legend)

export default function Generation() {
  const [sites, setSites] = useState([])
  const [selectedSite, setSelectedSite] = useState(null)
  const [siteDetail, setSiteDetail] = useState(null)   // { site, inverters, generation }
  const [hourly, setHourly] = useState([])             // 시간별 출력 데이터
  const [searchQuery, setSearchQuery] = useState('')
  const [dropdownOpen, setDropdownOpen] = useState(false)
  const dropdownRef = useRef(null)

  // 발전소 목록 로드
  useEffect(() => {
    apiGet('/api/sites').then((d) => {
      const list = d.sites || []
      setSites(list)
      if (list[0]) loadSite(list[0])
    }).catch(console.error)
  }, [])

  // 외부 클릭 시 드롭다운 닫기
  useEffect(() => {
    function handler(e) {
      if (dropdownRef.current && !dropdownRef.current.contains(e.target)) {
        setDropdownOpen(false)
      }
    }
    document.addEventListener('click', handler)
    return () => document.removeEventListener('click', handler)
  }, [])

  function loadSite(site) {
    setSelectedSite(site)
    const today = new Date().toISOString().slice(0, 10)
    Promise.all([
      apiGet(`/api/sites/${site.id}`),
      apiGet(`/api/sites/${site.id}/hourly?date=${today}`),
    ]).then(([detail, hourlyData]) => {
      setSiteDetail(detail)
      setHourly(hourlyData.series || [])
    }).catch(console.error)
  }

  const filteredSites = sites.filter((s) =>
    s.name.toLowerCase().includes(searchQuery.toLowerCase())
  )

  // 차트 데이터
  const chartData = {
    labels: hourly.map((r) => r.time),
    datasets: [
      {
        label: '출력(kW)',
        data: hourly.map((r) => r.kw),
        borderColor: '#1e6bb8',
        backgroundColor: 'rgba(30,107,184,0.08)',
        tension: 0.35,
        fill: true,
      },
    ],
  }

  const gen = siteDetail?.generation
  const site = siteDetail?.site
  const inverters = siteDetail?.inverters || []

  return (
    <div className="wrap-fill">
      <div className="gen-outer">
        {/* 왼쪽: 발전소 카드 */}
        <section className="card gen-plant-col">
          <h2 className="card-title"><span className="card-title-dot" />발전소</h2>

          {/* 발전소 검색 드롭다운 */}
          <div className="site-search-wrap" ref={dropdownRef} style={{ marginBottom: 8 }}>
            <div className="site-search-btn" onClick={() => setDropdownOpen((v) => !v)}>
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
              <span>{selectedSite ? selectedSite.name.replace(/\[.*?\]\s*/, '') : '발전소 선택'}</span>
              <svg className="site-search-chevron" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round"><polyline points="6 9 12 15 18 9"/></svg>
            </div>
            {dropdownOpen && (
              <div className="site-search-dropdown open">
                <input
                  type="text"
                  placeholder="발전소 검색..."
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  autoFocus
                />
                <ul className="site-search-list">
                  {filteredSites.length === 0 ? (
                    <li className="no-result">검색 결과 없음</li>
                  ) : (
                    filteredSites.map((s) => (
                      <li
                        key={s.id}
                        className={s.id === selectedSite?.id ? 'selected' : ''}
                        onClick={() => { loadSite(s); setDropdownOpen(false); setSearchQuery('') }}
                      >
                        {s.name}
                      </li>
                    ))
                  )}
                </ul>
              </div>
            )}
          </div>

          {/* 지도 영역 */}
          <div className="map-box" style={{ height: 240, flex: 'none', marginBottom: 8 }}>
            <div style={{ position: 'absolute', inset: 0, background: 'var(--bg)', display: 'flex', alignItems: 'center', justifyContent: 'center', color: 'var(--text-muted)', fontSize: '0.8rem' }}>
              지도 준비 중
            </div>
          </div>

          {/* 발전소 정보 */}
          {site && (
            <div id="plant-info" className="info-grid">
              <InfoRow label="발전소명" value={site.name.replace(/\[.*?\]\s*/, '')} highlight />
              <InfoRow label="주소" value={formatAddress(site.address)} />
              <InfoRow label="설비용량" value={site.capacityKw ? `${formatNum(site.capacityKw, 1)} kW` : ''} />
              <InfoRow label="인버터" value={site.invBrand} />
              <InfoRow label="인버터 수량" value={site.inverterCount ? `${site.inverterCount} 대` : ''} />
              <InfoRow label="등록일시" value={site.registeredAt} />
              <InfoRow label="최종 수신" value={site.lastReceivedAt} />
            </div>
          )}
        </section>

        {/* 오른쪽 */}
        <div className="gen-right">
          {/* 요약 바 */}
          <article className="card gen-summary-bar">
            <div className="kpi-grid">
              <KpiCard label="현재 출력" value={gen ? formatNum(gen.currentKw, 1) : '—'} unit="kW" />
              <KpiCard label="금일 발전량" value={gen ? formatNum(gen.todayKwh, 2) : '—'} unit="kWh" />
              <KpiCard label="전일 발전량" value={gen ? formatNum(gen.yesterdayKwh, 2) : '—'} unit="kWh" />
              <KpiCard label="누적 발전량" value={gen ? formatNum(gen.cumulativeKwh, 2) : '—'} unit="kWh" />
              <KpiCard label="금일 발전시간" value={gen ? formatNum(gen.todayGenHours, 1) : '—'} unit="h" />
            </div>
          </article>

          <div className="gen-grid">
            {/* 출력 그래프 */}
            <section className="card" style={{ gridColumn: '1 / -1' }}>
              <h2 className="card-title"><span className="card-title-dot" />발전 출력 (kW)</h2>
              <div className="chart-box">
                <Line data={chartData} options={{ responsive: true, maintainAspectRatio: false, plugins: { legend: { display: false } }, scales: { y: { title: { display: true, text: 'kW' } } } }} />
              </div>
            </section>

            {/* 인버터 현황 */}
            <section className="card">
              <h2 className="card-title"><span className="card-title-dot" />인버터 현황</h2>
              <table className="data-table">
                <thead>
                  <tr><th>인버터</th><th>상태</th><th className="num">출력(kW)</th></tr>
                </thead>
                <tbody>
                  {inverters.length === 0 ? (
                    <tr><td colSpan={3} className="hint">—</td></tr>
                  ) : (
                    inverters.map((inv) => (
                      <tr key={inv.id}>
                        <td>{inv.name}</td>
                        <td><span className={`status-dot ${statusDotClass(inv.status)}`} /></td>
                        <td className="num">{formatNum(inv.acKw, 2)}</td>
                      </tr>
                    ))
                  )}
                </tbody>
              </table>
            </section>
          </div>
        </div>
      </div>
    </div>
  )
}

function InfoRow({ label, value, highlight }) {
  return (
    <div className="info-row">
      <div className="label">{label}</div>
      <div className={`value${highlight ? ' highlight' : ''}`}>{value || '—'}</div>
    </div>
  )
}

function KpiCard({ label, value, unit }) {
  return (
    <div className="kpi-card">
      <div className="kpi-label">{label}</div>
      <div className="kpi-value">{value} <span className="kpi-unit">{unit}</span></div>
    </div>
  )
}

function formatAddress(addr) {
  if (!addr) return ''
  let s = addr.replace(/^\d{5}\s*/, '')
  const i = s.indexOf('//')
  return (i !== -1 ? s.slice(i + 2) : s).trim()
}
