<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>


<div class="tab-content padding-10">
	<div id="menuList-tab-content-1" class="tab-pane fade in active" data-type="homepage">
		<div class="tree">
			<ul>
				<li class="parent_li" data-key="${homeManager.MN_KEYNO }"> 
					<span class="label label-primary">
						<i  class="fa fa-lg fa-plus-circle">${homeManager.MN_NAME }</i>
					</span>
					<div class="settings">
						<div class="checkbox">
							<a href="javascript:;" onclick="pf_allOpenAndClose(this)"><i class="fa fa-plus" style="color:red;"></i> <font>모두 펼치기</font></a>
						</div>
					</div>
					<ul id="depth1Group">
						<li data-key="${homeManager.MN_KEYNO}"> 
							<a name="model_mn_name" href="javascript:;" onclick="">
							<span>
					  			<i class="fa fa-lg fa-caret-right" ></i> 
					  			모든 메뉴
							</span>
							</a>
						</li>
						<li data-key="${homeManager.MN_KEYNO}"> 
							<a name="model_mn_name" href="javascript:;" onclick="">
							<span>
					  			<i class="fa fa-lg fa-caret-right" ></i> 
					  			메인 화면
							</span>
							</a>
						</li>
					
					<c:set var="beforeDepth" value=""/>
					<c:forEach items="${menuList}" var="model" varStatus="status2">
					
						<c:if test="${!status2.first && model.MN_LEV lt beforeDepth }">
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
					  			<c:out value="${model.MN_NAME}" escapeXml="false" />
							</span>
					</c:if>
					
					<!--뷰, 게시판형일경우 -->
					<c:if test="${model.MN_PAGEDIV_C ne sp:getData('MENU_TYPE_SUBMENU') && model.MN_PAGEDIV_C ne sp:getData('MENU_TYPE_LINK')}">
						<li data-key="${model.MN_KEYNO }"> 
							<a name="model_mn_name" href="javascript:;"><span>
					  			<i class="fa fa-lg fa-caret-right" ></i> 
					  			<c:out value="${model.MN_NAME}" escapeXml="false" />
							</span></a>
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
	$("a[name=model_mn_name]").on('click', function(){
			
			var Maintext = $("ul#menuListTab").find(".active").text().trim();
	    	var Mainvalue = $("ul#menuListTab").find(".active").find("a").attr("data-key");
	    	var Subtext = $(this).closest("li").find("span").first().text().trim();
			var Subvalue = $(this).closest("li").attr('data-key');
			var type 
			if(Subtext == "모든 메뉴"){
				$("#Main_text").attr("value",Maintext);
				$("#Main_value").attr("value",Mainvalue);
				$("#Sub_text").attr("value",Subtext);
				$("#Sub_value").attr("value",Subvalue);
				$("#type_b").attr("value",'A');
			}else{
				$("#Main_text").attr("value",Maintext);
				$("#Main_value").attr("value",Mainvalue);
				$("#Sub_text").attr("value",Subtext);
				$("#Sub_value").attr("value",Subvalue);
				$("#type_b").attr("value",'N');
		}
			menu_popup_view();
			$("input[name=accessRole]").attr("checked",false);
	});
	
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

function menulist_showandhide(){
	var keyValue = $('#menulistSelect option:selected').data("key");
	var number = '${list_number}'
	for(var i=1;i<= number; i++){
		$("#menuList-tab-content-"+i).attr("class","tab-pane fade");
	}
		$(keyValue).attr("class","tab-pane fade in active");
}

</script>
