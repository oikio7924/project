<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<%@ include file="/WEB-INF/jsp/setting/settingData.jsp"%>
<style>
.btnBig_01 {
    padding: 10px 40px;
    font-size: 18px;
    color: #fff;
    background-color: #58595b;
    min-width: 150px;
}
.bgColorR {
    background-color: #e02b31 !important;
    color: #fff !important;
}
.detailViewBtnBox .rightBtnBox {
    position: absolute;
    right: 10px;
    top: 30px;
}
.btn {
    /* -webkit-transition: all 0.1s ease-in-out; */
    -moz-transition: all 0.1s ease-in-out;
    -o-transition: all 0.1s ease-in-out;
    /* transition: all 0.1s ease-in-out; */
    padding: 5px 10px; 
    cursor: pointer;
    display: inline-block;
}
</style>
<!-- 카카오톡 -->
<script src="/resources/js/sns/kakao.min.js"></script>
<!-- 구글플러스 -->
<script src="https://apis.google.com/js/platform.js" async defer></script>

<jsp:useBean id="toDay" class="java.util.Date" scope="page"/>
<fmt:formatDate value="${toDay}" pattern="yyyy-MM-dd" var="nowDate" />

<script type="text/javascript">


$(function(){
	cf_movePosition('${currentPosition}');
	
})

// 뒤로가기
function pf_back(){
	location.href="${mirrorPage }";
}



// 답글 쓰기
function pf_replyWrite(){
	var reply = '${boardAuthList.reply}';
	if(reply == 'false'){
		if(!cf_checkLogin()){
			return false;
		}
		alert('답글쓰기 권한이 없습니다. 관리자한테 문의하세요.');
		return false;
	}
	$("#Form").attr("action", "${tilesUrl }/BoardData/insertView.do");
	$("#Form").submit();
	
}

//게시글 수정 페이지로 이동
function pf_UpdateView(bnkey){
	
	actionUrl = '${tilesUrl }/Board/updateView.do';
	var pwd = '${BoardNotice.BN_PWD}';
	$("#Form").attr("action", actionUrl);
	if(pwd){
		pf_openPWD(bnkey);
		return false;
	}
	
	$("#Form").submit();
}

// 게시글 삭제
function pf_deleteMove(bnkey){
	if(confirm("삭제 하시겠습니까?")== true){
		actionUrl = '${tilesUrl }/Board/delete.do';
		var pwd = '${BoardNotice.BN_PWD}';
		$("#Form").attr("action", actionUrl);
		if(pwd){
			pf_openPWD(bnkey);
			return false;
		}

		$("#Form").submit();
	}
}

var actionUrl = '';

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

//게시물 이동
function pf_moveBoardData(key){
	
	var check = true;
	
	$.ajax({
	    type   : "post",
	    url    : "${tilesUrl}/Board/moveCheckAjax.do",
	    data   : {"BN_KEYNO" : key},
	    async  : false,
	    success:function(data){
	          if(data > 0){
	        	  check = false;
	          }
	    },
	    error: function(jqXHR, textStatus, exception) {
	    	alert('error: '+textStatus+": "+exception);
	    }
	});

	if(check){
		$('#Form').attr('action','${tilesUrl}/Board/'+key+'/moveView.do');
		$('#Form').submit();		
	}else{
		alert("해당 게시글은 답글이 달린글이라 이동이 불가능합니다.");
		return false;
	}
	
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
	    async  : false,
	    success:function(data){
	    	if(data){
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

</script>
<article id="container" class="container_sub clearfix">
	<div class="inner">
		<div class="conSub01_bottomBox">
			<div class="innerContainer clearfix">
				<form:form id="Form" name="Form" method="post">
					<input type="hidden" name="BN_KEYNO" id="BN_KEYNO" value="${BoardNotice.BN_KEYNO }">
					<input type="hidden" name="MN_KEYNO" id="MN_KEYNO" value="${BoardNotice.BN_MN_KEYNO }">
					<input type="hidden" name="BN_MN_KEYNO" id="BN_MN_KEYNO" value="${BoardNotice.BN_MN_KEYNO }">
					<input type="hidden" name="BC_REGNM" id="BC_REGNM" value="${userInfo.UI_ID}">
					<input type="hidden" name="BT_KEYNO" id="BT_KEYNO" value="${BoardType.BT_KEYNO }">
					<input type="hidden" name="BN_TITLE" id="BN_TITLE" value="${BoardNotices.BN_TITLE }">
<%-- 					<input type="hidden" id="snsdesc" value="<c:out value="${SNSInfo.DESC}" escapeXml="true" ></c:out>" /> --%>
				</form:form>
				
				<div class="boardDetailViewBox">
					<c:choose>
						<c:when test="${BoardType.BT_CODEKEY eq '' }">
							<!-- 필요할경우 타입 분기처리 -->
						</c:when>
						<c:otherwise>
							<%@ include file="detailView/prc_board_data_detailView_normal.jsp"%>
						</c:otherwise>
					</c:choose>
					
					<c:if test="${currentMenu.MN_GONGNULI_YN eq 'Y'}">
			            <div style="margin: 50px 0;">
<%-- 							<%@ include file="/WEB-INF/jsp/common/prc_gong_nuli.jsp" %>                             --%>
			            </div>
		            </c:if>
		            
				    <div class="detailViewNextBox">
				    	<ul class="detailViewNext">
				    		<c:if test="${not empty nextBoardNotice }">
				    		<fmt:parseNumber value="${fn:substring(nextBoardNotice.BN_KEYNO,5,20)}" var="numberType" />
				    		<li><span>다음글</span> <a href="${tilesUrl}/Board/${numberType }/detailView.do"><c:out value="${nextBoardNotice.BN_TITLE }" escapeXml="true" ></c:out></a></li>
				            </c:if>
				            <c:if test="${not empty prevBoardNotice }">
				            <fmt:parseNumber value="${fn:substring(prevBoardNotice.BN_KEYNO,5,20)}" var="numberType" />
				            <li><span>이전글</span> <a href="${tilesUrl}/Board/${numberType }/detailView.do"><c:out value="${prevBoardNotice.BN_TITLE }" escapeXml="true" ></c:out></a></li>
				            </c:if>
				        </ul>
				    </div>
				    <div class="detailViewBtnBox">
				    	<div class="rightBtnBox">
							<fmt:parseNumber value="${fn:substring(BoardNotice.BN_KEYNO, 4, 20)}" var="BN_KEYNO_NUMBERTYPE" />
							<c:if test="${userInfo.isAdmin eq 'Y'}">
								<button class="btn btnSmall_02 bgColorR btn-default" type="button" onclick="pf_moveBoardData('${BN_KEYNO_NUMBERTYPE}')">
									${language_default_move }
								</button>
							</c:if>
							<c:if test="${BoardNotice.BN_USE_YN eq 'Y' && ( not empty BoardNotice.BN_PWD || BoardNotice.BN_REGNM == userInfo.UI_KEYNO || userInfo.isAdmin eq 'Y') }">
								<button class="btn btnSmall_02 bgColorR btn-default" type="button" onclick="pf_UpdateView('${BN_KEYNO_NUMBERTYPE}')">
							 		수정
								</button>
								<button class="btn btnSmall_02 bgColorR btn-default" type="button" onclick="pf_deleteMove('${BN_KEYNO_NUMBERTYPE}')">
									삭제
								</button>
							</c:if>
							<c:if test="${BoardType.BT_REPLY_YN eq 'Y' && BoardNotice.BN_IMPORTANT ne 'Y' }">
							<button class="btn btnSmall_02 bgColorG_999 btn-default" type="button" onclick="pf_replyWrite()">
								답글
							</button>
							</c:if>
				        </div>
				        <button type="button" class="btn btnBig_01 btn-default" onclick="pf_back()">목록</button>
				    </div>
				    <c:if test="${BoardType.BT_COMMENT_YN == 'Y' }">
					<%@ include file="detailView/prc_board_data_detailView_reply.jsp"%>
					</c:if>
				</div>

				<div class="board_layerPop" id="board_pwd_confirm">
					<div class="board_layerPop_inner">
					<form:form id="pwdForm">
						<input type="hidden" name="BN_KEYNO" id="pwdBN_KEYNO">
						<button type="button" class="board_layerPop_close" onclick="pf_closePwd()">X</button>
						<p>비밀번호를 입력하여주세요.</p>
						<input type="password" name="BN_PWD" id="pwdBN_PWD" title="비밀번호 입력">
						<button type="button" class="btn" onclick="pf_checkPwd()">확인</button>	
					</form:form>
					</div>
				</div>
			</div>
		</div>
	</div>
</article>