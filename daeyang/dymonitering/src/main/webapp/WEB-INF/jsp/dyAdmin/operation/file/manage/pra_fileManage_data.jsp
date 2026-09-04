<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>


 
 <div class="pageNumberBox">
	<c:if test="${not empty resultList }">
		<div class="col-sm-6 col-xs-12" style="line-height: 35px; text-align: left;">
			<span class="pagetext">총 ${paginationInfo.totalRecordCount }건  / 총 ${paginationInfo.totalPageCount} 페이지 중 ${paginationInfo.currentPageNo} 페이지 </span>
		</div>
		<div class="col-sm-6 col-xs-12 middlePage" style="text-align: right;">
				<ul class="pageNumberUl" >
					<ui:pagination paginationInfo="${paginationInfo }" type="normal_board" jsFunction="pf_LinkPage" />
			    </ul>
		</div>
    </c:if>
    <c:if test="${empty resultList }">
		<div class="col-sm-6 col-xs-12" style="line-height: 35px; text-align: left;">
		<span class="pagetext">0건 중 0~0번째 결과(총  ${paginationInfo.totalRecordCount }건중 매칭된 데이터)</span>
		</div>
    </c:if>
    <div style="clear: both"></div>
</div> <!--위쪽페이징 끝  -->

<table id="dt_basic" class="pagingTable table table-striped table-bordered table-hover" width="100%">
	<thead>
		<%-- 모든필드 , 게시글 갯수 시작  --%>
		<tr>
			<th colspan="9">
				<div style="float:left;">
					<input type="text" class="form-control search-control" data-searchindex="all" placeholder="모든필드 검색" style="width:200px;display: inline-block;" />
					<button class="btn btn-sm btn-primary smallBtn" type="button" onclick="pf_LinkPage()" style="margin-right:10px;">
						<i class="fa fa-plus"></i> 검색
					</button>
				</div>
				<div style="float:right;">
<!-- 					<button type="button" class="btn btn-sm btn-primary" onclick="pf_excel()"> -->
<!-- 						<i class="fa fa-file-excel-o"></i> 엑셀 -->
<!-- 					</button> -->
					<select name="pageUnit" id="pageUnit" style="width:50px;display:inline-block; vertical-align: top;height: 31px;" onchange="pf_LinkPage();">
				    	<option value="10" ${10 eq search.pageUnit ? 'selected' : '' }>10</option>
				    	<option value="25" ${25 eq search.pageUnit ? 'selected' : '' }>25</option>
				    	<option value="50" ${50 eq search.pageUnit ? 'selected' : '' }>50</option>
				    	<option value="75" ${75 eq search.pageUnit ? 'selected' : '' }>75</option>
				    	<option value="100" ${100 eq search.pageUnit ? 'selected' : '' }>100</option>
				    </select>
			    </div>
			</th>
		</tr><%-- 모든필드 , 게시글 갯수 끝  --%>
								
		<tr>
			<th class="hasinput min200">
				<input type="text" class="form-control search-control" data-searchindex="1" placeholder="번호 검색" />
			</th>
						
			<th class="hasinput min200">
				<select class="form-control selectFilter search-control" data-searchindex="2" name="" style="width:100%;" onchange="pf_LinkPage()">
					<option value="">전체</option>
					<option value="BN">게시판</option>
					<option value="MVD">페이지생성</option>
	       </select>
			</th>	
			
			<th class="hasinput">
				<input type="text" class="form-control search-control" data-searchindex="3" placeholder="파일설명 검색" />
			</th>        
	        
	    <th class="hasinput min200">
	       <!-- 파일종류  -->
			</th>
	                
	        
	    <th class="hasinput min200">
				<input type="text" class="form-control search-control" data-searchindex="4" placeholder="등록자 검색" />
			</th>
	        
	        
	    <th class="hasinput min200">
				<input type="text" class="form-control search-control" data-searchindex="5" placeholder="등록일 검색" />	
			</th>
		</tr>
		<tr>
			<th class="arrow" data-index="1">키 번호</th>
			<th class="arrow" data-index="2">사용 처</th>
			<th class="arrow" data-index="3">파일설명</th>
			<th class="arrow" data-index="4">원본 파일명</th>
			<th class="arrow" data-index="5">등록자</th>
			<th class="arrow" data-index="6">등록일</th>
		</tr>
	</thead>
	<tbody>
		<c:if test="${empty resultList}">
			<tr><td colspan="9">검색된 데이터가 없습니다.</td></tr>
		</c:if>
		<style>
		  .webkitGradientColor { 
		    background: -webkit-linear-gradient(red, green);
			  -webkit-background-clip: text;
			  -webkit-text-fill-color: transparent;
			 }
		</style>
		<c:set var="resultLength" value="${fn:length(resultList) }"/>
		<c:forEach items="${resultList }" var="model" varStatus="status">
			<tr onclick="pf_openAddFile('${model.KEYNO}')" style="cursor:pointer;">
				<td><c:out value="${model.KEYNO}"/></td>
				<td>
				  <c:out value="${model.FM_WHERE_KEYS}"/>
				</td>
				<td><c:out value="${model.FM_COMMENTS}"/></td>
				
				<c:set var="FS_ORINM_array" value="${fn:split(fn:toLowerCase(model.FS_ORINMS), ',') }" />
				<td class="TD_fileExt" style="text-align:left;">
				  <c:forEach items="${FS_ORINM_array }" var="filename" varStatus="i">
				    <c:if test="${i.index > 0 }"><br/></c:if>
				    <c:set var="filename_array" value="${fn:split(filename, '.') }" />
				    <c:set var="ext" value="${filename_array[fn:length(filename_array)-1] }" />
					  <c:choose>
					    <c:when test="${ ext == 'jpg' || ext == 'png' || ext == 'gif' || ext == 'jpeg' }">
				        <i class="fa fa-picture-o webkitGradientColor" style=""></i>&nbsp;
					    </c:when>
					    <c:when test="${ ext == 'doc' || ext == 'docx' || ext == 'txt' || ext == 'hwp' }">
				        <i class="fa fa-file-word-o" style="color:#295598;"></i>&nbsp;
					    </c:when>
					    <c:when test="${ ext == 'xls' || ext == 'xlsx' }">
				        <i class="fa fa-file-excel-o" style="color:#207245;"></i>&nbsp;
					    </c:when>
					    <c:when test="${ ext == 'ppt' || ext == 'pptx' }">
				        <i class="fa fa-file-powerpoint-o" style="color:#D14524;"></i>&nbsp;
					    </c:when>
					    <c:when test="${ ext == 'pdf' }">
				        <i class="fa fa-file-pdf-o" style="color:red;"></i>&nbsp;
					    </c:when>
					    <c:when test="${ ext == 'mp3' || ext == 'wav' || ext == 'wma' }">
				        <i class="fa fa-file-audio-o" style=""></i>&nbsp;
					    </c:when>
					    <c:when test="${ not empty ext  }">
				        <i class="fa fa-file-audio-o" style=""></i>&nbsp;
					    </c:when>
					    <c:otherwise>
					    </c:otherwise>
					  </c:choose>
					  <c:out value="${filename }" />
				  </c:forEach>
				</td>
				<td><c:out value="${model.UI_NAME }"/>(<c:out value="${model.UI_ID}"/>)</td>
				<td><c:out value="${model.FM_REGDT}"/></td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
<!--테이블 끝  -->
<%-- 하단 페이징 --%>
	
<div class="pageNumberBox dt-toolbar-footer">
	<c:if test="${not empty resultList }">
		<div class="col-sm-6 col-xs-12" style="line-height: 35px; text-align: left;">
			<span class="pagetext">총 ${paginationInfo.totalRecordCount }건  / 총 ${paginationInfo.totalPageCount} 페이지 중 ${paginationInfo.currentPageNo} 페이지</span>
		</div>
		<div class="col-sm-6 col-xs-12" style="text-align: right;">
				<ul class="pageNumberUl" >
					<ui:pagination paginationInfo="${paginationInfo }" type="normal_board" jsFunction="pf_LinkPage" />
			    </ul>
		</div>
    </c:if>
    <c:if test="${empty resultList }">
    	<div class="col-sm-6 col-xs-12" style="line-height: 35px; text-align: left;">
		<span class="pagetext">0건 중 0~0번째 결과(총  ${paginationInfo.totalRecordCount }건중 매칭된 데이터)</span>
		</div>
    </c:if>
</div>

<script type="text/javascript">

$(function(){

	pf_defaultPagingSetting('${search.orderBy}','${search.sortDirect}');

})

</script>
					