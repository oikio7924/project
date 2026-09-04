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
    .base-info-col, .contract-info-col { background: #ffffff; border: 1px solid #dbe3ec; border-radius: 10px; padding: 1rem 1.25rem; box-sizing: border-box; min-width: 0; max-width: 100%; overflow: hidden; }
    .base-info-col { gap: 0.65rem; }
    .base-info-col .form-row { margin-bottom: 0; padding: 0; }
    .base-info-col #bizFields, .base-info-col #personFields { display: flex; flex-direction: column; gap: 0.65rem; }
    .base-info-col #bizFields .form-row, .base-info-col #personFields .form-row { margin-bottom: 0; }
    .type-choice-row {
      display: flex;
      align-items: center;
      gap: 0.7rem;
      min-height: 34px;
      margin: 0 0 0.8rem 0;
      flex-wrap: wrap;
      padding: 0.15rem 0 0.55rem 0;
      border-bottom: 1px solid #e4e9f0;
      max-width: 100%;
      box-sizing: border-box;
    }
    .type-choice-label { width: auto; flex-shrink: 0; white-space: nowrap; font-weight: 700; color: #34495e; font-size: 0.86rem; }
    #bizOwnerChoiceLabel { margin-left: 1.6rem; }
    .type-choice-options { display: flex; align-items: center; gap: 0.8rem; flex-wrap: wrap; }
    .type-choice-options label { display: inline-flex; align-items: center; gap: 3px; white-space: nowrap; margin: 0; width: auto; font-size: 0.84rem; }
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
    .biz-license-upload { display: flex; flex-direction: column; gap: 0.35rem; min-width: 0; grid-column: 2 / span 2; }
    .biz-license-saved-wrap { display: flex; gap: 0.5rem; align-items: center; justify-content: flex-end; width: 100%; }
    .biz-license-edit-wrap { display: flex; gap: 0.5rem; align-items: center; justify-content: flex-end; width: 100%; }
    .biz-license-edit-wrap input { flex: 1; }
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
    .form-row textarea {
      padding: 7px 10px;
      min-width: 0;
      width: 100%;
      box-sizing: border-box;
      border: 1px solid #ccd6e2;
      border-radius: 6px;
      background: #fff;
      transition: border-color 0.2s, box-shadow 0.2s;
    }
    .form-row input:not([type="radio"]):not([type="checkbox"]):focus, .form-row select:focus, .form-row textarea:focus {
      outline: none;
      border-color: #5b8def;
      box-shadow: 0 0 0 3px rgba(91, 141, 239, 0.14);
    }
    .wide-field { grid-column: 2 / -1; }
    .check-group { display: flex; flex-wrap: wrap; gap: 0.75rem; align-items: center; }
    .check-group label { width: auto; margin-right: 0.25rem; white-space: nowrap; display: inline-flex; align-items: center; gap: 4px; }
    .check-group input[type="radio"], .check-group input[type="checkbox"] {
      width: auto;
      min-width: 0;
      margin: 0;
      padding: 0;
      box-shadow: none;
      border: 0;
      vertical-align: middle;
    }
    .contract-option-wrap { margin: 0.75rem 0; flex: 1; display: flex; flex-direction: column; gap: 0.7rem; }
    .option-row { grid-template-columns: minmax(5.5rem, 7.5rem) minmax(0, 1fr); }
    .option-field {
      border: 1px solid #ccd6e2;
      border-radius: 6px;
      background: #fff;
      padding: 8px 12px;
      min-height: 38px;
      display: flex;
      align-items: center;
      justify-content: flex-start;
      flex-wrap: wrap;
      gap: 0.5rem 0.75rem;
      box-sizing: border-box;
      min-width: 0;
      max-width: 100%;
    }
    .option-field.check-group { width: 100%; }
    .option-field.check-group label { margin: 0; }
    .addr-wrap { display: flex; flex-direction: column; gap: 0.45rem; width: 100%; min-width: 0; max-width: 100%; box-sizing: border-box; }
    .addr-row-top {
      display: grid;
      grid-template-columns: minmax(0, 100px) minmax(56px, 72px) minmax(0, 1fr) minmax(56px, 76px);
      gap: 0.45rem;
      align-items: center;
      min-width: 0;
      width: 100%;
    }
    .addr-row-top input { min-width: 0; }
    .addr-row-bottom { display: grid; grid-template-columns: minmax(0, 1fr); gap: 0.45rem; align-items: center; min-width: 0; width: 100%; }
    .addr-btn { padding: 7px 8px; border: 1px solid #ccd6e2; border-radius: 6px; background: #f6f8fb; color: #34495e; cursor: pointer; white-space: nowrap; flex-shrink: 0; font-size: 0.82rem; box-sizing: border-box; }
    .addr-btn:hover { background: #eef3f9; }
    .memo-textarea { min-width: 0; width: 100%; grid-column: 2 / -1; min-height: 92px; }
    .form-actions { margin-top: 0.75rem; display: flex; gap: 0.5rem; flex-wrap: wrap; }
    .top-actions { display: flex; justify-content: flex-start; align-items: center; gap: 0.75rem; margin-bottom: 0.75rem; flex-wrap: wrap; }
    .excel-import-form { display: flex; gap: 0.5rem; align-items: center; }
    .excel-file-input { min-width: 380px; width: 520px; max-width: 100%; }
    .tool-search-row { margin-top: 0.5rem; }
    .tool-search-title { font-weight: 700; color: #2c3e50; margin-bottom: 0.35rem; }
    .tool-search-row .search-input { padding: 6px 10px; border: 1px solid #bdc3c7; border-radius: 4px; width: 100%; max-width: 100%; box-sizing: border-box; }
    .filter-toolbar { display: flex; flex-wrap: wrap; align-items: center; gap: 0.5rem 0.75rem; margin-top: 0.35rem; }
    .filter-toolbar .search-input { flex: 1 1 240px; min-width: 180px; max-width: 100%; }
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
    .contractor-tool-block { background: #f8f9fa; border: 1px solid #dee2e6; border-radius: 8px; padding: 1rem; margin-bottom: 1rem; }
    .contractor-list-block { background: #fff; border: 1px solid #dee2e6; border-radius: 8px; padding: 1rem; }
    .contractor-list-head { display: flex; justify-content: space-between; align-items: center; gap: 0.5rem; margin-bottom: 0.75rem; flex-wrap: wrap; }
    .contractor-list-title { font-weight: 800; color: #2c3e50; }
    .contractor-list-actions { display: flex; gap: 0.5rem; align-items: center; }
    .name-edit-link { color: #2c3e50; text-decoration: underline; cursor: pointer; font-weight: 600; }
    .name-edit-link:hover { color: #1b2838; }
    .msg { padding: 0.5rem; margin-bottom: 0.5rem; border-radius: 4px; background: #d4edda; color: #155724; }
    .hide { display: none; }
    @media (max-width: 1200px) {
      .form-split { grid-template-columns: minmax(0, 1fr); }
    }
  </style>
</head>
<body>
  <div class="hometax-wrap">
    <%@ include file="/WEB-INF/jsp/hometax/include/hometax_sidebar.jsp" %>
    <div class="hometax-main">
      <div class="page-title">계약자 관리</div>
      <div class="content-box">
        <c:if test="${not empty message}"><div class="msg">${message}</div></c:if>

        <!-- 수정/추가 폼(모달처럼 사용) -->
        <div class="form-box" id="editBox" style="display:none;">
          <h3 id="formTitle">계약자 정보</h3>
          <form action="${pageContext.request.contextPath}/bill/contractor/save.do" method="post" enctype="multipart/form-data" id="powerPlantForm">
            <input type="hidden" name="id" id="fid" value="" />
            <div class="type-choice-row">
              <div class="type-choice-label">구분</div>
              <div class="type-choice-options">
                <label><input type="radio" name="partyTypeOpt" value="01" checked="checked" /> 사업자</label>
                <label><input type="radio" name="partyTypeOpt" value="02" /> 개인</label>
              </div>
              <div class="type-choice-label" id="bizOwnerChoiceLabel">사업자구분</div>
              <div class="type-choice-options" id="bizOwnerChoiceRow">
                <label><input type="radio" name="bizOwnerTypeOpt" value="P" checked="checked" /> 개인사업자</label>
                <label><input type="radio" name="bizOwnerTypeOpt" value="C" /> 법인사업자</label>
              </div>
            </div>
            <input type="hidden" name="partyType" id="fpartyType" value="01" />
            <input type="hidden" name="bizOwnerType" id="fbizOwnerType" value="P" />

            <div class="form-split">
              <div class="form-col base-info-col">

                <div class="form-row">
                  <label>사용</label>
                  <select name="useYn" id="fuseYn">
                    <option value="Y">Y</option>
                    <option value="N">N</option>
                  </select>
                </div>

                <!-- 사업자 필드 -->
                <div id="bizFields">

                  <div class="form-row">
                    <label>상호명</label><input type="text" name="corpName" id="fcorpName" maxlength="100" />
                    <label>대표자명</label><input type="text" name="ceoName" id="fceoName" maxlength="50" />
                  </div>

                  <div class="form-row">
                    <label>사업자등록번호</label><input type="text" name="corpNum" id="fcoporNum" maxlength="20" />
                    <label>휴대전화</label><input type="text" name="mobilePhone" id="fmobilePhone" maxlength="30" />
                  </div>

                  <div class="form-row">
                    <label>업태</label><input type="text" name="bizType" id="fbizType" maxlength="50" />
                    <label>이메일</label><input type="text" name="email" id="femail" maxlength="100" />
                  </div>

                  <div class="form-row">
                    <label>업종</label><input type="text" name="bizClassification" id="fbizClassification" maxlength="50" />
                    <label>결제방식</label>
                    <select name="paymentMethod" id="fpaymentMethod">
                      <option value="AUTO">자동이체</option>
                      <option value="DIRECT">직접이체</option>
                    </select>
                  </div>
                  <div class="form-row">
                    <label>사업자등록증</label>
                    <div class="biz-license-upload">
                      <div id="bizLicenseSavedWrap" class="biz-license-saved-wrap">
                        <button type="button" class="btn btn-line btn-small" id="btnViewBizLicense" disabled="disabled">사업자등록증보기</button>
                        <button type="button" class="btn btn-line btn-small" id="btnChangeBizLicense" disabled="disabled">파일변경</button>
                      </div>

                      <div id="bizLicenseEditWrap" class="biz-license-edit-wrap" style="display:none;">
                        <input type="file" name="bizLicensePdf" id="fbizLicensePdf" accept="application/pdf,.pdf" />
                        <button type="button" class="btn btn-line btn-small" id="btnCancelBizLicense" style="display:none;">취소</button>
                      </div>
                    </div>
                  </div>
                </div>

                <!-- 개인 필드 -->
                <div id="personFields" style="display:none;">
                  <div class="form-row">
                    <label>상호명</label><input type="text" id="fpersonName" maxlength="100" />
                  </div>
                  <div class="form-row">
                    <label>대표자명</label><input type="text" id="fpersonCeoName" maxlength="50" />
                  </div>
                  <div class="form-row">
                    <label>주민등록번호</label><input type="text" name="idNum" id="fidNum" maxlength="20" />
                  </div>
                  <div class="form-row">
                    <label>휴대전화</label><input type="text" id="fpersonMobilePhone" maxlength="30" />
                    <label>이메일</label><input type="text" id="fpersonEmail" maxlength="100" />
                  </div>
                  <div class="form-row">
                    <label>결제방식</label>
                    <select id="fpersonPaymentMethod">
                      <option value="AUTO">자동이체</option>
                      <option value="DIRECT">직접이체</option>
                    </select>
                  </div>
                </div>

                <div class="form-row">
                  <label>주소</label>
                  <div class="wide-field addr-wrap">
                    <div class="addr-row-top">
                      <input type="text" id="faddressZip" maxlength="10" placeholder="우편번호" />
                      <button type="button" class="addr-btn" id="btnAddrSearch">검색</button>
                      <input type="text" id="faddressMain" maxlength="200" placeholder="주소" />
                      <button type="button" class="addr-btn" id="btnAddrClear">초기화</button>
                    </div>
                    <div class="addr-row-bottom">
                      <input type="text" id="faddressDetail" maxlength="200" placeholder="상세주소" />
                    </div>
                    <input type="hidden" name="address" id="faddress" value="" />
                  </div>
                </div>
              </div>

              <div class="form-col contract-info-col">
                <div class="contract-option-wrap">
                  <div class="form-row option-row">
                    <label>계약정보</label>
                    <div class="check-group option-field">
                      <label><input type="radio" name="contractInfoOpt" value="유지관리"> 유지관리</label>
                      <label><input type="radio" name="contractInfoOpt" value="안전관리"> 안전관리</label>
                      <label><input type="radio" name="contractInfoOpt" value="모니터링"> 모니터링</label>
                    </div>
                  </div>

                  <div class="form-row option-row">
                    <label>계약상세</label>
                    <div class="check-group option-field">
                      <label><input type="checkbox" name="contractDetailOpt" value="안전관리"> 안전관리</label>
                      <label><input type="checkbox" name="contractDetailOpt" value="세무"> 세무</label>
                      <label><input type="checkbox" name="contractDetailOpt" value="청구"> 청구</label>
                      <label><input type="checkbox" name="contractDetailOpt" value="모니터링"> 모니터링</label>
                    </div>
                  </div>

                  <div class="form-row option-row">
                    <label>모니터링</label>
                    <div class="check-group option-field">
                      <label><input type="radio" name="monitoringOpt" value="다고스"> 다르고스</label>
                      <label><input type="radio" name="monitoringOpt" value="솔라링"> 솔라링</label>
                      <label><input type="radio" name="monitoringOpt" value="C"> 타사 C</label>
                      <label><input type="radio" name="monitoringOpt" value="D"> 타사 D</label>
                      <label><input type="radio" name="monitoringOpt" value="E"> 타사 E</label>
                    </div>
                  </div>

                  <input type="hidden" name="contractInfo" id="fcontractInfo" value="" />
                  <input type="hidden" name="contractDetail" id="fcontractDetail" value="" />
                  <input type="hidden" name="monitoring" id="fmonitoring" value="" />
                </div>

                <div class="form-row">
                  <label>메모</label>
                  <textarea name="memo" id="fmemo" rows="4" class="memo-textarea"></textarea>
                </div>
              </div>
            </div>

            <div class="form-actions">
              <button type="submit" class="btn btn-primary">저장</button>
              <button type="button" class="btn btn-line" id="btnCancel">닫기</button>
            </div>
          </form>
        </div>

        <div class="contractor-tool-block">
          <div class="top-actions">
            <button type="button" class="btn btn-line" id="btnAdd">계약자 추가</button>
            <form action="${pageContext.request.contextPath}/bill/contractor/importContractorExcel.do" method="post" enctype="multipart/form-data" id="contractorImportExcelForm" class="excel-import-form">
              <button type="submit" class="btn btn-line">계약자 일괄등록</button>
              <input type="file" name="excelFile" accept=".xlsx,.xls" required="required" class="excel-file-input" />
            </form>
          </div>
          <div class="tool-search-row">
            <div class="tool-search-title">계약자 검색</div>
            <div class="filter-toolbar">
              <input type="text" id="contractorSearchKeyword" class="search-input" placeholder="검색창 (상호명, 대표자, 연락처 등)" autocomplete="off" />
              <button type="button" class="btn btn-primary btn-small" id="btnContractorSearch">검색</button>
              <button type="button" class="btn btn-line btn-small" id="btnContractorFilterReset">초기화</button>
              <span class="filter-result-count" id="contractorFilterCount" aria-live="polite"></span>
            </div>
            <div class="filter-subtitle">필터</div>
            <div class="filter-select-row" style="margin-top: 0.35rem;">
              <select id="filterContractorField" class="filter-select" title="필터 항목">
                <option value="corpname">상호명</option>
                <option value="partylabel">구분</option>
                <option value="ceoname">대표자</option>
                <option value="mobilephone">연락처</option>
                <option value="useyn">상태</option>
              </select>
              <select id="filterContractorValue" class="filter-select" title="필터 값">
                <option value="">값 전체</option>
              </select>
            </div>
            <div class="active-filter-chips" id="contractorActiveFilters"></div>
          </div>
        </div>

        <div class="contractor-list-block">
          <div class="contractor-list-head">
            <div class="contractor-list-title">계약자 목록</div>
            <div class="contractor-list-actions">
              <button type="button" class="btn btn-line btn-small" id="btnSelectAll">전체선택</button>
              <button type="button" class="btn btn-line btn-small" id="btnUnselectAll">선택 해제</button>
              <form action="${pageContext.request.contextPath}/bill/contractor/delete.do" method="post" id="bulkDeleteForm" style="margin:0;">
                <button type="submit" class="btn btn-danger btn-small" onclick="return confirm('선택한 계약자를 삭제할까요?');">선택 삭제</button>
              </form>
            </div>
          </div>
          <table>
            <thead>
              <tr>
                <th style="width:60px;">선택</th>
                <th style="width:70px;">No</th>
                <th>상호명</th>
                <th style="width:110px;">구분</th>
                <th style="width:140px;">대표자</th>
                <th style="width:150px;">연락처</th>
                <th style="width:90px;">상태</th>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${empty powerPlantList}">
                  <tr><td colspan="7" style="text-align:center;">등록된 계약자가 없습니다.</td></tr>
                </c:when>
                <c:otherwise>
                  <c:forEach var="p" items="${powerPlantList}" varStatus="st">
                    <tr class="js-contractor-row"
                        data-party-type="${p.partyType}"
                        data-use-yn="${p.useYn}"
                        data-corpname="<c:out value='${p.corpName}'/>"
                        data-partylabel="${p.partyType}"
                        data-ceoname="<c:out value='${p.ceoName}'/>"
                        data-mobilephone="<c:out value='${p.mobilePhone}'/>"
                        data-useyn="<c:out value='${p.useYn}'/>">
                      <td><input type="checkbox" name="ids" value="${p.id}"/></td>
                      <td>${st.index + 1}</td>
                      <td class="left">
                        <a href="#" class="name-edit-link btn-edit"
                           data-id="${p.id}"
                           data-partytype="${p.partyType}"
                           data-bizownertype="${p.bizOwnerType}"
                           data-corpname="${p.corpName}"
                           data-ceoname="${p.ceoName}"
                           data-corpnum="${p.corpNum}"
                           data-biztype="<c:out value='${p.bizType}'/>"
                           data-bizclassification="<c:out value='${p.bizClassification}'/>"
                           data-idnum="${p.idNum}"
                           data-mobilephone="${p.mobilePhone}"
                           data-address="<c:out value='${p.address}'/>"
                           data-email="<c:out value='${p.email}'/>"
                           data-paymentmethod="${p.paymentMethod}"
                           data-contractinfo="<c:out value='${p.contractInfo}'/>"
                           data-contractdetail="<c:out value='${p.contractDetail}'/>"
                           data-monitoring="<c:out value='${p.monitoring}'/>"
                           data-memo="<c:out value='${p.memo}'/>"
                           data-haslicense="${not empty p.bizLicenseFile ? 'Y' : 'N'}"
                           data-useyn="${p.useYn}">
                          ${p.corpName}
                        </a>
                      </td>
                      <td>
                        <c:choose>
                          <c:when test="${p.partyType == '01'}">사업자</c:when>
                          <c:when test="${p.partyType == '02'}">개인</c:when>
                          <c:otherwise>${p.partyType}</c:otherwise>
                        </c:choose>
                      </td>
                      <td>${p.ceoName}</td>
                      <td>${p.mobilePhone}</td>
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
      var btnAdd = document.getElementById('btnAdd');
      var btnCancel = document.getElementById('btnCancel');
      var formTitle = document.getElementById('formTitle');
      var partySel = document.getElementById('fpartyType');
      var btnViewBizLicense = document.getElementById('btnViewBizLicense');
      var btnChangeBizLicense = document.getElementById('btnChangeBizLicense');
      var btnCancelBizLicense = document.getElementById('btnCancelBizLicense');
      var fbizLicensePdf = document.getElementById('fbizLicensePdf');
      var bizLicenseSavedWrap = document.getElementById('bizLicenseSavedWrap');
      var bizLicenseEditWrap = document.getElementById('bizLicenseEditWrap');
      var bizFields = document.getElementById('bizFields');
      var personFields = document.getElementById('personFields');
      var bizOwnerWrap = document.getElementById('bizOwnerChoiceRow');
      var bizOwnerLabel = document.getElementById('bizOwnerChoiceLabel');
      var powerPlantForm = document.getElementById('powerPlantForm');
      var partyTypeOpts = document.querySelectorAll('input[name="partyTypeOpt"]');
      var bizOwnerTypeOpts = document.querySelectorAll('input[name="bizOwnerTypeOpt"]');

      var fid = document.getElementById('fid');
      var currentBizLicenseId = '';
      var bizLicenseEditing = false;
      var hasBizLicense = false;

      var fcorpName = document.getElementById('fcorpName');
      var fceoName = document.getElementById('fceoName');
      var fcorpn = document.getElementById('fcoporNum');
      var fbizType = document.getElementById('fbizType');
      var fbizClassification = document.getElementById('fbizClassification');
      var fidNum = document.getElementById('fidNum');
      var fpersonName = document.getElementById('fpersonName');
      var fpersonCeoName = document.getElementById('fpersonCeoName');
      var fpersonMobilePhone = document.getElementById('fpersonMobilePhone');
      var fpersonEmail = document.getElementById('fpersonEmail');
      var fpersonPaymentMethod = document.getElementById('fpersonPaymentMethod');

      var fmobilePhone = document.getElementById('fmobilePhone');
      var faddress = document.getElementById('faddress');
      var faddressZip = document.getElementById('faddressZip');
      var faddressMain = document.getElementById('faddressMain');
      var faddressDetail = document.getElementById('faddressDetail');
      var btnAddrClear = document.getElementById('btnAddrClear');
      var btnAddrSearch = document.getElementById('btnAddrSearch');
      var femail = document.getElementById('femail');

      var fpaymentMethod = document.getElementById('fpaymentMethod');
      var fcontractInfo = document.getElementById('fcontractInfo');
      var fcontractDetail = document.getElementById('fcontractDetail');
      var fmonitoring = document.getElementById('fmonitoring');
      var fmemo = document.getElementById('fmemo');
      var fuseYn = document.getElementById('fuseYn');
      var contractInfoOpts = document.querySelectorAll('input[name="contractInfoOpt"]');
      var contractDetailOpts = document.querySelectorAll('input[name="contractDetailOpt"]');
      var monitoringOpts = document.querySelectorAll('input[name="monitoringOpt"]');

      function clearChecks(nodeList) {
        nodeList.forEach(function(el){ el.checked = false; });
      }
      function setRadioByValue(nodeList, value) {
        var v = (value || '').trim();
        nodeList.forEach(function(el){ el.checked = (el.value === v); });
      }
      function setChecksByCsv(nodeList, csv) {
        var values = (csv || '').split(',').map(function(v){ return v.trim(); }).filter(function(v){ return !!v; });
        nodeList.forEach(function(el){ el.checked = values.indexOf(el.value) > -1; });
      }
      function syncContractFields() {
        var ci = '';
        contractInfoOpts.forEach(function(el){ if (el.checked) ci = el.value; });
        fcontractInfo.value = ci;

        var details = [];
        contractDetailOpts.forEach(function(el){ if (el.checked) details.push(el.value); });
        fcontractDetail.value = details.join(',');

        var mo = '';
        monitoringOpts.forEach(function(el){ if (el.checked) mo = el.value; });
        fmonitoring.value = mo;
      }

      function syncTypeOptionUI() {
        partyTypeOpts.forEach(function(el){ el.checked = (el.value === (partySel.value || '01')); });
        bizOwnerTypeOpts.forEach(function(el){ el.checked = (el.value === (document.getElementById('fbizOwnerType').value || 'P')); });
      }

      function composeAddressValue() {
        var zip = (faddressZip && faddressZip.value ? faddressZip.value.trim() : '');
        var main = (faddressMain && faddressMain.value ? faddressMain.value.trim() : '');
        var detail = (faddressDetail && faddressDetail.value ? faddressDetail.value.trim() : '');
        var parts = [];
        if (zip) parts.push('(' + zip + ')');
        if (main) parts.push(main);
        if (detail) parts.push(detail);
        faddress.value = parts.join(' ').trim();
      }

      function fillAddressUI(full) {
        var v = (full || '').trim();
        if (!faddressZip || !faddressMain || !faddressDetail) return;
        faddressZip.value = '';
        faddressMain.value = v;
        faddressDetail.value = '';
      }

      function applyTypeUI(partyType){
        var isBiz = partyType === '01';
        bizFields.style.display = isBiz ? '' : 'none';
        personFields.style.display = isBiz ? 'none' : '';
        if (bizOwnerWrap) bizOwnerWrap.style.display = isBiz ? '' : 'none';
        if (bizOwnerLabel) bizOwnerLabel.style.display = isBiz ? '' : 'none';
        if (isBiz) {
          // 개인 입력값 -> 실제 저장필드
          if (fpersonMobilePhone) fmobilePhone.value = fpersonMobilePhone.value || fmobilePhone.value || '';
          if (fpersonEmail) femail.value = fpersonEmail.value || femail.value || '';
          if (fpersonPaymentMethod) fpaymentMethod.value = fpersonPaymentMethod.value || fpaymentMethod.value || 'AUTO';
        } else {
          // 실제 저장필드 -> 개인 입력 UI
          if (fpersonMobilePhone) fpersonMobilePhone.value = fmobilePhone.value || '';
          if (fpersonEmail) fpersonEmail.value = femail.value || '';
          if (fpersonPaymentMethod) fpersonPaymentMethod.value = fpaymentMethod.value || 'AUTO';
        }
      }

      function openAdd(){
        fid.value = '';
        formTitle.textContent = '계약자 등록';
        document.getElementById('fpartyType').value = '01';
        document.getElementById('fbizOwnerType').value = 'P';
        syncTypeOptionUI();
        applyTypeUI('01');

        document.getElementById('fcorpName').value = '';
        document.getElementById('fceoName').value = '';
        document.getElementById('fcoporNum').value = '';
        if (fbizType) fbizType.value = '';
        if (fbizClassification) fbizClassification.value = '';
        document.getElementById('fidNum').value = '';
        document.getElementById('fpersonName').value = '';
        document.getElementById('fpersonCeoName').value = '';
        if (fpersonMobilePhone) fpersonMobilePhone.value = '';
        if (fpersonEmail) fpersonEmail.value = '';
        if (fpersonPaymentMethod) fpersonPaymentMethod.value = 'AUTO';

        document.getElementById('fmobilePhone').value = '';
        document.getElementById('faddress').value = '';
        fillAddressUI('');
        document.getElementById('femail').value = '';
        document.getElementById('fpaymentMethod').value = 'AUTO';
        document.getElementById('fcontractInfo').value = '';
        document.getElementById('fcontractDetail').value = '';
        document.getElementById('fmonitoring').value = '';
        clearChecks(contractInfoOpts);
        clearChecks(contractDetailOpts);
        clearChecks(monitoringOpts);
        document.getElementById('fmemo').value = '';
        document.getElementById('fuseYn').value = 'Y';
        bizLicenseEditing = false;
        currentBizLicenseId = '';
        hasBizLicense = false;
        if (bizLicenseSavedWrap) bizLicenseSavedWrap.style.display = 'none';
        if (bizLicenseEditWrap) bizLicenseEditWrap.style.display = '';
        if (btnCancelBizLicense) btnCancelBizLicense.style.display = 'none';
        if (fbizLicensePdf) {
          fbizLicensePdf.disabled = false;
          fbizLicensePdf.value = '';
        }
        if (btnViewBizLicense) {
          btnViewBizLicense.disabled = true;
          btnViewBizLicense.setAttribute('data-license-id', '');
        }

        editBox.style.display = 'block';
      }

      function openEdit(btn){
        var o = btn.dataset;
        // data-id는 일부 환경에서 dataset 바인딩 이슈가 있어 속성으로 보강
        fid.value = (btn.getAttribute('data-id') || o.id || '');
        formTitle.textContent = '계약자 수정';

        partySel.value = o.partytype || '01';
        document.getElementById('fbizOwnerType').value = o.bizownertype || 'P';
        syncTypeOptionUI();
        applyTypeUI(partySel.value);

        fcorpName.value = o.corpname || '';
        fceoName.value = o.ceoname || '';
        fcorpn.value = o.corpnum || '';
        if (fbizType) fbizType.value = o.biztype || '';
        if (fbizClassification) fbizClassification.value = o.bizclassification || '';
        fpersonName.value = o.corpname || '';
        fpersonCeoName.value = o.ceoname || '';
        fidNum.value = o.idnum || '';
        if (fpersonMobilePhone) fpersonMobilePhone.value = o.mobilephone || '';
        if (fpersonEmail) fpersonEmail.value = o.email || '';
        if (fpersonPaymentMethod) fpersonPaymentMethod.value = o.paymentmethod || 'AUTO';

        fmobilePhone.value = o.mobilephone || '';
        faddress.value = o.address || '';
        fillAddressUI(faddress.value);
        femail.value = o.email || '';
        fpaymentMethod.value = o.paymentmethod || 'AUTO';
        fcontractInfo.value = o.contractinfo || '';
        fcontractDetail.value = o.contractdetail || '';
        fmonitoring.value = o.monitoring || '';
        setRadioByValue(contractInfoOpts, fcontractInfo.value);
        setChecksByCsv(contractDetailOpts, fcontractDetail.value);
        setRadioByValue(monitoringOpts, fmonitoring.value);
        fmemo.value = o.memo || '';
        fuseYn.value = o.useyn || 'Y';
        hasBizLicense = (o.haslicense || 'N') === 'Y';
        bizLicenseEditing = false;
        currentBizLicenseId = hasBizLicense ? fid.value : '';

        if (hasBizLicense) {
          // 저장된 상태: 보기/파일변경 버튼만 노출
          if (bizLicenseSavedWrap) bizLicenseSavedWrap.style.display = '';
          if (bizLicenseEditWrap) bizLicenseEditWrap.style.display = 'none';
          if (btnCancelBizLicense) btnCancelBizLicense.style.display = 'none';
          if (fbizLicensePdf) fbizLicensePdf.disabled = true;

          if (btnChangeBizLicense) btnChangeBizLicense.disabled = false;
          if (btnViewBizLicense) {
            btnViewBizLicense.disabled = false;
            btnViewBizLicense.setAttribute('data-license-id', fid.value);
          }
        } else {
          // 저장된 파일이 없는 상태: 파일선택만 노출 (취소 버튼 없음)
          if (bizLicenseSavedWrap) bizLicenseSavedWrap.style.display = 'none';
          if (bizLicenseEditWrap) bizLicenseEditWrap.style.display = '';
          if (btnCancelBizLicense) btnCancelBizLicense.style.display = 'none';
          if (fbizLicensePdf) {
            fbizLicensePdf.disabled = false;
            fbizLicensePdf.value = '';
          }
          if (btnViewBizLicense) {
            btnViewBizLicense.disabled = true;
            btnViewBizLicense.setAttribute('data-license-id', '');
          }
          if (btnChangeBizLicense) btnChangeBizLicense.disabled = true;
        }

        editBox.style.display = 'block';
      }

      btnAdd.addEventListener('click', function(){ openAdd(); });
      btnCancel.addEventListener('click', function(){ editBox.style.display = 'none'; });
      if (btnViewBizLicense) {
        btnViewBizLicense.addEventListener('click', function(){
          var id = btnViewBizLicense.getAttribute('data-license-id') || '';
          if (!id) return;
          window.open('${pageContext.request.contextPath}/bill/contractor/license/view.do?id=' + encodeURIComponent(id), '_blank');
        });
      }
      if (btnChangeBizLicense) {
        btnChangeBizLicense.addEventListener('click', function(){
          if (!hasBizLicense) return;
          bizLicenseEditing = true;
          if (bizLicenseSavedWrap) bizLicenseSavedWrap.style.display = 'none';
          if (bizLicenseEditWrap) bizLicenseEditWrap.style.display = '';
          if (btnCancelBizLicense) btnCancelBizLicense.style.display = '';
          if (fbizLicensePdf) {
            fbizLicensePdf.disabled = false;
            fbizLicensePdf.value = '';
          }
        });
      }
      if (btnCancelBizLicense) {
        btnCancelBizLicense.addEventListener('click', function(){
          bizLicenseEditing = false;
          if (hasBizLicense) {
            // 저장된 상태로 되돌리기
            if (bizLicenseSavedWrap) bizLicenseSavedWrap.style.display = '';
            if (bizLicenseEditWrap) bizLicenseEditWrap.style.display = 'none';
            if (btnCancelBizLicense) btnCancelBizLicense.style.display = 'none';
            if (fbizLicensePdf) {
              fbizLicensePdf.disabled = true;
              fbizLicensePdf.value = '';
            }
          } else {
            // 저장된 파일이 없으면, 취소 버튼만 숨기고 파일선택만 유지
            if (bizLicenseSavedWrap) bizLicenseSavedWrap.style.display = 'none';
            if (bizLicenseEditWrap) bizLicenseEditWrap.style.display = '';
            if (btnCancelBizLicense) btnCancelBizLicense.style.display = 'none';
            if (fbizLicensePdf) {
              fbizLicensePdf.disabled = false;
              fbizLicensePdf.value = '';
            }
          }
        });
      }

      partyTypeOpts.forEach(function(el){
        el.addEventListener('change', function(){
          if (!this.checked) return;
          partySel.value = this.value;
          applyTypeUI(this.value);
        });
      });
      bizOwnerTypeOpts.forEach(function(el){
        el.addEventListener('change', function(){
          if (!this.checked) return;
          document.getElementById('fbizOwnerType').value = this.value;
        });
      });

      if (powerPlantForm) {
        powerPlantForm.addEventListener('submit', function(){
          // 개인일 때도 상호명/대표자명이 저장 필드로 반영되도록 동기화
          if (partySel.value !== '01') {
            fcorpName.value = fpersonName.value || '';
            fceoName.value = fpersonCeoName.value || '';
            if (fpersonMobilePhone) fmobilePhone.value = fpersonMobilePhone.value || '';
            if (fpersonEmail) femail.value = fpersonEmail.value || '';
            if (fpersonPaymentMethod) fpaymentMethod.value = fpersonPaymentMethod.value || 'AUTO';
          }
          composeAddressValue();
          syncContractFields();
        });
      }

      if (btnAddrClear) {
        btnAddrClear.addEventListener('click', function(){
          if (faddressZip) faddressZip.value = '';
          if (faddressMain) faddressMain.value = '';
          if (faddressDetail) faddressDetail.value = '';
          faddress.value = '';
        });
      }
      if (btnAddrSearch) {
        btnAddrSearch.addEventListener('click', function(){
          alert('주소 검색 연동은 추후 연결 예정입니다.');
        });
      }

      document.querySelectorAll('.btn-edit').forEach(function(btn){
        btn.addEventListener('click', function(e){
          e.preventDefault();
          openEdit(this);
        });
      });

      var btnGoRecipient = document.getElementById('btnGoRecipient');
      if (btnGoRecipient) {
        btnGoRecipient.addEventListener('click', function(){
          var checked = document.querySelector('input[name="ids"]:checked');
          if (!checked) { alert('발전소를 하나 선택하세요.'); return; }
          var id = checked.value;
          var ctx = '${pageContext.request.contextPath}';
          window.location.href = ctx + '/bill/recipient.do?powerPlantId=' + encodeURIComponent(id) + '&openAdd=1';
        });
      }

      var btnSelectAll = document.getElementById('btnSelectAll');
      if (btnSelectAll) {
        btnSelectAll.addEventListener('click', function(){
          document.querySelectorAll('input[name="ids"]').forEach(function(cb){
            cb.checked = true;
          });
        });
      }

      var btnUnselectAll = document.getElementById('btnUnselectAll');
      if (btnUnselectAll) {
        btnUnselectAll.addEventListener('click', function(){
          document.querySelectorAll('input[name="ids"]').forEach(function(cb){
            cb.checked = false;
          });
        });
      }

      // 선택 삭제: 현재 체크된 ids를 폼으로 동적으로 전달
      var bulkDeleteForm = document.getElementById('bulkDeleteForm');
      if (bulkDeleteForm) {
        bulkDeleteForm.addEventListener('submit', function(e){
          var checked = document.querySelectorAll('input[name="ids"]:checked');
          bulkDeleteForm.querySelectorAll('input[name="ids"][type="hidden"]').forEach(function(el){ el.remove(); });
          if (!checked || checked.length === 0) {
            e.preventDefault();
            alert('삭제할 발전소를 선택하세요.');
            return false;
          }
          checked.forEach(function(cb){
            var hidden = document.createElement('input');
            hidden.type = 'hidden';
            hidden.name = 'ids';
            hidden.value = cb.value;
            bulkDeleteForm.appendChild(hidden);
          });
          return true;
        });
      }

      // 계약자 목록: 검색 + 선택 필터
      (function(){
        var contractorSearchKeyword = document.getElementById('contractorSearchKeyword');
        var btnContractorSearch = document.getElementById('btnContractorSearch');
        var filterContractorField = document.getElementById('filterContractorField');
        var filterContractorValue = document.getElementById('filterContractorValue');
        var btnContractorFilterReset = document.getElementById('btnContractorFilterReset');
        var contractorFilterCount = document.getElementById('contractorFilterCount');
        var contractorActiveFilters = document.getElementById('contractorActiveFilters');
        var contractorRows = Array.prototype.slice.call(document.querySelectorAll('.contractor-list-block tbody tr.js-contractor-row'));
        var totalRows = contractorRows.length;
        var fieldLabelMap = {
          corpname: '상호명',
          partylabel: '구분',
          ceoname: '대표자',
          mobilephone: '연락처',
          useyn: '상태'
        };

        function normalizeFieldValue(fieldKey, value) {
          var v = (value || '').trim();
          if (fieldKey === 'partylabel') {
            if (v === '01') return '사업자';
            if (v === '02') return '개인';
          }
          return v;
        }
        function contractorFieldText(row, fieldKey) {
          return normalizeFieldValue(fieldKey, row.getAttribute('data-' + fieldKey) || '');
        }
        function contractorKeywordText(row) {
          return (
            contractorFieldText(row, 'corpname') + ' ' +
            contractorFieldText(row, 'partylabel') + ' ' +
            contractorFieldText(row, 'ceoname') + ' ' +
            contractorFieldText(row, 'mobilephone') + ' ' +
            contractorFieldText(row, 'useyn')
          ).toLowerCase();
        }
        function refillContractorFieldValues() {
          if (!filterContractorField || !filterContractorValue) return;
          var selectedField = filterContractorField.value || 'corpname';
          var unique = {};
          contractorRows.forEach(function(row){
            var v = contractorFieldText(row, selectedField);
            if (v) unique[v] = true;
          });
          var values = Object.keys(unique).sort(function(a, b){
            return a.localeCompare(b, 'ko');
          });
          var prev = filterContractorValue.value || '';
          filterContractorValue.innerHTML = '<option value="">값 전체</option>';
          values.forEach(function(v){
            var opt = document.createElement('option');
            opt.value = v;
            opt.textContent = v;
            filterContractorValue.appendChild(opt);
          });
          if (prev && unique[prev]) filterContractorValue.value = prev;
        }
        function renderContractorActiveFilterChips() {
          if (!contractorActiveFilters) return;
          var chips = [];
          var keyword = (contractorSearchKeyword && contractorSearchKeyword.value ? contractorSearchKeyword.value : '').trim();
          var fieldKey = filterContractorField ? filterContractorField.value : 'corpname';
          var selectedValue = filterContractorValue ? filterContractorValue.value : '';
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
          contractorActiveFilters.innerHTML = chips.join('');
        }

        function applyContractorFilters() {
          if (contractorRows.length === 0) {
            if (contractorFilterCount) contractorFilterCount.textContent = '';
            renderContractorActiveFilterChips();
            return;
          }
          var keyword = (contractorSearchKeyword && contractorSearchKeyword.value ? contractorSearchKeyword.value : '').toLowerCase().trim();
          var fieldKey = filterContractorField ? filterContractorField.value : 'corpname';
          var selectedValue = filterContractorValue ? filterContractorValue.value : '';
          var visible = 0;
          contractorRows.forEach(function(row){
            var ok = true;
            if (selectedValue && contractorFieldText(row, fieldKey) !== selectedValue) ok = false;
            if (ok && keyword && contractorKeywordText(row).indexOf(keyword) === -1) ok = false;
            row.style.display = ok ? '' : 'none';
            if (ok) visible++;
          });
          if (contractorFilterCount) contractorFilterCount.textContent = '표시 ' + visible + '건 / 전체 ' + totalRows + '건';
          renderContractorActiveFilterChips();
        }

        if (btnContractorSearch) btnContractorSearch.addEventListener('click', applyContractorFilters);
        if (contractorSearchKeyword) {
          contractorSearchKeyword.addEventListener('keydown', function(e){
            if (e.key === 'Enter' || e.keyCode === 13) {
              e.preventDefault();
              applyContractorFilters();
            }
          });
        }
        if (filterContractorField) {
          filterContractorField.addEventListener('change', function(){
            refillContractorFieldValues();
            applyContractorFilters();
          });
        }
        if (filterContractorValue) filterContractorValue.addEventListener('change', applyContractorFilters);
        if (btnContractorFilterReset) {
          btnContractorFilterReset.addEventListener('click', function(){
            if (contractorSearchKeyword) contractorSearchKeyword.value = '';
            if (filterContractorField) filterContractorField.value = 'corpname';
            refillContractorFieldValues();
            if (filterContractorValue) filterContractorValue.value = '';
            applyContractorFilters();
          });
        }
        if (contractorActiveFilters) {
          contractorActiveFilters.addEventListener('click', function(e){
            var target = e.target;
            if (!target || !target.getAttribute) return;
            var type = target.getAttribute('data-chip-remove');
            if (type === 'keyword' && contractorSearchKeyword) contractorSearchKeyword.value = '';
            if (type === 'value' && filterContractorValue) filterContractorValue.value = '';
            if (type) applyContractorFilters();
          });
        }

        refillContractorFieldValues();
        applyContractorFilters();
      })();

    })();
    document.getElementById('menu-contractor').classList.add('on');
  </script>
</body>
</html>

