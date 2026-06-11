<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>



<script type="text/javascript" src="/resources/api/se2/js/HuskyEZCreator.js" charset="utf-8"></script>
<%@ include file="/WEB-INF/jsp/dyAdmin/include/_board/pra_script_insertView.jsp" %>  
<%@ include file="/WEB-INF/jsp/dyAdmin/include/_board/pra_script_insertView_nomal.jsp" %>  

<div id="content">
	<section id="widget-grid" >
		<div class="row">
			<article class="col-sm-12 col-md-12 col-lg-12">
				<div class="jarviswidget jarviswidget-color-blueDark" id="" data-widget-editbutton="false">
					<header>
						<span class="widget-icon"> <i class="fa fa-lg fa-desktop"></i> </span>
						<c:if test="${action eq 'insert' }">
						<h2>게시물 등록하기 </h2>
						</c:if>
						<c:if test="${action eq 'update' }">
						<h2>게시물 수정하기 </h2>
						</c:if>
						<c:if test="${action eq 'move' }">
						<h2>게시물 이동하기 </h2>
						</c:if>
					</header> 
					
					<div class="jarviswidget-editbox"></div>
					
					<div class="widget-body">
	
	<form:form id="Form" class="form-horizontal" name="Form" method="post" enctype="multipart/form-data">
		<input type="hidden" name="BD_BT_KEYNO" value="${BoardType.BT_KEYNO }">
		<input type="hidden" name="BN_MN_KEYNO" value="${Menu.MN_KEYNO }">
		<input type="hidden" name="MN_KEYNO" value="${Menu.MN_KEYNO }">
		<input type="hidden" name="BN_IMPORTANT" id="BN_IMPORTANT" value="${BoardNotice.BN_IMPORTANT }">
		<input type="hidden" name="BT_THUMBNAIL_YN" value="${BoardType.BT_THUMBNAIL_YN  }">
		<input type="hidden" name="BT_ZIP_YN" id="BT_ZIP_YN" value="${BoardType.BT_ZIP_YN}">
		<input type="hidden" name="BN_KEYNO" id="BN_KEYNO" value="${BoardNotice.BN_KEYNO }">
		<input type="hidden" name="fileUpdateCheck" id="fileUpdateCheck" value="N">
		<input type="hidden" name="action" id="action" value="${action}">
		
		<c:if test="${not empty BoardNotice}">
		
		<input type="hidden" name="BN_MAINKEY" id="BN_MAINKEY" value="${BoardNotice.BN_MAINKEY }">
		<input type="hidden" name="BN_PARENTKEY" id="BN_PARENTKEY" value="${BoardNotice.BN_KEYNO}">
		<input type="hidden" name="BN_SEQ" id="BN_SEQ" value="${BoardNotice.BN_SEQ }">
		<input type="hidden" name="BN_DEPTH" id="BN_DEPTH" value="${BoardNotice.BN_DEPTH}">
		</c:if>
		<c:if test="${action eq 'insert' }">
			<input type="hidden" name="BN_REGNM" id="BN_REGNM" value="${userInfo.UI_KEYNO }">
		</c:if>
		<c:if test="${action eq 'update' || action eq 'move' }">
			<input type="hidden" name="BN_MODNM" value="${userInfo.UI_KEYNO }">
			<input type="hidden" name="BN_THUMBNAIL" id="BN_THUMBNAIL" value="${BoardNotice.BN_THUMBNAIL }">
		</c:if>
		<c:if test="${action eq 'move' }">
			<input type="hidden" name="BN_MOVE_MEMO" value="${BoardNotice.BN_MOVE_MEMO }">
			<input type="hidden" name="BT_KEYNO" value="${PreBoardType.BT_KEYNO }">
		</c:if>
		<legend>
			<c:if test="${action eq 'insert' }">
			<h2>게시물 등록하기 </h2>
			</c:if>
			<c:if test="${action eq 'update' }">
			<h2>게시물 수정하기 </h2>
			</c:if>
			<c:if test="${action eq 'move' }">
			<h2>게시물 이동하기 </h2>
			</c:if>
		</legend>
		
		<c:if test="${action eq 'move' }">
		<legend>
			<fieldset>
				<h3>이전 게시물 컬럼 데이터</h3>
				<c:if test="${action eq 'move' && BoardType.BT_KEYNO ne PreBoardType.BT_KEYNO }">
					<c:forEach items="${PreBoardColumnData }" var="model">
						<c:if test="${model.BD_BL_TYPE ne sp:getData('BOARD_COLUMN_TYPE_TITLE') and !empty model.BD_DATA}">
						<div class="row">
							<div class="form-group has-feedback">
								<label class="col-md-2 control-label">${model.COLUMN_NAME }</label>
								<div class="col-md-3">
									<input class="form-control column_data" type="text" value="${model.BD_DATA }" readonly="readonly">
								</div>
								
								<div class="col-md-2">
									<select id="BD_DATA${model.BD_KEYNO }" class="form-control">
										<option value="">선택하세요</option>
										<c:forEach items="${BoardColumnList }" var="model2">
											<c:if test="${model.BD_BL_TYPE eq model2.BL_TYPE }">
												<option value="${model2.BL_KEYNO }">${model2.BL_COLUMN_NAME }</option>
											</c:if>
										</c:forEach>
									</select>
								</div>
								
								<div class="col-md-1">
									<input class="form-control" type="button" value="적용하기" onclick="pf_adjust('BD_DATA${model.BD_KEYNO }', '${model.BD_BL_TYPE}', '${model.BD_DATA_ORI}');">
								</div>
								
								<div class="col-md-1">
									<a class="btn btn btn-default btn-xs" href="javascript:void(0);" onclick="pf_ClipBoard(this);">
										<i class="fa fa-copy"></i>
									</a>
									<!-- <input class="form-control" type="button" value="복사하기" onclick="pf_ClipBoard(this);"> -->
								</div>
								
							</div>
						</div>
						</c:if>
					</c:forEach>
				</c:if>
			</fieldset>
		</legend>
		</c:if>
	
		<fieldset>
			<div class="row">
			<div class="form-group has-feedback">
				<label class="col-md-2 control-label">공지사용</label>
				<div class="col-md-2">
					<label class="checkbox checkbox-inline no-margin">
					<input type="checkbox" value="Y" name="BN_IMPORTANT_CHECK" id="BN_IMPORTANT_CHECK" class="checkbox style-2" data-bv-field="rating" ${BoardNotice.BN_IMPORTANT eq 'Y' ? 'checked':'' }>
					<span>사용</span> </label>
				</div>
				
				<div class="col-md-4">
					<label class="col-md-4 control-label">공지 종료일</label>
					<div class="input-group">
						<input name="BN_IMPORTANT_DATE" id="BN_IMPORTANT_DATE" type="text" class="form-control" readonly="readonly" value="${BoardNotice.BN_IMPORTANT_DATE }" >
						<span class="input-group-addon"><i class="fa fa-calendar"></i></span>
					</div>
				</div>

				<div class="col-md-2">
					<div class="bs-example necessT">
			         <span class="colorR fs12">*표시는 필수 입력 항목입니다.</span>
			   	    </div>
				</div>

			</div>
			</div>
		
		
			<c:if test="${BoardType.BT_CATEGORY_YN eq 'Y' }">
				<div class="row">
					<div class="form-group has-feedback">
						<label class="col-md-2 control-label"><span>*</span> 카테고리 구분 </label>
					<div class="col-md-6">
							<div class="input-group">
					<select class="form-control input-sm" id="BN_CATEGORY_NAME" name="BN_CATEGORY_NAME">
							<option> 전체 </option>
						<c:forEach var = "categoryname" items= "${ fn:split(BoardType.BT_CATEGORY_INPUT,',')}" > 
						
							<option value="${categoryname }" ${categoryname eq BoardNotice.BN_CATEGORY_NAME ? 'selected' : ''}>${categoryname }</option>
						
						</c:forEach>
						
					</select>
					</div>
					</div>
					</div>
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
					<div class="form-group has-feedback">
						<label class="col-md-2 control-label"> <c:if test="${model.BL_VALIDATE eq 'Y' }"><span>*</span></c:if> ${model.BL_COLUMN_NAME }</label>
						<div class="col-md-6">
							<div class="input-group">
							<c:if test="${not empty BoardNotice }">
								<c:if test="${action eq 'insert' }">
								<input type="text" class="form-control ${BL_VALIDATE} checkTrim" data-title="${model.BL_COLUMN_NAME }" id="BD_DATA${model.BL_KEYNO }" name="BD_DATA" value="RE:${BoardNotice.BN_TITLE}" maxlength="70">
								</c:if>
								<c:if test="${action eq 'update' || action eq 'move'}">
								<input type="text" class="form-control ${BL_VALIDATE} checkTrim" data-title="${model.BL_COLUMN_NAME }" id="BD_DATA${model.BL_KEYNO }" name="BD_DATA" value="${BoardNotice.BN_TITLE}" maxlength="70">
								</c:if>
							</c:if>
							<c:if test="${empty BoardNotice }">
								<input type="text" class="form-control ${BL_VALIDATE} checkTrim" data-title="${model.BL_COLUMN_NAME }" id="BD_DATA${model.BL_KEYNO }" name="BD_DATA" value="" maxlength="70">
							</c:if>
							<span class="input-group-addon"><i class="fa fa-bold"></i></span>
							</div>
						</div>
					</div>
				</div>
				<c:set var="checkTitle" value="true"/>
			</c:if>
			
			<c:if test="${checkTitle && BoardType.BT_THUMBNAIL_YN eq 'Y' }">
				<c:set var="checkTitle" value="false"/>
				<div class="row">
					<div class="form-group has-feedback">
						<label class="col-md-2 control-label"><span>*</span> 썸네일</label>
						<div class="col-md-6 smart-form">
							<div class="col-md-12 smart-form">
								<img style="width:${BoardType.BT_THUMBNAIL_WIDTH }px;height:${BoardType.BT_THUMBNAIL_HEIGHT }px;margin:5px 0;" onerror="this.style.display='none';this" src="${BoardNotice.THUMBNAIL_PUBLIC_PATH }" id="thumbnail_img" alt="썸네일"/>
								<div class="col-md-10 smart-form">
									<div class="input input-file">
										<span class="button">
											<input id="thumbnail" type="file" name="thumbnail" onchange="cf_imgCheckAndPreview('thumbnail')">파일선택
										</span>
										<input type="text" name="thumbnail_text" id="thumbnail_text" placeholder="이미지를 선택하여주세요.">
									</div>
								</div>
								<div class="col-md-2 smart-form">
								<button type="button" class="btn btn-sm btn-default" onclick="thumnail_delete('${BoardNotice.BN_KEYNO }')" style="margin:3px;float: right;">썸네일 삭제</button>
								</div>
							</div>
							<p class="note">사이즈 :: ${BoardType.BT_THUMBNAIL_WIDTH } X ${BoardType.BT_THUMBNAIL_HEIGHT } 사이즈가 다를시 자동 리사이즈 됩니다.</p>
							<input type="hidden" name="BT_THUMBNAIL_WIDTH" value="${BoardType.BT_THUMBNAIL_WIDTH }">
							<input type="hidden" name="BT_THUMBNAIL_HEIGHT" value="${BoardType.BT_THUMBNAIL_HEIGHT  }">
						</div>
					</div>
				</div>
			</c:if>
			
		 			 
			
			
			<c:if test="${model.BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_TEXT') }">
				<div class="row">
					<div class="form-group has-feedback">
						<label class="col-md-2 control-label">${model.BL_VALIDATE eq 'Y' ?'<span>*</span>':'' } ${model.BL_COLUMN_NAME }</label>
						<div class="col-md-6">
							<input type="text" class="form-control ${BL_VALIDATE} checkTrim" data-title="${model.BL_COLUMN_NAME }" id="BD_DATA${model.BL_KEYNO }" name="BD_DATA" value="" maxlength="70">
						</div>
					</div>
				</div>
			</c:if>
			
			<c:if test="${model.BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_LINK') }">
				<div class="row">
					<div class="form-group has-feedback">
						<label class="col-md-2 control-label">${model.BL_VALIDATE eq 'Y' ?'<span>*</span>':'' }  ${model.BL_COLUMN_NAME }</label>
						<div class="col-md-6">
							<input type="text" class="form-control ${BL_VALIDATE}" data-title="${model.BL_COLUMN_NAME }" id="BD_DATA${model.BL_KEYNO }" name="BD_DATA" value="" maxlength="70">
						</div>
						<div class="col-md-4">
							<button type="button" class="btn btn-primary" onclick="pf_link('BD_DATA${model.BL_KEYNO }')">링크 확인</button>
						</div>
						<div class="col-md-2"></div>
						<div class="col-md-10">
							<p style="color:red;">외부 url의 경우 http:// 나 https:// 로 시작되어야됩니다.</p>
						</div>
					</div>
				</div>
			</c:if>
			
			<c:if test="${model.BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_CALENDAR')}">
				<div class="row">
					<div class="form-group has-feedback">
						<label class="col-md-2 control-label">${model.BL_VALIDATE eq 'Y' ?'<span>*</span>':'' }  ${model.BL_COLUMN_NAME }</label>
						<div class="col-md-6">
							<div class="input-group">
								<input type="text" class="form-control ${BL_VALIDATE} BD_DATA_CALENDAR datepicker" data-dateformat="yy-mm-dd" data-title="${model.BL_COLUMN_NAME }" id="BD_DATA${model.BL_KEYNO }" name="BD_DATA" value="" maxlength="10" readonly="readonly">
								<span class="input-group-addon"><i class="fa fa-calendar"></i></span>
							</div>
						</div>
					</div>
				</div>
			</c:if>
			
			<c:if test="${model.BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_CALENDAR_START') }">
				<div class="row">
					<div class="form-group has-feedback">
						<label class="col-md-2 control-label">${model.BL_VALIDATE eq 'Y' ?'<span>*</span>':'' }  ${model.BL_COLUMN_NAME }</label>
						<div class="col-md-6">
							<div class="input-group">
								<input type="text" class="form-control ${BL_VALIDATE} BD_DATA_CALENDAR_START datepicker" data-dateformat="yy-mm-dd" data-title="${model.BL_COLUMN_NAME }" id="BD_DATA${model.BL_KEYNO }" name="BD_DATA" value="" maxlength="10" readonly="readonly">
								<span class="input-group-addon"><i class="fa fa-calendar"></i></span>
							</div>
						</div>
					</div>
				</div>
			</c:if>
			
			<c:if test="${model.BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_CALENDAR_END') }">
				<div class="row">
					<div class="form-group has-feedback">
						<label class="col-md-2 control-label">${model.BL_VALIDATE eq 'Y' ?'<span>*</span>':'' }  ${model.BL_COLUMN_NAME }</label>
						<div class="col-md-6">
							<div class="input-group">
								<input type="text" class="form-control ${BL_VALIDATE} BD_DATA_CALENDAR_END datepicker" data-dateformat="yy-mm-dd" data-title="${model.BL_COLUMN_NAME }" id="BD_DATA${model.BL_KEYNO }" name="BD_DATA" value="" maxlength="10" readonly="readonly">
								<span class="input-group-addon"><i class="fa fa-calendar"></i></span>
							</div>
						</div>
					</div>
				</div>
			</c:if>
			
			
			<c:if test="${model.BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_PWD') }">
				<div class="row">
					<div class="form-group has-feedback">
						<label class="col-md-2 control-label">${model.BL_VALIDATE eq 'Y' ?'<span>*</span>':'' }  ${model.BL_COLUMN_NAME }</label>
						<div class="col-md-6">
							<div class="input-group">
								<input type="password" class="form-control ${BL_VALIDATE}" data-title="${model.BL_COLUMN_NAME }" id="BD_DATA${model.BL_KEYNO }" name="BD_DATA" value="" maxlength="20">
								<span class="input-group-addon"><i class="fa fa-lock"></i></span>
							</div>
						</div>
					</div>
				</div>
			</c:if>
			
			<c:if test="${model.BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_EMAIL') }">
				<div class="row">
					<div class="form-group has-feedback">
						<label class="col-md-2 control-label">${model.BL_VALIDATE eq 'Y' ?'<span>*</span>':'' }  ${model.BL_COLUMN_NAME }</label>
						<div class="col-md-6">
							<label class="input-group"> 
								<input type="text" class="form-control ${BL_VALIDATE} BD_DATA_EMAIL" data-title="${model.BL_COLUMN_NAME }" id="BD_DATA${model.BL_KEYNO }" name="BD_DATA" value="" maxlength="30">
								<span class="input-group-addon"><i class="fa fa-envelope-o"></i></span>
							</label>
						</div>
					</div>
				</div>
			</c:if>
			
			<c:if test="${model.BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_NUMBER') }">
				<div class="row">
					<div class="form-group has-feedback">
						<label class="col-md-2 control-label">${model.BL_VALIDATE eq 'Y' ?'<span>*</span>':'' }  ${model.BL_COLUMN_NAME }</label>
						<div class="col-md-6">
							<label class="input-group"> 
								<input type="number" class="form-control ${BL_VALIDATE} BD_DATA_NUMBER" data-title="${model.BL_COLUMN_NAME }" id="BD_DATA${model.BL_KEYNO }" name="BD_DATA" value="" oninput="cf_maxLengthCheck(this)" max="99999999999" maxlength="11">
								<span class="input-group-addon"><i class="fa fa-cube"></i></span>
							</label>
						</div>
					</div>
				</div>
			</c:if>
			
			<c:if test="${model.BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_CHECK') }">
				<div class="row">
					<div class="form-group">
						<label class="col-md-2 control-label">${model.BL_VALIDATE eq 'Y' ?'<span>*</span>':'' }  ${model.BL_COLUMN_NAME }</label>
						<div class="col-md-6">
							<input type="hidden" name="BD_DATA" id="BD_DATA${model.BL_KEYNO }" value=""  class="${BL_VALIDATE}" data-type="check" data-title="${model.BL_COLUMN_NAME }">
							<c:set var="checkData" value="${fn:split(model.BL_OPTION_DATA, '|') }"></c:set>
							<c:forEach items="${checkData }" var="OPTIONDATA" varStatus="c">
								<label class="checkbox-inline">
									<input type="checkbox" class="checkbox style-0" name="BD_DATA${model.BL_KEYNO }" value="${OPTIONDATA }" onchange="pf_checkOption(this)">
									<span>${OPTIONDATA }</span>
								</label>
							</c:forEach>
						</div>
					</div>
				</div>
			</c:if>
			
			<c:if test="${model.BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_RADIO') }">
				<div class="row">
					<div class="form-group">
						<label class="col-md-2 control-label">${model.BL_VALIDATE eq 'Y' ?'<span>*</span>':'' }  ${model.BL_COLUMN_NAME }</label>
						<div class="col-md-6">
							<input type="hidden" name="BD_DATA" id="BD_DATA${model.BL_KEYNO }" value=""  class="${BL_VALIDATE}" data-type="radio" data-title="${model.BL_COLUMN_NAME }">
							<c:set var="checkData" value="${fn:split(model.BL_OPTION_DATA, '|') }"></c:set>
							<c:forEach items="${checkData }" var="OPTIONDATA" varStatus="c">
								<label class="radio radio-inline">
									<input type="radio" class="radiobox style-0" name="BD_DATA${model.BL_KEYNO }" value="${OPTIONDATA }" onchange="pf_radioOption(this)">
									<span>${OPTIONDATA }</span>
								</label>
							</c:forEach>
						</div>
					</div>
				</div>
			</c:if>
			
			<c:if test="${model.BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_SELECT') }">
				<div class="row">
					<div class="form-group">
						<label class="col-md-2 control-label">${model.BL_VALIDATE eq 'Y' ?'<span>*</span>':'' }  ${model.BL_COLUMN_NAME }</label>
						<div class="col-md-6">
							<select name="BD_DATA" id="BD_DATA${model.BL_KEYNO }" class="form-control ${BL_VALIDATE}" data-title="${model.BL_COLUMN_NAME }">
								<option value="">선택하세요</option>
								<c:set var="selectData" value="${fn:split(model.BL_OPTION_DATA, '|') }"></c:set>
								<c:forEach items="${selectData }" var="OPTIONDATA">
									<option value="${OPTIONDATA }">${OPTIONDATA }</option>
								</c:forEach>
							</select>
						</div>
					</div>
				</div>
			</c:if>
			
			<c:if test="${model.BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_CHECK_CODE') }">
				<div class="row">
					<div class="form-group">
						<label class="col-md-2 control-label">${model.BL_VALIDATE eq 'Y' ?'<span>*</span>':'' }  ${model.BL_COLUMN_NAME }</label>
						<div class="col-md-6">
							<input type="hidden" name="BD_DATA" id="BD_DATA${model.BL_KEYNO }" value=""  class="${BL_VALIDATE}" data-type="check" data-title="${model.BL_COLUMN_NAME }">
							<c:set var="checkData" value="${fn:split(model.BL_OPTION_DATA, '|') }"></c:set>
							<c:forEach items="${BoardColumnCodeList }" var="OPTIONDATA" varStatus="c">
								<c:if test="${OPTIONDATA.MC_KEYNO eq model.BL_OPTION_DATA }">
								<label class="checkbox-inline">
									<input type="checkbox" class="checkbox style-0" name="BD_DATA${model.BL_KEYNO }" value="${OPTIONDATA.SC_KEYNO}" onchange="pf_checkOption(this)">
									<span>${OPTIONDATA.SC_CODENM }</span>
								</label>
								</c:if>
							</c:forEach>
						</div>
					</div>
				</div>
			</c:if>
			
			<c:if test="${model.BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_RADIO_CODE') }">
				<div class="row">
					<div class="form-group">
						<label class="col-md-2 control-label">${model.BL_VALIDATE eq 'Y' ?'<span>*</span>':'' }  ${model.BL_COLUMN_NAME }</label>
						<div class="col-md-6">
							<input type="hidden" name="BD_DATA" id="BD_DATA${model.BL_KEYNO }" value=""  class="${BL_VALIDATE}" data-type="radio" data-title="${model.BL_COLUMN_NAME }">
							<c:set var="checkData" value="${fn:split(model.BL_OPTION_DATA, '|') }"></c:set>
							<c:forEach items="${BoardColumnCodeList }" var="OPTIONDATA" varStatus="c">
								<c:if test="${OPTIONDATA.MC_KEYNO eq model.BL_OPTION_DATA }">
								<label class="radio radio-inline">
									<input type="radio" class="radiobox style-0" name="BD_DATA${model.BL_KEYNO }" value="${OPTIONDATA.SC_KEYNO }" onchange="pf_radioOption(this)">
									<span>${OPTIONDATA.SC_CODENM }</span>
								</label>
								</c:if>
							</c:forEach>
						</div>
					</div>
				</div>
			</c:if>
			
			<c:if test="${model.BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_SELECT_CODE') }">
				<div class="row">
					<div class="form-group">
						<label class="col-md-2 control-label">${model.BL_VALIDATE eq 'Y' ?'<span>*</span>':'' }  ${model.BL_COLUMN_NAME }</label>
						<div class="col-md-6">
							<select name="BD_DATA" id="BD_DATA${model.BL_KEYNO }" class="form-control ${BL_VALIDATE}" data-title="${model.BL_COLUMN_NAME }">
								<option value="">선택하세요</option>
								<c:set var="selectData" value="${fn:split(model.BL_OPTION_DATA, '|') }"></c:set>
								<c:forEach items="${BoardColumnCodeList }" var="OPTIONDATA">
									<c:if test="${OPTIONDATA.MC_KEYNO eq model.BL_OPTION_DATA }">
									<option value="${OPTIONDATA.SC_KEYNO }">${OPTIONDATA.SC_CODENM }</option>
									</c:if>
								</c:forEach>
							</select>
						</div>
					</div>
				</div>
			</c:if>
			
		</c:forEach>
		
		<c:if test="${BoardType.BT_UPLOAD_YN == 'Y' && not empty userInfo}">
			<div class="row">
				<div class="form-group has-feedback">
					<label class="col-md-2 control-label">첨부파일</label>
					<div class="col-md-6">
						<%@ include file="/WEB-INF/jsp/dyAdmin/operation/file/pra_file_insertView.jsp"%>
						<c:if test="${action eq 'update' || action eq 'move'}">
							<input type="hidden" name="fsSize" id="fsSize" value="${fn:length(FileSub) }">
							<c:if test="${fn:length(FileSub) > 0}">
									<input type="hidden" name="BN_FM_KEYNO" id="BN_FM_KEYNO" value="${BoardNotice.BN_FM_KEYNO }">
							</c:if>
						</c:if>
					</div>
				</div>
			</div>
		</c:if>
		
		<c:if test="${BoardType.BT_SECRET_YN == 'Y'}">
			<div class="row">
				<div class="form-group">
					<label class="col-md-2 control-label">비밀글 여부</label>
					<div class="col-md-6">
						<label class="radio radio-inline">
							<input type="radio" class="radiobox style-0" name="BN_SECRET_YN" value="Y">
							<span>비밀글</span>
						</label>
						<label class="radio radio-inline">
							<input type="radio" class="radiobox style-0" name="BN_SECRET_YN" value="N" checked>
							<span>일반글</span>
						</label>
					</div>
				</div>
			</div>
		</c:if>
		
	
		<div class="row">
			<div class="form-group has-feedback">
				<label class="col-md-2 control-label"><span>*</span> 내용</label>
				<div class="col-md-8">
					<c:if test="${action eq 'insert' }">
					<textarea name="BN_CONTENTS" id="BN_CONTENTS" rows="5" style="width:100%;height:400px;min-width:260px;padding:10px;" onkeydown="useTab(this);"></textarea>
					</c:if>
					<c:if test="${action eq 'update' || action eq 'move'}">
					<textarea name="BN_CONTENTS" id="BN_CONTENTS" rows="5" style="width:100%;height:400px;min-width:260px;padding:10px;" onkeydown="useTab(this);">${BoardNotice.BN_CONTENTS } </textarea>
					</c:if>
				</div>
			</div>	
		</div>
		
		<c:if test="${BoardType.BT_HTMLMAKER_PLUS_YN eq 'Y'}">
			<div class="row" id="editorbox" >
				<label class="col-md-2 control-label titleBox"><span></span> 에디터이미지</label>
		        <div class="col-md-8 smart-form">
					<div class="input input-file col-md-10">
						<span class="button">
							<input type="file" id="smartimg" name="smartimg" class="txtDefault txtWlong_1" onchange="selectFiles(this,'smartimg');" multiple="multiple">파일선택
						</span>
						<input type="text" name="smartimg_text" id="smartimg_text" placeholder="이미지를 선택하여주세요.">
					</div>
					<div class="col-md-2 smart-form">
					<button class="btn btn-sm btn-default"  type="button" id="imgsettingbutton" onclick="imgSetting();">적용</button>
					</div>
					<input type="hidden" id="selectedImg">
					<div id="smartimg_img">
					</div>
				</div>
			</div>
		</c:if>
	
		<div class="form-actions">
			<div class="row">
				<div class="col-md-12">
					<button type="button" class="btn btnBig_02 btn-default" onclick="pf_boardDataAction()">
						<c:choose>
							<c:when test="${action eq 'insert' }">글쓰기</c:when>	
							<c:when test="${action eq 'update' }">수정</c:when>	
							<c:when test="${action eq 'move' }">이동</c:when>	
						</c:choose>					
					</button>
					<button class="btn btn-sm btn-default" id="Board_Delete" type="button" onclick="pf_back();">취소</button> 
				</div>
			</div>
		</div>
		</fieldset>
		
	</form:form>
					</div>
				</div>
			</article>
		</div>
	</section>
</div>


<!-- 개인정보 보안 dialog -->
<div id="page_comment" title="개인정보 필터">
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

<c:if test="${BoardType.BT_HTMLMAKER_PLUS_YN eq 'Y'}">
	<%@ include file="/WEB-INF/jsp/dyAdmin/include/_board/pra_editor_imgSetting.jsp" %>    
</c:if>

