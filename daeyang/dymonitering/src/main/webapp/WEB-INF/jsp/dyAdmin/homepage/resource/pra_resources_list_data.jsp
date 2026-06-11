<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>


<style>
.tree .settings {display:inline-block;font-size: 0.5em;}
.tree .settings .checkbox {display:inline-block;margin:0;}
</style>

<li class="parent_li" data-key="${homeManager.MN_KEYNO }" id="session01"> 
	<span class="label label-primary">
		<i class="fa fa-lg fa-plus-circle">${homeManager.MN_NAME }</i>
	</span>
	<div class="settings">
		<div class="checkbox">
			<label>
			  <input type="checkbox" class="checkbox style-3 access" name="RMS_MN_TYPE" value="A" onclick="pf_totalMenu(this);">
			  <span>메뉴 전체 적용</span>
			</label>
		</div>
	</div>
</li>
<li class="parent_li" data-key="${homeManager.MN_KEYNO }" id="session02"> 
	<span class="label label-primary">
		<i class="fa fa-lg fa-plus-circle">${homeManager.MN_NAME } 메인</i>
	</span>
	<div class="settings">
		<div class="checkbox">
			<label>
			  <input type="checkbox" class="checkbox style-3 access" name="ApplyMenu" value="${homeManager.MN_KEYNO }">
			  <span>선택</span>
			</label>
		</div>
		<div class="checkbox">
			<a href="javascript:;" onclick="pf_allOpenAndClose(this)"><i class="fa fa-minus" style="color:red;"></i> <font>모두 닫기</font></a>
			<a href="javascript:;" onclick="pf_selectAll(true)"><i class="fa fa-plus" style="color:red;"></i> <font>전체 선택</font></a>
			<a href="javascript:;" onclick="pf_selectAll(false)"><i class="fa fa-minus" style="color:red;"></i> <font>전체 해제</font></a>
		</div>
	</div>
	
	<ul id="depth1Group">
		<c:set var="beforeDepth" value=""/>
		<c:forEach items="${menuList}" var="model" varStatus="status2">
			
			<c:if test="${ !status2.first && model.MN_LEV lt beforeDepth }">
				<c:forEach begin="${model.MN_LEV}" end="${beforeDepth - 1}">
				</ul>
			</li>
				</c:forEach>
			</c:if>
			
			<!-- 소메뉴 형 일경우 -->
			<c:if test="${model.MN_PAGEDIV_C eq sp:getData('MENU_TYPE_SUBMENU') }">
				<li class="parent_li" data-key="${model.MN_KEYNO }"> 
					<span class="label label-primary">
			  			<i class="fa fa-lg fa-plus-circle"></i> 
			</c:if>
			
			<!--뷰, 게시판형일경우 -->
			<c:if test="${model.MN_PAGEDIV_C ne sp:getData('MENU_TYPE_SUBMENU') }">
				<li data-key="${model.MN_KEYNO }" class="pageViewLi"> 
					<span>
			  			<i class="fa fa-lg fa-caret-right" ></i> 
			</c:if>
						
					<c:out value="${model.MN_NAME}" escapeXml="false" />
				
					</span>
					
					<c:if test="${model.MN_PAGEDIV_C ne sp:getData('MENU_TYPE_SUBMENU') || (model.MN_PAGEDIV_C eq sp:getData('MENU_TYPE_SUBMENU') && not empty fn:trim(model.MN_FORWARD_URL))}">
					
					<div class="settings">
						<div class="checkbox">
							<label>
							  <input type="checkbox" class="checkbox style-3 access" name="ApplyMenu" value="${model.MN_KEYNO }">
							  <span>선택</span>
							</label>
						</div>
					</div>
					
					</c:if>
				<ul>
					<c:if test="${model.MN_PAGEDIV_C ne sp:getData('MENU_TYPE_SUBMENU') || (model.MN_PAGEDIV_C eq sp:getData('MENU_TYPE_SUBMENU') && model.MN_CHILD_CNT eq 0)}">
				</ul>
					</li>
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


<script>

$(function(){
	$('.tree > ul').attr('role', 'tree').find('ul').attr('role', 'group');
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

	var menuKeys = '${MenuKeys.MENUKEYS}'
	var menuType = '${MenuKeys.RMS_MN_TYPE}'
	if(menuType == 'N'){
		$('input[name=ApplyMenu]').each(function(){
			if(menuKeys.search($(this).val()) != -1){
				$(this).prop('checked', true);
			}
		})
	}else if(menuType == 'A'){
		$('input[name=RMS_MN_TYPE]').prop('checked', true);
		pf_totalMenu($('input[name=RMS_MN_TYPE]'))
	}
})

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

function pf_selectAll(check){
	$('.settings input[type=checkbox]').prop('checked',check);
}

function pf_totalMenu(obj){
	var totalCk = $(obj).is(':checked')
	$('.settings input[type=checkbox][name=ApplyMenu]').attr('disabled',totalCk);
}
</script>