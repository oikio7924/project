<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>


<style>
.tree .settings {display:inline-block;font-size: 0.5em;}
.tree .settings .checkbox {display:inline-block;margin:0;}

.fixed-btns {position: fixed;bottom: 50px;right: 40px;z-index: 100;}
.fixed-btns > li {display: inline-block;margin-bottom: 7px;}
label input[type=checkbox].checkbox + span {font-weight: 700 !important;}
.board-tree label span {border:none;margin-right:0;}

label input[type=checkbox].checkbox.style-3.all:checked+span:before {border-color: #3276b1;background: #3276b1;}

</style>

<div class="jarviswidget jarviswidget-color-darken" id="wid-id-2" data-widget-editbutton="false">
	<header>
		<span class="widget-icon"> <i class="fa fa-table"></i>
		</span>
		<h2>권한 설정</h2>
	</header>
	<div class="widget-body" >
		<div class="widget-body-toolbar bg-color-white">
			<div class="alert alert-info no-margin fade in">
				<button type="button" class="close" data-dismiss="alert">×</button>
				* 수정 후 오른쪽 하단의 저장버튼으로 꼭 저장하여주세요. <br>
				<span class="colorR fs12">* 저장 후 권한관리에서 시스템 재설정 버튼을 클릭하셔야 적용됩니다.</span> 
			</div> 
		</div>
		<div>
			<form:form id="menuSettingForm">
			<input type="hidden" name="MN_KEYNO" value="${menuData.MN_KEYNO }">
			<input type="hidden" name="UIA_DIVISION" value="${resultData.UIA_DIVISION }">
		
		<div class="text-align-right pull-right">
			<div class="btn-group">  
				<button class="btn btn-sm btn-primary" type="button" onclick="pf_selectAll(true)">
					<i class="fa fa-plus"></i> 모두 선택
				</button>
				<button style="margin-left:5px;" class="btn btn-sm btn-primary" type="button" onclick="pf_selectAll(false)">
					<i class="fa fa-minus"></i> 모두 해제
				</button> 
			</div>
		</div>
		
		<legend id="mappingName">
			${menuData.MN_NAME}
		</legend>
		
		<div style="float: right;">
			<a href="javascript:;" onclick="pf_allOpenAndClose(this)"><i class="fa fa-minus" style="color:red;"></i> <font>모두 닫기</font></a>
		</div>
		<div class="tab-content padding-10">
			<div class="authList">
				<div class="tree menu-tree">
					<ul>
						<li data-key="${anonymousData.UIA_KEYNO }" class="pageViewLi"> 
							<span>
					  			<i class="fa fa-lg fa-caret-right" ></i> 
					  			<c:out value="비회원" escapeXml="false" />
							</span>
							<div class="settings">
								<div class="checkbox ${anonymousData.UIA_KEYNO }">
									<c:choose>
										<c:when test="${fn:contains(menuData.MN_URL,'/member')}">
											<span style="color:gray;">설정불가(로그인 관련 url)</span>	
										</c:when>
										<c:when test="${fn:contains(MainMenuAuth.MAIN_AUTH_KEY,anonymousData.UIA_KEYNO) }">
											<label>
												<c:set var="actionCheck" value="${fn:contains(anonymousData.UIR_KEYNO,sp:getData('AUTHORITY_ROLE_ACTION')) ? 'checked':'' }"/>
												<input type="checkbox" class="checkbox style-3 action" name="actionRole" value="${anonymousData.UIA_KEYNO }" ${actionCheck}>
												<span>수정권한</span>
											</label>
											<label>
												<c:set var="accessCheck" value="${fn:contains(anonymousData.UIR_KEYNO,sp:getData('AUTHORITY_ROLE_ACCESS')) ? 'checked':'' }"/>
												<c:set var="isBoardClass" value="${menuData.MN_PAGEDIV_C eq sp:getData('MENU_TYPE_BOARD') ? 'board':'' }"/>
												<input type="checkbox" class="checkbox style-3 access ${isBoardClass }" name="accessRole" value="${anonymousData.UIA_KEYNO }" ${accessCheck}>
												<span>접근권한</span>
											</label>
											<label class="viewLebel">
												<c:set var="viewChecked" value="${fn:contains(anonymousData.UIR_KEYNO,sp:getData('AUTHORITY_ROLE_VIEW')) ? 'checked':'' }"/>
												<input type="checkbox" class="checkbox style-3 view ${accessCheck}" name="viewRole" value="${anonymousData.UIA_KEYNO }" ${viewChecked}>
												<span>뷰권한</span>
											</label>
											<c:if test="${menuData.MN_PAGEDIV_C eq sp:getData('MENU_TYPE_BOARD')}">
												<label class="boardRole">
													<input type="checkbox" class="checkbox style-3 all" value="">
													<span>모든 권한</span>
												</label>
												<c:forEach items="${boardAuthorityList }" var="boardAuth">
												<label class="boardRole">
													<c:set var="roleCheck" value="${fn:contains(anonymousData.UIR_KEYNO,boardAuth.UIR_KEYNO) ? 'checked':'' }"/>
													<input type="checkbox" class="checkbox style-3 ${boardAuth.UIR_NAME}" name="${boardAuth.UIR_NAME}Role" value="${anonymousData.UIA_KEYNO }" ${roleCheck }>
													<span>${boardAuth.UIR_COMMENT}</span>
												</label>
												</c:forEach>
											</c:if>
										</c:when>
										<c:otherwise>
											<span style="color:gray;">접근불가</span>	
										</c:otherwise>
									</c:choose>
								</div>
							</div>
						</li>	
					</ul>
					<c:set var="beforeDepth" value=""/>
					<c:set var="userCount" value="0"/>
					<c:forEach items="${menuAuthorityUserList}" var="model" varStatus="status">
							
							<c:if test="${model.UIA_MAINKEY eq 'UIA_00000' && model.UIA_DEPTH eq 1 }">
								<ul class="parent_ul">
							</c:if>
							
							<c:if test="${model.CHILD_CNT gt 0 }">
								<li class="parent_li" data-key="${model.UIA_KEYNO }"> 
									<span class="label label-primary">
							  			<i class="fa fa-lg fa-plus-circle"></i> 
							</c:if>
		  					
							<c:if test="${model.CHILD_CNT eq 0 }">
								<li data-key="${model.UIA_KEYNO }" class="pageViewLi"> 
								<span>
						  			<i class="fa fa-lg fa-caret-right" ></i> 
							</c:if>
								
		  						<c:out value="${model.UIA_NAME}" escapeXml="false" />
								</span>
								
								<div class="settings">
									<div class="checkbox ${model.UIA_KEYNO }">
										<c:choose>
											<c:when test="${fn:contains(menuData.MN_URL,'/member')}">
												<span style="color:gray;">설정불가(로그인 관련 url)</span>	
											</c:when>
											<c:when test="${fn:contains(MainMenuAuth.MAIN_AUTH_KEY,model.UIA_KEYNO) }">
												<!-- 부모그룹이 없거나 // 부모 그룹이 있고, 부모 그룹에서 접근권한이 있을경우 -->
												<label>
													<c:set var="actionCheck" value="${fn:contains(model.UIR_KEYNO,sp:getData('AUTHORITY_ROLE_ACTION')) ? 'checked':'' }"/>
													<input type="checkbox" class="checkbox style-3 action" name="actionRole" value="${model.UIA_KEYNO }" ${actionCheck}>
													<span>수정권한</span>
												</label>
												<label>
													<c:set var="accessCheck" value="${fn:contains(model.UIR_KEYNO,sp:getData('AUTHORITY_ROLE_ACCESS')) ? 'checked':'' }"/>
													<c:set var="isBoardClass" value="${menuData.MN_PAGEDIV_C eq sp:getData('MENU_TYPE_BOARD') ? 'board':'' }"/>
													<input type="checkbox" class="checkbox style-3 access ${isBoardClass }" name="accessRole" value="${model.UIA_KEYNO }" ${accessCheck}>
													<span>접근권한</span>
												</label>
												<label class="viewLebel">
													<c:set var="viewChecked" value="${fn:contains(model.UIR_KEYNO,sp:getData('AUTHORITY_ROLE_VIEW')) ? 'checked':'' }"/>
													<input type="checkbox" class="checkbox style-3 view ${accessCheck}" name="viewRole" value="${model.UIA_KEYNO }" ${viewChecked}>
													<span>뷰권한</span>
												</label>
												<c:if test="${menuData.MN_PAGEDIV_C eq sp:getData('MENU_TYPE_BOARD')}">
													<label class="boardRole">
														<input type="checkbox" class="checkbox style-3 all" value="">
														<span>모든 권한</span>
													</label>
													<c:forEach items="${boardAuthorityList }" var="boardAuth">
													<label class="boardRole">
														<c:set var="roleCheck" value="${fn:contains(model.UIR_KEYNO,boardAuth.UIR_KEYNO) ? 'checked':'' }"/>
														<input type="checkbox" class="checkbox style-3 ${boardAuth.UIR_NAME}" name="${boardAuth.UIR_NAME}Role" value="${model.UIA_KEYNO }" ${roleCheck }>
														<span>${boardAuth.UIR_COMMENT}</span>
													</label>
													</c:forEach>
												</c:if>
											</c:when>
											<c:otherwise>
												<span style="color:gray;">접근불가</span>	
											</c:otherwise>
										</c:choose>
									</div>
								</div>
									
									<c:if test="${model.CHILD_CNT gt 0}">
										<ul>
									</c:if>
								
									<c:if test="${model.CHILD_CNT eq 0 && model.UIA_DEPTH eq model.UIA_ORDER}">
									</ul>
								</li>
									<c:forEach begin="1" end="${model.UIA_DEPTH - 1}">
								</ul>
									</c:forEach>
									</c:if>
									
									
									
									<c:if test="${model.UIA_DIVISION eq 'A' && model.CHILD_CNT gt 0}">
										<c:set var="endCnt" value="${model.CHILD_CNT }"/>
										<c:set var="parentSibling" value="${model.SIBLING_CNT }"/>
									</c:if>
									
									<c:if test="${model.UIA_DIVISION eq 'U'}">
									<c:set var="userCount" value="${userCount + 1 }"/>
										<c:if test="${userCount eq model.SIBLING_CNT }">
											<c:if test="${parentSibling le 1 }">
											</ul>
											</c:if>
											</li>
												<c:forEach begin="1" end="${endCnt}">
											</ul>
												</c:forEach>
										</c:if>
									</c:if>
									<c:if test="${model.UIA_DIVISION ne 'U'}">
										<c:set var="userCount" value="0"/>
									</c:if>
									
									
							<c:if test="${status.last && model.UIA_DEPTH gt 1}">
								<c:forEach begin="1" end="${model.UIA_DEPTH - 1}">
								</ul>
							</li>
								</c:forEach>
							</c:if>
							<c:set var="beforeDepth" value="${model.UIA_DEPTH }"/>			
						
					</c:forEach>
				</div>
			</div>
		</div>
		</form:form>
		
		<ul class="fixed-btns">
			<li>
				<a href="javascript:;" onclick="pf_save()" class="btn btn-primary btn-circle btn-lg"><i class="fa fa-save"></i></a>
			</li>
			<li>
				<a href="javascript:;" onclick="pf_moveTop()" class="btn btn-default btn-circle btn-lg"><i class="fa fa-chevron-up"></i></a>
			</li>
		</ul>
		</div>
	</div>
</div>


<script>

$(function(){
	$('.authList .tree > ul').attr('role', 'tree').find('ul').attr('role', 'group');
	$('.authList .tree').find('.parent_li').attr('role', 'treeitem').find(' > span').attr('title', 'Collapse this branch').on('click', function(e) {
		var children = $(this).parent('li.parent_li').find(' > ul > li');
		if (children.is(':visible')) {
			children.hide('fast');
			$(this).attr('title', 'Expand this branch').find(' > i').removeClass().addClass('fa fa-lg fa-plus-circle');
		} else {
			children.show('fast');
			$(this).attr('title', 'Collapse this branch').find(' > i').removeClass().addClass('fa fa-lg fa-minus-circle');
		}
		e.stopPropagation();
	});	
	
	$('input[name=accessRole]').on('click',function(){
		
		//뷰권한 숨김
		if($(this).is(':checked')){
			$(this).closest('div').find('input[name=viewRole]').prop('checked',false);
			$(this).closest('div').find('.viewLebel').hide();
			
		}else{
			$(this).closest('div').find('.viewLebel').show();
		}
		
		//하위 checkbox들 checked 처리
		$(this).closest('li').find('input[name=accessRole]').prop('checked',$(this).is(':checked')).each(function(){
			if($(this).hasClass('board')){
				pf_changeBoardAuth($(this))	
			}
		});
		
		//부모 checkbox checked 처리
		if($(this).is(':checked')){
			$(this).parents('li.parent_li').children('.settings').find('input[name=accessRole]').prop('checked',true);
		}
		
	})
	
	$('input[name=accessRole].board').each(function(){
		pf_changeBoardAuth($(this))
	})
	
	$('.settings input[type=checkbox].all').on('click',function(){
		$(this).closest('.settings').find('input[type=checkbox]:not(.access)').prop('checked',$(this).is(':checked'));
	})
	
	$('.settings input[type=checkbox]:not(.all)').on('click',function(){
		pf_boardAuthAllCheck($(this).closest('.settings'));
		
	})
	
	$('.settings').each(function(){
		pf_boardAuthAllCheck(this);
	})
	
	//접근권한 체크된 뷰권한 숨김
	$('input[type=checkbox][name=viewRole].checked').each(function(){
		$(this).closest('label').hide();
	});
	
})

/**
 * 게시판 모드 권한 체크박스 체크 여부 
 * obj  = .setting 객체
 */
function pf_boardAuthAllCheck(obj){
	var unCheckedLength = $(obj).find('input[type=checkbox]:not(.all):not(:checked)').length;
	$(obj).find('input[type=checkbox].all').prop('checked',unCheckedLength == 0)
}



function pf_allOpenAndClose(obj){
	$ul = $('.menu-tree').find('ul.parent_ul');

	if($(obj).find('i').hasClass('fa-plus')){
		$(obj).find('i').addClass('fa-minus').removeClass('fa-plus');
		$(obj).find('font').text('모두 닫기');
		$ul.find('li.parent_li').each(function(){
			$(this).find('ul > li').show('fast');
			$(this).attr('title', 'Collapse this branch').find(' > i').removeClass().addClass('fa fa-lg fa-minus-circle');
		})
	}else{
		$(obj).find('i').addClass('fa-plus').removeClass('fa-minus');
		$(obj).find('font').text('모두 펼치기');
		$ul.find('li.parent_li').each(function(){
			$(this).find('ul > li').hide('fast');
			$(this).attr('title', 'Expand this branch').find(' > i').removeClass().addClass('fa fa-lg fa-plus-circle');
		})
	}
	
	
}

function pf_save(){
	
	cf_loading();
	
	setTimeout(function(){
		$.ajax({
			type: "POST",
			url: "/dyAdmin/admin/authority/saveUserListAjax.do",
			data: $('#menuSettingForm').serializeArray(),
			async :false,
			success : function(data){
				if(data == 'S'){
					cf_smallBox('ajax', '[${menuData.MN_NAME}] 에 대한 유저별 권한이 저장되었습니다.', 3000);
					if('${type}' == 'B'){
						pf_LinkPage($('#userPageIndex').val())
					}
				}else{
					cf_smallBox('ajax', '알수없는 에러 발생. 관리자한테 문의하세요.', 3000,'gray');
				}
			},
			error: function(jqXHR, textStatus, errorThrown){
				cf_smallBox('ajax', '알수없는 에러 발생. 관리자한테 문의하세요.', 3000,'gray');
			}
	   }).done(function(){
		   cf_loading_out();
	   });
	},100)
	
	
}

function pf_changeBoardAuth(obj){
	var mnKey = $(obj).val();

	var checkbox = $('.settings .checkbox.'+mnKey);
	
	checkbox.find('.boardRole').hide();
	if($(obj).is(':checked')){
		checkbox.find('label.boardRole').show();
	}else{
		checkbox.find('.boardRole input[type=checkbox]').prop('checked',false);
		checkbox.find('span.boardRole').show();
	}

	
	
}

function pf_selectAll(check){
	$('.settings input[type=checkbox]').prop('checked',check);
	
	$('input[name=accessRole].board').each(function(){
		pf_changeBoardAuth($(this))
	})
}


</script>
