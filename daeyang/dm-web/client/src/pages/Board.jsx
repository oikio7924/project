import { useState, useEffect } from 'react'
import { apiGet, apiSend, escapeHtml } from '../api'

export default function Board() {
  const [posts, setPosts] = useState([])
  const [category, setCategory] = useState('all')
  const [modal, setModal] = useState(null) // null | { mode: 'create' | 'edit', post? }
  const [form, setForm] = useState({ category: '', siteName: '', title: '' })

  useEffect(() => { loadPosts() }, [category])

  function loadPosts() {
    const q = category !== 'all' ? `?category=${encodeURIComponent(category)}` : ''
    apiGet(`/api/board${q}`).then((d) => setPosts(d.posts || [])).catch(console.error)
  }

  function openCreate() {
    setForm({ category: '', siteName: '', title: '' })
    setModal({ mode: 'create' })
  }

  function openEdit(post) {
    setForm({ category: post.category, siteName: post.siteName, title: post.title })
    setModal({ mode: 'edit', post })
  }

  async function handleSave() {
    try {
      if (modal.mode === 'create') {
        await apiSend('/api/board', 'POST', form)
      } else {
        await apiSend(`/api/board/${modal.post.id}`, 'PUT', form)
      }
      setModal(null)
      loadPosts()
    } catch (err) {
      alert(err.message)
    }
  }

  async function handleDelete(id) {
    if (!confirm('삭제하시겠습니까?')) return
    await apiSend(`/api/board/${id}`, 'DELETE')
    loadPosts()
  }

  const CATEGORIES = ['all', '공지', '장애', '점검', '기타']

  return (
    <div className="wrap-scroll">
      <div className="card">
        <div className="board-toolbar">
          <h2 className="card-title" style={{ margin: 0 }}><span className="card-title-dot" />게시판</h2>
          <div style={{ display: 'flex', gap: 8, alignItems: 'center' }}>
            <select value={category} onChange={(e) => setCategory(e.target.value)} style={{ padding: '5px 8px', border: '1px solid var(--line)', borderRadius: 'var(--radius-sm)' }}>
              {CATEGORIES.map((c) => <option key={c} value={c}>{c === 'all' ? '전체' : c}</option>)}
            </select>
            <button className="btn btn-primary" onClick={openCreate}>+ 등록</button>
          </div>
        </div>

        <div className="table-scroll">
          <table className="data-table">
            <thead>
              <tr>
                <th>번호</th><th>분류</th><th>현장명</th><th>제목</th>
                <th>작성자</th><th className="num">조회</th><th>등록일</th><th>관리</th>
              </tr>
            </thead>
            <tbody>
              {posts.length === 0 ? (
                <tr><td colSpan={8} className="hint">게시글이 없습니다.</td></tr>
              ) : (
                posts.map((p, i) => (
                  <tr key={p.id}>
                    <td>{i + 1}</td>
                    <td>{p.category || '—'}</td>
                    <td>{p.siteName || '—'}</td>
                    <td>{p.title}</td>
                    <td>{p.author}</td>
                    <td className="num">{p.views}</td>
                    <td>{p.createdAt?.slice(0, 10)}</td>
                    <td>
                      <button className="btn btn-sm" onClick={() => openEdit(p)}>수정</button>{' '}
                      <button className="btn btn-sm btn-danger" onClick={() => handleDelete(p.id)}>삭제</button>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>

      {/* 등록/수정 모달 */}
      {modal && (
        <div className="modal-overlay" onClick={() => setModal(null)}>
          <div className="modal-box" onClick={(e) => e.stopPropagation()}>
            <div className="modal-header">
              <h3>{modal.mode === 'create' ? '게시글 등록' : '게시글 수정'}</h3>
              <button className="modal-close" onClick={() => setModal(null)}>&times;</button>
            </div>
            <div className="modal-body">
              <table className="form-table">
                <tbody>
                  <tr className="form-row">
                    <th>분류</th>
                    <td><select value={form.category} onChange={(e) => setForm({ ...form, category: e.target.value })} style={{ width: '100%' }}>
                      {['공지', '장애', '점검', '기타'].map((c) => <option key={c}>{c}</option>)}
                    </select></td>
                    <th>현장명</th>
                    <td><input value={form.siteName} onChange={(e) => setForm({ ...form, siteName: e.target.value })} style={{ width: '100%' }} /></td>
                  </tr>
                  <tr className="form-row">
                    <th>제목</th>
                    <td colSpan={3}><input value={form.title} onChange={(e) => setForm({ ...form, title: e.target.value })} style={{ width: '100%' }} /></td>
                  </tr>
                </tbody>
              </table>
            </div>
            <div className="modal-footer">
              <button className="btn" onClick={() => setModal(null)}>취소</button>
              <button className="btn btn-primary" onClick={handleSave}>저장</button>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
