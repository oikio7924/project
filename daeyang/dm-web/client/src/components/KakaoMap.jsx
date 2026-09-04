import { useEffect, useRef, useState, useMemo, forwardRef, useImperativeHandle } from 'react'

const INIT_LAT   = 36.2
const INIT_LNG   = 127.8
const INIT_LEVEL = 13

// 대한민국 시도 전체 목록 (주소 첫 토큰 인식에 사용)
const SIDO_SET = new Set([
  '서울특별시', '부산광역시', '대구광역시', '인천광역시', '광주광역시',
  '대전광역시', '울산광역시', '세종특별자치시', '경기도', '강원도', '강원특별자치도',
  '충청북도', '충청남도', '전라북도', '전북특별자치도', '전라남도', '경상북도', '경상남도',
  '제주특별자치도',
])

// 지도 표시용 시도 축약명
const SIDO_SHORT = {
  '서울특별시': '서울', '부산광역시': '부산', '대구광역시': '대구',
  '인천광역시': '인천', '광주광역시': '광주', '대전광역시': '대전',
  '울산광역시': '울산', '세종특별자치시': '세종', '경기도': '경기',
  '강원도': '강원', '충청북도': '충북', '충청남도': '충남',
  '전라북도': '전북', '전라남도': '전남', '경상북도': '경북',
  '경상남도': '경남', '제주특별자치도': '제주',
}
function shortSido(sido) { return SIDO_SHORT[sido] || sido }

// SDK 한 번만 로드 (export해서 다른 컴포넌트와 공유)
let sdkLoading = false
const sdkCbs = []
export function loadSdk(key, cb) {
  if (window.kakao?.maps) { cb(); return }
  sdkCbs.push(cb)
  if (sdkLoading) return
  sdkLoading = true
  const sc = document.createElement('script')
  sc.src = `//dapi.kakao.com/v2/maps/sdk.js?appkey=${key}&autoload=false`
  sc.onload = () => window.kakao.maps.load(() => { sdkCbs.forEach(f => f()); sdkCbs.length = 0 })
  document.head.appendChild(sc)
}

// 축약 시도명 → 전체명 변환 테이블
const SIDO_ABBR = {
  '서울': '서울특별시', '부산': '부산광역시', '대구': '대구광역시',
  '인천': '인천광역시', '광주': '광주광역시', '대전': '대전광역시',
  '울산': '울산광역시', '세종': '세종특별자치시',
  '경기': '경기도', '강원': '강원도', '강원특별자치도': '강원도',
  '충북': '충청북도', '충남': '충청남도',
  '전북': '전라북도', '전북특별자치도': '전라북도', '전남': '전라남도',
  '경북': '경상북도', '경남': '경상남도',
  '제주': '제주특별자치도',
}

// 주소 파싱: "/" 또는 "//" 앞은 무조건 무시 (우편번호 있든 없든)
// 전체명("전라남도")·축약명("전남") 모두 인식
function parseAddr(raw = '') {
  // // 또는 / 뒤부터 읽기 (// 먼저 시도, 없으면 / 시도)
  const dbl = raw.indexOf('//')
  const sgl = raw.indexOf('/')
  let s
  if (dbl !== -1)      s = raw.slice(dbl + 2)
  else if (sgl !== -1) s = raw.slice(sgl + 1)
  else                 s = raw
  s = s.trim()
  const p = s.split(/\s+/)
  let i = 0, sido = ''

  if (SIDO_SET.has(p[0])) {
    // 전체명: 전라남도, 경기도, 서울특별시 ...
    sido = p[0]; i = 1
  } else if (SIDO_ABBR[p[0]]) {
    // 축약명: 전남, 경기, 광주 ...
    sido = SIDO_ABBR[p[0]]; i = 1
  }
  // 시도 없는 주소(해남군, 나주시 등)는 sido='' → DB 수정 필요

  return { sido, sigungu: p[i] || '', eupmyeondong: p[i + 1] || '' }
}

// 사이트 배열을 keyFn 기준으로 그룹화, 중심 좌표 계산
function groupBy(sites, keyFn) {
  const map = {}
  sites.forEach(s => {
    const k = keyFn(s) || '기타'
    if (!map[k]) map[k] = []
    map[k].push(s)
  })
  return Object.entries(map).map(([key, list]) => ({
    key,
    sites: list,
    lat: list.reduce((a, s) => a + Number(s.lat), 0) / list.length,
    lng: list.reduce((a, s) => a + Number(s.lng), 0) / list.length,
  }))
}

// 클릭 가능한 버블 DOM 생성
function makeBubble(label, count, tooltip, onClick) {
  const wrap = document.createElement('div')
  wrap.className = 'map-bubble-wrap'
  wrap.innerHTML = `
    ${label ? `<div class="map-region-label">${label}</div>` : ''}
    <div class="map-count-dot">${count}</div>
    ${tooltip ? `<div class="map-tooltip">${tooltip}</div>` : ''}
  `
  wrap.addEventListener('click', e => { e.stopPropagation(); onClick() })
  return wrap
}

// ── 컴포넌트 ────────────────────────────────────────────────────────────────
const KakaoMap = forwardRef(function KakaoMap({ appKey, sites, onSelectSite, onFilterSites }, ref) {
  const containerRef  = useRef(null)
  const mapRef        = useRef(null)
  const overlaysRef   = useRef([])
  const indivSitesRef = useRef([]) // depth 3 에서 표시할 개별 사이트

  // 계층 탐색 상태: depth 0=시도, 1=시군구, 2=읍면동, 3=개별
  const [nav, setNav] = useState({ depth: 0, sido: '', sigungu: '', eupmyeondong: '' })

  // sites 변경 시에만 주소 파싱 — drawLevel 내 중복 parseAddr 호출 방지
  const parsedAddrMap = useMemo(() => {
    const m = new Map()
    sites.forEach((s) => { m.set(s.id, parseAddr(s.address)) })
    return m
  }, [sites])

  // 부모에서 ref.current.reset() 호출 가능
  useImperativeHandle(ref, () => ({
    reset() {
      if (!mapRef.current || !window.kakao?.maps) return
      mapRef.current.setCenter(new window.kakao.maps.LatLng(INIT_LAT, INIT_LNG))
      mapRef.current.setLevel(INIT_LEVEL)
      setNav({ depth: 0, sido: '', sigungu: '', eupmyeondong: '' })
      onFilterSites?.(null)
    },
  }))

  useEffect(() => {
    if (!appKey || !containerRef.current) return
    loadSdk(appKey, initMap)
    return () => { mapRef.current = null }
  }, [appKey])

  // nav 또는 sites 변경 시 오버레이 다시 그리기
  useEffect(() => {
    if (mapRef.current) drawLevel(nav)
  }, [sites, nav])

  function initMap() {
    if (!containerRef.current || mapRef.current) return
    const kakao = window.kakao
    const map = new kakao.maps.Map(containerRef.current, {
      center: new kakao.maps.LatLng(INIT_LAT, INIT_LNG),
      level: INIT_LEVEL,
      mapTypeId: kakao.maps.MapTypeId.HYBRID,
    })
    mapRef.current = map
    drawLevel({ depth: 0, sido: '', sigungu: '', eupmyeondong: '' })
  }

  function clearOverlays() {
    overlaysRef.current.forEach(o => o.setMap(null))
    overlaysRef.current = []
  }

  function addOverlay(pos, content) {
    const o = new window.kakao.maps.CustomOverlay({
      map: mapRef.current, position: pos, content, yAnchor: 1.0, zIndex: 5,
    })
    overlaysRef.current.push(o)
  }

  // 사이트 목록에 맞게 지도 범위 이동
  function zoomTo(siteList) {
    const kakao = window.kakao
    if (!siteList.length || !mapRef.current) return
    if (siteList.length === 1) {
      mapRef.current.setCenter(new kakao.maps.LatLng(Number(siteList[0].lat), Number(siteList[0].lng)))
      mapRef.current.setLevel(8, { animate: true })
      return
    }
    const bounds = new kakao.maps.LatLngBounds()
    siteList.forEach(s => bounds.extend(new kakao.maps.LatLng(Number(s.lat), Number(s.lng))))
    mapRef.current.setBounds(bounds, 80, 80, 80, 80)
  }

  // 현재 depth에 맞는 클러스터 버블 그리기
  function drawLevel(curNav) {
    const kakao = window.kakao
    if (!kakao?.maps || !mapRef.current) return
    clearOverlays()

    const valid = sites.filter(s => s.lat && s.lng)
    const { depth, sido, sigungu } = curNav

    // ── depth 3: 읍면동 내 개별 사이트 ─────────────────────────────
    if (depth === 3) {
      indivSitesRef.current.forEach(s => {
        const name = s.name.replace(/\[.*?\]\s*/, '')
        const pos = new kakao.maps.LatLng(Number(s.lat), Number(s.lng))
        const wrap = makeBubble('', 1, name, () => {
          onSelectSite?.(s)
          mapRef.current.setLevel(5, { anchor: pos, animate: true })
        })
        addOverlay(pos, wrap)
      })
      return
    }

    // ── depth 0~2: 행정구역별 클러스터 ──────────────────────────────
    let baseSites = valid
    let keyFn

    const pa = (s) => parsedAddrMap.get(s.id) || parseAddr(s.address)

    if (depth === 0) {
      keyFn = s => pa(s).sido
    } else if (depth === 1) {
      baseSites = valid.filter(s => (pa(s).sido || '기타') === sido)
      keyFn = s => pa(s).sigungu
    } else {
      baseSites = valid.filter(s => {
        const p = pa(s)
        return (p.sido || '기타') === sido && p.sigungu === sigungu
      })
      keyFn = s => pa(s).eupmyeondong
    }

    const groups = groupBy(baseSites, keyFn)

    groups.forEach(g => {
      const pos = new kakao.maps.LatLng(g.lat, g.lng)
      const tooltip = g.sites.length === 1 ? g.sites[0].name.replace(/\[.*?\]\s*/, '') : ''

      // depth 0(시도)은 축약명으로 표시, 나머지는 원본 그대로
      const displayKey = depth === 0 ? shortSido(g.key) : g.key
      const wrap = makeBubble(displayKey, g.sites.length, tooltip, () => {
        if (depth === 0) {
          // 시도 클릭 → 시군구 레벨
          const next = { depth: 1, sido: g.key, sigungu: '', eupmyeondong: '' }
          setNav(next)
          onFilterSites?.(g.sites)
          zoomTo(g.sites)
        } else if (depth === 1) {
          // 시군구 클릭 → 읍면동 레벨
          const next = { depth: 2, sido, sigungu: g.key, eupmyeondong: '' }
          setNav(next)
          onFilterSites?.(g.sites)
          zoomTo(g.sites)
        } else {
          // 읍면동 클릭
          if (g.sites.length === 1) {
            // 단일 사이트 → 바로 선택
            onSelectSite?.(g.sites[0])
            mapRef.current.setLevel(5, { anchor: pos, animate: true })
          } else {
            // 여러 사이트 → 개별 표시 (depth 3)
            indivSitesRef.current = g.sites
            setNav({ depth: 3, sido, sigungu, eupmyeondong: g.key })
            onFilterSites?.(g.sites)
            zoomTo(g.sites)
          }
        }
      })
      addOverlay(pos, wrap)
    })
  }

  // 브레드크럼 목록
  const crumbs = []
  if (nav.depth >= 1) crumbs.push({ label: shortSido(nav.sido), back: 0 })
  if (nav.depth >= 2) crumbs.push({ label: nav.sigungu,     back: 1 })
  if (nav.depth >= 3) crumbs.push({ label: nav.eupmyeondong, back: 2 })

  function goBack(targetDepth) {
    const next = { ...nav, depth: targetDepth }
    if (targetDepth <= 0) { next.sido = ''; next.sigungu = ''; next.eupmyeondong = '' }
    if (targetDepth <= 1) { next.sigungu = ''; next.eupmyeondong = '' }
    if (targetDepth <= 2) { next.eupmyeondong = '' }
    setNav(next)
    onFilterSites?.(null)
  }

  return (
    <div style={{ position: 'relative', width: '100%', height: '100%' }}>
      <div ref={containerRef} style={{ width: '100%', height: '100%', minHeight: 400 }} />

      {/* 지도 위 브레드크럼 (현재 위치 표시 + 클릭으로 상위 이동) */}
      {crumbs.length > 0 && (
        <div style={{
          position: 'absolute', top: 10, left: 10, zIndex: 10,
          display: 'flex', alignItems: 'center', gap: 4,
          background: 'rgba(15,40,71,0.88)', padding: '5px 12px',
          borderRadius: 6, fontSize: 12, color: '#fff',
          boxShadow: '0 2px 8px rgba(0,0,0,0.3)',
        }}>
          <span style={{ cursor: 'pointer', opacity: 0.65 }} onClick={() => goBack(0)}>전국</span>
          {crumbs.map((c, i) => (
            <span key={i} style={{ display: 'flex', alignItems: 'center', gap: 4 }}>
              <span style={{ opacity: 0.4 }}>›</span>
              <span
                style={{
                  cursor: i < crumbs.length - 1 ? 'pointer' : 'default',
                  opacity: i < crumbs.length - 1 ? 0.65 : 1,
                  fontWeight: i === crumbs.length - 1 ? 700 : 400,
                }}
                onClick={() => i < crumbs.length - 1 && goBack(c.back + 1)}
              >
                {c.label}
              </span>
            </span>
          ))}
        </div>
      )}
    </div>
  )
})

export default KakaoMap
