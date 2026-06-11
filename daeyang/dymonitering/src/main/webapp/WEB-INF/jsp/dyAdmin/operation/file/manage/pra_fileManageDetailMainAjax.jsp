<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<tbody>
  <tr>
    <td>등록자</td>
    <td><c:out value="${fileMain.FM_REGNM}"/></td>
  </tr>
  <tr>
    <td>등록일</td>
    <td><c:out value="${fileMain.FM_REGDT}"/></td>
  </tr>
  <tr>
    <td>파일 메인키</td>
    <td id="VAL_FM_KEYNO"><c:out value="${fileMain.FM_KEYNO}"/></td>
  </tr>
  <tr style="display:none;">
    <td>사용처</td>
	  <%-- dialog에 주입되는 실제 데이터 - 삭제하지 말 것 --%>
    <td id="VAL_FM_WHERE_KEYS"><c:out value="${fileMain.FM_WHERE_KEYS}"/></td>
  </tr>
  <tr>
    <td>사용처 링크</td>
    <td>
	    <c:set var="FM_WHERE_KEY_array" value="${fn:split(fileMain.FM_WHERE_KEYS, ',') }" />
	    <c:forEach items="${FM_WHERE_KEY_array }" var="where_key" varStatus="i">
        <c:if test="${i.index > 0 }"><br/></c:if>
        <c:choose>
          <c:when test="${ fn:indexOf(where_key, 'BN_') > -1 }">
				    <a href="javascript:af_boardDetailView('${fn:trim(where_key) }', true);">
					    <c:out value="${where_key }"/> [이동]
				    </a>
          </c:when>
          <c:otherwise>
				    <c:out value="${where_key}"/>
          </c:otherwise>
        </c:choose>
      </c:forEach>
    </td>
  </tr>
  <tr>
    <td>파일 메인 설명</td>
    <td id="VAL_FM_COMMENTS"><c:out value="${fileMain.FM_COMMENTS}"/></td>
  </tr>
</tbody>