import { useState, useEffect } from 'react'
import { Outlet, useNavigate } from 'react-router-dom'
import { apiGet } from '../api'
import { UserContext } from '../App'
import Sidebar from './Sidebar'

export default function Layout() {
  const navigate = useNavigate()
  const [user, setUser] = useState(null)

  useEffect(() => {
    apiGet('/api/me')
      .then((data) => setUser(data.user))
      .catch(() => navigate('/login'))
  }, [])

  return (
    // user 정보를 하위 컴포넌트(Sidebar, 각 페이지)에서 useContext로 사용 가능
    <UserContext.Provider value={user}>
      <Sidebar userName={user?.displayName || user?.username} />
      <Outlet />
    </UserContext.Provider>
  )
}
