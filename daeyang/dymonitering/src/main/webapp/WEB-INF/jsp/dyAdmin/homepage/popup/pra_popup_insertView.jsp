<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"  import="java.util.*" %>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<script type="text/javascript" src="/resources/api/se2/js/HuskyEZCreator.js" charset="utf-8"></script>

<style>
	.btn_margin{margin: 10px;}
	.center_box{width : 80%;}
	.full_box{width: 100%;}
	.contents_box{width: 70%;height: 30%;}
	.img_box{border: 1px solid gray;margin-top : 10px;padding : 10px;width : 70%;height: 30%;}
	.popup_save{position : relative;left : 300px;bottom: 1px;}
	.popup_margin{margin: 8px;}
	.date_margin{margin-top: 10px;margin-bottom: 10px;}
	#MAINDIV, #SUBDIV1, #SUBDIV2, .homePoptype {display:none;}
	#view_background {width:100%;height:193px;border:1px solid #000;background-size:100% 100%;}
	#view_title {margin-top:30px;text-align: center;font-size:44px;font-weight: 500}
	#view_comment {margin-top:20px;text-align: center;font-size:19px;max-width:70%;display: block;margin: 0 auto;letter-spacing: -1px;line-height: 27px;font-weight: 400}
</style>

<section id="widget-grid" class="">
	<!-- row -->
	<div class="row" >
		<!-- NEW WIDGET START -->
		<article class="col-xs-12 col-sm-12 col-md-12 col-lg-6" >
			<!-- Widget ID (each widget will need unique ID)-->
			<form:form id="frm" name="frm" enctype="multipart/form-data" action="/dyAdmin/homepage/popup/insert.do?${_csrf.parameterName}=${_csrf.token}"  method="post">
			<input type="hidden" name="PI_KEYNO" id="PI_KEYNO" value="${popupData.PI_KEYNO }">
			<input type="hidden" name="PI_MN_TYPE" id="PI_MN_TYPE" value="${popupData.PI_MN_TYPE }">
			<input type="hidden" name="PI_FS_KEYNO" id="PI_FS_KEYNO" value="${popupData.PI_FS_KEYNO }">
			<input type="hidden" name="MN_HOMEDIV_C" id="MN_HOMEDIV_C" value="${MN_HOMEDIV_C}">
			<input type="hidden" name="action" id="action" value="${action}">
			<input type="hidden" name="popupSubListKey" id="popupSubListKey" value="">
			<input type="hidden" name="popupSubListType" id="popupSubListType" value="">
			
			<input type="hidden" name="resize" id="resize" value="${resize }">
            <c:if test="${not empty popupData }">
            <input type="hidden" name="PI_TYPE" value="${popupData.PI_TYPE }">
            <input type="hidden" name="PI_DIVISION" value="${popupData.PI_DIVISION }">
            </c:if>
			<div class="jarviswidget jarviswidget-color-darken" id="wid-id-0" data-widget-editbutton="false">
				<header>
					<span class="widget-icon"> <i class="fa fa-table"></i>
					</span>
					<h2>팝업 관리</h2>
				</header>
				
				<div class="widget-body form-horizontal">
				<fieldset>
					<div class="bs-example necessT">
				         <span class="colorR fs12">*표시는 필수 입력 항목입니다.</span>
				     </div>
					<div class="form-group">
						<label class="col-md-2 control-label"><span class="nessSpan">*</span> 팝업 제목</label>
						<div class="col-md-8">
							<input class="form-control checkTrim" name="PI_TITLE" id="PI_TITLE" type="text" value="<c:out value='${popupData.PI_TITLE }' escapeXml='true'/>" maxlength="100">
						</div>
						</div>
							<div class="form-group">
								<label class="col-md-2 control-label"><span
									class="nessSpan">*</span>선택된 메뉴</label>
								<input class="form-control tagsinput" value="" data-role="tagsinput" style="display: none;">
									<div class="col-md-8">
										<div id="selected_menu" class="bootstrap-tagsinput">
										<c:forEach items="${popupSubListData }" var="model" varStatus="status">
											<input class="delete" type="hidden" name="MN_SUB_TITLE" value="${model.MN_KEYNO}" data-menu="${model.MENUKEY}"/>
											<span class="tag label label-info deleteSpan" data-menu="${model.MENUKEY}">
												<div class="b"> ${model.SUB_NAME }</div>
												<span onclick="pf_delete_span('${model.MENUKEY}')" data-role="remove"></span>
											</span>
										</c:forEach>
										</div>
									</div>
							</div>

							<div class="form-group">
								<label class="col-md-2 control-label">팝업 링크</label>
								<div class="col-md-8">
									<input class="form-control" name="PI_LINK" id="PI_LINK"type="text" value="${popupData.PI_LINK }"placeholder="http:// or https:// 으로 시작되어야됩니다." maxlength="200">
								</div>
							</div>
						
					<div class="row">
						<label class="col-md-2 control-label"><span class="nessSpan">*</span> 날짜</label>
						
						<div class="col-md-4 smart-form">
						<label class="radio">
							<input type="radio" id="start_date" name="date_select" value="Y" onclick="pf_date_use('Y')" ${(not empty popupData.PI_STARTDAY) ? 'checked':'' }>
							<i style="margin-top: 7px;"></i>등록</label>
						<label class="radio">
							<input type="radio" id="end_date" name="date_select" value="N" onclick="pf_date_use('N')"${(empty popupData || popupData.PI_ENDDAY eq '기간없음') ? 'checked':'' }>
							<i style="margin-top: 7px;"></i>등록 안함</label>
						</div>
						
						<div class="col-md-2 smart-form" id="date_1">시작날짜
							<label class="input"> <i class="icon-append fa fa-calendar"></i>
								<input type="text" name="PI_STARTDAY" id="PI_STARTDAY" placeholder="시작날짜" data-dateformat="yy-mm-dd" class="datepicker " value="${popupData.PI_STARTDAY }">
							</label>
						</div>
						<div class="col-md-2 smart-form" id="date_2">종료날짜
							<label class="input"> <i class="icon-append fa fa-calendar"></i>
								<input type="text" name="PI_ENDDAY" id="PI_ENDDAY" placeholder="종료날짜" data-dateformat="yy-mm-dd" class="datepicker " value="${popupData.PI_ENDDAY }">
							</label>
						</div>
					</div>
					
					<div class="form-group" style="margin-top: 10px;">
						<label class="col-md-2 control-label">팝업 유형</label>
						<div class="col-md-8">
							<c:if test="${empty popupData }">
							<div class="smart-form">
								<div class="inline-group">
									<label class="radio">
										<input type="radio" name="PI_DIVISION" value="W" onclick="pf_popType('W')"${(empty popupData || popupData.PI_DIVISION eq 'W') ? 'checked':'' }>
										<i style="margin-top: 7px;"></i>레이아웃 형태</label>
									<label class="radio">
										<input type="radio" name="PI_DIVISION" value="B" onclick="pf_popType('B')" ${popupData.PI_DIVISION eq 'B' ? 'checked':'' }>
										<i style="margin-top: 7px;"></i>배너형태</label>
								</div>
							</div>
							</c:if>
							<c:if test="${not empty popupData }">
							<input class="form-control" type="text" value="${popupData.PI_DIVISION eq 'W' ? '레이아웃 형태':'배너형태'  }" readonly="readonly">
							</c:if>
						</div>
					</div>
					
					<div class="form-group homePoptype" style="margin-top: 10px;">
						<label class="col-md-2 control-label">배너형 팝업 유형</label>
						<div class="col-md-4">
							<c:if test="${empty popupData }">
							<div class="smart-form">
								<div class="inline-group">
									<label class="radio">
										<input type="radio" name="PI_TYPE" value="A" ${(empty popupData || popupData.PI_TYPE eq 'A') ? 'checked':'' }>
										<i style="margin-top: 7px;"></i>이미지형</label>
									<label class="radio">
										<input type="radio" name="PI_TYPE" value="B" ${popupData.PI_TYPE eq 'B' ? 'checked':'' }>
										<i style="margin-top: 7px;"></i>텍스트형</label>
								</div>
							</div>
							</c:if>
							<c:if test="${not empty popupData }">
							<input class="form-control" type="text" value="${popupData.PI_TYPE eq 'A' ? '이미지형':'텍스트형'  }" readonly="readonly">
							</c:if>
						</div>
					</div>
				</fieldset>
				
				<legend></legend>
				<fieldset class="popupType popupTypeW"> 
					<div class="form-group">
						<label class="col-md-2 control-label">팝업 내용</label>
						<div class="col-md-10">
						     <textarea style="width:100%;height:400px;min-width:260px;" name="PI_CONTENTS" id="PI_CONTENTS" placeholder="이미지를 삽입하지 않고, 텍스트만 입력할 경우 팝업 내용에 표시됩니다.">${popupData.PI_CONTENTS }</textarea>
						     <div class="note" style="color: red;">(이미지를 삽입하지 않고, 텍스트만 입력할 경우 팝업 내용에 표시됩니다. 이미지를 올릴 경우 텍스트 내용은 포함되지 않습니다.)
				         	</div>
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-2 control-label">팝업 이미지</label>
						<section class="col-md-6 smart-form">
						<div class="input input-file">
							<span class="button">
								<input type="file" id="fileW" name="fileW" onchange="cf_imgCheckAndPreview('fileW')">Browse
							</span>
							<input type="text" placeholder="이미지를 선택하여주세요" readonly="" id="fileW_text" value="${popupData.FS_ORINM }">
						</div>
				   		 <div class="note" style="color: red;">(이미지를 올리지 않을경우 기본 크기는 300 x 300 px 이며, 아래 지정한 크기만큼 팝업창의 크기가 결정됩니다.<br>
				   		                                                                        이미지를 올릴 경우 아래 팝업 크기에 맞게 자동 리사이즈 됩니다.)
				         </div>
				         </section>
				           <section class="col-md-4 smart-form">
				         	<label class="checkbox" style="padding-top:0">
       	                    <input type="checkbox" name="file_resize" value="${popupData.PI_RESIZE_CHECK eq 'N' ? 'N' : 'Y'}"  ${popupData.PI_RESIZE_CHECK eq 'N' ? '' : 'checked'}>
							<i></i>자동 리사이즈 여부</label>
				         </section>
					</div>
					<div class="form-group">
						<label class="col-md-2 control-label"><span class="nessSpan">*</span> 팝업 위치</label>
						<div class="col-md-5">상단
							<input class="form-control" placeholder="200" name="PI_TOP_LOC" id="PI_TOP_LOC" type="number" value="${popupData.PI_TOP_LOC }" oninput="cf_maxLengthCheck(this)" max="99999999999" maxlength="4">
							<div class="note" style="color: red;">
								(200px 이하는 호환성이 맞지 않으니, 200px 이상으로 설정하시기 바랍니다.)
					         </div>
						</div>
						<div class="col-md-5">왼쪽
							<input class="form-control" placeholder="200" name="PI_LEFT_LOC" id="PI_LEFT_LOC" type="number" value="${popupData.PI_LEFT_LOC }" oninput="cf_maxLengthCheck(this)" max="99999999999" maxlength="4">
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-2 control-label"><span class="nessSpan">*</span> 팝업 크기</label>
						<div class="col-md-5">넓이
							<input class="form-control" placeholder="300" name="PI_WIDTH" id="PI_WIDTH" type="number" value="${popupData.PI_WIDTH }" oninput="cf_maxLengthCheck(this)" max="99999999999" maxlength="4">
							<div class="note" style="color: red;">
								(200px 이하는 호환성이 맞지 않으니, 200px 이상으로 설정하시기 바랍니다.)
					         </div>
						</div>
						<div class="col-md-5">높이
							<input class="form-control" placeholder="300" name="PI_HEIGHT" id="PI_HEIGHT" type="number" value="${popupData.PI_HEIGHT }" oninput="cf_maxLengthCheck(this)" max="99999999999" maxlength="4">
						</div>
					</div>
				</fieldset>
				
				<fieldset class="popupType popupTypeA">
					<div class="form-group">
						<label class="col-md-2 control-label">팝업 이미지</label>
						<section class="col-md-4 smart-form">
						<div class="input input-file">
							<span class="button">
								<input type="file" id="fileA" name="fileA" onchange="cf_imgCheckAndPreview('fileA')">Browse
							</span>
							<input type="text" placeholder="이미지를 선택하여주세요" readonly="" name="fileA_text" id="fileA_text" value="${popupData.FS_ORINM }">
						</div>
				   		 <div class="note" style="color: red;">(이미지 사이즈는 1920 x 193 입니다 사이즈가 다를경우 이미지가 깨질수있습니다.)
				         </div>
				         </section>
				         <section class="col-md-4 smart-form">
				         	<label class="checkbox" style="padding-top:0">
							<input type="checkbox" name="file_resize" value="${popupData.PI_RESIZE_CHECK eq 'N' ? 'N' : 'Y'}" ${popupData.PI_RESIZE_CHECK eq 'N' ? '' : 'checked'}>
							<i></i>자동 리사이즈 여부</label>
				         </section>
					</div>
				</fieldset>
				<fieldset class="popupType popupTypeB">
					<div class="form-group">
						<label class="col-md-2 control-label">제목 문구</label>
						<div class="col-md-4">
							<input class="form-control" name="PI_TITLE2" id="PI_TITLE2" type="text" value="${popupData.PI_TITLE2 }" maxlength="50" placeholder="테스트" onkeyup="pf_changeText(this.value,'T')">
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-2 control-label">내용 문구</label>
						<div class="col-md-6">
							<div class="smart-form">
								<label class="textarea"> 										
									<textarea rows="3" class="custom-scroll" name="PI_COMMENT" id="PI_COMMENT" onkeyup="pf_changeText(this.value,'C')" placeholder="모든 국민은 인간으로서의 존엄과 가치를 가지며, 행복을 추구할 권리를 가진다. 국가는 개인이 가지는 불가침의 기본적 인권을 확인하고 이를 보장할 의무를 진다.">${popupData.PI_COMMENT }</textarea> 
								</label>
							</div>
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-2 control-label">배경 이미지</label>
						<div class="col-md-10">
							<div class="smart-form">
								<div class="inline-group">
									<label class="radio">
										<input type="radio" name="PI_BACKGROUND_COLOR" value="N" ${(empty popupData || popupData.PI_BACKGROUND_COLOR eq 'N') ? 'checked':'' }>
										<i style="margin-top: 7px;"></i>없음<br>
									</label>
									<label class="radio">
										<input type="radio" name="PI_BACKGROUND_COLOR" value="1" ${popupData.PI_BACKGROUND_COLOR eq '1' ? 'checked':'' }>
										<i style="margin-top: 7px;"></i>타입1<br>
										<img src="/resources/img/popup/background01.jpg" style="width:100px;">
									</label>
									<label class="radio">
										<input type="radio" name="PI_BACKGROUND_COLOR" value="2" ${popupData.PI_BACKGROUND_COLOR eq '2' ? 'checked':'' }>
										<i style="margin-top: 7px;"></i>타입2<br>
										<img src="/resources/img/popup/background02.jpg" style="width:100px;">
									</label>
									<label class="radio">
										<input type="radio" name="PI_BACKGROUND_COLOR" value="3" ${popupData.PI_BACKGROUND_COLOR eq '3' ? 'checked':'' }>
										<i style="margin-top: 7px;"></i>타입3<br>
										<img src="/resources/img/popup/background03.jpg" style="width:100px;">
									</label>
									<label class="radio">
										<input type="radio" name="PI_BACKGROUND_COLOR" value="4" ${popupData.PI_BACKGROUND_COLOR eq '4' ? 'checked':'' }>
										<i style="margin-top: 7px;"></i>타입4<br>
										<img src="/resources/img/popup/background04.jpg" style="width:100px;">
									</label>
									<label class="radio">
										<input type="radio" name="PI_BACKGROUND_COLOR" value="5" ${popupData.PI_BACKGROUND_COLOR eq '5' ? 'checked':'' }>
										<i style="margin-top: 7px;"></i>타입5<br>
										<img src="/resources/img/popup/background05.jpg" style="width:100px;">
									</label>
								</div>
							</div>
						</div>
					</div>
					
					
					<div class="form-group">
						<label class="col-md-2 control-label">색상</label>
						<div class="col-md-2">제목
							<input class="form-control" name="PI_TITLE_COLOR" id="PI_TITLE_COLOR" type="text" placeholder="#8CC63E" value="${popupData.PI_TITLE_COLOR}" maxlength="7" >
						</div>
						<div class="col-md-2">내용
							<input class="form-control" name="PI_COMMENT_COLOR" id="PI_COMMENT_COLOR" type="text" placeholder="#000" value="${popupData.PI_COMMENT_COLOR}" maxlength="7" >
						</div>
					</div>
					<c:if test="${empty popupData}">
					<div id="view_background">
						<p style="color:#8CC63E" id="view_title">테스트</p>
						<p style="color:#000" id="view_comment">모든 국민은 인간으로서의 존엄과 가치를 가지며, 행복을 추구할 권리를 가진다. 국가는 개인이 가지는 불가침의 기본적 인권을 확인하고 이를 보장할 의무를 진다.</p>
					</div>
					</c:if>
					<c:if test="${not empty popupData}">
						<c:set var="backgroundImg" value=""/>
						<c:if test="${not empty popupData.PI_BACKGROUND_COLOR && popupData.PI_BACKGROUND_COLOR ne 'N' }">
							<c:set var="backgroundImg" value="url('/resources/img/popup/background0${popupData.PI_BACKGROUND_COLOR}.jpg')"/>
						</c:if>
					<div style="background-image:${backgroundImg}"  id="view_background">
						<p style="color:${popupData.PI_TITLE_COLOR}" id="view_title">${popupData.PI_TITLE2 }</p>
						<p style="color:${popupData.PI_COMMENT_COLOR}" id="view_comment">${popupData.PI_COMMENT }</p>
					</div>
					</c:if>
				</fieldset>
				
				<div class="form-actions">
					<div class="row">
						<div class="col-md-12">
							<c:if test="${empty popupData}">
							<button class="btn btn-primary" type="button" onclick="Popup_Save()" id="saveBtn">
								<i class="fa fa-save"></i>
								저장
							</button>
							</c:if>
							<c:if test="${not empty popupData}">
							<button class="btn btn-primary" type="button" onclick="Popup_Update()" id="updateBtn">
								<i class="fa fa-save"></i>
								수정
							</button>
							<button class="btn btn-danger" type="button" onclick="Popup_Delete()">
								<i class="fa fa-save"></i>
								삭제
							</button>
							</c:if>
							<button class="btn btn-default" type="button" onclick="location.href='/dyAdmin/homepage/popup/popup.do'">
								취소
							</button>
						</div>
					</div>
				</div>
				
				</div>
				
			    <!-- end 팝업관련 이미지 및 정보 div -->
			</div>
			</form:form>
			<!-- end widget -->
		</article>
		<!-- WIDGET END -->

		<!-- 메뉴 페이지 -->
		<article class="col-xs-12 col-sm-6 col-md-6 col-lg-6">
			<div class="jarviswidget jarviswidget-color-darken" id="wid-id-1" data-widget-editbutton="false">
				<header>
					<span class="widget-icon"> <i class="fa fa-table"></i>
					</span>
					<h2>메뉴 선택</h2>
				</header>
				<div class="widget-body " >
					<div class="widget-body-toolbar bg-color-white">
						<div class="alert alert-info no-margin fade in">
							<button type="button" class="close" data-dismiss="alert">×</button>
							* 각 항목들에 있는 YES/NO 스위치는 해당 항목 노출 여부 입니다.
						</div> 
					</div>
					<div id="menuListWrap">
					
					</div>
				</div>
			</div>
		</article>
		
	</div>

</section>

<%@ include file="/WEB-INF/jsp/dyAdmin/include/_popup/pra_script_insertView.jsp" %>  
