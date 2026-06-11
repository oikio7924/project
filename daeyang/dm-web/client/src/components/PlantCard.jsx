import { useState, useEffect, useRef } from 'react'
import { formatNum } from '../api'
import { loadSdk } from './KakaoMap'

export function SiteMarkerMap({ appKey, site }) {
  const containerRef = useRef(null)
  const mapRef = useRef(null)
  const markerRef = useRef(null)
  const mapReadyRef = useRef(false)

  function positionOnSite(map, s) {
    if (!s?.lat || !s?.lng || !window.kakao?.maps) return
    const kakao = window.kakao
    const pos = new kakao.maps.LatLng(Number(s.lat), Number(s.lng))
    map.setCenter(pos)
    if (markerRef.current) {
      markerRef.current.setPosition(pos)
    } else {
      markerRef.current = new kakao.maps.Marker({ map, position: pos, title: s.name || '' })
    }
  }

  useEffect(() => {
    if (!appKey || !site?.lat || !site?.lng || !containerRef.current) return

    if (mapRef.current) {
      // 지도가 이미 있으면 재생성 없이 이동만 (relayout 완료 후에만)
      if (mapReadyRef.current) positionOnSite(mapRef.current, site)
      return
    }

    let stale = false  // cleanup 후 SDK 콜백이 뒤늦게 실행되는 걸 막음
    loadSdk(appKey, () => {
      if (stale || !containerRef.current || mapRef.current) return
      const kakao = window.kakao
      const pos = new kakao.maps.LatLng(Number(site.lat), Number(site.lng))
      const map = new kakao.maps.Map(containerRef.current, {
        center: pos,
        level: 5,
        mapTypeId: kakao.maps.MapTypeId.HYBRID,
      })
      mapRef.current = map
      mapReadyRef.current = false
      markerRef.current = new kakao.maps.Marker({ map, position: pos, title: site.name || '' })
      setTimeout(() => {
        if (!mapRef.current) return
        mapRef.current.relayout()
        mapReadyRef.current = true
      }, 150)
    })

    return () => {
      stale = true
      if (markerRef.current) { markerRef.current.setMap(null); markerRef.current = null }
      mapRef.current = null
      mapReadyRef.current = false
    }
  }, [appKey, site?.lat, site?.lng])

  return (
    <div style={{ position: 'absolute', inset: 0 }}>
      <div ref={containerRef} style={{ width: '100%', height: '100%', minHeight: 150 }} />
      {(!site?.lat || !site?.lng) && (
        <div style={{ position: 'absolute', inset: 0, display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 1, color: 'rgba(255,255,255,0.6)', fontSize: '0.8rem' }}>
          위치 정보 없음
        </div>
      )}
    </div>
  )
}

function formatAddress(addr) {
  if (!addr) return ''
  const i = addr.indexOf('//')
  return (i !== -1 ? addr.slice(i + 2) : addr).replace(/^\d{5}\s*/, '').trim()
}

function InfoRow({ label, value, highlight }) {
  return (
    <div className="info-row">
      <div className="label">{label}</div>
      <div className={`value${highlight ? ' highlight' : ''}`}>{value || '—'}</div>
    </div>
  )
}

export default function PlantCard({ sites = [], selectedSite, site, onSelect, appKey = '' }) {
  const [searchQuery, setSearchQuery] = useState('')
  const [dropdownOpen, setDropdownOpen] = useState(false)
  const dropdownRef = useRef(null)

  useEffect(() => {
    function handler(e) {
      if (dropdownRef.current && !dropdownRef.current.contains(e.target)) setDropdownOpen(false)
    }
    document.addEventListener('click', handler)
    return () => document.removeEventListener('click', handler)
  }, [])

  const filteredSites = sites.filter((s) =>
    s.name.toLowerCase().includes(searchQuery.toLowerCase())
  )

  return (
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
              ) : filteredSites.map((s) => (
                <li
                  key={s.id}
                  className={s.id === selectedSite?.id ? 'selected' : ''}
                  onClick={() => { onSelect(s); setDropdownOpen(false); setSearchQuery('') }}
                >
                  {s.name}
                </li>
              ))}
            </ul>
          </div>
        )}
      </div>

      {/* 지도 */}
      <div style={{
        height: 200, flex: 'none', marginBottom: 8,
        borderRadius: 'var(--radius-sm)',
        background: 'linear-gradient(145deg, #1e3a5f 0%, #2d5a87 40%, #4a7c59 100%)',
        position: 'relative',
        overflow: 'hidden',
      }}>
        <SiteMarkerMap appKey={appKey} site={site} />
      </div>

      {/* 발전소 정보 */}
      {site && (
        <div className="info-grid">
          <InfoRow label="발전소명" value={site.name.replace(/\[.*?\]\s*/, '')} highlight />
          <InfoRow label="주소"     value={formatAddress(site.address)} />
          <InfoRow label="설비용량" value={site.capacityKw ? `${formatNum(site.capacityKw, 1)} kW` : ''} />
          <InfoRow label="인버터"   value={site.invBrand || '—'} />
          <InfoRow label="수량"     value={site.inverterCount ? `${site.inverterCount} 대` : ''} />
          {site.registeredAt && <InfoRow label="등록일시" value={site.registeredAt} />}
          <InfoRow label="최종수신" value={site.lastReceivedAt || '—'} />
        </div>
      )}
    </section>
  )
}
