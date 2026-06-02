import { useEffect, useState } from 'react'
import { Outlet, NavLink, useNavigate, useLocation } from 'react-router-dom'
import { apiGet, apiSend } from '../../api'

const ADMIN_NAV = [
  { path: '/admin/members',  label: '회원관리',   breadcrumb: '회원 관리 > 회원리스트' },
  { path: '/admin/plants',   label: '발전소관리',  breadcrumb: '발전소 관리' },
  { path: '/admin/map-keys', label: '지도키 관리', breadcrumb: '지도키 관리' },
]

export default function AdminLayout() {
  const navigate = useNavigate()
  const { pathname } = useLocation()

  const current = ADMIN_NAV.find((n) => pathname.startsWith(n.path))
  const breadcrumb = current?.breadcrumb || ''

  useEffect(() => {
    apiGet('/api/me').catch(() => navigate('/login'))
  }, [])

  // body.admin-body 클래스 관리
  useEffect(() => {
    document.body.classList.add('admin-body')
    return () => document.body.classList.remove('admin-body')
  }, [])

  async function handleLogout() {
    await apiSend('/api/logout', 'POST')
    navigate('/login')
  }

  return (
    <>
      <aside className="admin-sidebar">
        {/* 브랜드 */}
        <div className="admin-sidebar-brand">
          <img src="/image/logo-color.png" alt="대양기업" />
          <span>dy 관리자페이지</span>
        </div>

        {/* 네비게이션 */}
        <nav className="admin-nav">
          {ADMIN_NAV.map((item) => (
            <NavLink
              key={item.path}
              to={item.path}
              className={({ isActive }) => isActive ? 'active' : ''}
            >
              {item.label}
            </NavLink>
          ))}
        </nav>

        {/* 하단 로그아웃 */}
        <div className="admin-sidebar-foot">
          <a href="#" onClick={(e) => { e.preventDefault(); handleLogout() }}>로그아웃</a>
        </div>
      </aside>

      <div className="admin-main">
        {/* 상단바 */}
        <header className="admin-topbar">
          <div className="admin-breadcrumb">
            관리자페이지 &gt; <strong>{breadcrumb}</strong>
          </div>
          <div className="admin-topbar-actions">
            <NavLink to="/" className="btn btn-ghost">모니터링</NavLink>
          </div>
        </header>

        {/* 페이지 내용 */}
        <main className="admin-content">
          <Outlet />
        </main>
      </div>
    </>
  )
}
