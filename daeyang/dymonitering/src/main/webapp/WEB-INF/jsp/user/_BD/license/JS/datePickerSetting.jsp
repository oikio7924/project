<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>
<script type="text/javascript">

function datePickerSetting(){
	
	var idname = ["bd_plant_BusDueDate","bd_plant_BusStart","bd_plant_BusEndDate","bd_plant_DevStartDate","bd_plant_DevEndDate","bd_plant_DevCompletionDate","bd_plant_OperationStartDate","bd_plant_PPADate"];
	
	idname.forEach(function(i) {
		$("#"+i+"").daterangepicker({
			singleDatePicker : true,
			autoApply : true,
			locale:{
				"format": "YYYY-MM-DD",
				"daysOfWeek": ["일","월","화","수","목","금","토"],
		        "monthNames": ["1월","2월","3월","4월","5월","6월","7월","8월","9월","10월","11월","12월"],
			},
			showDropdowns : true
		});	
	});
}

</script>