
$(function(){
	$("#researchRusult").attr("class", 'listNone');
	$("#researchRusult").css({
        "top": ($('.sub-survey-box').position().top)+"px"
     });
});
function pf_insert(){
	var checkval = $("input[type=radio][name=TPS_SCORE]:checked").val()
	if(checkval == "5")
		$("#TPS_SCORE_NAME").val("매우만족");
	if(checkval == "4")
		$("#TPS_SCORE_NAME").val("만족");
	if(checkval == "3")
		$("#TPS_SCORE_NAME").val("보통");
	if(checkval == "2")
		$("#TPS_SCORE_NAME").val("불만족");
	if(checkval == "1")
		$("#TPS_SCORE_NAME").val("매우불만족");
	
	var menu = $("#TPS_MN_KEYNO").val();
	var satisfaction = $("input[name=TPS_SCORE]:radio:checked").val();
	if(!satisfaction){
		alert("만족도를 선택하세요.");
		return false;
	}

	$.ajax({
	    type   : "POST",
	    url    : "/common/page/satisfaction/satisfactionInsert.do",
	    data   : $("#PageForm").serialize(),
	    async:false,
	    success:function(result){
// 	    	$("input:radio[name='TPS_SCORE']").removeAttr('checked');
	    	$(".textAreaHealing").val("");
	    	if(result == 1){
	    		alert("평가가 완료되었습니다.");
// 	    		$("input[type=radio][name=TPS_SCORE][value='5']").prop('checked',true);
	    	}else if(result == 0){
	    		alert("평가는 하루에 한번씩만 가능합니다.");
	    	}
	    },
	    error: function() {
	    	alert("에러, 관리자에게 문의하세요.");
	    }
	});

}

//결과보기
function pf_PointTow(point, type){
	var className = $("#"+point).attr('class');
	var key = $("#TPS_MN_KEYNO").val();
	if(type == 'R'){
		$.ajax({
		      type: "POST",
		      url: "/common/page/satisfaction/satisfactionResult.do",
		      data: {
		    	  "TPS_MN_KEYNO" : key
		      },
		      success : function(data){
	    		var dataList = data.resultData;
				var total = 0;
				var max = 0;
				var maxScore = 5;
				var maxScoreNM = "매우만족";
	    		$.each(dataList, function(j){
		    		datas = dataList[j];	
		    		$(".bar_list").find("#value0"+datas.TPS_SCORE).text(datas.COUNT+"표").css("width", datas.COUNT+"0%");
		    		total += datas.COUNT;
		    		if(max < datas.TPS_SCORE){
		    			max = datas.COUNT;
		    			maxScoreNM = datas.TPS_SCORE_NAME;
		    		} 
		    	});
	    	
	    		$(".scoreName").text(maxScoreNM);
	    		$(".scoreCnt").text(max+"표");
	    		$("#Participants").text("(참여인원:"+total+"명)");
	    		$("#Participants2").text("총 "+total+"명");
	    		$('#researchRusult').show();
		      }, 
		      error: function(){
		        return false;
		      }
		    });
	}
	
	if(className != 'listNone'){
		$("#"+point).attr("class", 'listNone');
	}else{
		$("#"+point).attr("class", 'listBlock');		
	}
}
