<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<article id="container" class="container_sub clearfix">
	<div class="inner">
		<div class="conSub01_bottomBox">
			<div class="innerContainer clearfix">
				<c:if test="${BoardHtml.BIH_DIV_LOCATION eq 'T' }">
				<div id="html_contents">${BoardHtml.BIH_CONTENTS }</div>
				</c:if>
				<form:form id="Form" name="Form" method="post" enctype="multipart/form-data">
						<input type="hidden" name="BD_BT_KEYNO" value="${BoardType.BT_KEYNO }">
						<input type="hidden" name="BT_EMAIL_YN" value="${BoardType.BT_EMAIL_YN }">
						<input type="hidden" name="BT_EMAIL_ADDRESS" value="${BoardType.BT_EMAIL_ADDRESS }">
						<input type="hidden" name="BT_THUMBNAIL_INSERT" value="${BoardType.BT_THUMBNAIL_INSERT }">
						<input type="hidden" name="BN_MN_KEYNO" value="${Menu.MN_KEYNO}">
						<input type="hidden" name="MN_KEYNO" value="${Menu.MN_KEYNO }">
						<input type="hidden" name="category" id="category" value="${category}">
						<input type="hidden" name="BT_ZIP_YN" id="BT_ZIP_YN" value="${BoardType.BT_ZIP_YN}">
						<input type="hidden" name="BT_THUMBNAIL_YN" value="${BoardType.BT_THUMBNAIL_YN  }">
						<input type="hidden" name="BN_KEYNO" id="BN_KEYNO" value="${replyCk ? '' : BoardNotice.BN_KEYNO }">
						<input type="hidden" name="BN_HTMLMAKER_PLUS_TYPE" id="BN_HTMLMAKER_PLUS_TYPE" value="${BoardType.BT_HTMLMAKER_PLUS_YN}">
						<input type="hidden" name="fileUpdateCheck" id="fileUpdateCheck" value="N">
						<input type="hidden" name="action" id="action" value="${action}">
						
						<c:if test="${currentMenu.MN_GONGNULI_YN eq 'Y'}">
						<input type="hidden" name="BN_GONGNULI_TYPE" id="BN_GONGNULI_TYPE" value="${not empty BoardNotice.BN_GONGNULI_TYPE ? BoardNotice.BN_GONGNULI_TYPE : currentMenu.MN_GONGNULI_TYPE }">
						</c:if>
						<c:if test="${not empty BoardNotice}">
							<input type="hidden" name="BN_MAINKEY" id="BN_MAINKEY" value="${BoardNotice.BN_MAINKEY }">
							<input type="hidden" name="BN_PARENTKEY" id="BN_PARENTKEY" value="${BoardNotice.BN_KEYNO}">
							<input type="hidden" name="BN_SEQ" id="BN_SEQ" value="${BoardNotice.BN_SEQ }">
							<input type="hidden" name="BN_DEPTH" id="BN_DEPTH" value="${BoardNotice.BN_DEPTH}">
						</c:if>
						<c:if test="${action eq 'insert' }">
							<input type="hidden" name="BN_REGNM" id="BN_REGNM" value="${userInfo.UI_KEYNO }">
						</c:if>
						<c:if test="${action eq 'update' || action eq 'move'  }">
							<input type="hidden" name="BN_MODNM" value="${userInfo.UI_KEYNO }">
							<input type="hidden" name="BN_THUMBNAIL" id="BN_THUMBNAIL" value="${BoardNotice.BN_THUMBNAIL }">
						</c:if>
						<c:if test="${action eq 'move' }">
							<input type="hidden" name="BN_MOVE_MEMO" value="${BoardNotice.BN_MOVE_MEMO }">
							<input type="hidden" name="BT_KEYNO" value="${PreBoardType.BT_KEYNO }">
						</c:if>
						
					<c:if test="${action eq 'move' }">
					<div class="boardUploadWrap">
						<h3>이전 게시물 컬럼 데이터</h3>
						<c:if test="${action eq 'move' && BoardType.BT_KEYNO ne PreBoardType.BT_KEYNO }">
							<c:forEach items="${PreBoardColumnData }" var="model">
								<c:if test="${model.BD_BL_TYPE ne sp:getData('BOARD_COLUMN_TYPE_TITLE') and !empty model.BD_DATA}">
								<div class="row">
									<p class="titleBox">
										<label>${model.COLUMN_NAME }</label>
									</p>
									<p class="formBox">
										<input class="txtDefault txtWmiddle_1 column_data" type="text" value="${model.BD_DATA }" readonly="readonly">
										<select id="BD_DATA${model.BD_KEYNO }" class="txtDefault txtWmiddle_1">
											<option value="">선택하세요</option>
											<c:forEach items="${BoardColumnList }" var="model2">
												<c:if test="${model.BD_BL_TYPE eq model2.BL_TYPE }">
													<option value="${model2.BL_KEYNO }">${model2.BL_COLUMN_NAME }</option>
												</c:if>
											</c:forEach>
										</select>
										
										
										<input class="btn btnSmall_01" type="button" value="적용하기" onclick="pf_adjust('BD_DATA${model.BD_KEYNO }', '${model.BD_BL_TYPE}', '${model.BD_DATA_ORI}');">
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
					<c:if test="${action eq 'insert' && empty userInfo}">
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
				    
				    <c:if test="${userInfo.isAdmin eq 'Y'}">
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
					        	<input type="text" name="BN_IMPORTANT_DATE"  placeholder="입력안할시 날짜제한 없이 계속 공지글로 등록됩니다." class="txtDefault txtWlong_1" id="BN_IMPORTANT_DATE" maxlength="10" readonly value="${BoardNotice.BN_IMPORTANT_DATE }"> <img src="/resources/img/icon/icon_calendar_01.png" alt="작성일선택">
					        </p>
					    </div>
						<script>
						$(function(){
							$('#BN_IMPORTANT_DATE').datepicker(datepickerOption);
						})
						</script>
					</c:if>
					
					<c:if test="${BoardType.BT_CATEGORY_YN eq 'Y' }">
								<div class="row">
									<p class="titleBox">
						        	<label for="BN_CATEGORY_NAME">카테고리 구분</label>
						       		 </p>
									<select class="form-control input-sm" id="BN_CATEGORY_NAME"
										name="BN_CATEGORY_NAME">
										<option>전체</option>
										<c:forEach var="categoryname"
											items="${ fn:split(BoardType.BT_CATEGORY_INPUT,',')}">

											<option value="${categoryname }"
												${categoryname eq BoardNotice.BN_CATEGORY_NAME ? 'selected' : ''}>${categoryname }</option>

										</c:forEach>

									</select>
								</div>
							</c:if>
					
				    
				    <c:forEach items="${BoardColumnList }" var="model" varStatus="status">
						<input type="hidden" name="BD_BL_TYPE" value="${model.BL_TYPE }">
						<input type="hidden" name="BD_BL_KEYNO" value="${model.BL_KEYNO }">
						<input type="hidden" id="BD_KEYNO${model.BL_KEYNO }" name="BD_KEYNO" value="">
						<c:set var="BL_VALIDATE" value=""/>
						<c:if test="${model.BL_VALIDATE eq 'Y' }">
							<c:set var="BL_VALIDATE" value="BD_TYPE_VALIDATE"/>
						</c:if>
						<c:if test="${model.BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_TITLE') }">
							<div class="row">
								<p class="titleBox">
						        	<label for="BD_DATA${model.BL_KEYNO }">${model.BL_COLUMN_NAME }</label>
						        </p>
						        <p class="formBox">
								<c:if test="${not empty BoardNotice }">
									<c:if test="${action eq 'insert' }">
									<input type="text" class="${BL_VALIDATE} txtDefault txtWlong_1" data-title="${model.BL_COLUMN_NAME }" id="BD_DATA${model.BL_KEYNO }" name="BD_DATA" value="RE:${BoardNotice.BN_TITLE}" maxlength="70">
									</c:if>
									<c:if test="${action eq 'update' || action eq 'move' }">
									<input type="text" class="${BL_VALIDATE} txtDefault txtWlong_1" data-title="${model.BL_COLUMN_NAME }" id="BD_DATA${model.BL_KEYNO }" name="BD_DATA" value="${BoardNotice.BN_TITLE}" maxlength="70">
									</c:if>
								</c:if>
								<c:if test="${empty BoardNotice }">
									<input type="text" class="${BL_VALIDATE} txtDefault txtWlong_1" data-title="${model.BL_COLUMN_NAME }" id="BD_DATA${model.BL_KEYNO }" name="BD_DATA" value="" maxlength="70">
								</c:if>
								</p>
							</div>
							<c:set var="checkTitle" value="true"/>
						</c:if>
						
						<c:if test="${checkTitle && BoardType.BT_THUMBNAIL_YN eq 'Y' }">
							<c:set var="checkTitle" value="false"/>
							<div class="row">
								<p class="titleBox">
						        	<label for="thumbnail">썸네일</label>
						        </p>
						        <div class="formBox">
									<img style="width:${BoardType.BT_THUMBNAIL_WIDTH }px;height:${BoardType.BT_THUMBNAIL_HEIGHT }px;margin:5px 0;" onerror="this.style.display='none';" src="${BoardNotice.THUMBNAIL_PUBLIC_PATH }" id="thumbnail_img" alt="썸네일"/>
									<div class="clear"></div>
									<input type="file" id="thumbnail" name="thumbnail" class="txtDefault txtWlong_1" onchange="cf_imgCheckAndPreview('thumbnail')"> <img src="/resources/img/icon/icon_attachment_01.png" alt="링크">
									<input type="hidden" name="thumbnail_text" id="thumbnail_text">
									<button type="button" onclick="thumnail_delete('${BoardNotice.BN_KEYNO }')">썸네일 삭제</button>
									<p class="thumbnailNote">사이즈 :: ${BoardType.BT_THUMBNAIL_WIDTH } X ${BoardType.BT_THUMBNAIL_HEIGHT } 사이즈가 다를시 자동 리사이즈 됩니다.</p>
									<input type="hidden" name="BT_THUMBNAIL_WIDTH" value="${BoardType.BT_THUMBNAIL_WIDTH }">
									<input type="hidden" name="BT_THUMBNAIL_HEIGHT" value="${BoardType.BT_THUMBNAIL_HEIGHT  }">
								</div>
							</div>
						</c:if>

							

							<c:if test="${model.BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_TEXT') }">
							<div class="row">
								<p class="titleBox">
						        	<label for="BD_DATA${model.BL_KEYNO }">${model.BL_COLUMN_NAME }</label>
						        </p>
						        <p class="formBox">
									<input type="text" class="${BL_VALIDATE} txtDefault txtWlong_1" data-title="${model.BL_COLUMN_NAME }" id="BD_DATA${model.BL_KEYNO }" name="BD_DATA" value="" maxlength="70">
								</p>
							</div>
						</c:if>
						
						<c:if test="${model.BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_LINK') }">
							<div class="row">
								<p class="titleBox">
						        	<label for="BD_DATA${model.BL_KEYNO }">${model.BL_COLUMN_NAME }</label>
						        </p>
						        <p class="formBox">
									<input type="text" class="${BL_VALIDATE} txtDefault txtWlong_1" data-title="${model.BL_COLUMN_NAME }" id="BD_DATA${model.BL_KEYNO }" name="BD_DATA" value="" maxlength="70">
									<button type="button" class="btn btnSmall_01" onclick="pf_link('BD_DATA${model.BL_KEYNO }')">링크 확인</button>
								</p>
							</div>
						</c:if>
						
						<c:if test="${model.BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_CALENDAR')}">
							<div class="row">
								<p class="titleBox">
						        	<label for="BD_DATA${model.BL_KEYNO }">${model.BL_COLUMN_NAME }</label>
						        </p>
						        <p class="formBox">
									<input type="text" class="${BL_VALIDATE} txtDefault txtWlong_1 BD_DATA_CALENDAR" data-title="${model.BL_COLUMN_NAME }" id="BD_DATA${model.BL_KEYNO }" name="BD_DATA" value="" maxlength="10" readonly>  <img src="/resources/img/icon/icon_calendar_01.png" alt="작성일선택">
								</p>
							</div>
						</c:if>
						
						<c:if test="${model.BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_CALENDAR_START') }">
							<div class="row">
								<p class="titleBox">
						        	<label for="BD_DATA${model.BL_KEYNO }">${model.BL_COLUMN_NAME }</label>
						        </p>
						        <p class="formBox">
									<input type="text" class="${BL_VALIDATE} txtDefault txtWlong_1 BD_DATA_CALENDAR_START" data-title="${model.BL_COLUMN_NAME }" id="BD_DATA${model.BL_KEYNO }" name="BD_DATA" value="" maxlength="10" readonly>  <img src="/resources/img/icon/icon_calendar_01.png" alt="작성일선택">
								</p>
							</div>
						</c:if>
						
						<c:if test="${model.BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_CALENDAR_END') }">
							<div class="row">
								<p class="titleBox">
						        	<label for="BD_DATA${model.BL_KEYNO }">${model.BL_COLUMN_NAME }</label>
						        </p>
						        <p class="formBox">
									<input type="text" class="${BL_VALIDATE} txtDefault txtWlong_1 BD_DATA_CALENDAR_END" data-title="${model.BL_COLUMN_NAME }" id="BD_DATA${model.BL_KEYNO }" name="BD_DATA" value="" maxlength="10" readonly>  <img src="/resources/img/icon/icon_calendar_01.png" alt="작성일선택">
								</p>
							</div>
						</c:if>						
						
						<c:if test="${model.BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_PWD') }">
							<div class="row">
								<p class="titleBox">
						        	<label for="BD_DATA${model.BL_KEYNO }">${model.BL_COLUMN_NAME }</label>
						        </p>
						        <p class="formBox">
									<input type="password" class="${BL_VALIDATE} txtDefault txtWlong_1" data-title="${model.BL_COLUMN_NAME }" id="BD_DATA${model.BL_KEYNO }" name="BD_DATA" value="" maxlength="20">
								</p>
							</div>
						</c:if>
						
						<c:if test="${model.BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_EMAIL') }">
							<div class="row">
								<p class="titleBox">
						        	<label for="BD_DATA${model.BL_KEYNO }">${model.BL_COLUMN_NAME }</label>
						        </p>
						        <p class="formBox">
									<input type="text" class="${BL_VALIDATE} txtDefault txtWlong_1 BD_DATA_EMAIL" data-title="${model.BL_COLUMN_NAME }" id="BD_DATA${model.BL_KEYNO }" name="BD_DATA" value="" maxlength="30">
								</p>
							</div>
						</c:if>
						
						<c:if test="${model.BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_NUMBER') }">
							<div class="row">
								<p class="titleBox">
						        	<label for="BD_DATA${model.BL_KEYNO }">${model.BL_COLUMN_NAME }</label>
						        </p>
						        <p class="formBox">
									<input type="number" class="${BL_VALIDATE} txtDefault txtWlong_1 BD_DATA_NUMBER" data-title="${model.BL_COLUMN_NAME }" id="BD_DATA${model.BL_KEYNO }" name="BD_DATA" value="" oninput="cf_maxLengthCheck(this)" max="99999999999" maxlength="11">
								</p>
							</div>
						</c:if>
						
						<c:if test="${model.BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_CHECK') }">
							<div class="row lineheightBox">
								<p class="titleBox">
						        	<label>${model.BL_COLUMN_NAME }</label>
						        </p>
						        <p class="formBox">
									<input type="hidden" name="BD_DATA" id="BD_DATA${model.BL_KEYNO }" value=""  class="${BL_VALIDATE} txtDefault txtWlong_1" data-type="check" data-title="${model.BL_COLUMN_NAME }">
									<c:set var="checkData" value="${fn:split(model.BL_OPTION_DATA, '|') }"></c:set>
									<c:forEach items="${checkData }" var="OPTIONDATA" varStatus="c">
										<label><input type="checkbox" name="BD_DATA${model.BL_KEYNO }" value="${OPTIONDATA }" onchange="pf_checkOption(this)">
										${OPTIONDATA }</label>
									</c:forEach>
								</p>
							</div>
						</c:if>
						
						<c:if test="${model.BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_RADIO') }">
							<div class="row lineheightBox">
								<p class="titleBox">
						        	<label>${model.BL_COLUMN_NAME }</label>
						        </p>
						        <p class="formBox">
								<input type="hidden" name="BD_DATA" id="BD_DATA${model.BL_KEYNO }" value="" class="${BL_VALIDATE} txtDefault txtWlong_1" data-type="radio" data-title="${model.BL_COLUMN_NAME }">
								<c:set var="checkData" value="${fn:split(model.BL_OPTION_DATA, '|') }"></c:set>
								<c:forEach items="${checkData }" var="OPTIONDATA" varStatus="c">
									<label><input type="radio" name="BD_DATA${model.BL_KEYNO }" value="${OPTIONDATA }" onchange="pf_radioOption(this)">
									${OPTIONDATA }</label>
								</c:forEach>
								</p>
							</div>
						</c:if>
						
						<c:if test="${model.BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_SELECT') }">
							<div class="row">
								<p class="titleBox">
						        	<label>${model.BL_COLUMN_NAME }</label>
						        </p>
						        <p class="formBox">
									<select name="BD_DATA" id="BD_DATA${model.BL_KEYNO }" class="${BL_VALIDATE} txtDefault txtWlong_1" data-title="${model.BL_COLUMN_NAME }">
										<option value="">선택하세요</option>
										<c:set var="selectData" value="${fn:split(model.BL_OPTION_DATA, '|') }"></c:set>
										<c:forEach items="${selectData }" var="OPTIONDATA">
											<option value="${OPTIONDATA }">${OPTIONDATA }</option>
										</c:forEach>
									</select>
								</p>
							</div>
						</c:if>
						
						<c:if test="${model.BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_CHECK_CODE') }">
							<div class="row lineheightBox">
								<p class="titleBox">
						        	<label>${model.BL_COLUMN_NAME }</label>
						        </p>
						        <p class="formBox">
								<input type="hidden" name="BD_DATA" id="BD_DATA${model.BL_KEYNO }" value=""  class="${BL_VALIDATE} txtDefault txtWlong_1" data-type="check" data-title="${model.BL_COLUMN_NAME }">
								<c:forEach items="${BoardColumnCodeList }" var="OPTIONDATA" varStatus="c">
									<c:if test="${OPTIONDATA.MC_KEYNO eq model.BL_OPTION_DATA }">
									<label><input type="checkbox" name="BD_DATA${model.BL_KEYNO }" value="${OPTIONDATA.SC_KEYNO }" onchange="pf_checkOption(this)">
									${OPTIONDATA.SC_CODENM }</label>
									</c:if>
								</c:forEach>
								</p>
							</div>
						</c:if>
						
						<c:if test="${model.BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_RADIO_CODE') }">
							<div class="row lineheightBox">
								<p class="titleBox">
						        	<label>${model.BL_COLUMN_NAME }</label>
						        </p>
						        <p class="formBox">
								<input type="hidden" name="BD_DATA" id="BD_DATA${model.BL_KEYNO }" value="" class="${BL_VALIDATE} txtDefault txtWlong_1" data-type="radio" data-title="${model.BL_COLUMN_NAME }">
								<c:forEach items="${BoardColumnCodeList }" var="OPTIONDATA" varStatus="c">
									<c:if test="${OPTIONDATA.MC_KEYNO eq model.BL_OPTION_DATA }">
									<label><input type="radio" name="BD_DATA${model.BL_KEYNO }" value="${OPTIONDATA.SC_KEYNO}" onchange="pf_radioOption(this)">
									${OPTIONDATA.SC_CODENM }</label>
									</c:if>
								</c:forEach>
								</p>
							</div>
						</c:if>
						
						<c:if test="${model.BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_SELECT_CODE') }">
							<div class="row">
								<p class="titleBox">
						        	<label>${model.BL_COLUMN_NAME }</label>
						        </p>
						        <p class="formBox">
									<select name="BD_DATA" id="BD_DATA${model.BL_KEYNO }" class="${BL_VALIDATE} txtDefault txtWlong_1" data-title="${model.BL_COLUMN_NAME }">
										<option value="">선택하세요</option>
										<c:forEach items="${BoardColumnCodeList }" var="OPTIONDATA">
											<c:if test="${OPTIONDATA.MC_KEYNO eq model.BL_OPTION_DATA }">
											<option value="${OPTIONDATA.SC_KEYNO}">${OPTIONDATA.SC_CODENM }</option>
											</c:if>
										</c:forEach>
									</select>
								</p>
							</div>
						</c:if>
						
					</c:forEach>
				    <c:if test="${BoardType.BT_UPLOAD_YN == 'Y'}"> 
							<div class="row">
								<p class="titleBox">
									<label>첨부파일</label>
						        </p>
						        <div class="formBox">

								<%@ include file="/WEB-INF/jsp/dyAdmin/operation/file/pra_file_insertView.jsp"%>
								
								<c:if test="${action eq 'update' || action eq 'move'}">
									<input type="hidden" name="fsSize" id="fsSize" value="${fn:length(FileSub) }">
									<input type="hidden" name="BN_FM_KEYNO" id="BN_FM_KEYNO" value="${BoardNotice.BN_FM_KEYNO }">
								</c:if>
								</div>		
							</div>
					</c:if>
				    <c:if test="${BoardType.BT_SECRET_YN == 'Y'}">
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
						<c:if test="${action eq 'insert' }">
							<textarea name="BN_CONTENTS" id="BN_CONTENTS" rows="5" style="width:100%;height:400px;min-width:260px;padding:10px;" onkeydown="useTab(this);" title="내용을 입력해주세요"></textarea>
						</c:if>
						<c:if test="${action eq 'update' || action eq 'move'}">
						    <% pageContext.setAttribute("newLineChar", "\n"); %>						
							<textarea name="BN_CONTENTS" id="BN_CONTENTS" rows="5" style="width:100%;height:400px;min-width:260px;padding:10px;" onkeydown="useTab(this);" title="내용을 입력해주세요">${fn:replace(fn:replace(BoardNotice.BN_CONTENTS, newLineChar, "<br/>"), "&", "&amp;")}</textarea>
						</c:if>
						 </p>
					</div>
					<c:if test="${BoardType.BT_HTMLMAKER_PLUS_YN eq 'Y'}">
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
				    <c:if test="${currentMenu.MN_GONGNULI_YN eq 'Y' && currentMenu.MN_GONGNULI_TYPE eq '0'}">
			            <div>
							<%@ include file="/WEB-INF/jsp/user/_common/prc_gong_nuli_insert.jsp" %>                            
			            </div>
		            </c:if>   				                       
				</div>
							
				<div class="btnBox textC">
					<button type="button" class="btn btnBig_02 btn-default" onclick="pf_boardDataAction()">
						<c:choose>
							<c:when test="${action eq 'insert' }">글쓰기</c:when>	
							<c:when test="${action eq 'update' }">수정</c:when>	
							<c:when test="${action eq 'move' }">이동</c:when>	
						</c:choose>					
					</button>
					<button type="button" class="btn btnBig_02 btn-default" onclick="pf_back()">취소</button>
				</div>
				</form:form>
				<c:if test="${BoardHtml.BIH_DIV_LOCATION eq 'B' }">
				<div id="html_contents">${BoardHtml.BIH_CONTENTS }</div>
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

