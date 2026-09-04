import { useState, useEffect, useContext } from 'react'
import { NavLink, useNavigate } from 'react-router-dom'
import { apiSend } from '../api'
import { UserContext } from '../App'

// role: user=일반사용자 / admin=관리자 / developer=개발자
const NAV_ITEMS = [
  {
    path: '/',
    label: '종합현황',
    minRole: 'admin',
    icon: <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>,
  },
  {
    path: '/generation',
    label: '발전현황',
    icon: <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/></svg>,
  },
  {
    path: '/statistics',
    label: '통계분석',
    icon: <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg>,
  },
  {
    path: '/notice',
    label: '공지사항',
    icon: <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/></svg>,
  },
  {
    path: '/settings',
    label: '설정',
    icon: <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83-2.83l.06-.06A1.65 1.65 0 0 0 4.68 15a1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 2.83-2.83l.06.06A1.65 1.65 0 0 0 9 4.68a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 2.83l-.06.06A1.65 1.65 0 0 0 19.4 9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"/></svg>,
  },
  {
    path: '/safety',
    label: '안전관리',
    safetyOnly: true,
    icon: <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/><polyline points="9 12 11 14 15 10"/></svg>,
  },
]

const ICON_DOC   = <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><rect x="4" y="2" width="16" height="20" rx="2"/><line x1="8" y1="6" x2="16" y2="6"/><line x1="8" y1="10" x2="10" y2="10"/><line x1="14" y1="10" x2="16" y2="10"/><line x1="8" y1="14" x2="10" y2="14"/><line x1="14" y1="14" x2="16" y2="14"/><line x1="8" y1="18" x2="10" y2="18"/><line x1="14" y1="18" x2="16" y2="18"/></svg>
const ICON_CHECK = <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/></svg>
const ICON_SAFE  = <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
const ICON_LINK  = <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"/><polyline points="15 3 21 3 21 9"/><line x1="10" y1="14" x2="21" y2="3"/></svg>

// 일반 사용자용 바로가기
const QUICK_USER = [
  { label: '국세청 홈택스', href: 'https://www.hometax.go.kr', external: true, icon: ICON_LINK },
]

// 관리자/개발자용 바로가기
const QUICK_ADMIN = [
  { label: '대양세금계산서',  href: 'http://dymonitering.co.kr/htweb/', external: true,  icon: ICON_DOC   },
  { label: '대양인허가관리',  href: 'http://dymonitering.co.kr/bdweb/', external: true,  icon: ICON_CHECK },
  { label: '대양안전관리',    href: null,                               external: false, icon: ICON_SAFE  },
  { label: '국세청 홈택스',   href: 'https://www.hometax.go.kr',        external: true,  icon: ICON_LINK  },
  { label: '전력거래소',      href: 'https://www.kpx.or.kr',            external: true,  icon: ICON_LINK  },
  { label: '한국에너지공단',  href: 'https://www.energy.or.kr',          external: true,  icon: ICON_LINK  },
]

export default function Sidebar({ userName }) {
  const navigate = useNavigate()
  const user = useContext(UserContext)
  const role = user?.role || 'user'
  const isAdminOrDev = role === 'admin' || role === 'developer'
  const isPartner    = role === 'partner_admin'
  const isSafety     = role === 'safety_admin'
  const quickLinks   = isAdminOrDev ? QUICK_ADMIN : QUICK_USER
  const [collapsed, setCollapsed]   = useState(false)
  const [quickOpen, setQuickOpen]   = useState(false)
  const [safetyOpen, setSafetyOpen] = useState(false)
  const [comingSoon, setComingSoon] = useState(null)

  // 저장된 상태 복원
  useEffect(() => {
    const saved = localStorage.getItem('sidebar-collapsed') === '1'
    setCollapsed(saved)
  }, [])

  // collapsed 상태를 body 클래스에 동기화 (CSS가 body.sidebar-collapsed 에 의존)
  useEffect(() => {
    document.body.classList.toggle('sidebar-collapsed', collapsed)
  }, [collapsed])

  function toggleCollapse() {
    const next = !collapsed
    setCollapsed(next)
    localStorage.setItem('sidebar-collapsed', next ? '1' : '0')
  }

  async function handleLogout() {
    await apiSend('/api/logout', 'POST')
    navigate('/login')
  }

  return (
    <>
      <aside className={`sidebar${collapsed ? ' collapsed' : ''}`} id="sidebar">
        {/* 헤더 */}
        <div className="sidebar-header">
          <button className="sidebar-toggle" onClick={toggleCollapse} aria-label="메뉴 접기/펴기">
            <span /><span /><span />
          </button>
          <NavLink to="/" className="sidebar-logo-link">
            <img src="/image/logo-color.png" alt="대양기업 로고" className="sidebar-logo" />
          </NavLink>
        </div>

        {/* 메인 네비게이션 */}
        <nav className="sidebar-nav" id="main-nav">
          {NAV_ITEMS.filter((item) => {
            if (item.safetyOnly) return false   // 안전관리는 별도 하위메뉴로 처리
            if (item.minRole)    return isAdminOrDev || isPartner || isSafety
            return true
          }).map((item) => (
            <NavLink
              key={item.path}
              to={item.path}
              end={item.path === '/'}
              className={({ isActive }) => `sidebar-link${isActive ? ' active' : ''}`}
              title={item.label}
            >
              <span className="sidebar-icon">{item.icon}</span>
              <span className="sidebar-label">{item.label}</span>
            </NavLink>
          ))}

          {/* 안전관리 하위메뉴 */}
          {(isSafety || isAdminOrDev) && (<>
          <hr className="sidebar-divider" />
          <button type="button" className={`sidebar-link sidebar-link-parent${safetyOpen ? ' open' : ''}`} title="안전관리" onClick={() => setSafetyOpen(v => !v)}>
            <span className="sidebar-icon">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/><polyline points="9 12 11 14 15 10"/></svg>
            </span>
            <span className="sidebar-label">안전관리</span>
            <svg className="sidebar-chevron" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round"><polyline points="6 9 12 15 18 9"/></svg>
          </button>
          <div className={`sidebar-submenu${safetyOpen ? ' open' : ''}`}>
            <NavLink to="/safety/main"      className={({ isActive }) => `sidebar-subitem${isActive ? ' active' : ''}`} title="메인">
              <span className="sidebar-label">메인</span>
            </NavLink>
            <NavLink to="/safety/manage"    className={({ isActive }) => `sidebar-subitem${isActive ? ' active' : ''}`} title="일정관리">
              <span className="sidebar-label">일정관리</span>
            </NavLink>
            <NavLink to="/safety/equipment" className={({ isActive }) => `sidebar-subitem${isActive ? ' active' : ''}`} title="장비관리">
              <span className="sidebar-label">장비관리</span>
            </NavLink>
          </div>
          </>)}

          {isAdminOrDev && (<>
          <hr className="sidebar-divider" />
          <NavLink to="/admin" className={({ isActive }) => `sidebar-link${isActive ? ' active' : ''}`} title="관리자페이지">
            <span className="sidebar-icon">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
            </span>
            <span className="sidebar-label">관리자페이지</span>
          </NavLink>
          </>)}

          <hr className="sidebar-divider" />

          {/* 바로가기 */}
          <button
            type="button"
            className={`sidebar-link sidebar-link-parent${quickOpen ? ' open' : ''}`}
            title="바로가기"
            onClick={() => setQuickOpen((v) => !v)}
          >
            <span className="sidebar-icon">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"/><polyline points="15 3 21 3 21 9"/><line x1="10" y1="14" x2="21" y2="3"/></svg>
            </span>
            <span className="sidebar-label">바로가기</span>
            <svg className="sidebar-chevron" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round"><polyline points="6 9 12 15 18 9"/></svg>
          </button>

          <div className={`sidebar-submenu${quickOpen ? ' open' : ''}`}>
            {quickLinks.map((link) =>
              link.external ? (
                <a key={link.label} href={link.href} className="sidebar-subitem" target="_blank" rel="noopener noreferrer" title={link.label}>
                  <span className="sidebar-subitem-icon">{link.icon}</span>
                  <span className="sidebar-label">{link.label}</span>
                </a>
              ) : (
                <button key={link.label} type="button" className="sidebar-subitem" title={link.label} onClick={() => setComingSoon(link.label)}>
                  <span className="sidebar-subitem-icon">{link.icon}</span>
                  <span className="sidebar-label">{link.label}</span>
                </button>
              )
            )}
          </div>
        </nav>

        {/* 하단 사용자 정보 */}
        <div className="sidebar-footer">
          <div className="sidebar-user-info">
            <svg className="sidebar-user-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
            <span className="sidebar-user-name">{userName || '사용자'}</span>
            <span className="sidebar-user-nim">님</span>
            <button className="sidebar-logout-btn" title="로그아웃" onClick={handleLogout}>
              <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
            </button>
          </div>
        </div>
      </aside>

      {/* 추후 오픈 모달 */}
      {comingSoon && (
        <div className="modal-overlay" onClick={() => setComingSoon(null)}>
          <div className="modal-box" style={{ maxWidth: 320, textAlign: 'center' }} onClick={(e) => e.stopPropagation()}>
            <div className="modal-header">
              <h3>{comingSoon}</h3>
              <button className="modal-close" onClick={() => setComingSoon(null)}>&times;</button>
            </div>
            <div className="modal-body"><p style={{ margin: '16px 0', fontSize: '0.9rem', color: 'var(--text-muted)' }}>추후 오픈 예정입니다.</p></div>
            <div className="modal-footer" style={{ justifyContent: 'center' }}>
              <button className="btn btn-primary" onClick={() => setComingSoon(null)}>확인</button>
            </div>
          </div>
        </div>
      )}
    </>
  )
}
