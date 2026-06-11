<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<script>
$(document).ready(function(){
	getMenuCountHtml('${id}');
});

function getMenuCountHtml(id,stdt,endt){
	stdt = stdt || ''
	endt = endt || ''

	var menuNameArr = new Array();
	var menuCountArr = new Array();
	
	$.ajax({
		type : "post",
		url : "/dyAdmin/main/menuCount/DataAjax.do", 
		data : {"STDT":stdt,
				"AH_HOMEDIV_C":homeKey,
				"ENDT":endt},
		success : function(data) {
			$("#"+id +" #menuTable tbody").empty().html(data.menuObject);
			if(data.menuList){
				var menuResultList = data.menuList;
				$.each(menuResultList,function(i){
					menuNameArr.push(menuResultList[i].MN_NAME);
					menuCountArr.push(menuResultList[i].selectCount);
				});
				pf_menuGraphList(stdt,endt,menuNameArr,menuCountArr,id);
			}
		},
		beforeSend:function(){
			$("#"+id).find(".dataEmptyDiv").hide(); 
			$("#"+id).find(".dataEmpty").show(); 
			
	    },
	    complete:function(){
	    	$("#"+id).find(".dataEmptyDiv").show(); 
			$("#"+id).find(".dataEmpty").hide(); 
	   	},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
		}
	});
}


function pf_menuGraphList(stdt,endt,menuNameArr,menuCountArr,id){
	var title = '전체';
	if(stdt) title = stdt + ' ~ ' + endt;
	
	var menuId = id || '${id}';
	var horizontalBarChartData = {
		labels: menuNameArr,
		datasets: [{
			label: 'Dataset 1',
			backgroundColor: '#55a8de',
			borderColor: '#55a8de',
			borderWidth: 1,
			data: menuCountArr
		}]
	};

	var ctx1 = $('#'+menuId+' .canvas1');
	
	if(menuHorizontalBarList.${id}){ //버튼 클릭스 캔버스 지우고 다시 생성
		ctx1.remove();
		var x = document.createElement("CANVAS");
		x.setAttribute("class", "canvas1");
		$('#'+menuId+' .canvas1Div').append(x);
	}
	
	var menuHorizontalBar = new Chart($('#'+menuId+' .canvas1'), {
		type: 'horizontalBar',
		data: horizontalBarChartData,
		options: {
			elements: {
				rectangle: {
					borderWidth: 2,
				}
			},
			responsive: true,
			maintainAspectRatio: false,
			legend: {
				display : false,
			},
			title: {
				display: true,
				text: title,
				fontFamily: 'Noto Sans'
			},
			scales: {
	            xAxes: [{
	                ticks: {
	                	min : 0,
						fontFamily: 'Noto Sans'
	                }
	            }],
				yAxes: [{
					ticks: {
						fontFamily: 'Noto Sans',
					}
				}]
	        }
		}
	});
	
	menuHorizontalBarList.${id} = true;
}
	
//기간별 체크
function set_menuCountType(obj,id,type){
	var stdt;
	var endt; 
	var nowDay = new Date();
	var settingDate = new Date();
	if(type){
		if(type == 'T'){
			stdt = nowDay;
			endt = nowDay;
		}else if(type == 'W'){
			settingDate.setDate(settingDate.getDate()-7);  //일주일 전
			stdt = settingDate; 
			endt = nowDay;
		}else if(type == 'M'){
			settingDate.setMonth(settingDate.getMonth()-1); //한달 전
			stdt = settingDate;
			endt = nowDay;
		}
		getMenuCountHtml(id,stdt.format("yyyy-MM-dd"),endt.format("yyyy-MM-dd"));
	}else{
		getMenuCountHtml(id);
	}
	
	$(obj).closest('.menuCountUl').find('li').removeClass('active');
	$(obj).closest('li').addClass('active');
}

</script>

	<div class="tit-box">
		<p class="tit">메뉴 페이지 통계</p>
		<ul class="dash-tab1 menuCountUl">
			<li class="active"><a href="javascript:;" onclick="set_menuCountType(this,'${id}')">전체</a></li>
			<li><a href="javascript:;" onclick="set_menuCountType(this,'${id}','T')">오늘</a></li>
			<li><a href="javascript:;" onclick="set_menuCountType(this,'${id}','W')">일주일</a></li>
			<li><a href="javascript:;" onclick="set_menuCountType(this,'${id}','M')">한달</a></li>
		</ul>
		<%@ include file="/WEB-INF/jsp/dyAdmin/include/pra_import_mainSelect.jsp"%>
		
             <a href="/dyAdmin/statistics/menucount.do" class="btn btn-sm btn-primary moreBtn">
                 <i class="fa fa-floppy-o"></i> 더보기
             </a>
	</div>
	<div class="dataEmpty">로딩중입니다.</div>
	<div class="ds-festi-current canvas1Div"> <!-- 메뉴별 통계 그래프 -->
		<canvas class="canvas1"></canvas>
	</div> <!-- // 축제현황 -->
	<div class="dataEmptyDiv">
		<div class="table-box table_wrap_mobile">
			<table class="tbl_da_sm" id="menuTable">
				<colgroup>
					<col width="auto;">
					<col width="auto;">
					<col width="auto;">
					<col width="auto;">
				</colgroup>
				<thead>
					<tr>
						<th>순위</th>
						<th>메뉴</th>
						<th>카운트</th>
						<th>퍼센트</th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
		</div>
	</div>
