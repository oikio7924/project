<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>
<section id="widget-grid" class="">

	<!-- row -->
	<div class="row">

		<!-- NEW WIDGET START -->
		<article class="col-xs-12 col-sm-12 col-md-12 col-lg-12">

			<!-- Widget ID (each widget will need unique ID)-->
			<div class="jarviswidget jarviswidget-color-darken" id="wid-id-0"
				data-widget-editbutton="false">
				<header>
					<span class="widget-icon"> <i class="fa fa-table"></i>
					</span>
					<h2>회원관리 설정</h2>
				</header>
				<!-- widget div-->
				<div>
					
					<!-- widget edit box -->
					<div class="jarviswidget-editbox">
						<!-- This area used as dropdown edit box -->

					</div>
					<!-- end widget edit box -->

					<!-- widget content -->
					<div class="widget-body">
						<ul id="myTab1" class="nav nav-tabs bordered">
							<c:forEach items="${homeList }" var="model" varStatus="status">
							<li class="${status.count eq 1 ? 'active':'' }">
								<a href="#s${status.count }" data-toggle="tab" aria-expanded="true">${model.MN_NAME }</a>
							</li>
							</c:forEach>
						</ul>
						<form:form id="Form" method="post" action="/dyAdmin/person/setting/insert.do">
						<div id="myTabContent1" class="tab-content padding-10 form-horizontal bv-form">
							<c:forEach items="${homeList }" var="model" varStatus="status">
							<div class="tab-pane fade ${status.count eq 1 ? 'in active':'' }" id="s${status.count }">
								<input type="hidden" name="US_TYPE" value="${model.HM_KEYNO}">
								<legend>${model.MN_NAME }</legend>
								<fieldset>
									<!-- <div class="bs-example necessT">
								         <span class="colorR fs12">*모든항목이 필수 입력 항목입니다.</span>
								    </div> -->
									<div class="form-group">
										<label class="col-md-2 control-label" for="select-1">회원가입 인증여부</label>
										<div class="col-md-8">
											<select class="form-control" name="US_AUTH">
												<option value="N" ${model.US_AUTH eq 'N' ? 'selected':'' }>없음</option>
												<option value="E" ${model.US_AUTH eq 'E' ? 'selected':'' }>이메일</option>
<%-- 												<option value="P" ${model.US_AUTH eq 'P' ? 'selected':'' }>핸드폰</option> --%>
												<option value="A" ${model.US_AUTH eq 'A' ? 'selected':'' }>관리자</option>
											</select> 
										</div>
									</div>
									<div class="form-group">
										<label class="col-md-2 control-label" for="select-1">회원가입 부여권한</label>
										<div class="col-md-8">
											<select class="form-control" name="US_UIA_KEYNO">
												<option value="">없음</option>
												<c:forEach items="${authList }" var="auth">
												<option value="${auth.UIA_KEYNO }" ${model.US_UIA_KEYNO eq auth.UIA_KEYNO ? 'selected':'' }>${auth.UIA_NAME }</option>
												</c:forEach>
											</select> 
										</div>
									</div>
									<div class="form-group">
										<label class="col-md-2 control-label" for="select-1">비밀번호 정규식</label>
										<div class="col-md-8">
											<select class="form-control" name="US_REGEX">
												<option value="">선택하세요.</option>
												<c:forEach items="${PasswordRegex}" var="regex">
												<option value="${regex.SC_KEYNO}" ${model.US_REGEX eq regex.SC_KEYNO ? 'selected':'' }>${regex.SC_CODENM }</option>
												</c:forEach>
											</select> 
										</div>
									</div>
									<div class="form-group">
										<label class="col-md-2 control-label">아이디,별명 금지단어</label>
										<div class="col-md-8">
											<textarea class="form-control" name="US_ID_FILTER" placeholder="입력하세요" rows="4" maxlength="1000">${model.US_ID_FILTER }</textarea>
										</div>
									</div>
									<div class="form-group">
										<label class="col-md-2 control-label">회원가입약관</label>
										<div class="col-md-8">
											<textarea class="form-control" name="US_INFO1" placeholder="입력하세요" rows="6">${model.US_INFO1 }</textarea>
										</div>
									</div>
									<div class="form-group">
										<label class="col-md-2 control-label">개인정보취급방침</label>
										<div class="col-md-8">
											<textarea class="form-control" name="US_INFO2" placeholder="입력하세요" rows="6">${model.US_INFO2 }</textarea>
										</div>
									</div>
								</fieldset>	
							</div>
							</c:forEach>
							<fieldset class="padding-10 text-right"> 
								<button type="submit" onclick="return confirm('저장하시겠습니까?')" class="btn btn-sm btn-primary">	
									<i class="fa fa-floppy-o"></i> 저장
								</button>
							</fieldset>
						</div>
						</form:form>
					</div>
					<!-- end widget content -->

				</div>
				<!-- end widget div -->

			</div>
			<!-- end widget -->
		</article>
		<!-- WIDGET END -->

	</div>

	<!-- end row -->
</section>

