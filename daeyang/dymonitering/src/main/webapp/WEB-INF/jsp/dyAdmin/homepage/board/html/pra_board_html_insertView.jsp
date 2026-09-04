<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<script type="text/javascript" src="/resources/api/se2/js/HuskyEZCreator.js" charset="utf-8"></script>
<script type="text/javascript">
var editor_object = [];
$(function(){
	
	nhn.husky.EZCreator.createInIFrame({
        oAppRef: editor_object,
        elPlaceHolder: "BIH_CONTENTS",
        sSkinURI: "/resources/api/se2/se2Skin.html",
        htParams : {
            // 툴바 사용 여부 (true:사용/ false:사용하지 않음)
            bUseToolbar : true,            
            // 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
            bUseVerticalResizer : true,    
            // 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
            bUseModeChanger : true,
        },
        menuName : '게시판 html' //본문에 이미지 저장시 사용되는 캡션
    });
	
	
	
	cf_radio_checked("BIH_DIV_LOCATION", "${BoardHtml.BIH_DIV_LOCATION }");
})

function pf_boardHtmlInsert(){
	//웹에디터 내용 textarea로 복사
	editor_object.getById["BIH_CONTENTS"].exec("UPDATE_CONTENTS_FIELD", []);
	$("#Form").attr("action","/dyAdmin/homepage/board/data/html/insert.do?${_csrf.parameterName}=${_csrf.token}");
	$("#Form").submit();
}
function pf_boardHtmlUpdate(){
	//웹에디터 내용 textarea로 복사
	editor_object.getById["BIH_CONTENTS"].exec("UPDATE_CONTENTS_FIELD", []);
	$("#Form").attr("action","/dyAdmin/homepage/board/data/html/update.do?${_csrf.parameterName}=${_csrf.token}");
	$("#Form").submit();
}
function pf_boardHtmlDelete(useyn){
	$("#BIH_USE_YN").val(useyn)
	$("#Form").attr("action","/dyAdmin/homepage/board/data/html/delete.do?${_csrf.parameterName}=${_csrf.token}");
	$("#Form").submit();
}
function pf_back(){
	$("#Form").attr("action","/dyAdmin/homepage/board/dataView.do?${_csrf.parameterName}=${_csrf.token}");
	$("#Form").submit();
}
</script>
<style>
label input[type=checkbox].checkbox+span, label input[type=radio].radiobox+span{z-index: 1}
</style>
<div id="content">
	<section id="widget-grid" >
		<div class="row">
			<article class="col-sm-12 col-md-12 col-lg-12">
				<div class="jarviswidget jarviswidget-color-blueDark" id="" data-widget-editbutton="false">
					<header>
						<span class="widget-icon"> <i class="fa fa-lg fa-desktop"></i> </span>
						<h2>게시물관리 </h2>
					</header> 
					<div class="jarviswidget-editbox"></div>
					
					<div class="widget-body">
						<form:form id="Form" name="Form" method="post" class="form-horizontal bv-form" novalidate="novalidate" enctype="multipart/form-data"><button type="submit" class="bv-hidden-submit" style="display: none; width: 0px; height: 0px;"></button>
							<input type="hidden" name="BIH_MN_KEYNO" id="BIH_MN_KEYNO" value="${Menu.MN_KEYNO }">
							<input type="hidden" name="MN_KEYNO" id="MN_KEYNO" value="${Menu.MN_KEYNO }">
							<input type="hidden" name="BIH_BT_KEYNO" id="BIH_BT_KEYNO" value="${BoardType.BT_KEYNO }">
							<input type="hidden" name="BIH_REGNM" id="BIH_REGNM" value="${userInfo.UI_KEYNO }">
							<input type="hidden" name="BIH_KEYNO" id="BIH_KEYNO" value="${BoardHtml.BIH_KEYNO }">
							<input type="hidden" name="BIH_USE_YN" id="BIH_USE_YN" value="">
							<legend>게시물 등록</legend>
							
							<fieldset>
								<div class="form-group has-feedback">
									<label class="col-md-1 control-label">위치</label>
									<div class="col-sm-12 col-md-6">
										<label class="radio radio-inline no-margin">
										<input type="radio" name="BIH_DIV_LOCATION" value="T" class="radiobox style-2" data-bv-field="rating">
										<span>게시판 상단</span> </label>
									
										<label class="radio radio-inline no-margin">
										<input type="radio" name="BIH_DIV_LOCATION" value="B" class="radiobox style-2" data-bv-field="rating">
										<span>게시판 하단</span> </label>
									</div>
								</div>
							</fieldset>
							
							<fieldset>
								<div class="form-group has-feedback">
									<label class="col-md-1 control-label">내용</label>
									<div class="col-md-10">
										<textarea class="form-control"  name="BIH_CONTENTS" id="BIH_CONTENTS" style="width:100%;height:400px;min-width:260px;" data-bv-field="content">${BoardHtml.BIH_CONTENTS }</textarea><i class="form-control-feedback" data-bv-icon-for="content" style="display: none;"></i>
									</div>
								</div>
							</fieldset>
							
							<fieldset class="padding-10 text-right"> 
								<c:if test="${empty BoardHtml}">
									<button class="btn btn-sm btn-primary" id="Board_Edit"	type="button" onclick="pf_boardHtmlInsert()">	
										<i class="fa fa-floppy-o"></i> 저장
									</button>
								</c:if>
								<c:if test="${not empty BoardHtml}">
									<button class="btn btn-sm btn-primary" id="Board_Edit"	type="button" onclick="pf_boardHtmlUpdate()">	
										<i class="fa fa-floppy-o"></i> 수정
									</button>
									<c:if test="${BoardHtml.BIH_USE_YN == 'Y' }">
										<button class="btn btn-sm btn-danger" id="Board_Edit"	type="button" onclick="pf_boardHtmlDelete('N')">	
											<i class="fa fa-floppy-o"></i> 삭제
										</button>
									</c:if>
									<c:if test="${BoardHtml.BIH_USE_YN == 'N' }">
										<button class="btn btn-sm btn-success" id="Board_Edit"	type="button" onclick="pf_boardHtmlDelete('Y')">	
											<i class="fa fa-floppy-o"></i> 복구
										</button>
									</c:if>
								</c:if>
								<button class="btn btn-sm btn-default" id="Board_Delete" type="button" onclick="pf_back()"> 
									<i class="fa fa-times"></i> 취소
								</button> 
							</fieldset>
							
						</form:form>

					</div>
				</div>
			</article>
		</div>
	</section>
</div>
