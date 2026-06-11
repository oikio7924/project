<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<%@ include file="/WEB-INF/jsp/dyAdmin/include/CodeMirror_Include.jsp"%>
<script type="text/javascript" src="/resources/common/js/common/diff_match_patch.js"></script>
<style>
#versionTd, #historyVersionTd{display: none;}
.customTitle{
	width: 90px;
    height: 20px;
}

.ui-draggable {
	max-height: 300px;
}
</style>

<section id="widget-grid" class="">

	<div class="row">

		<article class="col-xs-12 col-sm-12 col-md-12 col-lg-12">

			<div class="jarviswidget jarviswidget-color-darken" id="wid-id-0"
				data-widget-editbutton="false">
				<header>
					<span class="widget-icon"> <i class="fa fa-table"></i>
					</span>
					<h2>레이아웃 설정</h2>
				</header>
				<div>
					<div class="jarviswidget-editbox"></div>
					<div class="widget-body">
						<div class="widget-body-toolbar bg-color-white">
							<div class="alert alert-info no-margin fade in">
								<button type="button" class="close" data-dismiss="alert">×</button>
								홈페이지를 선택하면 해당하는 홈페이지의 레이아웃 설정이 출력 됩니다.
							</div>
						</div> 
						<div class="widget-body-toolbar bg-color-white">
							<div class="row">
								<div class="col-sm-12 text-align-right">
									<button class="btn btn-sm btn-success" type="button" onclick="pf_Distribute('true')" style="margin-right:10px;">
										<i class="fa fa-plus"></i> 전체배포
									</button>
								</div>																
							</div>
						</div> 
						
						<ul id="LayoutTab" class="nav nav-tabs bordered">
							<li class="active" data-scope="prc_main">
								<a href="#" data-toggle="tab" aria-expanded="true">main</a>
							</li>
							<li data-scope="layout">
								<a href="#" data-toggle="tab" aria-expanded="true">layout</a>
							</li>
							<li data-scope="header">
								<a href="#" data-toggle="tab" aria-expanded="true">header</a>
							</li>
							<li data-scope="footer">
								<a href="#" data-toggle="tab" aria-expanded="true">footer</a>
							</li>
							<li data-scope="css">
								<a href="#" data-toggle="tab" aria-expanded="true">css</a>
							</li>
							<li data-scope="script">
								<a href="#" data-toggle="tab" aria-expanded="true">script</a>
							</li>
							<li data-scope="leftmenu">
								<a href="#" data-toggle="tab" aria-expanded="true">leftmenu</a>
							</li>
							<li data-scope="rightTop">
								<a href="#" data-toggle="tab" aria-expanded="true">rightTop</a>
							</li>
							<li data-scope="subTop">
								<a href="#" data-toggle="tab" aria-expanded="true">subTop</a>
							</li>
						</ul>
						
						<form:form id="Form" method="post" action="/dyAdmin/homepage/layout/layout.do">
							<input type="hidden" id="MN_HOMEDIV_C" name="MN_HOMEDIV_C" value="${MN_HOMEDIV_C}" />
							<input type="hidden" id="RM_MN_HOMEDIV_C" name="RM_MN_HOMEDIV_C" value="${MN_HOMEDIV_C}" />
							<input type="hidden" name="RM_KEYNO" id="RM_KEYNO" value="">
							<input type="hidden" name="RM_SCOPE" id="RM_SCOPE" value="">
							<input type="hidden" name="RM_FILE_NAME" id="RM_FILE_NAME" value="">
							<input type="hidden" name="actionType" id="actionType" value="">
							<input type="hidden" name="RM_DATA" id="RM_DATA_TEMP" value="">
							<input type="hidden" name="RM_TYPE" id="RM_TYPE" value="${type }">
							<input type="hidden" name="DISTRIBUTE_TYPE" id="DISTRIBUTE_TYPE">
							<input type="hidden" name="currentVersion" id="currentVersion" value="0">
							<input type="hidden" name="homeName" id="homeName" value="">
							
							<div id="myTabContent1" class="tab-content padding-10 form-horizontal bv-form">
								<div>
									<table class="table table-bordered table-striped">
										<colgroup>
											<col style="width: 20%;">
											<col style="width: 30%;">
											<col style="width: 20%;">
											<col style="width: 30%;">
										</colgroup>
										<tbody>
											<tr>
												<td>작성자</td>
												<td id="REGNM">
												</td>
												<td>작성일</td>
												<td id="REGDT">
												</td>
											</tr>
											<tr>
												<td>최근 게시물 수정자</td>
												<td id="MODNM">
												</td>
												<td>최근 게시물 수정일자</td>
												<td id="MODDT">
												</td>
											</tr>
											<tr>
												<td><span class="nessSpan">*</span>코멘트</td>
												<td colspan="3">
												<input type="text" class="form-control" name="RMH_COMMENT" id="RMH_COMMENT" data-bv-field="fullName" maxlength="500" placeholder="no message">
												</td>
											</tr>
											<tr>
												<td><div style="padding: 2px 6px;">내용</div></td>
												<td><span id="versionTd">최신 버전  [ <span id="viewVersion"></span> ]</span></td>
												<td><span id="historyVersionTd">복원 버전  [ <span id="historyViewVersion"></span> ]</span></td>
												<td>
													<div class="text-align-right">
													<button class="btn btn-sm btn-success paddingthin" type="button" onclick="pf_openPopup()">
														 Skin선택
													</button>
												</div>	
												</td>
											</tr>
											<tr>
												<td colspan="4">
													<textarea class="form-control ckWebEditor" id="RM_DATA" style="width:100%;height:500px;min-width:260px;" data-bv-field="content"></textarea>
												</td>
											</tr>
											<tr>
												<td colspan="4">
													<fieldset class="padding-10 text-right"> 
														<button type="button" onclick="pf_LayoutInsert();" class="btn btn-sm btn-primary">	
															<i class="fa fa-floppy-o"></i> 저장
														</button>
														<button class="btn btn-sm btn-success" type="button" onclick="pf_Distribute('false')" style="margin-right:10px;">
															<i class="fa fa-plus"></i> 배포
														</button>
													</fieldset>
												</td>
											</tr>
										</tbody>
									</table>
								</div>	
							</div>
						</div>
						</form:form>
						
						<div class="row">	
							<article class="col-sm-12 col-md-12 col-lg-12">
								<div class="jarviswidget jarviswidget-color-green" id="" data-widget-editbutton="false" data-widget-custombutton="false">
									<header>
										<span class="widget-icon"> <i class="fa fa-edit"></i></span>
										<h2>히스토리</h2>
									</header>
									<div>
										<div class="jarviswidget-editbox"></div>
										<div class="widget-body">
											<div class="table-responsive">
												<table id="datatable_fixed_column" class="table table-bordered table-hover" width="100%">
											    	<colgroup>
														<col width="5%">
														<col width="10%">
														<col width="">
														<col width="20%">
														<col width="25%">
													</colgroup>
											    <thead>
											      <tr>
											      	<th class="text-align-center">버전</th>
													<th class="text-align-center">작성자</th>
													<th class="text-align-center">코멘트</th>
													<th class="text-align-center">게시기간</th>
													<th class="text-align-center">기능</th>
											      </tr>
											    </thead>
											    <tbody id="intro-history">
										    	</tbody>
											    </table>
											</div>
										</div>
									</div>
								</div>
							</article>
						</div>
						
						<div class="row">	
							<article class="col-sm-12 col-md-12 col-lg-12">
								<div class="jarviswidget jarviswidget-color-green" id="compareData_wrap" data-widget-editbutton="false" data-widget-custombutton="false">
									<header>
										<span class="widget-icon"> <i class="fa fa-edit"></i></span>
										<h2>소스 비교</h2>
									</header>
									<div>
										<div class="jarviswidget-editbox"></div>
										<div class="widget-body">
											<div id="compareData"></div>
										</div>
									</div>
								</div>
							</article>
						</div>
					</div>
				</div>
			</div>
		</article>
	</div>
</section>

<%@ include file="/WEB-INF/jsp/dyAdmin/include/pra_import_popup.jsp"%>
<%@ include file="/WEB-INF/jsp/dyAdmin/include/_layout/pra_common_script.jsp"%>

<script type="text/javascript">
var editor = null;

$(function(){
	
	pf_setHomeName();
	
	resourceType = 'layout';
	
	editor = codeMirror('htmlmixed','RM_DATA');
	
	pf_clickLi();
	
	var scope = '${SCOPE}'
	
	if(scope != null && scope != ''){
		$("#LayoutTab li").each(function(i){
			if($(this).data('scope') == scope){
				$("#LayoutTab li").removeClass('active');
				$(this).addClass('active');
				$(this).trigger("click");
			}
		})
	}else{
		$("#LayoutTab li").first().trigger("click");
	}
});

//탭 클릭
function pf_clickLi(){
	$("#LayoutTab li").each(function(i){
		$(this).on('click', function(){
			var scopeType = $(this).data('scope');
			
			pf_dataAjax(scopeType);
			
		})
	})
}


//데이터 불러오기
function pf_dataAjax(scopeType){
	cf_loading();
	setTimeout(function(){
		$.ajax({
			type: "POST",
			url: "/dyAdmin/homepage/common/"+resourceType+"/dataAjax.do",
			data : {"RM_MN_HOMEDIV_C" : $("#MN_HOMEDIV_C").val(),
					"RM_SCOPE" : scopeType},
			success : function(result){
				pf_settingData(scopeType, resourceType, result)
			},
			error : function(){	
				cf_smallBox('error', '에러발생', 3000,'#d24158');
			}
		}).done(function(){
			cf_loading_out();
		});
	},100)
}


function pf_LayoutInsert(){
	pf_beforeActionCk();
	
	$("#RM_DATA_TEMP").val(editor.getValue())

	if(!pf_validate('RMH_COMMENT','코멘트')){return false;}
	if(!pf_validate('RM_DATA_TEMP','내용')){return false;}
	
	if(confirm("저장하시겠습니까?")){
        cf_loading();        
        
        setTimeout(function(){
            $.ajax({
            type: "POST",
            url: "/dyAdmin/homepage/layout/insert.do",
            data : $("#Form").serialize(),
            success : function(data){
            	
                if(!data.updateCheck){
                	cf_smallBox('return', '변경된 데이터가 존재하여 저장에 실패하였습니다.', 3000,'#d24158');
                	$('#viewVersion').text(data.historyVersion);
                	pf_dataAjaxHistory(data.historyMainKey);
                	
                }else{
               	    cf_smallBox('ajax', '저장되었습니다.', 3000);
                	pf_dataAjax(data.scope);
                }
                
            },
            error : function(){    
            }
            }).done(function(){
                cf_loading_out();
            });
        },100)

	}
} 

// layout 배포
function pf_Distribute(allck) {
	
    var rst = pf_beforeDistributeCk(allck);

    if(rst.status && confirm(rst.msg)) {
		cf_loading();
		setTimeout(function(){
			$.ajax({
			    type   : "post",
			    url    : "/dyAdmin/homepage/layout/distributeAjax.do",
			    data   : $("#Form").serialize(),
			    success:function(data){
			    	if(data) {
			    		cf_smallBox('success', '배포되었습니다', 3000);
			    	} else {
			    		cf_smallBox('error', '배포실패', 3000,'#d24158');
			    	}
			    },
			    error: function(jqXHR, textStatus, exception) {
			    	cf_smallBox('error', '에러발생', 3000,'#d24158');
			    }
			  }).done(function(){
				cf_loading_out();
			})
		},100)
	}
	
	
}

</script>
