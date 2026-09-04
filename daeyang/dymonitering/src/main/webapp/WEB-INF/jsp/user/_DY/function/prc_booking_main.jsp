<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<style>

.btn_margin{
 margin: 10px;
}

.UserList {display:none;}

</style>

<!-- widget grid -->
<section id="widget-grid" class="">
	<!-- row -->
	<div class="row">

		<!-- NEW WIDGET START -->
		<article class="col-xs-12 col-sm-12 col-md-12 col-lg-12">

			<!-- Widget ID (each widget will need unique ID)-->
			<div class="jarviswidget jarviswidget-color-darken" id="wid-id-0"
				data-widget-editbutton="false">
				<header>
					<span class="widget-icon"> <i class="fa fa-table"></i>
					</span>

				</header>
				<!-- widget div-->
				<div>

					<!-- widget content -->
					<div class="widget-body no-padding">

					  	<div role="content">
							
							<div class="table-responsive">
												
								<table class="table table-hover" >
									<thead>
										<tr>
											<th width="5%"></th>
											<th width="70%">제 목</th>
											<th width="5%"></th>
											<th width="5%"></th>
											<th width="5%"></th>
										</tr>
									</thead>
									<tbody>
									 <c:forEach items="${BSM_List}" var="list">
									  <c:set var="num" value="${num1}"></c:set>
									  <c:set var="num1" value="${num+1}"></c:set>
										<tr>
											<td>${num1}</td>
											<td>${list.BSM_TITLE}</td>
											<input type="hidden" value="${list.BSM_KEYNO}">											
											<c:if test="${list.BSS_COUNT ne '1' }">
											<td><input type="button" class="btnSmall_02 bgColorR" value="마감"></td>
											</c:if>
											<c:if test="${list.BSS_COUNT eq '1' }">
											<td><input type="button" class="btnSmall_02 bgColorDeepOrange" value="예약 신청" onclick="pf_booking_view('${list.BSM_KEYNO}')"></td>
										    </c:if>
										</tr>
									 </c:forEach>																								
									</tbody>
								</table>
								
							</div>		

						</div>				

					</div>
					<!-- end widget content -->

				</div>
				<!-- end widget div -->

			</div>
			<!-- end widget -->
		</article>
		<!-- WIDGET END -->

	</div>

	<!-- end row -->
	
	<div class="row" style="width: 60%">

		<!-- NEW WIDGET START -->
		<article class="col-xs-12 col-sm-12 col-md-12 col-lg-12 UserList">

			<!-- Widget ID (each widget will need unique ID)-->
			<div class="jarviswidget jarviswidget-color-darken" id="wid-id-0"
				data-widget-editbutton="false">
				<header>
					<span class="widget-icon"> <i class="fa fa-table"></i>
					</span>
					<h2>예약 신청자 리스트</h2>

				</header>
				<!-- widget div-->
				<div>

					<!-- widget content -->
					<div class="widget-body no-padding">

					  	 <div role="content">
	
							<label class="input"> <i class="icon-append fa fa-user"></i>
								<input type="text" name="UI_NAME" id="UI_NAME" placeholder="Name">
							</label>									
							
		                   <input class="btn_margin btn btn-sm btn-primary" type="button" value="조 회" onclick="pf_booking_userSearch()">
							
							<div class="table-responsive">
												
								<table class="table table-hover">
									<thead>
										<tr>
											<th width="5%"></th>
											<th width="30%">아이디</th>
											<th width="30%">이 름</th>
											<th width="10%">날 짜</th>
											<th width="10%">시 간</th>
											<th width="5%">삭 제</th>
										</tr>
									</thead>
									<tbody>
																							
									</tbody>
								</table>
								
							</div>		

						</div>				 

					</div>
					<!-- end widget content -->

				</div>
				<!-- end widget div -->

			</div>
			<!-- end widget -->
		</article>
		<!-- WIDGET END -->

	</div>
	<!-- end row -->

</section>
<!-- end widget grid -->

<script type="text/javascript">
	
$(document).ready(function(){
   
})

//예약신청 페이지 이동
 function pf_booking_view(key){
	 
	 location.href="/dy/function/booking_view.do?key="+key;	 
	 
 }
	
</script>