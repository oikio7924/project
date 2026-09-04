<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
  
  <button type="button" onclick="pf_test()">
    테스트!12
  </button>
 
<script>
 
  function pf_test(){
    $.ajax({
				type: "POST",
				url: "/dy/tes1tAjax.do",
				async :false,
				success : function(data){
                  	alert('11')
				},
				error: function(jqXHR, textStatus, errorThrown){
					alert('22')
				}
		   });
  }
  


</script>