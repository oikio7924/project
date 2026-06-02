import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import { apiSend } from '../api'

export default function Login() {
  const navigate = useNavigate()
  const [username, setUsername] = useState('')

  // 로그인 페이지는 사이드바 없음 → body에 no-sidebar 클래스 추가
  useEffect(() => {
    document.body.classList.add('no-sidebar')
    return () => document.body.classList.remove('no-sidebar')
  }, [])
  const [password, setPassword] = useState('')
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)

  async function handleSubmit(e) {
    e.preventDefault()
    setError('')
    setLoading(true)
    try {
      await apiSend('/api/login', 'POST', { username, password })
      navigate('/')
    } catch (err) {
      setError(err.message)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="login-bg">
      <div className="login-box">
        <div className="login-logo-wrap">
          <img src="/image/logo-color.png" alt="대양기업 로고" className="login-logo" />
        </div>
        <h1 className="login-title">DAEYANG 모니터링</h1>

        <form className="login-form" onSubmit={handleSubmit}>
          <div className="login-field">
            <label>아이디</label>
            <input
              type="text"
              value={username}
              onChange={(e) => setUsername(e.target.value)}
              placeholder="아이디 입력"
              autoComplete="username"
              required
            />
          </div>
          <div className="login-field">
            <label>비밀번호</label>
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="비밀번호 입력"
              autoComplete="current-password"
              required
            />
          </div>

          {error && <p className="login-error">{error}</p>}

          <button type="submit" className="btn btn-primary login-btn" disabled={loading}>
            {loading ? '로그인 중...' : '로그인'}
          </button>
        </form>
      </div>
    </div>
  )
}
