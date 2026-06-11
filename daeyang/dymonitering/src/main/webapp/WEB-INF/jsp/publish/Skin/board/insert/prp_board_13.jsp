<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<div id="container" class="heightAuto">
	<div class="auto_wrapper">
		<div class="inner">
			
			<div class="board_title">
               <h2>글쓰기</h2>
            </div>
			
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
			
			<div class="board_upload_wrap">
                <table class="tbl_upload">
                    <caption>글쓰기</caption>
                    <colgroup>
                        <col style="width: 15%;">
                        <col style="width: 85%;">
                    </colgroup>
                    <tbody>
                    	<c:if test="${BoardType.BT_CATEGORY_YN eq 'Y' }">
                        <tr>
                            <th><label><b>*</b> 카테고리</label></th>
                            <td>
                            	<c:forEach var="categoryname" items="${ fn:split(BoardType.BT_CATEGORY_INPUT,',')}" varStatus="status">
									<span class="ca_in">
                                    	<input type="radio" name="BN_CATEGORY_NAME" id="ch0${status.count }"  
                                    	value="${categoryname }" ${(action eq 'update' && categoryname eq BoardNotice.BN_CATEGORY_NAME) || ( empty BoardNotice.BN_CATEGORY_NAME && status.count == 1)  ?'checked':'' } >
                                    	<label for="ch0${status.count }">${categoryname }</label>
                                	</span>
								</c:forEach>
                            </td>
                        </tr>
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
								<tr>
									<th><label for="BD_DATA${model.BL_KEYNO}"><b>*</b> ${model.BL_COLUMN_NAME }</label></th>								
									<td>
									<c:if test="${not empty BoardNotice }">
										<c:if test="${action eq 'insert' }">
											<input type="text" class="${BL_VALIDATE} txt_nor md w100" data-title="${model.BL_COLUMN_NAME }" id="BD_DATA${model.BL_KEYNO }" name="BD_DATA" value="RE:${BoardNotice.BN_TITLE}" maxlength="70">
										</c:if>
										<c:if test="${action eq 'update' || action eq 'move' }">
											<input type="text" class="${BL_VALIDATE} txt_nor md w100" data-title="${model.BL_COLUMN_NAME }" id="BD_DATA${model.BL_KEYNO }" name="BD_DATA" value="${BoardNotice.BN_TITLE}" maxlength="70">
										</c:if>
									</c:if>
									<c:if test="${empty BoardNotice }">
										<input type="text" class="${BL_VALIDATE} txt_nor md w100" data-title="${model.BL_COLUMN_NAME }" id="BD_DATA${model.BL_KEYNO }" name="BD_DATA" value="" maxlength="70">
									</c:if>
		                            </td>
		                        </tr>
								
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
                        
                        <tr>
                        	<th><label for=""><b>*</b> 발전소 명칭</label></th>
                        	<td>
                        		<select id="BN_PLANT_NAME" name="BN_PLANT_NAME" class="txt_nor md w100">
                        			<c:forEach items="${Plant_List }" var="plant">
                        				<option value="${plant.DPP_KEYNO }" ${plant.DPP_KEYNO eq BoardNotice.BN_PLANT_NAME ? 'selected' : '' } >${plant.DPP_NAME }</option>
                        			</c:forEach>
                        		</select>
                        	</td>
                        </tr>
                        
                        
                        <c:if test="${BoardType.BT_UPLOAD_YN == 'Y'}"> 
							<tr>
								<th><label for=""><b>*</b> 첨부파일</label></th>
						        <td>

								<%@ include file="/WEB-INF/jsp/dyAdmin/operation/file/pra_file_insertView.jsp"%>
								
								<c:if test="${action eq 'update' || action eq 'move'}">
									<input type="hidden" name="fsSize" id="fsSize" value="${fn:length(FileSub) }" class="txt_nor md w100">
									<input type="hidden" name="BN_FM_KEYNO" id="BN_FM_KEYNO" value="${BoardNotice.BN_FM_KEYNO }" class="txt_nor md w100">
								</c:if>
								</td>		
							</tr>
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
						<tr>
							<th><label for="BN_CONTENTS"><b>*</b> 내용</label></th>
							<td>
							<c:if test="${action eq 'insert' }">
								<textarea name="BN_CONTENTS" class="txtarea_nor w100" id="BN_CONTENTS" rows="5" style="width:100%;height:400px;min-width:260px;padding:10px;" onkeydown="useTab(this);" title="내용을 입력해주세요"></textarea>
							</c:if>
							<c:if test="${action eq 'update' || action eq 'move'}">
								<textarea name="BN_CONTENTS" class="txtarea_nor w100" id="BN_CONTENTS" rows="5" style="width:100%;height:400px;min-width:260px;padding:10px;" onkeydown="useTab(this);" title="내용을 입력해주세요">
									${BoardNotice.BN_CONTENTS}
								</textarea>
							</c:if>
							</td>
						</tr>
                    </tbody>
                </table>
            </div>
            
            <div class="upload_btns">
	            <button type="button" class="btn_nor round b_line" onclick="pf_boardDataAction()">
					<c:choose>
						<c:when test="${action eq 'insert' }">글쓰기</c:when>	
						<c:when test="${action eq 'update' }">수정</c:when>	
						<c:when test="${action eq 'move' }">이동</c:when>	
					</c:choose>					
				</button>
				
				<button type="button" class="btn_nor round g_line" onclick="pf_back()">취소</button>
			</div>
			</form:form>
			
			<c:if test="${BoardHtml.BIH_DIV_LOCATION eq 'B' }">
			<tr>
               <th><label for="html_contents"><b>*</b> 내용</label></th>
	            <td>
	                <textarea id="html_contents" >${BoardHtml.BIH_CONTENTS }</textarea>
	            </td>
            </tr>
			</c:if>
		</div>
	</div>
</div>
