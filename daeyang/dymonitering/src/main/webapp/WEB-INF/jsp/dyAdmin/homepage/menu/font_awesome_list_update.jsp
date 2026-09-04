<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<style>
.demo-icon-font:hover { background-color: rgba(0,0,0,0) !important;}
#menuIconView_update {font-size:50px; margin:15px 5px;} 
.menuIconBox {max-height:150px; overflow-y:scroll;}
.demo-icon-font {text-align:center; cursor:pointer;}
.demo-icon-font:HOVER i {font-size:30px; overflow:hidden; margin:-15px;}
.demo-icon-font.selectedIcon i {font-size:30px; overflow:hidden; margin:-15px; color:#3276b1;}

</style>
<script>
$(function(){
	/* 아이콘 클릭 시 모양 변경 및 값 저장 등 */
	$('#menuIconBox_update .demo-icon-font').on('click', function(){
	  $('#menuIconBox_update .demo-icon-font').removeClass('selectedIcon');
	  $(this).addClass('selectedIcon');
// 	  alert($(this).children('i').attr('class'));
	  var classNm = $(this).children('i').attr('class');
	  $('#menuIconView_update').attr('class','').addClass(classNm);
	  $('#Mainmenu-update-ICONBOX').val(classNm);
// 	  $('#MN_ICON_CSS').val(classNm);
	})
	
})
	
</script>

<%--
 update 모달창 : 메뉴의 삽입/수정 모달창이 각각 존재하여
  가독성을 위해 리스트 각각 따로 작성함
 --%>
 
 <%@ include file="/WEB-INF/jsp/dyAdmin/homepage/menu/font_awesome_list.jsp" %>

