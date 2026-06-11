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

<!-- 폴더 생성화면 레이어창 --> 
<div id="Folder-insert" title="폴더 추가">
	<div class="widget-body no-padding smart-form">
		<br/>
		<fieldset>
			<div class="necessT">
		         <span class="colorR fs12">* 표시는 필수 입력 항목입니다.</span>
		     </div>
			<section class="col col-12">	
				<dl class="dl-horizontal">
					<dt><span>*</span> 폴더명</dt>
					<dd>
					  <label class="input"> 
              			<i class="icon-append fa fa-question-circle"></i>
						    <input type="text" id="Folder-insert-NAME" placeholder="폴더명을 입력하세요" maxlength="50"/>
						</label>
					</dd>
				</dl>
			</section>
		</fieldset>
	</div>
</div>			
			
<!-- 대메뉴 수정화면 레이어창 -->
<div id="Folder-update" title="메뉴 수정">
	<div class="widget-body no-padding smart-form">
		<br/>
		<fieldset>
			<div class="necessT">
		         <span class="colorR fs12">*표시는 필수 입력 항목입니다.</span>
		    </div>
			<section class="col col-12">	
				<dl class="dl-horizontal">
					<dt><span>*</span> 폴더명</dt>
					<dd>
						<label class="input"> 
	            			<i class="icon-append fa fa-question-circle"></i>
							<input  type="text" id="Folder-update-NAME" placeholder="폴더명을 입력하세요" value="" maxlength="50">
					  </label>
					</dd>
				</dl>
			</section>
		</fieldset>
	</div>
</div>





