<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

&lt;script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.10.3/jquery-ui.min.js"&gt;&lt;/script&gt;
&lt;script&gt;
	if (!window.jQuery.ui) {
		document.write('&lt;script src="/resources/smartadmin/js/libs/jquery-ui-1.10.3.min.js"&gt;&lt;\/script&gt;');
	}
&lt;/script&gt;

&lt;%@ include file="/WEB-INF/jsp/user/_common/_Script/board/script_insertView_nomal.jsp"%&gt;
&lt;%@ include file="/WEB-INF/jsp/user/_common/_Script/board/script_insertView.jsp"%&gt;

&lt;article id="container" class="container_sub clearfix"&gt;
	&lt;div class="inner"&gt;
		&lt;div class="conSub01_bottomBox"&gt;
			&lt;div class="innerContainer clearfix"&gt;
				&lt;c:if test="${BoardHtml.BIH_DIV_LOCATION eq 'T' }"&gt;
				&lt;div id="html_contents"&gt;${BoardHtml.BIH_CONTENTS }&lt;/div&gt;
				&lt;/c:if&gt;
				&lt;form:form id="Form" name="Form" method="post" enctype="multipart/form-data"&gt;
						&lt;input type="hidden" name="BD_BT_KEYNO" value="${BoardType.BT_KEYNO }"&gt;
						&lt;input type="hidden" name="BT_EMAIL_YN" value="${BoardType.BT_EMAIL_YN }"&gt;
						&lt;input type="hidden" name="BT_EMAIL_ADDRESS" value="${BoardType.BT_EMAIL_ADDRESS }"&gt;
						&lt;input type="hidden" name="BT_THUMBNAIL_INSERT" value="${BoardType.BT_THUMBNAIL_INSERT }"&gt;
						&lt;input type="hidden" name="BN_MN_KEYNO" value="${Menu.MN_KEYNO}"&gt;
						&lt;input type="hidden" name="MN_KEYNO" value="${Menu.MN_KEYNO }"&gt;
						&lt;input type="hidden" name="category" id="category" value="${category}"&gt;
						&lt;input type="hidden" name="BT_ZIP_YN" id="BT_ZIP_YN" value="${BoardType.BT_ZIP_YN}"&gt;
						&lt;input type="hidden" name="BT_THUMBNAIL_YN" value="${BoardType.BT_THUMBNAIL_YN  }"&gt;
						&lt;input type="hidden" name="BN_KEYNO" id="BN_KEYNO" value="${BoardNotice.BN_KEYNO }"&gt;
						&lt;input type="hidden" name="fileUpdateCheck" id="fileUpdateCheck" value="N"&gt;
						&lt;input type="hidden" name="action" id="action" value="${action}"&gt;
						
						&lt;c:if test="${currentMenu.MN_GONGNULI_YN eq 'Y'}"&gt;
						&lt;input type="hidden" name="BN_GONGNULI_TYPE" id="BN_GONGNULI_TYPE" value="${not empty BoardNotice.BN_GONGNULI_TYPE ? BoardNotice.BN_GONGNULI_TYPE : currentMenu.MN_GONGNULI_TYPE }"&gt;
						&lt;/c:if&gt;
						&lt;c:if test="${not empty BoardNotice}"&gt;
							&lt;input type="hidden" name="BN_MAINKEY" id="BN_MAINKEY" value="${BoardNotice.BN_MAINKEY }"&gt;
							&lt;input type="hidden" name="BN_PARENTKEY" id="BN_PARENTKEY" value="${BoardNotice.BN_KEYNO}"&gt;
							&lt;input type="hidden" name="BN_SEQ" id="BN_SEQ" value="${BoardNotice.BN_SEQ }"&gt;
							&lt;input type="hidden" name="BN_DEPTH" id="BN_DEPTH" value="${BoardNotice.BN_DEPTH}"&gt;
						&lt;/c:if&gt;
						&lt;c:if test="${action eq 'insert' }"&gt;
							&lt;input type="hidden" name="BN_REGNM" id="BN_REGNM" value="${userInfo.UI_KEYNO }"&gt;
						&lt;/c:if&gt;
						&lt;c:if test="${action eq 'update' || action eq 'move'  }"&gt;
							&lt;input type="hidden" name="BN_MODNM" value="${userInfo.UI_KEYNO }"&gt;
							&lt;input type="hidden" name="BN_THUMBNAIL" id="BN_THUMBNAIL" value="${BoardNotice.BN_THUMBNAIL }"&gt;
						&lt;/c:if&gt;
						&lt;c:if test="${action eq 'move' }"&gt;
							&lt;input type="hidden" name="BN_MOVE_MEMO" value="${BoardNotice.BN_MOVE_MEMO }"&gt;
							&lt;input type="hidden" name="BT_KEYNO" value="${PreBoardType.BT_KEYNO }"&gt;
						&lt;/c:if&gt;
						
					&lt;c:if test="${action eq 'move' }"&gt;
					&lt;div class="boardUploadWrap"&gt;
						&lt;h3&gt;이전 게시물 컬럼 데이터&lt;/h3&gt;
						&lt;c:if test="${action eq 'move' && BoardType.BT_KEYNO ne PreBoardType.BT_KEYNO }"&gt;
							&lt;c:forEach items="${PreBoardColumnData }" var="model"&gt;
								&lt;c:if test="${model.BD_BL_TYPE ne sp:getData('BOARD_COLUMN_TYPE_TITLE') and !empty model.BD_DATA}"&gt;
								&lt;div class="row"&gt;
									&lt;p class="titleBox"&gt;
										&lt;label&gt;${model.COLUMN_NAME }&lt;/label&gt;
									&lt;/p&gt;
									&lt;p class="formBox"&gt;
										&lt;input class="txtDefault txtWmiddle_1 column_data" type="text" value="${model.BD_DATA }" readonly="readonly"&gt;
										&lt;select id="BD_DATA${model.BD_KEYNO }" class="txtDefault txtWmiddle_1"&gt;
											&lt;option value=""&gt;선택하세요&lt;/option&gt;
											&lt;c:forEach items="${BoardColumnList }" var="model2"&gt;
												&lt;c:if test="${model.BD_BL_TYPE eq model2.BL_TYPE }"&gt;
													&lt;option value="${model2.BL_KEYNO }"&gt;${model2.BL_COLUMN_NAME }&lt;/option&gt;
												&lt;/c:if&gt;
											&lt;/c:forEach&gt;
										&lt;/select&gt;
										
										
										&lt;input class="btn btnSmall_01" type="button" value="적용하기" onclick="pf_adjust('BD_DATA${model.BD_KEYNO }', '${model.BD_BL_TYPE}', '${model.BD_DATA_ORI}');"&gt;
										&lt;a class="btn btn-default btn-xs" href="javascript:void(0);" onclick="pf_ClipBoard(this);"&gt;
											&lt;!-- &lt;i class="fa fa-copy"&gt;&lt;/i&gt; --&gt;복사하기
										&lt;/a&gt;
									&lt;/p&gt;
								&lt;/div&gt;
								&lt;/c:if&gt;
							&lt;/c:forEach&gt;
						&lt;/c:if&gt;
					&lt;/div&gt;
					&lt;/c:if&gt;
						
				&lt;div class="boardUploadWrap"&gt;
					&lt;c:if test="${action eq 'insert' && empty userInfo}"&gt;
					&lt;div class="row"&gt;
				    	&lt;p class="titleBox"&gt;
				        	&lt;label for="BN_NAME"&gt;작성자&lt;/label&gt;
				        &lt;/p&gt;
				        &lt;p class="formBox"&gt;
				        	&lt;input type="text" class="txtDefault txtWlong_1" name="BN_NAME" id="BN_NAME" maxlength="10"&gt;
				        &lt;/p&gt;
				    &lt;/div&gt;
					&lt;div class="row"&gt;
				    	&lt;p class="titleBox"&gt;
				        	&lt;label for="BN_PWD"&gt;비밀번호&lt;/label&gt;
				        &lt;/p&gt;
				        &lt;p class="formBox"&gt;
				        	&lt;input type="password" class="txtDefault txtWlong_1" name="BN_PWD" id="BN_PWD" maxlength="10"&gt;
				        &lt;/p&gt;
				    &lt;/div&gt;
				    &lt;/c:if&gt;
				    
				    &lt;c:if test="${userInfo.isAdmin eq 'Y'}"&gt;
					   	&lt;div class="row lineheightBox"&gt;
					    	&lt;p class="titleBox"&gt;
					        	&lt;label&gt;공지사용&lt;/label&gt;
					        &lt;/p&gt;
					        &lt;p class="formBox"&gt;
					        	&lt;label&gt;&lt;input type="radio" class="radioDefault" name="BN_IMPORTANT" value="Y"&gt;공지(상단에 항상 노출)&lt;/label&gt;
								&lt;label&gt;&lt;input type="radio" class="radioDefault" name="BN_IMPORTANT" value="N" checked&gt;일반글&lt;/label&gt;
					        &lt;/p&gt;
					    &lt;/div&gt;
					    &lt;div class="row" style="border-bottom:1px solid #7b8292;margin-bottom:20px;padding-bottom:20px;"&gt;
					    	&lt;p class="titleBox"&gt;
					        	&lt;label for="BN_IMPORTANT_DATE"&gt;공지 종료일&lt;/label&gt;
					        &lt;/p&gt;
					        &lt;p class="formBox"&gt;
					        	&lt;input type="text" name="BN_IMPORTANT_DATE"  placeholder="입력안할시 날짜제한 없이 계속 공지글로 등록됩니다." class="txtDefault txtWlong_1" id="BN_IMPORTANT_DATE" maxlength="10" readonly value="${BoardNotice.BN_IMPORTANT_DATE }"&gt; &lt;img src="/resources/img/icon/icon_calendar_01.png" alt="작성일선택"&gt;
					        &lt;/p&gt;
					    &lt;/div&gt;
						&lt;script&gt;
						$(function(){
							$('#BN_IMPORTANT_DATE').datepicker(datepickerOption);
						})
						&lt;/script&gt;
					&lt;/c:if&gt;
					
					&lt;c:if test="${BoardType.BT_CATEGORY_YN eq 'Y' }"&gt;
								&lt;div class="row"&gt;
									&lt;p class="titleBox"&gt;
						        	&lt;label for="BN_CATEGORY_NAME"&gt;카테고리 구분&lt;/label&gt;
						       		 &lt;/p&gt;
									&lt;select class="form-control input-sm" id="BN_CATEGORY_NAME"
										name="BN_CATEGORY_NAME"&gt;
										&lt;option&gt;전체&lt;/option&gt;
										&lt;c:forEach var="categoryname"
											items="${ fn:split(BoardType.BT_CATEGORY_INPUT,',')}"&gt;

											&lt;option value="${categoryname }"
												${categoryname eq BoardNotice.BN_CATEGORY_NAME ? 'selected' : ''}&gt;${categoryname }&lt;/option&gt;

										&lt;/c:forEach&gt;

									&lt;/select&gt;
								&lt;/div&gt;
							&lt;/c:if&gt;
					
				    
				    &lt;c:forEach items="${BoardColumnList }" var="model" varStatus="status"&gt;
						&lt;input type="hidden" name="BD_BL_TYPE" value="${model.BL_TYPE }"&gt;
						&lt;input type="hidden" name="BD_BL_KEYNO" value="${model.BL_KEYNO }"&gt;
						&lt;input type="hidden" id="BD_KEYNO${model.BL_KEYNO }" name="BD_KEYNO" value=""&gt;
						&lt;c:set var="BL_VALIDATE" value=""/&gt;
						&lt;c:if test="${model.BL_VALIDATE eq 'Y' }"&gt;
							&lt;c:set var="BL_VALIDATE" value="BD_TYPE_VALIDATE"/&gt;
						&lt;/c:if&gt;
						&lt;c:if test="${model.BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_TITLE') }"&gt;
							&lt;div class="row"&gt;
								&lt;p class="titleBox"&gt;
						        	&lt;label for="BD_DATA${model.BL_KEYNO }"&gt;${model.BL_COLUMN_NAME }&lt;/label&gt;
						        &lt;/p&gt;
						        &lt;p class="formBox"&gt;
								&lt;c:if test="${not empty BoardNotice }"&gt;
									&lt;c:if test="${action eq 'insert' }"&gt;
									&lt;input type="text" class="${BL_VALIDATE} txtDefault txtWlong_1" data-title="${model.BL_COLUMN_NAME }" id="BD_DATA${model.BL_KEYNO }" name="BD_DATA" value="RE:${BoardNotice.BN_TITLE}" maxlength="70"&gt;
									&lt;/c:if&gt;
									&lt;c:if test="${action eq 'update' || action eq 'move' }"&gt;
									&lt;input type="text" class="${BL_VALIDATE} txtDefault txtWlong_1" data-title="${model.BL_COLUMN_NAME }" id="BD_DATA${model.BL_KEYNO }" name="BD_DATA" value="${BoardNotice.BN_TITLE}" maxlength="70"&gt;
									&lt;/c:if&gt;
								&lt;/c:if&gt;
								&lt;c:if test="${empty BoardNotice }"&gt;
									&lt;input type="text" class="${BL_VALIDATE} txtDefault txtWlong_1" data-title="${model.BL_COLUMN_NAME }" id="BD_DATA${model.BL_KEYNO }" name="BD_DATA" value="" maxlength="70"&gt;
								&lt;/c:if&gt;
								&lt;/p&gt;
							&lt;/div&gt;
							&lt;c:set var="checkTitle" value="true"/&gt;
						&lt;/c:if&gt;
						
						&lt;c:if test="${checkTitle && BoardType.BT_THUMBNAIL_YN eq 'Y' }"&gt;
							&lt;c:set var="checkTitle" value="false"/&gt;
							&lt;div class="row"&gt;
								&lt;p class="titleBox"&gt;
						        	&lt;label for="thumbnail"&gt;썸네일&lt;/label&gt;
						        &lt;/p&gt;
						        &lt;div class="formBox"&gt;
									&lt;img style="width:${BoardType.BT_THUMBNAIL_WIDTH }px;height:${BoardType.BT_THUMBNAIL_HEIGHT }px;margin:5px 0;" onerror="this.style.display='none';" src="${BoardNotice.THUMBNAIL_PUBLIC_PATH }" id="thumbnail_img" alt="썸네일"/&gt;
									&lt;div class="clear"&gt;&lt;/div&gt;
									&lt;input type="file" id="thumbnail" name="thumbnail" class="txtDefault txtWlong_1" onchange="cf_imgCheckAndPreview('thumbnail')"&gt; &lt;img src="/resources/img/icon/icon_attachment_01.png" alt="링크"&gt;
									&lt;input type="hidden" name="thumbnail_text" id="thumbnail_text"&gt;
									&lt;button type="button" onclick="thumnail_delete('${BoardNotice.BN_KEYNO }')"&gt;썸네일 삭제&lt;/button&gt;
									&lt;p class="thumbnailNote"&gt;사이즈 :: ${BoardType.BT_THUMBNAIL_WIDTH } X ${BoardType.BT_THUMBNAIL_HEIGHT } 사이즈가 다를시 자동 리사이즈 됩니다.&lt;/p&gt;
									&lt;input type="hidden" name="BT_THUMBNAIL_WIDTH" value="${BoardType.BT_THUMBNAIL_WIDTH }"&gt;
									&lt;input type="hidden" name="BT_THUMBNAIL_HEIGHT" value="${BoardType.BT_THUMBNAIL_HEIGHT  }"&gt;
								&lt;/div&gt;
							&lt;/div&gt;
						&lt;/c:if&gt;

							

							&lt;c:if test="${model.BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_TEXT') }"&gt;
							&lt;div class="row"&gt;
								&lt;p class="titleBox"&gt;
						        	&lt;label for="BD_DATA${model.BL_KEYNO }"&gt;${model.BL_COLUMN_NAME }&lt;/label&gt;
						        &lt;/p&gt;
						        &lt;p class="formBox"&gt;
									&lt;input type="text" class="${BL_VALIDATE} txtDefault txtWlong_1" data-title="${model.BL_COLUMN_NAME }" id="BD_DATA${model.BL_KEYNO }" name="BD_DATA" value="" maxlength="70"&gt;
								&lt;/p&gt;
							&lt;/div&gt;
						&lt;/c:if&gt;
						
						&lt;c:if test="${model.BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_LINK') }"&gt;
							&lt;div class="row"&gt;
								&lt;p class="titleBox"&gt;
						        	&lt;label for="BD_DATA${model.BL_KEYNO }"&gt;${model.BL_COLUMN_NAME }&lt;/label&gt;
						        &lt;/p&gt;
						        &lt;p class="formBox"&gt;
									&lt;input type="text" class="${BL_VALIDATE} txtDefault txtWlong_1" data-title="${model.BL_COLUMN_NAME }" id="BD_DATA${model.BL_KEYNO }" name="BD_DATA" value="" maxlength="70"&gt;
									&lt;button type="button" class="btn btnSmall_01" onclick="pf_link('BD_DATA${model.BL_KEYNO }')"&gt;링크 확인&lt;/button&gt;
								&lt;/p&gt;
							&lt;/div&gt;
						&lt;/c:if&gt;
						
						&lt;c:if test="${model.BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_CALENDAR')}"&gt;
							&lt;div class="row"&gt;
								&lt;p class="titleBox"&gt;
						        	&lt;label for="BD_DATA${model.BL_KEYNO }"&gt;${model.BL_COLUMN_NAME }&lt;/label&gt;
						        &lt;/p&gt;
						        &lt;p class="formBox"&gt;
									&lt;input type="text" class="${BL_VALIDATE} txtDefault txtWlong_1 BD_DATA_CALENDAR" data-title="${model.BL_COLUMN_NAME }" id="BD_DATA${model.BL_KEYNO }" name="BD_DATA" value="" maxlength="10" readonly&gt;  &lt;img src="/resources/img/icon/icon_calendar_01.png" alt="작성일선택"&gt;
								&lt;/p&gt;
							&lt;/div&gt;
						&lt;/c:if&gt;
						
						&lt;c:if test="${model.BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_CALENDAR_START') }"&gt;
							&lt;div class="row"&gt;
								&lt;p class="titleBox"&gt;
						        	&lt;label for="BD_DATA${model.BL_KEYNO }"&gt;${model.BL_COLUMN_NAME }&lt;/label&gt;
						        &lt;/p&gt;
						        &lt;p class="formBox"&gt;
									&lt;input type="text" class="${BL_VALIDATE} txtDefault txtWlong_1 BD_DATA_CALENDAR_START" data-title="${model.BL_COLUMN_NAME }" id="BD_DATA${model.BL_KEYNO }" name="BD_DATA" value="" maxlength="10" readonly&gt;  &lt;img src="/resources/img/icon/icon_calendar_01.png" alt="작성일선택"&gt;
								&lt;/p&gt;
							&lt;/div&gt;
						&lt;/c:if&gt;
						
						&lt;c:if test="${model.BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_CALENDAR_END') }"&gt;
							&lt;div class="row"&gt;
								&lt;p class="titleBox"&gt;
						        	&lt;label for="BD_DATA${model.BL_KEYNO }"&gt;${model.BL_COLUMN_NAME }&lt;/label&gt;
						        &lt;/p&gt;
						        &lt;p class="formBox"&gt;
									&lt;input type="text" class="${BL_VALIDATE} txtDefault txtWlong_1 BD_DATA_CALENDAR_END" data-title="${model.BL_COLUMN_NAME }" id="BD_DATA${model.BL_KEYNO }" name="BD_DATA" value="" maxlength="10" readonly&gt;  &lt;img src="/resources/img/icon/icon_calendar_01.png" alt="작성일선택"&gt;
								&lt;/p&gt;
							&lt;/div&gt;
						&lt;/c:if&gt;
						
						
						&lt;c:if test="${model.BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_PWD') }"&gt;
							&lt;div class="row"&gt;
								&lt;p class="titleBox"&gt;
						        	&lt;label for="BD_DATA${model.BL_KEYNO }"&gt;${model.BL_COLUMN_NAME }&lt;/label&gt;
						        &lt;/p&gt;
						        &lt;p class="formBox"&gt;
									&lt;input type="password" class="${BL_VALIDATE} txtDefault txtWlong_1" data-title="${model.BL_COLUMN_NAME }" id="BD_DATA${model.BL_KEYNO }" name="BD_DATA" value="" maxlength="20"&gt;
								&lt;/p&gt;
							&lt;/div&gt;
						&lt;/c:if&gt;
						
						&lt;c:if test="${model.BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_EMAIL') }"&gt;
							&lt;div class="row"&gt;
								&lt;p class="titleBox"&gt;
						        	&lt;label for="BD_DATA${model.BL_KEYNO }"&gt;${model.BL_COLUMN_NAME }&lt;/label&gt;
						        &lt;/p&gt;
						        &lt;p class="formBox"&gt;
									&lt;input type="text" class="${BL_VALIDATE} txtDefault txtWlong_1 BD_DATA_EMAIL" data-title="${model.BL_COLUMN_NAME }" id="BD_DATA${model.BL_KEYNO }" name="BD_DATA" value="" maxlength="30"&gt;
								&lt;/p&gt;
							&lt;/div&gt;
						&lt;/c:if&gt;
						
						&lt;c:if test="${model.BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_NUMBER') }"&gt;
							&lt;div class="row"&gt;
								&lt;p class="titleBox"&gt;
						        	&lt;label for="BD_DATA${model.BL_KEYNO }"&gt;${model.BL_COLUMN_NAME }&lt;/label&gt;
						        &lt;/p&gt;
						        &lt;p class="formBox"&gt;
									&lt;input type="number" class="${BL_VALIDATE} txtDefault txtWlong_1 BD_DATA_NUMBER" data-title="${model.BL_COLUMN_NAME }" id="BD_DATA${model.BL_KEYNO }" name="BD_DATA" value="" oninput="cf_maxLengthCheck(this)" max="99999999999" maxlength="11"&gt;
								&lt;/p&gt;
							&lt;/div&gt;
						&lt;/c:if&gt;
						
						&lt;c:if test="${model.BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_CHECK') }"&gt;
							&lt;div class="row lineheightBox"&gt;
								&lt;p class="titleBox"&gt;
						        	&lt;label&gt;${model.BL_COLUMN_NAME }&lt;/label&gt;
						        &lt;/p&gt;
						        &lt;p class="formBox"&gt;
									&lt;input type="hidden" name="BD_DATA" id="BD_DATA${model.BL_KEYNO }" value=""  class="${BL_VALIDATE} txtDefault txtWlong_1" data-type="check" data-title="${model.BL_COLUMN_NAME }"&gt;
									&lt;c:set var="checkData" value="${fn:split(model.BL_OPTION_DATA, '|') }"&gt;&lt;/c:set&gt;
									&lt;c:forEach items="${checkData }" var="OPTIONDATA" varStatus="c"&gt;
										&lt;label&gt;&lt;input type="checkbox" name="BD_DATA${model.BL_KEYNO }" value="${OPTIONDATA }" onchange="pf_checkOption(this)"&gt;
										${OPTIONDATA }&lt;/label&gt;
									&lt;/c:forEach&gt;
								&lt;/p&gt;
							&lt;/div&gt;
						&lt;/c:if&gt;
						
						&lt;c:if test="${model.BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_RADIO') }"&gt;
							&lt;div class="row lineheightBox"&gt;
								&lt;p class="titleBox"&gt;
						        	&lt;label&gt;${model.BL_COLUMN_NAME }&lt;/label&gt;
						        &lt;/p&gt;
						        &lt;p class="formBox"&gt;
								&lt;input type="hidden" name="BD_DATA" id="BD_DATA${model.BL_KEYNO }" value="" class="${BL_VALIDATE} txtDefault txtWlong_1" data-type="radio" data-title="${model.BL_COLUMN_NAME }"&gt;
								&lt;c:set var="checkData" value="${fn:split(model.BL_OPTION_DATA, '|') }"&gt;&lt;/c:set&gt;
								&lt;c:forEach items="${checkData }" var="OPTIONDATA" varStatus="c"&gt;
									&lt;label&gt;&lt;input type="radio" name="BD_DATA${model.BL_KEYNO }" value="${OPTIONDATA }" onchange="pf_radioOption(this)"&gt;
									${OPTIONDATA }&lt;/label&gt;
								&lt;/c:forEach&gt;
								&lt;/p&gt;
							&lt;/div&gt;
						&lt;/c:if&gt;
						
						&lt;c:if test="${model.BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_SELECT') }"&gt;
							&lt;div class="row"&gt;
								&lt;p class="titleBox"&gt;
						        	&lt;label&gt;${model.BL_COLUMN_NAME }&lt;/label&gt;
						        &lt;/p&gt;
						        &lt;p class="formBox"&gt;
									&lt;select name="BD_DATA" id="BD_DATA${model.BL_KEYNO }" class="${BL_VALIDATE} txtDefault txtWlong_1" data-title="${model.BL_COLUMN_NAME }"&gt;
										&lt;option value=""&gt;선택하세요&lt;/option&gt;
										&lt;c:set var="selectData" value="${fn:split(model.BL_OPTION_DATA, '|') }"&gt;&lt;/c:set&gt;
										&lt;c:forEach items="${selectData }" var="OPTIONDATA"&gt;
											&lt;option value="${OPTIONDATA }"&gt;${OPTIONDATA }&lt;/option&gt;
										&lt;/c:forEach&gt;
									&lt;/select&gt;
								&lt;/p&gt;
							&lt;/div&gt;
						&lt;/c:if&gt;
						
						&lt;c:if test="${model.BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_CHECK_CODE') }"&gt;
							&lt;div class="row lineheightBox"&gt;
								&lt;p class="titleBox"&gt;
						        	&lt;label&gt;${model.BL_COLUMN_NAME }&lt;/label&gt;
						        &lt;/p&gt;
						        &lt;p class="formBox"&gt;
								&lt;input type="hidden" name="BD_DATA" id="BD_DATA${model.BL_KEYNO }" value=""  class="${BL_VALIDATE} txtDefault txtWlong_1" data-type="check" data-title="${model.BL_COLUMN_NAME }"&gt;
								&lt;c:forEach items="${BoardColumnCodeList }" var="OPTIONDATA" varStatus="c"&gt;
									&lt;c:if test="${OPTIONDATA.MC_KEYNO eq model.BL_OPTION_DATA }"&gt;
									&lt;label&gt;&lt;input type="checkbox" name="BD_DATA${model.BL_KEYNO }" value="${OPTIONDATA.SC_KEYNO }" onchange="pf_checkOption(this)"&gt;
									${OPTIONDATA.SC_CODENM }&lt;/label&gt;
									&lt;/c:if&gt;
								&lt;/c:forEach&gt;
								&lt;/p&gt;
							&lt;/div&gt;
						&lt;/c:if&gt;
						
						&lt;c:if test="${model.BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_RADIO_CODE') }"&gt;
							&lt;div class="row lineheightBox"&gt;
								&lt;p class="titleBox"&gt;
						        	&lt;label&gt;${model.BL_COLUMN_NAME }&lt;/label&gt;
						        &lt;/p&gt;
						        &lt;p class="formBox"&gt;
								&lt;input type="hidden" name="BD_DATA" id="BD_DATA${model.BL_KEYNO }" value="" class="${BL_VALIDATE} txtDefault txtWlong_1" data-type="radio" data-title="${model.BL_COLUMN_NAME }"&gt;
								&lt;c:forEach items="${BoardColumnCodeList }" var="OPTIONDATA" varStatus="c"&gt;
									&lt;c:if test="${OPTIONDATA.MC_KEYNO eq model.BL_OPTION_DATA }"&gt;
									&lt;label&gt;&lt;input type="radio" name="BD_DATA${model.BL_KEYNO }" value="${OPTIONDATA.SC_KEYNO}" onchange="pf_radioOption(this)"&gt;
									${OPTIONDATA.SC_CODENM }&lt;/label&gt;
									&lt;/c:if&gt;
								&lt;/c:forEach&gt;
								&lt;/p&gt;
							&lt;/div&gt;
						&lt;/c:if&gt;
						
						&lt;c:if test="${model.BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_SELECT_CODE') }"&gt;
							&lt;div class="row"&gt;
								&lt;p class="titleBox"&gt;
						        	&lt;label&gt;${model.BL_COLUMN_NAME }&lt;/label&gt;
						        &lt;/p&gt;
						        &lt;p class="formBox"&gt;
									&lt;select name="BD_DATA" id="BD_DATA${model.BL_KEYNO }" class="${BL_VALIDATE} txtDefault txtWlong_1" data-title="${model.BL_COLUMN_NAME }"&gt;
										&lt;option value=""&gt;선택하세요&lt;/option&gt;
										&lt;c:forEach items="${BoardColumnCodeList }" var="OPTIONDATA"&gt;
											&lt;c:if test="${OPTIONDATA.MC_KEYNO eq model.BL_OPTION_DATA }"&gt;
											&lt;option value="${OPTIONDATA.SC_KEYNO}"&gt;${OPTIONDATA.SC_CODENM }&lt;/option&gt;
											&lt;/c:if&gt;
										&lt;/c:forEach&gt;
									&lt;/select&gt;
								&lt;/p&gt;
							&lt;/div&gt;
						&lt;/c:if&gt;
						
					&lt;/c:forEach&gt;
				    &lt;c:if test="${BoardType.BT_UPLOAD_YN == 'Y'}"&gt; 
							&lt;div class="row"&gt;
								&lt;p class="titleBox"&gt;
									&lt;label&gt;첨부파일&lt;/label&gt;
						        &lt;/p&gt;
						        &lt;div class="formBox"&gt;

								&lt;%@ include file="/WEB-INF/jsp/dyAdmin/operation/file/pra_file_insertView.jsp"%&gt;
								
								&lt;c:if test="${action eq 'update' || action eq 'move'}"&gt;
									&lt;input type="hidden" name="fsSize" id="fsSize" value="${fn:length(FileSub) }"&gt;
									&lt;input type="hidden" name="BN_FM_KEYNO" id="BN_FM_KEYNO" value="${BoardNotice.BN_FM_KEYNO }"&gt;
								&lt;/c:if&gt;
								&lt;/div&gt;		
							&lt;/div&gt;
					&lt;/c:if&gt;
				    &lt;c:if test="${BoardType.BT_SECRET_YN == 'Y'}"&gt;
						&lt;div class="row lineheightBox"&gt;
					    	&lt;p class="titleBox"&gt;
					        	&lt;label&gt;비밀글 여부&lt;/label&gt;
					        &lt;/p&gt;
					        &lt;p class="formBox"&gt;
					        	&lt;label&gt;&lt;input type="radio" class="radioDefault" name="BN_SECRET_YN" value="Y"&gt;비밀글&lt;/label&gt;
								&lt;label&gt;&lt;input type="radio" class="radioDefault" name="BN_SECRET_YN" value="N" checked&gt;일반글&lt;/label&gt;
					        &lt;/p&gt;
					    &lt;/div&gt;
					&lt;/c:if&gt;
					
 				    &lt;div class="row lineheightBox"&gt;
				    	&lt;p class="titleBox"&gt;
				        	&lt;label&gt;내용&lt;/label&gt;
				        &lt;/p&gt;
				        &lt;p class="formBox"&gt;
						&lt;c:if test="${action eq 'insert' }"&gt;
							&lt;textarea name="BN_CONTENTS" id="BN_CONTENTS" rows="5" style="width:100%;height:400px;min-width:260px;padding:10px;" onkeydown="useTab(this);" title="내용을 입력해주세요"&gt;&lt;/textarea&gt;
						&lt;/c:if&gt;
						&lt;c:if test="${action eq 'update' || action eq 'move'}"&gt;
							&lt;textarea name="BN_CONTENTS" id="BN_CONTENTS" rows="5" style="width:100%;height:400px;min-width:260px;padding:10px;" onkeydown="useTab(this);" title="내용을 입력해주세요"&gt;${BoardNotice.BN_CONTENTS }&lt;/textarea&gt;
						&lt;/c:if&gt;
						 &lt;/p&gt;
					&lt;/div&gt;
					&lt;c:if test="${BoardType.BT_HTMLMAKER_PLUS_YN eq 'Y'}"&gt;
					&lt;div class="row" id="editorbox" &gt;
						&lt;p class="titleBox"&gt;&lt;label&gt;에디터이미지&lt;/label&gt;&lt;/p&gt;
				        &lt;div class="formBox"&gt;
							&lt;div class="clear"&gt;&lt;/div&gt;
							&lt;input type="file" id="smartimg" name="smartimg" class="txtDefault txtWlong_1" onchange="selectFiles(this,'smartimg');" multiple="multiple"&gt;
							&lt;input type="button" id="imgsettingbutton" onclick="imgSetting();" value="적용"&gt;
							&lt;input type="hidden" id="selectedImg"&gt;
							&lt;div id="smartimg_img"&gt;
							&lt;/div&gt;
						&lt;/div&gt;
					&lt;/div&gt;
					&lt;/c:if&gt;
				    &lt;c:if test="${currentMenu.MN_GONGNULI_YN eq 'Y' && currentMenu.MN_GONGNULI_TYPE eq '0'}"&gt;
			            &lt;div&gt;
							&lt;%@ include file="/WEB-INF/jsp/user/_common/prc_gong_nuli_insert.jsp" %&gt;                            
			            &lt;/div&gt;
		            &lt;/c:if&gt;   
				                       
				&lt;/div&gt;
				&lt;div class="btnBox textC"&gt;
					&lt;button type="button" class="btn btnBig_02 btn-default" onclick="pf_boardDataAction()"&gt;
						&lt;c:choose&gt;
							&lt;c:when test="${action eq 'insert' }"&gt;글쓰기&lt;/c:when&gt;	
							&lt;c:when test="${action eq 'update' }"&gt;수정&lt;/c:when&gt;	
							&lt;c:when test="${action eq 'move' }"&gt;이동&lt;/c:when&gt;	
						&lt;/c:choose&gt;					
					&lt;/button&gt;
					&lt;button type="button" class="btn btnBig_02 btn-default" onclick="pf_back()"&gt;취소&lt;/button&gt;
				&lt;/div&gt;
				&lt;/form:form&gt;
				&lt;c:if test="${BoardHtml.BIH_DIV_LOCATION eq 'B' }"&gt;
				&lt;div id="html_contents"&gt;${BoardHtml.BIH_CONTENTS }&lt;/div&gt;
				&lt;/c:if&gt;
			&lt;/div&gt;
		&lt;/div&gt;
	&lt;/div&gt;
&lt;/article&gt;
&lt;!-- 개인정보 보안 dialog --&gt;
&lt;div id="page_comment" title="페이지 평가 결과"&gt;
	&lt;div class="widget-body "&gt;
		&lt;fieldset&gt;
			&lt;div class="form-horizontal"&gt;
				&lt;fieldset&gt;
					&lt;div class="form-group"&gt;
						&lt;label class="col-md-2 control-label"&gt;&lt;h6&gt; 경고 :: &lt;/h6&gt;&lt;/label&gt;
						
						&lt;div class="col-md-10 tps_comment" style="margin-top: 13px"&gt;
							 게시판 작성 내용중 &lt;strong&gt;개인정보&lt;/strong&gt;가 포함되어 있는 것으로 판단되어 글 등록이 보류되었습니다.&lt;br&gt;
						개인정보 보호를 위하여 &lt;strong&gt;주민번호, 핸드폰 번호&lt;/strong&gt; 등 입력은 &lt;strong&gt;금지&lt;/strong&gt;하여 주시기 바랍니다
						&lt;/div&gt;
					&lt;/div&gt;
					
					&lt;div class="form-group"&gt;
						&lt;label class="col-md-2 control-label"&gt;&lt;h6&gt; 발견된 정보  :: &lt;/h6&gt;&lt;/label&gt;
						&lt;div class="col-md-10 Menu_name" style="margin-top: 20px"&gt;
						
						&lt;/div&gt;
					&lt;/div&gt;
					
					
				&lt;/fieldset&gt;
			&lt;/div&gt;
		&lt;/fieldset&gt;
	&lt;/div&gt;
&lt;/div&gt;

&lt;c:if test="${BoardType.BT_HTMLMAKER_PLUS_YN eq 'Y'}"&gt;
	&lt;%@ include file="/WEB-INF/jsp/user/_common/_Script/board/include/prc_img_setting.jsp" %&gt;      
&lt;/c:if&gt;