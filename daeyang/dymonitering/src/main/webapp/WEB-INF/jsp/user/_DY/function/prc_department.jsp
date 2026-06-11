<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
					             

				        
					

<div class="subRealContentsBox subGroupIntroWrap clearfix">                      	
    <div class="searchBox_01">
        <div class="inner clearfix">
        	<span class="searchPerson_Span">직원검색 </span>
        	<select class="selectDefault mobileW100" name="searchCondition" id="searchCondition" title="검색 할 내용 선택">
	            <option value="A">담당자</option>
	            <option value="B">전화번호</option>
	            <option value="C">담당업무</option>
	            <option value="D">부서명</option>
            </select>
            <input type="text" class="txtDefault mobileW100 txtWmiddle" placeholder="검색어를 입력하세요" name="searchKeyword" id="searchKeyword" onkeydown="if(event.keyCode == 13) pf_orgSearch();" title="검색어를 입력하세요">
            <button type="button" class="btn btnSmall_01 mobileW100" onclick="pf_orgSearch();">검색</button>
        </div>
    </div>
                                                           	
    <div class="subRealTitleBox">
        <h1>조직구성도 <span class="titleSubSpan">· 1처2실1단2관</span></h1>
    </div>
    <div class="groupGrapBoxWrap clearfix">
    	<div class="toplogoBox">
        	<img src="/resources/img/icon/icon_subGroupPage_topCircle.png" alt="풍선 로고">
        </div>
        <div class="middleGroupBox">
        	<p class="groupTitle bgColorDeepOrange">
                <a href="#">이사장<span class="small">(광주광역시장)</span></a>
                <span class="name leftFirst"><a href="#">이사회(감사)</a></span>
            </p>
        	<p class="groupTitle bgColorOrange">
            	<a href="javascript:;" onclick="pf_orgSearch('대표이사')">대표이사</a>
            	<span class="name rightSecond"><a href="#">자문위원회</a></span>  
            </p>                                                              
        	<p class="groupTitle">
            	<a href="javascript:;" onclick="pf_orgSearch('사무처장')">사무처장</a>
                <span class="name leftThird"><a href="#">보조·수탁심의위원회</a></span>
            </p>                                
        </div>
        <div class="bottomGroupBox clearfix">
       	<c:forEach items="${orgList}" var="model">
   		<c:if test="${model.DN_MAINKEY eq 'DN_0000000064' && model.DN_TEMP eq 'N' }"> <!-- 사무처장 KEY -->
   		<fmt:parseNumber value="${fn:substring(model.DN_KEYNO, 4, 20)}" var="DN_KEYNO_NUMBERTYPE" />
   			<div class="col_01">
           	   <h1>
               	<a href="javascript:;" onclick="pf_orgSearch('${model.DN_NAME }')" style="margin: 5px;">${model.DN_NAME }</a>
               </h1>
               <ul class="groupSeparateUl ${model.DN_COUNT_DEPARTMENT eq 4 ? 'groupSeparateUl_04':model.DN_COUNT_DEPARTMENT eq 2 ? 'groupSeparateUl_02':''}">
               <c:forEach items="${orgList}" var="model2">
   			   <c:if test="${model2.DN_MAINKEY eq model.DN_KEYNO && model2.DN_TEMP eq 'N'}">
   			   <fmt:parseNumber value="${fn:substring(model2.DN_KEYNO, 4, 20)}" var="DN_KEYNO_NUMBERTYPE" />
               	<li><a href="javascript:;" onclick="pf_orgSearch('${model2.DN_NAME }')">${model2.DN_NAME }</a></li>
               </c:if>
               </c:forEach>
               </ul>
           </div>
   		</c:if>
   		</c:forEach>
        </div>
    </div>                                        	
    <div class="subRealTitleBox">
        <h1>업무상세표 <span class="titleSubSpan">· 2017.05.19 기준</span></h1>
    </div>
    <div class="subRealSubTitleBox_02" id="groupCEO">
    	<h2 class="colorRightBlue"><font class="depMarker">◇</font> <font class="depName">대표이사</font></h2>
    </div>
    <div class="table_wrap_mobile02">
    	<table class="tbl_03 tbl_borTopBlue tbl_Group_01">
        	<caption>조직도</caption>
            <thead>
            	<tr>
                	<th>직위</th>
                	<th>이름</th>
                	<th>담당업무</th>
                	<th>전화 및 팩스 번호</th>
                </tr>
            </thead>
            <tbody>
            	<c:forEach items="${orgPersonList}" var="model2">
	             <c:if test="${model2.DU_KEYNO eq 'DU_0000000009'}"> <!-- 대표이사 KEY -->
	             	<fmt:parseNumber value="${fn:substring(model2.DU_KEYNO, 4, 20)}" var="DU_KEYNO_NUMBERTYPE" />
	            	<tr id="person${DU_KEYNO_NUMBERTYPE}">
	                	<td class="conditionC">${model2.DU_ROLE }</td>
	                	<td class="conditionA">${model2.DU_NAME }</td>
	                	<td class="conditionC">
	                		<pre>${model2.DU_CONTENTS }</pre>
	                    </td>
	                	<td class="conditionB">
	                    	<pre>${model2.DU_TEL }</pre>
	                    </td>
	                </tr>
                </c:if>
                </c:forEach>
            </tbody>
        </table>
    </div>
    <div class="subRealSubTitleBox_02" id="groupOWA">
    	<h2 class="colorRightBlue"><font class="depMarker">◇</font> <font class="depName">사무처장</font></h2>
    </div>
    <div class="table_wrap_mobile02">
    	<table class="tbl_03 tbl_borTopBlue tbl_Group_01">
        	<caption>조직도</caption>
            <thead>
            	<tr>
                	<th>직위</th>
                	<th>이름</th>
                	<th>담당업무</th>
                	<th>전화 및 팩스 번호</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${orgPersonList}" var="model2">
	             <c:if test="${model2.DU_KEYNO eq 'DU_0000000010'}"> <!-- 사무처장 KEY -->
	             	<fmt:parseNumber value="${fn:substring(model2.DU_KEYNO, 4, 20)}" var="DU_KEYNO_NUMBERTYPE" />
	            	<tr id="person${DU_KEYNO_NUMBERTYPE}">
	                	<td class="conditionC">${model2.DU_ROLE }</td>
	                	<td class="conditionA">${model2.DU_NAME }</td>
	                	<td class="conditionC">
	                		<pre>${model2.DU_CONTENTS }</pre>
	                    </td>
	                	<td class="conditionB">
	                    	<pre>${model2.DU_TEL }</pre>
	                    </td>
	                </tr>
                </c:if>
                </c:forEach>
            </tbody>
        </table>
    </div>
    
    
    <c:forEach items="${orgList}" var="model">
    	<c:if test="${model.DN_MAINKEY eq 'DN_0000000064'}"> <!-- 사무처장 KEY -->
    	<fmt:parseNumber value="${fn:substring(model.DN_KEYNO, 4, 20)}" var="DN_KEYNO_NUMBERTYPE" />
		<div class="subRealSubTitleBox_02" id="group${ DN_KEYNO_NUMBERTYPE}">
	    	<h2 class="colorRightBlue"><font class="depMarker">◇</font><font class="depName">${model.DN_NAME }</font> <span class="titleSubSpan_02">(
	    	<c:set var="subOrgCnt" value="first"/>
	    	<c:forEach items="${orgList}" var="model2" varStatus="status">
	    	<c:if test="${model2.DN_MAINKEY eq model.DN_KEYNO}">
	    		<c:choose>
	    			<c:when test="${subOrgCnt eq 'first' }">
			    		<c:set var="subOrgCnt" value="not"/>
		    		</c:when>
		    		<c:when test="${subOrgCnt ne 'first' }">
			    		, 
		    		</c:when>
	    		</c:choose>
	    		${model2.DN_NAME }
	    	</c:if>
	    	</c:forEach>
	    	<c:if test="${subOrgCnt eq 'first' }">
	    	<span class="empty"></span>
	    	</c:if>
	    	)</span></h2>
	    </div>
	    <div class="table_wrap_mobile02">
	    	<table class="tbl_03 tbl_borTopBlue tbl_Group_01">
	        	<caption>조직도</caption>
	            <thead>
	            	<tr>
	                	<th>직위</th>
	                	<th>이름</th>
	                	<th>담당업무</th>
	                	<th>전화 및 팩스 번호</th>
	                </tr>
	            </thead>
	            <tbody>
	             <c:forEach items="${orgPersonList}" var="model2">
	             <c:if test="${model2.DU_DN_KEYNO eq model.DN_KEYNO}">
	             	<fmt:parseNumber value="${fn:substring(model2.DU_KEYNO, 4, 20)}" var="DU_KEYNO_NUMBERTYPE" />
	            	<tr id="person${DU_KEYNO_NUMBERTYPE}">
	                	<td class="conditionC">${model2.DU_ROLE }</td>
	                	<td class="conditionA">${model2.DU_NAME }</td>
	                	<td class="conditionC">
	                		<pre>${model2.DU_CONTENTS }</pre>
	                    </td>
	                	<td class="conditionB">
	                    	<pre>${model2.DU_TEL }</pre>
	                    </td>
	                </tr>
                </c:if>
                </c:forEach>
	            </tbody>
	        </table>
	    </div>
	    
	    
	    
	    <c:forEach items="${orgList}" var="model2">
	    <c:if test="${model2.DN_MAINKEY eq model.DN_KEYNO}">
	    	<fmt:parseNumber value="${fn:substring(model2.DN_KEYNO, 4, 20)}" var="DN_KEYNO_NUMBERTYPE2" />
		    <div class="subRealSubTitleBox_03 group${ DN_KEYNO_NUMBERTYPE}" id="group${ DN_KEYNO_NUMBERTYPE2}">
		    	<h2 class="colorOrange subRealSubTitleBox_02"><span class="depMarker colorOrange">●</span> <font class="depName">${model2.DN_NAME }</font><font style="display:none"></font> <span class="depMarker colorOrange">●</span></h2>
		    </div>
		    <div class="table_wrap_mobile02">
		    	<table class="tbl_03 tbl_Group_01">
		        	<caption>조직도</caption>
		            <thead>
		            	<tr>
		                	<th>직위</th>
		                	<th>이름</th>
		                	<th>담당업무</th>
		                	<th>전화 및 팩스 번호</th>
		                </tr>
		            </thead>
		            <tbody>
		            	<c:forEach items="${orgPersonList}" var="model3">
			             <c:if test="${model3.DU_DN_KEYNO eq model2.DN_KEYNO}">
			             <fmt:parseNumber value="${fn:substring(model3.DU_KEYNO, 4, 20)}" var="DU_KEYNO_NUMBERTYPE" />
			            	<tr id="person${DU_KEYNO_NUMBERTYPE}">
			                	<td class="conditionC">${model3.DU_ROLE }</td>
			                	<td class="conditionA">${model3.DU_NAME }</td>
			                	<td class="conditionC">
			                		<pre>${model3.DU_CONTENTS }</pre>
			                    </td>
			                	<td class="conditionB">
			                    	<pre>${model3.DU_TEL }</pre>
			                    </td>
			                </tr>
		                </c:if>
		                </c:forEach>
		            </tbody>
		        </table>
		    </div>
	    </c:if>
    	</c:forEach>
	    
	    
	    </c:if>
	</c:forEach>
</div>                  

<script>
$(function(){
	$('.empty').parent('.titleSubSpan_02').hide();
})


//검색
function pf_orgSearch(depName){
	if(depName){
		$('#searchCondition').val('D')
		$('#searchKeyword').val(depName)
	}
	
	var searchCondition = $('#searchCondition').val();
	
	var keyword = $('#searchKeyword').val();
	
	
	
	
	
	$('.table_wrap_mobile02').show(); // 일단 모든 테이블 show
	
	$('font.searchKeyword').each(function(){ // 기존 하이라이트 제거
		$wrap = $(this).parent();
		var temp = $wrap.text();
		$wrap.html(temp);
	});
	
	if(!keyword){ // 검색어가 없으면 전체 보여줌
		$('div[id^=group], tr[id^=person]').show();
	}else{
		
		if(searchCondition == 'D'){ //부서검색일시
			pf_orgSearchWithDepName(keyword)
			return false;
		}
		
		$('div[id^=group], tr[id^=person]').hide();
		
		var className = '.condition'+searchCondition;
		$(className).each(function(){ // 검색결과 필터링
			if($(this).html().includes(keyword.trim())){ 
				$(this).parents('tr').show(); // 해당 사원 show
				$(this).parents('.table_wrap_mobile02').prev().show(); //해당 사원의 부서 show
				
				var temp = $(this).html(); // 검색결과 하이라이트
				temp = temp.replaceAll(keyword , '<font class="searchKeyword">'+keyword+'</font>');
				$(this).html(temp);
				
			}
		})
	}
	
	$('.table_wrap_mobile02').each(function(){ // 검색된 사원이 없는 table hide
		if($(this).find('tbody tr:visible').length == 0){
			$(this).hide();
		}
	})
	if($(".table_wrap_mobile02:visible").length > 0){ //검색된 사원중 첫번째 부서명으로 위치 이동
		var offset = $(".subRealTitleBox").eq(1).offset();
	    $('html, body').animate({scrollTop : offset.top- 25}, 400);
	}else{ // 검색결과가 없으면 모든 사원 보여줌
		alert('검색결과가 없습니다.');
		$('.table_wrap_mobile02, div[id^=group], tr[id^=person]').show();
	}
}

//부서 검색
function pf_orgSearchWithDepName(keyword){
	$('div[id^=group], .table_wrap_mobile02').hide();
	$('tr[id^=person]').show();
	
	$('div[id^=group]').each(function(){
		if($(this).find('.depName').text().includes(keyword.trim())){ 
			$(this).show();
			$(this).next().show();
			if($(this).hasClass('subRealSubTitleBox_02')){ //상위부서일시 하위부서까지 보여줌
				var id = $(this).attr('id');
				$('.'+id).each(function(){
					$(this).show();
					$(this).next().show();
				})
			}
		}
	})
	
	if($("div[id^=group]:visible").length > 0){ //검색된 부서 첫번째 부서명으로 위치 이동
		var offset = $(".subRealTitleBox").eq(1).offset();
	    $('html, body').animate({scrollTop : offset.top - 25}, 400);
	}else{ // 검색결과가 없으면 모든 사원 보여줌
		alert('검색결과가 없습니다.');
		$('.table_wrap_mobile02, div[id^=group], tr[id^=person]').show();
	}
}
</script>