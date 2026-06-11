import { createContext } from 'react'
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom'
import Layout from './components/Layout'
import Login from './pages/Login'
import Overview from './pages/Overview'
import Generation from './pages/Generation'
import Statistics from './pages/Statistics'
import Board from './pages/Board'
import Settings from './pages/Settings'
import SafetyMain      from './pages/SafetyMain'
import SafetyManage    from './pages/SafetyManage'
import SafetyEquipment from './pages/SafetyEquipment'
import AdminLayout from './pages/admin/AdminLayout'
import AdminMembers from './pages/admin/AdminMembers'
import AdminPlants from './pages/admin/AdminPlants'
import AdminMapKeys from './pages/admin/AdminMapKeys'

export const UserContext = createContext(null)

export default function App() {
  return (
    <BrowserRouter>
      <Routes>
        {/* 로그인 페이지 (사이드바 없음) */}
        <Route path="/login" element={<Login />} />

        {/* 일반 페이지 (사이드바 포함) */}
        <Route element={<Layout />}>
          <Route path="/" element={<Overview />} />
          <Route path="/generation" element={<Generation />} />
          <Route path="/statistics" element={<Statistics />} />
          <Route path="/notice" element={<Board />} />
          <Route path="/settings" element={<Settings />} />
          <Route path="/safety/main"      element={<SafetyMain />} />
          <Route path="/safety/manage"    element={<SafetyManage />} />
          <Route path="/safety/equipment" element={<SafetyEquipment />} />
        </Route>

        {/* 관리자 페이지 */}
        <Route path="/admin" element={<AdminLayout />}>
          <Route index element={<Navigate to="/admin/members" replace />} />
          <Route path="members" element={<AdminMembers />} />
          <Route path="plants" element={<AdminPlants />} />
          <Route path="map-keys" element={<AdminMapKeys />} />
        </Route>

        {/* 그 외 경로 → 홈으로 */}
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </BrowserRouter>
  )
}
