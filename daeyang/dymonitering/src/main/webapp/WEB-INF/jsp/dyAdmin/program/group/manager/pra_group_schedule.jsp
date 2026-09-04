<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<script src="/resources/common/js/calendar/TronixCalendar.js"></script>
<script src="/resources/common/js/clockpicker/clockpicker.js"></script>
<link rel="stylesheet" type="text/css" media="screen" href="/resources/common/css/calendar/TronixCalendar.css">
<link rel="stylesheet" type="text/css" media="screen" href="/resources/common/css/clockpicker/clockpicker.css">
<style>
	.em_time:first-of-type .removeTimeButton {display:none;}
	.deleteBtn
	{	 	
	   background: red;
	   color: #fff;
	   border: none;
	   border-radius: 5px;
       right: 0;
 	   position: absolute;
	}
	.tronixSchedules{position: relative; text-align: left; margin-left: 10px;}
	.divMargin{margin-bottom: 50px;}
	.divtitle{
		background: #ddd;
	    height: 50px;
	    text-align: center;
	}
	.divtitle span {
		line-height:50px;
		font-size: 20px;
	}
	#scheduleAdd {
	    width: 90%;
 	    margin: 20px auto;
	}
	.applyTime{
		width: 90%;
   		margin: 0 auto;
	}
	#scheduleAdd .panel-body {
  	  padding: 15px;
	}
</style>
<div class="widget-body-toolbar bg-color-white"  style="margin-bottom: 10px;">
	<div class="alert alert-info fade in" style="margin-bottom: 10px;">
		<button type="button" class="close" data-dismiss="alert">×</button>
		스케줄을 등록합니다.
	</div>
	<c:if test="${action eq 'update' }">
		<div class="alert alert-info"  style="margin-bottom: 0;">
			<a class="close" data-dismiss="alert">×</a>
			<p style="text-align: center; font-size: 15px; color: red;">
				※ 신청자가 있는 프로그램일 경우 스케줄을 수정 할 수 없습니다.
			</p>
		</div>
	</c:if>
	<button style="float: right;  margin: 10px 0;" class="btn btn-sm btn-primary" type="button" onclick="pf_Addschedule('N');" >스케줄 추가</button>
	<div class="clear"></div>
</div>

<div style="float: left; width:50%" >
	<div class="divtitle"><span>예약일정</span></div>
	<div id="calendar_div" style="">
	</div>
</div>

<div  style="float: left; width:50%">
	<!-- 스케줄 등록목록 -->
	<div class="divtitle applyTime"><span>예약시간</span></div>
	<div id="scheduleAdd">
	
		<div class="panel-group smart-accordion-default AutoList" id="scheduleList"></div>
		
	</div>
</div>
		<div class="clear"></div>
	
<!-- 스케줄 레이어창  -->
<div id="scheduleInsert" title="스케줄 추가 ">
	<div class="widget-body scheduleInsert">
		<div class="table-responsive">
			<table class="table-bordered table-striped table-authorityInfo" style="width:100%;">
				<input type="hidden" id="resultKeyno">
				<tbody>
					<tr>
						<td style="vertical-align:middle; text-align:center;">일시</td>
						<td id="referee_name" colspan="3" style="text-align: center; padding: 2%;">
						<div class="row smart-form">
							<label style="width: 100%; text-align: left;">
								<code>	※ 날짜를 입력하지 않을 시 현재 달 초부터 3개월까지 자동으로 입력됩니다.</code>
							</label>
							<section class="col col-6"  style="margin: 10px 0;">  
								<label class="input"> <i class="icon-prepend fa fa-edit"></i>    
									<input type="text" class="start_date" id="start_date" readonly="readonly" placeholder="시작일자를 선택하세요." />
								</label>  
							</section>   
							<section class="col col-6"  style="margin: 10px 0;"> 
								<label class="input"> <i class="icon-prepend fa fa-edit"></i>      
									<input type="text" class="end_date" id="end_date"  readonly="readonly" placeholder="종료일자를 선택하세요."/>
								</label>    
							</section>
						</div>

						</td>
					</tr>
					<tr>
						<td style="vertical-align:middle; text-align:center;">반복일</td>
						<td id="referee_name" colspan="3" style="text-align: center; padding: 2%;">
							<div class="row smart-form">
								<label style="width: 100%; text-align: left;">
									<code>	※ 특정요일이 반복될 경우만 선택하세요</code>
								</label>
								<section class="col col-12 dateDayBox" style="margin-bottom: 0;">
									<label class="checkbox EM_DATE4">
										<input type="checkbox" name="repeat" data-number="1" value="월">
										<i></i>월</label>
									<label class="checkbox EM_DATE4">
										<input type="checkbox"  name="repeat"  data-number="2" value="화">
										<i></i>화</label>
									<label class="checkbox EM_DATE4">
										<input type="checkbox"  name="repeat"  data-number="3" value="수">
										<i></i>수</label>
									<label class="checkbox EM_DATE4">
										<input type="checkbox"  name="repeat"  data-number="4" value="목">
										<i></i>목</label>
									<label class="checkbox EM_DATE4">
										<input type="checkbox"  name="repeat"  data-number="5" value="금">
										<i></i>금</label>
									<label class="checkbox EM_DATE4">
										<input type="checkbox"  name="repeat"  data-number="6" value="토">
										<i></i>토</label>
									<label class="checkbox EM_DATE4">
										<input type="checkbox"  name="repeat"  data-number="0" value="일">
										<i></i>일</label>
									
								</section>
							</div>
						</td>
					</tr>			
					<tr>
						<td style="vertical-align:middle; text-align:center;"><span class="nessSpan">*</span> 시간/정원
						<button class="btn btn-sm btn-warning addTimeButton" style="margin-left:10px;" type="button" onclick="pf_addTimeContainer(this)">
							<i class="fa fa-plus-circle"></i> 추가
						</button>
						</td>
						<td id="referee_id" style="padding: 1%;" colspan="3"> 
						<div class="row smart-form">
								<section class="col col-12 em_time_wrap" id="em_time_wrap"
									style="margin: 0px;">
									<section style="width: 100%; margin: 10px; float: left;" class="em_time">
											<div class="col col-6 input-group clockpicker"
												style="width: 40%; padding-left: 0;">
												<input type="text" name="st_hour" id="st_hour"
													class="form-control st_hour" placeholder="시작 시간"> <span
													class="input-group-addon"> <span
													class="glyphicon glyphicon-time"></span>
												</span>
											</div>

											<div class="col col-6 input-group clockpicker"
												style="width: 40%;">
												<input type="text" name="en_hour" id="en_hour"
													class="form-control en_hour" placeholder="종료 시간"> <span
													class="input-group-addon"> <span
													class="glyphicon glyphicon-time"></span>
												</span>
											</div>

											<button class="btn btn-sm btn-danger removeTimeButton"
												style="margin-left: 10px;" type="button"
												onclick="pf_removeTimeContainer(this.parentNode)">
												<i class="fa fa-trash-o"></i> 삭제
											</button>

											<div class="col col-12" style="padding: 10px 0 10px 0;">
												<div class="col col-6" style="padding-left: 0;">
													<label class="input" name="" class=""> <i
														class="icon-prepend fa fa-edit"></i><input id="changeCnt"
														class="NumberOnly changeCnt" type="text"
														placeholder="변경할 인원수를 입력하세요."
														onKeyDown="return cf_only_Num(event);" maxlength="4"
														onfocusout="pf_mixNum2(this);" />
													</label>
												</div>
												<div class="col col-6">
													<label class="input" name="" class=""> <i
														class="icon-prepend fa fa-edit"></i><input
														class="GSS_SUBTITLE" name="GSS_SUBTITLE" type="text"
														placeholder="제목을 입력하세요." maxlength="50" />
													</label>
												</div>
											</div>
									</section>
								</section>
								<label style="width: 100%; padding:0px 10px 0px 10px;">
											<code> * 변경사항이 없으면 입력하지 않으셔도 됩니다.</code>
										</label>
						</div>
						</td>
					</tr>	
				</tbody>
			</table>
		</div>
	</div>
</div>

<%@ include file="pra_group_schedule_script.jsp"%>