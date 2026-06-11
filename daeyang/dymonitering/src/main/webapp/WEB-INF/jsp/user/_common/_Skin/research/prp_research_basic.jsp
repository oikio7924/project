<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<link href="/resources/common/css/page_research.css" type="text/css" rel="stylesheet">

	<article class="sub-survey-wrap">
         <div class="sub-survey-box">
             <div class="detail-info-b clearfix">
                 <div class="letter-b left">
                     <span class="icon icon1"></span>
                     <span class="txt">담당부서 : ${MANAGER_DEP}</span>
                 </div>
                 <div class="letter-b left">
                     <span class="icon icon2"></span>
                     <span class="txt">담당자 : ${MANAGER }</span>
                 </div>
                 <div class="letter-b left">
                     <span class="icon icon3"></span>
                     <span class="txt">연락처 : ${MANAGER_TEL}</span>
                 </div>
                 <div class="letter-b right">
                     <span class="icon icon4"></span>
                     <span class="txt">최종수정일 : ${currentMenu.MN_MODDT == null || empty currentMenu.MN_MODDT ? fn:substring(currentMenu.MN_REGDT,0,10) : fn:substring(currentMenu.MN_MODDT,0,10) }</span>
                 </div>
             </div>

				<c:if test="${not empty currentMenu.MN_QR_KEYNO}">
					 <div class="qrbox">
	                    <p class="qrImgBox">
	                        <img alt="qr-code" src="/common/file.do?file=${currentMenu.IMG_PATH }"/>
	                    </p>
	                    <p class="inforMation">
				                         QR Code 이미지를 스마트폰에 인식시키면 자동으로 이 페이지로 연결됩니다.<br>
				                        이 QR Code는 페이지의 정보를 담고 있습니다.
	                    </p>
	                </div>
	                <div class="clear"></div>
				</c:if>
             <div class="survey-content-box">
                 <div class="icon-box">
                     <img src="/resources/img/icon/survey/icon_bottom_survey_02.png" alt="아이콘">
                 </div>
                 <div class="content-b">
                     <h3>이 페이지에서 제공하는 정보에 만족하시나요?</h3>
                     <div class="radio-box">
                         <label><input type="radio" name="TPS_SCORE"  value="5" checked="true"> <span>매우만족</span></label>
                         <label><input type="radio" name="TPS_SCORE"  value="4"> <span>만족</span></label>
                         <label><input type="radio" name="TPS_SCORE"  value="3"> <span>보통</span></label>
                         <label><input type="radio" name="TPS_SCORE"  value="2"> <span>불만족</span></label>
                         <label><input type="radio" name="TPS_SCORE"  value="1"> <span>매우불만족</span></label>
                     </div>
                     <div class="input-box">
                         <div class="text-b">
                             <textarea class="textAreaHealing" name="TPS_COMMENT" maxlength="2000"></textarea>
                         </div>
                         <div class="btn-b">
                             <button type="button" onclick="pf_insert()">등록하기</button>
                         </div>
                     </div>
                     <div class="input-box">
                         <div class="divRight">
                             <button type="button" class="btnSurResult" onclick="pf_PointTow('researchRusult', 'R'); return false;">결과보기</button>
                         </div>
                     </div>
                 </div>
             </div>
         </div>
	 </article>
	 
	 
	 
	 
	 <div id="researchRusult" class="listBlock">
	  	<h4>만족도조사결과 <span id="Participants">(참여인원:0명)</span></h4>
	    <p class="pointBtn"><a class="ALink" href="#pointView" onclick="pf_PointTow('pointView', 'S'); return false;">요약설명보기</a></p>
	    <div id="pointView" class="listNone">
	    	<p class="Pagepoint">만족도 조사에 참여해 주셔서 감사합니다.<br>
	        현재 페이지의 만족도 투표는 <strong id="Participants2">총 0명</strong>이 참여하였으며, 현재 "<strong class="scoreName">매우만족</strong>"이 <strong class="scoreCnt">0표</strong>로 가장 많은 표를 받았습니다.<br>
	        투표에 참여한 시민들은 현 페이지에 대해 "<strong class="scoreName">매우만족</strong>" 하고 있습니다.</p>
	        <p class="btn_close02"><a class="ALink" href="#pointView" onclick="pf_PointTow('pointView', 'C'); return false;">닫기</a></p>
	    </div>
	    <div class="hGraph">
	    
	    <ul class="graph">
	    	<li>
	        	<div class="bar_list">
	            	<dl>
	                	<dt class="gTerm">매우만족</dt>
	                    <dd><span id="value05" class="gBar" style="width:0%;">0표</span></dd>
	                </dl>
	            </div>
	        </li>
	    	<li>
	        	<div class="bar_list">
	            	<dl>
	                	<dt class="gTerm">만족</dt>
	                    <dd><span id="value04" class="gBar" style="width:0%;">0표</span></dd>
	                </dl>
	            </div>
	        </li>
	    	<li>
	        	<div class="bar_list">
	            	<dl>
	                	<dt class="gTerm">보통</dt>
	                    <dd><span id="value03" class="gBar" style="width:0%;">0표</span></dd>
	                </dl>
	            </div>
	        </li>
	    	<li>
	        	<div class="bar_list">
	            	<dl>
	                	<dt class="gTerm">불만족</dt>
	                    <dd><span id="value02" class="gBar" style="width:0%;">0표</span></dd>
	                </dl>
	            </div>
	        </li>
	    	<li>
	        	<div class="bar_list">
	            	<dl>
	                	<dt class="gTerm">매우불만족</dt>
	                    <dd><span id="value01" class="gBar" style="width:0%;">0표</span></dd>
	                </dl>
	            </div>
	        </li>
	    </ul>
	    </div>
	    <p class="btn_close"><a class="ALink" href="#researchRusult" onclick="pf_PointTow('researchRusult', 'C'); return false;"><img alt="닫기" src="/resources/img/calendar/btn_close_gray.png" class="closeImg"/></a></p>
	  </div>
