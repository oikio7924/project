<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

 	&lt;div class="detailViewTilteBox"&gt;
    	&lt;div class="topBox clearfix"&gt;
        	&lt;p class="left_1"&gt;
            	&lt;span&gt;제목&lt;/span&gt;&lt;font class="contents"&gt;&lt;c:out value="${BoardNotice.BN_TITLE}" escapeXml="true"/&gt;&lt;/font&gt;
            &lt;/p&gt;
            &lt;p class="right_1"&gt;
            	&lt;span&gt;작성일&lt;/span&gt;${fn:substring(BoardNotice.BN_REGDT,0,10) }
            &lt;/p&gt;
        &lt;/div&gt;
        &lt;c:forEach items="${BoardColumnList }" var="bcl"&gt;
        &lt;c:if test="${bcl.BL_TYPE ne sp:getData('BOARD_COLUMN_TYPE_TITLE')}"&gt;
	        &lt;c:forEach items="${BoardColumnDataList }" var="model"&gt;
	        &lt;c:if test="${not empty model.BD_DATA && bcl.BL_KEYNO eq model.BD_BL_KEYNO}"&gt;
			&lt;div class="middleBox clearfix"&gt;
				&lt;p&gt;
					&lt;span&gt;${model.COLUMN_NAME }&lt;/span&gt;
					&lt;font class="contents"&gt;
					&lt;c:choose&gt;
						&lt;c:when test="${model.BD_BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_CHECK') }"&gt;${fn:replace(model.BD_DATA,'|',',' ) }&lt;/c:when&gt;
						&lt;c:when test="${model.BD_BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_CHECK_CODE') }"&gt;${fn:replace(model.BD_DATA,'|',',' ) }&lt;/c:when&gt;
						&lt;c:when test="${model.BD_BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_LINK')}"&gt;
	           				&lt;a href="${model.BD_DATA }" target="_blank"&gt;&lt;c:out value="${model.BD_DATA }" escapeXml="true"/&gt;&lt;/a&gt;
	           			&lt;/c:when&gt;
						&lt;c:otherwise&gt;&lt;c:out value="${model.BD_DATA }" escapeXml="true"/&gt;&lt;/c:otherwise&gt;
					&lt;/c:choose&gt;
					&lt;/font&gt;
				&lt;/p&gt;
			&lt;/div&gt;
			&lt;/c:if&gt;
			&lt;/c:forEach&gt;
		&lt;/c:if&gt;
		&lt;/c:forEach&gt;
        &lt;div class="bottomBox clearfix"&gt;
        	&lt;div class="row clearfix "&gt;
            	&lt;p class="left_1"&gt;
                	&lt;span&gt;작성자&lt;/span&gt; ${BoardNotice.BN_UI_NAME }
                &lt;/p&gt;
                &lt;p class="right_1"&gt;
                	&lt;span&gt;조회&lt;/span&gt; ${BoardNotice.BN_HITS }
                &lt;/p&gt;
            &lt;/div&gt;
            &lt;c:if test="${'Y'eq BoardType.BT_CATEGORY_YN }"&gt;
            &lt;div class="row clearfix "&gt;
            	&lt;p class="left_1"&gt;
                	&lt;span&gt;카테고리 구분&lt;/span&gt; ${BoardNotice.BN_CATEGORY_NAME }
                &lt;/p&gt;
               
            &lt;/div&gt;
            &lt;/c:if&gt;
            &lt;c:if test="${BoardType.BT_UPLOAD_YN eq 'Y' && fn:length(FileSub) gt 0 }"&gt;
            &lt;div class="row clearfix mgT10"&gt;
            	&lt;span&gt;첨부&lt;/span&gt;
				&lt;div class="inputBox"&gt;
					&lt;c:forEach items="${FileSub}" var="fs"&gt;
					 &lt;c:set value="${fn:toLowerCase(fs.FS_EXT) }" var="ext"/&gt;
						&lt;div style="height:30px;"&gt;
			                &lt;a href="javascript:;" onclick="cf_download('${fs.encodeFsKey}')"&gt;  
								&lt;img src="/resources/img/icon/icon_attachment_01.png" alt="첨부파일 아이콘"&gt; ${fs.FS_ORINM }
								&lt;c:if test="${fs.FS_FILE_SIZE / 1024  gt 1000}"&gt;
									(&lt;fmt:formatNumber value="${fs.FS_FILE_SIZE / 1024 / 1024 }" pattern=".0"/&gt;M)
								&lt;/c:if&gt;
								&lt;c:if test="${fs.FS_FILE_SIZE / 1000  le 1000}"&gt;
									(&lt;fmt:formatNumber value="${fs.FS_FILE_SIZE / 1024 }" pattern=".0"/&gt;K)
								&lt;/c:if&gt; 
							&lt;/a&gt;
							&lt;c:if test="${fn:contains('bmp,jpg,png,gif,jpeg,hwp,pdf,xls,xlsx,doc,docx,ppt,pptx,txt', ext) && BoardType.BT_PREVIEW_YN eq 'Y'}"&gt;
							&lt;c:choose&gt;
								&lt;c:when test="${fs.FS_CONVERT_CHK eq 'Y' }"&gt;
									&lt;button style="float:right" type="button" class="btn" data-path='${empty fs.FS_PUBLIC_PATH ? fs.encodePath : fs.encodePublicPath}' data-key='${fs.encodeFsKey}' onclick="pf_preView(this, '${fs.encodeFsKey }')"&gt;미리보기&lt;/button&gt;			
								&lt;/c:when&gt;
								&lt;c:otherwise&gt;
									&lt;button style="float:right" type="button" class="btn" data-chk='N' onclick="pf_preView(this, '${fs.encodeFsKey }')"&gt;미리보기&lt;/button&gt;
								&lt;/c:otherwise&gt;
							&lt;/c:choose&gt;
							&lt;/c:if&gt;
						&lt;/div&gt;
					&lt;/c:forEach&gt;
				&lt;/div&gt;
            &lt;/div&gt;
            &lt;c:if test="${BoardType.BT_ZIP_YN eq 'Y'  && fn:length(FileSub) gt 1 }"&gt;
            	&lt;div class="row clearfix mgT10"&gt;
	            	&lt;a href="javascript:;" onclick="cf_download_zip('${FileSub.get(0).encodeFsFmKey}')"&gt;
    	        		압축파일 다운
            		&lt;/a&gt;
            	&lt;/div&gt;
            &lt;/c:if&gt;
			&lt;/c:if&gt;
        &lt;/div&gt;
    &lt;/div&gt;
    &lt;div class="detailViewContentsBox"&gt;
    	&lt;c:out value="${BoardNotice.BN_CONTENTS }" escapeXml="false"/&gt;
    &lt;/div&gt;
&lt;%@ include file="/WEB-INF/jsp/user/_common/_Board/data/detailView/prc_board_data_detailView_preview.jsp"%&gt;
&lt;script&gt;

//파일 미리보기
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

//미리보기 경로 암호화
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
	            var temp =  '&lt;div style="width:100%"&gt;';
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
				temp +=  '&lt;div style="width:100%"&gt;';
				temp += '&lt;a href="javascript:;" onclick="cf_download(\''+fskey+'\')"&gt;';
				temp += '&lt;img src="/resources/img/icon/icon_attachment_01.png" alt="첨부파일 아이콘"&gt;'+orinm;
				
				if(size/1024 &gt; 1000){
					temp += '(' +(size/1024/1024).toFixed(1) + 'M)';
				}else{
					temp += '(' + (size/1024).toFixed(1) + 'K)';
				}
				temp += '&lt;/a&gt;';
				if(chk == 'Y'){
					var enPath;
					if(!path){
						enPath = encodePath
					}else{
						enPath = encodePublicPath
					}
				temp += '&lt;button style="float:right" type="button" class="btn" data-path="'+enPath+'" data-key="'+fsKey+'" onclick="pf_preView(this, \''+fskey+'\')"&gt;미리보기&lt;/button&gt;';
				}else{
				temp += '&lt;button style="float:right" type="button" class="btn" data-chk="N" onclick="pf_preView(this, \''+fskey+'\')"&gt;미리보기&lt;/button&gt;';
				}
				temp += '&lt;/div&gt;';
			});
				temp += '&lt;/div&gt;';
				test.find('.inputBox').append(temp);
	       }
	   });
}
&lt;/script&gt;
