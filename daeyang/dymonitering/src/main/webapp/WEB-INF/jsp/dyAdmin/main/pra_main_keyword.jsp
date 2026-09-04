<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>



<script>

$(document).ready(function(){
	getKeywordCountHtml('${id}');
});


function getKeywordCountHtml(id,stdt,endt){
	stdt = stdt || ''
	endt = endt || ''

	
	$.ajax({
		type : "post",
		url : "/dyAdmin/main/keywordCount/DataAjax.do", 
		data : {"STDT":stdt,
				"ENDT":endt},
		success : function(data) {
			$("#"+id +" #keywordTable tbody").empty().html(data.keywordObject);
			$("#"+id +" #totalKeyword").empty().append("총 키워드"+data.keywordListCnt +"건")
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


//기간별 체크
function setKeywordListAjax(obj,id,type){
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
		getKeywordCountHtml(id,stdt.format("yyyy-MM-dd"),endt.format("yyyy-MM-dd"));
	}else{
		getKeywordCountHtml(id);
	}

	$(obj).closest('.keywordCountUl').find('li').removeClass('active');
	$(obj).closest('li').addClass('active');
}

</script>
<div class="tit-box">
	<p class="tit">키워드 리스트</p>
		<ul class="dash-tab1 keywordCountUl">
			<li class="active"><a href="javascript:;" onclick="setKeywordListAjax(this,'${id}')">전체</a></li>
			<li><a href="javascript:;" onclick="setKeywordListAjax(this,'${id}','T')">오늘</a></li>
			<li><a href="javascript:;" onclick="setKeywordListAjax(this,'${id}','W')">일주일</a></li>
			<li><a href="javascript:;" onclick="setKeywordListAjax(this,'${id}','M')">한달</a></li>
		</ul>
	<%@ include file="/WEB-INF/jsp/dyAdmin/include/pra_import_mainSelect.jsp"%>
	
       <a href="/dyAdmin/admin/keyword.do" class="btn btn-sm btn-primary moreBtn">
    	<i class="fa fa-floppy-o"></i> 더보기
       </a>
</div>
<div class="dataEmpty">로딩중입니다.</div>
<div class="dataEmptyDiv">
	<div class="ds-festi-reservation keywordListDiv"> <!-- 키워드 리스트 -->
	    <p id="totalKeyword"></p>
		<div class="table-box">
			<div class="t-col-1">
				<table class="tbl_da_sm" id="keywordTable">
					<colgroup>
						<col width="10%;">
						<col width="auto;">
						<col width="10%;">
					</colgroup>
					<thead>
						<tr>
							<th>번호</th>
							<th>키워드</th>
							<th>검색수</th>
						</tr>
					</thead>
					<tbody>
					</tbody>
				</table>
			</div>
		</div>
	</div>
</div> 
