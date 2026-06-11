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
</div>

<div class="tableMobileWrap">
<table id="dt_basic" class="pagingTable table table-striped table-bordered table-hover" width="100%">
	<thead>
		<%-- 모든필드 , 게시글 갯수 시작  --%>
		<tr>
			<th colspan="10">
				<div style="float:left;">
					<input type="text" class="form-control search-control" data-searchindex="all" placeholder="모든필드 검색" style="width:200px;display: inline-block;" />
					<button class="btn btn-sm btn-primary smallBtn" type="button" onclick="pf_LinkPage()" style="margin-right:10px;">
						<i class="fa fa-plus"></i> 검색
					</button>
				</div>
				<div style="float:right;">
					<button type="button" class="btn btn-sm btn-primary" onclick="pf_excel()">
						<i class="fa fa-file-excel-o"></i> 엑셀
					</button>
					<select name="pageUnit" id="pageUnit" style="width:50px;display:inline-block; vertical-align: top;height: 31px;" onchange="pf_LinkPage();">
				    	<option value="10" ${10 eq search.pageUnit ? 'selected' : '' }>10</option>
				    	<option value="25" ${25 eq search.pageUnit ? 'selected' : '' }>25</option>
				    	<option value="50" ${50 eq search.pageUnit ? 'selected' : '' }>50</option>
				    	<option value="75" ${75 eq search.pageUnit ? 'selected' : '' }>75</option>
				    	<option value="100" ${100 eq search.pageUnit ? 'selected' : '' }>100</option>
				    </select>
			    </div>
			</th>
		</tr>
		<%-- 모든필드  ,  엑셀다운, 게시글 갯수 끝  --%>
		<tr>
			<th class="hasinput">
				<input type="text" class="form-control search-control" data-searchindex="1" placeholder="번호 검색" />
			</th>
			<th class="hasinput">
				<input type="text" class="form-control search-control" data-searchindex="2" placeholder="사원명 검색" />
			</th>
			<th class="hasinput">
				<input type="text" class="form-control search-control" data-searchindex="3" placeholder="부서 검색" />
			</th>
			<th class="hasinput">
				<input type="text" class="form-control search-control" data-searchindex="4" placeholder="직책 검색" />
			</th>		
			<th class="hasinput">
				<input type="text" class="form-control search-control" data-searchindex="5" placeholder="업무명 검색" />
			</th>		
			<!-- 이메일과 전화번호는 암호화로 인해 검색 불가 -->
			<th class="hasinput"></th>
			<th class="hasinput"></th>
		</tr>
		<%-- 화살표 정렬 --%>
		<tr>
			<th class="arrow" data-index="1">번호</th>
			<th class="arrow" data-index="2">사원명</th>
			<th class="arrow" data-index="3">부서</th>
			<th class="arrow" data-index="4">직책</th>
			<th class="arrow" data-index="5">업무명</th>
			<th class="min200" style="width:15%;">전화번호</th>
			<th class="min200" style="width:15%;">설정</th>
		</tr>
	</thead>
	<tbody>
		<c:if test="${empty resultList }">
		<tr>
			<td colspan="9">검색된 데이터가 없습니다.</td>
		</tr>
		</c:if>
		<c:forEach items="${resultList }" var="model">
		 <tr>
			<td class="num" value="${model.DU_KEYNO}"><c:out value="${model.COUNT}"/></td>
			<td class="name">${model.DU_NAME}</td>
			<td class="department" value="${model.DU_DN_KEYNO}"><c:out value="${model.DN_NAME}"/></td>
			<td class="role">${model.DU_ROLE}</td>
			<td class="contents">${model.DU_CONTENTS}</td>
			<td class="tel">${model.DU_TEL}</td>
			<td><button type="button" class="btn btn-sm btn-primary" style="margin-right:5px;" onclick="pf_openUpdatePersonInfo(this);">더보기</button>
				<button type="button" class="btn btn-sm btn-danger" onclick="pf_deletePersonInfo(this);">삭제</button></td>
		</tr> 
		</c:forEach>
	</tbody>
</table>
</div>
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

<!-- 조직원 수정 -->
<div id="orgPersonUpdate" title="조직원 수정">
	<div class="widget-body ">
		<fieldset>
			<div class="form-horizontal">
				<fieldset>
					<div class="bs-example necessT">
				         <span class="colorR fs12">*표시는 필수 입력 항목입니다.</span>
				     </div>
					<div class="form-group">
						<label class="col-md-2 control-label"><span class="nessSpan">*</span> 사원명</label>
						<div class="col-md-10">
							<input type="text" class="form-control orgPersonName" maxlength="50">
						</div>
					</div>
					<div class="form-group">
							<label class="col-md-2 control-label"><span
								class="nessSpan">*</span> 부서</label>
							<div class="col-md-10">
								<select class="form-control input-sm select2"
									id="festivalSelect3" name="SITE_KEYNO">
									<c:forEach items="${orgList}" var="homeDiv">
										<option value="${homeDiv.DN_KEYNO}"><c:out
												value="${homeDiv.DN_NAME}" /></option>
									</c:forEach>
								</select>
							</div>
						</div>
					<div class="form-group">
						<label class="col-md-2 control-label">직책</label>
						<div class="col-md-10">
							<input type="text" class="form-control orgPersonRole" maxlength="15">
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-2 control-label">전화번호</label>
						<div class="col-md-10">
							<textarea class="form-control orgPersonTel" rows="3" maxlength="1000"></textarea>
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-2 control-label">업무내용</label>
						<div class="col-md-10">
							<textarea class="form-control orgPersonContents" rows="6" maxlength="1000"></textarea>
						</div>
					</div>
				</fieldset>
			</div>
		</fieldset>
	</div>
</div>
<%@ include file="pra_organ_member_list_insert.jsp"%>
<%--  <form:form id="orgPersonForm">
	<input type="hidden" name="DU_KEYNO" id="DU_KEYNO" value="">
	<input type="hidden" name="DU_NAME" id="DU_NAME" value="">
	<input type="hidden" name="DU_DN_KEYNO" id="DU_DN_KEYNO" value="">
	<input type="hidden" name="DU_ROLE" id="DU_ROLE" value="">
	<input type="hidden" name="DU_LEV" id="DU_LEV" value="">
	<input type="hidden" name="DU_CONTENTS" id="DU_CONTENTS" value="">
	<input type="hidden" name="DU_TEL" id="DU_TEL" value="">
	<input type="hidden" name="DU_HOMEDIV_C" id="DU_HOMEDIV_C" value="">
	<input type="hidden" name="PAGE_DIV_C" id="PAGE_DIV_C" value="11">
</form:form>  --%>

<script src="/resources/smartadmin/js/plugin/select2/select2.min.js"></script>
<script type="text/javascript">

$(function(){

	pf_defaultPagingSetting('${search.orderBy}','${search.sortDirect}');
	
	/* 조직원 수정 */
	cf_setttingDialog('#orgPersonUpdate','조직원 수정','수정','pf_updatePersonInfo()');
	
	 var temp = '';
	 temp += '<option value="">선택하세요.</option>';
	 <c:forEach items="${orgList}" var="homeDiv">
		temp += '<option value="${homeDiv.DN_KEYNO}"><c:out value="${homeDiv.DN_NAME}" /></option>';
	 </c:forEach>
		
		$('#insert_select').html(temp); 
		$('#festivalSelect3').html(temp); 
	
})

//조직원 수정 modal창 오픈
function pf_openUpdatePersonInfo(obj){
	var num = $(obj).closest('tr').find('.num').attr('value');
	var name = $(obj).closest('tr').find('.name').text();
	var department = $(obj).closest('tr').find('.department').attr('value');
	var role = $(obj).closest('tr').find('.role').text();
	var contents = $(obj).closest('tr').find('.contents').text();
	var tel = $(obj).closest('tr').find('.tel').text();
	
	$('#orgPersonUpdate .select2').val(department);
	
	$('#orgPersonUpdate').dialog('open');
	$('#festivalSelect3').select2({
		dropdownParent : $('#orgPersonUpdate')
	});
	
 	$('#DU_KEYNO').val(num);
	$('#orgPersonUpdate .orgPersonName').val(name);
	$('#orgPersonUpdate .orgPersonRole').val(role);
	$('#orgPersonUpdate .orgPersonTel').val(tel);
	$('#orgPersonUpdate .orgPersonContents').val(contents);
	
}

//조직원 수정
function pf_updatePersonInfo(){
	
	if(!$('#orgPersonUpdate .orgPersonName').val().trim()){
		alert('이름을 입력하여주세요.')
		$('#orgPersonName .orgPersonName').focus();
		return false;
	}
	
	if(!confirm('수정하시겠습니까?')){
		return false;
	}
	
	
	$('#DU_NAME').val($('#orgPersonUpdate .orgPersonName').val().trim())
	$('#DU_DN_KEYNO').val($('#orgPersonUpdate .select2').val())
	$('#DU_ROLE').val($('#orgPersonUpdate .orgPersonRole').val().trim())
	$('#DU_TEL').val($('#orgPersonUpdate .orgPersonTel').val())
	$('#DU_CONTENTS').val($('#orgPersonUpdate .orgPersonContents').val())
	$('#DU_HOMEDIV_C').val($('#HOMEDIV').val())
	
	$('#orgPersonForm').attr('action','/dyAdmin/homepage/org/person/update.do');
	$('#orgPersonForm').submit();
	
	
}

//조직원 삭제
function pf_deletePersonInfo(obj){
	var num = $(obj).closest('tr').find('.num').attr('value');
	var department = $(obj).closest('tr').find('.department').attr('value');
	
	if(!confirm('정말 삭제하시겠습니까?')){
		return false;
	}
	
	$('#DU_KEYNO').val(num)
	$('#DU_DN_KEYNO').val(department)
	$('#DU_HOMEDIV_C').val($('#HOMEDIV').val())
	var code = $('.orgInfoTable .code').text();
	$('#orgPersonForm').attr('action','/dyAdmin/homepage/org/person/delete.do');
	$('#orgPersonForm').submit();
}

</script>
