<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<script>
//리스트로 돌아가기
function pf_back(){
	$("#Form").attr("action", "/dyAdmin/program/group/apply.do");
	$("#Form").submit();
}

</script>

<!-- widget grid -->
<div id="content">
	<section id="widget-grid" >
		<div class="row">
			<article class="col-sm-12 col-md-12 col-lg-12">
				<div class="jarviswidget jarviswidget-color-blueDark" id="wid-id-11" data-widget-colorbutton="false" data-widget-colorbutton="false" data-widget-editbutton="false" data-widget-togglebutton="false" data-widget-deletebutton="false" data-widget-fullscreenbutton="false" data-widget-custombutton="false">
					<header>
						<span class="widget-icon"> <i class="fa fa-lg fa-desktop"></i> </span>
						<h2>신청자 정보 </h2>
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
							<!-- widget body text-->
											
							<div class="tab-content">
								<div class="tab-pane fade in active" id="hr1">
									<h6 class="alert alert-info"> <button type="button" class="close" data-dismiss="alert">×</button>
									단체예약 신청자 정보를 확인합니다.  </h6>
									<div class="widget-body">
										<form:form id="Form" name="Form" method="post">

											<table id="" class="table table-bordered table-striped" style="clear: both">
												<colgroup>
													<col style="width: 35%;">
													<col style="width: 65%;">
												</colgroup>
												<tbody>
													<tr>
														<td>성명</td>
														<td><c:out value="${userInfo.UI_NAME}" escapeXml="true"/></td>
													</tr>
													<tr>
														<td>휴대폰 번호</td>
														<td>${userInfo.UI_PHONE}</td>
													</tr>
													<tr>
														<td>이메일</td>
														<td>${userInfo.UI_EMAIL}</td>
													</tr>
													<tr>
														<td>구분</td>
														<td>기본코스</td>
													</tr>
													<tr>
														<td>투어일시</td>
														<td>${applyData.GP_DATE } / ${applyData.GP_TIME }</td>
													</tr>
													<tr>
														<td>단체명</td>
														<td>${applyData.GP_GROUPNAME }</td>
													</tr>
													<tr>
														<td>참가인원</td>
														<td>${applyData.GP_HEADCOUNT }명</td>
													</tr>
													<tr>
														<td>인솔자</td>
														<td>${applyData.GP_NAME }</td>
													</tr>
													<tr>
														<td>인솔자 연락처</td>
														<td>${applyData.GP_PHONE }</td>
													</tr>
													<tr>
														<td>유모차/휠체어</td>
														<td>${applyData.GP_YUMOCAR } / ${applyData.GP_WHEELCHAIR } 개</td>
													</tr>
													<tr>
														<td>교통편</td>
														<td>
														<c:choose>
															<c:when test="${applyData.GP_TRAFFIC == 'C'}">
																대중교통
															</c:when>
															<c:when test="${applyData.GP_TRAFFIC == 'B'}">
																버스
															</c:when>
															<c:when test="${applyData.GP_TRAFFIC == 'E'}">
																${applyData.GP_TRAFFIC_EXP}
															</c:when>
														</c:choose>
														</td>
													</tr>
													<tr>
														<td>신청일자</td>
														<td>${applyData.GP_REGDT }</td>
													</tr>
												</tbody>
											</table>
										</form:form>
									</div>
							<div class="form-actions">
								<div class="row">
									<div class="col-md-12">
											<button class="btn btn-default" type="button" onclick="pf_back()">
											<i class="fa fa-times"></i> 목록
										</button>
									</div>
								</div>
							</div>
						</div>
					</div>
					</div>
				</div>
			</div>
		</article>
	</div>
	</section>
</div>

