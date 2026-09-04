import { useState, useEffect } from 'react'
import { Line } from 'react-chartjs-2'
import { Chart as ChartJS, CategoryScale, LinearScale, PointElement, LineElement, Tooltip, Legend, Filler } from 'chart.js'
import { apiGet, formatNum, statusDotClass } from '../api'
import PlantCard from '../components/PlantCard'

ChartJS.register(CategoryScale, LinearScale, PointElement, LineElement, Tooltip, Legend, Filler)

function today() { return new Date().toISOString().slice(0, 10) }

function fmtEnergy(kwh) {
  const v = Number(kwh) || 0
  if (v >= 1000000) return `${formatNum(v / 1000000, 2)} GWh`
  if (v >= 1000)    return `${formatNum(v / 1000, 2)} MWh`
  return `${formatNum(v, 2)} kWh`
}

const STATUS_KO = { normal: '정상', error: '에러', no_comm: '통신없음' }

// ── 메인 컴포넌트 ────────────────────────────────────────────────────────────
export default function Generation() {
  const [sites, setSites] = useState([])
  const [selectedSite, setSelectedSite] = useState(null)
  const [siteDetail, setSiteDetail] = useState(null)
  const [hourly, setHourly] = useState([])
  const [date, setDate] = useState(today())
  const [kakaoKey, setKakaoKey] = useState('')
  useEffect(() => {
    apiGet('/api/config').then((c) => setKakaoKey(c.mapKeys?.kakao || '')).catch(console.error)
    apiGet('/api/sites').then((d) => {
      const list = d.sites || []
      setSites(list)
      if (list[0]) loadSite(list[0], date)
    }).catch(console.error)
  }, [])

  function loadSite(site, d) {
    setSelectedSite(site)
    Promise.all([
      apiGet(`/api/sites/${site.id}`),
      apiGet(`/api/sites/${site.id}/hourly?date=${d}`),
    ]).then(([detail, hourlyData]) => {
      setSiteDetail(detail)
      setHourly(hourlyData.series || [])
    }).catch(console.error)
  }

  function handleDateChange(e) {
    const d = e.target.value
    setDate(d)
    if (selectedSite) {
      apiGet(`/api/sites/${selectedSite.id}/hourly?date=${d}`)
        .then((h) => setHourly(h.series || []))
        .catch(console.error)
    }
  }

  const gen = siteDetail?.generation
  const site = siteDetail?.site
  const inverters = siteDetail?.inverters || []

  const chartData = {
    labels: hourly.map((r) => r.time),
    datasets: [{
      label: '출력(kW)',
      data: hourly.map((r) => r.kw),
      borderColor: '#1e6bb8',
      backgroundColor: 'rgba(30,107,184,0.08)',
      tension: 0.35,
      fill: true,
      pointRadius: 2,
    }],
  }

  const chartOptions = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: { legend: { display: false } },
    scales: {
      x: { ticks: { maxTicksLimit: 12, font: { size: 11 } } },
      y: { title: { display: true, text: 'kW', font: { size: 11 } }, beginAtZero: true },
    },
  }

  return (
    <div className="wrap-fill">
      <div className="gen-outer">

        {/* ── 왼쪽: 발전소 패널 ── */}
        <PlantCard
          sites={sites}
          selectedSite={selectedSite}
          site={site}
          onSelect={(s) => loadSite(s, date)}
          appKey={kakaoKey}
        />

        {/* ── 오른쪽 ── */}
        <div className="gen-right">

          {/* KPI 요약 */}
          <article className="card gen-summary-bar">
            <div className="kpi-grid">
              <KpiCard label="현재 출력"    value={gen ? `${formatNum(gen.currentKw, 1)} kW`   : '—'} />
              <KpiCard label="금일 발전량"  value={gen ? fmtEnergy(gen.todayKwh)               : '—'} />
              <KpiCard label="전일 발전량"  value={gen ? fmtEnergy(gen.yesterdayKwh)            : '—'} />
              <KpiCard label="누적 발전량"  value={gen ? fmtEnergy(gen.cumulativeKwh)           : '—'} />
              <KpiCard label="금일 발전시간" value={gen ? `${formatNum(gen.todayGenHours, 1)} h` : '—'} />
            </div>
          </article>

          <div className="gen-grid">
            {/* 출력 그래프 */}
            <section className="card" style={{ gridColumn: '1 / -1' }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 10 }}>
                <h2 className="card-title" style={{ margin: 0 }}><span className="card-title-dot" />발전 출력 (kW)</h2>
                <input
                  type="date"
                  value={date}
                  onChange={handleDateChange}
                  style={{ marginLeft: 'auto', padding: '4px 8px', border: '1px solid var(--line)', borderRadius: 'var(--radius-sm)', fontSize: '0.8rem', background: 'var(--surface)', color: 'var(--text)' }}
                />
              </div>
              <div className="chart-box">
                <Line data={chartData} options={chartOptions} />
              </div>
            </section>

            {/* 인버터 현황 */}
            <section className="card" style={{ display: 'flex', flexDirection: 'column', minHeight: 0 }}>
              <h2 className="card-title"><span className="card-title-dot" />인버터 현황</h2>
              <div className="table-scroll" style={{ flex: 1 }}>
                <table className="data-table">
                  <thead>
                    <tr>
                      <th>인버터</th>
                      <th>모델</th>
                      <th>상태</th>
                      <th className="num">출력(kW)</th>
                    </tr>
                  </thead>
                  <tbody>
                    {inverters.length === 0 ? (
                      <tr><td colSpan={4} className="hint">—</td></tr>
                    ) : inverters.map((inv) => (
                      <tr key={inv.id}>
                        <td>{inv.name}</td>
                        <td style={{ color: inv.model ? 'inherit' : 'var(--text-muted)' }}>{inv.model || '—'}</td>
                        <td>
                          <span className={`status-dot ${statusDotClass(inv.status)}`} />
                          {' '}{STATUS_KO[inv.status] || '—'}
                        </td>
                        <td className="num">{formatNum(inv.acKw, 2)}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </section>
          </div>

        </div>
      </div>
    </div>
  )
}

function KpiCard({ label, value }) {
  return (
    <div className="kpi-card">
      <div className="kpi-label">{label}</div>
      <div className="kpi-value">{value}</div>
    </div>
  )
}

