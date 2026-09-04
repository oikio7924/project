var index = 0;

$(document).ready(function(){
	
	$('#agree_notice').change(function(){
		$('.agreement_next').show();
		$('.agreement_next').focus();   
		$('.agreement').hide();
	});
	
	// 교통편 초기 설정
	$("#GR_OR_TRAFFIC_EXP").attr("disabled", true);
	$("input[name=GR_OR_TRAFFIC]").change(function() {
		var div = $(this).val();
		if(div == 'D'){
			$("#GR_OR_TRAFFIC_EXP").attr("disabled", false);
		} else {
			$("#GR_OR_TRAFFIC_EXP").attr("disabled", true);
		}
	});
	
	//교통편 버스 선택시 상세내용 input show
	$('.bus_info').hide();
	$('input[name="GR_OR_TRAFFIC"]').change(function(){
		if($(this).val() == 'C'){
			$('.bus_info').show();
		}else{
			$('.bus_info').hide();
		}
	});
	
	$('#GR_BU_INDEX').change(function(){
		$('.bus_temp').not(':first').remove();
		index = Number($(this).val());
		var clone=$('.bus_temp').clone();
		for(var i=1;i<=index;i++){
			$('.bus_temp').first().clone().appendTo('.bus_info_input').show();
			$('.bus_index').last().text(i+'번째 버스');
		}
		
	});
	
	
});


function checkBusInfo(){
	var result = false;
	$('.bus_temp').not(':first').each(function(){
		if(result){
			return;
		}
		if($(this).find(".GR_BU_LOCATION").val() == ''){
			alert("주차 위치를 입력하세요.");
			$(this).find(".GR_BU_LOCATION").focus();
			result = true;
			return;
		}else if($(this).find(".GR_BU_KIND").val() == ''){
			alert("차량(인승)을 입력하세요.");
			$(this).find(".GR_BU_KIND").focus();
			result = true;
			return;
		}else if($(this).find(".GR_BU_NUMBER").val() == ''){
			alert("차량번호를 입력하세요.");
			$(this).find(".GR_BU_NUMBER").focus();
			result = true;
			return;
		}else if($(this).find(".GR_BU_NAME").val() == ''){
			alert("차주 성함을 입력하세요.");
			$(this).find(".GR_BU_NAME").focus();
			result = true;
			return;
		}else if($(this).find(".GR_BU_PHONE_1").val() == '' || $(this).find(".GR_BU_PHONE_2").val()  == ''|| $(this).find(".GR_BU_PHONE_3").val() == ''){
			alert("차주 휴대폰번호를 입력하세요.");
			$(this).find(".GR_BU_PHONE_1").focus();
			result = true;
			return;
		} else {
			$(this).find(".GR_BU_PHONE").val($(this).find(".GR_BU_PHONE_1").val()+"-"+$(this).find(".GR_BU_PHONE_2").val()+"-"+$(this).find(".GR_BU_PHONE_3").val());	
		}
	});
	return result;
	
}


function gonyImgWin(img){ 
    var imgTmp = new Image(); 
    imgTmp.src = img; 

    var imgWin = window.open("","gImgWin","width="+imgTmp.width+",height="+imgTmp.height+",status=no,toolbar=no,scrollbars=no,resizable=no"); 
    imgWin.document.write("<html><title>미리보기</title>" 
    +"<body topmargin=0 leftmargin=0 marginheight=0 marginwidth=0>" 
    +"<img onclick='window.close()' src="+img+" width="+imgTmp.width+" height="+imgTmp.height+" border=0>" 
    +"</body></html>"); 
} 