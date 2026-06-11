<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>


<style>
.searchButton{
    height: 35px;
    color: #fff;
    vertical-align: middle;
    padding: 0 16px;
    margin-left: 5px;
    background-color: #3061AD;
    float: right;
}
</style>
<!-- COMTAINER -->
    <div id="container" class="heightFix">
        
        <div class="flex_wrapper">
            
            <section class="one_row left">
                <article class="artBoard top">
                    <h2 class="circle">종합현황</h2>

                    <div class="all_status sm">
                        <ul>
                            <li>
                                <p class="cate">총대수</p>
                                <p class="num navy">${cntM.a + cntM.b + cntM.c + cntM.d }</p>
                            </li>
                            <li>
                                <p class="cate">가동</p>
                                <p class="num sky">${cntM.a }</p>
                            </li>
                            <li>
                                <p class="cate">인버터 에러</p>
                                <p class="num red">${cntM.b }</p>
                            </li>
                            <li>
                                <p class="cate">장비 미개통</p>
                                <p class="num black">${cntM.c }</p>
                            </li>
                            <li>
                                <p class="cate">통신값 없음</p>
                                <p class="num orange">${cntM.d }</p>
                            </li>
                        </ul>
                    </div>
                </article>

                
                <article class="artBoard bott">
                    <h2 class="circle">현장리스트</h2>

                    <div class="r_c">
                        <select class="sel_nor wAuto" id="region" name="region" >
                            <option value="all">전체</option>
                            <option value="광주">광주</option>
                            <option value="나주">나주</option>
                            <option value="진천">진천</option>
                            <option value="부산">부산</option>
                            <option value="김제">김제</option>
                            <option value="해남">해남</option>
                            <option value="부안">부안</option>
                        </select>
                        
                        <select class="sel_nor wAuto" id="status" name="status">
                            <option value="status">전체</option>
                            <option value="정상">정상</option>
                            <option value="장애">장애</option>
                            <option value="연결 끊김">연결 끊김</option>
                            <option value="미개통">미개통</option>
                            <option value="대기">통신값 없음</option>
                        </select>
                        
                        <button type="button" onclick="searching()" class="searchButton">검색</button>
                    </div>
					
                    <div class="table_wrapper md con_h">
                        <table class="tbl_normal fixed">
                            <colgroup>
                                <col width="35%">
                                <col width="25%">
                                <col width="25%">
                                <col width="15%">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>현장명</th>
                                    <th>오늘</th>
                                    <th>어제</th>
                                    <th>상태</th>
                                </tr>
                            </thead>
                            <tbody id="ajax2">
                            	<c:forEach items="${list }" var="model" varStatus="status">
                            		<c:if test="${status.index == 0}">
                            			<c:set var="fristKeyno" value="${model.DPP_KEYNO}" />
                            		</c:if>
                            		
                            		<c:choose>
                            			<c:when test="${model.DDM_STATUS eq '정상' }">
                            				<c:set var="status" value="circle_statue green"/>
                            			</c:when>
                            			<c:when test="${model.DDM_STATUS eq '장애' }">
                            				<c:set var="status" value="circle_statue red"/>
                            			</c:when>
                            			<c:when test="${model.DDM_STATUS eq '대기' }">
                            				<c:set var="status" value="circle_statue orange"/>
                            			</c:when>
                            			<c:when test="${model.DDM_STATUS eq '연결 끊김' }">
                            				<c:set var="status" value="circle_statue blue"/>
                            			</c:when>
                            			<c:otherwise>
                            				<c:set var="status" value="circle_statue black"/>
                            			</c:otherwise>
                            		</c:choose>
		                                <tr>
		                                    <td><a href="javascript:;" onclick="detailInverter('${model.DPP_KEYNO}')"> [ ${model.DPP_AREA } ] ${model.DPP_NAME }</a></td>
		                                    <td><fmt:formatNumber value="${model.DDM_D_DATA }" pattern="0.00"/>(<fmt:formatNumber value="${model.DDM_D_DATA/model.DPP_VOLUM }" pattern="0.00"/>)</td>
		                                    <td><fmt:formatNumber value="${model.DDM_P_DATA }" pattern="0.00"/>(<fmt:formatNumber value="${model.DDM_P_DATA/model.DPP_VOLUM }" pattern="0.00"/>)</td>
		                                    <td><span class="${status }"></span></td>
		                                </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </article>
            </section>


            <section class="one_row right">

                <article class="artBoard top">
                    <h2 class="circle">전체 발전량</h2>

                    <div class="all_status w5">
                        <ul>
                            <li>
                                <p class="cate">총 현재출력</p>
                                <p class="number"><b><fmt:formatNumber value="${listSum.ACTIVE }" pattern="0.00"/></b>kW</p>
                            </li>
                            <li>
                                <p class="cate">총 금일발전량</p>
                                <p class="number"><b><fmt:formatNumber value="${listSum.DALIY/1000 }" pattern="0.00"/></b>MWh</p>
                            </li>
                            <li>
                                <p class="cate">총 전일발전량</p>
                                <p class="number"><b><fmt:formatNumber value="${listSum.PREDATA/1000 }" pattern="0.00"/></b>MWh</p>
                            </li>
                            <li>
                                <p class="cate">총 누적발전량</p>
                                <p class="number"><b><fmt:formatNumber value="${listSum.CUMULATIVE/1000000 }" pattern="0.00"/></b>GWh</p>
                            </li>
                            <li>
                                <p class="cate">총 설비용량</p>
                                <p class="number"><b><fmt:formatNumber value="${listSum.VOLUM }" pattern="0.0"/></b>kW</p>
                            </li>
                        </ul>
                    </div>
                </article>

				<!-- 상세 정보 -->
                <div class="wb bott" id="ajax">
                </div>

            </section>

            
        </div>
        
    </div>
    <!-- COMTAINER END -->

</div>
<!-- WRAP END -->

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${sp:getString('DAUM_APPKEY')}&libraries=services"></script>
<script>
$(function(){
 	detailInverter("${fristKeyno}");
 	
 	setInterval(function() {
 	   location.reload();
 	}, 600000);
 	 
});

function detailInverter(keyno){
	$.ajax({
        url: '/dy/moniter/overAll_Ajax.do',
        type: 'POST',
        data: {
        	keyno : keyno
        },
        async: false,  
        success: function(result) {
        	$("#ajax").html(result);
        },
        error: function(){
        	alert("상세정보 부르기 에러");
        }
	});
}

function searching(){
	$.ajax({
        url: '/dy/moniter/overAll_Ajax2.do',
        type: 'POST',
        data: {
        	region : $("#region").val()
        	,status : $("#status").val()
        },
        async: false,  
        success: function(result) {
        	$("#ajax2").html(result);
        },
        error: function(){
        	alert("상세정보 부르기 에러");
        }
	});
}

</script>