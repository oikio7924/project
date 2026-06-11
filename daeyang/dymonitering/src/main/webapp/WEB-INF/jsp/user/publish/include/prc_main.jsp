<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<%@ include file="/WEB-INF/jsp/setting/settingData.jsp"%>

<div style="width:100%;min-height:600px;text-align:center;padding-top:400px;font-size:20px;">메인화면!!</div>

  <p>
    여기도 테스트111
  </p>

<script>
function pf_search(id){
	if(!$('#'+id).val()){
		alert('검색어를 입력해주세요.');
		$('#'+id).focus();
		return false;
	}
	location.href="/jcia/search.do?searchKeyword="+$('#'+id).val();
}

</script>