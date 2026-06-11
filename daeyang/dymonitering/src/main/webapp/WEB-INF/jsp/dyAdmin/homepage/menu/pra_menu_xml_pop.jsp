<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>

<style>
div .dl-horizontal {margin-top:5px}
.dl-horizontal dt {line-height: 30px;}
.dl-horizontal dt span{color:red;}
.url-input-span {float: left;display: block;line-height: 32px;padding-left:10px;color:#3276b1}
.url-input input{border: 0px !important;float: left;padding-left:0 !important;}


.authorityTable {max-height:300px;overflow-y:scroll}
.smart-form .radio:first-of-type {margin-left:0}
.checkbox-inline, .radio-inline {display:inline-block !important;}
.smart-form .checkbox:last-child, .smart-form .radio:last-child {margin-bottom:4px;}

.select2-selection__rendered {padding-left:5px !important;}

</style>

<!-- xml 히스토리 레이어창 --> 
<div id="Xml-history" title="xml 히스토리">
	<div class="widget-body smart-form">
		<table id="XmlListTable" class="table table-striped table-bordered table-hover table-center" style="margin: 0 auto; width: 98%;">
			<thead>
				<tr>
					<th>파일명</th>
					<th>백업일자</th>
					<th>관리</th>				
					<th>설정</th>				
				</tr>
			</thead>
			<tbody>
			
			</tbody>
		
		</table>
	</div>
</div>			
	
