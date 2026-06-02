import { useState, useEffect } from 'react'
import { apiGet, apiSend } from '../../api'

const ROLES = { admin: '관리자', site_admin: '현장 관리자', user: '일반 사용자' }

export default function AdminMembers() {
  const [members, setMembers] = useState([])
  const [total, setTotal] = useState(0)
  const [search, setSearch] = useState('')
  const [modal, setModal] = useState(null)
  const [form, setForm] = useState({ username: '', name: '', password: '', role: 'user', email: '', mobile: '' })

  useEffect(() => { loadMembers() }, [])

  function loadMembers(q = '') {
    const qs = q ? `?q=${encodeURIComponent(q)}` : ''
    apiGet(`/api/admin/members${qs}`)
      .then((d) => { setMembers(d.members || []); setTotal(d.total || 0) })
      .catch(console.error)
  }

  function openCreate() {
    setForm({ username: '', name: '', password: '', role: 'user', email: '', mobile: '' })
    setModal({ mode: 'create' })
  }

  function openEdit(m) {
    setForm({ username: m.username, name: m.name, password: '', role: m.role || 'user', email: m.email || '', mobile: m.phone || '' })
    setModal({ mode: 'edit', member: m })
  }

  function upd(key) { return (e) => setForm((p) => ({ ...p, [key]: e.target.value })) }

  async function handleSave() {
    try {
      if (modal.mode === 'create') {
        await apiSend('/api/admin/members', 'POST', form)
      } else {
        await apiSend(`/api/admin/members/${modal.member.id}`, 'PUT', form)
      }
      setModal(null)
      loadMembers(search)
    } catch (err) { alert(err.message) }
  }

  async function handleDelete(id) {
    if (!confirm('삭제하시겠습니까?')) return
    await apiSend(`/api/admin/members/${id}`, 'DELETE')
    loadMembers(search)
  }

  return (
    <div className="admin-panel">
      {/* 패널 헤더 */}
      <div className="admin-panel-head">
        <span>회원 리스트</span>
        <span>
          <button type="button" className="btn-admin-primary" onClick={openCreate}>+ 회원 등록</button>
        </span>
      </div>

      {/* 안내 */}
      <div className="admin-alert">회원 리스트를 확인합니다. 행을 클릭하면 수정할 수 있습니다.</div>

      {/* 검색 툴바 */}
      <div className="admin-toolbar">
        <span className="meta">총 {total}건</span>
        <input
          type="search"
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          onKeyDown={(e) => e.key === 'Enter' && loadMembers(search)}
          placeholder="모든필드 검색"
          style={{ flex: 1, maxWidth: 280 }}
        />
        <button type="button" className="btn-admin-primary" onClick={() => loadMembers(search)}>검색</button>
      </div>

      {/* 테이블 */}
      <div className="admin-table-wrap">
        <table className="admin-table">
          <thead>
            <tr>
              <th>번호</th><th>ID</th><th>이름</th><th>권한</th>
              <th>이메일</th><th>전화번호</th><th>마지막 로그인</th><th>관리</th>
            </tr>
          </thead>
          <tbody>
            {members.length === 0 ? (
              <tr><td colSpan={8} style={{ textAlign: 'center', padding: 20, color: '#94a3b8' }}>데이터가 없습니다.</td></tr>
            ) : (
              members.map((m, i) => (
                <tr key={m.id} onClick={() => openEdit(m)}>
                  <td>{i + 1}</td>
                  <td>{m.username}</td>
                  <td>{m.name}</td>
                  <td>
                    <span className={`role-badge${m.role ? ` ${m.role}` : ''}`}>
                      {ROLES[m.role] || m.role || '—'}
                    </span>
                  </td>
                  <td>{m.email || '—'}</td>
                  <td>{m.phone || '—'}</td>
                  <td>{m.lastLogin || '—'}</td>
                  <td onClick={(e) => e.stopPropagation()}>
                    <button className="btn-admin-danger" style={{ padding: '4px 10px', fontSize: '0.75rem' }}
                      onClick={() => handleDelete(m.id)}>삭제</button>
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>

      {/* 모달 */}
      {modal && (
        <div className="admin-modal-overlay" onClick={() => setModal(null)}>
          <div className="admin-modal" onClick={(e) => e.stopPropagation()}>
            <div className="admin-modal-header">
              <span>{modal.mode === 'create' ? '회원 등록' : '회원 수정'}</span>
              <button className="admin-modal-close" onClick={() => setModal(null)}>&times;</button>
            </div>
            <div className="admin-modal-body">
              <div className="admin-form-grid">
                <div className="label">아이디</div>
                <div className="field"><input value={form.username} onChange={upd('username')} disabled={modal.mode === 'edit'} /></div>
                <div className="label">이름</div>
                <div className="field"><input value={form.name} onChange={upd('name')} /></div>
                <div className="label">비밀번호</div>
                <div className="field"><input type="password" value={form.password} onChange={upd('password')} placeholder={modal.mode === 'edit' ? '변경 시에만 입력' : '필수'} /></div>
                <div className="label">권한</div>
                <div className="field">
                  <select value={form.role} onChange={upd('role')} style={{ width: '100%' }}>
                    <option value="user">일반 사용자</option>
                    <option value="site_admin">현장 관리자</option>
                    <option value="admin">관리자</option>
                  </select>
                </div>
                <div className="label">이메일</div>
                <div className="field"><input type="email" value={form.email} onChange={upd('email')} /></div>
                <div className="label">휴대전화</div>
                <div className="field"><input type="tel" value={form.mobile} onChange={upd('mobile')} /></div>
              </div>
            </div>
            <div className="admin-modal-footer">
              <button type="button" className="btn-admin-outline" onClick={() => setModal(null)}>취소</button>
              <button type="button" className="btn-admin-primary" onClick={handleSave}>저장</button>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
