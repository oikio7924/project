<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>


<script src="/resources/api/uploadfile/jquery.form.js" ></script>

<script>

//리스트로 돌아가기
function pf_back(){
	$("#Form").attr("action", "/dyAdmin/operation/file.do");
	$("#Form").submit();
}


//파일 삭제
function pf_deleteFS(fskey){
	
	if(confirm('해당 첨부파일, 관련 정보를 완전 삭제 하시겠습니까?\n복구하실 수 없습니다.')){
		  cf_loading();
			$.ajax({
	       type   : "post",   
	       url    : "/async/MultiFile/fs/deleteAjax.do",
	       data   : {FS_KEYNO : fskey},
	       success: function(){
    	   	 $('.fileSub_'+fskey).fadeOut(600,function(){
	        	 $(this).remove()
		         cf_loading_out();
	         });
	       },
	       error: function(jqXHR, exception) {
	         cf_loading_out();
	         alert('error')
	       }
	     });
	  }
}

//클립보드 복사 이벤트
$(document).on("click", ".copyToClipboard", function(){
	var target = $(this).find('data');
	if( target.length == 0 ){ target = $(this) }
	var data = target.html().trim();
	cf_copyToClipboard(data);
	cf_smallBox('클립보드에 복사되었습니다.', '(Ctrl + V)로 붙여넣으세요.', 3000);
})

//확장자 체크
function fileManageExtCheck(id,ext,maxSize){
	
	var path =$('#'+id).val();
  if(!path){ // 파일 선택 취소 처리
//     $('#'+id+'_img').attr('src','').hide();
//     $('#'+id).val('')
	  return false;
  }
  var thisExt = path.substring(path.lastIndexOf('.') + 1).toLowerCase(); 
	
	var imgExt = 'gif,jpeg,jpg,png';
	var etcExt = '${sp:getString("FILE_EXT")}'; //파일관리 허용 확장자 임의추가

	var ext = ext || thisExt;
	
	if( imgExt.indexOf(ext) > -1 ){
		cf_imgCheckAndPreview(id,ext,maxSize) //common.js 타입체크&미리보기
		
	}else{
		ext = etcExt 
		cf_fileCheck(id,etcExt,maxSize) //common.js 타입체크
		$('#'+id+'_img').attr('src','').hide(); //미리보기 제거
	}
	
}

//파일 서브(SUB) 폼 valid
function formCheckSub(){
	  if(!cf_checkVal('#insertSubFileForm #FS_COMMENTS','파일설명을 적어주세요.')){
	    return false;
	  }
	  if(!cf_checkVal('#insertSubFileForm #FS_ALT','파일주석을 적어주세요.')){
	    return false;
	  }
	  if(!cf_checkVal('#insertSubFileForm #insertFileSubImg_text','등록할 파일을 선택하여 주세요.')){
	    return false;
	  }
	  
	  /* 이미지 리사이징 체크  */
	  if( $('#insertSubFileForm #RESIZE_WIDTH') ){
	  }
	  
	  return true;
}

//파일 메인(MAIN) 폼 valid
function formCheckMain(){
	  if(!cf_checkVal('#updateMainFileForm #FM_WHERE_KEYS','사용처 추적용 키 목록을 입력해 주세요.')){
	    return false;
	  }
	  if(!cf_checkVal('#updateMainFileForm #FM_COMMENTS','파일 설명을 적어주세요.')){
	    return false;
	  }
	  
	  return true;
}

//파일 서브(SUB) 정보 등록/수정 액션 - 키 유무에 따라 내부 분기됨
function pf_fileSub_insert(){
// alert('인썰트')
	if( formCheckSub() ){
      $('form#insertSubFileForm').attr('action', '/async/MultiFile/single/uploadAjax.do');
      
      var fsKey = $('#insertSubFileForm').find('input[name=FS_KEYNO]').val();
      fsKey = unNumberFormat(fsKey);	
      $('#insertSubFileForm').find('input[name=FS_KEYNO]').val(fsKey);
      
	  $('#insertSubFileForm').ajaxForm({
	      contentType : false,
	      processData: false,
	      enctype: "multipart/form-data",
	      dataType : "POST",
	      dataType : 'json',
	      beforeSubmit: function(data, form, option) {
	          $("#fileSub-insert").dialog("close");
	      },
	      success: function(data) {
	          cf_smallBox('등록완료', '파일이 등록 되었습니다.', 3000);
	          addNewFileSubRow(data.FS_KEYNO);
	      },
	      error: function(x,e){
	          console.log("status : "+x.status);
	          console.log(e);
	      },
	  }).submit();
	}
	
}

//파일 메인(MAIN) 정보 수정액션
function pf_fileMain_update(){
	if( formCheckMain() ){
	  var param = $('#fileMain-update #updateMainFileForm').serialize();
	  htmlAppend('/dyAdmin/operation/file/manage/main/UpdateAjax.do', 'table#fileMain tbody', param, 'outer-change', true, callbackAfterGetFMUpdate);
	}
	
}


//파일 서브(SUB) 등록 다이얼로그 열기
function pf_insertFSDialog(){
	$("#fileSub-insert").find('input:not("#FS_FM_KEYNO")').val('');
	setDefaultValue_FSDialog();
	$('#insertFileSubImg_img').attr('src','').hide(); //미리보기 제거
	$("#fileSub-insert")
	.dialog('option','title', '파일 신규등록')
	.dialog("open");
}

//파일 서브(SUB) 수정 다이얼로그 열기
function pf_updateFSDialog(key){
	$("#fileSub-insert").find('input:not("#FS_FM_KEYNO")').val('');
	setDefaultValue_FSDialog();
	$('#insertFileSubImg_img').attr('src','').hide(); //미리보기 제거
	
	/* 데이터주입  */
	$("#fileSub-insert #FS_KEYNO").val(key);
	$("#fileSub-insert #FS_COMMENTS").val( $('.fileSub_'+key).find('.VAL_COMMENTS').html() );
	$("#fileSub-insert #FS_ALT").val( $('.fileSub_'+key).find('.VAL_ALT').html() );
	$("#fileSub-insert #insertFileSubImg_text").val( $('.fileSub_'+key).find('.VAL_FILE_ORINM').html() );
	
	$("#fileSub-insert")
	.dialog('option','title', '파일 변경')
	.dialog("open");
	
}

//FS 다이얼로그 form 초기화 관련 공통
function setDefaultValue_FSDialog(){
	$('#fileSub-insert #IS_RESIZE').val(true).prop('checked',false);
	$('#fileSub-insert #IS_MAKE_THUMBNAIL').val(true).prop('checked',false);
	$('#fileSub-insert .defaultValueIsZero').val(0);
	$('#fileSub-insert .defaultValueIsZero').val(0);
}

//파일 메인(MAIN) 수정 다이얼로그 열기
function pf_updateFMDialog(){
	/* 데이터주입  */
  $("#fileMain-update #FM_WHERE_KEYS").val( $('#fileMain').find('#VAL_FM_WHERE_KEYS').html() );
  $("#fileMain-update #FM_COMMENTS").val( $('#fileMain').find('#VAL_FM_COMMENTS').html() );
	  
	$("#fileMain-update")
	.dialog('option','title', '파일 메인 변경')
	.dialog("open");
}

$(function(){
	
  //첫 서브페이지 ajax호출
  var fmKey = cf_setKeyno($('#FM_KEYNO').val());
  var param = 'fmKey='+fmKey;
  htmlAppend('/dyAdmin/operation/file/subListAjax.do', '.fileSubList tbody', param, 'inner-append', false, callbackAfterGetFS);
	
	//파일서브 수정 다이얼로그 생성
  cf_setttingDialog("#fileSub-insert", "파일 추가", "등록", "pf_fileSub_insert()");
  cf_setttingDialog("#fileMain-update", "파일 메인 수정", "변경", "pf_fileMain_update()");
	
})


///////////////////////////////////////////////////////// 
//// 비동기 처리 관련 
/////////////////////////////////////////////////////////
 
//목록에 새 Row 추가 - 추가등록/수정
function addNewFileSubRow(fsKeyno){
	var key = cf_setKeyno(fsKeyno);
  var oldRowClass = '.fileSubList tbody .fileSub_'+key;
  var isNew = $(oldRowClass).length == 0 ? true : false; //신규등록인지 수정인지 확인
  
  var param = 'fsKey='+key;
  if( isNew ){
	  htmlAppend('/dyAdmin/operation/file/subListAjax.do', '.fileSubList tbody', param, 'inner-append', true, callbackAfterGetFS, key);
  }else{
	  htmlAppend('/dyAdmin/operation/file/subListAjax.do', '.fileSubList tbody .fileSub_'+key, param, 'outer-change', true, callbackAfterGetFSUpdate, key);
  }
}

//FS 신규등록 ajax처리 후 callback
function callbackAfterGetFS(result, key){
  refreshAttachNum();
}

//FS 수정 ajax처리 후 callback
function callbackAfterGetFSUpdate(result, key){
// 	alert('key : ' + key + ' // ' + $('.fileSubList tbody .fileSub_'+key+' img').length )
  $('.fileSubList tbody .fileSub_'+key+' img.fileSubImg').each(function(){
		imgReload(this, 3000); //이미지 파일명이 동일하여 캐쉬를 참조하게 되는 문제 때문에 사용
  })
  refreshAttachNum();
}

//FM 수정 ajax처리 후 callback
function callbackAfterGetFMUpdate(result){
	cf_smallBox('수정완료', '파일 메인정보 수정이 완료되었습니다.', 3000);
	cf_loading_out();
	$("#fileMain-update").dialog("close");
}

//컬럼 카운팅 초기화
function refreshAttachNum(){
  $(document).find('.fileSubCnt').each(function(index, element){
    $(this).html(index+1);
  })
}


/* 
 * 이미지 재호출 요청
 * dom : 이미지객체
 * delay_ms : 딜레이 millisecond
 * end : 최대 반복 횟수 - 기본값 3회
 */
function imgReload(dom, delay_ms, end){
	$(dom).attr('onerror',null);
	if( typeof end == 'undefined' ){ end = 3; }
	var begin = 1;
	imgReload_recur(dom, delay_ms, end, begin);
	
	//이미지갱신 재귀함수
	function imgReload_recur(dom, delay_ms, end, begin){
		if( begin == 1 || ( !imgLoaded(dom) && begin <= end ) ){
			$(dom).attr('src',$(dom).attr('src')+'?'+begin);
			begin++;
			setTimeout(function(){
	      imgReload_recur(dom, delay_ms, end, begin);
	    }, delay_ms);
		}
	}
	//이미지 로드 여부체크
	function imgLoaded(dom) {
	  return dom.complete && dom.naturalHeight !== 0;
	}
}


//이미지 가로*세로 길이 출력 - gcd() 최대공약수 구하는 함수 의존성
function getOriginWidthHeight(dom){
	var width = $(dom).prop('naturalWidth');
	var height = $(dom).prop('naturalHeight');
	var gcdVal = gcd(width,height);
  if( $(dom).next('.imgOriginSizeView').length == 0 ){
	  $(dom).after('<div class="imgOriginSizeView"></div>');
  }
	$(dom).next('.imgOriginSizeView').html(width+' x '+height+' ( '+width/gcdVal+' : '+height/gcdVal+' )');
	var ori_width = $(dom).data('ori-width');
	var ori_height = $(dom).data('ori-height');
	if( ori_width && ori_height ){
		var sizeView = $(dom).next('.imgOriginSizeView');		
		var ori_gcdVal = gcd(ori_width,ori_height);
	  if( sizeView.next('.sizeBeforeResizing').length == 0 ){
		  sizeView.after('<div class="sizeBeforeResizing"></div>');
	  }
	  sizeView.next('.sizeBeforeResizing')
	  .html('리사이즈 전 : ' + ori_width+' x '+ori_height+' ( '+ori_width/ori_gcdVal+' : '+ori_height/ori_gcdVal+' )');
	}
	//최대공약수 binary방식
	function gcd(u,v){if(u===v)return u;if(u===0)return v;if(v===0)return u;
	if(~u&1){if(v&1){return gcd(u>>1,v)}else{return gcd(u>>1,v>>1)<<1}}
	if(~v&1){return gcd(u,v>>1)}if(u>v){return gcd((u-v)>>1,v)}return gcd((v-u)>>1,u)}
}

</script>
<style>
.copyToClipboard {color:#3276b1; cursor:pointer;}
.imgMain { width: auto; max-width: 100%; height: auto; max-height: 450px; }
.imgThumb { width:auto; max-width:100%; height: auto; max-height:100px; }
.imgOriginSizeView {font-size:15px;}
.sizeBeforeResizing {color:#999;}
.checkOnOff {width:10%; min-width:50px; cursor:pointer;}
</style>
<!-- widget grid -->
<div id="content">
	<section id="widget-grid" >
    <div class="row">
      <article class="col-sm-12 col-md-12 col-lg-12">
        <div class="jarviswidget jarviswidget-color-blueDark" id="wid-id-11" data-widget-colorbutton="false" data-widget-colorbutton="false" data-widget-editbutton="false" data-widget-togglebutton="false" data-widget-deletebutton="false" data-widget-fullscreenbutton="false" data-widget-custombutton="false">
          <header>
            <span class="widget-icon"> <i class="fa fa-lg fa-desktop"></i> </span>
            <h2>파일관리 정보</h2>
          </header>
          <!-- widget div-->
          <div>
            <!-- widget edit box -->
            <div class="jarviswidget-editbox">
            <!-- This area used as dropdown edit box -->
            </div>
            <!-- end widget edit box -->
          
            <!-- widget content -->
            <div class="widget-body">
              <!-- widget body text-->
                      
              <div class="tab-content">
                <div class="tab-pane fade in active" id="hr1">
                  <h6 class="alert alert-info"> <button type="button" class="close" data-dismiss="alert">×</button>
                  파일관리 상세 정보를 확인합니다.</h6>
                  <div class="widget-body">
                    <form:form id="Form" class="" action="" method="post">
                      <input type="hidden" name="pageIndex" id="pageIndex" value="${search.pageIndex}">
											<input type="hidden" name="orderBy" id="orderBy" value="${search.orderBy }">
											<input type="hidden" name="sortDirect" id="sortDirect"  value="${search.sortDirect }">
                    </form:form>
                    <table id="fileMain" class="table table-bordered table-striped fileMainList" style="clear: both">
                      <colgroup>
                        <col style="width: 10%;">
                        <col style="width: 90%;">
                      </colgroup>
                      <%@ include file="/WEB-INF/jsp/dyAdmin/operation/file/manage/pra_fileManageDetailMainAjax.jsp" %>
                      <tfoot>
	                      <tr>
	                        <td colspan="2" class="text-align-right">
	                         <button class="btn btn-sm btn-primary" id="fileManage_edit" type="button" onclick="pf_updateFMDialog()"> 
			                      <i class="fa fa-floppy-o"></i> 메인정보 수정
			                    </button>
	                        </td>
	                      </tr>
                      </tfoot>
                    </table>
                    <br/>
                    <table id="fileSub" class="table table-bordered table-striped fileSubList" style="clear: both">
                      <colgroup>
                        <col style="width: 10%;">
                        <col style="width: 90%;">
                      </colgroup>
                      <tbody>
                        <%@ include file="/WEB-INF/jsp/dyAdmin/operation/file/manage/pra_fileManageDetailSubAjax.jsp" %>
                      </tbody>
                    </table>
                  </div>
              <div class="form-actions">
                <div class="row">
                  <div class="col-md-12">
                    <button class="btn btn-sm btn-primary" id="fileManage_insert" type="button" onclick="pf_insertFSDialog()"> 
	                    <i class="fa fa-floppy-o"></i> 파일 추가
	                  </button>
                    <button class="btn btn-default" type="button" onclick="pf_back()">
                      <i class="fa fa-times"></i> 목록
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
          </div>
        </div>
      </div>
    </article>
  </div>
  </section>
</div>



<div id="fileSub-insert" title="파일 등록">
  <form:form id="insertSubFileForm" class="" action="" method="post" enctype="multipart/form-data">
	  <div class="widget-body ">
	    <fieldset>
	      <div class="form-horizontal">
	        <div class="bs-example necessT">
	               <span class="colorR fs12">*표시는 필수 입력 항목입니다.</span>
	          </div>
	        <fieldset>
	          <div class="form-group">
	            <label class="col-md-3 control-label"><span class="nessSpan">*</span> 파일 메인키</label>
	            <div class="col-md-6">
	              <input type="text" class="form-control" name="FS_FM_KEYNO" id="FS_FM_KEYNO" value="${fileMain.FM_KEYNO}" maxlength="30" readonly>
	            </div>
	          </div>
	          <div class="form-group">
	            <label class="col-md-3 control-label"><span class="nessSpan">*</span> 파일 서브키</label>
	            <div class="col-md-6">
	              <input type="text" class="form-control" name="FS_KEYNO" id="FS_KEYNO" value="" maxlength="30" readonly>
	            </div>
	          </div>
	          <div class="form-group">
	            <label class="col-md-3 control-label"><span class="nessSpan">*</span> 파일설명</label>
	            <div class="col-md-6">
	              <input type="text" class="form-control" name="FS_COMMENTS" id="FS_COMMENTS" value="" maxlength="100">
	            </div>
	          </div>
	          <div class="form-group">
	            <label class="col-md-3 control-label"><span class="nessSpan">*</span> 파일주석(이미지 ALT)</label>
	            <div class="col-md-6">
	              <input type="text" class="form-control" name="FS_ALT" id="FS_ALT" value="" maxlength="100">
	            </div>
	          </div>
	          <div class="form-group">
	            <label class="col-md-3 control-label"> 이미지 리사이징</label>
	            <div class="col-md-6">
	              <input type="checkbox" class="form-control" name="IS_RESIZE" id="IS_RESIZE" class="checkOnOff" value="true">
	            </div>
	          </div>
	          <div id="IS_RESIZE_GROUP">
		          <div class="form-group">
		            <label class="col-md-3 control-label"> 리사이즈 가로크기(px)</label>
		            <div class="col-md-6">
		              <input type="number" class="form-control defaultValueIsZero" name="RESIZE_WIDTH" id="RESIZE_WIDTH" onkeydown="return cf_only_Num(event);">
		            </div>
		          </div>
		          <div class="form-group">
		            <label class="col-md-3 control-label"> 리사이즈 세로크기(px)</label>
		            <div class="col-md-6">
		              <input type="number" class="form-control defaultValueIsZero" name="RESIZE_HEIGHT" id="RESIZE_HEIGHT" onkeydown="return cf_only_Num(event);">
		            </div>
		          </div>
	          </div>
	          <div class="form-group">
	            <label class="col-md-3 control-label"> 이미지 썸네일 생성</label>
	            <div class="col-md-6">
	              <input type="checkbox" class="form-control" name="IS_MAKE_THUMBNAIL" id="IS_MAKE_THUMBNAIL" class="checkOnOff" value="true">
	            </div>
	          </div>
	          <div id="IS_RESIZE_GROUP">
		          <div class="form-group">
		            <label class="col-md-3 control-label"> 썸네일 가로크기(px)</label>
		            <div class="col-md-6">
		              <input type="number" class="form-control defaultValueIsZero" name="THUMB_WIDTH" id="THUMB_WIDTH" onkeydown="return cf_only_Num(event);">
		            </div>
		          </div>
		          <div class="form-group">
		            <label class="col-md-3 control-label"> 썸네일 세로크기(px)</label>
		            <div class="col-md-6">
		              <input type="number" class="form-control defaultValueIsZero" name="THUMB_HEIGHT" id="THUMB_HEIGHT" onkeydown="return cf_only_Num(event);">
		            </div>
		          </div>
	          </div>
	          <div class="form-group">
	            <label class="col-md-3 control-label"><span class="nessSpan">*</span> 파일</label>
	            <div class="smart-form col-md-6 col-lg-6">
                <label class="input input-file">
	                <span class="button">
	                  <input type="file" name="file" id="insertFileSubImg" onchange="fileManageExtCheck('insertFileSubImg')">찾기
	                </span>
	                <input type="text" readonly="" id="insertFileSubImg_text" placeholder="파일을 선택하여주세요." value="">
	              </label>
	              <div class="imgWrap" style="width:200px;margin:10px auto;">
	                <c:if test="${not empty resultData.FS_KEYNO }">
	                  <img id="insertFileSubImg_img" src="/resources/img/upload/${resultData.FS_FOLDER }${resultData.FS_CHANGENM }.${resultData.FS_EXT }" alt="미리보기" style="max-width:100%;max-height:300px;">
	                </c:if>
	                <c:if test="${empty resultData.FS_KEYNO }">
	                  <img id="insertFileSubImg_img" alt="미리보기" style="display:none;max-width:100%;max-height:300px;">
	                </c:if>
	              </div>
	            </div>
	          </div>
	        </fieldset>
	      </div>
	    </fieldset>
	  </div>
  </form:form>
</div>

<div id="fileMain-update" title="파일 메인 수정">
  <form:form id="updateMainFileForm" class="" action="" method="post" enctype="multipart/form-data">
	  <div class="widget-body ">
	    <fieldset>
	      <div class="form-horizontal">
	        <div class="bs-example necessT">
	               <span class="colorR fs12">*표시는 필수 입력 항목입니다.</span>
	          </div>
	        <fieldset>
	          <div class="form-group">
	            <label class="col-md-3 control-label"><span class="nessSpan">*</span> 파일 메인키</label>
	            <div class="col-md-6">
	              <input type="text" class="form-control" name="FM_KEYNO" id="FM_KEYNO" value="${fileMain.FM_KEYNO}" maxlength="30" readonly>
	            </div>
	          </div>
	          <div class="form-group">
	            <label class="col-md-3 control-label"><span class="nessSpan">*</span> 사용처</label>
	            <div class="col-md-6">
	              <input type="text" class="form-control" name="FM_WHERE_KEYS" id="FM_WHERE_KEYS" value="" maxlength="30">
	            </div>
	          </div>
	          <div class="form-group">
	            <label class="col-md-3 control-label"><span class="nessSpan">*</span> 파일설명</label>
	            <div class="col-md-6">
	              <input type="text" class="form-control" name="FM_COMMENTS" id="FM_COMMENTS" value="" maxlength="30">
	            </div>
	          </div>
	        </fieldset>
	      </div>
	    </fieldset>
	  </div>
  </form:form>
</div>

