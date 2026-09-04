<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<script src="/resources/smartadmin/js/plugin/horizontal/jquery.horizBarChart.js"></script>
<script>
$(function(){
    $('.chart').horizBarChart({
        selector: '.bar',
        speed: 500
      });
});
</script>

<table id="pctable" class="table table-striped table-bordered table-hover"  width="100%">
	<thead>
		<tr>
			<th colspan="4" class="smart-form">
				<div class="inline-group" style="padding: 5px 0;">
					<label class="radio">
						<input type="radio" name="STM_ORDER" value="A" ${search.STM_ORDER eq 'A' ? 'checked':'' }>
						<i></i>접속자순</label>
					<label class="radio">
						<input type="radio" name="STM_ORDER" value="B" ${search.STM_ORDER eq 'B' ? 'checked':'' }>
						<i></i>항목순</label>
					<button type="button" 
							class="btn btn-sm btn-primary" 
							onclick="pf_excel('/dyAdmin/statistics/${tiles}/pagingAjax.do?excel=excel')"
							style="float: right;margin-right: 10px;margin-top: -3px;">
						<i class="fa fa-file-excel-o"></i> 엑셀
					</button>
				</div>
			</th>
		</tr>
		<th colspan="4" class="smart-form">
			<div style="height: 90%; width: 32%; margin: auto;">
				<canvas id="doughnutChart"></canvas>
			</div>
		</th>
		
		<tr>
			<th style="text-align: center">${visitorCase}</th>
			<th style="width:60%;">그래프</th>
			<th style="text-align: center">접속자수</th>
			<th style="text-align: center">비율</th>
		</tr>
	</thead>
	<tbody>
		<script>
			var list_content = new Array();
			var list_persent = new Array();
		</script>
 		<c:forEach items="${html }" var="model">
			<tr> 
				<c:if test="${visitorCase eq '도메인' || visitorCase eq '브라우저' || visitorCase eq '운영체제' }">
				
				<td>${model.no}</td>
				</c:if>
				
				<c:set var="contents" value="${model.CONTENT }"/>
				
				<c:if test="${fn:length(contents) > '30' }">
					<td>알수없는 주소</td>
				</c:if>
 				<c:if test="${fn:length(contents) <= '30' }">
					<td>${contents }</td>
				</c:if>
 				
 				<script>
 					list_content.push("${fn:substring(model.CONTENT,0,30) }");
 				</script> 
				<td><div class='visitor_bar chart'><span class="bar" data-number="${model.persent }"></span></div></td>
				<td>${model.COUNT }</td> 
				<td>${model.persent }%</td>
				<script>
 					list_persent.push("${model.persent}");
 				</script> 
 			</tr>
		</c:forEach> 
	</tbody>
	<c:if test="${total ne '0'}">
		<tfoot id="footercolumn">
			<tr>
				<th colspan="2" style="text-align: center">total</th>
				<th style="text-align: center">${total }</th>
				<th style="text-align: center">100%</th>
			</tr>
		</tfoot>
	</c:if>
</table>


<script>
$(function(){
	$('input[name=STM_ORDER]').on('change',function(){
		pf_getHtml();
	})
})

</script>

<script src="/resources/smartadmin/js/plugin/Chart/Chart.min.js"></script>
<script>
	
$(function(){
	var list_ten = []
	var list_persent_ten = []
	var list_etc = 0;
	for (var i = 0; i < list_content.length; i++) {
		if (i < 10) {
			if (list_content[i] != null) {
				list_ten.push(list_content[i])
				list_persent_ten.push(list_persent[i])
			}
		} else {
			list_etc += Number(list_persent[i])
		}
	}
	list_ten.push("기타")
	list_persent_ten.push(list_etc)

	var list_color = [ "#F7464A", "#46BFBD", "#FDB45C", "#949FB1", "#4D5360",
			"#8878CD", "#D2E1FF", "#C1FF6B", "#FF7DC8", "#FF7493", "#FFA500"]
	
	var ctxD = document.getElementById("doughnutChart").getContext('2d');

	var myLineChart = new Chart(ctxD, {
		type : 'pie',
		data : {
			labels : list_ten,
			datasets : [ {
				data : list_persent_ten,
				backgroundColor : list_color
			} ]
		},
		options : {
			responsive : true
		},
	});
})
</script>