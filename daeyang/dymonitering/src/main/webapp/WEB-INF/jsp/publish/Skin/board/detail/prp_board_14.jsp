<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

		<c:if test="${'Y'eq BoardType.BT_CATEGORY_YN }">
		<div class="board_title">
	        <h2>${not empty BoardNotice.BN_CATEGORY_NAME? BoardNotice.BN_CATEGORY_NAME: '전체'  }</h2>
	    </div>
		</c:if>
		
		<div class="board_detail_info">
            <h2><c:out value="${BoardNotice.BN_TITLE}" escapeXml="true"/></h2>
            <div class="info_b">
                <dl>
                    <dt>작성자</dt>
                    <dd>${BoardNotice.BN_UI_NAME }</dd>
                </dl>
                <dl>
                    <dt>작성일</dt>
                    <dd>${fn:substring(BoardNotice.BN_REGDT,0,10) }</dd>
                </dl>
                <dl>
                    <dt>조회</dt>
                    <dd>${BoardNotice.BN_HITS }</dd>
                </dl>
            </div>
        </div>
            
	    <c:forEach items="${BoardColumnList }" var="bcl">
	       <c:if test="${bcl.BL_TYPE ne sp:getData('BOARD_COLUMN_TYPE_TITLE')}">
		        <c:forEach items="${BoardColumnDataList }" var="model">
			        <c:if test="${not empty model.BD_DATA && bcl.BL_KEYNO eq model.BD_BL_KEYNO}">
						<div class="board_detail_contents">
							<p>
								<span>${model.COLUMN_NAME }</span>
								<font class="contents">
								<c:choose>
									<c:when test="${model.BD_BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_CHECK') }">${fn:replace(model.BD_DATA,'|',',' ) }</c:when>
									<c:when test="${model.BD_BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_CHECK_CODE') }">${fn:replace(model.BD_DATA,'|',',' ) }</c:when>
									<c:when test="${model.BD_BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_LINK')}">
				           				<a href="${model.BD_DATA }" target="_blank"><c:out value="${model.BD_DATA }" escapeXml="true"/></a>
				           			</c:when>
									<c:otherwise><c:out value="${model.BD_DATA }" escapeXml="true"/></c:otherwise>
								</c:choose>
								</font>
							</p>
						</div>
					</c:if>
				</c:forEach>
			</c:if>
		</c:forEach>
        
        
        <div class="board_detail_contents">
	    	<c:choose>
	    		<c:when test="${BoardNotice.BN_HTMLMAKER_PLUS_TYPE eq 'N'}">
	    		 <pre>
	    		 	<c:out value="${BoardNotice.BN_CONTENTS }" escapeXml="false"/>
	    		 	
	    		 	<c:forEach items="${FileSub}" var="fs">
	    		 		<c:if test="${fs.FS_EXT eq 'png' || fs.FS_EXT eq 'jpg' || fs.FS_EXT eq 'jpeg' }">
	    		 			<img src="/resources/img/upload/${fs.FS_FOLDER }${fs.FS_CHANGENM}.${fs.FS_EXT}" width="50%;" height="50%;"/>
	    		 		</c:if>
	    		 	</c:forEach>
	    		 	
	    		 </pre>
	    		</c:when>
	    		<c:otherwise>
	    			<c:out value="${BoardNotice.BN_CONTENTS }" escapeXml="false"/>
	    		</c:otherwise>
	    	</c:choose>
	    </div>
        
        
        <c:if test="${BoardType.BT_UPLOAD_YN eq 'Y' && fn:length(FileSub) gt 0 }">
        <div class="board_detail_attach">
             <div class="tit">첨부파일</div>
             <c:forEach items="${FileSub}" var="fs">
				 <c:set value="${fn:toLowerCase(fs.FS_EXT) }" var="ext"/>
					<div class="list">
						<ul>
							<li class="file">
							  <%-- <c:choose>
								<c:when test="${boardAuthList.download eq true}">
				                	<a href="javascript:;" onclick="cf_download('${fs.encodeFsKey}')"> 
								</c:when>
							  	<c:otherwise>
							  		<a href="javascript:;" onclick="alert('다운로드 권한이 없습니다.')">
							  	</c:otherwise>
							  </c:choose> --%>
							  ${fs.FS_ORINM }
							  <c:if test="${fs.FS_FILE_SIZE / 1024  gt 1000}">
									(<fmt:formatNumber value="${fs.FS_FILE_SIZE / 1024 / 1024 }" pattern=".0"/>M)
							  </c:if>
							  <c:if test="${fs.FS_FILE_SIZE / 1000  le 1000}">
									(<fmt:formatNumber value="${fs.FS_FILE_SIZE / 1024 }" pattern=".0"/>K)
							  </c:if> 
<!-- 							  </a> -->
							 <c:if test="${fn:contains('bmp,jpg,png,gif,jpeg,hwp,pdf,xls,xlsx,doc,docx,ppt,pptx', ext) && BoardType.BT_PREVIEW_YN eq 'Y' && boardAuthList.download eq true}">
								<c:choose>
									<c:when test="${fs.FS_CONVERT_CHK eq 'Y' }">
										<button style="float:right" type="button" class="btn preview" data-path='${empty fs.FS_PUBLIC_PATH ? fs.encodePath : fs.encodePublicPath}' data-key='${fs.encodeFsKey}' onclick="pf_preView(this, '${fs.encodeFsKey }')">미리보기</button>			
									</c:when>
									<c:otherwise>
										<button style="float:right" type="button" class="btn preview" data-chk='N' onclick="pf_preView(this, '${fs.encodeFsKey }')">미리보기</button>
									</c:otherwise>
								</c:choose>
							 </c:if>
							</li>
						</ul>
					</div>
				</c:forEach>
                <c:if test="${BoardType.BT_ZIP_YN eq 'Y'  && fn:length(FileSub) > 1 && boardAuthList.download eq true}">
            	<div class="list">
            		<ul>
            			<li class="file">
			            	<a href="javascript:;" onclick="cf_download_zip('${FileSub.get(0).encodeFsFmKey}')">
		    	        		압축파일 다운
		            		</a>
	            		</li>
            		</ul>
            	</div>
            </c:if>
             
         </div>
         </c:if>
