<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>


<c:set var="beforeDepth" value=""/>

<c:forEach items="${resultList}" var="model" varStatus="status2">

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
		</span> - 
		<c:if test="${model.MN_USE_YN eq 'Y' }">
			<button type="button" class="btn bg-color-blueDark txt-color-white btn-xs" onclick="pf_Set_MenuManagerView('Update','${model.MN_HOMEDIV_C}','${model.MN_MAINKEY}','${model.MN_LEV}','${model.MN_KEYNO}','menu')" data-toggle="tooltip" data-placement="top" title="수정하기">
				<i class="fa fa-pencil"></i>
			</button>
			<c:if test="${model.MN_PAGEDIV_C eq sp:getData('MENU_TYPE_SUBMENU') }">   
			<button type="button" class="btn bg-color-blueDark txt-color-white btn-xs" onclick="pf_Set_MenuManagerView('Insert','${model.MN_HOMEDIV_C}', '${model.MN_KEYNO}','${model.MN_LEV}','${model.MN_URL }')" data-toggle="tooltip" data-placement="top" title="추가하기"><i class="fa fa-plus"></i></button>
			</c:if>
			<button type="button" class="btn bg-color-blueDark txt-color-white btn-xs" onclick="pf_ShowUseChecking('${model.MN_KEYNO}','N','use')" data-toggle="tooltip" data-placement="top" title="사용 안하기"><i class="fa fa-check-square-o"></i></button>
			<button type="button" class="btn bg-color-blueLight txt-color-white btn-xs" onclick="pf_MenuDelete('${model.MN_KEYNO}','${model.MN_MAINKEY }')" data-toggle="tooltip" data-placement="top" title="삭제하기"><i class="fa fa-trash-o"></i></button>
			<button type="button" class="btn bg-color-blueDark txt-color-white btn-xs" onclick="pf_ShowUseChecking('${model.MN_KEYNO}','${model.MN_SHOW_YN eq 'Y' ? 'N' : 'Y'}','show')" data-toggle="tooltip" data-placement="top" title="${model.MN_SHOW_YN eq 'Y' ? '메뉴 감추기' : '메뉴 보이기'}"><i class="fa ${model.MN_SHOW_YN eq 'Y' ? 'fa-unlock' : 'fa-lock'}"></i></button>
		<!-- DB에 저장된 페이지 바로가기 -->
		</c:if>
		<c:if test="${model.MN_USE_YN eq 'N' }">
			<button type="button" class="btn btn-warning btn-xs" onclick="pf_ShowUseChecking('${model.MN_KEYNO}','Y','use')" data-toggle="tooltip" data-placement="top" title="사용하기"><i class="fa fa-square-o"></i></button>
		</c:if>
		<button type="button" class="btn bg-color-blueDark txt-color-white btn-xs" onclick="pf_Set_MenuManagerView('Update','${model.MN_HOMEDIV_C}','${model.MN_MAINKEY}','${model.MN_LEV}','${model.MN_KEYNO}','auth')" data-toggle="tooltip" data-placement="top" title="권한설정"><i class="fa fa-sign-in"></i></button>
		<button  type="button" class="btn bg-color-blueDark txt-color-white btn-xs" onclick="pf_Set_MenuManagerView('Update','${model.MN_HOMEDIV_C}','${model.MN_MAINKEY}','${model.MN_LEV}','${model.MN_KEYNO}','deth')" data-toggle="tooltip" data-placement="top" title="뎁스이동"><i class="fa fa-exchange"></i></button>
		<!--게시판형  -->
		<c:if test="${model.MN_PAGEDIV_C eq sp:getData('MENU_TYPE_BOARD') }">
			<c:if test="${not empty model.MN_KEYNO }"> 
			<button  type="button" class="btn bg-color-blueDark txt-color-white btn-xs" onclick="pf_boardmanagement('${model.MN_KEYNO }')" data-toggle="tooltip" data-placement="top" title="게시물 관리"><i class="fa fa-book"></i></button>
			</c:if>
		</c:if>
		
		<!-- 소메뉴형일때 제외 -->
		<c:if test="${model.MN_PAGEDIV_C ne sp:getData('MENU_TYPE_SUBMENU') }">
			<button  type="button" class="btn bg-color-blueDark txt-color-white btn-xs" onclick="pf_qrchange('${model.MN_KEYNO }','${model.MN_URL }')" data-toggle="tooltip" data-placement="top" title="QR코드"><i class="fa fa-repeat"></i></button>
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
