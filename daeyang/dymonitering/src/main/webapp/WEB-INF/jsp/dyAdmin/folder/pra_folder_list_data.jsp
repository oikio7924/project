<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>

<!-- 폴더 출력-->
<c:forEach items="${resultList}" var="model" varStatus="status">

<li class="parent_li" data-path="${model.filePath}" data-depth="${model.fileDepth }"> 
		<span class="label label-primary">
  			<i class="fa fa-lg fa-plus-circle"></i> 
				<c:out value="${model.fileNm}" />
				</span>
				<button type="button" class="btn btn-success btn-xs" title="폴더 수정하기" onclick="pf_Set_FolderUpdateView('${model.filePath}','${model.fileNm}','${model.fileDepth}')"><i class="fa fa-pencil"></i></button>
				<button type="button" class="btn btn-primary btn-xs" title="폴더 등록하기" onclick="pf_Set_FolderInsertView('${model.filePath}','${model.fileDepth}')"><i class="fa fa-plus"></i></button>
				<button type="button" class="btn btn-warning btn-xs" title="폴더 다운로드" onclick="pf_Set_FolderDownload('${model.filePath}','${model.fileNm}')"><i class="fa fa-download"></i></button>
				<button type="button" class="btn btn-danger btn-xs" title="폴더 삭제하기" onclick="pf_FolderDelete('${model.filePath}','${model.fileDepth}')"><i class="fa fa-trash-o"></i></button>
		<ul></ul>
	</li>
</c:forEach>
							