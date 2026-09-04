<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<style>
/* 탭으로 보이는 컬럼 수가 적어서 모달보다 좁아지면 100%로 채우고,
   컬럼이 많아서 모달보다 넓어지면 자연스럽게 넘쳐서 가로 스크롤(overflow-x)로 처리됨 */
#detail-table {
	width: 100%;
	table-layout: auto;
}

.pop_base_calculation {
	white-space: nowrap;
	left: 50%;
	transform: translate(-50%, -50%);
	width: 98%;
	overflow-x: auto;
	box-sizing: border-box;
}
@media screen and (max-width: 500px) {
	.pop_base_calculation {left:50%;width:90%;height: 85%;}
	.pop_base_calculation.header { top: 43% !important;}
	.pop_base_calculation.body { top: 53% !important;}
}

/* 상세보기 표 - 컬럼 그룹 탭 */
.detail-tab-bar { display: flex; gap: 6px; margin-bottom: 10px; white-space: normal; }
.detail-tab-btn { padding: 8px 14px; border: 1px solid #ddd; border-radius: 20px; background-color: #fff; color: #333; font-size: 13px; cursor: pointer; }
.detail-tab-btn.active { background-color: #253e83; color: #fff; border-color: #253e83; }
#detail-table .grp-mppt, #detail-table .grp-istr, #detail-table .grp-grid, #detail-table .grp-etc { display: none; }
#detail-table.show-mppt .grp-mppt { display: table-cell; }
#detail-table.show-istr .grp-istr { display: table-cell; }
#detail-table.show-grid .grp-grid { display: table-cell; }
#detail-table.show-etc .grp-etc { display: table-cell; }
</style>


<div class="pop_base_calculation header" style="top: 6%;">
				<button type="button" class="btn_close" title="닫기"  onclick="$('.base_pop_wrapper').removeClass('on')" style="position: sticky; top: 0px;"><i class="xi-close" style="margin: 10px;"></i></button>
	            <c:if test="${userInfo.isAdmin eq 'Y'}">
	            	<button type="button" class="a_box_line" style="border-radius:50%;float: left;padding: 10px 0px;color: white;background-color: #4caf50;position:sticky;top: 0px" onclick="Detail_Excel();">엑셀</button>
	            </c:if>
			</div>
            <div class="pop_base_calculation body" style="top: 51%;height: 85%;padding-top: 0px;">
                <div class="form_box">
                    <div class="detail-tab-bar">
                        <button type="button" class="detail-tab-btn active" onclick="showDetailTab('mppt', this)">MPPT</button>
                        <button type="button" class="detail-tab-btn" onclick="showDetailTab('istr', this)">스트링 전류</button>
                        <button type="button" class="detail-tab-btn" onclick="showDetailTab('grid', this)">계통 전기값</button>
                        <button type="button" class="detail-tab-btn" onclick="showDetailTab('etc', this)">온도·상태·기타</button>
                    </div>
				       <table id="detail-table" class="tbl_normal fixed show-mppt">
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
						            <th class="grp-mppt">Vpv1</th>
						            <th class="grp-mppt">Ipv1</th>
						            <th class="grp-mppt">Vpv2</th>
						            <th class="grp-mppt">Ipv2</th>
						            <th class="grp-mppt">Vpv3</th>
						            <th class="grp-mppt">Ipv3</th>
						            <th class="grp-mppt">Vpv4</th>
						            <th class="grp-mppt">Ipv4</th>
						            <th class="grp-mppt">Vpv5</th>
						            <th class="grp-mppt">Ipv5</th>
						            <th class="grp-mppt">Vpv6</th>
						            <th class="grp-mppt">Ipv6</th>
						            <th class="grp-mppt">Vpv7</th>
						            <th class="grp-mppt">Ipv7</th>
						            <th class="grp-mppt">Vpv8</th>
						            <th class="grp-mppt">Ipv8</th>
						            <th class="grp-mppt">Vpv9</th>
						            <th class="grp-mppt">Ipv9</th>
						            <th class="grp-mppt">Vpv10</th>
						            <th class="grp-mppt">Ipv10</th>
						            <th class="grp-mppt">Vpv11</th>
						            <th class="grp-mppt">Ipv11</th>
						            <th class="grp-mppt">Vpv12</th>
						            <th class="grp-mppt">Ipv12</th>
						            <th class="grp-mppt">Vpv13</th>
						            <th class="grp-mppt">Ipv13</th>
						            <th class="grp-mppt">Vpv14</th>
						            <th class="grp-mppt">Ipv14</th>
						            <th class="grp-mppt">Vpv15</th>
						            <th class="grp-mppt">Ipv15</th>
						            <th class="grp-mppt">Vpv16</th>
						            <th class="grp-mppt">Ipv16</th>
						            <th class="grp-mppt">Vpv17</th>
						            <th class="grp-mppt">Ipv17</th>
						            <th class="grp-mppt">Vpv18</th>
						            <th class="grp-mppt">Ipv18</th>
						            <th class="grp-mppt">Vpv19</th>
						            <th class="grp-mppt">Ipv19</th>
						            <th class="grp-mppt">Vpv20</th>
						            <th class="grp-mppt">Ipv20</th>
						            <th class="grp-mppt">Vpv21</th>
						            <th class="grp-mppt">Ipv21</th>
						            <th class="grp-mppt">Vpv22</th>
						            <th class="grp-mppt">Ipv22</th>
						            <th class="grp-mppt">Vpv23</th>
						            <th class="grp-mppt">Ipv23</th>
						            <th class="grp-mppt">Vpv24</th>
						            <th class="grp-mppt">Ipv24</th>
						            <th class="grp-istr">Istr1</th>
						            <th class="grp-istr">Istr2</th>
						            <th class="grp-istr">Istr3</th>
						            <th class="grp-istr">Istr4</th>
						            <th class="grp-istr">Istr5</th>
						            <th class="grp-istr">Istr6</th>
						            <th class="grp-istr">Istr7</th>
						            <th class="grp-istr">Istr8</th>
						            <th class="grp-istr">Istr9</th>
						            <th class="grp-istr">Istr10</th>
						            <th class="grp-istr">Istr11</th>
						            <th class="grp-istr">Istr12</th>
						            <th class="grp-istr">Istr13</th>
						            <th class="grp-istr">Istr14</th>
						            <th class="grp-istr">Istr15</th>
						            <th class="grp-istr">Istr16</th>
						            <th class="grp-istr">Istr17</th>
						            <th class="grp-istr">Istr18</th>
						            <th class="grp-istr">Istr19</th>
						            <th class="grp-istr">Istr20</th>
						            <th class="grp-istr">Istr21</th>
						            <th class="grp-istr">Istr22</th>
						            <th class="grp-istr">Istr23</th>
						            <th class="grp-istr">Istr24</th>
						            <th class="grp-grid">V_AB</th>
						            <th class="grp-grid">V_BC</th>
						            <th class="grp-grid">V_CA</th>
						            <th class="grp-grid">V_AN</th>
						            <th class="grp-grid">V_BN</th>
						            <th class="grp-grid">V_CN</th>
						            <th class="grp-grid">I_A</th>
						            <th class="grp-grid">I_B</th>
						            <th class="grp-grid">I_C</th>
						            <th class="grp-grid">Fa</th>
						            <th class="grp-grid">Fb</th>
						            <th class="grp-grid">Fc</th>
						            <th class="grp-grid">Freq</th>
						            <th class="grp-etc">온도</th>
						            <th class="grp-etc">Temp2</th>
						            <th class="grp-etc">DSP_Err</th>
						            <th class="grp-etc">DSP_Alm</th>
						            <th class="grp-etc">SDSP_Err</th>
						            <th class="grp-etc">SDSP_Alm</th>
						            <th class="grp-etc">PV_Flt</th>
						            <th class="grp-etc">T_Flt</th>
						            <th class="grp-etc">T_Hour</th>
						            <th class="grp-etc">Safety</th>
						            <th class="grp-etc">Mode</th>
						            <th class="grp-etc">Phase</th>
						            <th class="grp-etc">Cap</th>
						            <th class="grp-etc">V_Rated</th>
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
						            <td class="grp-mppt">${result1.Vpv1}</td>
						            <td class="grp-mppt">${result1.Ipv1}</td>
						            <td class="grp-mppt">${result1.Vpv2}</td>
						            <td class="grp-mppt">${result1.Ipv2}</td>
						            <td class="grp-mppt">${result1.Vpv3}</td>
						            <td class="grp-mppt">${result1.Ipv3}</td>
						            <td class="grp-mppt">${result1.Vpv4}</td>
						            <td class="grp-mppt">${result1.Ipv4}</td>
						            <td class="grp-mppt">${result1.Vpv5}</td>
						            <td class="grp-mppt">${result1.Ipv5}</td>
						            <td class="grp-mppt">${result1.Vpv6}</td>
						            <td class="grp-mppt">${result1.Ipv6}</td>
						            <td class="grp-mppt">${result1.Vpv7}</td>
						            <td class="grp-mppt">${result1.Ipv7}</td>
						            <td class="grp-mppt">${result1.Vpv8}</td>
						            <td class="grp-mppt">${result1.Ipv8}</td>
						            <td class="grp-mppt">${result1.Vpv9}</td>
						            <td class="grp-mppt">${result1.Ipv9}</td>
						            <td class="grp-mppt">${result1.Vpv10}</td>
						            <td class="grp-mppt">${result1.Ipv10}</td>
						            <td class="grp-mppt">${result1.Vpv11}</td>
						            <td class="grp-mppt">${result1.Ipv11}</td>
						            <td class="grp-mppt">${result1.Vpv12}</td>
						            <td class="grp-mppt">${result1.Ipv12}</td>
						            <td class="grp-mppt">${result1.Vpv13}</td>
						            <td class="grp-mppt">${result1.Ipv13}</td>
						            <td class="grp-mppt">${result1.Vpv14}</td>
						            <td class="grp-mppt">${result1.Ipv14}</td>
						            <td class="grp-mppt">${result1.Vpv15}</td>
						            <td class="grp-mppt">${result1.Ipv15}</td>
						            <td class="grp-mppt">${result1.Vpv16}</td>
						            <td class="grp-mppt">${result1.Ipv16}</td>
						            <td class="grp-mppt">${result1.Vpv17}</td>
						            <td class="grp-mppt">${result1.Ipv17}</td>
						            <td class="grp-mppt">${result1.Vpv18}</td>
						            <td class="grp-mppt">${result1.Ipv18}</td>
						            <td class="grp-mppt">${result1.Vpv19}</td>
						            <td class="grp-mppt">${result1.Ipv19}</td>
						            <td class="grp-mppt">${result1.Vpv20}</td>
						            <td class="grp-mppt">${result1.Ipv20}</td>
						            <td class="grp-mppt">${result1.Vpv21}</td>
						            <td class="grp-mppt">${result1.Ipv21}</td>
						            <td class="grp-mppt">${result1.Vpv22}</td>
						            <td class="grp-mppt">${result1.Ipv22}</td>
						            <td class="grp-mppt">${result1.Vpv23}</td>
						            <td class="grp-mppt">${result1.Ipv23}</td>
						            <td class="grp-mppt">${result1.Vpv24}</td>
						            <td class="grp-mppt">${result1.Ipv24}</td>
						            <td class="grp-istr">${result1.Istr1}</td>
						            <td class="grp-istr">${result1.Istr2}</td>
						            <td class="grp-istr">${result1.Istr3}</td>
						            <td class="grp-istr">${result1.Istr4}</td>
						            <td class="grp-istr">${result1.Istr5}</td>
						            <td class="grp-istr">${result1.Istr6}</td>
						            <td class="grp-istr">${result1.Istr7}</td>
						            <td class="grp-istr">${result1.Istr8}</td>
						            <td class="grp-istr">${result1.Istr9}</td>
						            <td class="grp-istr">${result1.Istr10}</td>
						            <td class="grp-istr">${result1.Istr11}</td>
						            <td class="grp-istr">${result1.Istr12}</td>
						            <td class="grp-istr">${result1.Istr13}</td>
						            <td class="grp-istr">${result1.Istr14}</td>
						            <td class="grp-istr">${result1.Istr15}</td>
						            <td class="grp-istr">${result1.Istr16}</td>
						            <td class="grp-istr">${result1.Istr17}</td>
						            <td class="grp-istr">${result1.Istr18}</td>
						            <td class="grp-istr">${result1.Istr19}</td>
						            <td class="grp-istr">${result1.Istr20}</td>
						            <td class="grp-istr">${result1.Istr21}</td>
						            <td class="grp-istr">${result1.Istr22}</td>
						            <td class="grp-istr">${result1.Istr23}</td>
						            <td class="grp-istr">${result1.Istr24}</td>
						            <td class="grp-grid">${result1.voltage_of_phase_A_to_B}</td>
						            <td class="grp-grid">${result1.voltage_of_phase_B_to_C}</td>
						            <td class="grp-grid">${result1.voltage_of_phase_C_to_A}</td>
						            <td class="grp-grid">${result1.Phase_voltage_of_phase_A}</td>
						            <td class="grp-grid">${result1.Phase_voltage_of_phase_B}</td>
						            <td class="grp-grid">${result1.Phase_voltage_of_phase_C}</td>
						            <td class="grp-grid">${result1.Current_of_phase_A}</td>
						            <td class="grp-grid">${result1.Current_of_phase_B}</td>
						            <td class="grp-grid">${result1.Current_of_phase_C}</td>
						            <td class="grp-grid">${result1.Frequency_of_phase_A}</td>
						            <td class="grp-grid">${result1.Frequency_of_phase_B}</td>
						            <td class="grp-grid">${result1.Frequency_of_phase_C}</td>
						            <td class="grp-grid">${result1.Grid_Frequency}</td>
						            <td class="grp-etc">${result1.Internal_temperature}</td>
						            <td class="grp-etc">${result1.Cabinet_Temperature_2}</td>
						            <td class="grp-etc">${result1.DSP_Error_Code}</td>
						            <td class="grp-etc">${result1.DSP_Alarm_Code}</td>
						            <td class="grp-etc">${result1.Slave_DSP_ErrorCode}</td>
						            <td class="grp-etc">${result1.Slave_DSP_AlarmCode}</td>
						            <td class="grp-etc">${result1.PV_String_Fault_Bit}</td>
						            <td class="grp-etc">${result1.Temperature_Fault_Bit}</td>
						            <td class="grp-etc">${result1.Total_Generation_Hour}</td>
						            <td class="grp-etc">${result1.Safety_Code}</td>
						            <td class="grp-etc">${result1.Work_Mode}</td>
						            <td class="grp-etc">${result1.Phase}</td>
						            <td class="grp-etc">${result1.PowerCapacity}</td>
						            <td class="grp-etc">${result1.RatedLineVoltage}</td>
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
// 상세보기 표 - 컬럼 그룹 탭 전환
function showDetailTab(tab, btn){
	var table = document.getElementById('detail-table');
	table.className = table.className.replace(/\bshow-\w+\b/g, '').trim() + ' show-' + tab;
	var buttons = document.querySelectorAll('.detail-tab-btn');
	for(var i=0; i<buttons.length; i++){ buttons[i].classList.remove('active'); }
	if(btn){ btn.classList.add('active'); }
}

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
            
