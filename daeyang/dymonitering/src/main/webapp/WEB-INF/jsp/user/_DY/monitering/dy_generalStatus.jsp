<%@ page language="java" contentType="text/javascript ; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>



<link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.3/css/select2.min.css" rel="stylesheet"/> 




<form:form action="/dy/moniter/general.do" method="POST" id="Form">

<input type="hidden" name="keyno" value="${DPP_KEYNO }" id="keyno">


<!-- COMTAINER -->


<div id="container" class="heightFix2" style="padding-top: 10px;">
    
    <div class="flex_wrapper" style="margin-bottom: 0; padding-bottom: 0;">
        
        <section class="one_row left2" style="margin-bottom: 0;">
            <article class="artBoard top2">
                <h2 class="circle">발전소</h2>
						
                <p class="power_tit" style="float: left;">[${ob.DPP_AREA }] ${ob.DPP_NAME }</p>
                <c:if test="${DPP_KEYNO eq '23' }">
<!--                 	<a id="more" href="javascript:;" style="padding: 0px 0px 0px 10px;font-size: 15px; float: right;" onclick="moreTable();">예측량 확인</a> -->
               	</c:if>

				<div class="power_select">
                    <select class="select_nor select2 sm3 w100" id="DPP_KEYNO" name="DPP_KEYNO" value="${DPP_KEYNO }" onchange="DPPDataAjax(this.value);">
                        <c:forEach items="${list }" var="list">
                        	<option value="${list.DPP_KEYNO }" ${list.DPP_KEYNO eq DPP_KEYNO ? 'selected' : '' } >${list.DPP_NAME }</option>
                        </c:forEach>
                    </select>
                </div>
				
                <div class="power_select">
<%--                     <select class="select_nor sm3 w100" id="InverterNum" name="Invert --%>
<%--                     erNum" value="${InverterNum }" onchange="ajaxData();" > --%>
<%--                         <c:forEach varStatus="status" begin="1" end="${ob.DPP_INVER_COUNT }"> --%>
<%--                         	<option value="인버터 ${status.count }호">인버터 ${status.count }호</option> --%>
<%--                         </c:forEach> --%>
                   <%-- </select> --%>
                </div>
                
                <c:if test="${DPP_KEYNO eq '2' }">
                	<button type="button" style="height: 36px;background-color: #3061ad;color: #fff;border-radius: 30px;font-size: 14px;float: right;width: 30%;" onclick="showCCTV('${ob.DPP_IP}');">현장확인</button>
                </c:if>
                
                <h2 class="location">발전소 현장정보</h2>
				
                <div class="power_preview">
                	<c:if test="${DPP_KEYNO eq '63' }">
                		<table class="tbl_normal fixed">
                            <colgroup>
                                <col width="30">
                                <!-- <col width="21%">
                                <col width="21%"> -->
                                <col width="30%">
                                <col width="30%">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>날짜</th>
                                    <!-- <th>Phase A Watts</th>
                                    <th>Phase B Watts</th> -->
                                    <th>소비 전력(kWh)</th>
                                    <th>잉여 전력(kWh)</th>
                                </tr>
                            </thead>
                            <tbody>
                            		<c:forEach items="${pospump2 }" var="pos">
                            			<tr>
	                            			<td>${pos.kpd_Date }</td>
	                            			<%-- <td><fmt:formatNumber value="${pos.kpd_data1/1000000}" pattern="0.0000"/></td>
	                            			<td><fmt:formatNumber value="${pos.kpd_data2/1000000}" pattern="0.0000"/></td> --%>
	    	                                <td><fmt:formatNumber value="${pos.a4}" pattern="0.000"/></td>
	        	                            <td><fmt:formatNumber value="${pos.a5}" pattern="0.000"/></td>
		                                </tr>
                            		</c:forEach>
                            		
                            </tbody>
                        </table>
                	</c:if>
                	<c:if test="${DPP_KEYNO ne '63' }">
                		<div class="imgs" id="map" style="height: 200px"></div> <!-- 카카오맵 -->
                	</c:if>
                </div>

                <p class="power_addr">${fn:substringAfter(ob.DPP_LOCATION,'//')} </p>

                <ul class="power_info">
                    <li>
                        <p class="lb battery">발전소 설비용량</p>
                        <p class="rb"><span class="num">${ob.DPP_VOLUM }</span>kW</p>
                    </li>
                    
                    <c:choose>
               			<c:when test="${ob.DDM_STATUS eq '정상' }">
               				<c:set var="statusT" value="green"/>
               			</c:when>
               			<c:when test="${ob.DDM_STATUS eq '장애' }">
               				<c:set var="statusT" value="red"/>
               			</c:when>
               			<c:when test="${ob.DDM_STATUS eq '연결 끊김' }">
               				<c:set var="statusT" value="black"/>
               			</c:when>
               			<c:when test="${ob.DPP_STATUS eq 'Y' }">
               				<c:set var="statusT" value="gray"/>
               			</c:when>
               			<c:otherwise>
               				<c:set var="statusT" value="gray"/>
               			</c:otherwise>
               		</c:choose>
                    <li>
                        <p class="lb invert">인버터상태</p>
                        <p class="rb"><span class="check_c ${statusT }"></span> ${empty ob.DDM_STATUS? '미개통':ob.DDM_STATUS }</p>
                    </li>
                    <li>
                        <p class="lb time">발전소등록 날짜 / 시간</p>
                        <p class="rb w100">
                            <span class="gb_txt">${ob.DPP_DATE }</span>
                        </p>
                    </li>
                    <li>
                        <p class="lb time">최종수신 날짜 / 시간</p>
                        <p class="rb w100">
                            <span class="gb_txt" id="Conndate">${empty ob.DDM_DATE? '현재 통신 없음': ob.DDM_DATE }</span>
                        </p>
                    </li>
                </ul>

                <div class="power_btns">
                    <button type="button" class="btn_calcu" onclick="$('.base_pop_wrapper').addClass('on')">수익계산</button>
                </div>

            </article>  
        </section>


        <!-- 수익계산 팝업 - 클래스 on 추가시 나타남 -->
        <section class="base_pop_wrapper">
            <div class="pop_base_calculation">
                <button type="button" class="btn_close" title="닫기"  onclick="$('.base_pop_wrapper').removeClass('on')"><i class="xi-close"></i></button>

                <div class="warning_box">
                    SMP 또는 REC 중 한가지만 입력하고 계산이 가능합니다.<br>
                    SMP,  REC 둘다 입력하고 계산하면 예상수익을 볼 수 있습니다.
                </div>

                <div class="form_box">
                    <dl class="bo">
                        <dt>
                            <b>SMP</b>
                            <label for="smp1">SMP 단가</label>
                        </dt>
                        <dd>
                            <p class="money_inp">
                                <input type="text" class="in_txt2" id="smp1">
                                <span>원</span>
                            </p>
                        </dd>
                    </dl>
                    <dl class="bo">
                        <dt>
                            <b>REC</b>
                            <label for="rec1">REC 단가</label>
                        </dt>
                        <dd>
                            <p class="money_inp">
                                <input type="text" class="in_txt2" id="rec1">
                                <span>원</span>
                            </p>
                        </dd>
                    </dl>
                    <dl>
                        <dt><label for="set">설치유형</label></dt>
                        <dd>
                            <select id="set" class="select_in02" onchange="plusValue(this.value)">
                                <option value="a">일반부지</option>
                                <option value="b">축사</option>
                            </select>
                        </dd>
                    </dl>
                    <dl>
                        <dt>가중치</dt>
                        <dd id="plus">${(ob.DPP_INVER_COUNT + 0.2)/ob.DPP_INVER_COUNT}</dd>
                    </dl>
                </div>

                <div class="btn_mid">
                    <button type="button" class="btn_round_1 blue" onclick="calculation();">계산</button>
                    <button type="button" class="btn_round_1 line" onclick="clean();">초기화</button>
                </div>

                <!-- 계산 버튼 누를시 나타남 - 클래스 on 추가시 나타남 -->
                <div class="calculation_result">
                    <ul class="list">
                        <li>
                            <span class="state black">전일</span>
                            <ul class="mid">
                                <li>
                                    <span class="tit">발전량</span>
                                    <span class="number" ><b><fmt:formatNumber value="${ob.DDM_P_DATA}" pattern="0.00"/></b>kWh</span>
                                </li>
                            </ul>
                            <div class="result">
                                <span class="blue">예상수익</span>
                                <div class="re" id="pre_benefit">0원</div>
                            </div>
                        </li>
						<li>
                            <span class="state red">전월</span>
                            <ul class="mid">
                                <li>
                                    <span class="tit">발전량</span>
                                    <span class="number"><b><fmt:formatNumber value="${Prmonth}" pattern="0.00"/></b>kWh</span>
                                </li>
                            </ul>
                            <div class="result">
                                <span class="blue">예상수익</span>
                                <div class="re" id="Pm_benefit">0원</div>
                            </div>
                        </li>
                        <li>
                            <span class="state green">금일</span>
                            <ul class="mid">
                                <li>
                                    <span class="tit">발전량</span>
                                    <span class="number"><b><fmt:formatNumber value="${ob.DDM_D_DATA}" pattern="0.00"/></b>kWh</span>
                                </li>
                            </ul>
                            <div class="result">
                                <span class="blue">예상수익</span>
                                <div class="re" id="benefit">0원</div>
                            </div>
                        </li>
                        <li>
                            <span class="state orange">금년</span>
                            <ul class="mid">
                                <li>
                                    <span class="tit">발전량</span>
                                    <span class="number"><b><fmt:formatNumber value="${year1}" pattern="0.00"/></b>kWh</span>
                                </li>
                            </ul>
                            <div class="result">
                                <span class="blue">예상수익</span>
                                <div class="re" id="y_benefit">0원</div>
                            </div>
                        </li>
                        <li>
                            <span class="state gray">누적</span>
                            <ul class="mid">
                                <li>
                                    <span class="tit">발전량</span>
                                    <span class="number"><b><fmt:formatNumber value="${ob.DDM_CUL_DATA }" pattern="0.00"/></b>kWh</span>
                                </li>
                            </ul>
                            <div class="result">
                                <span class="blue">예상수익</span>
                                <div class="re" id="n_benefit">0원</div>
                            </div>
                        </li>
                    </ul>
                </div>
            </div>
        </section>
        <!-- // 수익계산 팝업 -->


        <section class="one_row right3" style="margin-bottom: 0;">

            <div class="col n01">
				
                
                <article class="artBoard long">
                     <%-- 금일 발전량/현재 발전량 --%>
                     <h2 class="circle mgSm">금일 발전량 | ${ob.DPP_NAME }</h2>
                     
                     <div style="padding: 10px 20px;">
                         <select class="select_nor select2 w100" id="InverterNum" name="InverterNum" value="${InverterNum }" onchange="ajaxData();" style="width: 100%;">
                             <c:forEach varStatus="status" begin="1" end="${ob.DPP_INVER_COUNT }">
                             	<option value="인버터 ${status.count }호">인버터 ${status.count }호</option>
                             </c:forEach>
                         </select>
                     </div>
                    
                     <div class="graph_b_gaue">
                         <div id="gauge_1" style="display: inline-block; width: 300px; height: 300px;"></div>
                         <div class="guage_txt" style="padding-bottom: 0px;">
                             <span>총 금일 발전량(%)</span>
                             <p><b id="AllPower">0.0kWh / 0h</b></p>
                             <p style="float: right;margin-right: 35px;color: gray;font-size: 11px;">*	발전량은 8시간 기준 100% 입니다.</p>
                         </div>
                     </div>
                     
                     <h2 class="circle mgSm">현재 발전량</h2>
                     
                     <div class="graph_b_gaue">
                         <div id="gauge_2" style="display: inline-block; width: 300px; height: 300px;"></div>
                         <div class="guage_txt">
                             <span>발전 전력</span>
                             <p><b id="Active">0.0</b></p>
                         </div>
                     </div>
                 </article>  
            </div>

            <div class="col n02">
                <article class="artBoard long">
                    <h2 class="circle">인버터별 상태</h2>

                    <span class="state_b pos">
                    	${ob.DPP_INVER }
                    </span>
					
					<c:if test="${ob.DPP_KEYNO eq '74'}">
						<c:set var="css_type" value="mr"/>
					</c:if>
					<c:if test="${ob.DPP_KEYNO ne '74'}">
						<c:set var="css_type" value=""/>
					</c:if>
                    <div class="table_wrapper ${css_type }" style="height: 600px; overflow-y: auto;">
                        <table class="tbl_normal fixed">
                            <colgroup>
                                <col width="55%">
                                <col width="25%">
                                <col width="20%">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>인버터명</th>
                                    <th>AC전력(kW)</th>
                                    <th>발전상태</th>
                                </tr>
                            </thead>
                            <tbody>
                            	<c:forEach items="${invertDataList }" var="model" varStatus="status">
<%--                             	<c:forEach begin="0" end="${ob.DPP_INVER_COUNT-1 }" var="cnt"> --%>
                            		<c:choose>
                            			<c:when test="${model.Work_Mode eq 'Normal'}">
                            				<c:set var="type" value="green"/>
                            			</c:when>
                            			<c:when test="${model.Work_Mode eq 'Fault'}">
                            				<c:set var="type" value="red"/>
                            			</c:when>
                            			<c:when test="${model.Work_Mode eq 'Wait'}">
                            				<c:set var="type" value="blue"/>
                            			</c:when>
                            			<c:when test="${model.Work_Mode eq 'noData'}">
                            				<c:set var="type" value="gray"/>
                            			</c:when>
                            			<c:otherwise>
                            				<c:set var="type" value="black"/>
                            			</c:otherwise>
                            		</c:choose>
                            		<tr>
    	                                <td>
    	                                	[${ob.DPP_AREA }]
    	                                	<c:choose>
    	                                		<c:when test="${ob.DPP_KEYNO eq '49' }">
	    	                                		<c:if test="${status.index == 0}">
	    	                                			윤서 태양광 발전소 1호 | 인버터 1
	    	                                		</c:if>
	    	                                		<c:if test="${status.index == 1}">
	    	                                			윤서 태양광 발전소 2호 | 인버터 1
	    	                                		</c:if>
    	                                		</c:when>
    	                                		<c:when test="${ob.DPP_KEYNO eq '51' }">
	    	                                		<c:if test="${status.index == 0}">
	    	                                			푸른 태양광 발전소| 인버터 1
	    	                                		</c:if>
	    	                                		<c:if test="${status.index == 1}">
	    	                                			하늘 태양광 발전소| 인버터 1
	    	                                		</c:if>
    	                                		</c:when>
    	                                		<c:when test="${ob.DPP_KEYNO eq '52' }">
	    	                                		<c:if test="${status.index == 0}">
	    	                                			은영 태양광 발전소 1호 | 인버터 1
	    	                                		</c:if>
	    	                                		<c:if test="${status.index == 1}">
	    	                                			은영 태양광 발전소 2호 | 인버터 1
	    	                                		</c:if>
    	                                		</c:when>
    	                                		<c:when test="${ob.DPP_KEYNO eq '54' }">
	    	                                		<c:if test="${status.index == 0}">
	    	                                			순옥 2호 태양광 발전소| 인버터 1
	    	                                		</c:if>
	    	                                		<c:if test="${status.index == 1}">
	    	                                			순옥 2호 태양광 발전소| 인버터 2
	    	                                		</c:if>
	    	                                		<c:if test="${status.index == 2}">
	    	                                			순옥 3호 태양광 발전소| 인버터 1
	    	                                		</c:if>
    	                                		</c:when>
    	                                		<c:when test="${ob.DPP_KEYNO eq '56' }">
	    	                                		<c:if test="${status.index == 0}">
	    	                                			하랑 태양광 2호| 인버터 1
	    	                                		</c:if>
	    	                                		<c:if test="${status.index == 1}">
	    	                                			하랑 태양광 3호| 인버터 1
	    	                                		</c:if>
    	                                		</c:when>
 		                               		<c:when test="${ob.DPP_KEYNO eq '93' }">
	    	                                		<c:if test="${status.index == 0}">
	    	                                			한빛 태양광 발전소 1호 | 인버터 1
	    	                                		</c:if>
	    	                                		<c:if test="${status.index == 1}">
	    	                                			한빛 태양광 발전소 2호 | 인버터 1
	    	                                		</c:if>
	    	                                		<c:if test="${status.index == 2}">
	    	                                			한밭 태양광 발전소 | 인버터 1
	    	                                		</c:if>
	    	                                		<c:if test="${status.index == 3}">
	    	                                			한밭 태양광 발전소 | 인버터 2
	    	                                		</c:if>
	    	                                		<c:if test="${status.index == 4}">
	    	                                			한밭 태양광 발전소 | 인버터 3
	    	                                		</c:if>
	    	                                		<c:if test="${status.index == 5}">
	    	                                			한밭 태양광 발전소 | 인버터 4
	    	                                		</c:if>

    	                                		</c:when>
 		                               		<c:when test="${ob.DPP_KEYNO eq '96' }">
	    	                                		<c:if test="${status.index == 0}">
	    	                                			하민 태양광 발전소| 인버터 1
	    	                                		</c:if>
	    	                                		<c:if test="${status.index == 1}">
	    	                                			한결 태양광 발전소| 인버터 1
	    	                                		</c:if>
    	                                		</c:when>
 		                               		<c:when test="${ob.DPP_KEYNO eq '97' }">
	    	                                		<c:if test="${status.index == 0}">
	    	                                			주원 태양광 발전소 1호 | 인버터 1
	    	                                		</c:if>
	    	                                		<c:if test="${status.index == 1}">
	    	                                			주원 태양광 발전소 2호 | 인버터 1
	    	                                		</c:if>
	    	                                		<c:if test="${status.index == 2}">
	    	                                			주원 태양광 발전소 3호 | 인버터 1
	    	                                		</c:if>
    	                                		</c:when>
 		                               		<c:when test="${ob.DPP_KEYNO eq '98' }">
	    	                                		<c:if test="${status.index == 0}">
	    	                                			아라 태양광 발전소 1호 | 인버터 1
	    	                                		</c:if>
	    	                                		<c:if test="${status.index == 1}">
	    	                                			아라 태양광 발전소 1호 | 인버터 2
	    	                                		</c:if>
	    	                                		<c:if test="${status.index == 2}">
	    	                                			아라 태양광 발전소 1호 | 인버터 3
	    	                                		</c:if>
	    	                                		<c:if test="${status.index == 3}">
	    	                                			아라 태양광 발전소 1호 | 인버터 4
	    	                                		</c:if>
	    	                                		<c:if test="${status.index == 4}">
	    	                                			아라 태양광 발전소 2호 | 인버터 1
	    	                                		</c:if>
    	                                		</c:when>
 		                               		<c:when test="${ob.DPP_KEYNO eq '80' }">
	    	                                		<c:if test="${status.index == 0}">
	    	                                			종배 태양광 발전소 1호 | 인버터 1
	    	                                		</c:if>
	    	                                		<c:if test="${status.index == 1}">
	    	                                			종배 태양광 발전소 2호 | 인버터 1
	    	                                		</c:if>
	    	                                		<c:if test="${status.index == 2}">
	    	                                			종배 태양광 발전소 3호 | 인버터 1
	    	                                		</c:if>
    	                                		</c:when>
 		                               		<c:when test="${ob.DPP_KEYNO eq '145' }">
	    	                                		<c:if test="${status.index == 0}">
	    	                                			민정 태양광 발전소
	    	                                		</c:if>
	    	                                		<c:if test="${status.index == 1}">
	    	                                			영자 태양광 발전소
	    	                                		</c:if>
	    	                                		<c:if test="${status.index == 2}">
	    	                                			재두 태양광 발전소
	    	                                		</c:if>
    	                                		</c:when>
 		                               		<c:when test="${ob.DPP_KEYNO eq '178' }">
	    	                                		<c:if test="${status.index == 0}">
	    	                                			오남매 태양광 발전소 2호 | 인버터 1
	    	                                		</c:if>
	    	                                		<c:if test="${status.index == 1}">
	    	                                			오남매 태양광 발전소 2호 | 인버터 2
	    	                                		</c:if>
	    	                                		<c:if test="${status.index == 2}">
	    	                                			오남매 태양광 발전소 3호 | 인버터 1
	    	                                		</c:if>
	    	                                		<c:if test="${status.index == 3}">
	    	                                			오남매 태양광 발전소 3호 | 인버터 2
	    	                                		</c:if>
    	                                		</c:when>
 		                               		<c:when test="${ob.DPP_KEYNO eq '179' }">
	    	                                		<c:if test="${status.index == 0}">
	    	                                			오남매 태양광 발전소 4호 | 인버터 1
	    	                                		</c:if>
	    	                                		<c:if test="${status.index == 1}">
	    	                                			오남매 태양광 발전소 4호 | 인버터 2
	    	                                		</c:if>
	    	                                		<c:if test="${status.index == 2}">
	    	                                			오남매 태양광 발전소 5호 | 인버터 1
	    	                                		</c:if>
    	                                		</c:when>
    	                                		<c:otherwise>
    	                                			${ob.DPP_NAME }| ${fn:substringBefore(model.DI_NAME,'호')}
    	                                		</c:otherwise>
    	                                	</c:choose>
    	                                </td>
        	                            <td>${not empty model.Active_Power?model.Active_Power:0 }</td>
            	                        <td><span class="check_c ${type }"></span></td>
	                                </tr>
                            	</c:forEach>
                            </tbody>
                        </table>
                    </div>
                </article>  

                <%-- 게시판 주석 처리 (나중에 사용 가능)
                <article class="artBoard bott">
                    <h2 class="circle">게시판</h2>

                    <div class="tab_inner_01_wrap">
                        <ul class="tab_inner_01 tab_board_1">
                            <li class="active"><a href="javascript:;">안전관리</a></li>
                            <li><a href="javascript:;">유지관리</a></li>
                        </ul>
                    </div>

                    <div class="tab_board_1_con">
                        <div class="table_wrapper">
                            <table class="tbl_normal fixed">
                                <colgroup>
                                    <col width="10%">
                                    <col width="65%">
                                    <col width="25%">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>No.</th>
                                        <th>제목</th> 
                                        <th>날짜</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:if test="${fn:length(boardList_A) != 0 }">
	                                	<c:forEach items="${boardList_A }" var="typeA">
		                                    <tr>
		                                        <td>${typeA.COUNT }</td>
		                                        <td><a href="/dy/Board/${typeA.BN_KEYNO}/detailView.do">${typeA.BN_TITLE }</a></td>
		                                        <td><c:out value="${fn:substring(typeA.BN_REGDT,0,10) }"/></td>
		                                    </a>
	                                    </c:forEach>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>


                        <div class="table_wrapper">
                            <table class="tbl_normal fixed">
                                <colgroup>
                                    <col width="10%">
                                    <col width="65%">
                                    <col width="25%">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>No.</th>
                                        <th>제목</th> 
                                        <th>날짜</th>
                                    </tr>
                                </thead>
                                <tbody>
                                	<c:if test="${fn:length(boardList_B) != 0 }">
	                                	<c:forEach items="${boardList_B }" var="typeB">
		                                    <tr>
		                                        <td>${typeB.COUNT }</td>
		                                        <td><a href="/dy/Board/${typeB.BN_KEYNO}/detailView.do">${typeB.BN_TITLE }</a></td>
		                                        <td><c:out value="${fn:substring(typeB.BN_REGDT,0,10) }"/></td>
		                                    </tr>
	                                    </c:forEach>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>

                        <script>
                            tab('.tab_board_1', 0)
                        </script>
                    </div>

                </article>
                --%>
            </div>

            <div class="col n03">
                <article class="artBoard long">
                    <h2 class="circle">인버터 종합 발전실적 | ${ob.DPP_NAME } </h2>
                    
                    <div class="inverter_all_develope" style="max-height: 580px; overflow-y: auto;">
                        <ul class="list">
                            <li>
                                <span class="state black">전일</span>
                                <ul class="info">
                                    <li>
                                        <span class="sbj">발전시간</span>
                                        <span class="num"><b><fmt:formatNumber value="${ob.DDM_P_DATA/ob.DPP_VOLUM }" pattern="0.00"/></b>h</span>
                                    </li>
                                    <li>
                                        <span class="sbj">발전량</span>
                                        <span class="num"><b><fmt:formatNumber value="${ob.DDM_P_DATA}" pattern="0.00"/></b>kWh</span>
                                    </li>
                                </ul>
                            </li>
                            <li>
                                <span class="state red">금일</span>
                                <ul class="info">
                                    <li>
                                        <span class="sbj">발전시간</span>
                                        <span class="num"><b id="todayHour">0.00</b>h</span>
                                    <li>
                                        <span class="sbj">발전량</span>
                                        <span class="num"><b id="todayGeneration">0.00</b>kWh</span>
                                    </li>
                                </ul>
                            </li>
                            <li>
                                <span class="state green">금월</span>
                                <ul class="info">
                                    <li>
                                        <span class="sbj">발전시간(평균)</span>
                                        <span class="num"><b id="monthlyHourAvg">0.00</b>h</span>
                                    </li>
                                    <li>
                                        <span class="sbj">발전량</span>
                                        <span class="num"><b id="monthlyGeneration">0.00</b>kWh</span>
                                    </li>
                                </ul>
                            </li>
                            <li>
                                <span class="state orange">금년</span>
                                <ul class="info">
                                    <%-- <li>
                                        <span class="sbj">발전시간(평균)</span>
                                        <span class="num"><b>
                                        		<c:if test="${year.CNT ne '0'}">
                                        			<fmt:formatNumber value="${((year.DATA/ob.DPP_VOLUM) + ob.DDM_T_HOUR)/year.CNT }" pattern="0.00"/>
                                        		</c:if>
                                        		<c:if test="${year.CNT eq '0'}">
                                        			<fmt:formatNumber value="${ob.DDM_D_DATA/ob.DPP_VOLUM }" pattern="0.00"/>
                                        		</c:if>
                                        	</b>h
                                        </span>
                                    </li> --%>
                                    <li>
                                        <span class="sbj">발전시간</span>
                                        <span class="num"><b>
                                        	<fmt:formatNumber value="${year1/ob.DPP_VOLUM }" pattern="0.00"/>
                                        	</b>h
                                        </span>
                                    </li>
                                    <li>
                                        <span class="sbj">발전량</span>
                                        <span class="num"><b><fmt:formatNumber value="${year1 }" pattern="0.00"/></b>kWh</span>
                                    </li>
                                </ul>
                            </li>
                            <li>
                                <span class="state gray">누적</span>
                                <ul class="info">
                                    <%-- <li>
                                        <span class="sbj">발전시간(평균)</span>
                                        <span class="num"><b>
                                        	<c:if test="${all.CNT ne '0'}">
                                       			<fmt:formatNumber value="${((all.DATA/ob.DPP_VOLUM) + ob.DDM_T_HOUR)/all.CNT }" pattern="0.00"/>
                                       		</c:if>
                                       		<c:if test="${all.CNT eq '0'}">
                                       			<fmt:formatNumber value="${ob.DDM_D_DATA/ob.DPP_VOLUM }" pattern="0.00"/>
                                       		</c:if>
                                        	</b>h
                                        </span>
                                    </li> --%>
                                    <li>
                                        <span class="sbj">발전시간</span>
                                        <span class="num"><b>
                                        	<fmt:formatNumber value="${ob.DDM_CUL_DATA/ob.DPP_VOLUM }" pattern="0.00"/>
                                        	</b>h
                                        </span>
                                    </li>
                                    <li>
                                        <span class="sbj">발전량</span>
                                        <span class="num"><b><fmt:formatNumber value="${ob.DDM_CUL_DATA }" pattern="0.00"/></b>kWh</span>
                                    </li>
                                </ul>
                            </li>
                        </ul>
                    </div>

                </article>  
            </div>

        </section>
        
        <section class="base_pop_wrapper2">
            <div class="pop_base_calculation" style="top: 50%; width: 690px; left: calc(44% - 231px);" >
                
                <button type="button" class="btn_close" title="닫기"  onclick="$('.base_pop_wrapper2').removeClass('on')" style="position: sticky; top: 0px;float:right;"><i class="xi-close" style="margin: 10px;"></i></button>
<!--                 <button type="button" class="a_box_line" style="border-radius:50%;float: left;padding: 10px 0px;color: white;background-color: #4caf50;" onclick="Detail_Excel();">엑셀</button> -->
                <div class="form_box">
				       <table class="tbl_normal fixed" style="width: auto; margin-left: auto; margin-right: auto;">
				           <colgroup>
				               <!-- <col style="width: 10%;">
				               <col style="width: 15%;">
				               <col style="width: 20%;">
				               <col style="width: 20%;">
				               <col style="width: 15%;">
				               <col style="width: 15%;"> -->
				            </colgroup>
				            <thead>
				                <tr>
				                    <th>일시</th>
				                    <th>지역</th>
				                    <th>실제 발전량(kWh)</th>
				                    <th>자사 예측량(kWh)</th>
				                    <th>해줌 예측량(kWh)</th>
				                </tr>
				            </thead>
				            <tbody>
				                <c:forEach items="${predict}" var="predict">
					                <tr>
					                    <td>${predict.pre_date }</td>
					                    <td>나주</td>
					                    <td><fmt:formatNumber value="${predict.pre_actval}" pattern="0.00"/></td>
					                    <td><fmt:formatNumber value="${predict.pre_avg}" pattern="0.00"/></td>
					                    <td><fmt:formatNumber value="${predict.pre_act_haezoom}" pattern="0.00"/></td>
<%-- 					                    <td><fmt:formatNumber value="${result1.Daily_Generation/(ob.DPP_VOLUM/ob.DPP_INVER_COUNT)  }" pattern="0.00"/></td> --%>
					               </tr>
				                </c:forEach>
				            </tbody>
				            	<tr>
				            	 	<td colspan="3">대양기업 오차율(%)</td>
				            	 	<td colspan="2">0.63</td>
				            	</tr>
				            	<tr>
				            	 	<td colspan="3">해줌 오차율(%)</td>
				            	 	<td colspan="2">1.77</td>
				            	</tr>
				        </table>
				       
                </div>

            </div>
        </section>

        
    </div>
    
</div>
<!-- COMTAINER END -->
</form:form>


<script src="/resources/smartadmin/js/plugin/select2/select2.min.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${sp:getString('DAUM_APPKEY')}&libraries=services"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.24.0/moment.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.3/js/select2.min.js"></script>

<script type="text/javascript">

// 카카오맵 API 로드 완료 대기 함수
function waitForKakao(callback) {
	if (typeof kakao !== 'undefined' && kakao.maps) {
		callback();
	} else {
		setTimeout(function() {
			waitForKakao(callback);
		}, 100);
	}
}

$(function(){
	// 카카오맵 API가 로드된 후 지도 초기화
	if ("${DPP_KEYNO}" != '63'){
		waitForKakao(function() {
			pf_setMap();
		});
	} 
	ajaxData();
	updateMonthlyData();
 
 	$('.select2').select2({
	    closeOnSelect: true,
	    minimumResultsForSearch: 0,  // 검색 기능 항상 활성화
	    placeholder: "발전소를 검색하세요",
	    allowClear: false
	});
 	
 	//5분마다 F5
 	setInterval(function() {
	   location.reload();
	}, 300000);
 	

});

function DPPDataAjax(keyno){
	$("#keyno").val(keyno);
	
	$("#Form").submit();
}

function ajaxData(){
	$.ajax({
        url: '/dy/moniter/generalAjax.do',
        type: 'POST',
        data: {
        	keyno : $("#DPP_KEYNO").val(),
        	name : $("#InverterNum").val()
        },
        async: true,  // ✅ 비동기 처리로 변경 (브라우저 멈춤 현상 제거)
        success: function(result) {
        	
        	//인버터 이름 추가
        	$("#inverterName").text("<"+result.name+">")
        	
        	var volum = "${ob.DPP_VOLUM}";
        	var count = "${ob.DPP_INVER_COUNT}";

        	var ALL_VOLUM = volum/count;
        	
        	
        	//개별용량 추가
        	var other_count = "${ob.DPP_OTHER_VOLUM}";
        	
        	console.log(other_count);
        	
        	var volum_list = []
        	if(other_count != "") {
        	
        		volum_list = other_count.split(",")	
        		
        		//인버터 호에서 숫자만 추출
	        	var inverternumberstr = $("#InverterNum").val();
				var regex = /[^0-9]/g;
				var resulttemp = inverternumberstr.replace(regex, "");
				var numbering = parseInt(resulttemp);
        		
        		ALL_VOLUM = volum_list[numbering-1]
        	}
        	
        
        	
        	if(result.invertData == null){
        		
        		$("#AllPower").text("0.0kW / 0.00h")
        		$("#Active").text("0.0kW")

        		chartOption(0.0,0.0,ALL_VOLUM);
        	}else{
        		console.log("volum :"+volum)
        		console.log("count :"+count)
        		console.log("Daily_Generation :"+result.invertData.Daily_Generation)
        		var hour = result.invertData.Daily_Generation / (volum/count);
        		$("#AllPower").text(result.invertData.Daily_Generation+"kWh / " + hour.toFixed(2) +"h")
        	
        		var hour = result.invertData.Daily_Generation / (ALL_VOLUM);
        		$("#AllPower").text(result.invertData.Daily_Generation+"kW / " + hour.toFixed(2) +"h")
            	$("#Active").text(result.invertData.Active_Power+"kW")
        		
            	var aDeg = (result.invertData.Daily_Generation/((ALL_VOLUM)*8))*100
             	/*$("#AllPower_g").attr("style","background-color: #f13a3a; transform: rotate("+aDeg+"deg);")
            	
            	var bDeg = (result.invertData.Active_Power/(ALL_VOLUM))*100
             	$("#Active_g").attr("style","background-color: #ff7d53; transform: rotate("+bDeg+"deg);") */

             	chartOption(aDeg,result.invertData.Active_Power,ALL_VOLUM);
        	}
        	
        	var totalDailyGen = 0;
        	if(result.invertDataList){
        		for(var i=0; i<result.invertDataList.length; i++){
        			totalDailyGen += parseFloat(result.invertDataList[i].Daily_Generation || 0);
       			}
      		}
      		
      		// 금일 발전량 합계 반영
      		$("#todayGeneration").text(totalDailyGen.toFixed(2));
      		
      		// 금일 발전시간 = (총 발전량 / 설비용량)
      		var plantVolum = parseFloat("${ob.DPP_VOLUM}");
      		var todayHour = 0;
      		if(plantVolum > 0){
      			todayHour = totalDailyGen/plantVolum;
      		}
      		$("#todayHour").text(todayHour.toFixed(2));
      		
        },
        error: function(){
        	alert("에러 관리자에 문의해주세요.");
        }
	});
}

// 금월 발전량/발전시간 업데이트
function updateMonthlyData(){
	$.ajax({
        url: '/dy/moniter/monthlyAjax.do',
        type: 'POST',
        data: {
        	keyno : "${ob.DPP_KEYNO}"
        },
        success: function(result) {
        	var monthlyGen = parseFloat(result.Monthly_Generation || 0);
        	$("#monthlyGeneration").text(monthlyGen.toFixed(2));
        	
        	// 금월 평균 발전시간 = (금월 발전량 / 설비용량) / 일수
        	var plantVolum = parseFloat("${ob.DPP_VOLUM}");
        	var dayCount = parseInt("${month1Cnt}") + 1; // 오늘 포함
        	var monthlyHourAvg = 0;
        	if(plantVolum > 0 && dayCount > 0){
        		monthlyHourAvg = (monthlyGen / plantVolum) / dayCount;
        	}
        	$("#monthlyHourAvg").text(monthlyHourAvg.toFixed(2));
        },
        error: function(){
        	console.log("금월 발전량 로드 실패");
        }
	});
}

function pf_setMap(){
	lat = "${ob.DPP_X_LOCATION}"
	lng = "${ob.DPP_Y_LOCATION}"
	
	if(!lat || !lng || lat == "" || lng == "") {
		console.error("지도 좌표가 없습니다. lat:", lat, "lng:", lng);
		return;
	}
	
	$("#map").html("")
	
	var container = document.getElementById("map");
	if(!container) {
		console.error("지도를 담을 영역(#map)을 찾을 수 없습니다.");
		return;
	}
	
	// 카카오맵 API 확인
	if (typeof kakao === 'undefined' || !kakao.maps) {
		console.error("카카오맵 API가 로드되지 않았습니다.");
		return;
	}
	
	var options = {
		center: new kakao.maps.LatLng(lat, lng),
		level: 3
	};
	map = new kakao.maps.Map(container, options);
	
	map.setMapTypeId(kakao.maps.MapTypeId.HYBRID); 
	
	marker = new kakao.maps.Marker({ 
	    // 지도 중심좌표에 마커를 생성합니다 
	    position: map.getCenter() 
	}); 
	marker.setMap(map);
}

function calculation(){
	$('.calculation_result').addClass('on')
// 	var Dm_val = "${month.DATA+ob.DDM_D_DATA}";	//금월
// 	var y_val = "${year.DATA+ob.DDM_D_DATA}";	//금년
// 	var n_val = "${all.DATA+ob.DDM_D_DATA}";	//누적
	var val = "${ob.DDM_D_DATA}";	//금일
	var Dm_val = "${month1}";	//금월
	var P_val = "${ob.DDM_P_DATA}";	//전일
	var Pm_val = "${Prmonth}";//전월
	var y_val = "${year1}";	//금년
	var n_val = "${ob.DDM_CUL_DATA}";	//누적
	var smp = $("#smp1").val();	
	var rec = $("#rec1").val();
	var plus = $("#plus").text();
	
	$("#pre_benefit").text(comma((P_val*(parseFloat(smp) + (rec*plus))).toFixed(0)).toString() + "원");
	$("#benefit").text(comma((val*(parseFloat(smp) + (rec*plus))).toFixed(0)).toString() +"원");
	$("#Pm_benefit").text(comma((Pm_val*(parseFloat(smp) + (rec*plus))).toFixed(0)).toString() +"원");
	$("#y_benefit").text(comma((y_val*(parseFloat(smp) + (rec*plus))).toFixed(0)).toString() +"원");
	$("#n_benefit").text(comma((n_val*(parseFloat(smp) + (rec*plus))).toFixed(0)).toString() +"원");
}

function comma(num){
    var len, point, str; 
       
    num = num + ""; 
    point = num.length % 3 ;
    len = num.length; 
   
    str = num.substring(0, point); 
    while (point < len) { 
        if (str != "") str += ","; 
        str += num.substring(point, point + 3); 
        point += 3; 
    } 
    return str;
}


function plusValue(value){
	var a = "${(ob.DPP_INVER_COUNT + 0.2)/ob.DPP_INVER_COUNT}"
	if(value == 'b'){
		$("#plus").text("1.5")
	}else{
		$("#plus").text(a)
	}
}

function clean(){
	$("#rec1").val("");
	$("#smp1").val("");
}

function showCCTV(ip){
	var url = "http://"+ip+":8082/";
	var win = window.open(url, "PopupWin", "width=500,height=600");

// 	win.document.write("<p>새창에 표시될 내용 입니다.</p>");
}

function chartOption(v1, v2, s1){
	  var chartDom = document.getElementById('gauge_1');
	  var myChart = echarts.init(chartDom);
	  var chartDom2 = document.getElementById('gauge_2');
	  var myChart2 = echarts.init(chartDom2);
	  
	  var option;
	  var option2;
	
	option = {
		       series: [
		           {
		               type: 'gauge',
		               center: ['50%', '50%'],
		               startAngle: 180,
		               endAngle: 0,
		               min: 0,
		               max: 100,
		               splitNumber: 10,
		               itemStyle: {
		                   color: '#f13a3a'
		               },
		               progress: {
		                   show: true,
		                   width: 30
		               },
		               pointer: {
		                   show: false
		               },
		               axisLine: {
		                   lineStyle: {
		                       width: 30
		                   }
		               },
		               axisTick: {
		                   distance: -40,
		                   splitNumber: 3,
		                   lineStyle: {
		                       width: 1,
		                       color: '#eee'
		                   }
		               },
		               splitLine: {
		                   distance: -43,
		                   length: 5,
		                   lineStyle: {
		                       width: 1,
		                       color: '#eee'
		                   }
		               },
		               axisLabel: {
		                   distance: 7,
		                   color: '#ddd',
		                   fontSize: 11
		               },
		               anchor: {
		                   show: false
		               },
		               title: {
		                   show: false
		               },
		               detail: {
		                   valueAnimation: true,
		                   width: '100%',
		                   lineHeight: 40,
		                   borderRadius: 8,
		                   offsetCenter: [0, '-15%'],
		                   fontSize: 0,
		                   fontWeight: 'bolder',
		                   formatter: '{value} kW',
		                   color: 'auto',
		                   show : 'false'
		               },
		               data: [
		                   {
		                       value: v1
		                       
		                   }
		               ]
		           }
		       ]
		   };
		   
		   option2 = {
		       series: [
		           {
		               type: 'gauge',
		               center: ['50%', '50%'],
		               startAngle: 180,
		               endAngle: 0,
		               min: 0,
		               max: s1,
		               splitNumber: 10,
		               itemStyle: {
		                   color: '#ff7d53'
		               },
		               progress: {
		                   show: true,
		                   width: 30
		               },
		               pointer: {
		                   show: false
		               },
		               axisLine: {
		                   lineStyle: {
		                       width: 30
		                   }
		               },
		               axisTick: {
		                   distance: -40,
		                   splitNumber: 3,
		                   lineStyle: {
		                       width: 1,
		                       color: '#eee'
		                   }
		               },
		               splitLine: {
		                   distance: -43,
		                   length: 5,
		                   lineStyle: {
		                       width: 1,
		                       color: '#eee'
		                   }
		               },
		               axisLabel: {
		                   distance: 7,
		                   color: '#ddd',
		                   fontSize: 11
		               },
		               anchor: {
		                   show: false
		               },
		               title: {
		                   show: false
		               },
		               detail: {
		                   valueAnimation: true,
		                   width: '60%',
		                   lineHeight: 40,
		                   borderRadius: 8,
		                   offsetCenter: [0, '-15%'],
		                   fontSize: 0,
		                   fontWeight: 'bolder',
		                   formatter: '{value} kW',
		                   color: 'auto',
		                   show : 'false'
		               },
		               data: [
		                   {
		                       value: v2
		                   }
		               ]
		           }
		       ]
		   };

		   option && myChart.setOption(option);
		   option2 && myChart2.setOption(option2);
		 	
}

$("#capture").on("click", function() {
	sreenShot($("#container"));
});

function sreenShot(target) {
	console.log(target);
	if (target != null && target.length > 0) {
		var t = target[0];
		console.log(t);
		html2canvas(t).then(function(canvas) {
			var myImg = canvas.toDataURL("image/png");
			myImg = myImg.replace("data:image/png;base64,", "");

			$.ajax({
				type : "POST",
				data : {
					"imgSrc" : myImg
				},
				dataType : "text",
				url : "/imageCreate.do",
				success : function(data) {
					console.log(data);
				},
				error : function(a, b, c) {
					alert("error");
				}
			});
		});
	}
}

function moreTable(){
	$('.base_pop_wrapper2').addClass('on')
}




</script>