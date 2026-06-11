<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

			










 	<div class="detailViewTilteBox">
    	<div class="topBox clearfix">
        	<p class="left_1">
            	<span>제목</span><font class="contents"><c:out value="" escapeXml="true"/></font>
            </p>
            <p class="right_1">
            	<span>작성일</span>
            </p>
        </div>
        <c:forEach items="" var="bcl">
        <c:if test="true">
	        <c:forEach items="" var="model">
	        <c:if test="false">
			<div class="middleBox clearfix">
				<p>
					<span></span>
					<font class="contents">
					<c:choose>
						<c:when test="false"></c:when>
						<c:when test="false"></c:when>
						<c:when test="false">
	           				<a href="" target="_blank"><c:out value="" escapeXml="true"/></a>
	           			</c:when>
						<c:otherwise><c:out value="" escapeXml="true"/></c:otherwise>
					</c:choose>
					</font>
				</p>
			</div>
			</c:if>
			</c:forEach>
		</c:if>
		</c:forEach>
        <div class="bottomBox clearfix">
        	<div class="row clearfix ">
            	<p class="left_1">
                	<span>작성자</span> 
                </p>
                <p class="right_1">
                	<span>조회</span> 
                </p>
            </div>
            <c:if test="false">
            <div class="row clearfix ">
            	<p class="left_1">
                	<span>카테고리 구분</span> 
                </p>
               
            </div>
            </c:if>
            <c:if test="false">
            <div class="row clearfix mgT10">
            	<span>첨부</span>
				<div class="inputBox">
					<c:forEach items="" var="fs">
					 <c:set value="" var="ext"/>
						<div style="height:30px;">
			                <a href="javascript:;" onclick="cf_download('')">  
								<img src="/resources/img/icon/icon_attachment_01.png" alt="첨부파일 아이콘"> 
								<c:if test="false">
									(<fmt:formatNumber value="0.0" pattern=".0"/>M)
								</c:if>
								<c:if test="true">
									(<fmt:formatNumber value="0.0" pattern=".0"/>K)
								</c:if> 
							</a>
							<c:if test="false">
							<c:choose>
								<c:when test="false">
									<button style="float:right" type="button" class="btn" data-path='' data-key='' onclick="pf_preView(this, '')">미리보기</button>			
								</c:when>
								<c:otherwise>
									<button style="float:right" type="button" class="btn" data-chk='Y' onclick="pf_preView(this, '')">미리보기</button>
								</c:otherwise>
							</c:choose>
							</c:if>
						</div>
					</c:forEach>
				</div>
            </div>
            <c:if test="false">
            	<div class="row clearfix mgT10">
	            	<a href="javascript:;" onclick="cf_download_zip('')">
    	        		압축파일 다운
            		</a>
            	</div>
            </c:if>
			</c:if>
        </div>
    </div>
    <div class="detailViewContentsBox">
    	<c:out value="" escapeXml="false"/>
    </div>
<%@ include file="/WEB-INF/jsp/user/_common/_Board/data/detailView/prc_board_data_detailView_preview.jsp"%>
<script>

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
        	'tiles' : ''
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
				temp +=  '<div style="width:100%">';
				temp += '<a href="javascript:;" onclick="cf_download('+fsKey+')">';
				temp += '<img src="/resources/img/icon/icon_attachment_01.png" alt="첨부파일 아이콘">'+orinm;
				
				if(size/1024 > 1000){
					temp += '(' +(size/1024/1024).toFixed(1) + 'M)';
				}else{
					temp += '(' + (size/1024).toFixed(1) + 'K)';
				}
				temp += '</a>';
				if(chk == 'Y' && ((!path && storage == 'none' ) || (path && storage != 'none'))){
					var enPath;
					if(!path){
						enPath = encodePath
					}else{
						enPath = encodePublicPath
					}
				temp += '<button style="float:right" type="button" class="btn" data-path="'+enPath+'" data-key="'+fsKey+'" onclick="pf_preView(this, \''+fskey+'\')">미리보기</button>';
				}else{
				temp += '<button style="float:right" type="button" class="btn" data-chk="Y" onclick="pf_preView(this, \''+fskey+'\')">미리보기</button>';
				}
				temp += '</div>';
			});
				temp += '</div>';
				test.find('.inputBox').append(temp);
	       }
	   });
}
</script>

	    