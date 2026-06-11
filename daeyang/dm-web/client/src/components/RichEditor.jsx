import { useEditor, EditorContent, NodeViewWrapper, ReactNodeViewRenderer } from '@tiptap/react'
import StarterKit from '@tiptap/starter-kit'
import TextAlign from '@tiptap/extension-text-align'
import Underline from '@tiptap/extension-underline'
import TextStyle from '@tiptap/extension-text-style'
import Color from '@tiptap/extension-color'
import Link from '@tiptap/extension-link'
import Image from '@tiptap/extension-image'
import { useEffect, useRef, useCallback } from 'react'

const COLORS = ['#000000', '#374151', '#dc2626', '#d97706', '#16a34a', '#2563eb', '#7c3aed', '#db2777']

// ── 크기 조절 가능한 이미지 노드 뷰 ────────────────────────────
function ResizableImageView({ node, updateAttributes, selected }) {
  const { src, alt, width } = node.attrs
  const containerRef = useRef(null)
  const startRef = useRef(null)

  const startResize = useCallback((e, dir) => {
    e.preventDefault()
    e.stopPropagation()
    const initW = containerRef.current?.offsetWidth || 300
    startRef.current = { x: e.clientX, w: initW, dir }

    function onMove(e) {
      if (!startRef.current) return
      const { x, w, dir } = startRef.current
      const dx = dir === 'right' ? e.clientX - x : x - e.clientX
      const newW = Math.max(60, Math.min(w + dx, 900))
      updateAttributes({ width: newW })
    }
    function onUp() {
      startRef.current = null
      document.removeEventListener('mousemove', onMove)
      document.removeEventListener('mouseup', onUp)
    }
    document.addEventListener('mousemove', onMove)
    document.addEventListener('mouseup', onUp)
  }, [updateAttributes])

  return (
    <NodeViewWrapper style={{ display: 'inline-block', maxWidth: '100%' }}>
      <div
        ref={containerRef}
        style={{
          position: 'relative',
          display: 'inline-block',
          width: width ? width + 'px' : 'auto',
          maxWidth: '100%',
          lineHeight: 0,
        }}
      >
        <img
          src={src}
          alt={alt || ''}
          draggable={false}
          style={{ display: 'block', width: '100%', height: 'auto', borderRadius: 4 }}
        />
        {selected && (
          <>
            <div style={{ position: 'absolute', inset: 0, outline: '2px solid var(--primary)', pointerEvents: 'none', borderRadius: 4 }} />
            <div className="img-resize-handle img-resize-sw" onMouseDown={(e) => startResize(e, 'left')} />
            <div className="img-resize-handle img-resize-se" onMouseDown={(e) => startResize(e, 'right')} />
          </>
        )}
      </div>
    </NodeViewWrapper>
  )
}

// Image 확장에 width 속성 + NodeView 추가
const ResizableImage = Image.extend({
  addAttributes() {
    return {
      ...this.parent?.(),
      width: {
        default: null,
        parseHTML: (el) => el.getAttribute('width') ? Number(el.getAttribute('width')) : null,
        renderHTML: (attrs) => attrs.width ? { width: attrs.width, style: `width:${attrs.width}px;max-width:100%` } : {},
      },
    }
  },
  addNodeView() {
    return ReactNodeViewRenderer(ResizableImageView)
  },
})

// ── 에디터 ────────────────────────────────────────────────────
export default function RichEditor({ value, onChange, readOnly = false }) {
  const skipExternalUpdate = useRef(false)

  const editor = useEditor({
    extensions: [
      StarterKit,
      Underline,
      TextStyle,
      Color,
      ResizableImage.configure({ inline: true, allowBase64: true }),
      Link.configure({ openOnClick: readOnly }),
      TextAlign.configure({ types: ['heading', 'paragraph'] }),
    ],
    content: value || '',
    editable: !readOnly,
    editorProps: {
      handlePaste(view, event) {
        const items = Array.from(event.clipboardData?.items || [])
        const imageItem = items.find((item) => item.type.startsWith('image/'))
        if (!imageItem) return false
        event.preventDefault()
        const file = imageItem.getAsFile()
        if (!file) return true
        const reader = new FileReader()
        reader.onload = (e) => {
          view.dispatch(
            view.state.tr.replaceSelectionWith(
              view.state.schema.nodes.image.create({ src: e.target.result })
            )
          )
        }
        reader.readAsDataURL(file)
        return true
      },
    },
    onUpdate({ editor }) {
      skipExternalUpdate.current = true
      if (onChange) onChange(editor.getHTML())
    },
  })

  useEffect(() => {
    if (!editor) return
    if (skipExternalUpdate.current) { skipExternalUpdate.current = false; return }
    if (value !== editor.getHTML()) editor.commands.setContent(value || '', false)
  }, [value])

  useEffect(() => {
    if (editor) editor.setEditable(!readOnly)
  }, [readOnly, editor])

  if (!editor) return null

  return (
    <div className={`rich-editor${readOnly ? ' read-only' : ''}`}>
      {!readOnly && (
        <div className="rich-toolbar">
          <ToolBtn active={editor.isActive('bold')}      onClick={() => editor.chain().focus().toggleBold().run()}      title="굵게"><b>B</b></ToolBtn>
          <ToolBtn active={editor.isActive('italic')}    onClick={() => editor.chain().focus().toggleItalic().run()}    title="기울임"><i>I</i></ToolBtn>
          <ToolBtn active={editor.isActive('underline')} onClick={() => editor.chain().focus().toggleUnderline().run()} title="밑줄"><u>U</u></ToolBtn>
          <ToolBtn active={editor.isActive('strike')}    onClick={() => editor.chain().focus().toggleStrike().run()}    title="취소선"><s>S</s></ToolBtn>
          <div className="rich-divider" />
          <ToolBtn active={editor.isActive('heading', { level: 1 })} onClick={() => editor.chain().focus().toggleHeading({ level: 1 }).run()} title="제목1">H1</ToolBtn>
          <ToolBtn active={editor.isActive('heading', { level: 2 })} onClick={() => editor.chain().focus().toggleHeading({ level: 2 }).run()} title="제목2">H2</ToolBtn>
          <ToolBtn active={editor.isActive('heading', { level: 3 })} onClick={() => editor.chain().focus().toggleHeading({ level: 3 }).run()} title="제목3">H3</ToolBtn>
          <div className="rich-divider" />
          <ToolBtn active={editor.isActive({ textAlign: 'left' })}   onClick={() => editor.chain().focus().setTextAlign('left').run()}   title="왼쪽"><AlignIcon align="left" /></ToolBtn>
          <ToolBtn active={editor.isActive({ textAlign: 'center' })} onClick={() => editor.chain().focus().setTextAlign('center').run()} title="가운데"><AlignIcon align="center" /></ToolBtn>
          <ToolBtn active={editor.isActive({ textAlign: 'right' })}  onClick={() => editor.chain().focus().setTextAlign('right').run()}  title="오른쪽"><AlignIcon align="right" /></ToolBtn>
          <div className="rich-divider" />
          <ToolBtn active={editor.isActive('bulletList')}  onClick={() => editor.chain().focus().toggleBulletList().run()}  title="글머리">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><line x1="9" y1="6" x2="20" y2="6"/><line x1="9" y1="12" x2="20" y2="12"/><line x1="9" y1="18" x2="20" y2="18"/><circle cx="4" cy="6" r="1.5" fill="currentColor"/><circle cx="4" cy="12" r="1.5" fill="currentColor"/><circle cx="4" cy="18" r="1.5" fill="currentColor"/></svg>
          </ToolBtn>
          <ToolBtn active={editor.isActive('orderedList')} onClick={() => editor.chain().focus().toggleOrderedList().run()} title="번호목록">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><line x1="10" y1="6" x2="21" y2="6"/><line x1="10" y1="12" x2="21" y2="12"/><line x1="10" y1="18" x2="21" y2="18"/><text x="2" y="9" fontSize="8" fill="currentColor" stroke="none">1</text><text x="2" y="15" fontSize="8" fill="currentColor" stroke="none">2</text><text x="2" y="21" fontSize="8" fill="currentColor" stroke="none">3</text></svg>
          </ToolBtn>
          <div className="rich-divider" />
          <div className="rich-color-wrap" title="글자 색상">
            {COLORS.map((c) => (
              <button key={c} type="button"
                className={`rich-color-btn${editor.isActive('textStyle', { color: c }) ? ' active' : ''}`}
                style={{ background: c }}
                onMouseDown={(e) => { e.preventDefault(); editor.chain().focus().setColor(c).run() }}
              />
            ))}
          </div>
        </div>
      )}
      <EditorContent editor={editor} className="rich-content" />
    </div>
  )
}

function ToolBtn({ active, onClick, title, children }) {
  return (
    <button type="button" className={`rich-btn${active ? ' active' : ''}`}
      onMouseDown={(e) => { e.preventDefault(); onClick() }} title={title}>
      {children}
    </button>
  )
}

function AlignIcon({ align }) {
  const lines = align === 'left'
    ? [[4,4,20,4],[4,9,16,9],[4,14,20,14],[4,19,14,19]]
    : align === 'center'
    ? [[4,4,20,4],[7,9,17,9],[4,14,20,14],[7,19,17,19]]
    : [[4,4,20,4],[8,9,20,9],[4,14,20,14],[10,19,20,19]]
  return (
    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
      {lines.map(([x1,y1,x2,y2],i) => <line key={i} x1={x1} y1={y1} x2={x2} y2={y2}/>)}
    </svg>
  )
}
