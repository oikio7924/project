import { useState, useEffect, useContext } from 'react'
import { apiGet, apiSend } from '../api'
import { UserContext } from '../App'
import RichEditor from '../components/RichEditor'

const TAGS = ['공지', '점검', '이벤트', '기타']

// view: 'list' | 'detail' | 'edit' | 'create'
export default function Board() {
  const user = useContext(UserContext)
  const isAdmin = user?.role === 'admin'

  const [view, setView] = useState('list')
  const [posts, setPosts] = useState([])
  const [filterTag, setFilterTag] = useState('all')
  const [selected, setSelected] = useState(null)   // 열람/수정 중인 공지
  const [detailFiles, setDetailFiles] = useState([])
  const [form, setForm] = useState({ tag: TAGS[0], title: '', contents: '' })
  const [files, setFiles] = useState([])
  const [editFiles, setEditFiles] = useState([])
  const [saving, setSaving] = useState(false)

  useEffect(() => { if (view === 'list') loadPosts() }, [filterTag, view])

  function loadPosts() {
    const q = filterTag !== 'all' ? `?category=${encodeURIComponent(filterTag)}` : ''
    apiGet(`/api/notice${q}`).then((d) => setPosts(d.posts || [])).catch(console.error)
  }

  async function openDetail(post) {
    const updated = { ...post, views: post.views + 1 }
    setSelected(updated)
    setPosts((prev) => prev.map((p) => p.id === post.id ? updated : p))
    apiSend(`/api/notice/${post.id}/view`, 'POST', {}).catch(() => {})
    setView('detail')
    try {
      const d = await apiGet(`/api/notice/${post.id}/files`)
      setDetailFiles(d.files || [])
    } catch { setDetailFiles([]) }
  }

  function openCreate() {
    setForm({ tag: TAGS[0], title: '', contents: '' })
    setFiles([])
    setEditFiles([])
    setSelected(null)
    setView('create')
  }

  async function openEdit(post) {
    const target = post || selected
    setForm({
      tag: target.category || TAGS[0],
      title: target.title || '',
      contents: target.contents || '',
    })
    setFiles([])
    setSelected(target)
    setView('edit')
    try {
      const d = await apiGet(`/api/notice/${target.id}/files`)
      setEditFiles(d.files || [])
    } catch { setEditFiles([]) }
  }

  async function handleSave() {
    if (!form.title.trim()) return alert('제목을 입력하세요.')
    setSaving(true)
    try {
      const body = { category: form.tag, tags: '', siteName: '', title: form.title, contents: form.contents }
      let noticeId
      if (view === 'create') {
        const r = await apiSend('/api/notice', 'POST', body)
        noticeId = r.id
      } else {
        await apiSend(`/api/notice/${selected.id}`, 'PUT', body)
        noticeId = selected.id
      }
      for (const f of files) {
        const fd = new FormData()
        fd.append('file', f)
        await fetch(`/api/notice/${noticeId}/files`, { method: 'POST', body: fd, credentials: 'include' })
      }
      // 저장 후 상세보기로 이동
      const updated = await apiGet(`/api/notice`)
      const saved = (updated.posts || []).find((p) => p.id === noticeId)
      if (saved) {
        setSelected(saved)
        const df = await apiGet(`/api/notice/${noticeId}/files`)
        setDetailFiles(df.files || [])
      }
      setPosts(updated.posts || [])
      setView('detail')
    } catch (err) {
      alert(err.message)
    } finally {
      setSaving(false)
    }
  }

  async function handleDelete(id) {
    if (!confirm('삭제하시겠습니까?')) return
    await apiSend(`/api/notice/${id}`, 'DELETE', {})
    setView('list')
    loadPosts()
  }

  function pickFiles() {
    const input = document.createElement('input')
    input.type = 'file'
    input.multiple = true
    input.onchange = function () {
      const picked = Array.from(input.files || [])
      if (picked.length) setFiles((prev) => [...prev, ...picked])
    }
    input.click()
  }

  // ── 목록 ────────────────────────────────────────────────────
  if (view === 'list') return (
    <div className="wrap-scroll">
      <div className="card">
        <div className="board-toolbar">
          <h2 className="card-title" style={{ margin: 0 }}>
            <span className="card-title-dot" />공지사항
          </h2>
          <div style={{ display: 'flex', gap: 8, alignItems: 'center' }}>
            <div className="seg-btns">
              <button type="button" className={filterTag === 'all' ? 'active' : ''} onClick={() => setFilterTag('all')}>전체</button>
              {TAGS.map((t) => (
                <button key={t} type="button" className={filterTag === t ? 'active' : ''} onClick={() => setFilterTag(t)}>{t}</button>
              ))}
            </div>
            {isAdmin && <button className="btn btn-primary" onClick={openCreate}>+ 등록</button>}
          </div>
        </div>

        <div className="table-scroll">
          <table className="data-table">
            <thead>
              <tr>
                <th style={{ width: 48 }}>번호</th>
                <th style={{ width: 90 }}>분류</th>
                <th>제목</th>
                <th style={{ width: 80 }}>작성자</th>
                <th style={{ width: 60 }} className="num">조회</th>
                <th style={{ width: 90 }}>등록일</th>
              </tr>
            </thead>
            <tbody>
              {posts.length === 0 ? (
                <tr><td colSpan={6} className="hint">공지사항이 없습니다.</td></tr>
              ) : (
                posts.map((p, i) => (
                  <tr key={p.id} onClick={() => openDetail(p)} style={{ cursor: 'pointer' }}>
                    <td>{i + 1}</td>
                    <td><span className={`notice-badge cat-${p.category}`}>{p.category || '—'}</span></td>
                    <td>
                      <span style={{ color: 'var(--primary)', fontWeight: 500 }}>{p.title}</span>
                      {p.fileCount > 0 && (
                        <span style={{ marginLeft: 6, fontSize: '0.72rem', color: 'var(--text-muted)', verticalAlign: 'middle' }}>
                          <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" style={{ verticalAlign: 'middle', marginRight: 2 }}><path d="M21.44 11.05l-9.19 9.19a6 6 0 0 1-8.49-8.49l9.19-9.19a4 4 0 0 1 5.66 5.66l-9.2 9.19a2 2 0 0 1-2.83-2.83l8.49-8.48"/></svg>
                          {p.fileCount}
                        </span>
                      )}
                    </td>
                    <td>{p.author}</td>
                    <td className="num">{p.views}</td>
                    <td>{p.createdAt?.slice(0, 10)}</td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  )

  // ── 상세보기 ─────────────────────────────────────────────────
  if (view === 'detail') {
    const idx = posts.findIndex((p) => p.id === selected.id)
    const nextPost = idx > 0 ? posts[idx - 1] : null         // 최신글 방향
    const prevPost = idx < posts.length - 1 ? posts[idx + 1] : null  // 이전글 방향

  return (
    <div className="wrap-scroll">
      <div className="card">
        {/* 상단 툴바 */}
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 16 }}>
          <button className="btn" onClick={() => setView('list')}>
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" style={{ marginRight: 4, verticalAlign: 'middle' }}><polyline points="15 18 9 12 15 6"/></svg>
            목록으로
          </button>
          {isAdmin && (
            <div style={{ display: 'flex', gap: 8 }}>
              <button className="btn" onClick={() => openEdit(selected)}>수정</button>
              <button className="btn btn-danger" onClick={() => handleDelete(selected.id)}>삭제</button>
            </div>
          )}
        </div>

        {/* 제목/메타 */}
        <div style={{ marginBottom: 20 }}>
          <div style={{ marginBottom: 8 }}>
            <span className={`notice-badge cat-${selected.category}`}>{selected.category}</span>
          </div>
          <h2 style={{ margin: '0 0 8px', fontSize: '1.3rem', fontWeight: 700 }}>{selected.title}</h2>
          <div style={{ fontSize: '0.82rem', color: 'var(--text-muted)' }}>
            {selected.author} · {selected.createdAt} · 조회 {selected.views}
          </div>
        </div>

        <hr style={{ border: 'none', borderTop: '1px solid var(--line)', marginBottom: 20 }} />

        {/* 내용 */}
        <div className="notice-content-view">
          <RichEditor value={selected.contents || ''} readOnly />
        </div>

        {/* 첨부파일 */}
        {detailFiles.length > 0 && (
          <div className="notice-files" style={{ marginTop: 24 }}>
            <div className="notice-files-title">첨부파일 ({detailFiles.length})</div>
            {detailFiles.map((f) => (
              <div key={f.id} className="notice-file-item">
                <a href={`/api/notice/files/${f.id}/download`}>
                  <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
                  {f.name}
                </a>
                <span style={{ color: 'var(--text-muted)', fontSize: '0.75rem' }}>{(f.size / 1024).toFixed(1)} KB</span>
              </div>
            ))}
          </div>
        )}
      </div>

      {/* 이전글 / 다음글 */}
      <div className="card" style={{ marginTop: 12, padding: 0, overflow: 'hidden' }}>
        <div className={`notice-nav-item${nextPost ? '' : ' disabled'}`} onClick={() => nextPost && openDetail(nextPost)}>
          <span className="notice-nav-label">
            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5"><polyline points="18 15 12 9 6 15"/></svg>
            다음글
          </span>
          <span className="notice-nav-title">{nextPost ? nextPost.title : '다음 글이 없습니다.'}</span>
        </div>
        <div className={`notice-nav-item${prevPost ? '' : ' disabled'}`} onClick={() => prevPost && openDetail(prevPost)}>
          <span className="notice-nav-label">
            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5"><polyline points="6 9 12 15 18 9"/></svg>
            이전글
          </span>
          <span className="notice-nav-title">{prevPost ? prevPost.title : '이전 글이 없습니다.'}</span>
        </div>
      </div>
    </div>
  )
  }

  // ── 등록 / 수정 폼 ───────────────────────────────────────────
  return (
    <div className="wrap-scroll">
      <div className="card">
        {/* 상단 툴바 */}
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 20 }}>
          <button className="btn" onClick={() => setView(view === 'edit' ? 'detail' : 'list')}>
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" style={{ marginRight: 4, verticalAlign: 'middle' }}><polyline points="15 18 9 12 15 6"/></svg>
            {view === 'edit' ? '상세보기로' : '목록으로'}
          </button>
          <h3 style={{ margin: 0, fontSize: '1rem', fontWeight: 600 }}>
            {view === 'create' ? '공지사항 등록' : '공지사항 수정'}
          </h3>
          <button className="btn btn-primary" onClick={handleSave} disabled={saving} style={{ minWidth: 72 }}>
            {saving ? '저장 중...' : '저장'}
          </button>
        </div>

        {/* 분류 + 제목 */}
        <div style={{ display: 'flex', gap: 12, marginBottom: 16, alignItems: 'flex-end' }}>
          <div style={{ flexShrink: 0 }}>
            <div className="form-label" style={{ marginBottom: 4 }}>분류</div>
            <select value={form.tag} onChange={(e) => setForm({ ...form, tag: e.target.value })}>
              {TAGS.map((t) => <option key={t} value={t}>{t}</option>)}
            </select>
          </div>
          <div style={{ flex: 1 }}>
            <div className="form-label" style={{ marginBottom: 4 }}>제목</div>
            <input
              value={form.title}
              onChange={(e) => setForm({ ...form, title: e.target.value })}
              placeholder="제목을 입력하세요"
              style={{ width: '100%' }}
            />
          </div>
        </div>

        {/* 내용 에디터 */}
        <div style={{ marginBottom: 16 }}>
          <div className="form-label" style={{ marginBottom: 4 }}>내용</div>
          <RichEditor value={form.contents} onChange={(v) => setForm({ ...form, contents: v })} />
        </div>

        {/* 첨부파일 */}
        <div>
          <div className="form-label" style={{ marginBottom: 4 }}>첨부파일</div>

          {/* 기존 파일 (수정 모드) */}
          {view === 'edit' && editFiles.length > 0 && (
            <div style={{ marginBottom: 8 }}>
              {editFiles.map((f) => (
                <div key={f.id} className="notice-file-item">
                  <a href={`/api/notice/files/${f.id}/download`} style={{ color: 'var(--primary)' }}>
                    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
                    {f.name}
                  </a>
                  <span style={{ color: 'var(--text-muted)', fontSize: '0.75rem' }}>{(f.size / 1024).toFixed(1)} KB</span>
                  <button
                    className="btn btn-sm btn-danger"
                    style={{ padding: '1px 6px', fontSize: '0.72rem' }}
                    onClick={async () => {
                      if (!confirm('첨부파일을 삭제하시겠습니까?')) return
                      await apiSend(`/api/notice/${selected.id}/files/${f.id}`, 'DELETE', {})
                      setEditFiles((prev) => prev.filter((x) => x.id !== f.id))
                    }}
                  >삭제</button>
                </div>
              ))}
            </div>
          )}

          <div className="file-drop-area" onClick={pickFiles}>
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg>
            <span>클릭하여 파일 추가 (최대 20MB)</span>
          </div>
          {files.length > 0 && (
            <div style={{ marginTop: 8 }}>
              {files.map((f, i) => (
                <div key={i} className="notice-file-item">
                  <span>{f.name}</span>
                  <span style={{ color: 'var(--text-muted)', fontSize: '0.75rem' }}>{(f.size / 1024).toFixed(1)} KB</span>
                  <button
                    className="btn btn-sm btn-danger"
                    style={{ padding: '1px 6px', fontSize: '0.72rem' }}
                    onClick={() => setFiles((prev) => prev.filter((_, j) => j !== i))}
                  >제거</button>
                </div>
              ))}
            </div>
          )}
        </div>
      </div>
    </div>
  )
}
