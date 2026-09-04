<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<script type="text/javascript">


var webSocket = null;

var isSocketConnected = false;

var totalReply = "${BoardNotice.REPLYCOUNT}";
// var isReplyPagingEnd = 'false';
var btDelCommentYN = '${BoardType.BT_DEL_COMMENT_YN}';
var btSecretCommentYN = '${BoardType.BT_SECRET_COMMENT_YN}'


$(function(){
	//초기데이터 불러오기
	replyConnectWS();
	pf_getNextReplyList();
	
});

function replyConnectWS(){
	
	var hostname = window.location.hostname;
	var port = window.location.port;
	webSocket = new WebSocket("ws://"+hostname+":"+port+"/boardEcho");

	webSocket.onopen = function(){
		console.log('Info : connection opened');
		webSocket.send("view,"+'${BoardNotice.BN_KEYNO }');
		isSocketConnected = true;
	};
	
	webSocket.onmessage = function (event){
		
		var data = event.data.split(',');
		var type = data[0];
		var count = data[1];
// 		if(type == 'success' && isReplyPagingEnd == 'true'){
		if(type == 'success'){
			$('.reflashDiv').show();
			$('.reflashDiv').find('.reflashNum').text('('+(Number(count)-Number(totalReply))+')');
		}
	}

	webSocket.onclose = function (event) { 
		console.log('Info : connection closed.');
		isSocketConnected = false;
		
	}
	
	webSocket.onerror = function (err) { 
		console.log('Error.' + err.data);
	}
}

//댓글 불러오기
function pf_getNextReplyList(type,sendWS){
	
	cf_loading();
	
	type = type || '';
	
	$.ajax({
	    type   : "get",
	    url    : "${tilesUrl}/Board/comment/listAjax.do",
	    data   : {
	    	"BC_BN_KEYNO" : $('#BN_KEYNO').val(),
	    	"BT_PAGEUNIT_C" : ${BoardType.BT_PAGEUNIT_C},
	    	"BT_PAGESIZE_C" : ${BoardType.BT_PAGESIZE_C},
	    	"pageIndex" : $('#replyPageIndex').val(),
	    	"BT_DEL_COMMENT_YN" : btDelCommentYN, 
	    	"BT_SECRET_COMMENT_YN":btSecretCommentYN,
	    	"type": type
	    },
	    success:function(data){
	    	$('.realComment').html(data);
	    	if(sendWS){
                //websocket에 보내기 (type,게시글번호,댓글수) 
                webSocket.send("new,"+'${BoardNotice.BN_KEYNO }'+","+totalReply);
            }
	    },
	    error: function(jqXHR, textStatus, exception) {
	    	alert('error: '+textStatus+": "+exception);
	    }
	  }).done(function(){
		  cf_loading_out();
	  });
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
	
	var bc_secret_yn ='';
	if($("#BC_SECRET_YN").is(":checked")){
		bc_secret_yn = $("#BC_SECRET_YN").val();
	}else{
		bc_secret_yn = 'N'
	}
	
	var bc_bn_keyno = $("#BN_KEYNO").val();
	var userID = $("#BC_REGNM").val();
	var bc_contents = $("#BC_CONTENTS").val();

	if(bc_contents == null || bc_contents == ""){
		alert("내용을 입력해 주세요 ");
	}else{
		cf_loading();
	
		$.ajax({
		    type   : "post",
		    url    : "${tilesUrl}/Board/comment/insertAjax.do",
		    async  : false,
		    data   : {
		    	"BC_BN_KEYNO" : bc_bn_keyno, 
		    	"BC_CONTENTS" : bc_contents,
		    	"BC_SECRET_YN" : bc_secret_yn
		    },
		    success:function(data){
		    	cf_loading_out();
                $('#BC_CONTENTS').val('');
                cf_TextAreaInputLimit('BC_CONTENTS',500);
                pf_getNextReplyList('',isSocketConnected);
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
	
	var bc_secret_yn; 
	if($("#BC_SECRET_YN_reply_"+count).is(":checked")){
		bc_secret_yn = "Y"
	}else{
		bc_secret_yn = "N"
	}
	
	cf_loading();
	$.ajax({
	    type   : "post",
	    url    : "${tilesUrl }/Board/comment/insertAjax.do",
	    data   : {
	    	"BC_BN_KEYNO" : $("#BN_KEYNO").val(), 
	    	"BC_CONTENTS" : bc_contents,
	    	"BC_MAINKEY" : bc_keyno,
	    	"BC_ROOTKEY" : rootkey,
	    	"BC_SECRET_YN" : bc_secret_yn 
	    	
	    },
	    success:function(data){
	    	cf_loading_out();
	    	pf_ActionAfterSubmit();
	    	
	    	if(isSocketConnected){
	    		totalReply = Number(totalReply) + Number(1);	    	
                //websocket에 보내기 (type,게시글번호,댓글수) 
                webSocket.send("new,"+'${BoardNotice.BN_KEYNO }'+","+totalReply);
            }
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
	if($("#BC_SECRET_YN_Modify_"+count).val()=='Y'){
		 $("#BC_SECRET_YN_Modify_"+count).attr("checked", true);
	 }
	 
}

// 댓글 수정 취소
function pf_commentModifyCandle(count){
	$("#commentModify_"+count).css('display','none')
}

// 댓글 수정
function pf_commentUpdate(bc_keyno,count){
	var bc_contents = $("#BC_CONTENTS_Modify_"+count).val();
	var bc_secret_yn ='';
	if($("#BC_SECRET_YN_Modify_"+count).is(":checked")){
		bc_secret_yn = 'Y';
	}else{
		bc_secret_yn = 'N'
	}
	cf_loading();
	$.ajax({
	    type   : "post",
	    url    : "${tilesUrl }/Board/comment/updateAjax.do",
	    data   : {"BC_KEYNO" : bc_keyno, "BC_CONTENTS" : bc_contents, "BC_SECRET_YN" : bc_secret_yn},
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

//대댓글 작업후 submit
function pf_ActionAfterSubmit(){
	cf_postSend(document.location.pathname,{
		'auth':'Y',
		'currentPosition':$(window).scrollTop(),
		'${_csrf.parameterName}':'${_csrf.token}'
	})
}




// 좋아요 버튼
function pf_likeUpDown(obj, bc_keyno, type){
	if(!cf_checkLogin()){
		return false;
	}
	
	$.ajax({
	    type   : "post",
	    url    : "${tilesUrl}/Board/comment/likeUpdateAjax.do",
	    data   : {
	    		"BC_KEYNO" : bc_keyno,
	    		"TYPE" : type	
	    },
	    success:function(data){
	    	if(data != null){
	    		if(data.result == 'error'){
	    			alert('에러!!!!!!');
	    			return;
	    		}
		    	var type = data.type;
		    	var value = data.value;
	    		if(type == "msg"){
		    		alert(value);	
		    	}else if(type == "int"){
		    		$(obj).addClass('likeSelect').find('.likeCnt').text(value);
		    	}else if(type == "del"){
		    		$(obj).removeClass('likeSelect').find('.likeCnt').text(value);
		    	}
    		}
	    },
	    error: function(jqXHR, textStatus, exception) {
	    	cf_loading_out();
	    	alert('error: '+textStatus+": "+exception);
	    }
	});
}

</script>
