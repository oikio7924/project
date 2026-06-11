<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<link type="text/css" rel="stylesheet" href="/resources/common/css/paging_table.css">
<style>
.fixed-btns {position: fixed;bottom: 40px;right: 30px;z-index: 100;}

.fixed-btns > li {display: inline-block;margin-bottom: 7px;}

.showMenuList.active {color:red;}


.dd3-content.dd3-content-system {color: #0400ff;}

.homepageAdminAuth {
	background-color: #f0f0f0;
    padding: 7px;
    margin-left: 14px;
    border: 1px solid #999;
}

.homepageAdminAuth label {padding: 3px;}

    
</style>
<section id="widget-grid" class="">
	<div class="row">
		<article class="col-xs-12 col-sm-6 col-md-5 col-lg-5">
			<div class="jarviswidget jarviswidget-color-darken" id="wid-id-0"
				data-widget-editbutton="false">
				<header>
					<span class="widget-icon"> <i class="fa fa-table"></i>
					</span>
					<h2>권한/사용자</h2>
				</header>
				<div class="widget-body " >
					<div class="widget-body-toolbar bg-color-white">
						<div class="alert alert-info no-margin fade in">
							<button type="button" class="close" data-dismiss="alert">×</button>
							* 메뉴에 대한 권한들을 설정 하고 [서버 권한 재설정] 버튼으로 적용 시켜야 서버에 반영됩니다.<br>
							* 권한 - 수정 모드에서 수정된 권한이나 그룹은 메뉴에 대한 설정값들이 초기화 됩니다.<br>
							* 권한 - 수정 모드에서 작업후 하단의 [저장] 버튼으로 저장하여주세요.
						</div> 
					</div>
					<div class="widget-body-toolbar bg-color-white">
						<ul id="authorityListTab" class="nav nav-tabs bordered">
							<li class="active">
								<a href="#" onclick="pf_listview('A')" data-toggle="tab">권한</a>
							</li>
							<li>
								<a href="#" onclick="pf_listview('B')" data-toggle="tab">회원</a>
							</li>
							
							<li class="pull-right">
								<button class="btn btn-sm btn-primary" type="button" onclick="pf_applyAuthority()">
									<i class="fa fa-fw fa-lg fa-chain"></i> 서버 권한 재설정
								</button>
							</li>
						</ul>
						<div id="listWrap" class="tab-content padding-10">
							
						</div>
					</div>		
					<div class="pull-right saveAuthority authorityModifyBtn" style="display:none;">
						<div class="btn-group">  
							<button class="btn btn-sm btn-success" type="button" onclick="pf_saveAuthority()">
								<i class="fa fa-save"></i> 저장
							</button>
						</div>
					</div>
				</div>
			</div>
		</article>
		<article class="col-xs-12 col-sm-6 col-md-7 col-lg-7">
			<div class="jarviswidget jarviswidget-color-darken" id="wid-id-1"
				data-widget-editbutton="false">
				<header>
					<span class="widget-icon"> <i class="fa fa-table"></i>
					</span>
					<h2>권한 설정</h2>
				</header>
				<div class="widget-body " >
					<div class="widget-body-toolbar bg-color-white">
						<div class="alert alert-info no-margin fade in">
							<button type="button" class="close" data-dismiss="alert">×</button>
							* 접근불가 메뉴는  상위 그룹/권한에서 접근권한을 추가하셔야 접근가능합니다.<br>
							* 수정 후 오른쪽 하단의 저장버튼으로 꼭 저장하여주세요. 
						</div> 
					</div>
					<div id="menuListWrap">
					
					</div>
				</div>
			</div>
		</article>
	</div>
</section>

<script>

var currentListViewType = 'A'; // A : 권한 , B : 회원

$(function(){
	
	pf_listview(currentListViewType);
})

function pf_listview(type,pageIndex,searchKeyword){
	
	$('#menuListWrap').html('');
	
	cf_loading();
	currentListViewType = type;
	
	var data;
	if(type == 'A'){
		data = {
			"type" 			: 	currentListViewType
		}
	}else if(type == 'B'){
		data = {
			"type" 			: 	currentListViewType,
			"pageIndex"		:	pageIndex || 1,
			"searchKeyword"	:	searchKeyword || ''
		}
	}
	setTimeout(function(){
		
		$.ajax({
			type: "POST",
			url: "/dyAdmin/admin/authority/listAjax.do",
			async: false,
			data: data,
			success : function(data){
			  	$('#listWrap').html(data);
		  		$('.saveAuthority').hide();
			  	
			}, error: function(){
		        cf_smallBox('error', '리스트 가져오기 에러', 3000,'#d24158');
			}
		});
		
		cf_loading_out();
	},100)
	
	
}

function pf_getMenuList(key,obj){
	
	$('.showMenuList.active').removeClass('active').children('i').addClass('fa-th-list').removeClass('fa-arrow-right');
	
	if(key){
		cf_loading();
		
		setTimeout(function(){
			
			$.ajax({
				type: "POST",
				url: "/dyAdmin/admin/authority/menuListAjax.do",
				async: false,
				data: {
					"type"	: 	currentListViewType,
					"key"	:	key
				},
				success : function(data){
				  	$('#menuListWrap').html(data);
				  	$(obj).addClass('active').children('i').addClass('fa-arrow-right');
				  	
				}, error: function(){
			        cf_smallBox('error', '리스트 가져오기 에러', 3000,'#d24158');
					return false;
				}
			});
			
			cf_loading_out();
		},100)
	}else{
		$('#menuListWrap').html('');
	}
	
}


function pf_applyAuthority(){
	if(confirm('서버 권한을 재설정 하시겠습니까?')){
		cf_loading();
		
		setTimeout(function(){
			
			$.ajax({
				type: "POST",
				url: "/dyAdmin/admin/authority/applyAuthorityAjax.do",
				async: false,
				success : function(data){
					cf_smallBox('서버 권한 재설정', '성공적으로 권한이 재설정 되었습니다.', 3000);
				  	
				}, error: function(){
			        cf_smallBox('error', '권한 재설정 작업이 실패하였습니다. 관리자한테 문의하여주세요.', 3000,'#d24158');
					return false;
				}
			});
			
			cf_loading_out();
		},100)
	}
}

</script>