<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>


<form:form action="" id="Form2" name="Form2" method="post" >

<div class="tree">
	<ul>		
	
<!-- 파일 출력-->
<c:forEach items="${resultList}" var="model" varStatus="status">
<li> 
		<input type="checkbox" name="FILE_PATH" value="${model.filePath }">
		<span class="file_original">
			<label class="input">
  			<i class="fa fa-lg fa-file"></i> 
  			<c:out value="${model.fileNm}"/>
			</label>
		</span>
		<label class="input file_update" style="display: none;">
			<input type="text" class="NEW_FILE_NAME" value="${model.fileNm}"/>
		</label>
		 - 
		<button type="button" class="btn btn-success btn-xs update_btn" title="이름 수정하기" onclick="pf_file_update(this);"><i class="fa fa-pencil"></i></button>
		<button type="button" class="btn btn-primary btn-xs save_btn" title="저장하기" onclick="pf_file_ok(this,'${model.filePath}');" style="display: none;"><i class="fa fa-check"></i></button>
		<button type="button" class="btn btn-danger btn-xs cancel_btn" title="취소하기" onclick="pf_file_cancel(this);" style="display: none;"><i class="fa fa-times"></i></button>
		<button type="button" class="btn btn-warning btn-xs down_btn" title="파일 다운받기" onclick="pf_download_webFile('${model.filePath}');"><i class="fa fa-download"></i></button>
		<button type="button" class="btn btn-danger btn-xs drop_btn" title="파일 삭제하기" onclick="pf_file_delete('${model.filePath}');"><i class="fa fa-trash-o"></i></button>
		<button type="button" class="btn btn-default btn-xs copy_btn" title="파일 경로 복사하기" onclick="pf_file_copy('${model.filePath}');"><i class="fa fa-copy"></i></button>
	</li>
</c:forEach>
  	</ul>
</div>

</form:form>