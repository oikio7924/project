<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<script src="https://cdnjs.cloudflare.com/ajax/libs/babel-core/5.6.15/browser-polyfill.min.js"></script>

<style>
.tree .settings {display:inline-block;font-size: 0.5em;}
.tree .settings .checkbox {display:inline-block;margin:0;}
</style>

<input type="hidden" id="homeKey" value="${homeManager.MN_KEYNO}"/>
<input type="hidden" id="homeName" value="${homeManager.MN_NAME}"/>

<div class="tab-content padding-10">
	<div id="menuList-tab-content-1" class="tab-pane fade in active" data-type="homepage">
		<div class="tree">
			<ul>
				<li class="parent_li homeVeiw" data-key="${homeManager.MN_KEYNO }" id="homeVeiw" data-menu="A"> 
					<span class="label label-primary">
						<i  class="fa fa-lg fa-plus-circle">
						${homeManager.MN_NAME }
						</i>
					</span>
					<div class="settings">
						<div class="checkbox">
							<label>
							  <input type="checkbox" class="checkbox style-3 access" name="accessRole" onclick="pf_PopMenuCheck(this);">
							  <span></span>
							</label>
						</div>
					</div>
					<div class="settings">
						<div class="checkbox">
							<a href="javascript:;" onclick="pf_allOpenAndClose(this)"><i class="fa fa-plus" style="color:red;"></i> <font>모두 펼치기</font></a>
						</div>
					</div>
					<ul id="depth1Group">
							<li class="menuVeiw" data-key="${homeManager.MN_KEYNO}" id="menuVeiw" data-menu="N"> 
							<span>
					  			<i class="fa fa-lg fa-caret-right" ></i> 
					  			메인 화면
							</span>
							<div class="settings">
								<div class="checkbox">
									<label>
									  <input type="checkbox" class="checkbox style-3 access" name="accessRole" onclick="pf_PopMenuCheck(this);">
									  <span></span>
									</label>
								</div>
							</div>
							</li>
					<c:set var="beforeDepth" value=""/>
					<c:forEach items="${menuList}" var="model" varStatus="status2">
						<fmt:parseNumber value="${fn:substring(model.MN_KEYNO,5,20)}" var="menuKeyVal" />
						<c:if test="${ !status2.first && model.MN_LEV lt beforeDepth }">
							<c:forEach begin="${model.MN_LEV}" end="${beforeDepth - 1}">
							</ul>
						</li>
							</c:forEach>
						</c:if>
					
					<!-- 소메뉴 형 일경우 -->
					<c:if test="${model.MN_PAGEDIV_C eq sp:getData('MENU_TYPE_SUBMENU') }">
						<li class="parent_li" data-key="${model.MN_KEYNO }" data-menu="${menuKeyVal}"> 
							<span class="label label-primary">
					  			<i class="fa fa-lg fa-plus-circle"></i> 
					  			<c:out value="${model.MN_NAME}" escapeXml="false" />
					
							</span>
					</c:if>
					<!--뷰, 게시판형일경우 -->
					<c:if test="${model.MN_PAGEDIV_C ne sp:getData('MENU_TYPE_SUBMENU') && model.MN_PAGEDIV_C ne sp:getData('MENU_TYPE_LINK') }">
						<li data-key="${model.MN_KEYNO }" data-menu="${menuKeyVal}"> 
							<span>
					  			<i class="fa fa-lg fa-caret-right" ></i> 
					  			<c:out value="${model.MN_NAME}" escapeXml="false" />
					
							</span>
							<div class="settings">
								<div class="checkbox">
									<label>
									  <input type="checkbox" class="checkbox style-3 access" name="accessRole" onclick="pf_PopMenuCheck(this);">
									  <span></span>
									</label>
								</div>
							</div>
					  		
					</c:if>
					
					<c:if test="${model.MN_PAGEDIV_C eq sp:getData('MENU_TYPE_SUBMENU') }">
							<ul>
						<c:if test="${model.MN_PAGEDIV_C ne sp:getData('MENU_TYPE_SUBMENU') || (model.MN_PAGEDIV_C eq sp:getData('MENU_TYPE_SUBMENU') && model.MN_CHILD_CNT eq 0)}">
							</ul>
						</li>
						</c:if>
					</c:if>
						
						<c:if test="${status2.last && model.MN_LEV gt 1}">
							<c:forEach begin="1" end="${model.MN_LEV - 1}">
							</ul>
						</li>
							</c:forEach>
						</c:if>
						<c:set var="beforeDepth" value="${model.MN_LEV }"/>
					</c:forEach>
					</ul>
				</li>
			</ul>
		</div>
	</div>
</div>


<script>
$(function(){

	pf_savedPopMenuCheck();
	
	pf_tree();
	
});

function pf_savedPopMenuCheck(){

	var iterator = popupCheckedDataMap[Symbol.iterator]();
	for (var i=0; i < popupCheckedDataMap.size; i++) {
		var mapVal = iterator.next().value;
		var key = mapVal[0];
		var value = mapVal[1];
		
		pf_rightMenuListCheck(key,true);
		
		if(key == 'A'){
			$('#menuList-tab-content-1').find('input[name=accessRole]').prop('disabled',true);
			$('#homeVeiw').find('input[type=checkbox]:first').prop('disabled','');
		}
		
	}

}

function pf_PopMenuCheck(obj){
	var popupMenuType = 'N';
	
	var Subtext = $(obj).closest("li").find("span").first().text().trim();
	var Subvalue = $(obj).closest("li").attr('data-menu');
	var menuKeyno = $(obj).closest("li").attr('data-key');
	
	var homeBoolean = $(obj).closest("li").hasClass('homeVeiw');
	var menuBoolean = $(obj).closest("li").hasClass('menuVeiw');
	
	if($(obj).is(':checked')){
		popupCheckedDataMap.set(Subvalue,Subtext);
		
		$('#selected_menu').append(pf_add_span(menuKeyno,Subvalue,Subtext));
	
		pf_rightMenuListCheck(Subvalue,true);
		
		if(Subvalue == 'A') popupMenuType = 'A';
		
	}else{
		
		pf_delete_span(Subvalue);
		popupCheckedDataMap.delete(Subvalue);
	}
	
	$('#PI_MN_TYPE').val(popupMenuType);
	
}

function pf_add_span(menuKeyno,Subvalue,Subtext){
	if(Subvalue == 'A') Subtext = '모든 메뉴';
	var temp = "";
	temp += '<input class ="delete" type="hidden" name="MN_SUB_TITLE" value="'+menuKeyno+'" data-menu="'+Subvalue+'"/>';
	temp += '<span class="tag label label-info deleteSpan" data-menu="'+Subvalue+'">';
	temp += '<div class="b">'+Subtext+'</div>';
	temp += '<span onclick="pf_delete_span(\''+Subvalue+'\')" data-role="remove"></span>';
	temp += '</span>';
	return temp;
}

function pf_delete_span(num){

	$('.deleteSpan[data-menu='+num+'], .delete[data-menu='+num+']').remove();
	
	pf_rightMenuListCheck(num,false);
	
}

function pf_rightMenuListCheck(key,bool){

	if(key == 'A'){	//전체선택	
		$('#homeVeiw').find('input[type=checkbox]:first').prop('checked',bool);
	}else if(key == 'N'){	//메인화면 선택
		$('#menuVeiw').find('input[type=checkbox]').prop('checked',bool);
	}else{
		$('#menuList-tab-content-1 li[data-menu='+key+']').find('input[type=checkbox]').prop('checked',bool);
	}
}


function pf_allOpenAndClose(obj){
	var ul = $(obj).next('ul');
	
	if($(obj).find('i').hasClass('fa-plus')){
		$(obj).find('i').addClass('fa-minus').removeClass('fa-plus');
		$(obj).find('font').text('모두 닫기');
		$(obj).closest('li').find('li.parent_li > span').each(function(){
			$(this).parent('li.parent_li').find(' > ul > li').show();
			$(this).attr('title', 'Collapse this branch').find(' > i').removeClass().addClass('fa fa-lg fa-minus-circle');
		})
	}else{
		$(obj).find('i').addClass('fa-plus').removeClass('fa-minus');
		$(obj).find('font').text('모두 펼치기');
		$(obj).closest('li').find('li.parent_li > span').each(function(){
			$(this).parent('li.parent_li').find(' > ul > li').hide();
			$(this).attr('title', 'Expand this branch').find(' > i').removeClass().addClass('fa fa-lg fa-plus-circle');
		})
	}
}

function pf_tree(){
	$('.tree > ul').attr('role', 'tree').find('ul').attr('role', 'group');
	$('.tree li.parent_li > ul > li').hide();
	$('.tree').find('.parent_li').attr('role', 'treeitem').find(' > span').attr('title', 'Collapse this branch').on('click', function(e) {
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
	$('.tree > ul > li > span').trigger('click');
	
	$('input[name=accessRole]').on('click',function(){
		
		$(this).closest('li').find('input[name=accessRole]').prop('disabled',$(this).is(':checked'));
		$(this).prop("disabled","");

// 		var uncheckedLength = $(this).closest('ul').children('li').find('input[name=accessRole]').not(':checked').length;
// 		var parentInput = $(this).closest('ul').closest('li').children('.settings').find('input[name=accessRole]');
// 		if(uncheckedLength == 0){
// 			parentInput.prop('checked',true)
// 		}else{
// 			parentInput.prop('checked',false)
// 		}

	});

}

var popupSubListKey, popupSubListType;
function pf_setSubDataArry(){
	popupSubListKey = new Array();
	popupSubListType = new Array();
	$('#selected_menu input[name=MN_SUB_TITLE]').each(function(){
		popupSubListKey.push($(this).val());
		popupSubListType.push($(this).data('menu'));
	});
	
	$("#popupSubListKey").val(popupSubListKey);
	$("#popupSubListType").val(popupSubListType);
}

</script>
