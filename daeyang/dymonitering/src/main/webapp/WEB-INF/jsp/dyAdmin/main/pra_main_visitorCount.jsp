<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<script>
$(document).ready(function(){
	getVisitorCountHtml();
});
function getVisitorCountHtml(){
	var lastYear = new Date().getFullYear()-1;
	var thisYear = new Date().getFullYear();
	
	var visitorLastCountArr = new Array();
	var visitorThisCountArr = new Array();
	
	$.ajax({
		type : "post",
		url : "/dyAdmin/main/visitorCount/DataAjax.do", 
		data : {"lastYear":lastYear,
				"AH_HOMEDIV_C":homeKey,
				"thisYear":thisYear},
		success : function(data) {
			$("#${id} .visitorTable").empty().html(data.visitorObject);

			if(data.visitorList){
				var visitorResultList = data.visitorList;
				
				for(var i = 0; i < visitorResultList.length; i++){
					var data = visitorResultList[i];
					visitorLastCountArr.push(data.lastCount);
					visitorThisCountArr.push(data.thisCount);
				}
				
				pf_visitorGraphList(lastYear,thisYear,visitorLastCountArr,visitorThisCountArr);
			}
		},
		beforeSend:function(){
			$("#${id}").find(".dataEmptyDiv").hide(); 
			$("#${id}").find(".dataEmpty").show(); 
			
	    },
	    complete:function(){
	    	$("#${id}").find(".dataEmptyDiv").show(); 
			$("#${id}").find(".dataEmpty").hide(); 
	   	},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
		}
	});
}



function pf_visitorGraphList(lastYear,thisYear,visitorLastCountArr,visitorThisCountArr){

	var ctx2 = $('#${id} .canvas2');
	if(visitorHorizontalBarList.${id}){ //버튼 클릭스 캔버스 지우고 다시 생성
		ctx2.remove();
		var x2 = document.createElement("CANVAS");
		x2.setAttribute("class", "canvas2");
		$('#${id} .canvas2Div').append(x2);
	}
	
	var visitorHorizontalBar = new Chart($('#${id} .canvas2'), {
		type: 'line',
		data: {
			labels: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
			datasets: [{
				label: lastYear+'년도 방문자 현황',
				backgroundColor: 'rgba(0,0,0,0.3)',
				borderColor: 'rgba(0,0,0,0.3)',
				data: visitorLastCountArr
			}, {
				label: thisYear+'년도 방문자 현황',
				backgroundColor: 'rgba(170,218,240,0.7)',
				borderColor: 'rgba(170,218,240,0.7)',
				data: visitorThisCountArr
			}]
		},
		options: {
			responsive: true,
			maintainAspectRatio: false,
			title: {
				display: false
			},
			tooltips: {
				mode: 'index',
			},
			hover: {
				mode: 'index'
			},
			legend: {
				position: 'bottom',
				padding : 0,
				labels: { 
			      fontFamily: 'Noto Sans'
			    }
			},
			scales: {
				xAxes: [{
					ticks: {
						fontFamily: 'Noto Sans',
					},
					scaleLabel: {
						display: true,
					}
				}],
				yAxes: [{
					ticks: {
						min : 0,
						fontFamily: 'Noto Sans',
					},
					scaleLabel: {
						display: true,
					}
				}]
			}
		}
	});
	
	visitorHorizontalBarList.${id} = true;
}
	
</script>

	<div class="tit-box">
		<p class="tit">방문자 현황</p>
		<%@ include file="/WEB-INF/jsp/dyAdmin/include/pra_import_mainSelect.jsp"%>
          <a href="/dyAdmin/statistics/visitor.do" class="btn btn-sm btn-primary moreBtn">
              <i class="fa fa-floppy-o"></i> 더보기
          </a>
	</div>
	<div class="dataEmpty">로딩중입니다.</div>
	<div class="ds-festi-reservation"> <!-- 방문자 현황 -->
		<div class="garaph-box canvas2Div">
			<canvas class="canvas2" width="100%" height=""></canvas>
		</div>
		<div class="table-box visitorTable dataEmptyDiv">
		</div>
	</div> 
