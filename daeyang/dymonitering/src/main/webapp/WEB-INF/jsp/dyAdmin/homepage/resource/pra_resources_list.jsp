<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<%@ include file="/WEB-INF/jsp/dyAdmin/include/CodeMirror_Include.jsp"%>
<script type="text/javascript" src="/resources/common/js/common/diff_match_patch.js"></script>
<style>
#versionTd, #historyVersionTd{display: none;}
.customTitle{
    border: none;
    cursor: pointer;
    display: inline;
    float: left;
    height: 27px;
}
.closeBtn{float: right;}
.form-control[disabled], .form-control[readonly], fieldset[disabled] .form-control{background-color: inherit;}
#LayoutTab li.active{-webkit-box-shadow: 0 -2px 0 #57889c; -moz-box-shadow: 0 -2px 0 #57889c; box-shadow: 0 -2px 0 #57889c; border-top-width: 0!important; margin-top: 1px!important; font-weight: 700;
    color: #555; background-color: #fff;  border: 1px solid #ddd; border-bottom-color: transparent; cursor: default;}
#LayoutTab .customli.active .customeBtn{border-bottom: none; }

#LayoutTab li .customeBtn{padding: 10px 10px 10px; float: left; background: #fff; border: none;}
#LayoutTab li .customeBtn:hover,#LayoutTab li.customli .customeBtn:hover{background: #eee;}
#LayoutTab li.customli .customeBtn{padding: 5px 10px 10px; float: left; background: #fff; border: none; margin-bottom: 1px;}
#LayoutTab .customli .closeBtn{margin-top: 0px; float: right;}
.nav-tabs>li.active>a {box-shadow:none; cursor: pointer;}
</style>

<section id="widget-grid" class="">

	<div class="row">

		<article class="col-xs-12 col-sm-12 col-md-12 col-lg-12">

			<div class="jarviswidget jarviswidget-color-darken" id="wid-id-0"
				data-widget-editbutton="false">
				<header>
					<span class="widget-icon"> <i class="fa fa-table"></i>
					</span>
					<h2>${resourcesType} 설정</h2>
				</header>
				<div>
					<div class="jarviswidget-editbox"></div>
					<div class="widget-body">
						<div class="widget-body-toolbar bg-color-white">
							<div class="alert alert-info no-margin fade in">
								<button type="button" class="close" data-dismiss="alert">×</button>
								홈페이지를 선택하면 해당하는 홈페이지의 ${resourcesType}설정이 출력 됩니다. 저장하지 않고 다른 탭을 누를 경우 작성했던 내용이 삭제됩니다.<br>
								파일명 변경 후 배포를 누르지 않으면 파일이 생성되지 않습니다.
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
						
						<ul id="LayoutTab" class="ui-sortable nav nav-tabs bordered">
							<c:set value="false" var="activeCk"/>
							<c:forEach items="${ResourcesList}" var="model" varStatus="index">
								<c:set value="true" var="activeCk"/>
								<c:if test="${model.RM_SCOPE ne 'custom'}">
									<li class="sq-column-row ${index.count eq 1 ? 'active' : '' }" data-keyno="${model.RM_KEYNO}" data-order="${model.RM_ORDER}">
										<a class="customeBtn" data-toggle="tab" aria-expanded="true" data-scope="${model.RM_SCOPE}"><c:out value="${model.RM_TITLE}"/></a>
									</li>
								</c:if>
								<c:if test="${model.RM_SCOPE eq 'custom'}">
									<li class="sq-column-row customli ${index.count eq 1 ? 'active' : '' }" data-keyno="${model.RM_KEYNO}" data-order="${model.RM_ORDER}" data-filenm="${model.RM_FILE_NAME}">
										<a class="customeBtn" data-toggle="tab" aria-expanded="true" data-scope="custom">
										<input type="text" class="form-control customTitle" value="${model.RM_TITLE}" name="custom_title_${model.RM_ORDER}" maxlength="20" readonly="readonly">
										</a>
										<button type="button" class="close closeBtn" data-dismiss="alert" onclick="pf_closeTab(this);">×</button>
										<div class="clear"></div>
									</li> 
								</c:if>
							</c:forEach>
							<c:forEach items="${scopeList}" var="model" varStatus="index">
								<li class="sq-column-row ${(activeCk eq false) && (index.count eq 1) ? 'active' : ''}">
									<a class="customeBtn" data-toggle="tab" aria-expanded="true" data-scope="${model}"><c:out value="${scopeMap[model]}"/></a>
								</li>
							</c:forEach>
							<button id="tabPlus" class="btn btn-sm btn-info tabPlus" onclick="pf_addNewJs();" style="padding: 9px;">
								<i class="fa fa-plus"></i>
								추가
							</button>
						</ul>
						<form:form id="Form" method="post" action="/dyAdmin/homepage/resource/${resourceType}.do">
							<input type="hidden" id="MN_HOMEDIV_C" name="MN_HOMEDIV_C" value="${menu.MN_HOMEDIV_C }" />
							<input type="hidden" id="RM_MN_HOMEDIV_C" name="RM_MN_HOMEDIV_C" value="${menu.MN_HOMEDIV_C }" />
							<input type="hidden" name="RM_TYPE" id="RM_TYPE" value="${resourcesType}">
							<input type="hidden" name="RM_KEYNO" id="RM_KEYNO" value="">
							<input type="hidden" name="RM_TITLE" id="RM_TITLE" value="">
							<input type="hidden" name="RM_SCOPE" id="RM_SCOPE" value="">
							<input type="hidden" name="RM_ORDER" id="RM_ORDER" value="">
							<input type="hidden" name="DISTRIBUTE_TYPE" id="DISTRIBUTE_TYPE" value="">
							<input type="hidden" name="actionType" id="actionType" value="">
							<input type="hidden" name="currentVersion" id="currentVersion" value="0">
							<input type="hidden" name="homeName" id="homeName" value="">
							<input type="hidden" name="beforeFileNm" id="beforeFileNm" value="">
							
							<div id="myTabContent1" class="tab-content padding-10 form-horizontal bv-form">
								<div id="resourcesMenuDiv" class="tree">
			  						<ul id="menuListUl">
									</ul>
								</div>
								<div id="resourcesForm">
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
												<td><span class="nessSpan">*</span>제목</td>
												<td colspan="3">
												<input type="text" class="form-control" name="TITLE_NAME" id="TITLE_NAME" maxlength="50" placeholder="파일명 입력" onkeyup="pf_titleInsert(this.value);">
												</td>
											</tr>
											<tr>
												<td><span class="nessSpan">*</span>파일명</td>
												<td colspan="3">
												<input type="text" class="form-control" name="RM_FILE_NAME" id="RM_FILE_NAME" maxlength="50" placeholder="파일명.min으로 저장 후 배포할 경우 압축되어 배포됩니다." onkeyup="fn_press_han(this);">
												</td>
											</tr>
											<tr>
												<td><span class="nessSpan">*</span>코멘트</td>
												<td colspan="3">
												<input type="text" class="form-control" name="RMH_COMMENT" id="RMH_COMMENT" data-bv-field="fullName" maxlength="500" placeholder="no message">
												</td>
											</tr>
											<tr>
												<td><span class="nessSpan">*</span>내용</td>
												<td><span id="versionTd">최신 버전  [ <span id="viewVersion"></span> ]</span></td>
												<td colspan="2"><span id="historyVersionTd">복원 버전  [ <span id="historyViewVersion"></span> ]</span></td>
											</tr>
											<tr>
												<td colspan="4">
													<textarea class="form-control ckWebEditor" name="RM_DATA" id="RM_DATA"  style="width:100%;height:500px;min-width:260px;" data-bv-field="content"></textarea>
												</td>
											</tr>
											
											<tr>
												<td colspan="4">
													<fieldset class="padding-10 text-right"> 
														<button type="button" onclick="pf_jsDataInsert();" class="btn btn-sm btn-primary">	
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
							<article class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
								<div class="jarviswidget jarviswidget-color-green" data-widget-editbutton="false" data-widget-custombutton="false">
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
							<article class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
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

<%@ include file="/WEB-INF/jsp/dyAdmin/include/_layout/pra_common_script.jsp"%>
<script type="text/javascript">
var editor = null;
var msg = '${msg}';

$(function(){
	$("#LayoutTab li .customeBtn").on('click', function(){
		pf_getLiData($(this));
	});
	
	pf_setHomeName();
	
	resourceType = '${resourcesType}';
	
	resetColumnCnt();

	if(msg){
		setTimeout(function(){
			cf_smallBox('success', msg, 3000);
		},100)
	}
	
	$("#LayoutTab").sortable({
		beforeStop: function( event, ui ) {
			resetColumnCnt();
		}
	});
	
	//resourcesMirrorType가 js면 javascript 타입으로 코드미러를 적용한다.
	var resourcesMirrorType = '${resourcesType}'
		resourcesMirrorType = resourcesMirrorType == 'js' ? 'javascript':resourcesMirrorType;
		editor = codeMirror(resourcesMirrorType,'RM_DATA');
	
		var SELECT_KEYNO = '${SELECT_KEYNO}';
		var obj;
		if(SELECT_KEYNO != null && SELECT_KEYNO != ''){	//저장 또는 수정 후 작업했던걸 선택되도록 함.
			$("#LayoutTab li").each(function(i){
				if($(this).data('keyno') == SELECT_KEYNO){
					$("#LayoutTab li").removeClass('active');
					$(this).addClass('active');
					obj = $(this);
				}
			});
		}else{
			obj = $("#LayoutTab li").first();
		}
	pf_clickLi('true',obj);
	
	pf_liTextSize();
	
});

//id값 재정렬, 순서 리셋
function resetColumnCnt(){
	$row = $('.sq-column-row').not('.ui-sortable-placeholder');
	$row.each(function(i){
		$(this).attr("data-order", (i+1) );
	});
	
	updateColumnCnt(); //순서 세팅해서 바로 저장
}

//탭 순서 변경
function updateColumnCnt(){
	var arrKey = new Array();
	
	$row = $('.sq-column-row').not('.ui-sortable-placeholder');
	$row.each(function(i){
		var keyno = $(this).data('keyno') || '';
		arrKey.push(keyno);
	});
	
	$.ajax({
		type: "POST",
		async: false,
		url: "/dyAdmin/homepage/resource/"+resourceType+"/OrderSettingAjax.do",
		data : {
				 "arrKeyno":arrKey
			},
		success : function(data){
		},
		error : function(){	
			cf_smallBox('error', '순서변경 에러발생', 3000,'#d24158');
		}
	 });
}

//탭 클릭
function pf_clickLi(tabactiveCK,obj){
	
	if(!tabactiveCK){	//active된 탭이 없을 경우, 마지막 탭에 active 주고 클릭하기
		$("#LayoutTab li").removeClass('active');
		$('#LayoutTab li:last').addClass('active');
		$('#LayoutTab li:last .customeBtn').trigger('click');
	}
	if(obj){
		obj = $(obj).find('a');
		pf_getLiData(obj);
	}else{
		$("#LayoutTab li .customeBtn").on('click', function(){
			pf_getLiData($(this));
		});
	}
}

function pf_getLiData(obj){
	var scopeType = $(obj).data('scope');
	var resourcesKey = $(obj).closest('li').data('keyno');
	var title;
	if(scopeType == 'custom'){
		title = $(obj).find('input').val();
	}else{
		title = $(obj).text();
	}
	pf_dataAjax(resourcesKey,scopeType,title);
}

//데이터 불러오기
function pf_dataAjax(resourcesKey,scopeType,title){
	var beforeFileNm = '';
	cf_loading();

	setTimeout(function(){
		$.ajax({
			type: "POST",
			url: "/dyAdmin/homepage/common/"+resourceType+"/dataAjax.do",
			data : {"RM_KEYNO"	 :	resourcesKey},
			success : function(result){
				$("#RM_TITLE").val(title);
				$("#TITLE_NAME").val(title);
				pf_settingData(scopeType, resourceType, result);
				$("#beforeFileNm").val(result.RM_FILE_NAME);
			},
			error : function(){	
				cf_smallBox('error', '에러발생', 3000,'#d24158');
			}
		}).done(function(){
			cf_loading_out();
		});
	},100)
}

//저장
function pf_jsDataInsert(){
	pf_beforeActionCk();
	
	$("#RM_DATA").val(editor.getValue())
	$("#RM_TITLE").val($("#TITLE_NAME").val())
	$('#RM_ORDER').val($('#LayoutTab li[class*=active]').data('order'));
	
	if(!pf_validate('TITLE_NAME','제목')){return false;}
	if(!pf_validate('RM_FILE_NAME','파일명')){return false;}
	if(!pf_validate('RM_DATA','내용')){return false;}
	if(!pf_validate('RMH_COMMENT','코멘트')){return false;}
		
	var url = '/dyAdmin/homepage/resource/'+resourceType+'/insert.do'
	cf_smallBoxConfirm('Ding Dong!', '저장 하시겠습니까?','pf_submit(\''+url+'\', \'I\')')
} 


//배포
function pf_Distribute(allck) {

    var rst = pf_beforeDistributeCk(allck);
    
    if(rst.status){
        var url = '/dyAdmin/homepage/common/'+resourceType+'/distributeAjax.do'
        cf_smallBoxConfirm('Ding Dong!', rst.msg,'pf_submit(\''+url+'\', \'D\')');
    }
	
}

function pf_submit(url,type){
	cf_loading();
	
	if(type == 'I'){
		setTimeout(function(){
		   $.ajax({
	            type: "POST",
	            url: "/dyAdmin/homepage/resource/"+resourceType+"/versionCheckAjax.do",
	            data : $("#Form").serialize(),
	            success : function(data){
	            	
	                if(!data.updateCheck){
	                	cf_smallBox('return', '변경된 데이터가 존재하여 저장에 실패하였습니다.', 3000,'#d24158');
	                	$('#viewVersion').text(data.historyVersion);
	                	pf_dataHistory(data.historyMainKey);
	                	
	                }else{
	                	$('#Form').attr('action',url);
	            		$('#Form').submit();
	                }
	            },
	            error : function(){    
	            }
	       }).done(function(){
	           cf_loading_out();
	       });
		},100)
	}else{
    	$('#Form').attr('action',url);
		$('#Form').submit();
	}
}


//리소스 적용 메뉴 리스트 불러요기
function pf_jsMenuList(homekey,keyno){
	$.ajax({
		type: "POST",
		url: "/dyAdmin/homepage/resource/"+resourceType+"/MenuListAjax.do",
		data : {
				"KEYNO"					: keyno,
				"MN_HOMEDIV_C"			: homekey
			},
		success : function(result){
			$("#menuListUl").html(result)
		},
		error : function(){	
			cf_smallBox('error', '메뉴 리스트 가져오기 에러', 3000,'#d24158');
		}
	});
}
</script>
