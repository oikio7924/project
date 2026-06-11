import { useState, useEffect } from 'react'
import { apiGet, apiSend } from '../../api'

const ROLES = {
  user:         '일반 사용자',
  partner_admin:'파트너 관리자',
  safety_admin: '안전관리자',
  admin:        '관리자',
  developer:    '개발자',
}

const ROLE_BADGE_COLOR = {
  user:         '#64748b',
  partner_admin:'#0284c7',
  safety_admin: '#16a34a',
  admin:        '#7c3aed',
  developer:    '#0f2847',
}

export default function AdminMembers() {
  const [members, setMembers]   = useState([])
  const [total, setTotal]       = useState(0)
  const [search, setSearch]     = useState('')
  const [modal, setModal]       = useState(null)
  const [allPlants, setAllPlants] = useState([])
  const [form, setForm] = useState({
    username: '', name: '', password: '', role: 'user',
    email: '', mobile: '', plants: [],
  })

  useEffect(() => {
    loadMembers()
    apiGet('/api/admin/plants?limit=500')
      .then((d) => setAllPlants(d.plants || []))
      .catch(console.error)
  }, [])

  function loadMembers(q = '') {
    const qs = q ? `?q=${encodeURIComponent(q)}` : ''
    apiGet(`/api/admin/members${qs}`)
      .then((d) => { setMembers(d.members || []); setTotal(d.total || 0) })
      .catch(console.error)
  }

  function openCreate() {
    setForm({ username: '', name: '', password: '', role: 'user', email: '', mobile: '', plants: [] })
    setModal({ mode: 'create' })
  }

  function openEdit(m) {
    setForm({
      username: m.username, name: m.name, password: '',
      role: m.role || 'user', email: m.email || '',
      mobile: m.phone || '', plants: m.plants || [],
    })
    setModal({ mode: 'edit', member: m })
  }

  function upd(key) { return (e) => setForm((p) => ({ ...p, [key]: e.target.value })) }

  function togglePlant(id) {
    setForm((p) => ({
      ...p,
      plants: p.plants.includes(id)
        ? p.plants.filter((x) => x !== id)
        : [...p.plants, id],
    }))
  }

  async function handleSave() {
    try {
      const payload = { ...form, plants: form.plants.map(Number) }
      if (modal.mode === 'create') {
        await apiSend('/api/admin/members', 'POST', payload)
      } else {
        await apiSend(`/api/admin/members/${modal.member.id}`, 'PUT', payload)
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
      <div className="admin-panel-head">
        <span>회원 리스트</span>
        <button type="button" className="btn-admin-primary" onClick={openCreate}>+ 회원 등록</button>
      </div>

      <div className="admin-alert">회원 리스트를 확인합니다. 행을 클릭하면 수정할 수 있습니다.</div>

      <div className="admin-toolbar">
        <span className="meta">총 {total}건</span>
        <input
          type="search" value={search}
          onChange={(e) => setSearch(e.target.value)}
          onKeyDown={(e) => e.key === 'Enter' && loadMembers(search)}
          placeholder="모든필드 검색"
          style={{ flex: 1, maxWidth: 280 }}
        />
        <button type="button" className="btn-admin-primary" onClick={() => loadMembers(search)}>검색</button>
      </div>

      <div className="admin-table-wrap">
        <table className="admin-table">
          <thead>
            <tr>
              <th>번호</th><th>ID</th><th>이름</th><th>권한</th>
              <th>담당 발전소</th><th>이메일</th><th>전화번호</th><th>마지막 로그인</th><th>관리</th>
            </tr>
          </thead>
          <tbody>
            {members.length === 0 ? (
              <tr><td colSpan={9} style={{ textAlign: 'center', padding: 20, color: '#94a3b8' }}>데이터가 없습니다.</td></tr>
            ) : members.map((m, i) => (
              <tr key={m.id} onClick={() => openEdit(m)}>
                <td>{i + 1}</td>
                <td>{m.username}</td>
                <td>{m.name}</td>
                <td>
                  <span style={{
                    display: 'inline-block', padding: '2px 8px', borderRadius: 10,
                    fontSize: '0.72rem', fontWeight: 600, color: '#fff',
                    background: ROLE_BADGE_COLOR[m.role] || '#64748b',
                  }}>
                    {ROLES[m.role] || m.role || '—'}
                  </span>
                </td>
                <td style={{ fontSize: '0.78rem', color: '#64748b' }}>
                  {m.role === 'partner_admin'
                    ? (m.plants?.length ? `${m.plants.length}개` : '미배정')
                    : '—'}
                </td>
                <td>{m.email || '—'}</td>
                <td>{m.phone || '—'}</td>
                <td>{m.lastLogin || '—'}</td>
                <td onClick={(e) => e.stopPropagation()}>
                  <button className="btn-admin-danger" style={{ padding: '4px 10px', fontSize: '0.75rem' }}
                    onClick={() => handleDelete(m.id)}>삭제</button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {modal && (
        <div className="admin-modal-overlay" onClick={() => setModal(null)}>
          <div className="admin-modal" style={{ maxWidth: 560 }} onClick={(e) => e.stopPropagation()}>
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
                <div className="field">
                  <input type="password" value={form.password} onChange={upd('password')}
                    placeholder={modal.mode === 'edit' ? '변경 시에만 입력' : '필수'} />
                </div>

                <div className="label">권한</div>
                <div className="field">
                  <select value={form.role} onChange={upd('role')} style={{ width: '100%' }}>
                    <option value="user">일반 사용자</option>
                    <option value="partner_admin">파트너 관리자</option>
                    <option value="safety_admin">안전관리자</option>
                    <option value="admin">관리자</option>
                    <option value="developer">개발자</option>
                  </select>
                </div>

                <div className="label">이메일</div>
                <div className="field"><input type="email" value={form.email} onChange={upd('email')} /></div>

                <div className="label">휴대전화</div>
                <div className="field"><input type="tel" value={form.mobile} onChange={upd('mobile')} /></div>
              </div>

              {/* 파트너 관리자 발전소 배정 */}
              {form.role === 'partner_admin' && (
                <div style={{ marginTop: 20, paddingTop: 4 }}>
                  <div style={{ fontWeight: 600, fontSize: '0.85rem', marginBottom: 8 }}>
                    담당 발전소 배정
                    <span style={{ marginLeft: 8, fontWeight: 400, color: '#64748b', fontSize: '0.78rem' }}>
                      ({form.plants.length}개 선택)
                    </span>
                  </div>
                  <div style={{
                    border: '1px solid #e2e8f0', borderRadius: 6,
                    maxHeight: 240, overflowY: 'auto', padding: '4px 8px',
                  }}>
                    {allPlants.length === 0 ? (
                      <div style={{ color: '#94a3b8', padding: 12, textAlign: 'center', fontSize: '0.82rem' }}>발전소 없음</div>
                    ) : allPlants.map((p) => (
                      <label key={p.id} style={{
                        display: 'flex', alignItems: 'center', gap: 8,
                        padding: '5px 4px', cursor: 'pointer', fontSize: '0.83rem',
                        borderBottom: '1px solid #f1f5f9',
                      }}>
                        <input
                          type="checkbox"
                          checked={form.plants.includes(p.id)}
                          onChange={() => togglePlant(p.id)}
                        />
                        <span>{p.name}</span>
                        <span style={{ marginLeft: 'auto', color: '#94a3b8', fontSize: '0.75rem' }}>{p.region}</span>
                      </label>
                    ))}
                  </div>
                </div>
              )}
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
