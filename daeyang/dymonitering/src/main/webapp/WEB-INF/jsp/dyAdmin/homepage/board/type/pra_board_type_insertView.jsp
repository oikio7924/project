<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<style>
.columnTitle {
	text-align: center;
	word-break: keep-all;
	border-top: 1px solid #ddd;
	border-bottom: 1px solid #ccc;
	padding: 5px 0
}
.columnTitle section {margin-bottom: 0}
.input-group-addon {background-color: #fff; border: none; }
.checkboxWrap{border-bottom: 3px solid #ddd;}
.inputmargin{margin-top: 10px;}
.option_dp, .selectCodeWrap, .column_size_dp {display: none;}
    .fixed-btns {position: fixed; bottom: 10px; right: 30px; z-index: 100; }
    .fixed-btns>li { display: inline-block;  margin-bottom: 7px; }

</style>

<c:set value="${action eq 'insertView' ? '등록' : '수정' }" var="actionName"/>
<c:set value="${action eq 'insertView' ? 'insert' : 'update' }" var="actionType"/>
<div id="content">
	<form:form id="Form" name="Form" method="post" action="/dyAdmin/homepage/board/type/action.do">
		<input type="hidden" id="action" name="action" value="${actionType}" />
		
		<c:if test="${actionType eq 'insert' }">
			<input type="hidden" name="BT_REGNM" value="${userInfo.UI_ID }" />
		</c:if>
		<c:if test="${actionType eq 'update' }">
			<input type="hidden" name="BT_MODNM" value="${userInfo.UI_ID }" />
			<input type="hidden" name="BT_KEYNO" value="${BoardType.BT_KEYNO }" />
		</c:if>
		
		<input type="hidden" name="BT_FILE_EXT" id="BT_FILE_EXT" value=""/>
		<input type="hidden" id="BT_HTML_YN" name="BT_HTML_YN" value="${BoardType.BT_HTML_YN }"/>
		<input type="hidden" id="BT_XSS_YN" name="BT_XSS_YN" value="${BoardType.BT_XSS_YN }"/>
		<input type="hidden" id="BT_NUMBERING_TYPE" name="BT_NUMBERING_TYPE" value="${BoardType.BT_NUMBERING_TYPE }"/>
		<input type="hidden" id="BT_SECRET_YN" name="BT_SECRET_YN" value="${BoardType.BT_SECRET_YN }"/>
		<input type="hidden" id="BT_REPLY_YN" name="BT_REPLY_YN" value="${BoardType.BT_REPLY_YN }"/>
		<input type="hidden" id="BT_COMMENT_YN" name="BT_COMMENT_YN" value="${BoardType.BT_COMMENT_YN }"/>
		<input type="hidden" id="BT_DEL_LISTVIEW_YN" name="BT_DEL_LISTVIEW_YN" value="${BoardType.BT_DEL_LISTVIEW_YN }"/>
		<input type="hidden" id="BT_DEL_COMMENT_YN" name="BT_DEL_COMMENT_YN" value="${BoardType.BT_DEL_COMMENT_YN }"/>
		<input type="hidden" id="BT_THUMBNAIL_YN" name="BT_THUMBNAIL_YN" value="${BoardType.BT_THUMBNAIL_YN }"/>
		<input type="hidden" id="BT_EMAIL_YN" name="BT_EMAIL_YN" value="${BoardType.BT_EMAIL_YN }"/>
		<input type="hidden" id="BT_UPLOAD_YN" name="BT_UPLOAD_YN" value="${BoardType.BT_UPLOAD_YN }"/>
		<input type="hidden" id="BT_SHOW_MINE_YN" name="BT_SHOW_MINE_YN" value="${BoardType.BT_SHOW_MINE_YN }"/>
		<input type="hidden" id="BT_PERSONAL_YN" name="BT_PERSONAL_YN" value="${BoardType.BT_PERSONAL_YN }"/>
		<input type="hidden" id="BT_DEL_POLICY" name="BT_DEL_POLICY" value="${BoardType.BT_DEL_POLICY }"/>
		<input type="hidden" id="BT_ZIP_YN" name="BT_ZIP_YN" value="${BoardType.BT_ZIP_YN }"/>
		<input type="hidden" id="BT_MOVIE_THUMBNAIL_YN" name="BT_MOVIE_THUMBNAIL_YN" value="${BoardType.BT_MOVIE_THUMBNAIL_YN }"/>
		<input type="hidden" id="BT_CATEGORY_YN" name="BT_CATEGORY_YN" value="${BoardType.BT_CATEGORY_YN }"/>
		<input type="hidden" id="BT_SECRET_COMMENT_YN" name="BT_SECRET_COMMENT_YN" value="${BoardType.BT_SECRET_COMMENT_YN }"/>
		<input type="hidden" id="BT_CALENDAR_YN" name="BT_CALENDAR_YN" value="${BoardType.BT_CALENDAR_YN }"/>
		<input type="hidden" id="BT_PREVIEW_YN" name="BT_PREVIEW_YN" value="${BoardType.BT_PREVIEW_YN }"/>
		<input type="hidden" id="BT_DEL_MANAGE_YN" name="BT_DEL_MANAGE_YN" value="${BoardType.BT_DEL_MANAGE_YN }"/>
		<input type="hidden" id="BT_FORBIDDEN_YN" name="BT_FORBIDDEN_YN" value="${BoardType.BT_FORBIDDEN_YN }"/>

		<section id="widget-grid">
			<div class="row">
				<article class="col-sm-12 col-md-12 col-lg-12">
					<div class="jarviswidget jarviswidget-color-blueDark" id=""
						data-widget-editbutton="false">
						<header>
							<span class="widget-icon"> <i class="fa fa-table"></i>
							</span>
							<h2>게시판 타입 ${actionName}</h2>
						</header>

						<div>
							<div class="widget-body-toolbar bg-color-white">
								<div class="alert alert-info no-margin fade in">
									<button type="button" class="close" data-dismiss="alert">×</button>
									새로운 게시판 타입 정보를 생성합니다.<br> <span style="color: red;">*표시는
										필수 입력 항목입니다.</span>
								</div>
							</div>

							<div class="widget-body no-padding smart-form">
								<fieldset>
									<div class="row">
										<section class="col col-12">
											<h6>게시판 정보 ${actionName}</h6>
										</section>
									</div>

									<div class="row">
										<section class="col col-6">
											<span class="nessSpan">*</span> 게시판 타입명 <label class="input">
												<i class="icon-prepend fa fa-edit"></i> <input
												class="checkTrim inputmargin" type="text" id="BT_TYPE_NAME"
												name="BT_TYPE_NAME" placeholder="게시판 타입명" maxlength="50"
												value="${BoardType.BT_TYPE_NAME }" />
											</label>
										</section>
										<section class="col col-6">
											<span class="nessSpan">*</span> 스킨 패키지 <label class="select">
												<select name="Package" id="Package" class="inputmargin" onchange="SkinChange(this.value)">
													<option value="-1">패키지 유형</option>
													<c:forEach items="${PackageForm}" var="model">
														<option value="${model.BSP_KEYNO }">${model.BSP_TITLE }</option>
													</c:forEach>
												</select> <i></i>
											</label>
										</section>
									</div>
									
									<div class="row">
										<section class="col col-4">
											<span class="nessSpan">*</span> 리스트 스킨 <label class="select">
												<select name="BT_LIST_KEYNO" id="BT_LIST_KEYNO" class="inputmargin" onchange="PackageChange()">
													   <option value="list" ${BoardType.BT_LIST_KEYNO eq 'list' ? 'selected' : '' }>리스트 기본 폼(기본)</option>
														<option value="no_deatail" ${BoardType.BT_LIST_KEYNO eq 'no_detail' ? 'selected' : '' }>상세페이지 없는 폼(기본)</option>
														<option value="gallery" ${BoardType.BT_LIST_KEYNO eq 'gallery' ? 'selected' : '' }>갤러리 폼(기본)</option>
														<option value="calendar" ${BoardType.BT_LIST_KEYNO eq 'calendar' ? 'selected' : '' }>캘린더 폼(기본)</option>
														<c:forEach items="${SkinForm }" var="model">
														<c:if test="${model.BST_TYPE eq 'list' }">
															<option value="${model.BST_KEYNO }" ${BoardType.BT_LIST_KEYNO eq model.BST_KEYNO? 'selected':'' }>${model.BST_TITLE }</option>
														</c:if>
														</c:forEach>
												</select> <i></i>
											</label>
										</section>
										<section class="col col-4">
											<span class="nessSpan">*</span> 상세페이지 스킨 <label class="select">
												<select name="BT_DETAIL_KEYNO" id="BT_DETAIL_KEYNO" class="inputmargin" onchange="PackageChange()">
														<option value="no" ${BoardType.BT_DETAIL_KEYNO eq 'no' ? 'selected' : '' }>사용안함(기본)</option>
														<option value="normal" ${BoardType.BT_DETAIL_KEYNO eq 'normal' ? 'selected' : '' }>상세페이지 기본 폼(기본)</option>
														<c:forEach items="${SkinForm }" var="model">
														<c:if test="${model.BST_TYPE eq 'detail' }">
															<option value="${model.BST_KEYNO }" ${BoardType.BT_DETAIL_KEYNO eq model.BST_KEYNO? 'selected':'' }>${model.BST_TITLE }</option>
														</c:if>
														</c:forEach>
												</select> <i></i>
											</label>
										</section>
										<section class="col col-4">
											<span class="nessSpan">*</span> 등록 및 수정페이지 스킨 <label class="select">
												<select name="BT_INSERT_KEYNO" id="BT_INSERT_KEYNO" class="inputmargin" onchange="PackageChange()">
													<option value="normal" ${BoardType.BT_INSERT_KEYNO eq 'normal' ? 'selected' : '' }>등록 기본 폼(기본)</option>
													<c:forEach items="${SkinForm }" var="model">
														<c:if test="${model.BST_TYPE eq 'insert' }">
															<option value="${model.BST_KEYNO }" ${BoardType.BT_INSERT_KEYNO eq model.BST_KEYNO? 'selected':'' }>${model.BST_TITLE }</option>
														</c:if>
													</c:forEach>
												</select> <i></i>
											</label>
										</section>
									</div>
									
									<div class="row">
										<section class="col col-6">
											<label class="label input">한 페이지당 게시되는 게시물 건 수 <input
												type="number" id="BT_PAGEUNIT" name="BT_PAGEUNIT" value="${not empty BoardType.BT_PAGEUNIT ? BoardType.BT_PAGEUNIT : '10'}" class="inputmargin"
												oninput="cf_maxLengthCheck(this)" max="99" maxlength="2" />
											</label>
										</section>
										<section class="col col-6">
											<label class="label input"> 페이지 리스트에 게시되는 페이지 건수 <input
												type="number" id="BT_PAGESIZE" name="BT_PAGESIZE" value="${not empty BoardType.BT_PAGESIZE ? BoardType.BT_PAGESIZE : '5'}" class="inputmargin"
												oninput="cf_maxLengthCheck(this)" max="99" maxlength="2" />
											</label>
										</section>
									</div>
									
									<div class="row checkboxWrap" style="margin-bottom: 15px;">										
										<section class="col col-6"> 
										<label class="label">web 에디터</label>
										 <label class="radio">
											<input type="radio" name="BT_HTMLMAKER_PLUS_YN" value="N" ${BoardType.BT_HTMLMAKER_PLUS_YN eq 'N'?'checked':'' } > 사용 안함 <i></i>
											</label>
											<label class="radio">
											<input type="radio" name="BT_HTMLMAKER_PLUS_YN" value="Y" ${BoardType.BT_HTMLMAKER_PLUS_YN eq 'Y'?'checked':'' } > 스마트 에디터 <i></i>
											</label>
											<label class="radio">
											<input type="radio" name="BT_HTMLMAKER_PLUS_YN" value="S" ${BoardType.BT_HTMLMAKER_PLUS_YN eq 'S'?'checked':'' } > 썸머노트 에디터<i></i>
											</label>
										</section>
										
										
										
									</div>
									
									<div class="row checkboxWrap" style="margin-bottom: 15px;">		
										<section class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
											<label class="col col-xs-6 col-sm-6 col-md-6 col-lg-6 control-label">소개HTML 사용여부</label>
											<div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 inline-group">
												<label class="col"> 
													<span class="input-group-addon">
														<span class="onoffswitch">
															<input type="checkbox" name="HTML_YN" value="" 
																	class="onoffswitch-checkbox" id="HTML_YN" >
															<label class="onoffswitch-label" for="HTML_YN"> 
																<span class="onoffswitch-inner" data-swchon-text="YES" data-swchoff-text="NO"></span> 
																<span class="onoffswitch-switch"></span> 
															</label> 
														</span>
													</span>
												</label>	
											</div>
										</section>
										
										<section class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
											<label class="col col-xs-6 col-sm-6 col-md-6 col-lg-6 control-label">XSS 필터 사용여부</label>
											<div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 inline-group">
												<label class="col"> 
													<span class="input-group-addon">
														<span class="onoffswitch">
															<input type="checkbox" name="XSS_YN" value="" 
																	class="onoffswitch-checkbox" id="XSS_YN" >
															<label class="onoffswitch-label" for="XSS_YN"> 
																<span class="onoffswitch-inner" data-swchon-text="YES" data-swchoff-text="NO"></span> 
																<span class="onoffswitch-switch"></span> 
															</label> 
														</span>
													</span>
												</label>	
											</div>
										</section>										
																				
										<section class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
											<label class="col col-xs-6 col-sm-6 col-md-6 col-lg-6 control-label">번호 넘버링 종류</label>
											<div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 inline-group">
												<label class="col"> 
													<span class="input-group-addon">
														<span class="onoffswitch" style="width: 70px;">
															<input type="checkbox" name="NUMBERING_TYPE" value="" 
																	class="onoffswitch-checkbox" id="NUMBERING_TYPE" >
															<label class="onoffswitch-label" for="NUMBERING_TYPE"> 
																<span class="onoffswitch-inner" data-swchon-text="가상번호" data-swchoff-text="실제번호"></span> 
																<span class="onoffswitch-switch onoffswitch-switch2"></span> 
															</label> 
														</span>
													</span>
												</label>	
											</div>
										</section>
										
										<section class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
											<label class="col col-xs-6 col-sm-6 col-md-6 col-lg-6 control-label">자기가 쓴글만 보이기 여부</label>
											<div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 inline-group">
												<label class="col"> 
													<span class="input-group-addon">
														<span class="onoffswitch">
															<input type="checkbox" name="SHOW_MINE_YN" value="" 
																	class="onoffswitch-checkbox" id="SHOW_MINE_YN" >
															<label class="onoffswitch-label" for="SHOW_MINE_YN"> 
																<span class="onoffswitch-inner" data-swchon-text="YES" data-swchoff-text="NO"></span> 
																<span class="onoffswitch-switch"></span> 
															</label> 
														</span>
													</span>
												</label>	
											</div>
										</section>
									
										<section class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
											<label class="col col-xs-6 col-sm-6 col-md-6 col-lg-6 control-label">비밀글 기능 사용여부</label>
												<div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 inline-group">
													<label class="col"> 
														<span class="input-group-addon">
															<span class="onoffswitch">
																<input type="checkbox" name="SECRET_YN" value="" 
																		class="onoffswitch-checkbox" id="SECRET_YN" >
																<label class="onoffswitch-label" for="SECRET_YN"> 
																	<span class="onoffswitch-inner" data-swchon-text="YES" data-swchoff-text="NO"></span> 
																	<span class="onoffswitch-switch"></span> 
																</label> 
															</span>
														</span>
													</label>	
												</div>
										</section>
										
										<section class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
											<label class="col col-xs-6 col-sm-6 col-md-6 col-lg-6 control-label">답글 기능 사용여부</label>
											<div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 inline-group">
												<label> 
													<span class="input-group-addon">
														<span class="onoffswitch">
															<input type="checkbox" name="REPLY_YN" value="" 
																	class="onoffswitch-checkbox" id="REPLY_YN" >
															<label class="onoffswitch-label" for="REPLY_YN"> 
																<span class="onoffswitch-inner" data-swchon-text="YES" data-swchoff-text="NO"></span> 
																<span class="onoffswitch-switch"></span> 
															</label> 
														</span>
													</span>
												</label>	
											</div>
										</section>
										
										<section class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
											<label class="col col-xs-6 col-sm-6 col-md-6 col-lg-6 control-label">삭제된 게시물 리스트에 보여질지 여부</label>
											<div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 inline-group">
												<label class="col"> 
													<span class="input-group-addon">
														<span class="onoffswitch">
															<input type="checkbox" name="DEL_LISTVIEW_YN" value="" 
																	class="onoffswitch-checkbox" id="DEL_LISTVIEW_YN" >
															<label class="onoffswitch-label" for="DEL_LISTVIEW_YN"> 
																<span class="onoffswitch-inner" data-swchon-text="YES" data-swchoff-text="NO"></span> 
																<span class="onoffswitch-switch"></span> 
															</label> 
														</span>
													</span>
												</label>	
											</div>
										</section>
										
										<section class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
											<label class="col col-xs-6 col-sm-6 col-md-6 col-lg-6 control-label">삭제된 댓글 보여질지 여부</label>
											<div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 inline-group">
												<label class="col"> 
													<span class="input-group-addon">
														<span class="onoffswitch">
															<input type="checkbox" name="DEL_COMMENT_YN" value="" 
																	class="onoffswitch-checkbox" id="DEL_COMMENT_YN" >
															<label class="onoffswitch-label" for="DEL_COMMENT_YN"> 
																<span class="onoffswitch-inner" data-swchon-text="YES" data-swchoff-text="NO"></span> 
																<span class="onoffswitch-switch"></span> 
															</label> 
														</span>
													</span>
												</label>	
											</div>
										</section>
										
										<section class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
											<label class="col col-xs-6 col-sm-6 col-md-6 col-lg-6 control-label">동영상 썸네일 생성 여부</label>
											<div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 inline-group">
												<label class="col"> 
													<span class="input-group-addon">
														<span class="onoffswitch">
															<input type="checkbox" name="MOVIE_THUMBNAIL_YN" value="" 
																	class="onoffswitch-checkbox" id="MOVIE_THUMBNAIL_YN" >
															<label class="onoffswitch-label" for="MOVIE_THUMBNAIL_YN"> 
																<span class="onoffswitch-inner" data-swchon-text="YES" data-swchoff-text="NO"></span> 
																<span class="onoffswitch-switch"></span> 
															</label> 
														</span>
													</span>
												</label>	
											</div>
										</section>
										
										<section class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
											<label class="col col-xs-6 col-sm-6 col-md-6 col-lg-6 control-label">캘린더 사용 여부</label>
											<div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 inline-group">
												<label class="col"> 
													<span class="input-group-addon">
														<span class="onoffswitch">
															<input type="checkbox" name="CALENDAR_YN" value="" class="onoffswitch-checkbox" id="CALENDAR_YN" >
															<label class="onoffswitch-label" for="CALENDAR_YN"> 
																<span class="onoffswitch-inner" data-swchon-text="YES" data-swchoff-text="NO"></span> 
																<span class="onoffswitch-switch"></span> 
															</label> 
														</span>
													</span>
												</label>	
											</div>
										</section>			
																														
										<section class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
											<label class="col col-xs-6 col-sm-6 col-md-6 col-lg-6 control-label">게시물 삭제 정책</label>
											<div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 inline-group">
												<label class="col"> 
													<span class="input-group-addon">
														<span class="onoffswitch" style="width: 70px;">
															<input type="checkbox" name="DEL_POLICY" value="" 
																	class="onoffswitch-checkbox" id="DEL_POLICY" >
															<label class="onoffswitch-label" for="DEL_POLICY"> 
																<span class="onoffswitch-inner" data-swchon-text="논리삭제" data-swchoff-text="물리삭제"></span> 
																<span class="onoffswitch-switch onoffswitch-switch2"></span> 
															</label> 
														</span>
													</span>
												</label>	
											</div>
										</section>
										
									<section class="col-xs-6 col-sm-6 col-md-6 col-lg-6 deleteContentsChk">
										<label class="col col-xs-6 col-sm-6 col-md-6 col-lg-6 control-label">게시물 삭제사유 수집 여부</label>
										<div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 inline-group">
											<label class="col"> 
												<span class="input-group-addon">
													<span class="onoffswitch">
														<input type="checkbox" name="DEL_MANAGE_YN" value="" class="onoffswitch-checkbox" id="DEL_MANAGE_YN" >
														<label class="onoffswitch-label" for="DEL_MANAGE_YN"> 
															<span class="onoffswitch-inner" data-swchon-text="YES" data-swchoff-text="NO"></span> 
															<span class="onoffswitch-switch"></span> 
														</label> 
													</span>
												</span>
											</label>	
										</div>
									</section>
									
									<section class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
										<label class="col col-xs-6 col-sm-6 col-md-6 col-lg-6 control-label">게시물 내용 금지어 설정</label>
										<div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 inline-group">
											<label class="col"> 
												<span class="input-group-addon">
													<span class="onoffswitch">
														<input type="checkbox" name="FORBIDDEN_YN" value="" 
																class="onoffswitch-checkbox" id="FORBIDDEN_YN" >
														<label class="onoffswitch-label" for="FORBIDDEN_YN"> 
															<span class="onoffswitch-inner" data-swchon-text="YES" data-swchoff-text="NO"></span> 
															<span class="onoffswitch-switch"></span> 
														</label> 
													</span>
												</span>
											</label>	
										</div>
									</section>
										
 									<section class="col-xs-6 col-sm-6 col-md-6 col-lg-6 forbiddenChk">
										<label class="col col-xs-12 col-sm-12 col-md-12 col-lg-12 control-label input"> 금지어 설정
											<input type="text" id="BT_FORBIDDEN" placeholder="설정할 금지어를 ',' 로 구분하여 작성해주세요" class="inputmargin" name="BT_FORBIDDEN" value="${not empty BoardType.BT_FORBIDDEN ? BoardType.BT_FORBIDDEN : ''}" oninput="cf_maxLengthCheck(this)" maxlength="1000">
										</label>
									</section>
									
									
 									<section class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
										<label class="col col-xs-12 col-sm-12 col-md-12 col-lg-12 control-label input"> 게시물 제목 노출 글자 수
											<input type="number" id="BT_SUBJECT_NUM" class="inputmargin" name="BT_SUBJECT_NUM" value="${not empty BoardType.BT_SUBJECT_NUM ? BoardType.BT_SUBJECT_NUM : '10'}" oninput="cf_maxLengthCheck(this)" max="99" maxlength="2">
										</label>
		
									</section>
									</div>
									
									<div class="row">
									<section class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
											<label class="col col-xs-6 col-sm-6 col-md-6 col-lg-6 control-label">댓글 기능 사용여부</label>
											<div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 inline-group">
												<label class="col"> 
													<span class="input-group-addon">
														<span class="onoffswitch">
															<input type="checkbox" name="COMMENT_YN" value="" 
																	class="onoffswitch-checkbox" id="COMMENT_YN" >
															<label class="onoffswitch-label" for="COMMENT_YN"> 
																<span class="onoffswitch-inner" data-swchon-text="YES" data-swchoff-text="NO"></span> 
																<span class="onoffswitch-switch"></span> 
															</label> 
														</span>
													</span>
												</label>	
											</div>
										</section>
										
										<section class="col-xs-6 col-sm-6 col-md-6 col-lg-6 secretCommentCheck" >
											<label class="col col-xs-6 col-sm-6 col-md-6 col-lg-6 control-label">비밀댓글 기능 사용여부</label>
											<div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 inline-group">
												<label class="col"> 
													<span class="input-group-addon">
														<span class="onoffswitch">
															<input type="checkbox" name="SECRET_COMMENT_YN" value="" 
																	class="onoffswitch-checkbox" id="SECRET_COMMENT_YN" >
															<label class="onoffswitch-label" for="SECRET_COMMENT_YN"> 
																<span class="onoffswitch-inner" data-swchon-text="YES" data-swchoff-text="NO"></span> 
																<span class="onoffswitch-switch"></span> 
															</label> 
														</span>
													</span>
												</label>	
											</div>
										</section>
									</div>
																		
									<div class="row">
										<section class="col col-6 secretCommentCheck">
											<label class="label input">한 페이지당 게시되는 댓글 건 수 <input
												type="number" id="BT_PAGEUNIT_C" name="BT_PAGEUNIT_C" value="${not empty BoardType.BT_PAGEUNIT_C ? BoardType.BT_PAGEUNIT_C : '10'}" class="inputmargin"
												oninput="cf_maxLengthCheck(this)" max="99" maxlength="2" />
											</label>
										</section>
										<section class="col col-6 secretCommentCheck">
											<label class="label input"> 댓글 리스트에 게시되는 페이지 건수 <input
												type="number" id="BT_PAGESIZE_C" name="BT_PAGESIZE_C" value="${not empty BoardType.BT_PAGESIZE_C ? BoardType.BT_PAGESIZE_C : '5'}" class="inputmargin"
												oninput="cf_maxLengthCheck(this)" max="99" maxlength="2" />
											</label>
										</section>
									</div>
										
									<div class="row">
										<section class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
											<label
												class="col col-xs-6 col-sm-6 col-md-6 col-lg-6 control-label">개인정보보안
												사용여부</label>
											<div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 inline-group">
												<label class="col"> <span class="input-group-addon">
														<span class="onoffswitch"> <input type="checkbox"
															name="PERSONAL_YN" value="" class="onoffswitch-checkbox"
															id="PERSONAL_YN"> <label
															class="onoffswitch-label" for="PERSONAL_YN"> <span
																class="onoffswitch-inner" data-swchon-text="YES"
																data-swchoff-text="NO"></span> <span
																class="onoffswitch-switch"></span>
														</label>
													</span>
												</span>
												</label>
										</section>
												
										<section class="col-xs-6 col-sm-6 col-md-6 col-lg-6 personalCheck">
											<div class="col col-xs-12 col-sm-12 col-md-12 col-lg-12">
												<div class="inline-group">
													<div class="row">
														<c:forEach items="${sp:getCodeList('CQ')}" var="model"
															varStatus="status">
															<label class="checkbox"> <input type="checkbox"
																name="BT_PERSONAL" id="BT_PERSONAL${status.count }"
																value="${model.SC_KEYNO}" /> <i></i>${model.SC_CODENM }
															</label>
														</c:forEach>
													</div>
												</div>
											</div>
										</section>
									</div>
									
									
									<div class="row">
										<section class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
											<label class="col col-xs-6 col-sm-6 col-md-6 col-lg-6 control-label">글 등록시 이메일 수신여부</label>
											<div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 inline-group">
												<label class="col"> 
													<span class="input-group-addon">
														<span class="onoffswitch">
															<input type="checkbox" name="EMAIL_YN" value="" 
																	class="onoffswitch-checkbox" id="EMAIL_YN" >
															<label class="onoffswitch-label" for="EMAIL_YN"> 
																<span class="onoffswitch-inner" data-swchon-text="YES" data-swchoff-text="NO"></span> 
																<span class="onoffswitch-switch"></span> 
															</label> 
														</span>
													</span>
												</label>	
											</div>
										</section>
										
										<section class="col-xs-6 col-sm-6 col-md-6 col-lg-6 emailAddress">
											<div class="col col-xs-12 col-sm-12 col-md-12 col-lg-12 inline-group">
												<label class="col-xs-12 col-sm-12 col-md-12 col-lg-12 input inputmargin"> <i
													class="icon-prepend fa fa-edit"></i> <input type="text"
													id="BT_EMAIL_ADDRESS" name="BT_EMAIL_ADDRESS"
													placeholder="수신받을 이메일" maxlength="1000"
													value="${BoardType.BT_EMAIL_ADDRESS }" />
												</label>
											</div>
										</section>
									</div>
									
									<div class="row">
									<section class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
											<label
												class="col col-xs-6 col-sm-6 col-md-6 col-lg-6 control-label">
												카테고리 등록 여부 </label>
											<div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 inline-group">
												<label class="col"> <span class="input-group-addon">
														<span class="onoffswitch"> <input type="checkbox"
															name="CATEGORY_YN" value="" class="onoffswitch-checkbox"
															id="CATEGORY_YN"> <label
															class="onoffswitch-label" for="CATEGORY_YN"> <span
																class="onoffswitch-inner" data-swchon-text="YES"
																data-swchoff-text="NO"></span> <span
																class="onoffswitch-switch "></span>
														</label>
											</div>			
										</section>		
												</label>
												<section
													class="col-xs-6 col-sm-6 col-md-6 col-lg-6 categoryInput">
														<div class="col col-xs-12 col-sm-12 col-md-12 col-lg-12 inline-group">
														<label
															class="col-xs-12 col-sm-12 col-md-12 col-lg-12 input inputmargin">
															<i class="icon-prepend fa fa-edit"></i> <input
															type="text" id="BT_CATEGORY_INPUT"
															name="BT_CATEGORY_INPUT"
															placeholder="입력할 카테고리를 ',' 로 구분하여 작성해주세요" maxlength="100"
															value="${BoardType.BT_CATEGORY_INPUT }" />
														</label>
														</div>
												</section>
									</div>
									
									
									<div class="row">
										<section class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
											<label class="col col-xs-6 col-sm-6 col-md-6 col-lg-6 control-label">썸네일 사용여부</label>
											<div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 inline-group">
												<label class="col"> 
													<span class="input-group-addon">
														<span class="onoffswitch">
															<input type="checkbox" name="THUMBNAIL_YN" value="" 
																	class="onoffswitch-checkbox" id="THUMBNAIL_YN" >
															<label class="onoffswitch-label" for="THUMBNAIL_YN"> 
																<span class="onoffswitch-inner" data-swchon-text="YES" data-swchoff-text="NO"></span> 
																<span class="onoffswitch-switch"></span> 
															</label> 
														</span>
													</span>
												</label>	
											</div>
										</section>
										
										<section class="col-xs-2 col-sm-2 col-md-2 col-lg-2 thumnailResize">
											<label class="col col-xs-12 col-sm-12 col-md-12 col-lg-12 label input">썸네일 리사이즈 weight 값(단위px) <input
												type="number" id="BT_THUMBNAIL_WIDTH" class="inputmargin"
												name="BT_THUMBNAIL_WIDTH" value="${not empty BoardType.BT_THUMBNAIL_WIDTH ? BoardType.BT_THUMBNAIL_WIDTH : '0'}"
												oninput="cf_maxLengthCheck(this)" max="9999" maxlength="4" />
											</label>
										</section>
										<section class="col-xs-2 col-sm-2 col-md-2 col-lg-2 thumnailResize">
											<label class="col col-xs-12 col-sm-12 col-md-12 col-lg-12 label input">썸네일 리사이즈 height 값(단위px) <input
												type="number" id="BT_THUMBNAIL_HEIGHT" class="inputmargin"
												name="BT_THUMBNAIL_HEIGHT" value="${not empty BoardType.BT_THUMBNAIL_HEIGHT ? BoardType.BT_THUMBNAIL_HEIGHT : '0'}"
												oninput="cf_maxLengthCheck(this)" max="9999" maxlength="4" />
											</label>
										</section>
										<section class="col-xs-2 col-sm-2 col-md-2 col-lg-2 thumnailResize">
											<span>썸네일 등록 방법</span>
											<label class="col col-xs-12 col-sm-12 col-md-12 col-lg-12 label input">
											<select id="BT_THUMBNAIL_INSERT" name="BT_THUMBNAIL_INSERT" style="height: 30px;margin-top: 10px;" value="${BoardType.BT_THUMBNAIL_INSERT }">
												<option value="N" ${BoardType.BT_THUMBNAIL_INSERT eq 'N'?'selected':'' }>썸네일 기본등록</option>
												<option value="Y" ${BoardType.BT_THUMBNAIL_INSERT eq 'Y'?'selected':'' }>썸네일 자동등록</option>
											</select>
											</label>
										</section>
									</div>
									
									<div class="row">
										<section class="col-xs-4 col-sm-4 col-md-4 col-lg-4">
											<label class="col col-xs-6 col-sm-6 col-md-6 col-lg-6 control-label">업로드 기능 사용여부</label>
											<div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 inline-group">
												<label class="col"> 
													<span class="input-group-addon">
														<span class="onoffswitch">
															<input type="checkbox" name="UPLOAD_YN" value="" 
																	class="onoffswitch-checkbox" id="UPLOAD_YN" >
															<label class="onoffswitch-label" for="UPLOAD_YN"> 
																<span class="onoffswitch-inner" data-swchon-text="YES" data-swchoff-text="NO"></span> 
																<span class="onoffswitch-switch"></span> 
															</label> 
														</span>
													</span>
												</label>	
											</div>
										</section>

										<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 uploadRow">
											<div class="col col-xs-12 col-sm-12 col-md-12 col-lg-12 form-group">
												<label class="col-xs-12 col-sm-12 col-md-12 col-lg-12 label input">업로드 파일 수 제한 <input
													class="form-control inputmargin" id="BT_FILE_CNT_LIMIT"
													name="BT_FILE_CNT_LIMIT" value="${not empty BoardType.BT_FILE_CNT_LIMIT ? BoardType.BT_FILE_CNT_LIMIT : '0'}" type="number" 
													oninput="cf_maxLengthCheck(this)" max="999" maxlength="3">
												</label>
											</div>
										</div>
										
										<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 uploadRow">
											<div class="col col-xs-12 col-sm-12 col-md-12 col-lg-12 form-group">
												<label class="col-xs-12 col-sm-12 col-md-12 col-lg-12 label input">업로드 파일크기 제한(MB) <input
													class="form-control inputmargin" id="BT_FILE_SIZE_LIMIT"
													name="BT_FILE_SIZE_LIMIT" value="${not empty BoardType.BT_FILE_SIZE_LIMIT ? BoardType.BT_FILE_SIZE_LIMIT : '0'}" type="number"
													oninput="cf_maxLengthCheck(this)" max="999" maxlength="3">
												</label>
											</div>
										</div>
									    <div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 uploadRow">
											<div class="col col-xs-12 col-sm-12 col-md-12 col-lg-12 form-group">
												<label class="label input">업로드 이미지 Weight값(단위 px) <input
													class="form-control inputmargin" id="BT_FILE_IMAGE_WIDTH"
													name="BT_FILE_IMAGE_WIDTH" value="${not empty BoardType.BT_FILE_IMAGE_WIDTH ? BoardType.BT_FILE_IMAGE_WIDTH : '0'}" type="number"
													oninput="cf_maxLengthCheck(this)" max="9999" maxlength="4">
												</label>
											</div>
										</div>
									 	<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 uploadRow">
											<div class="col col-xs-12 col-sm-12 col-md-12 col-lg-12 form-group">
												<label class="label input">업로드 이미지 height값(단위 px) <input
													class="form-control inputmargin" id="BT_FILE_IMAGE_HEIGHT"
													name="BT_FILE_IMAGE_HEIGHT" value="${not empty BoardType.BT_FILE_IMAGE_HEIGHT ? BoardType.BT_FILE_IMAGE_HEIGHT : '0'}" type="number"
													oninput="cf_maxLengthCheck(this)" max="9999" maxlength="4">
												</label>
											</div>
										</div>
									</div>
									<div class="row uploadRow">
										<section class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
											<div class="col col-xs-12 col-sm-12 col-md-12 col-lg-12">
												<label class="col-md-4 control-label">업로드 확장자</label>
												<div class="inline-group">
													<div class="row">
														<label class="radio"> <input type="radio"
															name="FILE_EXT" value="bmp,jpg,png,gif,jpeg,hwp,pdf,zip,xls,xlsx,doc,docx,ppt,pptx" onclick="pf_fileExt('N');" checked> <i></i>통합파일
														</label> 
														<label class="radio"> <input type="radio"
															name="FILE_EXT" value="hwp,txt,pdf,xls,xlsx,doc,docx,ppt,pptx" onclick="pf_fileExt('N');"> <i></i>문서 파일류
														</label> 
														<label class="radio"> <input type="radio"
															name="FILE_EXT" value="bmp,jpg,png,gif,jpeg" onclick="pf_fileExt('N');"> <i></i>이미지 파일류
														</label> 
														<label class="radio"> <input type="radio"
															name="FILE_EXT" value="blank" onclick="pf_fileExt('Y');"> <i></i>직접입력
														</label>
													</div>
												</div>
											</div>
										</section>
										<section class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
											<div class="col col-xs-4 col-sm-4 col-md-4 col-lg-4">
											</div>
											<div class="col col-xs-8 col-sm-8 col-md-8 col-lg-8">
											<input class="form-control" id="FILE_EXT" type="text" placeholder="bmp,jpg,png,gif,jpeg,hwp,pdf,zip,xls,xlsx,doc,docx,ppt,pptx" style="display: none; margin-bottom: 15px;">
											</div>
										</section>
									</div>
									<div class="row uploadRow"> 
										<section class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
											<div class="col col-xs-12 col-sm-12 col-md-12 col-lg-12">
											<label class="col-md-4 control-label">파일 압축 여부</label>
												<div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 inline-group">
													<span class="onoffswitch">
													 <input type="checkbox" name="ZIP_YN" value=""  class="onoffswitch-checkbox" id="ZIP_YN" >
													<label class="onoffswitch-label" for="ZIP_YN"> 
														<span class="onoffswitch-inner" data-swchon-text="YES" data-swchoff-text="NO"></span> 
														<span class="onoffswitch-switch"></span> 
													</label> 
													 </span>											
												</div>
										</div>
										</section>
										<section class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
										<label class="col col-xs-6 col-sm-6 col-md-6 col-lg-6 control-label">첨부파일 미리보기 여부</label>
										<div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 inline-group">
											<label class="col"> 
												<span class="input-group-addon">
													<span class="onoffswitch">
													<input type="checkbox" name="PREVIEW_YN" value="" class="onoffswitch-checkbox" id="PREVIEW_YN" >
															<label class="onoffswitch-label" for="PREVIEW_YN"> 							
																<span class="onoffswitch-inner" data-swchon-text="YES" data-swchoff-text="NO"></span> 
																<span class="onoffswitch-switch"></span> 
															</label> 
														</span>
													</span>
												</label>	
											</div>
										</section>
									</div>
								</fieldset>
								<fieldset>
									<div class="smart-form">
										<div class="row">
											<section class="col col-1">
												<h6>컬럼 등록</h6>
											</section>
											<section class="col col-3">
												<button class="btn btn-sm btn-primary"
													type="button" onclick="pf_AddColumn()">
													<i class="fa fa-floppy-o"></i> 컬럼추가(정렬순서 드래그)
												</button>
											</section>
										</div>
										<div class="row columnTitle">
											<section class="col col-1">순서</section>
											<section class="col col-3">제목</section>
											<section class="col col-1">컬럼타입</section>
											<section class="col col-1">필수입력 여부</section>
											<section class="col col-1">리스트 노출여부</section>
											<section class="col col-3">기타옵션</section>
										</div>
										<fieldset id="AddColumn"></fieldset>
									</div>
								</fieldset>
						
								  <ul class="fixed-btns">
		                            <li>
		                                <a href="javascript:;" onclick="pf_boardTypeAction()" class="btn btn-primary btn-circle btn-lg" title="${actionName }"><i class="fa fa-save"></i></a>
		                            </li>
		                            <c:if test="${actionType eq 'update' }">
			                            <li id="deleteBtn">
			                                <a href="javascript:;" onclick="pf_boardTypeDelete()" class="btn btn-danger btn-circle btn-lg" title="삭제하기"><i class="fa fa-trash-o"></i></a>
			                            </li>
		                            </c:if>
		                            <li>
		                                <a href="javascript:;" onclick="cf_back('/dyAdmin/homepage/board/typeView.do')" class="btn btn-default btn-circle btn-lg" title="목록으로"><i class="fa fa-arrow-left"></i></a>
		                            </li>
		                        </ul>
								
								
								
								
								
							</div>
						</div>
					</div>
				</article>
			</div>
		</section>
	</form:form>
</div>
<div id="optiondialog_append"></div>

<%@ include file="/WEB-INF/jsp/dyAdmin/homepage/board/type/pra_board_type_insertView_script.jsp" %>