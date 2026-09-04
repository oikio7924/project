<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<!-- widget grid -->
<form:form id="Form" name="Form" method="post" action="" class="form-inline" role="form">
<input type="hidden" id="key" name="key" value="" />
<section id="widget-grid" class="">
	<div class="row">
		<article class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
			<!-- Widget ID (each widget will need unique ID)-->
			<div class="jarviswidget jarviswidget-color-blueDark" id="wid-id-0"
				data-widget-editbutton="false">
				<header>
					<span class="widget-icon"> <i class="fa fa-table"></i>
					</span>
					<h2>업로드 파일 관리</h2>
				</header>
				<div class="widget-body" >
					<div class="widget-body-toolbar bg-color-white">
						<div class="alert alert-info no-margin fade in">
							<button type="button" class="close" data-dismiss="alert">×</button>
							업로드 파일을 관리합니다.
						</div> 
					</div>
					<div class="widget-body-toolbar bg-color-white">
						<div class="row"> 
							<div class="col-sm-12 col-md-2 text-align-right" style="float:right;">
								<div class="btn-group">  
									<button class="btn btn-sm btn-primary" type="button" onclick="pf_insertFSDialog();" >
										<i class="fa fa-plus"></i>파일 등록
									</button>
								</div>
							</div>
						</div>
					</div>
					<div class="table-responsive">
						<jsp:include page="/WEB-INF/jsp/dyAdmin/include/search/pra_search_header_paging.jsp" flush="true">
							<jsp:param value="/dyAdmin/operation/file/manage/pagingAjax.do" name="pagingDataUrl" />
							<jsp:param value="/dyAdmin/operation/file/manage/excelAjax.do" name="excelDataUrl" />
							
							<jsp:param value="${search.pageIndex }" name="pageIndex" />
							<jsp:param value="${search.orderBy }" name="orderBy" />
							<jsp:param value="${search.sortDirect }" name="sortDirect" />
							
						</jsp:include>
						<fieldset id="tableWrap">
						</fieldset>
					</div>
				</div>
			</div>
		</article>
	</div>
</section>

</form:form>
<!-- end widget grid -->

<div id="fileMain-insert" title="파일 등록">
  <form:form id="insertSubFileForm" class="" action="" method="post" enctype="multipart/form-data">
    <div class="widget-body ">
      <fieldset>
        <div class="form-horizontal">
          <div class="bs-example necessT">
                 <span class="colorR fs12">*표시는 필수 입력 항목입니다.</span>
            </div>
          <fieldset>
            <div class="form-group">
              <label class="col-md-3 control-label"><span class="nessSpan">*</span> 파일 메인 설명</label>
              <div class="col-md-6">
                <input type="text" class="form-control" name="FM_COMMENTS" id="FM_COMMENTS" placeholder="파일들에 대한 설명을 적어주세요." value="" maxlength="100" >
              </div>
            </div>
            <div class="form-group">
              <label class="col-md-3 control-label"> 사용처 추적용 키 목록</label>
              <div class="col-md-6">
                <input type="text" class="form-control" name="FM_WHERE_KEYS" id="FM_WHERE_KEYS" value="" placeholder="파일들이 사용될 페이지의 메인키 Code를 입력해 주세요." maxlength="100">
              </div>
            </div>
          </fieldset>
        </div>
      </fieldset>
    </div>
  </form:form>
</div>

<script src="/resources/api/uploadfile/jquery.form.js" ></script>
<script>
//파일 추가
function pf_openAddFile(key){
	if(key != null && key != ""){
// 		$('#Form').attr('action', "/dyAdmin/operation/file/manage/detailView.do?key="+key);
		$('#Form').attr('action', "/dyAdmin/operation/file/manage/detailView.do");
		$('#Form #key').val(key);
		$('#Form').submit();
// 		location.href="/dyAdmin/operation/file/manage/detailView.do?key="+key;		
	}else{
		alert('부적절한 key값을 가지고 있습니다.')
	}
}

function pf_fileMain_insert(){

	  if( formCheck() ){
	    
	    cf_loading();
	    $('form#insertSubFileForm').attr('action', '/dyAdmin/operation/file/manage/mainInsertAjax.do');
	    
	    $('#insertSubFileForm').ajaxForm({
	        contentType : false,
	        processData: false,
	        enctype: "multipart/form-data",
	        dataType : "POST",
	        dataType : 'json',
	        beforeSubmit: function(data, form, option) {
	            $("#fileMain-insert").dialog("close");
	        },
	        success: function(data) {
	            pf_openAddFile( cf_setKeyno(data.FM_KEYNO) );
	            cf_loading_out();
	        },
	        error: function(x,e){
	            console.log("status : "+x.status);
	            console.log(e);
	        },
	    }).submit();
	    
	}
}

function formCheck(){
	if(!cf_checkVal('#insertSubFileForm #FM_COMMENTS','파일들에 대한 설명을 적어주세요.')){
	  return false;
	}
	
	return true;
}

//파일 메인 등록 다이얼로그
function pf_insertFSDialog(){
  $("#fileMain-insert").find('input:not("#FS_FM_KEYNO")').val('');
  $("#fileMain-insert")
	  .dialog("open");
}

$(function(){
	  //파일서브 수정 다이얼로그 생성
	  cf_setttingDialog("#fileMain-insert", "파일 메인 신규추가", "등록", "pf_fileMain_insert()");
	})

</script>
