<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<jsp:useBean id="toDay" class="java.util.Date" scope="page"/>
<fmt:formatDate value="${toDay}" pattern="yyyy-MM-dd" var="nowDate" />

<style>

#boardDetail th {text-align:right;}
</style>


<script type="text/javascript" src="/resources/common/js/common/diff_match_patch.js"></script>

<script type="text/javascript">

//게시판 타입 수정페이지 이동
function pf_UpdateMove(keyno){
	$("#actionForm").attr("action", "/dyAdmin/homepage/board/data/actionView.do");
	$("#actionForm").submit();
}
// 리스트로 돌아가기
function pf_back(){
	$("#actionForm").attr("action", "/dyAdmin/homepage/board/dataView.do");
	$("#actionForm").submit();
}


// 게시글 삭제하기
function pf_deleteMove(del,bnkey){
	var msg ='';
	if(del == 'Y'){
		msg = '삭제 하시겠습니까?';
	}else{
		msg = '복원 하시겠습니까?';
	}
	if(confirm(msg)){
		$('#BN_DEL_YN').val(del)
		if(('${BoardType.BT_DEL_MANAGE_YN}' == 'Y' && del == 'Y' && '${BoardType.BT_DEL_POLICY}' == 'L')){
			$('#actionForm').attr('action','/dyAdmin/homepage/board/'+bnkey+'/deleteView.do');
		}else{
			$("#actionForm").attr("action", "/dyAdmin/homepage/board/data/state.do");
		}
		$("#actionForm").submit();
	}
}

// 게시글 물리삭제
function pf_deleteComp(bnkey){
	if(confirm("정말 삭제하시겠습니까?")){
		$("#actionForm").attr("action", "/dyAdmin/homepage/board/data/state.do?delComplete=true");
		$("#actionForm").submit();
	}
}

function pf_hideMove(){
	if(confirm("숨김 처리  하시겠습니까?")){
		$('#BN_USE_YN').val('N')
		$("#actionForm").attr("action", "/dyAdmin/homepage/board/data/state.do");
		$("#actionForm").submit();
	}
}
function pf_showMove(){
	if(confirm("보이기 처리  하시겠습니까?")){
		$('#BN_USE_YN').val('Y')
		$("#actionForm").attr("action", "/dyAdmin/homepage/board/data/state.do");
		$("#actionForm").submit();
	}
}

// 댓글 삭제하기
function pf_commentDelete(bc_keyno){
	if(confirm("삭제 하시겠습니까?")== true){
		$.ajax({
		    type   : "post",
		    url    : "/dyAdmin/homepage/board/data/comment/deleteAjax.do",
		    data   : {"BC_KEYNO" : bc_keyno},
		    success:function(){
		          location.reload();
		    },
		    error: function(jqXHR, textStatus, exception) {
		    	alert('error: '+textStatus+": "+exception);
		    }
		});
	}
}


function pf_DetailMove(keyno){
	$('#BN_KEYNO').val(keyno);
	$("#actionForm").attr("action", "/dyAdmin/homepage/board/data/detailView.do");
	$("#actionForm").submit();
}

//게시물 이동
function pf_moveBoard(keyno){
	
	if('${userInfo.isAdmin}' == 'N' && '${userInfo.UI_KEYNO}' != '${BoardNotice.BN_REGNM}'){
		alert("게시물 이동 권한이 없습니다.");
		return false;
	}
	
	
	var check = true;
	
	$.ajax({
	    type   : "post",
	    url    : "/dyAdmin/homepage/board/moveCheckAjax.do",
	    data   : {"BN_KEYNO" : keyno},
	    async  : false,
	    success:function(data){
	          if(data > 0){
	        	  check = false;
	          }
	    },
	    error: function(jqXHR, textStatus, exception) {
	    	alert('error: '+textStatus+": "+exception);
	    }
	});

	if(check){
		$("#actionForm").attr("action", "/dyAdmin/homepage/board/moveView.do");
		$("#actionForm").submit();		
	}else{
		alert("해당 게시글은 답글이 달린글이라 이동이 불가능합니다.");
		return false;
	}
}

//답글 달기
function pf_replyWrite(keyno){
	
	$('#actionView').val('insertView');
	$('#BN_KEYNO').val(keyno);
	$("#actionForm").attr("action", "/dyAdmin/homepage/board/data/actionView.do");
	$("#actionForm").submit();
}

function pf_snsTest(){
	location.href="/sns/main.do";
}
</script>
<style>
.reply_contents textarea{width:100%;}
.reply_write{display: none;}
</style>
<div id="content">
	<section id="widget-grid" >
		<div class="row">
			<article class="col-sm-12 col-md-12 col-lg-12">
				<div class="jarviswidget jarviswidget-color-blueDark" id="wid-id-11" data-widget-colorbutton="false" data-widget-colorbutton="false" data-widget-editbutton="false" data-widget-togglebutton="false" data-widget-deletebutton="false" data-widget-fullscreenbutton="false" data-widget-custombutton="false">
					<header>
						<span class="widget-icon"> <i class="fa fa-lg fa-desktop"></i> </span>
						<h2>게시물관리 </h2>
						
						<ul id="widget-tab-1" class="nav nav-tabs pull-right">
							<li class="active">
								<a data-toggle="tab" href="#hr1"> <i class="fa fa-lg fa-arrow-circle-o-down"></i> <span class="hidden-mobile hidden-tablet"> 게시물상세 </span> </a>
							</li>
							<c:if test="${BoardType.BT_COMMENT_YN eq 'Y' }">
							<li>
								<a data-toggle="tab" href="#hr2"> <i class="fa fa-lg fa-arrow-circle-o-down"></i> <span class="hidden-mobile hidden-tablet"> 댓글 </span></a>
							</li>
							</c:if>
							<c:if test="${BoardType.BT_REPLY_YN eq 'Y' }">
							<li>
								<a data-toggle="tab" href="#hr3"> <i class="fa fa-lg fa-arrow-circle-o-down"></i> <span class="hidden-mobile hidden-tablet"> 답글 </span></a>
							</li>
							</c:if>
						</ul>	
					</header>
					<!-- widget div-->
					<div>
						<!-- widget edit box -->
						<div class="jarviswidget-editbox">
						<!-- This area used as dropdown edit box -->
						</div>
						<!-- end widget edit box -->
					
						<!-- widget content -->
						<div class="widget-body">
							<!-- widget body text-->
											
							<div class="tab-content">
								<div class="tab-pane fade in active" id="hr1">
									<h6 class="alert alert-info"> <button type="button" class="close" data-dismiss="alert">×</button>
									등록된 게시물을 확인하거나 수정, 삭제 처리 합니다.  </h6>
									<div class="widget-body">
										<form:form id="actionForm" name="Form" method="post">
											<input type="hidden" name="BN_KEYNO" id="BN_KEYNO" value="${BoardNotice.BN_KEYNO }">
											<input type="hidden" name="MN_KEYNO" id="MN_KEYNO" value="${BoardNotice.BN_MN_KEYNO }">
											<input type="hidden" name="BN_MN_KEYNO" id="BN_MN_KEYNO" value="${BoardNotice.BN_MN_KEYNO }">
											<input type="hidden" name="BN_THUMBNAIL" id="BN_THUMBNAIL" value="${BoardNotice.BN_THUMBNAIL }">
											<input type="hidden" name="BN_FM_KEYNO" id="BN_FM_KEYNO" value="${BoardNotice.BN_FM_KEYNO }">
											<input type="hidden" name="BC_KEYNO" id="BC_KEYNO" >
											<input type="hidden" name="BC_REGNM" id="BC_REGNM" >
											<input type="hidden" name="BT_KEYNO" id="BT_KEYNO" value="${BoardType.BT_KEYNO}">
											<input type="hidden" name="BN_DEL_YN" id="BN_DEL_YN" value="">
											<input type="hidden" name="BN_USE_YN" id="BN_USE_YN" value="">
											<input type="hidden" name="BN_TITLE" id="BN_TITLE" value="${BoardNotice.BN_TITLE }">
											<input type="hidden" name="actionView" id="actionView" value="updateView">
											
						
											<table id="boardDetail" class="table table-bordered table-striped" style="clear: both">
												<colgroup>
													<col style="width: 15%;">
													<col style="width: 35%;">
													<col style="width: 15%;">
													<col style="width: 35%;">
												</colgroup>
												<tbody>
													<tr>
														<th>제목</th>
														<td><c:out value="${BoardNotice.BN_TITLE}" escapeXml="true"/></td>
														<th>게시판명</th>
														<td><c:out value="${Menu.MN_NAME}" escapeXml="true"/></td>
													</tr>
													<tr>
														<th>공지여부</th>
														<td colspan="${BoardNotice.BN_IMPORTANT eq 'Y' ? '1' : '3' }">${BoardNotice.BN_IMPORTANT}</td>
														<c:if test="${BoardNotice.BN_IMPORTANT eq 'Y' }">
															<th>공지기간</th>
															<td>~ ${BoardNotice.BN_IMPORTANT_DATE}</td>
														</c:if>
													</tr>
													
													<c:forEach items="${BoardColumnList }" var="bcl">
        											<c:if test="${bcl.BL_TYPE ne sp:getData('BOARD_COLUMN_TYPE_TITLE')}">
														<c:forEach items="${BoardColumnDataList }" var="model">
														<c:if test="${not empty model.BD_DATA && bcl.BL_KEYNO eq model.BD_BL_KEYNO}">
															<tr>
																<th>${model.COLUMN_NAME }</th>
																<td colspan="3">
																<c:choose>
																	<c:when test="${model.BD_BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_CHECK') }">${fn:replace(model.BD_DATA,'|',',' ) }</c:when>
																	<c:when test="${model.BD_BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_CHECK_CODE') }">${fn:replace(model.BD_DATA,'|',',' ) }</c:when>
																	<c:when test="${model.BD_BL_TYPE eq sp:getData('BOARD_COLUMN_TYPE_LINK')}">
												           				<a href="${model.BD_DATA }" target="_blank"><c:out value="${model.BD_DATA}" escapeXml="true"/></a>
												           			</c:when>
																	<c:otherwise><c:out value="${model.BD_DATA}" escapeXml="true"/></c:otherwise>
																</c:choose>
																</td>
															</tr>
														</c:if>
														</c:forEach>
													</c:if>
													</c:forEach>
													<tr>
														<th>작성자</th>
														<td><c:out value="${BoardNotice.BN_UI_NAME }"/> (${BoardNotice.BN_INSERT_IP })</td>
														<th>작성일자</th>
														<td><c:out value="${BoardNotice.BN_REGDT }"/></td>
													</tr>
													<tr>
														<th>최근 게시물 수정자</th>
														<td><c:out value="${not empty BoardNotice.BN_MOD_UI_NAME ? BoardNotice.BN_MOD_UI_NAME : '최근 게시물 수정자 없음' }"/>
															<c:if test="${not empty BoardNotice.BN_MOD_UI_NAME}">(${BoardNotice.BN_UPDATE_IP})</c:if>
														</td>
														<th>최근 게시물 수정일자</th>
														<td><c:out value="${not empty BoardNotice.BN_MODDT ? BoardNotice.BN_MODDT : '게시물 수정이력 없음' }"/></td>
													</tr>
													<c:if test="${BoardNotice.BN_DEL_YN eq 'Y'}">
													<tr>
														<th>삭제자</th>
														<td><c:out value="${BoardNotice.BN_DEL_UI_NAME }"/>(${BoardNotice.BN_DELETE_IP})</td>
														<th>삭제일자</th>
														<td><c:out value="${BoardNotice.BN_DELDT }"/></td>
													</tr>
													<c:if test="${not empty BoardNotice.BN_DEL_MEMO}">
													<tr>
														<th>삭제 사유</th>
														<td colspan="3"><c:out value="${BoardNotice.BN_DEL_MEMO}"/></td>
													</tr>
													</c:if>
													</c:if>
													<tr>
														<th>카테고리</th>
														<td colspan="3"><c:out value="${not empty BoardNotice.BN_CATEGORY_NAME ? BoardNotice.BN_CATEGORY_NAME : '없음' }"/></td>
													</tr>
													
													<tr>
														<th>썸네일</th>
														<td colspan="3">
															<c:if test="${empty BoardNotice.BN_THUMBNAIL || BoardNotice.BN_THUMBNAIL == '' }">
																없음
															</c:if>
															<c:if test="${not empty BoardNotice.BN_THUMBNAIL && BoardNotice.BN_THUMBNAIL != '' }">
																<img style="width:${BoardType.BT_THUMBNAIL_WIDTH }px;height:${BoardType.BT_THUMBNAIL_HEIGHT }px;margin:5px 0;" onerror="this.style.display='none';this" src="${BoardNotice.THUMBNAIL_PUBLIC_PATH}" id="thumbnail_img" alt="썸네일"/>
															</c:if>
														</td>
													</tr>
													<tr>
														<th>
															파일첨부
															<c:if test="${BoardType.BT_ZIP_YN eq 'Y' && fn:length(FileSub) > 0  }">
												            	<div >
													            	<a href="javascript:;" onclick="cf_download_zip('${FileSub.get(0).encodeFsFmKey}')">
												    	        		압축파일 다운
												            		</a>
												            	</div>
												            </c:if>
														</th>
														<td colspan="3">
															<c:if test="${empty BoardNotice.BN_FM_KEYNO || BoardNotice.BN_FM_KEYNO == '' }">
																없음
															</c:if>
															<c:if test="${not empty BoardNotice.BN_FM_KEYNO && BoardNotice.BN_FM_KEYNO != '' }">
																<c:if test="${empty FileSub }">
																	없음
																</c:if>
																<c:forEach items="${FileSub }" var="FILE" varStatus="cnt">
                                                                    <a style="cursor: pointer;" onclick="javascript:cf_download('${FILE.encodeFsKey }')">- ${FILE.FS_ORINM }</a>
																	<c:choose>
																		<c:when test="${cnt.last }"> </c:when>
																		<c:otherwise><br> </c:otherwise>
																	</c:choose>
																</c:forEach>
															</c:if>
														</td>
													</tr>
													<c:if test="${BoardType.BT_SECRET_YN eq 'Y' }">
													<tr>
														<th>비밀글</th>
														<td colspan="3">
															<c:choose>
																<c:when test="${empty BoardNotice.BN_SECRET_YN || BoardNotice.BN_SECRET_YN == 'N' }">
																	X
																</c:when>
																<c:otherwise>
																	O
																</c:otherwise>
															</c:choose>
														</td>
													</tr>
													</c:if>
													<tr>
														<th>내용</th>
														<td colspan="3">${BoardNotice.BN_CONTENTS }</td>
													</tr>
													<c:if test="${not empty BoardNotice.BN_MOVE_MEMO && BoardNotice.BN_MOVE_MEMO != '' }">
														<tr>
															<th>게시판 이동 사유</th>
															<td colspan="3">${BoardNotice.BN_MOVE_MEMO }</td>
														</tr>
													</c:if>
												</tbody>
											</table>
										</form:form>
									</div>
							<div class="form-actions">
								<div class="row">
									<div class="col-md-12">
										<c:choose>
												<c:when test="${BoardNotice.BN_DEL_YN == 'Y' }">
													<button class="btn btn-danger" type="button" onclick="pf_deleteComp('${BoardNotice.BN_KEYNO }')">
														<i class="fa fa-save"></i> 삭제
													</button>
													<button class="btn btn-success" type="button" onclick="pf_deleteMove('N', '${BoardNotice.BN_KEYNO }')">
														<i class="fa fa-save"></i> 복원
													</button>
								              	</c:when>
								              	<c:otherwise>
								              		<c:if test="${BoardType.BT_REPLY_YN == 'Y' }">
								                   		<button class="btn btn-primary" type="button" onclick="pf_replyWrite('${BoardNotice.BN_KEYNO }')">
													 		<i class=" fa fa-pencil"></i> 답글달기
														</button>
													</c:if>
							                   		<button class="btn btn-primary" type="button" onclick="pf_UpdateMove('${BoardNotice.BN_KEYNO }')">
												 		<i class=" fa fa-pencil"></i> 수정
													</button>
													<c:if test="${empty BoardNotice.BN_PARENTKEY}">
														<button class="btn btn-primary" type="button" onclick="pf_moveBoard('${BoardNotice.BN_KEYNO }')">
													 		<i class=" fa fa-pencil"></i> 이동
														</button>
													</c:if>
													<c:if test="${BoardNotice.BN_USE_YN == 'Y' }">
														<button class="btn btn-success" type="button" onclick="pf_hideMove();">
															<i class="fa fa-save"></i> 숨기기
														</button>
														<button class="btn btn-danger" type="button" onclick="pf_deleteMove('Y','${BoardNotice.BN_KEYNO }')">
															<i class="fa fa-save"></i> 삭제
														</button>
									              	</c:if>
													<c:if test="${BoardNotice.BN_USE_YN == 'N' }">
														<button class="btn btn-success" type="button" onclick="pf_showMove()">
															<i class="fa fa-save"></i> 보이기
														</button>
									              	</c:if>
								              	</c:otherwise>
										</c:choose>									
										<button class="btn btn-default" type="button" onclick="pf_back()">
											<i class="fa fa-times"></i> 목록
										</button>
									</div>
								</div>
							</div>
								</div>
								<c:if test="${BoardType.BT_COMMENT_YN == 'Y' }">
								<div class="tab-pane fade" id="hr2">
									<h6 class="alert alert-info"> <button type="button" class="close" data-dismiss="alert">×</button>
									게시물에 대한 댓글을 확인합니다.  </h6>
									
									<div class="widget-body">
										<form:form id="Form" method="post">
											<input type="hidden" name="BC_BN_KEYNO" value="${BoardNotice.BN_KEYNO }">
											<div class="table-responsive">
												<jsp:include page="/WEB-INF/jsp/dyAdmin/include/search/pra_search_header_paging.jsp" flush="true">
													<jsp:param value="/dyAdmin/homepage/board/data/detailView/comment/pagingAjax.do" name="pagingDataUrl" />
													<jsp:param value="/dyAdmin/homepage/board/data/detailView/comment/excelAjax.do" name="excelDataUrl" />
												</jsp:include>
												<fieldset id="tableWrap">
												</fieldset>
											</div>
										</form:form>
									</div>
								</div>
								</c:if>
								
								<c:if test="${BoardType.BT_REPLY_YN == 'Y' }">
								<div class="tab-pane fade" id="hr3">
									<h6 class="alert alert-info"> <button type="button" class="close" data-dismiss="alert">×</button>
									게시물에 대한 답글을 확인합니다.  </h6>
									<div class="widget-body">
										<table class="table table-striped table-bordered table-hover">
											<thead>
												<tr>
													<th>게시물번호</th>
													<th>제목</th>
													<th>작성자</th>
													<th>작성일</th>
												</tr>
											</thead>
											<tbody>
											<c:forEach items="${BoardReplyList }" var="brl" varStatus="c">
												<tr>
													<td>${brl.BN_KEYNO }</td>
													<td>
														<a href="javascript:;" onclick="pf_DetailMove('${brl.BN_KEYNO}')">
															<c:out value="${brl.BN_TITLE }" escapeXml="true"/>
														</a>
													</td>
													<td>${brl.BN_UI_NAME }</td>
													<td>${fn:substring(brl.BN_REGDT,0,20) }</td>
												</tr>
											</c:forEach>	
											</tbody>
										</table>
										
									</div>
									<div class="form-actions">
										<div class="row">
											<div class="col-md-12">
						                   		<button class="btn btn-primary" type="button" onclick="pf_replyWrite('${BoardNotice.BN_KEYNO }')">
											 		<i class=" fa fa-pencil"></i> 답글달기
												</button>
												<button class="btn btn-default" type="button" onclick="pf_back()">
													<i class="fa fa-times"></i> 목록
												</button>
											</div>
										</div>
									</div>
								</div>
								</c:if>
						</div>
					</div>
					</div>
				</div>
				
				
			</article>
		</div>
		
		<div class="row" ${BoardNotice.BN_DEL_YN eq 'Y' ? 'style="display:none;"':'' }>	
			<article class="col-sm-12 col-md-12 col-lg-12">
				<div class="jarviswidget jarviswidget-color-blueDark" id="" data-widget-editbutton="false" data-widget-custombutton="false">
					<header>
						<span class="widget-icon"> <i class="fa fa-edit"></i></span>
						<h2>게시물 히스토리</h2>
					</header>
					<div>
						<div class="jarviswidget-editbox"></div>
						<div class="widget-body">
							<div class="table-responsive">
								<table id="datatable_fixed_column" class="table table-bordered table-hover" width="100%">
							    <thead>
							      <tr>
									<th class="text-align-center">작성자</th>
									<th class="text-align-center">게시일</th>
									<th class="text-align-center">사용여부</th>
									<th class="text-align-center">최신 데이터와 비교</th>    
									<th class="text-align-center">변경사항</th>
									<th class="text-align-center">미리보기</th>
							      </tr>
							    </thead>
							    <tbody id="intro-history">
							    	<c:forEach items="${BoardNoticeHistoryList }" var="model" varStatus="staus">
							    		<c:set value="${BoardNoticeHistoryList[staus.index - 1].BNH_BN_MODDT }" var="next"></c:set>
								    	<tr>
								    		<td class="text-align-center">${model.BN_UI_NAME }</td>
								    		<td class="text-align-center">
								    			<c:if test="${empty model.BNH_BN_MODDT }"> 
								    				${fn:substring(BoardNotice.BN_REGDT,0,16) }
								    			</c:if>
								    			<c:if test="${not empty model.BNH_BN_MODDT }"> 
								    				${fn:substring(model.BNH_BN_MODDT,0,16) }
								    			</c:if> 
								    			~ 
								    			<c:if test="${empty next }"> 
								    				${fn:substring(BoardNotice.BN_MODDT,0,16) }
								    			</c:if>
								    			<c:if test="${not empty next }"> 
								    				${fn:substring(next,0,16) }
								    			</c:if>
								    		</td>
								    		<td class="text-align-center"><a class="btn btn-default btn-xs" href="#" onclick="pf_introUse('${model.BNH_KEYNO }','${model.BNH_BN_KEYNO }');"><i class="fa fa-repeat"></i> 복원</a></td>
								    		<td class="text-align-center"><a class="btn btn-default btn-xs" href="javascript:;" onclick="pf_compareData('${model.BNH_KEYNO }','${model.BNH_BN_KEYNO }','1');"><i class="fa fa-repeat"></i> 보기</a></td>
								    		<c:if test="${staus.last }">
								    		<td class="text-align-center"></td>
								    		</c:if>
								    		<c:if test="${!staus.last }">
								    		<td class="text-align-center"><a class="btn btn-default btn-xs" href="javascript:;" onclick="pf_compareData('${model.BNH_KEYNO }','${model.BNH_BN_KEYNO }');"><i class="fa fa-repeat"></i> 보기</a></td>
								    		</c:if>
								    		<c:if test="${model.BNH_BN_CONTENTS ne null}">
								    			<td class="text-align-center"><a class="btn btn-success btn-xs" href="#" onclick="pf_introPreview('${model.BNH_KEYNO}');"><i class="fa fa-eye"></i> 내용보기</a></td>
							    			</c:if>
							    			<c:if test="${model.BNH_BN_CONTENTS eq null}">
							    				<td class="text-align-center"></td>
							    			</c:if>
							    		</tr>
						    		</c:forEach>
						    	</tbody>
							    </table>
							</div>
						</div>
					</div>
				</div>
			</article>
		</div>
		
		<div class="row" ${BoardNotice.BN_DEL_YN eq 'Y' ? 'style="display:none;"':'' }>	
			<article class="col-sm-12 col-md-12 col-lg-12">
				<div class="jarviswidget jarviswidget-color-blueDark" id="compareData_wrap" data-widget-editbutton="false" data-widget-custombutton="false">
					<header>
						<span class="widget-icon"> <i class="fa fa-edit"></i></span>
						<h2>게시물 소스 비교</h2>
					</header>
					<div>
						<div class="jarviswidget-editbox"></div>
						<div class="widget-body">
							<div id="compareData"></div>
						</div>
					</div>
				</div>
			</article>
		</div>
		
	</section>
</div>


<script>
function pf_compareData(KEY1, KEY2, KEY3){
	$.ajax({
		type: "POST",
		url: "/dyAdmin/homepage/board/data/detailView/compareAjax.do",
		data: "BNH_KEYNO="+KEY1+"&BN_KEYNO="+KEY2+"&COMPARE="+KEY3,
		async:false,
		success : function(result){
			var obj = result.BoardNoticeCompare;
			var dmp = new diff_match_patch();
			var d,file,secret,thumb,useyn,important,importantdate;
			if(KEY3 == undefined){
			    d = dmp.diff_main(obj.length == 1 ? "": obj[1].BN_CONTENTS, obj[0].BN_CONTENTS);
			    thumb = dmp.diff_main(obj.length == 1 ? "": obj[1].THUMBNAIL_ORINM, obj[0].THUMBNAIL_ORINM);
			    secret = (obj[1].BN_SECRET_YN == obj[0].BN_SECRET_YN);
			    file = (obj[1].BN_FM_KEYNO == obj[0].BN_FM_KEYNO);
			    useyn = (obj[1].BN_USE_YN == obj[0].BN_USE_YN);
			    important = (obj[1].BN_IMPORTANT == obj[0].BN_IMPORTANT);
			    importantdate = dmp.diff_main(obj.length == 1 ? "": obj[1].BN_IMPORTANT_DATE, obj[0].BN_IMPORTANT_DATE);
			    
			}else{
				d = dmp.diff_main(obj[0].BN_CONTENTS, obj[1].BN_CONTENTS);
				thumb = dmp.diff_main(obj[0].THUMBNAIL_ORINM, obj[1].THUMBNAIL_ORINM);
				secret = (obj[0].BN_SECRET_YN == obj[1].BN_SECRET_YN);
				file = (obj[0].BN_FM_KEYNO == obj[1].BN_FM_KEYNO);
				useyn = (obj[0].BN_USE_YN == obj[1].BN_USE_YN)
				important = (obj[0].BN_IMPORTANT == obj[1].BN_IMPORTANT);
				importantdate = dmp.diff_main(obj[0].BN_IMPORTANT_DATE, obj[1].BN_IMPORTANT_DATE)
			}
		    dmp.diff_cleanupSemantic(d);
		    dmp.diff_cleanupSemantic(thumb);
		    var secrettext, filetext, useyntext, importanttext = "";
		    secrettext = textinsert(secret);
		    filetext  = textinsert(file);
		    useyntext = textinsert(useyn);
		    importanttext = textinsert(important);
		    var con = "";
		    con += "<tr><td>비밀글</td><td>" + secrettext + "</td></tr>";
		    con += "<tr><td>공지사용여부</td><td>" + importanttext + "</td></tr>";
		    con += "<tr><td>공지날짜</td><td>" + dmp.diff_prettyHtml(importantdate) + "</td></tr>";
		    con += "<tr><td>사용여부</td><td>" + useyntext + "</td></tr>";
		    con += "<tr><td>첨부파일</td><td>" + filetext + "</td></tr>";
		    con += "<tr><td>썸네일</td><td>" + dmp.diff_prettyHtml(thumb) + "</td></tr>";
		    con += "<tr><td colspan='2'>내용</td></tr><tr><td colspan='2'>" + dmp.diff_prettyHtml(d) + "</td></tr>";
		    con += "</tbody></table>";
		    
		    
		    var ds = "<table id='' class='table table-bordered table-striped' style='clear: both'><colgroup><col style='width: 35%;'><col style='width: 65%;'></colgroup><tbody>";
		    for(var i = 0; i < result.BoardColmnDataCompare1.length; i++){
				    	if(KEY3 == undefined){
				    		  d = dmp.diff_main(result.BoardColmnDataCompare2 == 0 ? "": result.BoardColmnDataCompare2[i].BD_DATA, result.BoardColmnDataCompare1[i].BD_DATA);
						}else{
							  d = dmp.diff_main(result.BoardColmnDataCompare1[i].BD_DATA, result.BoardColmnDataCompare2[i].BD_DATA);
					}
		    	dmp.diff_cleanupSemantic(d);
		    	ds += "<tr><td>"+result.BoardColmnDataCompare1[i].COLUMN_NAME + "</td><td>" + dmp.diff_prettyHtml(d) + "</td></tr>";
		    	}
	    	$('#compareData').html(ds+con);
		},
		error: function(){
			alert('데이터를 가져올수없습니다. 관리자한테 문의하세요.')
			return false;
		}
	});
}
function textinsert(bool){
	var t = "";
	if(bool){
    	t = "변동사항없음";
    }else{
    	t = "<span style='color:red;'>수정됨</span>";
    }
	return t;
}

function pf_introUse(key1, key2){
	$("#actionForm").attr("action", "/dyAdmin/homepage/board/data/restore.do?bnh_keyno="+key1+"&bn_keyno="+key2);
	$("#actionForm").submit();
}

//내용보기
function pf_introPreview(KEYNO){
	window.open('/dyAdmin/homepage/board/data/detailView/historyContents.do?BNH_KEYNO='+KEYNO,"","width=960, height=800")
	
}
</script>