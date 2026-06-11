<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

			










<script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.10.3/jquery-ui.min.js"></script>
<script>
	if (!window.jQuery.ui) {
		document.write('<script src="/resources/smartadmin/js/libs/jquery-ui-1.10.3.min.js"><\/script>');
	}
</script>

<%@ include file="/WEB-INF/jsp/user/_common/_Script/board/script_insertView_nomal.jsp"%>
<%@ include file="/WEB-INF/jsp/user/_common/_Script/board/script_insertView.jsp"%>

<article id="container" class="container_sub clearfix">
	<div class="inner">
		<div class="conSub01_bottomBox">
			<div class="innerContainer clearfix">
				<c:if test="false">
				<div id="html_contents"></div>
				</c:if>
				<form:form id="Form" name="Form" method="post" enctype="multipart/form-data">
						<input type="hidden" name="BD_BT_KEYNO" value="">
						<input type="hidden" name="BT_EMAIL_YN" value="">
						<input type="hidden" name="BT_EMAIL_ADDRESS" value="">
						<input type="hidden" name="BT_THUMBNAIL_INSERT" value="">
						<input type="hidden" name="BN_MN_KEYNO" value="MN_0000001610">
						<input type="hidden" name="MN_KEYNO" value="MN_0000001610">
						<input type="hidden" name="category" id="category" value="">
						<input type="hidden" name="BT_ZIP_YN" id="BT_ZIP_YN" value="">
						<input type="hidden" name="BT_THUMBNAIL_YN" value="">
						<input type="hidden" name="BN_KEYNO" id="BN_KEYNO" value="">
						<input type="hidden" name="fileUpdateCheck" id="fileUpdateCheck" value="N">
						<input type="hidden" name="action" id="action" value="update">
						
						<c:if test="false">
						<input type="hidden" name="BN_GONGNULI_TYPE" id="BN_GONGNULI_TYPE" value="">
						</c:if>
						<c:if test="false">
							<input type="hidden" name="BN_MAINKEY" id="BN_MAINKEY" value="">
							<input type="hidden" name="BN_PARENTKEY" id="BN_PARENTKEY" value="">
							<input type="hidden" name="BN_SEQ" id="BN_SEQ" value="">
							<input type="hidden" name="BN_DEPTH" id="BN_DEPTH" value="">
						</c:if>
						<c:if test="false">
							<input type="hidden" name="BN_REGNM" id="BN_REGNM" value="UI_SFMHO">
						</c:if>
						<c:if test="true">
							<input type="hidden" name="BN_MODNM" value="UI_SFMHO">
							<input type="hidden" name="BN_THUMBNAIL" id="BN_THUMBNAIL" value="">
						</c:if>
						<c:if test="false">
							<input type="hidden" name="BN_MOVE_MEMO" value="">
							<input type="hidden" name="BT_KEYNO" value="">
						</c:if>
						
					<c:if test="false">
					<div class="boardUploadWrap">
						<h3>이전 게시물 컬럼 데이터</h3>
						<c:if test="false">
							<c:forEach items="" var="model">
								<c:if test="false">
								<div class="row">
									<p class="titleBox">
										<label></label>
									</p>
									<p class="formBox">
										<input class="txtDefault txtWmiddle_1 column_data" type="text" value="" readonly="readonly">
										<select id="BD_DATA" class="txtDefault txtWmiddle_1">
											<option value="">선택하세요</option>
											<c:forEach items="" var="model2">
												<c:if test="true">
													<option value=""></option>
												</c:if>
											</c:forEach>
										</select>
										
										
										<input class="btn btnSmall_01" type="button" value="적용하기" onclick="pf_adjust('BD_DATA', '', '');">
										<a class="btn btn-default btn-xs" href="javascript:void(0);" onclick="pf_ClipBoard(this);">
											<!-- <i class="fa fa-copy"></i> -->복사하기
										</a>
									</p>
								</div>
								</c:if>
							</c:forEach>
						</c:if>
					</div>
					</c:if>
						
				<div class="boardUploadWrap">
					<c:if test="false">
					<div class="row">
				    	<p class="titleBox">
				        	<label for="BN_NAME">작성자</label>
				        </p>
				        <p class="formBox">
				        	<input type="text" class="txtDefault txtWlong_1" name="BN_NAME" id="BN_NAME" maxlength="10">
				        </p>
				    </div>
					<div class="row">
				    	<p class="titleBox">
				        	<label for="BN_PWD">비밀번호</label>
				        </p>
				        <p class="formBox">
				        	<input type="password" class="txtDefault txtWlong_1" name="BN_PWD" id="BN_PWD" maxlength="10">
				        </p>
				    </div>
				    </c:if>
				    
				    <c:if test="true">
					   	<div class="row lineheightBox">
					    	<p class="titleBox">
					        	<label>공지사용</label>
					        </p>
					        <p class="formBox">
					        	<label><input type="radio" class="radioDefault" name="BN_IMPORTANT" value="Y">공지(상단에 항상 노출)</label>
								<label><input type="radio" class="radioDefault" name="BN_IMPORTANT" value="N" checked>일반글</label>
					        </p>
					    </div>
					    <div class="row" style="border-bottom:1px solid #7b8292;margin-bottom:20px;padding-bottom:20px;">
					    	<p class="titleBox">
					        	<label for="BN_IMPORTANT_DATE">공지 종료일</label>
					        </p>
					        <p class="formBox">
					        	<input type="text" name="BN_IMPORTANT_DATE"  placeholder="입력안할시 날짜제한 없이 계속 공지글로 등록됩니다." class="txtDefault txtWlong_1" id="BN_IMPORTANT_DATE" maxlength="10" readonly value=""> <img src="/resources/img/icon/icon_calendar_01.png" alt="작성일선택">
					        </p>
					    </div>
						<script>
						$(function(){
							$('#BN_IMPORTANT_DATE').datepicker(datepickerOption);
						})
						</script>
					</c:if>
					
					<c:if test="false">
								<div class="row">
									<p class="titleBox">
						        	<label for="BN_CATEGORY_NAME">카테고리 구분</label>
						       		 </p>
									<select class="form-control input-sm" id="BN_CATEGORY_NAME"
										name="BN_CATEGORY_NAME">
										<option>전체</option>
										<c:forEach var="categoryname"
											items="[Ljava.lang.String;@2c2499ec">

											<option value=""
												selected></option>

										</c:forEach>

									</select>
								</div>
							</c:if>
					
				    
				    <c:forEach items="" var="model" varStatus="status">
						<input type="hidden" name="BD_BL_TYPE" value="">
						<input type="hidden" name="BD_BL_KEYNO" value="">
						<input type="hidden" id="BD_KEYNO" name="BD_KEYNO" value="">
						<c:set var="BL_VALIDATE" value=""/>
						<c:if test="false">
							<c:set var="BL_VALIDATE" value="BD_TYPE_VALIDATE"/>
						</c:if>
						<c:if test="false">
							<div class="row">
								<p class="titleBox">
						        	<label for="BD_DATA"></label>
						        </p>
						        <p class="formBox">
								<c:if test="false">
									<c:if test="false">
									<input type="text" class=" txtDefault txtWlong_1" data-title="" id="BD_DATA" name="BD_DATA" value="RE:" maxlength="70">
									</c:if>
									<c:if test="true">
									<input type="text" class=" txtDefault txtWlong_1" data-title="" id="BD_DATA" name="BD_DATA" value="" maxlength="70">
									</c:if>
								</c:if>
								<c:if test="true">
									<input type="text" class=" txtDefault txtWlong_1" data-title="" id="BD_DATA" name="BD_DATA" value="" maxlength="70">
								</c:if>
								</p>
							</div>
							<c:set var="checkTitle" value="true"/>
						</c:if>
						
						<c:if test="false">
							<c:set var="checkTitle" value="false"/>
							<div class="row">
								<p class="titleBox">
						        	<label for="thumbnail">썸네일</label>
						        </p>
						        <div class="formBox">
									<img style="width:px;height:px;margin:5px 0;" onerror="this.style.display='none';" src="" id="thumbnail_img" alt="썸네일"/>
									<div class="clear"></div>
									<input type="file" id="thumbnail" name="thumbnail" class="txtDefault txtWlong_1" onchange="cf_imgCheckAndPreview('thumbnail')"> <img src="/resources/img/icon/icon_attachment_01.png" alt="링크">
									<input type="hidden" name="thumbnail_text" id="thumbnail_text">
									<button type="button" onclick="thumnail_delete('')">썸네일 삭제</button>
									<p class="thumbnailNote">사이즈 ::  X  사이즈가 다를시 자동 리사이즈 됩니다.</p>
									<input type="hidden" name="BT_THUMBNAIL_WIDTH" value="">
									<input type="hidden" name="BT_THUMBNAIL_HEIGHT" value="">
								</div>
							</div>
						</c:if>

							

							<c:if test="false">
							<div class="row">
								<p class="titleBox">
						        	<label for="BD_DATA"></label>
						        </p>
						        <p class="formBox">
									<input type="text" class=" txtDefault txtWlong_1" data-title="" id="BD_DATA" name="BD_DATA" value="" maxlength="70">
								</p>
							</div>
						</c:if>
						
						<c:if test="false">
							<div class="row">
								<p class="titleBox">
						        	<label for="BD_DATA"></label>
						        </p>
						        <p class="formBox">
									<input type="text" class=" txtDefault txtWlong_1" data-title="" id="BD_DATA" name="BD_DATA" value="" maxlength="70">
									<button type="button" class="btn btnSmall_01" onclick="pf_link('BD_DATA')">링크 확인</button>
								</p>
							</div>
						</c:if>
						
						<c:if test="false">
							<div class="row">
								<p class="titleBox">
						        	<label for="BD_DATA"></label>
						        </p>
						        <p class="formBox">
									<input type="text" class=" txtDefault txtWlong_1 BD_DATA_CALENDAR" data-title="" id="BD_DATA" name="BD_DATA" value="" maxlength="10" readonly>  <img src="/resources/img/icon/icon_calendar_01.png" alt="작성일선택">
								</p>
							</div>
						</c:if>
						
						<c:if test="false">
							<div class="row">
								<p class="titleBox">
						        	<label for="BD_DATA"></label>
						        </p>
						        <p class="formBox">
									<input type="text" class=" txtDefault txtWlong_1 BD_DATA_CALENDAR_START" data-title="" id="BD_DATA" name="BD_DATA" value="" maxlength="10" readonly>  <img src="/resources/img/icon/icon_calendar_01.png" alt="작성일선택">
								</p>
							</div>
						</c:if>
						
						<c:if test="false">
							<div class="row">
								<p class="titleBox">
						        	<label for="BD_DATA"></label>
						        </p>
						        <p class="formBox">
									<input type="text" class=" txtDefault txtWlong_1 BD_DATA_CALENDAR_END" data-title="" id="BD_DATA" name="BD_DATA" value="" maxlength="10" readonly>  <img src="/resources/img/icon/icon_calendar_01.png" alt="작성일선택">
								</p>
							</div>
						</c:if>
						
						
						<c:if test="false">
							<div class="row">
								<p class="titleBox">
						        	<label for="BD_DATA"></label>
						        </p>
						        <p class="formBox">
									<input type="password" class=" txtDefault txtWlong_1" data-title="" id="BD_DATA" name="BD_DATA" value="" maxlength="20">
								</p>
							</div>
						</c:if>
						
						<c:if test="false">
							<div class="row">
								<p class="titleBox">
						        	<label for="BD_DATA"></label>
						        </p>
						        <p class="formBox">
									<input type="text" class=" txtDefault txtWlong_1 BD_DATA_EMAIL" data-title="" id="BD_DATA" name="BD_DATA" value="" maxlength="30">
								</p>
							</div>
						</c:if>
						
						<c:if test="false">
							<div class="row">
								<p class="titleBox">
						        	<label for="BD_DATA"></label>
						        </p>
						        <p class="formBox">
									<input type="number" class=" txtDefault txtWlong_1 BD_DATA_NUMBER" data-title="" id="BD_DATA" name="BD_DATA" value="" oninput="cf_maxLengthCheck(this)" max="99999999999" maxlength="11">
								</p>
							</div>
						</c:if>
						
						<c:if test="false">
							<div class="row lineheightBox">
								<p class="titleBox">
						        	<label></label>
						        </p>
						        <p class="formBox">
									<input type="hidden" name="BD_DATA" id="BD_DATA" value=""  class=" txtDefault txtWlong_1" data-type="check" data-title="">
									<c:set var="checkData" value="[Ljava.lang.String;@1092c58"></c:set>
									<c:forEach items="" var="OPTIONDATA" varStatus="c">
										<label><input type="checkbox" name="BD_DATA" value="" onchange="pf_checkOption(this)">
										</label>
									</c:forEach>
								</p>
							</div>
						</c:if>
						
						<c:if test="false">
							<div class="row lineheightBox">
								<p class="titleBox">
						        	<label></label>
						        </p>
						        <p class="formBox">
								<input type="hidden" name="BD_DATA" id="BD_DATA" value="" class=" txtDefault txtWlong_1" data-type="radio" data-title="">
								<c:set var="checkData" value="[Ljava.lang.String;@727ab056"></c:set>
								<c:forEach items="" var="OPTIONDATA" varStatus="c">
									<label><input type="radio" name="BD_DATA" value="" onchange="pf_radioOption(this)">
									</label>
								</c:forEach>
								</p>
							</div>
						</c:if>
						
						<c:if test="false">
							<div class="row">
								<p class="titleBox">
						        	<label></label>
						        </p>
						        <p class="formBox">
									<select name="BD_DATA" id="BD_DATA" class=" txtDefault txtWlong_1" data-title="">
										<option value="">선택하세요</option>
										<c:set var="selectData" value="[Ljava.lang.String;@7b25b941"></c:set>
										<c:forEach items="" var="OPTIONDATA">
											<option value=""></option>
										</c:forEach>
									</select>
								</p>
							</div>
						</c:if>
						
						<c:if test="false">
							<div class="row lineheightBox">
								<p class="titleBox">
						        	<label></label>
						        </p>
						        <p class="formBox">
								<input type="hidden" name="BD_DATA" id="BD_DATA" value=""  class=" txtDefault txtWlong_1" data-type="check" data-title="">
								<c:forEach items="" var="OPTIONDATA" varStatus="c">
									<c:if test="true">
									<label><input type="checkbox" name="BD_DATA" value="" onchange="pf_checkOption(this)">
									</label>
									</c:if>
								</c:forEach>
								</p>
							</div>
						</c:if>
						
						<c:if test="false">
							<div class="row lineheightBox">
								<p class="titleBox">
						        	<label></label>
						        </p>
						        <p class="formBox">
								<input type="hidden" name="BD_DATA" id="BD_DATA" value="" class=" txtDefault txtWlong_1" data-type="radio" data-title="">
								<c:forEach items="" var="OPTIONDATA" varStatus="c">
									<c:if test="true">
									<label><input type="radio" name="BD_DATA" value="" onchange="pf_radioOption(this)">
									</label>
									</c:if>
								</c:forEach>
								</p>
							</div>
						</c:if>
						
						<c:if test="false">
							<div class="row">
								<p class="titleBox">
						        	<label></label>
						        </p>
						        <p class="formBox">
									<select name="BD_DATA" id="BD_DATA" class=" txtDefault txtWlong_1" data-title="">
										<option value="">선택하세요</option>
										<c:forEach items="" var="OPTIONDATA">
											<c:if test="true">
											<option value=""></option>
											</c:if>
										</c:forEach>
									</select>
								</p>
							</div>
						</c:if>
						
					</c:forEach>
				    <c:if test="false"> 
							<div class="row">
								<p class="titleBox">
									<label>첨부파일</label>
						        </p>
						        <div class="formBox">

								<%@ include file="/WEB-INF/jsp/dyAdmin/operation/file/pra_file_insertView.jsp"%>
								
								<c:if test="true">
									<input type="hidden" name="fsSize" id="fsSize" value="0">
									<input type="hidden" name="BN_FM_KEYNO" id="BN_FM_KEYNO" value="">
								</c:if>
								</div>		
							</div>
					</c:if>
				    <c:if test="false">
						<div class="row lineheightBox">
					    	<p class="titleBox">
					        	<label>비밀글 여부</label>
					        </p>
					        <p class="formBox">
					        	<label><input type="radio" class="radioDefault" name="BN_SECRET_YN" value="Y">비밀글</label>
								<label><input type="radio" class="radioDefault" name="BN_SECRET_YN" value="N" checked>일반글</label>
					        </p>
					    </div>
					</c:if>
					
 				    <div class="row lineheightBox">
				    	<p class="titleBox">
				        	<label>내용</label>
				        </p>
				        <p class="formBox">
						<c:if test="false">
							<textarea name="BN_CONTENTS" id="BN_CONTENTS" rows="5" style="width:100%;height:400px;min-width:260px;padding:10px;" onkeydown="useTab(this);" title="내용을 입력해주세요"></textarea>
						</c:if>
						<c:if test="true">
							<textarea name="BN_CONTENTS" id="BN_CONTENTS" rows="5" style="width:100%;height:400px;min-width:260px;padding:10px;" onkeydown="useTab(this);" title="내용을 입력해주세요"></textarea>
						</c:if>
						 </p>
					</div>
					<c:if test="false">
					<div class="row" id="editorbox" >
						<p class="titleBox"><label>에디터이미지</label></p>
				        <div class="formBox">
							<div class="clear"></div>
							<input type="file" id="smartimg" name="smartimg" class="txtDefault txtWlong_1" onchange="selectFiles(this,'smartimg');" multiple="multiple">
							<input type="button" id="imgsettingbutton" onclick="imgSetting();" value="적용">
							<input type="hidden" id="selectedImg">
							<div id="smartimg_img">
							</div>
						</div>
					</div>
					</c:if>
				    <c:if test="false">
			            <div>
							<%@ include file="/WEB-INF/jsp/user/_common/prc_gong_nuli_insert.jsp" %>                            
			            </div>
		            </c:if>   
				                       
				</div>
				<div class="btnBox textC">
					<c:if test="false">
					<button type="button" class="btn btnBig_02 btn-default" onclick="pf_boardDataInsert()">글쓰기</button>
					</c:if>
					<c:if test="true">
					<button type="button" class="btn btnBig_02 btn-default" onclick="pf_boardDataUpdate()">수정</button>
					</c:if>
					<c:if test="false">
					<button type="button" class="btn btnBig_02 btn-default" onclick="pf_boardDataUpdate('update')">이동</button>
					</c:if>
					<button type="button" class="btn btnBig_02 btn-default" onclick="pf_back()">취소</button>
				</div>
				</form:form>
				<c:if test="false">
				<div id="html_contents"></div>
				</c:if>
			</div>
		</div>
	</div>
</article>
<!-- 개인정보 보안 dialog -->
<div id="page_comment" title="페이지 평가 결과">
	<div class="widget-body ">
		<fieldset>
			<div class="form-horizontal">
				<fieldset>
					<div class="form-group">
						<label class="col-md-2 control-label"><h6> 경고 :: </h6></label>
						
						<div class="col-md-10 tps_comment" style="margin-top: 13px">
							 게시판 작성 내용중 <strong>개인정보</strong>가 포함되어 있는 것으로 판단되어 글 등록이 보류되었습니다.<br>
						개인정보 보호를 위하여 <strong>주민번호, 핸드폰 번호</strong> 등 입력은 <strong>금지</strong>하여 주시기 바랍니다
						</div>
					</div>
					
					<div class="form-group">
						<label class="col-md-2 control-label"><h6> 발견된 정보  :: </h6></label>
						<div class="col-md-10 Menu_name" style="margin-top: 20px">
						
						</div>
					</div>
					
					
				</fieldset>
			</div>
		</fieldset>
	</div>
</div>

<c:if test="false">
	<%@ include file="/WEB-INF/jsp/user/_common/_Script/board/include/prc_img_setting.jsp" %>      
</c:if>
	    