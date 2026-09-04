<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<style>
.com_div{overflow:hidden;}
      .com_div .com_data.hidden{
         white-space:nowrap;
         word-wrap:normal;
         width:90%;
         overflow:hidden;
         text-overflow: ellipsis;
         float:left;
         
      }
      
      .btn-moreInfo{display:none;white-space:nowrap;float:right;}
      
      @media screen and (max-width: 533px){
         .com_div .com_data.hidden{
            width:75%;
         }
      }
</style>

<div class="pageNumberBox">
	<c:if test="${not empty resultList }">
		<div class="col-sm-6 col-xs-12" style="line-height: 35px; text-align: left;">
			<span class="pagetext">총 ${paginationInfo.totalRecordCount }건  / 총 ${paginationInfo.totalPageCount} 페이지 중 ${paginationInfo.currentPageNo} 페이지 </span>
		</div>
		<div class="col-sm-6 col-xs-12 middlePage" style="text-align: right;">
				<ul class="pageNumberUl" >
					<ui:pagination paginationInfo="${paginationInfo }" type="normal_board" jsFunction="pf_LinkPage" />
			    </ul>
		</div>
    </c:if>
    <c:if test="${empty resultList }">
		<div class="col-sm-6 col-xs-12" style="line-height: 35px; text-align: left;">
		<span class="pagetext">0건 중 0~0번째 결과(총  ${paginationInfo.totalRecordCount }건중 매칭된 데이터)</span>
		</div>
    </c:if>
    <div style="clear: both"></div>
</div>

<c:set var="colspan" value="6"/>

<div class="tableMobileWrap">
<table id="dt_basic" class="pagingTable table table-striped table-bordered table-hover" width="100%">
	<thead>
		<%-- 모든필드 , 게시글 갯수 시작  --%>
		<tr>
			<th colspan="${colspan}">
				<div style="float:left;">
					<input type="text" class="form-control search-control" data-searchindex="all" placeholder="모든필드 검색" style="width:200px;display: inline-block;" />
					<button class="btn btn-sm btn-primary smallBtn" type="button" onclick="pf_LinkPage()" style="margin-right:10px;">
						<i class="fa fa-plus"></i> 검색
					</button>
				</div>
				<div style="float:right;">
					<button type="button" class="btn btn-sm btn-primary" onclick="pf_excel()">
						<i class="fa fa-file-excel-o"></i> 엑셀
					</button>
					<select name="pageUnit" id="pageUnit" style="width:50px;display:inline-block; vertical-align: top;height: 31px;" onchange="pf_LinkPage();">
				    	<option value="10" ${10 eq search.pageUnit ? 'selected' : '' }>10</option>
				    	<option value="25" ${25 eq search.pageUnit ? 'selected' : '' }>25</option>
				    	<option value="50" ${50 eq search.pageUnit ? 'selected' : '' }>50</option>
				    	<option value="75" ${75 eq search.pageUnit ? 'selected' : '' }>75</option>
				    	<option value="100" ${100 eq search.pageUnit ? 'selected' : '' }>100</option>
				    </select>
			    </div>
			</th>
		</tr>
		<%-- 모든필드  ,  엑셀다운, 게시글 갯수 끝  --%>
		<tr>
			<th class="hasinput">
				<input type="text" class="form-control search-control" data-searchindex="1" placeholder="번호 검색" />
			</th>
						<th class="hasinput">
				<input type="text" class="form-control search-control" data-searchindex="2" placeholder="페이지 검색" />
			</th>
			<th class="hasinput">
				<select class="form-control search-control" data-searchindex="3" style="width:100%;" onchange="pf_LinkPage()">
		            <option value="">전체</option>
		            <option value="매우 만족">매우 만족</option>
		            <option value="만족">만족</option>
		            <option value="보통">보통</option>
		            <option value="불만족">불만족</option>
		            <option value="매우 불만족">매우 불만족</option>
	          	</select>
			</th>
			<th class="hasinput">
				<input type="text" class="form-control search-control" data-searchindex="4" placeholder="IP 검색" />
			</th>
			<th class="hasinput">
				<input type="text" class="form-control search-control" data-searchindex="5" placeholder="코멘트 검색" />
			</th>
			<th class="hasinput">
				<input type="text" class="form-control search-control" data-searchindex="6" placeholder="평가일 검색" />
			</th>

		
		</tr>
		<%-- 화살표 정렬 --%>
		<tr>
			<th class="arrow" data-index="1">번호</th>
			<th class="arrow" data-index="2">페이지</th>
			<th class="arrow" data-index="3">만족도</th>
			<th class="arrow" data-index="4">IP</th>
			<th class="arrow" data-index="5" style="width:50%;">코멘트</th>
			<th class="arrow" data-index="6">평가일</th>
		</tr>
	</thead>
	<tbody>
		<c:if test="${empty resultList }">
			<tr>
				<td colspan="${colspan}">검색된 데이터가 없습니다.</td>
			</tr>
		</c:if>
		<c:forEach items="${resultList }" var="model">
		<tr>
		<fmt:parseNumber value="${fn:substring(model.TPS_MN_KEYNO,4,20)}" var="mnKey"/>
			<td>${model.COUNT }</td>
			<td>${model.MN_NAME}</td>
			<td>${model.TPS_SCORE_NAME }</td>
			<td>${model.TPS_IP }</td>
			<%-- <td style="text-align:left;"><div class="comment" style="width:200px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;"><c:out value="${model.TPS_COMMENT }" escapeXml="false"/></div></td> --%>
			<td>
				<div class="com_div">
					<span class="com_data">
						${model.TPS_COMMENT }
					</span>
					<span class="btn btn-sm btn-primary btn-moreInfo">자세히 보기</span>
				</div>
			</td>
			<td>${model.TPS_REGDT }</td>
		</tr>
		</c:forEach>
	</tbody>
</table>
</div>
<%-- 하단 페이징 --%>
<div class="pageNumberBox dt-toolbar-footer">
	<c:if test="${not empty resultList }">
		<div class="col-sm-6 col-xs-12" style="line-height: 35px; text-align: left;">
			<span class="pagetext">총 ${paginationInfo.totalRecordCount }건  / 총 ${paginationInfo.totalPageCount} 페이지 중 ${paginationInfo.currentPageNo} 페이지</span>
		</div>
		<div class="col-sm-6 col-xs-12" style="text-align: right;">
				<ul class="pageNumberUl" >
					<ui:pagination paginationInfo="${paginationInfo }" type="normal_board" jsFunction="pf_LinkPage" />
			    </ul>
		</div>
    </c:if>
    <c:if test="${empty resultList }">
    	<div class="col-sm-6 col-xs-12" style="line-height: 35px; text-align: left;">
		<span class="pagetext">0건 중 0~0번째 결과(총  ${paginationInfo.totalRecordCount }건중 매칭된 데이터)</span>
		</div>
    </c:if>
</div>

<script type="text/javascript">

$(function(){

	pf_defaultPagingSetting('${search.orderBy}','${search.sortDirect}');
	
	 var commentBox = $('.com_div .com_data');
     commentBox.each( function() {
        $( this ).outerHeight();
        if( $(this).outerHeight() > 20 ){
        	var chk = 1;
           $(this).addClass('hidden');
			var string = "<span class='com_data2'>"+($(this).text()).substring(0,20)+"..."+"</span>";
			   $( this ).closest('.com_div').append(string);
           var btnMoreCmt = $(this).siblings('.btn-moreInfo');
           btnMoreCmt.show();
           
            btnMoreCmt.on("click",function(){
            	if(chk == 1) {
            		$(this).text('접기');
                    $(this).siblings('.com_data').removeClass('hidden');
                    $(this).closest('.com_div').find('.com_data2').remove();
                    chk = 0;
            	} else {
            		$(this).text('자세히보기');
            		 $(this).siblings('.com_data').addClass('hidden');
            		 $(this).closest('.com_div').append(string);
            		 chk = 1;
            	}
           });
           
           
        }
     } );

})

</script>
