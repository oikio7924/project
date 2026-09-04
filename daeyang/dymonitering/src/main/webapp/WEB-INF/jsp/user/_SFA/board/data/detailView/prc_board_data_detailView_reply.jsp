<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<script type="text/javascript">

$(function(){
	//초기데이터 불러오기
	pf_getNextReplyList('${BoardType.BT_DEL_COMMENT_YN}')
	
})

//댓글 불러오기
function pf_getNextReplyList(ck){
	cf_loading();
	var option = {
	    	"BC_BN_KEYNO" : $('#BN_KEYNO').val(), 
	    	"BT_DEL_COMMENT_YN" : ck, 
	    	"pageIndex" : $('#replyPageIndex').val()
    }
	$('.tempComment').load("${tilesUrl}/Board/comment/listAjax.do",option,function(){
		var temp = $(this).find('script').remove().end().html();
		$('.moreComment').before(temp);
		$(this).html('');
		cf_loading_out();
	})
}

// 댓글 창 초기화
function pf_commentClear(){
	$("#BC_CONTENTS").val("");
}

// 댓글 입력
function pf_commentInsert(){
	
	if(!cf_checkLogin()){
		return false;
	}
	
	var comment = '${boardAuthList.comment}';
	if(comment == 'false'){
		alert('댓글쓰기 권한이 없습니다. 관리자한테 문의하세요.');
		return false;
	}
	
	
	var bc_bn_keyno = $("#BN_KEYNO").val();
	var userID = $("#BC_REGNM").val();
	var bc_contents = $("#BC_CONTENTS").val();
	if(bc_contents == null || bc_contents == ""){
		alert("내용을 입력해 주세요 ")
	}else{
		cf_loading();
		$.ajax({
		    type   : "post",
		    url    : "${tilesUrl }/Board/comment/insertAjax.do",
		    data   : {
		    	"BC_BN_KEYNO" : bc_bn_keyno, 
		    	"BC_CONTENTS" : bc_contents
		    },
		    success:function(data){
		    	cf_loading_out();
		    	pf_ActionAfterSubmit()
		    },
		    error: function(jqXHR, textStatus, exception) {
		    	cf_loading_out();
		    	alert('error: '+textStatus+": "+exception);
		    }
		  });
	}
}

// 댓글 삭제
function pf_commentDelete(bc_keyno){
	if(confirm("삭제 하시겠습니까?")== true){
		cf_loading();
		$.ajax({
		    type   : "post",
		    url    : "${tilesUrl }/Board/comment/deleteAjax.do",
		    data   : {"BC_KEYNO" : bc_keyno},
		    success:function(data){
		    	cf_loading_out();
		    	pf_ActionAfterSubmit();
		    },
		    error: function(jqXHR, textStatus, exception) {
		    	cf_loading_out();
		    	alert('error: '+textStatus+": "+exception);
		    }
		});
	}
}

//댓글의 답글 글쓰기 보이기
function pf_commentReply(count){
	
	if(!cf_checkLogin()){
		return false;
	}
	
	var comment = '${boardAuthList.comment}';
	if(comment == 'false'){
		alert('댓글쓰기 권한이 없습니다. 관리자한테 문의하세요.');
		return false;
	}
	
	$("#commentReply_"+count).css('display','block');
	$("#BC_CONTENTS_reply_"+count).focus();
}

//댓글의 답글 취소
function pf_commentReplyCandle(count){
	$("#commentReply_"+count).css('display','none')
}

//댓글의 답글 글쓰기
function pf_commentReplyWrite(bc_keyno,rootkey,count){
	
	if(!cf_checkLogin()){
		return false;
	}
	
	var comment = '${boardAuthList.comment}';
	if(comment == 'false'){
		alert('댓글쓰기 권한이 없습니다. 관리자한테 문의하세요.');
		return false;
	}
	
	
	var bc_contents = $("#BC_CONTENTS_reply_"+count).val();
	if(!bc_contents){
		alert('답글을 작성하여주세요.');
		$("#BC_CONTENTS_reply_"+count).focus();
		return false;
	}
	
	
	cf_loading();
	$.ajax({
	    type   : "post",
	    url    : "${tilesUrl }/Board/comment/insertAjax.do",
	    data   : {
	    	"BC_BN_KEYNO" : $("#BN_KEYNO").val(), 
	    	"BC_CONTENTS" : bc_contents,
	    	"BC_MAINKEY" : bc_keyno,
	    	"BC_ROOTKEY" : rootkey
	    	
	    },
	    success:function(data){
	    	cf_loading_out();
	    	pf_ActionAfterSubmit()
	    },
	    error: function(jqXHR, textStatus, exception) {
	    	cf_loading_out();
	    	alert('error: '+textStatus+": "+exception);
	    }
    });
}


// 댓글 수정창 보이기
function pf_commentModify(count){
	$("#commentModify_"+count).css('display','block')
	 $("#BC_CONTENTS_Modify_"+count).focus()
	 cf_TextAreaInputLimit('BC_CONTENTS_Modify_'+count,300);
	 
}

// 댓글 수정 취소
function pf_commentModifyCandle(count){
	$("#commentModify_"+count).css('display','none')
}

// 댓글 수정
function pf_commentUpdate(bc_keyno,count){
	var bc_contents = $("#BC_CONTENTS_Modify_"+count).val();
	cf_loading();
	$.ajax({
	    type   : "post",
	    url    : "${tilesUrl }/Board/comment/updateAjax.do",
	    data   : {"BC_KEYNO" : bc_keyno, "BC_CONTENTS" : bc_contents},
	    success:function(data){
	    	cf_loading_out();
	    	pf_ActionAfterSubmit();
	    },
	    error: function(jqXHR, textStatus, exception) {
	    	cf_loading_out();
	    	alert('error: '+textStatus+": "+exception);
	    }
	});
}

//댓글 작업후 submit
function pf_ActionAfterSubmit(){
	cf_postSend(document.location.pathname,{
				'auth':'Y',
				'currentPosition':$(window).scrollTop(),
				'${_csrf.parameterName}':'${_csrf.token}'})
	
}




// 좋아요 버튼
function pf_likeUP(bc_keyno){
	if(!cf_checkLogin()){
		return false;
	}
	
	cf_loading();
	$.ajax({
	    type   : "post",
	    url    : "${tilesUrl }/Board/comment/likeUpdateAjax.do",
	    data   : {"BC_KEYNO" : bc_keyno},
	    success:function(data){
	    	cf_loading_out();
	    	pf_ActionAfterSubmit();
	    },
	    error: function(jqXHR, textStatus, exception) {
	    	cf_loading_out();
	    	alert('error: '+textStatus+": "+exception);
	    }
	});
}

//싫어요 버튼
function pf_likeDown(bc_keyno){
	if(!cf_checkLogin()){
		return false;
	}
	cf_loading();
	$.ajax({
	    type   : "post",
	    url    : "${tilesUrl}/Board/comment/dislikeUpdateAjax.do",
	    data   : {"BC_KEYNO" : bc_keyno},
	    success:function(data){
	    	cf_loading_out();
	    	pf_ActionAfterSubmit();
	    },
	    error: function(jqXHR, textStatus, exception) {
	    	cf_loading_out();
	    	alert('error: '+textStatus+": "+exception);
	    }
	});
}
</script>

<input type="hidden" name="replyPageIndex" id="replyPageIndex" value="1">

<div class="detailViewReplyWriteBox">
	<span class=" block mgB10">댓글입력(500Byte 제한)
		<span class="right">(<span id="BC_CONTENTS_length">0</span>/500)</span>
	</span>
    <div class="writeBox">
    	<textarea title="댓글을 입력해주세요" name="BC_CONTENTS" id="BC_CONTENTS" class="commentTextarea"  onkeyup="javascript:cf_TextAreaInputLimit('BC_CONTENTS',500);" maxlength="1000"></textarea>
    </div>
</div>
<div class="detailViewBtnBox">
	<button type="button" class="btn btnBig_01 btn-default" onclick="pf_commentInsert()">댓글달기</button>
</div>

<div class="tempComment"></div>
<%-- <%@ include file="prc_board_data_detailView_reply_ajax.jsp"%> --%>
<div class="detailViewBtnBox moreComment">
	<button type="button" class="btn btnBig_01 btn-default" onclick="pf_getNextReplyList('${BoardType.BT_DEL_COMMENT_YN}')">더보기</button>
</div>

										
							