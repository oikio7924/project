import { useState } from 'react'

/**
 * 안전관리 공통 발전소 목록 사이드바
 *
 * Props:
 *   items       - 표시할 항목 배열
 *   getKey      - 항목에서 고유키 추출 (기본: item => item.id)
 *   getName     - 항목에서 표시 이름 추출 (기본: item => item.name, [태그] 제거)
 *   selectedKey - 현재 선택된 항목의 key (null = 선택 없음)
 *   onSelect    - 항목 클릭 시 콜백 (item) => void ; showAll일 때 null 전달 가능
 *   showAll     - 맨 위에 "전체" 항목 표시 여부 (기본 false)
 *   renderBadge - 이름 오른쪽에 뱃지 렌더링 (item, isSelected) => ReactNode | null
 */
export default function PlantSidebar({
  items = [],
  getKey   = item => item.id,
  getName  = item => (item.name || '').replace(/\[.*?\]\s*/, ''),
  selectedKey = null,
  onSelect,
  showAll = false,
  renderBadge,
}) {
  const [search, setSearch] = useState('')

  const filtered = items.filter(item =>
    getName(item).toLowerCase().includes(search.toLowerCase())
  )

  const itemStyle = (isSel) => ({
    padding: '8px 14px', cursor: 'pointer', fontSize: '0.82rem',
    borderBottom: '1px solid var(--line)',
    background: isSel ? 'var(--navy)' : undefined,
    color: isSel ? '#fff' : 'var(--text)',
    fontWeight: 600, whiteSpace: 'nowrap', overflow: 'hidden',
    display: 'flex', alignItems: 'center', gap: 6,
  })

  return (
    <div style={{
      width: 230, flexShrink: 0,
      borderRight: '1px solid var(--line)',
      background: 'var(--surface)',
      display: 'flex', flexDirection: 'column',
    }}>
      {/* 검색 */}
      <div style={{ padding: '10px 12px', borderBottom: '1px solid var(--line)' }}>
        <input
          type="text" placeholder="발전소 검색..." value={search}
          onChange={e => setSearch(e.target.value)}
          style={{
            width: '100%', padding: '6px 8px',
            border: '1px solid var(--line)', borderRadius: 'var(--radius-sm)',
            fontSize: '0.8rem', background: 'var(--bg)', color: 'var(--text)',
            boxSizing: 'border-box',
          }}
        />
      </div>

      {/* 목록 */}
      <div style={{ overflowY: 'auto', flex: 1 }}>
        {showAll && (
          <div
            onClick={() => onSelect?.(null)}
            style={itemStyle(selectedKey === null)}
          >
            <span style={{ overflow: 'hidden', textOverflow: 'ellipsis', flex: 1 }}>전체</span>
          </div>
        )}
        {filtered.map(item => {
          const key   = getKey(item)
          const name  = getName(item)
          const isSel = key === selectedKey
          const badge = renderBadge ? renderBadge(item, isSel) : null
          return (
            <div key={key} onClick={() => onSelect?.(item)} style={itemStyle(isSel)}>
              <span style={{ overflow: 'hidden', textOverflow: 'ellipsis', flex: 1 }}>{name}</span>
              {badge}
            </div>
          )
        })}
      </div>
    </div>
  )
}
