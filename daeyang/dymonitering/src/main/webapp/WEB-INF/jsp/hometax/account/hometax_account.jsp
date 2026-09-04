<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>
<!DOCTYPE html>
<html>
<head>
  <%@ include file="/WEB-INF/jsp/hometax/include/hometax_head.jsp" %>
  <style>
    .page-title { margin-bottom: 1rem; font-size: 1.25rem; }
    .content-box { background: #fff; border-radius: 8px; padding: 1.5rem; flex: 1; min-height: 0; overflow: auto; }
    .form-box { background: #f8f9fa; border: 1px solid #dee2e6; border-radius: 8px; padding: 1rem 1.5rem; }
    .form-row { display: flex; flex-wrap: wrap; gap: 1rem; margin-bottom: 0.75rem; align-items: center; }
    .form-row label { width: 120px; flex-shrink: 0; }
    .form-row input, .form-row select { padding: 6px 10px; min-width: 220px; }
    .btn { display: inline-block; padding: 8px 18px; border-radius: 4px; text-decoration: none; font-size: 0.95rem; border: none; cursor: pointer; }
    .btn-primary { background: #2c3e50; color: #fff; }
    .btn-primary:hover { background: #34495e; }
    .msg { padding: 0.5rem; margin-bottom: 0.75rem; border-radius: 4px; background: #d4edda; color: #155724; }
    .hint { color: #7f8c8d; font-size: 0.9rem; margin-top: 0.25rem; }
  </style>
</head>
<body>
  <div class="hometax-wrap">
    <%@ include file="/WEB-INF/jsp/hometax/include/hometax_sidebar.jsp" %>
    <div class="hometax-main">
      <div class="page-title">내 계정 설정</div>
      <div class="content-box">
        <c:if test="${not empty message}"><div class="msg">${message}</div></c:if>

        <div class="form-box">
          <form action="${pageContext.request.contextPath}/bill/account/save.do" method="post">
            <div class="form-row">
              <label>아이디</label>
              <input type="text" value="<c:out value='${user.loginId}'/>" disabled />
            </div>
            <div class="form-row">
              <label>기본 공급자</label>
              <select name="defaultProviderId">
                <option value="">선택</option>
                <c:forEach var="p" items="${providerList}">
                  <option value="${p.id}" <c:if test="${not empty user and user.defaultProviderId == p.id}">selected</c:if>>
                    <c:out value="${p.corpName}"/> (<c:out value="${p.corpNum}"/>)
                  </option>
                </c:forEach>
              </select>
              <div class="hint">엑셀 일괄등록/공급받는자 기본 선택에 사용됩니다.</div>
            </div>
            <div class="form-row">
              <label>부서(담당자)</label>
              <input type="text" name="department" value="<c:out value='${user.department}'/>" />
            </div>
            <div class="form-row">
              <label>연락처</label>
              <input type="text" name="phone" value="<c:out value='${user.phone}'/>" />
            </div>
            <div class="form-row">
              <label>이메일</label>
              <input type="text" name="email" value="<c:out value='${user.email}'/>" />
            </div>
            <div class="form-row">
              <button type="submit" class="btn btn-primary">저장</button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
  <script>
    document.getElementById('menu-account').classList.add('on');
  </script>
</body>
</html>

