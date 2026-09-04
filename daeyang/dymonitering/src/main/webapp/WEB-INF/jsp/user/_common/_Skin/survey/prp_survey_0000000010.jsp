
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<h2>${SmDTO.SM_TITLE }</h2>
	<br>

	<p>설문기간 : ${SmDTO.SM_STARTDT } ~ ${SmDTO.SM_ENDDT }</p><br>
	<c:if test="${SmDTO.SM_IDYN eq 'Y' }">
	<p>작성자 : ${userInfo.UI_ID }</p>
	</c:if>
	<p>설문 설명 :
	<pre style="padding-left:20px;">${SmDTO.SM_EXP }</pre>
	</p>

	<div class="sq_main">
		<c:forEach items="${sq_list }" var="sq" varStatus="sqc">
			<div class="sq_row">
				<input type="hidden" name="SQ_KEYNO" value="${sq.SQ_KEYNO }">
				<input type="hidden" name="SQ_ST_TYPE" id="SQ_ST_TYPE_${sqc.count }" value="${sq.SQ_ST_TYPE }">
				<input type="hidden" name="SQ_OPTION_DATA" id="SQ_OPTION_DATA_${sqc.count }" >
				<input type="hidden" name="SQ_OPTION_DATA2" id="SQ_OPTION_DATA2_${sqc.count }" >
				<input type="hidden" name="SQ_OPTION_RADIO_DATA" id="SQ_OPTION_RADIO_DATA_${sqc.count }" value="" >

				<span>${sq.SQ_KG_TEXT }</span><br><br>

				<span>질문 : ${sq.SQ_QUESTION }</span><br><br>

				<span>질문 설명 : ${sq.SQ_COMMENT }</span><br><br>
				
				<div class="sqo_main">
					<c:if test="${sq.SQ_ST_TYPE eq 'T' }">
						<div class="sqo_row">
							<textarea name="SQ_DATA" id="SQ_DATA_${sqc.count }" onchange="pf_dataInput('${sqc.count }')"  rows="3"></textarea>
						</div>
					</c:if>
					<c:if test="${sq.SQ_ST_TYPE eq 'R' || sq.SQ_ST_TYPE eq 'C' }">
					    <c:if test="${sq.SQ_ST_TYPE eq 'C' }">
					        <span>해당 설문은 <span class="SQ_CK_MIN${sqc.count }">${sq.SQ_CK_MIN }</span> ~
					        <span class="SQ_CK_MAX${sqc.count }">${sq.SQ_CK_MAX }</span>개의 체크박스를 선택하실 수 있습니다.</span>
					    </c:if>
					    <div class="inline-group">
					        <c:forEach items="${sqo_list }" var="sqo" varStatus="sqoc">
					            <c:if test="${sq.SQ_KEYNO eq sqo.SQO_SQ_KEYNO }">
					                <div class="sqo_row">
					                <c:if test="${sq.SQ_ST_TYPE eq 'R' }">
					                    <label class="radio">
					                        <input type="radio" name="SQO_OPTION_${sqc.count }" id="SQO_OPTION_${sqc.count }:${sqoc.count}"
					                         value="${sqo.SQO_KEYNO }:${sqo.SQO_VALUE}" onclick="pf_optionRadioClick('${sqc.count }','${sqo.SQO_KEYNO }','${sqo.SQO_VALUE}')">
								    </c:if>
								    <c:if test="${sq.SQ_ST_TYPE eq 'C' }">
										<label class="checkbox">
											<input type="checkbox" name="SQO_OPTION_${sqc.count }" id="SQO_OPTION_${sqc.count }:${sqoc.count}"
											value="${sqo.SQO_KEYNO }:${sqo.SQO_VALUE}" onclick="pf_optionCheckBoxClick('${sqc.count }','${sqo.SQO_KEYNO }','${sqo.SQO_VALUE}')">
									</c:if>
					                        <i></i>${sqo.SQO_OPTION }
					                    </label>
					                </div>
					            </c:if>
					        </c:forEach>
					        <br />
					        <c:if test="${sq.SQ_ST_TYPE eq 'R' && sq.SQ_ORDER_TYPE eq 'Y' }">
					            <span>기타의견을 입력하실 수 있습니다.</span>
					            <div class="sqo_row count_${sqc.count }" id="order_opinions">
					                <textarea name="SQ_DATA" id="SQ_DATA_${sqc.count }" onchange="pf_RadiodataInput('${sqc.count }')" rows="3"></textarea>
					            </div>
							</c:if>
					    </div>
				</c:if>
				</div>
			</div>
		</c:forEach>
	</div>

	<button class="btn btn-sm btn-primary" id="Board_Edit"	type="button" onclick="pf_surveyInsert()">
		 설문 결과 전송
	</button>
	<button class="btn btn-sm btn-default" id="Board_Delete" type="button" onclick="cf_back('/dy/function/servey.do')">
		 설문 작성 취소
	</button>
		