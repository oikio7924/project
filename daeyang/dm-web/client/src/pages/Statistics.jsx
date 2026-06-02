import { useState, useEffect, useRef } from 'react'
import { Line } from 'react-chartjs-2'
import { Chart as ChartJS, CategoryScale, LinearScale, PointElement, LineElement, Tooltip, Legend } from 'chart.js'
import { apiGet, formatNum } from '../api'

ChartJS.register(CategoryScale, LinearScale, PointElement, LineElement, Tooltip, Legend)

export default function Statistics() {
  const [sites, setSites] = useState([])
  const [selectedSite, setSelectedSite] = useState(null)
  const [siteDetail, setSiteDetail] = useState(null)
  const [series, setSeries] = useState([])
  const [dateFrom, setDateFrom] = useState(today())
  const [searchQuery, setSearchQuery] = useState('')
  const [dropdownOpen, setDropdownOpen] = useState(false)
  const dropdownRef = useRef(null)

  useEffect(() => {
    apiGet('/api/sites').then((d) => {
      const list = d.sites || []
      setSites(list)
      if (list[0]) loadSite(list[0], dateFrom)
    }).catch(console.error)
  }, [])

  useEffect(() => {
    function handler(e) {
      if (dropdownRef.current && !dropdownRef.current.contains(e.target)) setDropdownOpen(false)
    }
    document.addEventListener('click', handler)
    return () => document.removeEventListener('click', handler)
  }, [])

  function loadSite(site, date) {
    setSelectedSite(site)
    Promise.all([
      apiGet(`/api/sites/${site.id}`),
      apiGet(`/api/sites/${site.id}/hourly?date=${date}`),
    ]).then(([detail, hourlyData]) => {
      setSiteDetail(detail)
      setSeries(hourlyData.series || [])
    }).catch(console.error)
  }

  function handleSearch() {
    if (selectedSite) loadSite(selectedSite, dateFrom)
  }

  const filteredSites = sites.filter((s) => s.name.toLowerCase().includes(searchQuery.toLowerCase()))
  const site = siteDetail?.site
  const gen = siteDetail?.generation

  const chartData = {
    labels: series.map((r) => r.time),
    datasets: [{
      label: 'kW',
      data: series.map((r) => r.kw),
      borderColor: '#1e6bb8',
      tension: 0.35,
      fill: false,
    }],
  }

  return (
    <div className="wrap-fill">
      <div className="gen-outer">
        {/* 왼쪽: 발전소 카드 */}
        <aside className="card gen-plant-col">
          <h2 className="card-title"><span className="card-title-dot" />발전소</h2>

          <div className="site-search-wrap" ref={dropdownRef} style={{ marginBottom: 8 }}>
            <div className="site-search-btn" onClick={() => setDropdownOpen((v) => !v)}>
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
              <span>{selectedSite ? selectedSite.name.replace(/\[.*?\]\s*/, '') : '발전소 선택'}</span>
              <svg className="site-search-chevron" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round"><polyline points="6 9 12 15 18 9"/></svg>
            </div>
            {dropdownOpen && (
              <div className="site-search-dropdown open">
                <input type="text" placeholder="발전소 검색..." value={searchQuery} onChange={(e) => setSearchQuery(e.target.value)} autoFocus />
                <ul className="site-search-list">
                  {filteredSites.map((s) => (
                    <li key={s.id} className={s.id === selectedSite?.id ? 'selected' : ''}
                      onClick={() => { loadSite(s, dateFrom); setDropdownOpen(false); setSearchQuery('') }}>
                      {s.name}
                    </li>
                  ))}
                </ul>
              </div>
            )}
          </div>

          <div className="map-box" style={{ height: 240, flex: 'none', marginBottom: 8 }}>
            <div style={{ position: 'absolute', inset: 0, background: 'var(--bg)', display: 'flex', alignItems: 'center', justifyContent: 'center', color: 'var(--text-muted)', fontSize: '0.8rem' }}>지도 준비 중</div>
          </div>

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
        </aside>

        {/* 오른쪽 */}
        <div className="gen-right">
          {/* 요약 */}
          <div className="stats-top">
            <div className="summary-pills">
              <div className="summary-pill"><h4>당일</h4><p className="big">{formatNum(gen?.todayKwh, 2)} kWh</p></div>
              <div className="summary-pill"><h4>누적</h4><p className="big">{formatNum(gen?.cumulativeKwh, 2)} kWh</p></div>
            </div>
            <div className="card">
              <h2 className="card-title"><span className="card-title-dot" />발전 출력 그래프</h2>
              <div className="chart-box">
                <Line data={chartData} options={{ responsive: true, maintainAspectRatio: false, plugins: { legend: { display: false } }, scales: { y: { title: { display: true, text: 'kW' } } } }} />
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
            </div>
            <div className="table-scroll" style={{ flex: 1 }}>
              <table className="data-table">
                <thead>
                  <tr>
                    <th>시간</th>
                    <th className="num">출력(kW)</th>
                    <th className="num">발전량(kWh)</th>
                  </tr>
                </thead>
                <tbody>
                  {series.length === 0 ? (
                    <tr><td colSpan={3} className="hint">데이터가 없습니다.</td></tr>
                  ) : (
                    series.map((r) => (
                      <tr key={r.time}>
                        <td>{dateFrom} {r.time}</td>
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

function formatAddress(addr) {
  if (!addr) return ''
  let s = addr.replace(/^\d{5}\s*/, '')
  const i = s.indexOf('//')
  return (i !== -1 ? s.slice(i + 2) : s).trim()
}

function today() {
  return new Date().toISOString().slice(0, 10)
}
