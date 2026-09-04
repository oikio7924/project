<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>


<c:forEach items="${fileSubList }" var="fileSub" varStatus="idx">
	<fmt:parseNumber value="${fileSub.FS_KEYNO}" var="fsKey" />
	<c:choose>
		<c:when test="${ fn:indexOf(fileSub.mimeType, 'image') > -1 }">
		  <c:set var="isImage" value="true" />
		</c:when>
		<c:otherwise>
		  <c:set var="isImage" value="false" />
		</c:otherwise>
	</c:choose>
	<tr class="fileSub_${fsKey }" isImage="${isImage }">
	  <td>첨부 <span class="fileSubCnt">${idx.count }</span></td>
	  <td>
	    <table class="table table-bordered table-striped">
	      <c:if test="${ isImage }">
	        <colgroup>
	          <col style="width: 40%;">
	          <col style="width: 15%;">
	          <col style="width: 35%;">
	        </colgroup>
	        <tbody>
	          <tr>
	            <th rowspan="11" style="text-align:center;">
	              <img src="${fileSub.THUMBNAIL_PATH }" class="fileSubImg imgMain"
	               alt="${fileSub.FS_ALT }" onerror="imgReload(this, 3000)" onload="getOriginWidthHeight(this)"
	            	   data-ori-width="${fileSub.FS_ORIWIDTH }" data-ori-height="${fileSub.FS_ORIHEIGHT }" />
	               <input disabled type="hidden" name="FS_ORIWIDTH" value="${fileSub.FS_ORIWIDTH }" /> 
	               <input disabled type="hidden" name="FS_ORIHEIGHT" value="${fileSub.FS_ORIHEIGHT }" /> 
	            </th>
		            <th>썸네일</th>
		            <td style="text-align:center;">
		              <c:choose>
				            <c:when test="${not empty fileSub.FS_THUMBNAIL }">
				              <img src="${fileSub.FS_THUMBNAIL_PATH }" class="fileSubImg imgThumb"
				               alt="${fileSub.FS_ALT } 이미지 썸네일" onerror="imgReload(this, 3000)" onload="getOriginWidthHeight(this)" />
				            </c:when>
		              </c:choose>
		            </td>
	          </tr>
	        </c:if>
	        <c:if test="${ not isImage }">
	          <colgroup>
	            <col style="width: 20%;">
	            <col style="width: 80%;">
	          </colgroup>
	          <tbody>
	        </c:if>
	        <tr>
	          <th>파일키</th>
	          <td>
	           <span class="copyToClipboard"><c:out value="${fileSub.FS_KEYNO }"/></span>
	          </td>
	        </tr>
	        <tr>
	          <th>파일 암호화 키</th>
	          <td>
	           <span class="copyToClipboard"><c:out value="${fileSub.FS_ENCODE }"/></span>
	          </td>
	        </tr>
	        <tr>
	          <th>파일 경로</th>
	          <td>
	           <span class="copyToClipboard">/resources/img/upload/<c:out value="${fileSub.fileWebPath }"/></span>
	          </td>
	        </tr>
	        <tr>
            <th>업로드 파일명</th>
            <td>
              <span class="copyToClipboard"><c:out value="${fileSub.FS_CHANGENM}"/>.<c:out value="${fileSub.FS_EXT}"/></span>
              &nbsp;(<c:out value="${fileSub.mimeType }"/><c:if test="${empty fileSub.mimeType }">파일없음</c:if>)</td>
          	</tr>
	        <tr>
	          <th>원본 파일명</th>
	          <td><span class="copyToClipboard VAL_FILE_ORINM"><c:out value="${fileSub.FS_ORINM}"/></span>&nbsp;(<fmt:formatNumber value="${fileSub.FS_FILE_SIZE }" /> byte)</td>
	        </tr>
	        <tr>
	          <th>등록/수정일</th>
	          <td>
              <c:out value="${fileSub.FS_REGDT }" />
	          </td>
	        </tr>
	        <tr>
	          <th>파일 설명</th>
	          <td class="VAL_COMMENTS"><c:out value="${fileSub.FS_COMMENTS}"/></td>
	        </tr>
	        <tr>
	          <th>파일 주석(이미지 ALT)</th>
	          <td class="VAL_ALT"><c:out value="${fileSub.FS_ALT}"/></td>
	        </tr>
	        <tr>
	          <th>다운로드 횟수</th>
	          <td><c:out value="${fileSub.FS_DOWNCNT}"/></td>
	        </tr>
	        <tr>
	          <td colspan="2">
	            <c:if test="${ isImage }">
	              <span class="copyToClipboard">
	                [이미지태그 복사]
	                <data style="display:none;">
	                  <c:choose>
                      <c:when test="${ empty fileSub.FS_ALT }">
                        <c:set var="image_alt" value="${fileSub.FS_ORINM }" />
                      </c:when>
                      <c:otherwise>
                        <c:set var="image_alt" value="${fileSub.FS_ALT }" />
                      </c:otherwise>
	                  </c:choose>
                    <img src='<c:out value="${fileSub.THUMBNAIL_PATH}"/>' alt='<c:out value="${image_alt}"/>' />
	                </data>
	              </span>&nbsp;&nbsp;
	            </c:if>
	            <span class="copyToClipboard">
                [다운로드 태그 복사]
                <data style="display:none;">
                  <a href="javascript:cf_download('${fileSub.encodeFsKey }')">다운로드</a>
                </data>
              </span>&nbsp;&nbsp;
	            <span class="copyToClipboard">
                [다운로드 URL 복사]
                <data style="display:none;">
                  <c:out value="${fileSub.THUMBNAIL_PATH }"/>
                </data>
              </span>
	          </td>
	        </tr>
	        <tr>
	          <td colspan="2">
	           <button class="btn btn-sm btn-primary" id="" type="button" onclick="pf_updateFSDialog('${fsKey }')"><i class="fa fa-floppy-o"></i> 파일 수정</button> 
	           <button class="btn btn-sm btn-danger" id="" type="button" onclick="pf_deleteFS('${fsKey }')"><i class="fa fa-floppy-o"></i> 파일 삭제</button> 
	          </td>
	        </tr>
	      </tbody>
	    </table>
	  </td>
	</tr>

</c:forEach>
