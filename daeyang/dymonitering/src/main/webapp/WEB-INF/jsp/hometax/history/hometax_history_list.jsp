<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>
<!DOCTYPE html>
<html>
<head>
  <%@ include file="/WEB-INF/jsp/hometax/include/hometax_head.jsp" %>
  <style>
    .page-title { margin-bottom: 1rem; font-size: 1.25rem; }
    .content-box { background: #fff; border-radius: 8px; padding: 1.5rem; }
    .content-box table { width: 100%; border-collapse: collapse; }
    .content-box th, .content-box td { border: 1px solid #bdc3c7; padding: 8px 12px; text-align: left; }
    .content-box th { background: #34495e; color: #fff; }
  </style>
</head>
<body>
  <div class="hometax-wrap">
    <%@ include file="/WEB-INF/jsp/hometax/include/hometax_sidebar.jsp" %>
    <div class="hometax-main">
      <div class="page-title">발행내역</div>
      <div class="content-box" style="flex:1; min-height:0; overflow:auto;">
        <table>
          <thead><tr><th>발행일</th><th>품목명</th><th>문서번호</th><th>총금액</th><th>전송여부</th><th>상태</th></tr></thead>
          <tbody>
            <c:choose>
              <c:when test="${empty invoiceLogList}">
                <tr><td colspan="6" style="text-align:center;">발행 내역이 없습니다.</td></tr>
              </c:when>
              <c:otherwise>
                <c:forEach var="log" items="${invoiceLogList}">
                  <tr>
                    <td><c:out value="${log.issueDate}"/></td>
                    <td><c:out value="${log.subject}"/></td>
                    <td><c:out value="${log.documentNo}"/></td>
                    <td><c:out value="${log.grandTotal}"/></td>
                    <td><c:out value="${log.sendYn}"/></td>
                    <td><c:out value="${log.status}"/></td>
                  </tr>
                </c:forEach>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>
      </div>
    </div>
  </div>
  <script>
    document.getElementById('menu-history').classList.add('on');
  </script>
</body>
</html>
