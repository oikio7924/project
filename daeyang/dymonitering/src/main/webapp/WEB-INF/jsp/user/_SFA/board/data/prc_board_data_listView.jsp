<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<%@ include file="/WEB-INF/jsp/setting/settingData.jsp"%>
<%-- <%@ include file="/WEB-INF/jsp/cf/board/language/prc_board_language.jsp"%> --%>


<jsp:useBean id="toDay" class="java.util.Date" scope="page"/>
<fmt:formatDate value="${toDay}" pattern="yyyy-MM-dd" var="nowDate" />


<article id="container" class="container_sub clearfix">
	<div class="inner">
		
		<div class="conSub01_bottomBox">
			<div class="innerContainer clearfix">
			
				<c:if test="${BoardHtml.BIH_DIV_LOCATION eq 'T' }">
					<div id="html_contents">${BoardHtml.BIH_CONTENTS }</div>
				</c:if>
			
				<form:form id="Form" name="Form" method="post">
						<input type="hidden" name="BT_KEYNO" id="BT_KEYNO" value="${BoardType.BT_KEYNO }">
						<input type="hidden" name="BD_BT_KEYNO" id="BD_BT_KEYNO" value="${BoardType.BT_KEYNO }">
						<input type="hidden" name="MN_KEYNO" id="MN_KEYNO" value="${Menu.MN_KEYNO }">
						<input type="hidden" name="BN_MN_KEYNO" id="BN_MN_KEYNO" value="${Menu.MN_KEYNO }">
						<input type="hidden" name="BN_KEYNO" id="BN_KEYNO" value="">
						<input type="hidden" name="bnkey" id="bnkey" value="">
						<input type="hidden" name="PageIndex" id="PageIndex" value="${paginationInfo.currentPageNo}" />
						<input type="hidden" name="BN_PWD" id="BN_PWD">
				
				
					<c:choose>
						<c:when test="${BoardType.BT_CODEKEY eq BOARD_TYPE_LIST}">
							<!-- 일반 리스트화면 -->
							<%@ include file="listType/prc_board_data_listView_list.jsp"%>
						</c:when>
						<c:when test="${BoardType.BT_CODEKEY eq BOARD_TYPE_LIST_NO_CONTENT}">
							<!-- 일반 리스트화면 -->
							<%@ include file="listType/prc_board_data_listView_list.jsp"%>
						</c:when>
						<c:when test="${BoardType.BT_CODEKEY eq BOARD_TYPE_LIST_NO_DETAIL}">
							<!-- 상세화면 X  -->
							<%@ include file="listType/prc_board_data_listView_list_noDetail.jsp"%>
						</c:when>
						<c:when test="${BoardType.BT_CODEKEY eq BOARD_TYPE_GALLERY }">
							<!-- 사진자료, 영상자료등 갤러리 -->
							<%@ include file="listType/prc_board_data_listView_gallery.jsp"%>
						</c:when>
						<c:when test="${BoardType.BT_CODEKEY eq BOARD_TYPE_CALENDAR }">
							<%@ include file="listType/prc_board_data_listView_calendar.jsp"%>
						</c:when>
					</c:choose>
					<div class="searchBox_01">
						<div class="inner clearfix">
							<select name="orderCondition" id="orderCondition" class="selectDefault mobileW100" title="검색 순서 선택">
								<option value="A">최신순</option>
								<option value="B">조회수순</option>
							</select>
					    	<select name="searchCondition" id="searchCondition" class="selectDefault mobileW100" title="검색 할 내용 선택">
					        	<c:forEach items="${BoardColumnList }" var="model">
					           		<c:if test="${model.BL_LISTVIEW_YN eq 'Y'}">
										<c:if test="${model.BL_TYPE eq BOARD_COLUMN_TYPE_TITLE }">
											<c:set var="colTitle" value="${model.BL_COLUMN_NAME }"/>
											<option value="title" selected>${model.BL_COLUMN_NAME }</option>
										</c:if>
										<c:if test="${model.BL_TYPE ne BOARD_COLUMN_TYPE_TITLE }">
											<option value="${model.BL_KEYNO }">${model.BL_COLUMN_NAME }</option>
										</c:if>
									</c:if>	
								</c:forEach>
								<option value="contents">${colTitle}+내용</option>
								<option value="writer">작성자</option>
								<option value="all">모두</option>
					        </select>
					        <input type="text" class="txtDefault mobileW100 txtWmiddle" placeholder="검색어를 입력하세요" title="검색어를 입력하세요" name="searchKeyword" id="searchKeyword" onkeydown="if(event.keyCode == 13) pf_boardSearch();">
					        <button type="button" class="btn btnSmall_01 mobileW100 btn-default" onclick="pf_boardSearch()">검색</button>
					    </div>
					</div>
				</form:form>
			
<!-- 				<div class="board_layerPop" id="board_pwd_confirm"> -->
<!-- 					<div class="board_layerPop_inner"> -->
<%-- 					<form:form id="pwdForm"> --%>
<!-- 						<input type="hidden" name="BN_KEYNO" id="pwdBN_KEYNO"> -->
<!-- 						<button type="button" class="board_layerPop_close" onclick="pf_closePwd()">X</button> -->
<!-- 						<p>비밀번호를 입력하여주세요.</p> -->
<!-- 						<input type="password" name="BN_PWD" id="pwdBN_PWD" title="비밀번호 입력"> -->
<!-- 						<button type="button" class="btn" onclick="pf_checkPwd()">확인</button>	 -->
<%-- 					</form:form> --%>
<!-- 					</div> -->
<!-- 				</div> -->
				
				<c:if test="${BoardHtml.BIH_DIV_LOCATION eq 'B' }">
					<div id="html_contents">${BoardHtml.BIH_CONTENTS }</div>
				</c:if>
			</div>
		</div>
	</div>
</article>


<script>
$(function(){
	var searchCondition ='${BoardNotice.searchCondition}'
	if(searchCondition){
		$('#searchCondition').val('${BoardNotice.searchCondition}');
		$('#searchKeyword').val('${BoardNotice.searchKeyword}');
		$('#orderCondition').val('${BoardNotice.orderCondition}');
	}
	if(keywordList){
		$('#searchKeyword').autocomplete({
			source: keywordList,
			focus: function( event, ui ) {
				return false; 
			}
		});
	}
	
})
//페이지 이동
function pf_LinkPage(num){
	$('#PageIndex').val(num);
	$('#Form').attr('action',location.pathname)
	$('#Form').submit();
}

//검색
function pf_boardSearch(){
	$('#PageIndex').val(1);
	$('#Form').attr('action',location.pathname)
	$('#Form').submit();
}

//상세보기
function pf_DetailMove(bn_keyno){
	var read = '${boardAuthList.read}';
	if(read == 'false'){
		alert('접근권한이 없습니다. 로그인을 하시거나 접근권한을 확인하세요.')
		return false;
	}
	
	$('#Form').attr('action','${tilesUrl}/Board/'+bn_keyno+'/detailView.do');
	$('#Form').submit();
}
function pf_NotMyContents(){
	alert('비밀글 입니다.')	
}

//게시글 삭제
function pf_deleteMove(bnkey){
	if(confirm("삭제 하시겠습니까?")== true){
		$('#bnkey').val(bnkey)
		$("#Form").attr("action", '${tilesUrl }/Board/delete.do');
		$("#Form").submit();
	}
}
//게시글 수정 페이지로 이동
function pf_UpdateMove(bnkey){
	
	$('#bnkey').val(bnkey)
	$("#Form").attr("action", '${tilesUrl }/Board/updateView.do');
	$("#Form").submit();
}

//글쓰기
function pf_RegistMove() {
	var write = '${boardAuthList.write}';
	if(write == 'false'){
		if(!cf_checkLogin()){
			return false;
		}
		alert('글쓰기 권한이 없습니다. 관리자한테 문의하세요.');
		return false;
	}
	$("#Form").attr("action", "${tilesUrl }/BoardData/insertView.do");
	$("#Form").submit();
}

//비밀번호 창 open
function pf_openPWD(bnkey){
	$('#pwdBN_KEYNO').val(bnkey);
	$('#board_pwd_confirm').fadeIn();
	$('#pwdBN_PWD').focus();
}

//비밀번호 창 close
function pf_closePwd(){
	$('#board_pwd_confirm').fadeOut();
}

//비밀번호 확인
function pf_checkPwd(){
	if(!$('#pwdBN_PWD').val()){
		alert('비밀번호를 입력하여주세요.')
		$('#pwdBN_PWD').focus();
		return false;
	}
	
	$.ajax({
	    type   : "post",
	    url    : "${tilesUrl }/Board/checkPwdAjax.do",
	    data   : $('#pwdForm').serializeArray(),
	    success:function(data){
	    	if(data){
	    		$('#BN_PWD').val($('#pwdBN_PWD').val())
	    		$('#Form').attr('action','${tilesUrl}/Board/'+$('#pwdBN_KEYNO').val()+'/detailView.do');
	    		$('#Form').submit();
	    	}else{
	    		alert('비밀번호를 확인하여주세요.')
	    	}
	    },
	    error: function(jqXHR, textStatus, exception) {
	    	cf_loading_out();
	    	alert('error: '+textStatus+": "+exception);
	    }
	});
}

//게시물 이동
function pf_moveBoardData(key){
	$('#Form').attr('action','${tilesUrl}/Board/'+key+'/moveView.do');
	$('#Form').submit();
}



</script>