<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>
<!DOCTYPE html>
<html>
<head>
  <%@ include file="/WEB-INF/jsp/hometax/include/hometax_head.jsp" %>
  <style>
    .page-title { margin-bottom: 1rem; font-size: 1.25rem; }
    .content-box { background: #fff; border-radius: 8px; padding: 1.5rem; flex: 1; min-height: 0; overflow: auto; }
    .content-box table { width: 100%; border-collapse: collapse; }
    .content-box th, .content-box td { border: 1px solid #bdc3c7; padding: 8px 12px; text-align: left; }
    .content-box th { background: #34495e; color: #fff; }
    .left { text-align: left; }
    .btn { display: inline-block; padding: 6px 14px; border-radius: 4px; text-decoration: none; font-size: 0.9rem; border: none; cursor: pointer; }
    .btn-primary { background: #2c3e50; color: #fff; }
    .btn-primary:hover { background: #34495e; }
    .btn-danger { background: #dc3545; color: #fff; }
    .btn-danger:hover { background: #c82333; }
    .btn-line { background: #fff; border: 1px solid #2c3e50; color: #2c3e50; }
    .btn-line:hover { background: #f4f6f7; }
    .btn-small { padding: 4px 10px; font-size: 0.85rem; }
    .form-box { background: #f7f9fc; border: 1px solid #dbe3ec; border-radius: 10px; padding: 1rem 1.25rem; margin-bottom: 1rem; max-width: 100%; box-sizing: border-box; overflow-x: hidden; }
    .form-box h3 { margin: 0 0 0.9rem 0; font-size: 1rem; color: #2c3e50; font-weight: 800; }
    .form-split { display: grid; grid-template-columns: minmax(0, 1fr) minmax(0, 1fr); gap: 1rem; align-items: stretch; width: 100%; min-width: 0; box-sizing: border-box; }
    .form-col { min-width: 0; display: flex; flex-direction: column; max-width: 100%; }
    .base-info-col, .supplier-aside-col { background: #ffffff; border: 1px solid #dbe3ec; border-radius: 10px; padding: 1rem 1.25rem; box-sizing: border-box; min-width: 0; max-width: 100%; overflow: hidden; }
    .base-info-col { gap: 0.65rem; }
    .base-info-col .form-row { margin-bottom: 0; padding: 0; }
    .form-row {
      display: grid;
      grid-template-columns: minmax(5.5rem, 7.5rem) minmax(0, 1fr) minmax(5.5rem, 7.5rem) minmax(0, 1fr);
      column-gap: 0.65rem;
      row-gap: 0.5rem;
      margin-bottom: 0.7rem;
      align-items: center;
      min-width: 0;
      max-width: 100%;
      box-sizing: border-box;
    }
    .form-row label { width: auto; margin: 0; white-space: nowrap; line-height: 1.25; color: #34495e; font-weight: 600; }
    .form-row input:not([type="radio"]):not([type="checkbox"]), .form-row select {
      padding: 7px 10px;
      min-width: 0;
      width: 100%;
      box-sizing: border-box;
      border: 1px solid #ccd6e2;
      border-radius: 6px;
      background: #fff;
      transition: border-color 0.2s, box-shadow 0.2s;
    }
    .form-row input:not([type="radio"]):not([type="checkbox"]):focus, .form-row select:focus {
      outline: none;
      border-color: #5b8def;
      box-shadow: 0 0 0 3px rgba(91, 141, 239, 0.14);
    }
    .wide-field { grid-column: 2 / -1; }
    .supplier-info-panel {
      background: #f8fafc;
      border: 1px solid #e2e8f0;
      border-radius: 8px;
      padding: 1rem 1.1rem;
      font-size: 0.88rem;
      color: #475569;
      line-height: 1.55;
    }
    .supplier-info-panel strong { display: block; color: #2c3e50; margin-bottom: 0.5rem; font-size: 0.92rem; }
    .supplier-info-panel p { margin: 0; }
    .form-actions { margin-top: 0.75rem; display: flex; gap: 0.5rem; flex-wrap: wrap; }
    .top-actions { display: flex; justify-content: flex-start; align-items: center; gap: 0.75rem; margin-bottom: 0.75rem; flex-wrap: wrap; }
    .tool-search-row { margin-top: 0.5rem; }
    .tool-search-title { font-weight: 700; color: #2c3e50; margin-bottom: 0.35rem; }
    .tool-search-row .search-input { padding: 6px 10px; border: 1px solid #bdc3c7; border-radius: 4px; width: 100%; max-width: 100%; box-sizing: border-box; }
    .filter-toolbar { display: flex; flex-wrap: wrap; align-items: center; gap: 0.5rem 0.75rem; margin-top: 0.35rem; }
    .filter-toolbar .search-input { flex: 1 1 240px; min-width: 180px; }
    .filter-select { padding: 6px 10px; border: 1px solid #bdc3c7; border-radius: 4px; background: #fff; color: #2c3e50; min-width: 110px; box-sizing: border-box; }
    .filter-result-count { font-size: 0.85rem; color: #5c6b7a; white-space: nowrap; }
    .filter-subtitle { font-weight: 700; color: #2c3e50; margin-top: 0.35rem; margin-bottom: 0.15rem; }
    .filter-select-row { display: flex; flex-wrap: wrap; align-items: center; gap: 0.5rem 0.75rem; }
    .active-filter-chips { display: flex; flex-wrap: wrap; gap: 0.4rem; margin-top: 0.55rem; }
    .filter-chip {
      display: inline-flex;
      align-items: center;
      gap: 0.35rem;
      border: 1px solid #93c5fd;
      background: #eff6ff;
      color: #1e40af;
      border-radius: 999px;
      padding: 0.2rem 0.55rem;
      font-size: 0.82rem;
      line-height: 1.2;
    }
    .filter-chip button {
      border: none;
      background: transparent;
      color: #1e40af;
      font-size: 0.9rem;
      cursor: pointer;
      padding: 0;
      line-height: 1;
    }
    .supplier-tool-block { background: #f8f9fa; border: 1px solid #dee2e6; border-radius: 8px; padding: 1rem; margin-bottom: 1rem; }
    .supplier-list-block { background: #fff; border: 1px solid #dee2e6; border-radius: 8px; padding: 1rem; }
    .supplier-list-head { display: flex; justify-content: space-between; align-items: center; gap: 0.5rem; margin-bottom: 0.75rem; flex-wrap: wrap; }
    .supplier-list-title { font-weight: 800; color: #2c3e50; }
    .supplier-list-actions { display: flex; gap: 0.5rem; align-items: center; }
    .name-edit-link { color: #2c3e50; text-decoration: underline; cursor: pointer; font-weight: 600; }
    .name-edit-link:hover { color: #1b2838; }
    .msg { padding: 0.5rem; margin-bottom: 0.5rem; border-radius: 4px; background: #d4edda; color: #155724; }
    @media (max-width: 1200px) {
      .form-split { grid-template-columns: minmax(0, 1fr); }
    }
  </style>
</head>
<body>
  <div class="hometax-wrap">
    <%@ include file="/WEB-INF/jsp/hometax/include/hometax_sidebar.jsp" %>
    <div class="hometax-main">
      <div class="page-title">공급자</div>
      <div class="content-box">
        <c:if test="${not empty message}"><div class="msg">${message}</div></c:if>

        <!-- 등록/수정 폼 (계약자 관리와 동일 패턴) -->
        <div class="form-box" id="editBox" style="display:none;">
          <h3 id="formTitle">공급자 정보</h3>
          <form action="${pageContext.request.contextPath}/bill/supplier/save.do" method="post" id="supplierForm">
            <input type="hidden" name="id" id="fid" value="" />
            <div class="form-split">
              <div class="form-col base-info-col">
                <div class="form-row">
                  <label>사용</label>
                  <select name="useYn" id="fuseYn">
                    <option value="Y">Y</option>
                    <option value="N">N</option>
                  </select>
                </div>
                <div class="form-row">
                  <label>사업자번호</label><input type="text" name="corpNum" id="fcorpNum" maxlength="20" />
                  <label>업태</label><input type="text" name="bizType" id="fbizType" maxlength="50" />
                </div>
                <div class="form-row">
                  <label>업종</label><input type="text" name="bizClassification" id="fbizClassification" maxlength="50" />
                  <label>상호</label><input type="text" name="corpName" id="fcorpName" maxlength="100" />
                </div>
                <div class="form-row">
                  <label>대표자</label><input type="text" name="ceoName" id="fceoName" maxlength="50" />
                  <label>담당자</label><input type="text" name="contactName" id="fcontactName" maxlength="50" />
                </div>
                <div class="form-row">
                  <label>연락처</label><input type="text" name="contactPhone" id="fcontactPhone" maxlength="30" />
                  <label>이메일</label><input type="text" name="email" id="femail" maxlength="100" />
                </div>
                <div class="form-row">
                  <label>주소</label><input type="text" name="address" id="faddress" maxlength="200" class="wide-field" />
                </div>
              </div>
              <div class="form-col supplier-aside-col">
                <div class="supplier-info-panel">
                  <strong>안내</strong>
                  <p>세금계산서 발급 시 이 공급자 정보가 사용됩니다. 사업자등록번호·상호·주소 등 관리번호 부여에 필요한 항목을 정확히 입력해 주세요.</p>
                </div>
              </div>
            </div>
            <div class="form-actions">
              <button type="submit" class="btn btn-primary">저장</button>
              <button type="button" class="btn btn-line" id="btnCancel">닫기</button>
            </div>
          </form>
        </div>

        <div class="supplier-tool-block">
          <div class="top-actions">
            <button type="button" class="btn btn-line" id="btnAdd">공급자 추가</button>
          </div>
          <div class="tool-search-row">
            <div class="tool-search-title">공급자 검색</div>
            <div class="filter-toolbar">
              <input type="text" id="supplierSearchKeyword" class="search-input" placeholder="검색창 (사업자번호, 상호, 대표자명, 담당자명)" autocomplete="off" />
              <button type="button" class="btn btn-primary btn-small" id="btnSupplierSearch">검색</button>
              <button type="button" class="btn btn-line btn-small" id="btnSupplierFilterReset">초기화</button>
              <span class="filter-result-count" id="supplierFilterCount" aria-live="polite"></span>
            </div>
            <div class="filter-subtitle">필터</div>
            <div class="filter-select-row" style="margin-top: 0.35rem;">
              <select id="filterSupplierField" class="filter-select" title="필터 항목">
                <option value="corpnum">사업자번호</option>
                <option value="corpname">상호</option>
                <option value="ceoname">대표자명</option>
                <option value="contactname">담당자명</option>
              </select>
              <select id="filterSupplierValue" class="filter-select" title="필터 값">
                <option value="">값 전체</option>
              </select>
            </div>
            <div class="active-filter-chips" id="supplierActiveFilters"></div>
          </div>
        </div>

        <div class="supplier-list-block">
          <div class="supplier-list-head">
            <div class="supplier-list-title">공급자 목록</div>
            <div class="supplier-list-actions">
              <button type="button" class="btn btn-line btn-small" id="btnSupplierSelectAll">전체선택</button>
              <button type="button" class="btn btn-line btn-small" id="btnSupplierUnselectAll">선택 해제</button>
              <form action="${pageContext.request.contextPath}/bill/supplier/deleteSelected.do" method="post" id="supplierBulkDeleteForm" style="margin:0;">
                <button type="submit" class="btn btn-danger btn-small" onclick="return confirm('선택한 공급자를 삭제할까요?');">선택 삭제</button>
              </form>
            </div>
          </div>
          <table>
            <thead>
              <tr>
                <th style="width:60px;">선택</th>
                <th style="width:70px;">No</th>
                <th>사업자번호</th>
                <th>상호</th>
                <th>대표자</th>
                <th>담당자</th>
                <th>연락처</th>
                <th style="width:64px;">사용</th>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${empty providerList}">
                  <tr><td colspan="8" style="text-align:center;">등록된 공급자가 없습니다.</td></tr>
                </c:when>
                <c:otherwise>
                  <c:forEach var="p" items="${providerList}" varStatus="st">
                    <tr class="js-supplier-row" data-use-yn="${p.useYn}"
                        data-corpnum="<c:out value='${p.corpNum}'/>"
                        data-corpname="<c:out value='${p.corpName}'/>"
                        data-ceoname="<c:out value='${p.ceoName}'/>"
                        data-contactname="<c:out value='${p.contactName}'/>">
                      <td><input type="checkbox" name="ids" value="${p.id}"/></td>
                      <td>${st.index + 1}</td>
                      <td><c:out value="${p.corpNum}"/></td>
                      <td class="left">
                        <a href="#" class="name-edit-link btn-edit"
                           data-id="${p.id}"
                           data-corpnum="<c:out value='${p.corpNum}'/>"
                           data-biztype="<c:out value='${p.bizType}'/>"
                           data-bizclass="<c:out value='${p.bizClassification}'/>"
                           data-corpname="<c:out value='${p.corpName}'/>"
                           data-ceoname="<c:out value='${p.ceoName}'/>"
                           data-contact="<c:out value='${p.contactName}'/>"
                           data-phone="<c:out value='${p.contactPhone}'/>"
                           data-email="<c:out value='${p.email}'/>"
                           data-addr="<c:out value='${p.address}'/>"
                           data-useyn="${p.useYn}">
                          <c:out value="${p.corpName}"/>
                        </a>
                      </td>
                      <td><c:out value="${p.ceoName}"/></td>
                      <td><c:out value="${p.contactName}"/></td>
                      <td><c:out value="${p.contactPhone}"/></td>
                      <td>${p.useYn}</td>
                    </tr>
                  </c:forEach>
                </c:otherwise>
              </c:choose>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
  <script>
    (function(){
      var editBox = document.getElementById('editBox');
      var form = document.getElementById('supplierForm');
      var fid = document.getElementById('fid');
      var btnCancel = document.getElementById('btnCancel');
      var btnAdd = document.getElementById('btnAdd');
      var formTitle = document.getElementById('formTitle');

      function readData(btn) {
        return {
          id: btn.getAttribute('data-id') || '',
          corpNum: btn.getAttribute('data-corpnum') || '',
          bizType: btn.getAttribute('data-biztype') || '',
          bizClass: btn.getAttribute('data-bizclass') || '',
          corpName: btn.getAttribute('data-corpname') || '',
          ceoName: btn.getAttribute('data-ceoname') || '',
          contact: btn.getAttribute('data-contact') || '',
          phone: btn.getAttribute('data-phone') || '',
          email: btn.getAttribute('data-email') || '',
          addr: btn.getAttribute('data-addr') || '',
          useYn: btn.getAttribute('data-useyn') || 'Y'
        };
      }

      function setForm(o){
        fid.value = o.id || '';
        document.getElementById('fcorpNum').value = o.corpNum || '';
        document.getElementById('fbizType').value = o.bizType || '';
        document.getElementById('fbizClassification').value = o.bizClass || '';
        document.getElementById('fcorpName').value = o.corpName || '';
        document.getElementById('fceoName').value = o.ceoName || '';
        document.getElementById('fcontactName').value = o.contact || '';
        document.getElementById('fcontactPhone').value = o.phone || '';
        document.getElementById('femail').value = o.email || '';
        document.getElementById('faddress').value = o.addr || '';
        document.getElementById('fuseYn').value = o.useYn || 'Y';
        if (o.id) {
          formTitle.textContent = '공급자 수정';
        } else {
          formTitle.textContent = '공급자 등록';
        }
      }

      function openAdd(){
        setForm({});
        editBox.style.display = 'block';
        try { editBox.scrollIntoView({ behavior: 'smooth', block: 'nearest' }); } catch (e) {}
      }

      function openEdit(btn){
        setForm(readData(btn));
        editBox.style.display = 'block';
        try { editBox.scrollIntoView({ behavior: 'smooth', block: 'nearest' }); } catch (e) {}
      }

      if (btnAdd) btnAdd.addEventListener('click', function(){ openAdd(); });
      if (btnCancel) btnCancel.addEventListener('click', function(){
        editBox.style.display = 'none';
        setForm({});
      });

      document.querySelectorAll('.btn-edit').forEach(function(btn){
        btn.addEventListener('click', function(e){
          e.preventDefault();
          openEdit(this);
        });
      });

      (function(){
        var supplierSearchKeyword = document.getElementById('supplierSearchKeyword');
        var btnSupplierSearch = document.getElementById('btnSupplierSearch');
        var filterSupplierField = document.getElementById('filterSupplierField');
        var filterSupplierValue = document.getElementById('filterSupplierValue');
        var btnSupplierFilterReset = document.getElementById('btnSupplierFilterReset');
        var supplierFilterCount = document.getElementById('supplierFilterCount');
        var supplierActiveFilters = document.getElementById('supplierActiveFilters');
        var supplierRows = Array.prototype.slice.call(document.querySelectorAll('.supplier-list-block tbody tr.js-supplier-row'));
        var totalRows = supplierRows.length;
        var fieldLabelMap = {
          corpnum: '사업자번호',
          corpname: '상호',
          ceoname: '대표자명',
          contactname: '담당자명'
        };

        function supplierFieldText(row, fieldKey) {
          return (row.getAttribute('data-' + fieldKey) || '').trim();
        }
        function refillFieldValues() {
          if (!filterSupplierField || !filterSupplierValue) return;
          var selectedField = filterSupplierField.value || 'corpnum';
          var unique = {};
          supplierRows.forEach(function(row){
            var v = supplierFieldText(row, selectedField);
            if (v) unique[v] = true;
          });
          var values = Object.keys(unique).sort(function(a, b){
            return a.localeCompare(b, 'ko');
          });
          var prev = filterSupplierValue.value || '';
          filterSupplierValue.innerHTML = '<option value="">값 전체</option>';
          values.forEach(function(v){
            var opt = document.createElement('option');
            opt.value = v;
            opt.textContent = v;
            filterSupplierValue.appendChild(opt);
          });
          if (prev && unique[prev]) filterSupplierValue.value = prev;
        }

        function supplierKeywordText(row) {
          return (
            supplierFieldText(row, 'corpnum') + ' ' +
            supplierFieldText(row, 'corpname') + ' ' +
            supplierFieldText(row, 'ceoname') + ' ' +
            supplierFieldText(row, 'contactname')
          ).toLowerCase();
        }
        function renderActiveFilterChips() {
          if (!supplierActiveFilters) return;
          var chips = [];
          var keyword = (supplierSearchKeyword && supplierSearchKeyword.value ? supplierSearchKeyword.value : '').trim();
          var fieldKey = filterSupplierField ? filterSupplierField.value : 'corpnum';
          var selectedValue = filterSupplierValue ? filterSupplierValue.value : '';
          if (keyword) {
            chips.push(
              '<span class="filter-chip">검색어: ' + keyword.replace(/</g, '&lt;').replace(/>/g, '&gt;') +
              '<button type="button" data-chip-remove="keyword" aria-label="검색어 필터 제거">×</button></span>'
            );
          }
          if (selectedValue) {
            var label = fieldLabelMap[fieldKey] || fieldKey;
            chips.push(
              '<span class="filter-chip">' + label + ': ' + selectedValue.replace(/</g, '&lt;').replace(/>/g, '&gt;') +
              '<button type="button" data-chip-remove="value" aria-label="선택 필터 제거">×</button></span>'
            );
          }
          supplierActiveFilters.innerHTML = chips.join('');
        }

        function applySupplierFilters() {
          if (supplierRows.length === 0) {
            if (supplierFilterCount) supplierFilterCount.textContent = '';
            renderActiveFilterChips();
            return;
          }
          var fieldKey = filterSupplierField ? filterSupplierField.value : 'corpnum';
          var keyword = (supplierSearchKeyword && supplierSearchKeyword.value ? supplierSearchKeyword.value : '').toLowerCase().trim();
          var selectedValue = filterSupplierValue ? filterSupplierValue.value : '';
          var visible = 0;
          supplierRows.forEach(function(row){
            var ok = true;
            if (selectedValue && supplierFieldText(row, fieldKey) !== selectedValue) ok = false;
            if (ok && keyword && supplierKeywordText(row).indexOf(keyword) === -1) ok = false;
            row.style.display = ok ? '' : 'none';
            if (ok) visible++;
          });
          if (supplierFilterCount) supplierFilterCount.textContent = '표시 ' + visible + '건 / 전체 ' + totalRows + '건';
          renderActiveFilterChips();
        }

        if (btnSupplierSearch) btnSupplierSearch.addEventListener('click', applySupplierFilters);
        if (supplierSearchKeyword) {
          supplierSearchKeyword.addEventListener('keydown', function(e){
            if (e.key === 'Enter' || e.keyCode === 13) {
              e.preventDefault();
              applySupplierFilters();
            }
          });
        }
        if (filterSupplierField) {
          filterSupplierField.addEventListener('change', function(){
            refillFieldValues();
            applySupplierFilters();
          });
        }
        if (filterSupplierValue) filterSupplierValue.addEventListener('change', applySupplierFilters);
        if (btnSupplierFilterReset) {
          btnSupplierFilterReset.addEventListener('click', function(){
            if (supplierSearchKeyword) supplierSearchKeyword.value = '';
            if (filterSupplierField) filterSupplierField.value = 'corpnum';
            refillFieldValues();
            if (filterSupplierValue) filterSupplierValue.value = '';
            applySupplierFilters();
          });
        }
        if (supplierActiveFilters) {
          supplierActiveFilters.addEventListener('click', function(e){
            var target = e.target;
            if (!target || !target.getAttribute) return;
            var type = target.getAttribute('data-chip-remove');
            if (type === 'keyword' && supplierSearchKeyword) supplierSearchKeyword.value = '';
            if (type === 'value' && filterSupplierValue) filterSupplierValue.value = '';
            if (type) applySupplierFilters();
          });
        }

        refillFieldValues();
        applySupplierFilters();
      })();

      var btnSupplierSelectAll = document.getElementById('btnSupplierSelectAll');
      if (btnSupplierSelectAll) {
        btnSupplierSelectAll.addEventListener('click', function(){
          document.querySelectorAll('.supplier-list-block tbody input[name="ids"]').forEach(function(cb){
            if (cb.closest('tr').style.display === 'none') return;
            cb.checked = true;
          });
        });
      }
      var btnSupplierUnselectAll = document.getElementById('btnSupplierUnselectAll');
      if (btnSupplierUnselectAll) {
        btnSupplierUnselectAll.addEventListener('click', function(){
          document.querySelectorAll('.supplier-list-block tbody input[name="ids"]').forEach(function(cb){
            cb.checked = false;
          });
        });
      }
      var supplierBulkDeleteForm = document.getElementById('supplierBulkDeleteForm');
      if (supplierBulkDeleteForm) {
        supplierBulkDeleteForm.addEventListener('submit', function(e){
          var checked = document.querySelectorAll('.supplier-list-block tbody input[name="ids"]:checked');
          supplierBulkDeleteForm.querySelectorAll('input[name="ids"][type="hidden"]').forEach(function(el){ el.remove(); });
          if (!checked || checked.length === 0) {
            e.preventDefault();
            alert('삭제할 공급자를 선택하세요.');
            return false;
          }
          checked.forEach(function(cb){
            var hidden = document.createElement('input');
            hidden.type = 'hidden';
            hidden.name = 'ids';
            hidden.value = cb.value;
            supplierBulkDeleteForm.appendChild(hidden);
          });
          return true;
        });
      }
    })();
    document.getElementById('menu-supplier').classList.add('on');
  </script>
</body>
</html>
