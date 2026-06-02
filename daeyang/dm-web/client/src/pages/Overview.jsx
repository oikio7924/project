import { useState, useEffect, useContext, useRef } from 'react'
import { useNavigate } from 'react-router-dom'
import { apiGet, formatNum, statusDotClass } from '../api'
import { UserContext } from '../App'
import KakaoMap from '../components/KakaoMap'

function fmtEnergy(kwh) {
  const v = Number(kwh) || 0
  if (v >= 1000000) return formatNum(v / 1000000, 2) + ' GWh'
  if (v >= 1000)    return formatNum(v / 1000, 2) + ' MWh'
  return formatNum(v, 2) + ' kWh'
}

const STATUS_LABEL    = { normal: '정상', no_comm: '통신없음', fault: '장애', offline: '오프' }
const STATUS_CARD_CLS = { fault: ' card-error', no_comm: ' card-no-comm', offline: ' card-off' }

export default function Overview() {
  const navigate = useNavigate()
  const user = useContext(UserContext)

  useEffect(() => {
    if (user !== null && user.role !== 'admin') navigate('/generation', { replace: true })
  }, [user])

  const [summary, setSummary]           = useState(null)
  const [kakaoKey, setKakaoKey]         = useState('')
  const kakaoMapRef                     = useRef(null)  // KakaoMap 컴포넌트 ref
  const [allSites, setAllSites]         = useState([])
  const [filterRegion, setFilterRegion]   = useState('')
  const [filterStatus, setFilterStatus]   = useState('')
  const [searchQuery, setSearchQuery]     = useState('')
  const [mapFiltered, setMapFiltered]     = useState(null) // null = 전체, 배열 = 지도 필터
  const [selectedSite, setSelectedSite]   = useState(null)
  const [detail, setDetail]               = useState(null)
  const [alarms, setAlarms]               = useState([])

  useEffect(() => {
    apiGet('/api/config').then((c) => setKakaoKey(c.mapKeys?.kakao || '')).catch(console.error)
    apiGet('/api/dashboard/summary').then(setSummary).catch(console.error)
    apiGet('/api/sites').then((d) => setAllSites(d.sites || [])).catch(console.error)
  }, [])

  useEffect(() => {
    if (!selectedSite) { setDetail(null); setAlarms([]); return }
    apiGet(`/api/sites/${selectedSite.id}`).then(setDetail).catch(console.error)
    apiGet(`/api/alarms?siteId=${selectedSite.id}`).then((d) => setAlarms(d.alarms || [])).catch(console.error)
  }, [selectedSite])

  // 지도 필터 → 지역/상태/검색 필터 순으로 적용
  const displaySites = (mapFiltered ?? allSites)
    .filter((s) => !filterRegion || s.region === filterRegion)
    .filter((s) => !filterStatus || s.status === filterStatus)
    .filter((s) => !searchQuery  || s.name.toLowerCase().includes(searchQuery.toLowerCase()))

  const countNormal  = allSites.filter((s) => s.status === 'normal').length
  const countFault   = allSites.filter((s) => s.status === 'fault').length
  const countOffline = allSites.filter((s) => s.status === 'offline').length
  const countNoComm  = allSites.filter((s) => s.status === 'no_comm').length
  const regions = [...new Set(allSites.map((s) => s.region).filter(Boolean))].sort()

  const site = detail?.site
  const gen  = detail?.generation

  function selectSite(s) {
    setSelectedSite((prev) => prev?.id === s.id ? null : s)
  }

  return (
    <div className="wrap-fill" style={{ flexDirection: 'column' }}>

      {/* KPI 행 */}
      <div className="kpi-row" style={{ flexShrink: 0 }}>
        <article className="card kpi-card">
          <h3>종합현황</h3>
          <div className="kpi-grid">
            <KpiItem label="총개수"      value={allSites.length || '—'} />
            <KpiItem label="가동"        value={countNormal} />
            <KpiItem label="인버터 에러" value={countFault} />
            <KpiItem label="장비 오프"   value={countOffline} />
            <KpiItem label="통신없음"    value={countNoComm} extra="warn" />
          </div>
        </article>
        <article className="card kpi-card">
          <h3>전체 발전량</h3>
          <div className="kpi-grid">
            <KpiItem label="총 현재출력"   value={formatNum(summary?.totalOutputKw, 2)}  unit="kW" />
            <KpiItem label="총 금일발전량" value={formatNum(summary?.todayMwh, 2)}        unit="MWh" />
            <KpiItem label="총 전일발전량" value={formatNum(summary?.yesterdayMwh, 2)}    unit="MWh" />
            <KpiItem label="총 누적발전량" value={formatNum(summary?.cumulativeGwh, 2)}   unit="GWh" />
            <KpiItem label="총 설비용량"   value={formatNum(summary?.totalCapacityKw, 1)} unit="kW" />
          </div>
        </article>
      </div>

      {/* 3열 그리드: [리스트] [상세] [지도] */}
      <div className={`overview-main${selectedSite ? ' has-detail' : ''}`}>

        {/* 열 1: 현장리스트 (2열 카드 그리드) */}
        <div className="card" style={{ display: 'flex', flexDirection: 'column', minHeight: 0, overflow: 'hidden' }}>
          <div className="overview-list-hd" style={{ flexShrink: 0 }}>
            <h2 className="card-title" style={{ margin: 0 }}>
              <span className="card-title-dot" />현장리스트{' '}
              <span style={{ fontSize: '0.75rem', fontWeight: 400, color: 'var(--text-muted)', marginLeft: 4 }}>
                {displaySites.length}개소
              </span>
              {mapFiltered && (
                <button
                  onClick={() => setMapFiltered(null)}
                  style={{ marginLeft: 8, fontSize: '0.72rem', padding: '2px 8px', background: 'var(--accent-soft)', color: 'var(--accent)', border: 'none', borderRadius: 4, cursor: 'pointer' }}
                >
                  지도 필터 해제 ✕
                </button>
              )}
            </h2>
            <div className="toolbar" style={{ margin: 0 }}>
              <select value={filterRegion} onChange={(e) => setFilterRegion(e.target.value)}>
                <option value="">전체 지역</option>
                {regions.map((r) => <option key={r} value={r}>{r}</option>)}
              </select>
              <select value={filterStatus} onChange={(e) => setFilterStatus(e.target.value)}>
                <option value="">전체 상태</option>
                <option value="normal">정상</option>
                <option value="fault">장애</option>
                <option value="no_comm">통신없음</option>
                <option value="offline">오프</option>
              </select>
              <input
                type="search"
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                placeholder="현장명 검색"
              />
            </div>
          </div>

          <div className="site-card-grid" style={{ flex: 1, overflowY: 'auto', gridTemplateColumns: '1fr 1fr' }}>
            {displaySites.length === 0 && (
              <p className="hint" style={{ padding: 20, gridColumn: '1/-1' }}>현장이 없습니다.</p>
            )}
            {displaySites.map((s) => (
              <SiteCard
                key={s.id}
                site={s}
                selected={s.id === selectedSite?.id}
                onClick={() => selectSite(s)}
              />
            ))}
          </div>
        </div>

        {/* 열 2: 상세 패널 (클릭 시 등장) */}
        <div className="card overview-detail-panel" style={{ display: 'flex', flexDirection: 'column', minHeight: 0 }}>
          <div className="overview-detail-hd" style={{ flexShrink: 0 }}>
            <h2 className="card-title" style={{ margin: 0 }}>
              <span className="card-title-dot" />{site?.name?.replace(/\[.*?\]\s*/, '') || ''}
            </h2>
            <button type="button" className="btn-close-detail" onClick={() => setSelectedSite(null)}>&times;</button>
          </div>

          <div className="overview-detail-grid" style={{ flex: 1, minHeight: 0 }}>
            {/* 현장정보 */}
            <section className="card">
              <h2 className="card-title"><span className="card-title-dot" />현장정보</h2>
              <div className="info-grid">
                <InfoRow label="현장명"   value={site?.name || ''} />
                <InfoRow label="브랜드"   value={site?.brand || '—'} />
                <InfoRow label="모델"     value={site?.model || '—'} />
                <InfoRow label="용량"     value={site ? `${formatNum(site.capacityKw, 1)} kW` : ''} />
                <InfoRow label="인버터"   value={site ? `${site.inverterCount} 대` : ''} />
                <InfoRow label="주소"     value={site?.address || '—'} />
                <InfoRow label="최종수신" value={site?.lastReceivedAt || '—'} />
              </div>
            </section>

            {/* 현장 위치 */}
            <section className="card">
              <h2 className="card-title"><span className="card-title-dot" />{site?.name?.replace(/\[.*?\]\s*/, '') || '현장 위치'}</h2>
              <div className="map-box" style={{ flex: 1 }}>
                <div style={{ position: 'absolute', inset: 0, display: 'flex', alignItems: 'center', justifyContent: 'center', color: 'rgba(255,255,255,0.5)', fontSize: '0.85rem', textAlign: 'center', padding: 12 }}>
                  {site?.address || '위치 정보 없음'}
                </div>
              </div>
            </section>

            {/* 발전실적 */}
            <section className="card">
              <h2 className="card-title"><span className="card-title-dot" />발전실적</h2>
              <div className="info-grid">
                <InfoRow label="현재출력" value={gen ? `${formatNum(gen.currentKw, 2)} kW` : '—'} />
                <InfoRow label="금일"     value={gen ? `${formatNum(gen.todayKwh, 2)} kWh` : '—'} />
                <InfoRow label="전일"     value={gen ? `${formatNum(gen.yesterdayKwh, 2)} kWh` : '—'} />
                <InfoRow label="누적"     value={gen ? `${formatNum(gen.cumulativeKwh, 2)} kWh` : '—'} />
              </div>
            </section>

            {/* 알람 */}
            <section className="card">
              <h2 className="card-title"><span className="card-title-dot" />알람</h2>
              <div className="table-scroll" style={{ flex: 1 }}>
                <table className="data-table">
                  <thead>
                    <tr><th>인버터</th><th>시간</th><th>상태</th></tr>
                  </thead>
                  <tbody>
                    {alarms.length === 0 ? (
                      <tr><td colSpan={3} className="hint">알람 없음</td></tr>
                    ) : (
                      alarms.map((a, i) => (
                        <tr key={i}>
                          <td>{a.inverterName}</td>
                          <td>{a.time}</td>
                          <td>{a.inverterStatus}</td>
                        </tr>
                      ))
                    )}
                  </tbody>
                </table>
              </div>
            </section>
          </div>
        </div>

        {/* 열 3: 지도 (기본 표시, 클릭 시 밀려남) */}
        <div className="card overview-map-panel" style={{ display: 'flex', flexDirection: 'column', minHeight: 0 }}>
          <h2 className="card-title" style={{ flexShrink: 0, display: 'flex', alignItems: 'center', gap: 8 }}>
            <span className="card-title-dot" />현장 위치
            <button
              type="button"
              onClick={() => { kakaoMapRef.current?.reset(); setMapFiltered(null) }}
              style={{ marginLeft: 'auto', fontSize: '0.72rem', padding: '2px 10px', background: 'var(--blue-soft)', color: 'var(--navy)', border: 'none', borderRadius: 4, cursor: 'pointer', fontWeight: 600 }}
            >
              처음으로
            </button>
          </h2>
          <div style={{ flex: 1, position: 'relative', borderRadius: 'var(--radius-sm)', overflow: 'hidden' }}>
            {kakaoKey ? (
              <KakaoMap
                ref={kakaoMapRef}
                appKey={kakaoKey}
                sites={allSites}
                onSelectSite={(s) => selectSite(s)}
                onFilterSites={(sites) => setMapFiltered(sites)}
              />
            ) : (
              <div className="map-box" style={{ position: 'absolute', inset: 0, display: 'flex', alignItems: 'center', justifyContent: 'center', color: 'rgba(255,255,255,0.5)', fontSize: '0.85rem', textAlign: 'center' }}>
                지도 API 키가 없습니다.<br />관리자 페이지에서 Kakao 키를 등록하세요.
              </div>
            )}
          </div>
        </div>

      </div>
    </div>
  )
}

function SiteCard({ site, selected, onClick }) {
  const dotCls  = statusDotClass(site.status)
  const cardCls = STATUS_CARD_CLS[site.status] || ''
  const label   = STATUS_LABEL[site.status] || '오프'
  return (
    <div className={`site-card${cardCls}${selected ? ' selected' : ''}`} onClick={onClick} style={{ cursor: 'pointer' }}>
      <span className="site-card-name">{site.name}</span>
      <span className="site-card-item">오늘<span className="val">{fmtEnergy(site.todayKwh)}</span></span>
      <span className="site-card-item">어제<span className="val">{fmtEnergy(site.yesterdayKwh)}</span></span>
      <span className="site-card-status"><span className={`status-dot ${dotCls}`} />{label}</span>
    </div>
  )
}

function KpiItem({ label, value, unit, extra }) {
  return (
    <div className={`kpi-item${extra ? ` ${extra}` : ''}`}>
      <label>{label}</label>
      <span className="value">{value}{unit && <span className="unit">{unit}</span>}</span>
    </div>
  )
}

function InfoRow({ label, value }) {
  return (
    <div className="info-row">
      <div className="label">{label}</div>
      <div className="value">{value}</div>
    </div>
  )
}
