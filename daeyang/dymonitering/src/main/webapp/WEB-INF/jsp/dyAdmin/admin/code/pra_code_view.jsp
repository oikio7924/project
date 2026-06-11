<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>
<!-- MAIN CONTENT -->
<div id="content">
	<!-- START ROW -->
	<section id="widget-grid" >
		<div class="row">
			<!-- 좌측 시작 -->
			<article class="col-sm-12 col-md-12 col-lg-12">
				<div class="jarviswidget jarviswidget-color-green"
					id="BOARD_CODE_VIEW1" data-widget-editbutton="false">
					<header>
						<span class="widget-icon"> <i class="fa fa-cog"></i></span>
						<h2>메인코드 보기</h2>
					</header>
					<div>
						<div class="jarviswidget-editbox"></div>
							<div class="widget-body-toolbar bg-color-white">
						<div class="alert alert-info no-margin fade in">
									<button type="button" class="close" data-dismiss="alert">×</button>
									메인코드 리스트를 확인합니다.
								</div> 
							</div>	
						
						<div class="widget-body">
							<div class="widget-body-toolbar  no-padding bg-color-white">
								<div class="row text-right smart-form">
									<div class="btn-group">  
										<button class="btn btn-sm btn-primary" type="button" onclick="pf_CodeRegist()">
											<i class="fa fa-plus"></i> 메인코드 추가하기
										</button> 
									</div>
								</div>
							</div>
							<div class="table-responsive">
								<table class="table table-bordered table-hover ">
									<thead>
										<tr>
											<th>코드명칭</th>
											<th>코드값</th>
											<th>사용여부</th>
											<th>등록일자</th>
											<th>변경일자</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach items="${list}" var="list">
											<tr> 
												<td>
													<a href="/dyAdmin/func/sub/code.do?MC_IN_C=${list.MC_IN_C }">
														<code class="padding-5 ">
															${list.MC_CODENM }
														</code>
													</a>
												</td>
												<td>${list.MC_IN_C}</td>
												<td>
													<c:if test="${list.MC_USE_YN=='Y'}">
														사용중
													</c:if>
													<c:if test="${list.MC_USE_YN== 'N'}">
														미사용중
													</c:if>
												</td>
												<td>${fn:substring(list.MC_REGDT,0,19)}</td>
												<td>
													<c:if test="${empty list.MC_MODDT }">
														변경기록없음
													</c:if>
													<c:if test="${not empty list.MC_MODDT }">
														${fn:substring(list.MC_MODDT,0,19)}
													</c:if>
												</td>
											</tr>
										</c:forEach>
									</tbody>
								</table>
							</div>
						</div>
						<!-- end widget content -->
					</div>
					<!-- end widget div -->
				</div>
			</article>
		</div>
	</section>
</div>
<!-- END MAIN CONTENT -->

<script type="text/javascript">
	function pf_CodeRegist(){
		location.href="/dyAdmin/admin/code/sub/insertView.do";
	}
</script>