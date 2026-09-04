<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>


<style>
.pageViewLi.active span{background: #a15bae;; color: #fff;}
.pageViewLi.active span a{color: #fff;}
</style>


<li class="parent_li" data-key="${homeManager.MN_KEYNO }"> 
	<span class="label label-primary">
		<i class="fa fa-lg fa-plus-circle">${homeManager.MN_NAME }</i>
	</span>
	
	<ul id="depth1Group">
		<c:set var="beforeDepth" value=""/>
		<c:forEach items="${menuList}" var="model" varStatus="status2">
			
			<c:if test="${(model.MN_PAGEDIV_C eq sp:getData('MENU_TYPE_SUBMENU') && model.MN_PAGEVIEW_CNT ne 0) 
			 || (model.MN_PAGEDIV_C eq sp:getData('MENU_TYPE_PAGE') || model.MN_PAGEDIV_C eq sp:getData('MENU_TYPE_PAGE2')
			 || (model.MN_PAGEDIV_C eq sp:getData('MENU_TYPE_SUBMENU') &&  not empty model.MN_FORWARD_URL))}">
				<c:set value="${fn:contains(menuActionAuthData,model.MN_KEYNO) ? true : false}" var="pageAuthBoolean"/>
				
				<c:if test="${ !status2.first && model.MN_LEV lt beforeDepth }">
					<c:forEach begin="${model.MN_LEV}" end="${beforeDepth - 1}">
					</ul>
				</li>
					</c:forEach>
				</c:if>
				
				<!-- 소메뉴 형 일경우 -->
				<c:if test="${model.MN_PAGEDIV_C eq sp:getData('MENU_TYPE_SUBMENU')}">
					<li class="parent_li" data-key="${model.MN_KEYNO }"> 
						<span class="label label-primary">
				  			<i class="fa fa-lg fa-plus-circle"></i>
				</c:if>
				
				<!--뷰 형일경우 -->
				<c:if test="${pageAuthBoolean && (model.MN_PAGEDIV_C eq sp:getData('MENU_TYPE_PAGE') || model.MN_PAGEDIV_C eq sp:getData('MENU_TYPE_PAGE2'))}">
					<li data-key="${model.MN_KEYNO }" class="pageViewLi"> 
						<span>
				  			<i class="fa fa-lg fa-caret-right" ></i> 
				</c:if>
						<c:choose>
							<c:when test="${pageAuthBoolean && (model.MN_PAGEDIV_C eq sp:getData('MENU_TYPE_PAGE') || model.MN_PAGEDIV_C eq sp:getData('MENU_TYPE_PAGE2'))}">
								<a href="#" onclick="pf_makepage('${model.MN_KEYNO}',this)" data-key="${model.MN_KEYNO}">
								<c:out value="${model.MN_NAME}" escapeXml="false" />
								</a>
							</c:when>
							<c:when test="${model.MN_PAGEDIV_C eq sp:getData('MENU_TYPE_SUBMENU')}">
								<c:out value="${model.MN_NAME}" escapeXml="false" />
							</c:when>
						</c:choose>
						</span>
						<c:if test="${pageAuthBoolean && model.MN_PAGEDIV_C eq sp:getData('MENU_TYPE_SUBMENU') && not empty model.MN_FORWARD_URL}">
							<a href="#" onclick="pf_makepage('${model.MN_KEYNO}',this)" data-key="${model.MN_KEYNO}">
							소개페이지
							</a>
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
			
			</c:if>
		</c:forEach>
	</ul>
	
	<script>

	$(function(){
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
	
	function pf_allOpenAndClose(type){
		if(type == 'O'){
			$('#depth1Group').closest('li').find('li.parent_li > span').each(function(){
				$(this).parent('li.parent_li').find(' > ul > li').show();
				$(this).attr('title', 'Collapse this branch').find(' > i').removeClass().addClass('fa fa-lg fa-minus-circle');
			})
		}else{
			$('#depth1Group').find('li.parent_li > span').each(function(){
				$(this).parent('li.parent_li').find(' > ul > li').hide();
				$(this).attr('title', 'Expand this branch').find(' > i').removeClass().addClass('fa fa-lg fa-plus-circle');
			})
		}
	}
	</script>
	
	
</li>


