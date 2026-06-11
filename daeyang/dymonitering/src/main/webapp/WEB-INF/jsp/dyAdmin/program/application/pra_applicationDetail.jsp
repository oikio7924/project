<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>


<script>
//리스트로 돌아가기
function pf_back(){
	$("#Form").attr("action", "/dyAdmin/program/application/applicationApply.do");
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
									프로그램 신청자 정보를 확인합니다.  </h6>
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
														<td>프로그램구분</td>
														<td>
															<c:if test="${applicantData.APP_DIVISION eq sp:getData('PROGRAM_APPLY')}">신청 프로그램</c:if>
															<c:if test="${applicantData.APP_DIVISION eq sp:getData('PROGRAM_LECTURE')}">강좌 프로그램</c:if>
														</td>
													</tr>
													<tr>
														<td>프로그램명</td>
														<td>${applicantData.AP_NAME }</td>
													</tr>
													<tr>
														<td>날짜 / 시간</td>
														<c:if test="${applicantData.APP_DIVISION eq sp:getData('PROGRAM_APPLY')}">
															<td>${applicantData.APP_ST_DATE } / (${applicantData.APP_SEQUENCE}) ${applicantData.APP_ST_TIME }</td>
														</c:if>
														<c:if test="${applicantData.APP_DIVISION eq sp:getData('PROGRAM_LECTURE')}">
															<td>${applicantData.APP_ST_DATE } / ${applicantData.APP_ST_TIME }</td>
														</c:if>
													</tr>
													<tr>
														<td>총 예매수</td>
														<td>${applicantData.APP_COUNT }매</td>
													</tr>
													<c:if test="${applicantData.APP_DIVISION eq sp:getData('PROGRAM_LECTURE')}">
														<tr>
															<td>수강자 정보</td>
															<td>${applicantData.APU_NAME }(${applicantData.APU_RELATION }) / ${applicantData.APU_PHONE } / ${applicantData.APU_BIRTH }</td>
														</tr>
													</c:if>
													<c:forEach items="${applicantSaleList }" var="model" varStatus="idx">
													<tr>
														<c:if test="${idx.first }"> <!-- 첫번째에만 넣기 -->
															<td rowspan="${fn:length(applicantSaleList) }">할인종류</td>
															<c:set var="sum" value="0"/>
														</c:if>
															<c:if test="${sum + (model.APD_PRICE*model.APD_CNT) eq 0}"> <!-- 요금종류  * 매수 -->
																<td>무료</td>
															</c:if>
															<c:if test="${sum + (model.APD_PRICE*model.APD_CNT) ne 0}">
																<td>
																	${model.AD_NAME }
																	<c:choose>
																		<c:when test="${model.AD_TYPE == 'A'}">
																		(${model.AD_MONEY }% 할인) 
																		</c:when>
																		<c:when test="${model.AD_TYPE == 'B'}">
																		(${model.AD_MONEY }원 할인) 
																		</c:when>
																	</c:choose>
																	${model.APD_CNT}매
																 - 소계 : <fmt:formatNumber value="${model.APD_PRICE * model.APD_CNT}" type="number"/>원
																 </td>
																<c:set var="sum" value="${sum + (model.APD_PRICE*model.APD_CNT)}"/>
															</c:if>
													</tr>
													</c:forEach>
													
													</tr>
													<tr>
														<td>총 결제 금액</td>
														<td><fmt:formatNumber value="${sum }" type="number"/>원</td>
													</tr>
													<tr>
														<td>상태</td>
														<td>
															<c:choose>
																<c:when test="${applicantData.APP_STATUS == sp:getData('APPLY_WAITING')}">
																	<font color="blue">결제대기</font>
																</c:when>
																<c:when test="${applicantData.APP_STATUS == sp:getData('APPLY_COMPLETE')}">
																	<font color="blue">신청완료</font>
																</c:when>
																<c:when test="${applicantData.APP_STATUS == sp:getData('APPLY_CANCEL')}">
																	<font color="red">신청취소</font>
																</c:when>
																<c:when test="${applicantData.APP_STATUS == sp:getData('APPLY_RESERVE')}">
																	<font color="green">신청 대기중</font>
																</c:when>
																<c:when test="${applicantData.APP_STATUS == sp:getData('APPLY_EXPIRED')}">
																	<font color="red">결제만료</font>
																</c:when>
																<c:when test="${applicantData.APP_STATUS == sp:getData('APPLY_PREVIEW')}">
																	<font>관람완료</font>
																</c:when>
															</c:choose>
														</td>
													</tr>
													<tr>
														<td>신청일자</td>
														<td>${applicantData.APP_REGDT }</td>
													</tr>
													<tr>
														<td>예약좌석</td>
														<td>${applicantData.SEATNAME }</td>
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

