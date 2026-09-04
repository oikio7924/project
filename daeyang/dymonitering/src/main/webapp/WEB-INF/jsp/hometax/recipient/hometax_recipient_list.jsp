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
    .btn { display: inline-block; padding: 6px 14px; border-radius: 4px; text-decoration: none; font-size: 0.9rem; border: none; cursor: pointer; }
    .btn-primary { background: #2c3e50; color: #fff; }
    .btn-primary:hover { background: #34495e; }
    .btn-small { padding: 4px 10px; font-size: 0.85rem; }
    .btn-line { background: #fff; border: 1px solid #2c3e50; color: #2c3e50; }
    .btn-line:hover { background: #f4f6f7; }
    .top-actions { display: flex; justify-content: flex-end; align-items: center; gap: 0.75rem; margin-bottom: 0.75rem; flex-wrap: wrap; }
    .top-actions form { margin: 0; }
    .top-actions input[type="file"] { max-width: 260px; }
    .badge { display: inline-block; padding: 2px 8px; border-radius: 999px; font-size: 0.8rem; }
    .badge-y { background: #d4edda; color: #155724; }
    .badge-n { background: #f8d7da; color: #721c24; }
    .form-box { background: #f8f9fa; border: 1px solid #dee2e6; border-radius: 8px; padding: 1rem 1.5rem; margin-bottom: 1rem; }
    .form-box h3 { margin: 0 0 0.75rem 0; font-size: 1rem; }
    .section-title { margin: 1rem 0 0.5rem 0; font-weight: 700; color: #2c3e50; font-size: 0.95rem; }
    .section-box { border: 1px solid #e1e5ea; background: #fff; border-radius: 8px; padding: 0.9rem 1rem; margin-top: 0.5rem; }
    .form-row { display: flex; flex-wrap: wrap; gap: 1rem; margin-bottom: 0.5rem; align-items: center; }
    .use-row { margin-top: 0.75rem; }
    .form-row label { width: 100px; flex-shrink: 0; }
    .form-row input, .form-row select { padding: 4px 8px; min-width: 140px; }
    .form-actions { margin-top: 0.75rem; display: flex; gap: 0.5rem; flex-wrap: wrap; }
    .msg { padding: 0.5rem; margin-bottom: 0.5rem; border-radius: 4px; background: #d4edda; color: #155724; }

    /* 계약자 관리 스타일(사진형) */
    .contract-grid-wrap { margin-top: 1rem; background: #fff; border-radius: 8px; padding: 1rem; border: 1px solid #dee2e6; overflow: auto; }
    .contract-grid-title-row { display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.75rem; gap: 0.5rem; flex-wrap: wrap; }
    .contract-grid-title { font-weight: 800; color: #2c3e50; }
    .contract-grid-title-actions { display: flex; gap: 0.5rem; }
    .contract-grid { border-collapse: collapse; width: 100%; min-width: 1200px; table-layout: fixed; }
    .contract-grid th, .contract-grid td { border: 1px solid #d0d5dd; padding: 6px 6px; text-align: center; font-size: 0.85rem; }
    .contract-grid th { background: #f2f4f7; color: #2c3e50; font-weight: 700; }
    .contract-grid td.left { text-align: left; padding-left: 10px; }
    .contract-grid .month-td { width: 38px; }
    .contract-grid input[type="checkbox"] { width: 16px; height: 16px; }
    .contract-grid .amount-input { width: 100%; min-width: 0; box-sizing: border-box; text-align: right; padding: 4px 6px; border: 1px solid #ccd6e2; border-radius: 4px; }
    .contract-grid .amount-input[readonly] { background: #f5f7fa; color: #555; }
    .contract-grid .item-cell { text-align: left; }
    .contract-grid .item-prefix { color: #34495e; margin-right: 4px; white-space: nowrap; }
    .contract-grid .item-input { width: 140px; min-width: 0; box-sizing: border-box; padding: 4px 6px; border: 1px solid #ccd6e2; border-radius: 4px; }
    .item-edit-wrap { display: inline-flex; align-items: center; gap: 4px; width: 100%; }
    .btn-item-add, .btn-item-remove {
      border: 1px solid #bfc9d6;
      background: #fff;
      color: #2c3e50;
      border-radius: 4px;
      width: 24px;
      height: 24px;
      line-height: 22px;
      text-align: center;
      cursor: pointer;
      font-weight: 700;
      padding: 0;
      flex-shrink: 0;
    }
    .btn-item-add:hover, .btn-item-remove:hover { background: #f4f6f9; }
    .contract-grid tbody tr { cursor: pointer; }
    .contract-grid tbody tr.row-selected { background: #cce5ff !important; }
    .contract-grid tbody tr:hover:not(.row-selected) { background: #f0f7ff; }

    /* 공급받는자 상단 도구 블록 */
    .recipient-tool-block { background: #f8f9fa; border: 1px solid #dee2e6; border-radius: 8px; padding: 1rem; margin-bottom: 1rem; }
    .recipient-tool-block .tool-row { display: flex; justify-content: space-between; align-items: center; gap: 0.75rem; flex-wrap: wrap; }
    .recipient-tool-block .tool-row + .tool-row { margin-top: 0.75rem; }
    .recipient-tool-block .tool-left { display: flex; align-items: center; gap: 0.5rem; }
    .recipient-tool-block .tool-right { display: flex; align-items: center; gap: 0.5rem; }
    .recipient-tool-block .search-input { padding: 6px 10px; border: 1px solid #bdc3c7; border-radius: 4px; width: 100%; max-width: 100%; box-sizing: border-box; }

    .corp-link { color: #1f5fbf; text-decoration: underline; cursor: pointer; font-weight: 600; }

    /* 전자세금계산서 모달 — 팔레트: 공급자 #FFF1F1, 공급받는자 #EDF2FF, 표헤더 #E6F7F5, 테두리 #CED4DA */
    .tax-modal-overlay {
      position: fixed; inset: 0; background: rgba(15, 23, 42, 0.45);
      display: none; align-items: center; justify-content: center; z-index: 2000;
      padding: 12px;
    }
    .tax-modal-overlay.open { display: flex; }
    .tax-modal {
      width: min(1160px, 98vw); max-height: 94vh; overflow: auto;
      background: #fff; border-radius: 6px; box-shadow: 0 8px 28px rgba(0,0,0,0.12);
      border: 1px solid #CED4DA;
    }
    .tax-modal-head {
      display: flex; justify-content: flex-end; align-items: center;
      padding: 8px 12px; border-radius: 5px 5px 0 0;
      background: #F8F9FA; border-bottom: 1px solid #CED4DA;
    }
    .tax-close-btn {
      border: 1px solid #CED4DA; background: #fff; border-radius: 4px;
      padding: 6px 16px; cursor: pointer; font-size: 13px; font-weight: 600; color: #111;
    }
    .tax-close-btn:hover { background: #F1F3F5; }
    .tax-sheet { padding: 14px 16px 18px 16px; font-size: 12px; color: #000; line-height: 1.4; }
    .tax-doc-head-wrap {
      position: relative; display: flex; align-items: center; justify-content: center;
      min-height: 40px; margin-bottom: 12px; padding: 0 4px;
    }
    .tax-doc-title-main {
      font-size: 22px; font-weight: 800; letter-spacing: -0.02em; color: #000;
      text-align: center;
    }
    .tax-doc-appr-wrap {
      position: absolute; right: 0; top: 50%; transform: translateY(-50%);
      display: flex; align-items: center; gap: 6px; flex-wrap: nowrap; justify-content: flex-end;
      max-width: 52%;
      padding: 6px 10px; border-radius: 4px;
      border: 1px solid #CED4DA; background: #F0F4FF;
      font-size: 12px; font-weight: 600; color: #000;
    }
    .tax-appr-label { font-weight: 700; white-space: nowrap; }
    .tax-appr-val { white-space: nowrap; overflow: hidden; text-overflow: ellipsis; font-family: ui-monospace, monospace; font-size: 11px; }
    .tax-party-row {
      display: flex; width: 100%; box-sizing: border-box;
      border-radius: 4px; overflow: hidden;
      border: 1px solid #CED4DA; background: #fff;
    }
    .tax-party { display: flex; flex: 1; min-width: 0; border-right: 1px solid #CED4DA; }
    .tax-party:last-child { border-right: none; }
    .tax-vlabel {
      width: 28px; min-width: 28px; flex-shrink: 0;
      display: flex; align-items: center; justify-content: center;
      writing-mode: vertical-rl; text-orientation: mixed; font-weight: 800; font-size: 13px;
      letter-spacing: 2px; border-right: 1px solid #CED4DA; color: #000;
    }
    .tax-vlabel-sup { background: #FFF1F1; }
    .tax-vlabel-buy { background: #EDF2FF; }
    .tax-party-inner { width: 100%; border-collapse: separate; border-spacing: 0; table-layout: fixed; }
    .tax-party-inner td {
      border: 1px solid #CED4DA; padding: 6px 7px; vertical-align: middle;
      white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
    }
    .tax-lbl-sup {
      background: #FFEDED; font-weight: 700; text-align: center; width: 18%; color: #000;
      border-color: #CED4DA !important;
    }
    .tax-lbl-buy {
      background: #F0F4FF; font-weight: 700; text-align: center; width: 18%; color: #000;
      border-color: #CED4DA !important;
    }
    .tax-val { text-align: left; background: #fff; color: #000; }
    .tax-addr { min-height: 2.2em; }
    .tax-table-wrap {
      margin-top: 8px; border-radius: 4px; overflow: hidden;
      border: 1px solid #CED4DA; background: #fff;
    }
    .tax-sum-table, .tax-item-table, .tax-pay-table { width: 100%; border-collapse: collapse; table-layout: fixed; margin: 0; }
    .tax-sum-table th, .tax-item-table th, .tax-pay-table th {
      background: #E8E8E8; font-weight: 700; text-align: center; border: 1px solid #CED4DA;
      padding: 7px 5px; font-size: 12px; color: #000;
      white-space: nowrap;
    }
    .tax-sum-table td, .tax-item-table td, .tax-pay-table td {
      border: 1px solid #CED4DA; padding: 6px 5px; vertical-align: middle; font-size: 12px;
      background: #fff; color: #000;
      white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
    }
    .tax-right { text-align: right; }
    .tax-center { text-align: center; }
    .tax-item-empty td { height: 22px; background: #fff; }
    .tax-claim-wrap {
      margin-top: 8px; border-radius: 4px; overflow: hidden;
      border: 1px solid #CED4DA;
    }
    .tax-claim-row td {
      border: none; padding: 8px 10px; font-weight: 700; text-align: center;
      background: #F8F9FA; font-size: 12px; color: #000;
    }
    .tax-note {
      margin-top: 10px; padding: 8px 10px; border-radius: 4px;
      background: #F8F9FA; border: 1px dashed #CED4DA; color: #333; line-height: 1.5; font-size: 11px;
    }
    @media (max-width: 720px) {
      .tax-doc-head-wrap { min-height: auto; padding-bottom: 8px; }
      .tax-doc-appr-wrap {
        position: static; transform: none; max-width: 100%; margin-top: 8px;
        justify-content: center;
      }
      .tax-party-row { flex-direction: column; border-radius: 4px; }
      .tax-party { border-right: none; border-bottom: 1px solid #CED4DA; }
      .tax-party:last-child { border-bottom: none; }
    }
  </style>
</head>
<body>
  <div class="hometax-wrap">
    <%@ include file="/WEB-INF/jsp/hometax/include/hometax_sidebar.jsp" %>
    <div class="hometax-main">
      <div class="page-title">공급받는자</div>
      <div class="content-box">
        <c:if test="${not empty message}"><div class="msg">${message}</div></c:if>

        <div class="recipient-tool-block">
          <div class="tool-row">
            <div class="tool-left">
              <button type="button" class="btn btn-line" id="btnGridIssue">세금계산서 발행</button>
            </div>
            <div class="tool-right">
              <button type="button" class="btn btn-primary" id="btnGridSave">저장</button>
            </div>
          </div>
          <div class="tool-row">
            <input type="text" id="recipientSearch" placeholder="검색" class="search-input" />
          </div>
        </div>

        <div class="form-box" id="editBox" style="display:none;">
          <h3 id="formTitle">공급받는자 등록</h3>
          <form action="${pageContext.request.contextPath}/bill/recipient/save.do" method="post" id="recipientForm">
            <input type="hidden" name="id" id="fid" value="" />
            <div class="form-row">
              <label>공급자</label>
              <select name="providerId" id="fproviderId">
                <option value="">선택</option>
                <c:forEach var="pr" items="${providerList}">
                  <option value="${pr.id}"
                    data-corpnum="<c:out value='${pr.corpNum}'/>"
                    data-corpname="<c:out value='${pr.corpName}'/>"
                    data-ceoname="<c:out value='${pr.ceoName}'/>"
                    data-biztype="<c:out value='${pr.bizType}'/>"
                    data-bizclass="<c:out value='${pr.bizClassification}'/>"
                    data-email="<c:out value='${pr.email}'/>"
                    data-address="<c:out value='${pr.address}'/>"
                    <c:if test="${not empty defaultProviderId and pr.id == defaultProviderId}">selected="selected"</c:if>>
                    <c:out value="${pr.corpName}"/> (<c:out value="${pr.corpNum}"/>)
                  </option>
                </c:forEach>
              </select>
              <label>구분</label>
              <select name="recipientType" id="frecipientType">
                <option value="01">사업자</option>
                <option value="02">개인(주민)</option>
              </select>
            </div>

            <div class="section-title">공급받는자 정보</div>
            <div class="section-box">
              <!-- 사업자 -->
              <div id="bizFields">
                <div class="form-row">
                  <label>사업자번호</label><input type="text" name="corpNum" id="fcorpNum" maxlength="20" placeholder="사업자번호" />
                  <label>종사업자번호</label><input type="text" name="taxNum" id="ftaxNum" maxlength="20" placeholder="종사업자번호" />
                </div>
                <div class="form-row">
                  <label>업태</label><input type="text" name="bizType" id="fbizType" maxlength="50" />
                  <label>업종</label><input type="text" name="bizClassification" id="fbizClassification" maxlength="50" />
                </div>
                <div class="form-row">
                  <label>상호</label><input type="text" name="corpName" id="fcorpName" maxlength="100" />
                  <label>대표자</label><input type="text" name="ceoName" id="fceoName" maxlength="50" />
                </div>
              </div>

              <!-- 개인(주민) -->
              <div id="personFields">
                <div class="form-row">
                  <label id="idNumLabel">주민등록번호</label><input type="text" name="idNum" id="fidNum" maxlength="30" />
                  <label>성명</label><input type="text" name="corpName_person" id="fpersonName" maxlength="100" />
                </div>
              </div>

              <div class="form-row">
                <label>주소</label><input type="text" name="address" id="faddress" maxlength="200" style="min-width: 280px;" />
              </div>
              <div class="form-row">
                <label>이메일</label><input type="text" name="email" id="femail" maxlength="100" />
              </div>
            </div>

            <div class="section-title">발행담당자 정보</div>
            <div class="section-box">
              <div class="form-row">
                <label>담당자(부서)</label><input type="text" name="contactName" id="fcontactName" maxlength="50" />
                <label>연락처</label><input type="text" name="contactPhone" id="fcontactPhone" maxlength="30" />
                <label>이메일</label><input type="text" name="contactEmail" id="fcontactEmail" maxlength="100" />
              </div>
            </div>

            <div class="form-row use-row">
              <label>사용</label>
              <select name="useYn" id="fuseYn">
                <option value="Y">Y</option>
                <option value="N">N</option>
              </select>
            </div>
            <div class="form-actions">
              <button type="submit" class="btn btn-primary">저장</button>
              <button type="button" class="btn btn-line" id="btnCancel">닫기</button>
            </div>
          </form>
        </div>
        <div class="contract-grid-wrap">
          <div class="contract-grid-title-row">
            <div class="contract-grid-title">공급받는자 - ${gridYear}년</div>
            <div class="contract-grid-title-actions">
              <button type="button" class="btn btn-line" id="btnAllSelect">전체 선택</button>
              <button type="button" class="btn btn-line" id="btnAllUnselect">선택 해제</button>
            </div>
          </div>
          <table class="contract-grid">
            <thead>
              <tr>
                <th style="width:58px;">선택 <input type="checkbox" id="chkAllRows" title="전체 선택" /></th>
                <th style="width:60px;">No</th>
                <th style="width:260px;">상호명</th>
                <th style="width:220px;">품목</th>
                <th style="width:110px;">공급가액</th>
                <th style="width:90px;">세액</th>
                <th style="width:110px;">합계</th>
                <c:forEach var="m" begin="1" end="12">
                  <th class="month-td">${m}월</th>
                </c:forEach>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${empty gridRows}">
                  <tr><td colspan="${1 + 6 + 12}" style="text-align:center;">표시할 공급받는자가 없습니다.</td></tr>
                </c:when>
                <c:otherwise>
                  <c:forEach var="row" items="${gridRows}">
                    <tr class="grid-row"
                        data-contractid="${row.contractId}"
                        data-powerplantid="${row.providerId}"
                        data-recipientid="${row.recipientId}"
                        data-itemno="${row.itemNo}"
                        data-powerplantname="<c:out value='${row.powerPlantName}'/>"
                        data-recipienttype="<c:out value='${row.recipientType}'/>"
                        data-corpname="<c:out value='${row.corpName}'/>"
                        data-idvalue="<c:out value='${row.idValue}'/>"
                        data-taxnum="<c:out value='${row.taxNum}'/>"
                        data-biztype="<c:out value='${row.bizType}'/>"
                        data-bizclass="<c:out value='${row.bizClassification}'/>"
                        data-ceoname="<c:out value='${row.ceoName}'/>"
                        data-contactname="<c:out value='${row.contactName}'/>"
                        data-contactphone="<c:out value='${row.contactPhone}'/>"
                        data-contactemail="<c:out value='${row.contactEmail}'/>"
                        data-address="<c:out value='${row.address}'/>"
                        data-email="<c:out value='${row.email}'/>"
                        data-approvalno="<c:out value='${row.approvalNo}'/>">
                      <td class="td-row-chk" onclick="event.stopPropagation();"><input type="checkbox" class="rowChk" /></td>
                      <td>${row.no}</td>
                      <td class="left"><a href="#" class="corp-link btn-tax-preview"><c:out value="${row.powerPlantName}"/></a></td>
                      <td class="item-cell">
                        <div class="item-edit-wrap">
                          <span class="item-prefix"></span>
                          <input type="text" class="item-input" value="${row.itemName}" />
                          <button type="button" class="btn-item-add" title="같은 상호 품목추가">+</button>
                          <button type="button" class="btn-item-remove" title="품목행 삭제">-</button>
                        </div>
                      </td>
                      <td><input type="text" class="amount-input supply-input" value="${row.supplyTotal}" /></td>
                      <td><input type="text" class="amount-input tax-input" value="${row.taxTotal}" readonly="readonly" /></td>
                      <td><input type="text" class="amount-input grand-input" value="${row.grandTotal}" readonly="readonly" /></td>
                      <c:forEach var="m" begin="1" end="12">
                        <td class="month-td">
                          <c:if test="${row.sentMonths.contains(m)}">
                            <input
                              type="checkbox"
                              checked="checked"
                              disabled="disabled"
                              class="monthChk"
                              data-powerplantid="${row.providerId}"
                              data-recipientid="${row.recipientId}"
                              data-month="${m}"
                            />
                          </c:if>
                          <c:if test="${!row.sentMonths.contains(m)}">
                            <input
                              type="checkbox"
                              disabled="disabled"
                              class="monthChk"
                              data-powerplantid="${row.providerId}"
                              data-recipientid="${row.recipientId}"
                              data-month="${m}"
                            />
                          </c:if>
                        </td>
                      </c:forEach>
                    </tr>
                  </c:forEach>
                </c:otherwise>
              </c:choose>
            </tbody>
          </table>
        </div>

        <table style="display:none;">
          <thead>
            <tr>
              <th>구분</th><th>사업자/번호</th><th>상호(성명)</th><th>담당자</th><th>연락처</th><th>사용</th><th></th>
            </tr>
          </thead>
          <tbody>
            <c:choose>
              <c:when test="${empty recipientList}">
                <tr><td colspan="7" style="text-align:center;">등록된 공급받는자가 없습니다.</td></tr>
              </c:when>
              <c:otherwise>
                <c:forEach var="r" items="${recipientList}">
                  <tr>
                    <td>
                      <c:choose>
                        <c:when test="${r.recipientType == '01'}">사업자</c:when>
                        <c:when test="${r.recipientType == '02'}">개인</c:when>
                        <c:otherwise><c:out value="${r.recipientType}"/></c:otherwise>
                      </c:choose>
                    </td>
                    <td><c:out value="${r.corpNum}"/><c:if test="${not empty r.taxNum}"> / <c:out value="${r.taxNum}"/></c:if><c:if test="${not empty r.idNum}"> / <c:out value="${r.idNum}"/></c:if></td>
                    <td><c:out value="${r.corpName}"/></td>
                    <td><c:out value="${r.contactName}"/></td>
                    <td><c:out value="${r.contactPhone}"/></td>
                    <td>
                      <c:choose>
                        <c:when test="${r.useYn == 'Y'}"><span class="badge badge-y">Y</span></c:when>
                        <c:otherwise><span class="badge badge-n">N</span></c:otherwise>
                      </c:choose>
                    </td>
                    <td>
                      <a href="#" class="btn btn-primary btn-small btn-edit" data-id="${r.id}" data-providerid="${r.providerId}" data-type="${r.recipientType}" data-corpnum="${r.corpNum}" data-taxnum="${r.taxNum}" data-idnum="${r.idNum}" data-biztype="${r.bizType}" data-bizclass="${r.bizClassification}" data-corpname="${r.corpName}" data-ceoname="${r.ceoName}" data-contact="${r.contactName}" data-phone="${r.contactPhone}" data-contactemail="${r.contactEmail}" data-email="${r.email}" data-addr="${r.address}" data-useyn="${r.useYn}">수정</a>
                      <a href="${pageContext.request.contextPath}/bill/recipient/delete.do?id=${r.id}" class="btn btn-primary btn-small" onclick="return confirm('삭제할까요?');">삭제</a>
                    </td>
                  </tr>
                </c:forEach>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>
      </div>
    </div>
  </div>

  <div id="taxModalOverlay" class="tax-modal-overlay" aria-hidden="true">
    <div class="tax-modal" role="dialog" aria-modal="true" aria-label="전자세금계산서">
      <div class="tax-modal-head">
        <button type="button" class="tax-close-btn" id="btnTaxModalClose">닫기</button>
      </div>
      <div class="tax-sheet">
        <div class="tax-doc-head-wrap">
          <div class="tax-doc-title-main">전자세금계산서</div>
          <div class="tax-doc-appr-wrap">
            <span class="tax-appr-label">승인번호</span>
            <span id="mApprovalNo" class="tax-appr-val">-</span>
          </div>
        </div>

        <div class="tax-party-row">
          <div class="tax-party tax-party-sup">
            <div class="tax-vlabel tax-vlabel-sup">공급자</div>
            <table class="tax-party-inner">
              <colgroup><col /><col /><col /><col /></colgroup>
              <tr>
                <td class="tax-lbl-sup">등록번호</td>
                <td class="tax-val" id="mSupplierNo">-</td>
                <td class="tax-lbl-sup">종사업장번호</td>
                <td class="tax-val" id="mSupplierBranch">-</td>
              </tr>
              <tr>
                <td class="tax-lbl-sup">상호</td>
                <td class="tax-val" id="mSupplierCorp">-</td>
                <td class="tax-lbl-sup">성명</td>
                <td class="tax-val" id="mSupplierCeo">-</td>
              </tr>
              <tr>
                <td class="tax-lbl-sup">사업장</td>
                <td class="tax-val tax-addr" colspan="3" id="mSupplierAddr">-</td>
              </tr>
              <tr>
                <td class="tax-lbl-sup">업태</td>
                <td class="tax-val" id="mSupplierBizType">-</td>
                <td class="tax-lbl-sup">종목</td>
                <td class="tax-val" id="mSupplierBizKind">-</td>
              </tr>
              <tr>
                <td class="tax-lbl-sup">이메일</td>
                <td class="tax-val" colspan="3" id="mSupplierEmail">-</td>
              </tr>
            </table>
          </div>
          <div class="tax-party tax-party-buy">
            <div class="tax-vlabel tax-vlabel-buy">공급받는자</div>
            <table class="tax-party-inner">
              <colgroup><col /><col /><col /><col /></colgroup>
              <tr>
                <td class="tax-lbl-buy">등록번호</td>
                <td class="tax-val" id="mRecipientNo">-</td>
                <td class="tax-lbl-buy">종사업장번호</td>
                <td class="tax-val" id="mRecipientBranch">-</td>
              </tr>
              <tr>
                <td class="tax-lbl-buy">상호</td>
                <td class="tax-val" id="mRecipientCorp">-</td>
                <td class="tax-lbl-buy">성명</td>
                <td class="tax-val" id="mRecipientCeo">-</td>
              </tr>
              <tr>
                <td class="tax-lbl-buy">사업장</td>
                <td class="tax-val tax-addr" colspan="3" id="mRecipientAddr">-</td>
              </tr>
              <tr>
                <td class="tax-lbl-buy">업태</td>
                <td class="tax-val" id="mRecipientBizType">-</td>
                <td class="tax-lbl-buy">종목</td>
                <td class="tax-val" id="mRecipientBizKind">-</td>
              </tr>
              <tr>
                <td class="tax-lbl-buy">이메일</td>
                <td class="tax-val" colspan="3" id="mRecipientEmail">-</td>
              </tr>
            </table>
          </div>
        </div>

        <div class="tax-table-wrap">
        <table class="tax-sum-table">
          <tr>
            <th style="width:14%;">작성일자</th>
            <th style="width:18%;">공급가액</th>
            <th style="width:14%;">세액</th>
            <th style="width:18%;">수정사유</th>
            <th>비고</th>
          </tr>
          <tr>
            <td class="tax-center" id="mIssueDate">-</td>
            <td class="tax-right" id="mSupplyTotal">0</td>
            <td class="tax-right" id="mTaxTotal">0</td>
            <td class="tax-center">해당없음</td>
            <td></td>
          </tr>
        </table>
        </div>

        <div class="tax-table-wrap">
        <table class="tax-item-table">
          <colgroup>
            <col style="width:5%;" /><col style="width:5%;" /><col /><col style="width:8%;" />
            <col style="width:5%;" /><col style="width:8%;" /><col style="width:10%;" /><col style="width:8%;" /><col />
          </colgroup>
          <tr>
            <th>월</th><th>일</th><th>품목</th><th>규격</th><th>수량</th><th>단가</th>
            <th>공급가액</th><th>세액</th><th>비고</th>
          </tr>
          <tbody id="mItemRows"></tbody>
        </table>

        <table class="tax-pay-table">
          <tr>
            <th style="width:20%;">합계금액</th>
            <th style="width:16%;">현금</th>
            <th style="width:16%;">수표</th>
            <th style="width:16%;">어음</th>
            <th>외상미수금</th>
          </tr>
          <tr>
            <td class="tax-right" id="mGrandTotal">0</td>
            <td></td><td></td><td></td>
            <td class="tax-center">(청구)</td>
          </tr>
        </table>
        </div>

        <div class="tax-claim-wrap">
          <table class="tax-sum-table">
            <tr class="tax-claim-row">
              <td colspan="5">이 금액을 (청구) 함</td>
            </tr>
          </table>
        </div>

        <div class="tax-note">
          본 미리보기는 입력된 데이터 기반 화면입니다. 승인번호는 전자세금계산서 발행·전송 완료 후 DB에 저장된 국세청 승인번호가 있으면 그대로 표시됩니다.
        </div>
      </div>
    </div>
  </div>

  <script>
    (function(){
      var fid = document.getElementById('fid');
      var formTitle = document.getElementById('formTitle');
      var editBox = document.getElementById('editBox');
      var btnAdd = document.getElementById('btnAdd');
      var btnCancel = document.getElementById('btnCancel');

      var typeSel = document.getElementById('frecipientType');
      var bizWrap = document.getElementById('bizFields');
      var personWrap = document.getElementById('personFields');
      var idNumLabel = document.getElementById('idNumLabel');

      var fcorpNum = document.getElementById('fcorpNum');
      var ftaxNum = document.getElementById('ftaxNum');
      var fbizType = document.getElementById('fbizType');
      var fbizClassification = document.getElementById('fbizClassification');
      var fcorpName = document.getElementById('fcorpName');
      var fceoName = document.getElementById('fceoName');
      var fidNum = document.getElementById('fidNum');
      var fpersonName = document.getElementById('fpersonName');
      var faddress = document.getElementById('faddress');
      var femail = document.getElementById('femail');
      var fcontactEmail = document.getElementById('fcontactEmail');
      var fcontactName = document.getElementById('fcontactName');
      var fcontactPhone = document.getElementById('fcontactPhone');

      var defaults = {
        department: '<c:out value="${loginUserDepartment}"/>',
        phone: '<c:out value="${loginUserPhone}"/>',
        email: '<c:out value="${loginUserEmail}"/>'
      };

      function setDisabled(el, disabled) {
        if (!el) return;
        el.disabled = !!disabled;
        if (disabled) el.value = '';
      }

      function applyTypeUI(recipientType) {
        var isBiz = recipientType === '01';
        bizWrap.style.display = isBiz ? '' : 'none';
        personWrap.style.display = isBiz ? 'none' : '';

        // 사업자 필드 enable/disable
        setDisabled(fcorpNum, !isBiz);
        setDisabled(ftaxNum, !isBiz);
        setDisabled(fbizType, !isBiz);
        setDisabled(fbizClassification, !isBiz);
        // 개인(주민) 모드에서도 성명(corp_name)에 값이 서버로 넘어가야 하므로 disable 하지 않습니다.
        setDisabled(fcorpName, false);
        setDisabled(fceoName, !isBiz);

        // 개인 필드 enable/disable
        setDisabled(fidNum, isBiz);
        setDisabled(fpersonName, isBiz);

        // 라벨 (외국인 제거)
        idNumLabel.textContent = '주민등록번호';

        // 개인 모드일 때는 성명만 실제 저장 필드로 복사 (주소/이메일은 공급받는자 정보에 고정)
        if (!isBiz) {
          fcorpName.value = fpersonName.value || fcorpName.value || '';
        }
      }

      function setForm(o){
        fid.value = o.id || '';
        document.getElementById('fproviderId').value = o.providerId || '';
        typeSel.value = o.type || '01';
        fcorpNum.value = o.corpNum || '';
        ftaxNum.value = o.taxNum || '';
        fidNum.value = o.idNum || '';
        fbizType.value = o.bizType || '';
        fbizClassification.value = o.bizClass || '';
        fcorpName.value = o.corpName || '';
        fceoName.value = o.ceoName || '';
        fcontactName.value = o.contact || '';
        fcontactPhone.value = o.phone || '';
        fcontactEmail.value = o.contactEmail || '';
        femail.value = o.email || '';
        faddress.value = o.addr || '';

        // 개인 UI용 필드 채우기 (기존 저장 필드에서 복사)
        fpersonName.value = fcorpName.value || '';

        applyTypeUI(typeSel.value);
        document.getElementById('fuseYn').value = o.useYn || 'Y';
        if (o.id) { formTitle.textContent = '공급받는자 수정'; btnCancel.style.display = 'inline-block'; }
        else {
          formTitle.textContent = '공급받는자 등록';
          // 신규 등록일 때 발행담당자 기본값 자동 채움
          if (!fcontactName.value && defaults.department) fcontactName.value = defaults.department;
          if (!fcontactPhone.value && defaults.phone) fcontactPhone.value = defaults.phone;
          if (!fcontactEmail.value && defaults.email) fcontactEmail.value = defaults.email;
        }
      }

      typeSel.addEventListener('change', function(){ applyTypeUI(this.value); });
      document.getElementById('recipientForm').addEventListener('submit', function(){
        // 개인이면 개인 입력값을 실제 저장 필드로 복사
        if (typeSel.value !== '01') {
          fcorpName.value = fpersonName.value || '';
        }
      });

      document.querySelectorAll('.btn-edit').forEach(function(btn){
        btn.addEventListener('click', function(e){
          e.preventDefault();
          editBox.style.display = '';
          setForm({
            id: this.getAttribute('data-id'),
            providerId: this.getAttribute('data-providerid'),
            type: this.getAttribute('data-type'),
            corpNum: this.getAttribute('data-corpnum'),
            taxNum: this.getAttribute('data-taxnum'),
            idNum: this.getAttribute('data-idnum'),
            bizType: this.getAttribute('data-biztype'),
            bizClass: this.getAttribute('data-bizclass'),
            corpName: this.getAttribute('data-corpname'),
            ceoName: this.getAttribute('data-ceoname'),
            contact: this.getAttribute('data-contact'),
            phone: this.getAttribute('data-phone'),
            contactEmail: this.getAttribute('data-contactemail'),
            email: this.getAttribute('data-email'),
            addr: this.getAttribute('data-addr'),
            useYn: this.getAttribute('data-useyn') || 'Y'
          });
        });
      });
      if (btnAdd) {
        btnAdd.addEventListener('click', function(){
          editBox.style.display = '';
          setForm({});
          window.scrollTo({ top: 0, behavior: 'smooth' });
        });
      }
      btnCancel.addEventListener('click', function(){
        editBox.style.display = 'none';
        setForm({});
      });
      // 초기화: 기본은 사업자
      applyTypeUI(typeSel.value || '01');

      // URL 파라미터로 공급받는자 추가 폼을 자동 오픈
      try {
        var params = new URLSearchParams(window.location.search);
        var openAdd = params.get('openAdd');
        if (openAdd === '1') {
          editBox.style.display = '';
          setForm({});
          window.scrollTo({ top: 0, behavior: 'smooth' });
        }
      } catch (e) {
        // ignore
      }

      // 그리드 체크박스: 전체 선택/해제 + 저장/발행 버튼(현재는 UI 동작)
      var btnGridSave = document.getElementById('btnGridSave');
      var btnGridIssue = document.getElementById('btnGridIssue');
      var btnAllSelect = document.getElementById('btnAllSelect');
      var btnAllUnselect = document.getElementById('btnAllUnselect');
      var chkAllRows = document.getElementById('chkAllRows');
      var contractGridBody = document.querySelector('.contract-grid tbody');
      var taxModalOverlay = document.getElementById('taxModalOverlay');
      var btnTaxModalClose = document.getElementById('btnTaxModalClose');

      function text(elId, value) {
        var el = document.getElementById(elId);
        if (!el) return;
        el.textContent = value != null && String(value).trim() !== '' ? String(value) : '-';
      }
      function textAllowBlank(elId, value) {
        var el = document.getElementById(elId);
        if (!el) return;
        el.textContent = value != null ? String(value) : '';
      }
      /** data-* 는 dataset 대신 getAttribute로 읽음 (data-biztype 등 dataset 매핑 누락 방지) */
      function trAttr(tr, attrName) {
        if (!tr || !attrName) return '';
        var v = tr.getAttribute(attrName);
        return v == null ? '' : String(v);
      }
      function numberText(elId, value) {
        var el = document.getElementById(elId);
        if (!el) return;
        var n = parseFloat(String(value || '').replace(/,/g, '').trim());
        if (isNaN(n)) n = 0;
        el.textContent = n.toLocaleString('ko-KR');
      }
      function toNumber(v) {
        var n = parseFloat(String(v || '').replace(/,/g, '').trim());
        return isNaN(n) ? 0 : n;
      }
      function normalizeIdValue(v) {
        return String(v || '').replace(/[^0-9A-Za-z]/g, '').toUpperCase();
      }
      function getRecipientMergeKey(tr) {
        if (!tr) return '';
        var type = trAttr(tr, 'data-recipienttype') || '';
        var idValue = normalizeIdValue(trAttr(tr, 'data-idvalue'));
        // 합치기 기준:
        // - 사업자(01): 동일 사업자번호
        // - 개인(02): 동일 주민등록번호
        if ((type === '01' || type === '02') && idValue) return type + ':' + idValue;
        // 식별값이 비어있으면 recipientId fallback
        return type + ':RID:' + (trAttr(tr, 'data-recipientid') || '');
      }
      function formatNumberText(v) {
        return toNumber(v).toLocaleString('ko-KR');
      }
      function getGroupRowsForPreview(baseTr) {
        if (!baseTr) return [];
        var mergeKey = getRecipientMergeKey(baseTr);
        return Array.prototype.slice.call(document.querySelectorAll('.contract-grid tbody tr.grid-row')).filter(function(tr){
          return getRecipientMergeKey(tr) === mergeKey;
        }).sort(function(a, b){
          var an = parseInt(trAttr(a, 'data-itemno') || '0', 10);
          var bn = parseInt(trAttr(b, 'data-itemno') || '0', 10);
          if (isNaN(an)) an = 0;
          if (isNaN(bn)) bn = 0;
          return an - bn;
        });
      }
      function renderPreviewItemRows(groupRows, issueDate) {
        var body = document.getElementById('mItemRows');
        if (!body) return { supply: 0, tax: 0, grand: 0 };
        var parts = String(issueDate || '').split('-');
        var mm = parts.length >= 2 ? parts[1] : '-';
        var dd = parts.length >= 3 ? parts[2] : '-';
        var html = [];
        var supplySum = 0;
        var taxSum = 0;
        var grandSum = 0;

        groupRows.forEach(function(tr){
          var itemInput = tr.querySelector('.item-input');
          var prefixEl = tr.querySelector('.item-prefix');
          var prefix = prefixEl ? String(prefixEl.textContent || '').trim() : '';
          var itemPart = itemInput ? String(itemInput.value || '').trim() : '';
          var fullItem = (prefix + itemPart).trim() || '-';
          var supplyInput = tr.querySelector('.supply-input');
          var taxInput = tr.querySelector('.tax-input');
          var grandInput = tr.querySelector('.grand-input');
          var s = toNumber(supplyInput ? supplyInput.value : 0);
          var t = toNumber(taxInput ? taxInput.value : 0);
          var g = toNumber(grandInput ? grandInput.value : 0);
          supplySum += s;
          taxSum += t;
          grandSum += g;
          html.push(
            '<tr>' +
              '<td class="tax-center">' + mm + '</td>' +
              '<td class="tax-center">' + dd + '</td>' +
              '<td>' + fullItem.replace(/</g, '&lt;').replace(/>/g, '&gt;') + '</td>' +
              '<td></td><td></td><td></td>' +
              '<td class="tax-right">' + formatNumberText(s) + '</td>' +
              '<td class="tax-right">' + formatNumberText(t) + '</td>' +
              '<td></td>' +
            '</tr>'
          );
        });

        var minRows = 5;
        for (var i = html.length; i < minRows; i++) {
          html.push('<tr class="tax-item-empty"><td colspan="9">&nbsp;</td></tr>');
        }
        body.innerHTML = html.join('');
        return { supply: supplySum, tax: taxSum, grand: grandSum };
      }
      function getSelectedProvider() {
        var providerSel = document.getElementById('fproviderId');
        if (!providerSel) return null;
        var opt = providerSel.options[providerSel.selectedIndex];
        if (!opt || !opt.value) return null;
        return {
          num: opt.getAttribute('data-corpnum') || '-',
          corp: opt.getAttribute('data-corpname') || '-',
          ceo: opt.getAttribute('data-ceoname') || '-',
          bizType: opt.getAttribute('data-biztype') || '-',
          bizKind: opt.getAttribute('data-bizclass') || '-',
          email: opt.getAttribute('data-email') || '-',
          addr: opt.getAttribute('data-address') || '-'
        };
      }
      function openTaxPreview(tr) {
        if (!tr) return;
        var now = new Date();
        var issueDate = now.getFullYear() + '-' + String(now.getMonth() + 1).padStart(2, '0') + '-' + String(now.getDate()).padStart(2, '0');
        var supplier = getSelectedProvider();
        if (!supplier) {
          supplier = { num: '-', corp: '-', ceo: '-', bizType: '-', bizKind: '-', email: '-', addr: '-' };
        }
        var groupRows = getGroupRowsForPreview(tr);
        if (!groupRows.length) groupRows = [tr];
        var rt = trAttr(tr, 'data-recipienttype');
        var recCeo = (rt === '01') ? (trAttr(tr, 'data-ceoname') || '-') : (trAttr(tr, 'data-corpname') || '-');

        var appr = trAttr(tr, 'data-approvalno');
        if (appr && String(appr).trim()) {
          text('mApprovalNo', String(appr).trim());
        } else {
          text('mApprovalNo', '-');
        }
        text('mSupplierNo', supplier.num);
        text('mSupplierBranch', '-');
        text('mSupplierCorp', supplier.corp);
        text('mSupplierCeo', supplier.ceo);
        text('mSupplierAddr', supplier.addr);
        text('mSupplierBizType', supplier.bizType);
        text('mSupplierBizKind', supplier.bizKind);
        text('mSupplierEmail', supplier.email);

        text('mRecipientNo', trAttr(tr, 'data-idvalue') || '-');
        text('mRecipientBranch', trAttr(tr, 'data-taxnum') || '-');
        if (rt === '01') {
          text('mRecipientCorp', trAttr(tr, 'data-corpname') || '-');
        } else {
          // 개인은 전자세금계산서 상호 칸을 비움
          textAllowBlank('mRecipientCorp', '');
        }
        text('mRecipientCeo', recCeo);
        text('mRecipientAddr', trAttr(tr, 'data-address') || '-');
        text('mRecipientBizType', trAttr(tr, 'data-biztype') || '-');
        text('mRecipientBizKind', trAttr(tr, 'data-bizclass') || '-');
        text('mRecipientEmail', trAttr(tr, 'data-email') || trAttr(tr, 'data-contactemail') || '-');

        text('mIssueDate', issueDate);
        var totals = renderPreviewItemRows(groupRows, issueDate);
        numberText('mSupplyTotal', totals.supply);
        numberText('mTaxTotal', totals.tax);
        numberText('mGrandTotal', totals.grand);

        taxModalOverlay.classList.add('open');
        taxModalOverlay.setAttribute('aria-hidden', 'false');
      }
      function closeTaxPreview() {
        taxModalOverlay.classList.remove('open');
        taxModalOverlay.setAttribute('aria-hidden', 'true');
      }

      if (btnTaxModalClose) btnTaxModalClose.addEventListener('click', closeTaxPreview);
      if (taxModalOverlay) {
        taxModalOverlay.addEventListener('click', function(e){
          if (e.target === taxModalOverlay) closeTaxPreview();
        });
      }
      document.addEventListener('keydown', function(e){
        if (e.key === 'Escape' && taxModalOverlay && taxModalOverlay.classList.contains('open')) {
          closeTaxPreview();
        }
      });

      function getRowCheckboxes() {
        return Array.prototype.slice.call(document.querySelectorAll('.rowChk'));
      }
      function refreshGridNo() {
        var no = 1;
        document.querySelectorAll('.contract-grid tbody tr.grid-row').forEach(function(tr){
          var tdNo = tr.children && tr.children.length > 1 ? tr.children[1] : null;
          if (tdNo) tdNo.textContent = no++;
        });
      }
      function getItemPrefixText() {
        var now = new Date();
        var yy = String(now.getFullYear()).slice(-2);
        var mm = String(now.getMonth() + 1).padStart(2, '0');
        return yy + '.' + mm + '월';
      }
      function setItemPrefixForRow(tr) {
        if (!tr) return;
        var el = tr.querySelector('.item-prefix');
        if (el) el.textContent = getItemPrefixText();
      }
      function getGroupRows(baseTr) {
        var mergeKey = getRecipientMergeKey(baseTr);
        return Array.prototype.slice.call(document.querySelectorAll('.contract-grid tbody tr.grid-row')).filter(function(tr){
          return getRecipientMergeKey(tr) === mergeKey;
        });
      }
      function addItemRowFor(baseTr) {
        if (!baseTr || !contractGridBody) return;
        var sameRows = getGroupRows(baseTr);
        var maxItemNo = 0;
        sameRows.forEach(function(tr){
          var n = parseInt(trAttr(tr, 'data-itemno') || '0', 10);
          if (!isNaN(n) && n > maxItemNo) maxItemNo = n;
        });
        var nextItemNo = maxItemNo + 1;
        var clone = baseTr.cloneNode(true);
        clone.setAttribute('data-contractid', '');
        clone.setAttribute('data-itemno', String(nextItemNo));
        clone.querySelectorAll('.monthChk').forEach(function(m){ m.checked = false; });
        var cb = clone.querySelector('.rowChk');
        if (cb) cb.checked = true;
        clone.classList.add('row-selected');
        var itemInput = clone.querySelector('.item-input');
        if (itemInput) itemInput.value = '';
        var supplyEl = clone.querySelector('.supply-input');
        var taxEl = clone.querySelector('.tax-input');
        var grandEl = clone.querySelector('.grand-input');
        if (supplyEl) supplyEl.value = '0';
        if (taxEl) taxEl.value = '0';
        if (grandEl) grandEl.value = '0';
        var ref = sameRows[sameRows.length - 1];
        if (ref && ref.nextSibling) contractGridBody.insertBefore(clone, ref.nextSibling);
        else contractGridBody.appendChild(clone);
        bindGridRow(clone);
        refreshGridNo();
      }
      function removeItemRowFor(baseTr) {
        if (!baseTr) return;
        var sameRows = getGroupRows(baseTr);
        if (sameRows.length <= 1) {
          var itemInput = baseTr.querySelector('.item-input');
          var supplyEl = baseTr.querySelector('.supply-input');
          var taxEl = baseTr.querySelector('.tax-input');
          var grandEl = baseTr.querySelector('.grand-input');
          if (itemInput) itemInput.value = '';
          if (supplyEl) supplyEl.value = '0';
          if (taxEl) taxEl.value = '0';
          if (grandEl) grandEl.value = '0';
          recalcRow(baseTr);
          return;
        }
        baseTr.remove();
        refreshGridNo();
      }
      function bindGridRow(tr) {
        if (!tr) return;
        var rowCb = tr.querySelector('.rowChk');
        if (rowCb && !rowCb.getAttribute('data-bound')) {
          rowCb.setAttribute('data-bound', '1');
          rowCb.addEventListener('change', function(){
            tr.classList.toggle('row-selected', this.checked);
            if (chkAllRows) {
              var all = getRowCheckboxes();
              chkAllRows.checked = all.length > 0 && all.every(function(x){ return x.checked; });
            }
          });
        }
        if (!tr.getAttribute('data-click-bound')) {
          tr.setAttribute('data-click-bound', '1');
          tr.addEventListener('click', function(e){
            if (e.target.closest('.btn-tax-preview')) {
              e.preventDefault();
              e.stopPropagation();
              openTaxPreview(tr);
              return;
            }
            if (e.target.type === 'checkbox' || e.target.closest('.td-row-chk') || e.target.classList.contains('amount-input') || e.target.classList.contains('item-input')) return;
            var cb = tr.querySelector('.rowChk');
            if (cb) {
              cb.checked = !cb.checked;
              tr.classList.toggle('row-selected', cb.checked);
              if (chkAllRows) {
                var all = getRowCheckboxes();
                chkAllRows.checked = all.length > 0 && all.every(function(x){ return x.checked; });
              }
            }
          });
        }
        var supplyEl = tr.querySelector('.supply-input');
        if (supplyEl && !supplyEl.getAttribute('data-bound')) {
          supplyEl.setAttribute('data-bound', '1');
          recalcRow(tr);
          supplyEl.addEventListener('input', function(){ recalcRow(tr); });
          supplyEl.addEventListener('blur', function(){ supplyEl.value = formatAmount(supplyEl.value); recalcRow(tr); });
        }
        var addBtn = tr.querySelector('.btn-item-add');
        if (addBtn && !addBtn.getAttribute('data-bound')) {
          addBtn.setAttribute('data-bound', '1');
          addBtn.addEventListener('click', function(e){
            e.preventDefault();
            e.stopPropagation();
            addItemRowFor(tr);
          });
        }
        var removeBtn = tr.querySelector('.btn-item-remove');
        if (removeBtn && !removeBtn.getAttribute('data-bound')) {
          removeBtn.setAttribute('data-bound', '1');
          removeBtn.addEventListener('click', function(e){
            e.preventDefault();
            e.stopPropagation();
            removeItemRowFor(tr);
          });
        }
        setItemPrefixForRow(tr);
      }

      function setAllRows(checked) {
        getRowCheckboxes().forEach(function(cb){
          cb.checked = !!checked;
          var tr = cb.closest('tr');
          if (tr) tr.classList.toggle('row-selected', !!checked);
        });
        if (chkAllRows) chkAllRows.checked = !!checked;
      }

      if (btnAllSelect) {
        btnAllSelect.addEventListener('click', function(){
          setAllRows(true);
        });
      }
      if (btnAllUnselect) {
        btnAllUnselect.addEventListener('click', function(){
          setAllRows(false);
        });
      }

      function collectSelectedTargets() {
        var selected = [];
        document.querySelectorAll('.contract-grid tbody tr.grid-row').forEach(function(tr){
          var rowCb = tr.querySelector('.rowChk');
          if (!rowCb || !rowCb.checked) return;
          var supply = tr.querySelector('.supply-input');
          var tax = tr.querySelector('.tax-input');
          var grand = tr.querySelector('.grand-input');
          selected.push({
            powerPlantId: trAttr(tr, 'data-powerplantid'),
            recipientId: trAttr(tr, 'data-recipientid'),
            itemNo: trAttr(tr, 'data-itemno'),
            itemName: (tr.querySelector('.item-input') ? tr.querySelector('.item-input').value : ''),
            supplyTotal: supply ? supply.value : '0',
            taxTotal: tax ? tax.value : '0',
            grandTotal: grand ? grand.value : '0'
          });
        });
        return selected;
      }

      function collectAllTargets() {
        var rows = [];
        document.querySelectorAll('.contract-grid tbody tr.grid-row').forEach(function(tr){
          var supply = tr.querySelector('.supply-input');
          var tax = tr.querySelector('.tax-input');
          var grand = tr.querySelector('.grand-input');
          rows.push({
            powerPlantId: trAttr(tr, 'data-powerplantid'),
            recipientId: trAttr(tr, 'data-recipientid'),
            itemNo: trAttr(tr, 'data-itemno'),
            itemName: (tr.querySelector('.item-input') ? tr.querySelector('.item-input').value : ''),
            supplyTotal: supply ? supply.value : '0',
            taxTotal: tax ? tax.value : '0',
            grandTotal: grand ? grand.value : '0'
          });
        });
        return rows;
      }

      if (btnGridSave) {
        btnGridSave.addEventListener('click', function(){
          var rows = collectAllTargets();
          if (!rows || rows.length === 0) {
            alert('저장할 행이 없습니다.');
            return;
          }
          var xhr = new XMLHttpRequest();
          xhr.open('POST', '${pageContext.request.contextPath}/bill/recipient/gridSave.do');
          xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8');
          xhr.onload = function(){
            if (xhr.status !== 200) {
              alert('저장 실패: ' + xhr.status);
              return;
            }
            try {
              var res = JSON.parse(xhr.responseText || '{}');
              alert(res.message || '저장되었습니다.');
              window.location.reload();
            } catch (e) {
              alert('저장되었습니다.');
              window.location.reload();
            }
          };
          xhr.onerror = function(){ alert('저장 요청 중 오류가 발생했습니다.'); };
          var body = 'contractYear=' + encodeURIComponent('${gridYear}') +
                     '&rowsJson=' + encodeURIComponent(JSON.stringify(rows));
          xhr.send(body);
        });
      }
      if (btnGridIssue) {
        btnGridIssue.addEventListener('click', function(){
          var selected = collectSelectedTargets();
          alert('세금계산서 발행(UI): 선택된 발행 대상 ' + selected.length + '건입니다.');
        });
      }
      // 표기 목록 행 선택: 체크박스 + 선택된 행 배경색
      if (chkAllRows) {
        chkAllRows.addEventListener('change', function(){
          setAllRows(chkAllRows.checked);
        });
      }
      document.querySelectorAll('.contract-grid tbody tr.grid-row').forEach(function(tr){
        bindGridRow(tr);
      });

      // 공급가액 입력 시 세액(10%), 합계 자동 계산
      function formatAmount(v) {
        var n = Math.round((toNumber(v) + Number.EPSILON) * 100) / 100;
        return n.toLocaleString('ko-KR');
      }
      function recalcRow(tr) {
        if (!tr) return;
        var supplyEl = tr.querySelector('.supply-input');
        var taxEl = tr.querySelector('.tax-input');
        var grandEl = tr.querySelector('.grand-input');
        if (!supplyEl || !taxEl || !grandEl) return;
        var supply = toNumber(supplyEl.value);
        var tax = Math.round((supply * 0.1 + Number.EPSILON) * 100) / 100;
        var grand = supply + tax;
        taxEl.value = formatAmount(tax);
        grandEl.value = formatAmount(grand);
      }

      // 입력칸 탭 이동: 같은 열의 위/아래 행으로 이동 + 컬럼 간 래핑 지원
      function bindVerticalTab(selector, selectOnFocus, options) {
        options = options || {};
        var allInputs = Array.prototype.slice.call(document.querySelectorAll(selector));
        allInputs.forEach(function(input){
          input.addEventListener('keydown', function(e){
            if (e.key !== 'Tab') return;
            var idx = allInputs.indexOf(input);
            if (idx < 0) return;
            if (e.shiftKey) {
              if (idx === 0) {
                if (!options.prevSelector) return;
                var prevGroup = Array.prototype.slice.call(document.querySelectorAll(options.prevSelector));
                if (prevGroup.length === 0) return;
                e.preventDefault();
                var prevTarget = options.prevFromEnd ? prevGroup[prevGroup.length - 1] : prevGroup[0];
                prevTarget.focus();
                if (options.prevSelectOnFocus && typeof prevTarget.select === 'function') prevTarget.select();
                return;
              }
              e.preventDefault();
              var prev = allInputs[idx - 1];
              prev.focus();
              if (selectOnFocus && typeof prev.select === 'function') prev.select();
              return;
            }
            if (idx >= allInputs.length - 1) {
              if (!options.nextSelector) return;
              var nextGroup = Array.prototype.slice.call(document.querySelectorAll(options.nextSelector));
              if (nextGroup.length === 0) return;
              e.preventDefault();
              var nextTarget = options.nextFromEnd ? nextGroup[nextGroup.length - 1] : nextGroup[0];
              nextTarget.focus();
              if (options.nextSelectOnFocus && typeof nextTarget.select === 'function') nextTarget.select();
              return;
            }
            e.preventDefault();
            var next = allInputs[idx + 1];
            next.focus();
            if (selectOnFocus && typeof next.select === 'function') next.select();
          });
        });
      }

      refreshGridNo();
      bindVerticalTab('.contract-grid .item-input', false, {
        nextSelector: '.contract-grid .supply-input',
        nextFromEnd: false,
        nextSelectOnFocus: true
      });
      bindVerticalTab('.contract-grid .supply-input', true, {
        prevSelector: '.contract-grid .item-input',
        prevFromEnd: true,
        prevSelectOnFocus: false
      });

      // 품목 접두어(YY.MM월) 자동 표시
      (function(){
        var now = new Date();
        var yy = String(now.getFullYear()).slice(-2);
        var mm = String(now.getMonth() + 1).padStart(2, '0');
        var prefix = yy + '.' + mm + '월';
        document.querySelectorAll('.item-prefix').forEach(function(el){ el.textContent = prefix; });
      })();
    })();
    document.getElementById('menu-recipient').classList.add('on');
  </script>
</body>
</html>
