<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<script type="text/javascript">
//전역변수선언
var editor_object = [];

$(function(){
	/* 팝업 */
	cf_setttingDialog('#page_comment','개인정보노출이 불가합니다');
});
 
//개인정보보안 여부체크 되었을 때 게시판 
function pf_PersonalCheck(){
	var temp;
	var temp2;	
	$.ajax({
		    type   : "post",
		    url    : "/common/Board/data/checkPersonalAjax.do",
		    async  : false,
		    data   : {	
		    			 "BN_CONTENTS" 		: $("#BN_CONTENTS").val(), 
    					 "BT_KEYNO"		: '${BoardType.BT_KEYNO}'
		    		 },
		
		    success:function(data){
		    	temp = data.resultBoolean
		    	temp2 = data.resultArray
		 
		    	$('.Menu_name').text('')	    		
		    	if(data.resultBoolean == false){
		    		$('.Menu_name').text(temp2)
		    	} 	
		    },
		    error: function(jqXHR, textStatus, exception) {
		    	alert('에러!! 관리자한테 문의하세요');
		    	
		    }
		 });
	 
	 return temp;
 }	

$(function(){
	
	if(webEditUseYn){
	    nhn.husky.EZCreator.createInIFrame({
	        oAppRef: editor_object,
	        elPlaceHolder: "BN_CONTENTS",
	        sSkinURI: "/resources/api/se2/se2Skin.html",
	        htParams : {
	            // 툴바 사용 여부 (true:사용/ false:사용하지 않음)
	            	bUseToolbar : webEditUseYn,   
	            // 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
	            bUseVerticalResizer : webEditUseYn,    
	            // 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
	            bUseModeChanger : webEditUseYn
	        },
	        menuName : '${currentMenu.MN_NAME}' //본문에 이미지 저장시 사용되는 캡션
	    });
	}
    
    $("iframe").attr("title","네이버 에디터");

});

</script>
