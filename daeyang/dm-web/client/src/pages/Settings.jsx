import { useState, useEffect } from 'react'
import { apiGet, apiSend } from '../api'

export default function Settings() {
  const [form, setForm] = useState({ username: '', email: '', mobile: '', password: '', passwordConfirm: '' })
  const [message, setMessage] = useState('')

  useEffect(() => {
    apiGet('/api/settings').then((d) => {
      setForm((prev) => ({ ...prev, username: d.username || '', email: d.email || '', mobile: d.mobile || '' }))
    }).catch(console.error)
  }, [])

  function update(key) {
    return (e) => setForm({ ...form, [key]: e.target.value })
  }

  async function handleSave(e) {
    e.preventDefault()
    if (form.password && form.password !== form.passwordConfirm) {
      setMessage('비밀번호가 일치하지 않습니다.')
      return
    }
    try {
      await apiSend('/api/settings', 'PUT', { email: form.email, mobile: form.mobile, password: form.password })
      setMessage('저장되었습니다.')
      setForm((prev) => ({ ...prev, password: '', passwordConfirm: '' }))
    } catch (err) {
      setMessage(err.message)
    }
  }

  return (
    <div className="wrap-scroll">
      <div className="card settings-card">
        <h2 className="card-title"><span className="card-title-dot" />개인설정</h2>
        <form onSubmit={handleSave}>
          <table className="form-table">
            <tbody>
              <tr className="form-row">
                <th>아이디</th>
                <td><input value={form.username} disabled /></td>
                <th>이메일</th>
                <td><input type="email" value={form.email} onChange={update('email')} /></td>
              </tr>
              <tr className="form-row">
                <th>휴대폰</th>
                <td><input value={form.mobile} onChange={update('mobile')} /></td>
                <th></th>
                <td></td>
              </tr>
              <tr className="form-row">
                <th>새 비밀번호</th>
                <td><input type="password" value={form.password} onChange={update('password')} placeholder="변경 시에만 입력" /></td>
                <th>비밀번호 확인</th>
                <td><input type="password" value={form.passwordConfirm} onChange={update('passwordConfirm')} /></td>
              </tr>
            </tbody>
          </table>
          {message && <p style={{ margin: '8px 0', color: message.includes('저장') ? 'var(--success)' : 'var(--danger)' }}>{message}</p>}
          <div style={{ marginTop: 12 }}>
            <button type="submit" className="btn btn-primary">저장</button>
          </div>
        </form>
      </div>
    </div>
  )
}
