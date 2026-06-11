import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import { apiSend } from '../api'

export default function Login() {
  const navigate = useNavigate()
  const [username, setUsername] = useState('')
  const [password, setPassword] = useState('')
  const [rememberMe, setRememberMe] = useState(false)
  const [autoLogin, setAutoLogin] = useState(false)
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    document.body.classList.add('no-sidebar')
    return () => document.body.classList.remove('no-sidebar')
  }, [])

  useEffect(() => {
    const savedId = localStorage.getItem('dm_username')
    const savedAuto = localStorage.getItem('dm_auto_login') === 'true'
    const savedPw = localStorage.getItem('dm_password')

    if (savedId) {
      setUsername(savedId)
      setRememberMe(true)
    }
    if (savedAuto && savedId && savedPw) {
      setAutoLogin(true)
      doLogin(savedId, atob(savedPw), true)
    }
  }, [])

  async function doLogin(u, p, silent = false) {
    if (!silent) setError('')
    setLoading(true)
    try {
      await apiSend('/api/login', 'POST', { username: u, password: p })
      navigate('/')
    } catch (err) {
      if (silent) {
        // 자동로그인 실패 시 저장 정보 초기화
        localStorage.removeItem('dm_auto_login')
        localStorage.removeItem('dm_password')
        setAutoLogin(false)
      } else {
        setError(err.message)
      }
    } finally {
      setLoading(false)
    }
  }

  async function handleSubmit(e) {
    e.preventDefault()

    if (rememberMe) {
      localStorage.setItem('dm_username', username)
    } else {
      localStorage.removeItem('dm_username')
    }

    if (autoLogin) {
      localStorage.setItem('dm_auto_login', 'true')
      localStorage.setItem('dm_password', btoa(password))
    } else {
      localStorage.removeItem('dm_auto_login')
      localStorage.removeItem('dm_password')
    }

    await doLogin(username, password)
  }

  function handleRememberMe(checked) {
    setRememberMe(checked)
    if (!checked) {
      setAutoLogin(false)
      localStorage.removeItem('dm_auto_login')
      localStorage.removeItem('dm_password')
    }
  }

  function handleAutoLogin(checked) {
    setAutoLogin(checked)
    if (checked) setRememberMe(true)
  }

  return (
    <div className="login-bg">
      <div className="login-box">
        <div className="login-logo-wrap">
          <img src="/image/logo-color.png" alt="대양기업 로고" className="login-logo" />
        </div>
        <h1 className="login-title">태양광 발전 모니터링</h1>

        <form onSubmit={handleSubmit}>
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

          <div className="login-check-row">
            <label className="login-check-label">
              <input
                type="checkbox"
                checked={rememberMe}
                onChange={(e) => handleRememberMe(e.target.checked)}
              />
              아이디 저장
            </label>
            <label className="login-check-label">
              <input
                type="checkbox"
                checked={autoLogin}
                onChange={(e) => handleAutoLogin(e.target.checked)}
              />
              자동로그인
            </label>
          </div>

          {error && <p className="login-error">{error}</p>}

          <button type="submit" className="login-btn" disabled={loading}>
            {loading ? '로그인 중...' : '로그인'}
          </button>
        </form>
      </div>
    </div>
  )
}
