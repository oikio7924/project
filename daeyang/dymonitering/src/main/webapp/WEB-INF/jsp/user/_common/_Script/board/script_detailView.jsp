<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<script type="text/JavaScript" src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script type="text/javascript">
var isAdmin = '${userInfo.isAdmin}';
$(function(){
	cf_movePosition('${currentPosition}');
});

function pf_back(){
	location.href="${mirrorPage }"+pf_getParams();
}

function pf_getParams(){
	var params = ''
	if('${pageIndex}') params += '&pageIndex=${pageIndex}';
	if('${category}') params += '&category=${category}';
	
	if(params) params = '?'+params.slice(1);
	
	return params;
}

// 답글 쓰기
function pf_replyWrite(bnkey){
	
	var reply = '${boardAuthList.reply}';
	if(reply == 'false'){
		if(!cf_checkLogin()){
			return false;
		}
		alert('답글쓰기 권한이 없습니다. 관리자한테 문의하세요.');
		return false;
	}
	$('#BN_KEYNO').val(bnkey);
	$('#actionView').val('insertView');
	$("#Form").attr("action", "${tilesUrl }/BoardData/actionView.do");
	$("#Form").submit();
	
}

//게시글 수정 페이지로 이동
function pf_UpdateView(bnkey){
	actionUrl = '${tilesUrl }/BoardData/actionView.do';
	var pwd = '${BoardNotice.BN_PWD}';
	$('#BN_KEYNO').val(bnkey);
	$("#Form").attr("action", actionUrl);
	if(pwd && !isAdmin){
		pf_openPWD(bnkey);
		return false;
	}
	
	$("#Form").submit();
}

// 게시글 삭제
function pf_deleteMove(bnkey){
	if(confirm("삭제 하시겠습니까?")== true){
		if('${BoardType.BT_DEL_MANAGE_YN}' == 'Y' && '${BoardType.BT_DEL_POLICY}' == 'L'){
			$('#Form').attr('action','${tilesUrl}/Board/'+bnkey+'/deleteView.do');
		}else{
			$("#Form").attr("action", '${tilesUrl }/Board/delete.do');
			$('#BN_KEYNO').val(bnkey);
		}
			var pwd = '${BoardNotice.BN_PWD}';
			if(pwd && !isAdmin){
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

// 파일 미리보기
function pf_preView(obj, fskey){
	var path = $(obj).data('path');		
	var filekey = $(obj).data('key');

	var chk = $(obj).data('chk');
	if("N" == chk) {
		alert('파일 변환 중입니다. 잠시 후 다시 시도해주세요.');
		fileAjax(fskey,obj);
		return false;
	}
	pf_setView(path, filekey);
}

// 미리보기 경로 암호화
function pf_setView(path, filekey){
	cf_loading();
    $.ajax({
        url: '/user/Board/convertAjax.do',
        type: 'POST',
        data: {
        	'enFilePath' : path,
        	'enFileKey' : filekey,
        	'tiles' : '${tiles}'
        },
        async: false,
        success: function(result) {
             if(result){
            		var offset = $('.picture-popUp1').offset();
            		$('.swiper-wrapper').empty();
            		$('.pic-pop-black').fadeIn();
            		$('.swiper-wrapper').append(result);
            	    $('.picture-popUp1').show();
            		$('.openDoor').attr('onclick','window.open().document.write("'+result+'")');
            	    $('html').animate({scrollTop : offset.top}, 800);
            	 
             }else{
            	 alert('오류');
             }
       }
   }).done(function(){
	   cf_loading_out();
   });	 
}

// 변환중인 파일 새로고침
function fileAjax(fskey,obj){
	var test = $(obj).closest('.mgT10');
	  $.ajax({
	        url: '/user/Board/previewAjax.do',
	        type: 'POST',
	        data: {
	        	'filekey' : fskey
	        },
	        async: false,  
	        success: function(data) {
	        	$(obj).closest('.inputBox').empty();
	            var temp =  '<div style="width:100%">';
				$.each(data, function(i){
				files = data[i];
				var fsKey = files.FS_KEYNO
				var orinm = files.FS_ORINM
				var size = files.FS_FILE_SIZE
				var chk = files.FS_CONVERT_CHK
				var path = files.FS_PUBLIC_PATH
				var storage = files.FS_STORAGE
				var encodePath = files.FS_PATH
				var encodePublicPath = files.FS_PUBLIC_PATH
				var ext = (files.FS_EXT).toLowerCase()
				temp +=  '<div style="height:30px">';
				temp += '<a href="javascript:;" onclick="cf_download(\''+fsKey+'\')">';
				temp += '<img src="/resources/img/icon/icon_attachment_01.png" alt="첨부파일 아이콘">'+orinm;
				
				if(size/1024 > 1000){
					temp += '(' +(size/1024/1024).toFixed(1) + 'M)';
				}else{
					temp += '(' + (size/1024).toFixed(1) + 'K)';
				}
				temp += '</a>';
				var ch = 'bmp,jpg,png,gif,jpeg,hwp,pdf,xls,xlsx,doc,docx,ppt,pptx'.indexOf(ext)
				if(ch != -1){
				if(chk == 'Y'){
					var enPath;
					if(!path){
						enPath = encodePath
					}else{
						enPath = encodePublicPath
					}
				temp += '<button style="float:right" type="button" class="btn" data-path="'+enPath+'" data-key="'+fsKey+'" onclick="pf_preView(this, \''+fskey+'\')">미리보기</button>';
				}else{
				temp += '<button style="float:right" type="button" class="btn" data-chk="N" onclick="pf_preView(this, \''+fskey+'\')">미리보기</button>';
				}
				}
				temp += '</div>';
			});
				temp += '</div>';
				test.find('.inputBox').append(temp);
	       }
	   });
}

function sendLinkCustom() {
	
	$.ajax({
		type : "post",
		url : "/allimTalkAjax.do",
		data: {
			"bnkey" : "${BoardNotice.BN_KEYNO}",
			"key" : "${BoardNotice.BN_PLANT_NAME}",
			"title" : "${BoardNotice.BN_TITLE}",
			"name" : "${NowUser}"
		},
		success: function(data){
// 			alert(data)
			location.reload();
		},
		error: function(){
			alert("전송 에러! 관리자에 문의해주세요.");
		}
	});
	
}

</script>
