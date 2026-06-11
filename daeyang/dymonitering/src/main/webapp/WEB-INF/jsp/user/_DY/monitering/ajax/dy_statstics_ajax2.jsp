<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>


<div class="pop_base_calculation header" style="top: 6%;">
				<button type="button" class="btn_close" title="닫기"  onclick="$('.base_pop_wrapper').removeClass('on')" style="position: sticky; top: 0px;"><i class="xi-close" style="margin: 10px;"></i></button>
	            <c:if test="${userInfo.isAdmin eq 'Y'}">
	            	<button type="button" class="a_box_line" style="border-radius:50%;float: left;padding: 10px 0px;color: white;background-color: #4caf50;position:sticky;top: 0px" onclick="Detail_Excel();">엑셀</button>
	            </c:if>
			</div>
            <div class="pop_base_calculation body" style="top: 51%;height: 85%;padding-top: 0px;">
                <div class="form_box">
				       <table class="tbl_normal fixed" style="width: auto;">
				           <colgroup>
				            </colgroup>
				            <thead>
				                <tr>
				                    <th>일시</th>
				                    <th>시간</th>
				                    <th>발전소</th>
				                    <th>이름</th>
				                    <th>발전량(kWh)</th>
				                    <th>누적발전량(kWh)</th>
				                    <th>발전시간(h)</th>
				                    <th>현재 출력(kW)</th>
				                    <th>Vpv1</th>
						            <th>Ipv1</th>
						            <th>Vpv2</th>
						            <th>Ipv2</th>
						            <th>Vpv3</th>
						            <th>Ipv3</th>
						            <th>Vpv4</th>
						            <th>Ipv4</th>
						            <th>Vpv5</th>
						            <th>Ipv5</th>
						            <th>Vpv6</th>
						            <th>Ipv6</th>
						            <th>Vpv7</th>
						            <th>Ipv7</th>
						            <th>Vpv8</th>
						            <th>Ipv8</th>
						            <th>Vpv9</th>
						            <th>Ipv9</th>
						            <th>Vpv10</th>
						            <th>Ipv10</th>
    								<th>Vpv11</th>
						            <th>Ipv11</th>
						            <th>Vpv12</th>
						            <th>Ipv12</th>
						            <c:choose>
						            	<c:when test="${ob.DPP_INVER eq 'GOODWE'}">
								            <th>Vpv13</th>
								            <th>Ipv13</th>
								            <th>Vpv14</th>
								            <th>Ipv14</th>
								            <th>Vpv15</th>
								            <th>Ipv15</th>
								            <th>Vpv16</th>
								            <th>Ipv16</th>
								            <th>Vpv17</th>
								            <th>Ipv17</th>
								            <th>Vpv18</th>
								            <th>Ipv18</th>
								            <th>Vpv19</th>
								            <th>Ipv19</th>
								            <th>Vpv20</th>
								            <th>Ipv20</th>
								            <th>Vpv21</th>
								            <th>Ipv21</th>
								            <th>Vpv22</th>
								            <th>Ipv22</th>
								            <th>Vpv23</th>
								            <th>Ipv23</th>
								            <th>Vpv24</th>
								            <th>Ipv24</th>								            								            								            								            								            
						            	</c:when>
						            	<c:otherwise>
							            	<th>Istr1</th>
								            <th>Istr2</th>
								            <th>Istr3</th>
								            <th>Istr4</th>
								            <th>Istr5</th>
								            <th>Istr6</th>
								            <th>Istr7</th>
								            <th>Istr8</th>
								            <th>Istr9</th>
								            <th>Istr10</th>
								            <th>Istr11</th>
								            <th>Istr12</th>
								            <th>Istr13</th>
								            <th>Istr14</th>
								            <th>Istr15</th>
								            <th>Istr16</th>
								            <th>Istr17</th>
								            <th>Istr18</th>
								            <th>Istr19</th>
								            <th>Istr20</th>
							            </c:otherwise>
							        </c:choose>
						            <th>Voltage_Of_Phase_A to B</th>
						            <th>Voltage_Of_Phase_B to C</th>
						            <th>Voltage_Of_Phase_C to A</th>
						            <th>Phase Voltage of phase A</th>
						            <th>Phase Voltage of phase B</th>
						            <th>Phase Voltage of phase C</th>
						            <th>Current of phase A</th>
						            <th>Current of phase B</th>
						            <th>Current of phase C</th>
						            <th>Internal Temperature</th>
				                </tr>
				            </thead>
				            <!-- 251029 수정 - 스크롤 구현: tbody에 id 추가하여 동적 행 추가 가능하도록 설정 -->
				            <tbody id="detail-table-body">
				                <c:forEach items="${result1}" var="result1">
					                <tr>
					                    <td>${fn:substring(result1.Conn_date,0,11)}</td>
					                    <td>${fn:substring(result1.Conn_date,11,16)}</td>
					                    <td>${ob.DPP_NAME }</td>
					                    <td>${fn:substringBefore(result1.DI_NAME,'호')}</td>
					                    <td>${result1.Daily_Generation }</td>
					                    <td>${result1.Cumulative_Generation }</td>
					                    <td><fmt:formatNumber value="${result1.Daily_Generation/(ob.DPP_VOLUM/ob.DPP_INVER_COUNT)  }" pattern="0.00"/></td>
					                    <td>${result1.Active_Power }</td>
					                    <td>${result1.Vpv1}</td>
							            <td>${result1.Ipv1}</td>
							            <td>${result1.Vpv2}</td>
							            <td>${result1.Ipv2}</td>
							            <td>${result1.Vpv3}</td>
							            <td>${result1.Ipv3}</td>
							            <td>${result1.Vpv4}</td>
							            <td>${result1.Ipv4}</td>
							            <td>${result1.Vpv5}</td>
							            <td>${result1.Ipv5}</td>
							            <td>${result1.Vpv6}</td>
							            <td>${result1.Ipv6}</td>
							            <td>${result1.Vpv7}</td>
							            <td>${result1.Ipv7}</td>
							            <td>${result1.Vpv8}</td>
							            <td>${result1.Ipv8}</td>
							            <td>${result1.Vpv9}</td>
							            <td>${result1.Ipv9}</td>
							            <td>${result1.Vpv10}</td>
							            <td>${result1.Ipv10}</td>
					            		<td>${result1.Vpv11}</td>
							            <td>${result1.Ipv11}</td>
							            <td>${result1.Vpv12}</td>
							            <td>${result1.Ipv12}</td>
							            <c:choose>
							            	<c:when test="${ob.DPP_INVER eq 'GOODWE'}">
									            <td>${result1.Vpv13}</td>
									            <td>${result1.Ipv13}</td>
									            <td>${result1.Vpv14}</td>
									            <td>${result1.Ipv14}</td>
									            <td>${result1.Vpv15}</td>
									            <td>${result1.Ipv15}</td>
									            <td>${result1.Vpv16}</td>
									            <td>${result1.Ipv16}</td>
									            <td>${result1.Vpv17}</td>
									            <td>${result1.Ipv17}</td>
									            <td>${result1.Vpv18}</td>
									            <td>${result1.Ipv18}</td>
									            <td>${result1.Vpv19}</td>
									            <td>${result1.Ipv19}</td>
									            <td>${result1.Vpv20}</td>
									            <td>${result1.Ipv20}</td>
									            <td>${result1.Vpv21}</td>
									            <td>${result1.Ipv21}</td>									            							            								            								            								            								            
									            <td>${result1.Vpv22}</td>
									            <td>${result1.Ipv22}</td>
									            <td>${result1.Vpv23}</td>
									            <td>${result1.Ipv23}</td>
									            <td>${result1.Vpv24}</td>
									            <td>${result1.Ipv24}</td>									            									            
							            	</c:when>
							            	<c:otherwise>
								            	<td>${result1.Istr1}</td>
									            <td>${result1.Istr2}</td>
									            <td>${result1.Istr3}</td>
									            <td>${result1.Istr4}</td>
									            <td>${result1.Istr5}</td>
									            <td>${result1.Istr6}</td>
									            <td>${result1.Istr7}</td>
									            <td>${result1.Istr8}</td>
									            <td>${result1.Istr9}</td>
									            <td>${result1.Istr10}</td>
									            <td>${result1.Istr11}</td>
									            <td>${result1.Istr12}</td>
									            <td>${result1.Istr13}</td>
									            <td>${result1.Istr14}</td>
									            <td>${result1.Istr15}</td>
									            <td>${result1.Istr16}</td>
									            <td>${result1.Istr17}</td>
									            <td>${result1.Istr18}</td>
									            <td>${result1.Istr19}</td>
									            <td>${result1.Istr20}</td>
								            </c:otherwise>
								        </c:choose>
							            <td>${result1.voltage_of_phase_A_to_B}</td>
							            <td>${result1.voltage_of_phase_B_to_C}</td>
							            <td>${result1.voltage_of_phase_C_to_A}</td>
							            <td>${result1.Phase_voltage_of_phase_A}</td>
							            <td>${result1.Phase_voltage_of_phase_B}</td>
							            <td>${result1.Phase_voltage_of_phase_C}</td>
							            <td>${result1.Current_of_phase_A}</td>
							            <td>${result1.Current_of_phase_B}</td>
							            <td>${result1.Current_of_phase_C}</td>
							            <td>${result1.Internal_temperature}</td>
					               </tr>
				                </c:forEach>
				            </tbody>
				        </table>
                </div>
                <!-- 251029 수정 - 스크롤 구현: 로딩 인디케이터 추가 -->
                <div id="loading-indicator" style="text-align: center; padding: 20px; display: none;">
                    <i class="xi-spinner-3 xi-spin" style="font-size: 24px;"></i> 로딩 중...
                </div>

            </div>

<script>
// 251029 수정 - 스크롤 구현: 스크롤 시 자동으로 다음 페이지 데이터 로드

// [기존 코드] - 스크롤 없음, 한 번에 모든 데이터 로드
// (기존에는 이 부분 전체가 없었음)

// [수정 코드] - 스크롤 이벤트 감지 및 페이지별 데이터 로드 (200개씩)
var currentPage = 1;
var isLoading = false;
var hasMoreData = true;

$(document).ready(function() {
    // 스크롤 이벤트 리스너
    $('.pop_base_calculation.body').on('scroll', function() {
        var scrollTop = $(this).scrollTop();
        var scrollHeight = $(this).prop('scrollHeight');
        var clientHeight = $(this).height();
        
        // 스크롤이 하단 100px 이내로 도달하면 다음 페이지 로드
        if (scrollTop + clientHeight >= scrollHeight - 100) {
            if (!isLoading && hasMoreData) {
                loadMoreData();
            }
        }
    });
});

function loadMoreData() {
    isLoading = true;
    currentPage++;
    $('#loading-indicator').show();
    
    $.ajax({
        url: '/dy/moniter/stasticsAjax3.do',
        type: 'POST',
        data: {
            keyno: $("#n_keyno").val(),
            InverterType: $("#InverterType").val(),
            DaliyType: $("#DaliyType").val(),
            searchBeginDate: $("#searchBeginDate").val(),
            searchEndDate: $("#searchEndDate").val(),
            page: currentPage,
            pageSize: 200
        },
        success: function(response) {
            $('#loading-indicator').hide();
            
            // 응답에서 테이블 행만 추출
            var $response = $(response);
            var $rows = $response.find('#detail-table-body tr');
            
            if ($rows.length > 0) {
                // 새로운 행을 테이블에 추가
                $('#detail-table-body').append($rows);
            } else {
                // 더 이상 데이터가 없음
                hasMoreData = false;
                $('#loading-indicator').html('<p style="color: #999;">모든 데이터를 불러왔습니다.</p>').show();
            }
            
            isLoading = false;
        },
        error: function(xhr, status, error) {
            $('#loading-indicator').hide();
            alert("데이터 로딩 중 오류가 발생했습니다.");
            isLoading = false;
        }
    });
}
</script>
            
