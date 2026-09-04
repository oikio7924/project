<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>


<style>
.tree .settings {display:inline-block;font-size: 0.5em;}
.tree .settings .checkbox {display:inline-block;margin:0;}

.fixed-btns {position: fixed;bottom: 50px;right: 40px;z-index: 100;}
.fixed-btns > li {display: inline-block;margin-bottom: 7px;}
label input[type=checkbox].checkbox + span {font-weight: 700 !important;}
.board-tree label span {border:none;margin-right:0;}

label input[type=checkbox].checkbox.style-3.all:checked+span:before {border-color: #3276b1;background: #3276b1;}
#menuListWrap section, #menuListWrap .divLeft{float: left;}
.labeltitle{text-align: center;line-height: 30px;}

div .dl-horizontal {margin-top:5px}
.dl-horizontal dt, .dl-horizontal dd {line-height: 30px;}
.dl-horizontal dt span{color:red;}
.url-input-span {float: left;display: block;line-height: 32px;padding-left:10px;color:#3276b1}
.url-input input{border: 0px !important;float: left;padding-left:0 !important;}


.smart-form .radio:first-of-type {margin-left:0}
.checkbox-inline, .radio-inline {display:inline-block !important;}
.smart-form .checkbox:last-child, .smart-form .radio:last-child {margin-bottom:4px;}
.boardDiv{float: right; display: none;}
.authWrap{margin-top: 20px;}

.select2-selection__rendered {padding-left:5px !important;}
.pageRating, .pageRatingInfo, .gonggnogType{display:none;}
.gonggongUL li{position:relative;margin:0;margin-bottom:2px;padding:0;min-height:60px;border-top:1px solid #dbdbdb;border-bottom:1px solid #dbdbdb;background:#f7f7f7;}
.gonggongUL li label{display:block;position:relative;margin:0;padding:20px 10px 20px 0;padding-left:280px;font-size:12px;color:#231f20;font-weight:bold;line-height:130%;cursor:pointer;}
.gonggongUL li input{position:absolute;left:10px;top:22px;z-index:10;}
.gonggongUL li:last-child label{display:inline-block;padding:20px 10px 20px 0;padding-left:45px;font-size:12px;color:#231f20;font-weight:bold;line-height:130%;cursor:pointer;}

.paddingBottom{padding-bottom: 15px;}
.marginTop{margin-top: 20px;}
.divRight{float: right;}
.fontInfo{font-size: 15px; color: #bb1c1c;}
.iconhight{line-height: 26px;}


.form-control[disabled], .form-control[readonly], fieldset[disabled] .form-control{
	background-color: #eee !important;
    opacity: 1 !important;
}
</style>
<div class="jarviswidget jarviswidget-color-darken" id="wid-id-1" data-widget-editbutton="false">
	<header>
		<span class="widget-icon"> <i class="fa fa-table"></i>
		</span>
		<h2>메뉴 관리</h2>
	</header>
	<div class="widget-body" >
		<div class="widget-body-toolbar bg-color-white">
			<div class="alert alert-info no-margin fade in">
				<button type="button" class="close" data-dismiss="alert">×</button>
				* 메뉴 설정 후 오른쪽 하단의 저장버튼으로 꼭 저장하여주세요. <br>
				<span style="color: red;">* 저장 후 권한관리에서 시스템 재설정 버튼을 클릭하셔야 적용됩니다.</span> <br>
				<span style="color: red;">* 표시는 필수 입력 항목입니다.</span> 
			</div> 
		</div>
		<div>
			<div class="widget-body-toolbar bg-color-white">
				<ul id="authorityListTab" class="nav nav-tabs bordered">
					<li class="active">
						<a href="#menuList-tab-content-1" data-toggle="tab" id="menuLink">메뉴 설정</a>
					</li>
					<li>
						<a href="#menuList-tab-content-2" data-toggle="tab" id="authLink">권한 설정</a>
					</li>
					<c:if test="${action eq 'Update'}">
					<li>
						<a href="#menuList-tab-content-3" data-toggle="tab" id="dethLink">뎁스 이동</a>
					</li>
					</c:if>
				</ul>
				<div class="tab-content padding-10">
					<div id="menuList-tab-content-1" class="tab-pane fade in active widget-body smart-form menuPopWrap">
					<br/>
					
					<input type="hidden" id="Mainmenu-LEV" value="" >
					<input type="hidden" id="Mainmenu-MAINKEY" value="" maxlength="50">
					<input type="hidden" id="Mainmenu-BEFORE" value="${resultData.MN_ORDER }" maxlength="50">
					
					<c:if test="${action eq 'Update' }">
						<div>
							<legend class="col-xs-12 col-sm-12 col-md-12 col-lg-12 paddingBottom">
								<div class="col-xs-12 col-sm-6 col-md-6 col-lg-6">
								    <div class="divLeft fontInfo col-xs-12 col-sm-12 col-md-12 col-lg-12">
										<span>등록자 : ${resultData.MN_REGNM }</span>
									</div>
									<div class="divLeft fontInfo col-xs-12 col-sm-12 col-md-12 col-lg-12">
										<span>등록일 : ${resultData.MN_REGDT }</span>
									</div>
									<div class="divLeft fontInfo col-xs-12 col-sm-12 col-md-12 col-lg-12">
										<span>메뉴키 : ${resultData.MN_KEYNO }</span>
									</div>
									<div class="divLeft fontInfo col-xs-12 col-sm-12 col-md-12 col-lg-12">
										<span>메뉴 URL : ${resultData.MN_URL }</span>
									</div>
								</div>
								<c:if test="${not empty resultData.MN_MODDT}">
									<div class="col-xs-12 col-sm-6 col-md-6 col-lg-6">
									    <div class="divLeft fontInfo col-xs-12 col-sm-12 col-md-12 col-lg-12">
											<span>최종 수정자 : ${resultData.MN_MODNM }</span>
										</div>
										<div class="divLeft fontInfo col-xs-12 col-sm-12 col-md-12 col-lg-12">
											<span>최종 수정일 : ${resultData.MN_MODDT }</span>
										</div>
									</div>
								</c:if>
							</legend>
						</div>
					</c:if>
					<fieldset>
			    		<section class="col-xs-12 col-sm-6 col-md-6 col-lg-6 marginTop">
							<div class="form-group">
								<label class="col-xs-2 col-sm-4 col-md-4 col-lg-4 control-label labeltitle">사용 여부</label>
								<div class="col-xs-10 col-sm-8 col-md-8 col-lg-8">
									 <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
										 <label class="radio radio-inline">
											<input type="radio" name="Mainmenu-USE_YN" value="Y" ${empty resultData.MN_USE_YN || resultData.MN_USE_YN eq 'Y' ? 'checked' : '' }>
											<i></i>사용
										</label>
										<span class="btn-warning btn-xs iconhight"><i class="fa fa-check-square-o"></i></span>
									 </div>
									 <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
										<label class="radio radio-inline">
											<input type="radio" name="Mainmenu-USE_YN" value="N" ${resultData.MN_USE_YN eq 'N' ? 'checked' : '' }>
											<i></i>미사용
										</label>
										<span class="btn-warning btn-xs iconhight"><i class="fa fa-square-o"></i></span>
									 </div>
								</div>
						    </div>
					    </section>
			    		<section class="col-xs-12 col-sm-6 col-md-6 col-lg-6 marginTop">
							<div class="form-group">
								<label class="col-xs-2 col-sm-4 col-md-4 col-lg-4 control-label labeltitle">노출 여부</label>
								<div class="col-xs-10 col-sm-8 col-md-8 col-lg-8">
									 <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
										 <label class="radio radio-inline">
											<input type="radio" name="Mainmenu-SHOW_YN" value="Y" ${empty resultData.MN_SHOW_YN || resultData.MN_SHOW_YN eq 'Y' ? 'checked' : '' }>
											<i></i>보임
										</label>
										<span class="btn-primary btn-xs iconhight"><i class="fa fa-unlock"></i></span>
									 </div>
									 <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
										<label class="radio radio-inline">
											<input type="radio" name="Mainmenu-SHOW_YN" value="N" ${resultData.MN_SHOW_YN eq 'N' ? 'checked' : '' }>
											<i></i>숨김
										</label>
										<span class="btn-primary btn-xs iconhight"><i class="fa fa-lock"></i></span>
									 </div>
								</div>
						    </div>
					    </section>
				    </fieldset>
					
					<fieldset>
						<legend class="col-xs-12 col-sm-12 col-md-12 col-lg-12 paddingBottom">
							<div class="divLeft">
								<span>메뉴 정보</span>
							</div>
						</legend>
					     <section class="col-xs-12 col-sm-6 col-md-6 col-lg-6 marginTop">
							<div class="form-group">
								<label class="col-xs-4 col-sm-4 col-md-4 col-lg-4 control-label labeltitle"><span>*</span> 메뉴명</label>
								<div class="col-xs-8 col-sm-8 col-md-8 col-lg-8">
									<label class="input"> 
			              			<i class="icon-append fa fa-question-circle"></i>
									    <input type="text" id="Mainmenu-NAME" placeholder="메뉴명을 입력하세요" maxlength="50" value="${resultData.MN_NAME}"/>
									</label>
								</div>
						    </div>
					    </section>
					     <section class="col-xs-12 col-sm-6 col-md-6 col-lg-6 marginTop">
							<div class="form-group">
								<label class="col-xs-4 col-sm-4 col-md-4 col-lg-4 control-label labeltitle"><span>*</span> 정렬순서</label>
								<div class="col-xs-8 col-sm-8 col-md-8 col-lg-8">
									<select class="form-control" id="Mainmenu-ORDER">
									</select>
								</div>
						    </div>
					    </section>
					    
					    <section class="col-xs-12 col-sm-6 col-md-6 col-lg-6 marginTop">
							<div class="form-group">
								<label class="col-xs-4 col-sm-4 col-md-4 col-lg-4 control-label labeltitle"> 메뉴새창여부</label>
								<div class="col-xs-10 col-sm-8 col-md-8 col-lg-8">
									<div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
										 <label class="radio radio-inline">
											<input type="radio" name="Mainmenu-NEWLINK" value="Y" ${ resultData.MN_NEWLINK eq 'Y' ? 'checked' : '' }>
											<i></i> 새창열기 
										</label>
										
									 </div>
									 <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
										<label class="radio radio-inline">
											<input type="radio" name="Mainmenu-NEWLINK" value="N" ${empty resultData.MN_NEWLINK || resultData.MN_NEWLINK eq 'N' ? 'checked' : '' }>
											<i></i> 현재창열기
										</label>
										
									 </div>
									 </div>
						    </div>
					    </section>
					    
					    
					     <section class="col-xs-12 col-sm-6 col-md-6 col-lg-6">
							<div class="form-group">
								<label class="col-xs-4 col-sm-4 col-md-4 col-lg-4 control-label labeltitle">영문메뉴명</label>
								<div class="col-xs-8 col-sm-8 col-md-8 col-lg-8">
									<label class="input"> 
			              			<i class="icon-append fa fa-question-circle"></i>
									    <input type="text" id="Mainmenu-ENG-NAME" placeholder="영문메뉴명을 입력하세요" maxlength="50" value="${resultData.MN_ENG_NAME}"/>
									    <b class="tooltip tooltip-top-right"> <i class="fa fa-warning txt-color-teal"></i> 필요시 입력하세요.</b>
									</label>
								</div>
						    </div>
					    </section>
					
					    <section class="col-xs-12 col-sm-6 col-md-6 col-lg-6">
							<div class="form-group">
								<label class="col-xs-4 col-sm-4 col-md-4 col-lg-4 control-label labeltitle">컬러</label>
								<div class="col-xs-8 col-sm-8 col-md-8 col-lg-8">
									<label class="input"> 
									<i class="icon-append fa fa-question-circle"></i>
									<input	type="text" placeholder="컬러를 입력하세요" id="Mainmenu-COLOR" maxlength="20" value="${resultData.MN_COLOR}">
									 <b class="tooltip tooltip-top-right"> <i class="fa fa-warning txt-color-teal"></i> 필요시 입력하세요.</b>
								</label>
								</dd>
								</div>
						    </div>
					    </section>
					    <section class="col-xs-12 col-sm-6 col-md-6 col-lg-6">
							<div class="form-group">
								<label class="col-xs-4 col-sm-4 col-md-4 col-lg-4 control-label labeltitle">기타1</label>
								<div class="col-xs-8 col-sm-8 col-md-8 col-lg-8">
									<label class="input"> 
									<i class="icon-append fa fa-question-circle"></i>
									<input	type="text" placeholder="기타 컬럼1" id="Mainmenu-DATA1"  maxlength="150" value="${resultData.MN_DATA1}">
									 <b class="tooltip tooltip-top-right"> <i class="fa fa-warning txt-color-teal"></i> 필요시 입력하세요.</b>
									</label>
								</dd>
								</div>
						    </div>
					    </section>
					    <section class="col-xs-12 col-sm-6 col-md-6 col-lg-6">
							<div class="form-group">
								<label class="col-xs-4 col-sm-4 col-md-4 col-lg-4 control-label labeltitle">기타2</label>
								<div class="col-xs-8 col-sm-8 col-md-8 col-lg-8">
									<label class="input"> 
									<i class="icon-append fa fa-question-circle"></i>
									<input	type="text" placeholder="기타 컬럼2" id="Mainmenu-DATA2" maxlength="150" value="${resultData.MN_DATA2}">
									 <b class="tooltip tooltip-top-right"> <i class="fa fa-warning txt-color-teal"></i> 필요시 입력하세요.</b>
									</label>
								</dd>
								</div>
						    </div>
					    </section>
					    <section class="col-xs-12 col-sm-6 col-md-6 col-lg-6">
							<div class="form-group">
								<label class="col-xs-4 col-sm-4 col-md-4 col-lg-4 control-label labeltitle">기타3</label>
								<div class="col-xs-8 col-sm-8 col-md-8 col-lg-8">
									<label class="input"> 
									<i class="icon-append fa fa-question-circle"></i>
									<input	type="text" placeholder="기타 컬럼3" id="Mainmenu-DATA3" maxlength="150" value="${resultData.MN_DATA3}">
									 <b class="tooltip tooltip-top-right"> <i class="fa fa-warning txt-color-teal"></i> 필요시 입력하세요.</b>
									</label>
								</dd>
								</div>
						    </div>
					    </section>
					</fieldset>
					<fieldset>
						<section class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
							<div class="form-group">
								<label class="col-xs-2 col-sm-2 col-md-2 col-lg-2 control-label labeltitle"><span>*</span> 페이지 형태</label>
								<div class="col-xs-10 col-sm-10 col-md-10 col-lg-10">
									<c:set value="${empty resultData.MN_CHILD_CNT || resultData.MN_CHILD_CNT eq '' ? '0' : resultData.MN_CHILD_CNT }" var="childCnt"/>
									<select class="form-control input-sm" id="Mainmenu-PAGEDIV_C" onchange="pf_checkShowAndHide(this.value,'${childCnt}');">
									<c:forEach items="${menuList }" var="model">
										<option value="${model.SC_KEYNO }">${model.SC_CODENM }</option>
									</c:forEach>
									</select>
								</dd>
								</div>
						    </div>
					    </section>
						<section class="col-xs-12 col-sm-12 col-md-12 col-lg-12 Mainmenu-SUBMENUBOX">
							<div class="form-group">
								<label class="col-xs-2 col-sm-2 col-md-2 col-lg-2 control-label labeltitle">소개 페이지</label>
								<div class="col-xs-10 col-sm-10 col-md-10 col-lg-10">
									<label class="input" for="Mainmenu-INTRO_URL">
									<i class="icon-append fa fa-question-circle"></i>
									<input type='text' id="Mainmenu-INTRO_URL" maxlength="150">
								    <b class="tooltip tooltip-top-right"> <i class="fa fa-warning txt-color-teal"></i> 띄어쓰기 없이 영문과 숫자만으로 작성되어야되고, 마지막은 .do로 끝나야됩니다.</b>
									</label>
									<div class="dl-horizontal">
										* 소메뉴 클릭시 <br>
										&nbsp;&nbsp;소개 페이지 있을 경우 : 소메뉴 url + / + 소개페이지 url 로 연결 <br>
										&nbsp;&nbsp;소개 페이지 없을 경우 : 하위 첫번째 메뉴로 연결 
									</div>
								</div>
						    </div>
					    </section>
						<section class="col-xs-12 col-sm-12 col-md-12 col-lg-12" id="Mainmenu-BOARDTYPEBOX" style="display:none;">
							<div class="form-group">
								<label class="col-xs-2 col-sm-2 col-md-2 col-lg-2 control-label labeltitle">게시판 형태</label>
								<div class="col-xs-10 col-sm-10 col-md-10 col-lg-10">
									<select class="form-control input-sm" id="Mainmenu-BOARDTYPE">
						              <option value="">게시판 선택</option>
						            <c:forEach items="${boardTypeList }" var="boardType">
						              <option value="${boardType.BT_KEYNO }" ${resultData.MN_BT_KEYNO eq  boardType.BT_KEYNO ? 'selected' :''}>${boardType.BT_TYPE_NAME }</option>
						            </c:forEach>
						            </select>
								</div>
						    </div>
					    </section>
						<section class="col-xs-12 col-sm-12 col-md-12 col-lg-12" id="Mainmenu-EMAILBOX" style="display:none;">
							<div class="form-group">
								<label class="col-xs-2 col-sm-2 col-md-2 col-lg-2 control-label labeltitle">담당자 이메일</label>
								<div class="col-xs-10 col-sm-10 col-md-10 col-lg-10">
									 <label class="input" for="Mainmenu-EMAIL">
										<i class="icon-append fa fa-question-circle"></i>
										<input type='text' id="Mainmenu-EMAIL" maxlength="1000" value="${resultData.MN_EMAIL}">
									    <b class="tooltip tooltip-top-right"> <i class="fa fa-warning txt-color-teal"></i> 게시글 알람을 받을 담당자 이메일을 입력합니다.</b>
										<div class="clear"></div>
									</label>
								</div>
						    </div>
					    </section>
						<section class="col-xs-12 col-sm-12 col-md-12 col-lg-12" id="Mainmenu-URLBOX" name="Mainmenu-URLBOX">
							<div class="form-group">
								<label class="col-xs-2 col-sm-2 col-md-2 col-lg-2 control-label labeltitle"><span>*</span> URL 입력</label>
								<div class="col-xs-10 col-sm-10 col-md-10 col-lg-10">
									 <label class="input" for="Mainmenu-URL">
										<div class="url-input" style="border: 1px solid #BDBDBD;">
											<span class="url-input-span" id="Mainmenu-preURL">/test/aaa/bbb</span>
											<i class="icon-append fa fa-question-circle"></i>
											<input type='text' id="Mainmenu-URL" maxlength="150">
										    <b class="tooltip tooltip-top-right"> <i class="fa fa-warning txt-color-teal"></i> 소메뉴형은 띄어쓰기 없이 영문으로 작성되어야되고, 소메뉴형이 아닐경우 마지막은 .do로 끝나야됩니다.</b>
											<div class="clear"></div>
										</div>
									</label>
								</div>
						    </div>
					    </section>
						<section class="col-xs-12 col-sm-12 col-md-12 col-lg-12" id="Mainmenu-LINKBOX" name="Mainmenu-LINKBOX">
							<div class="form-group">
								<label class="col-xs-2 col-sm-2 col-md-2 col-lg-2 control-label labeltitle"><span>*</span> 링크 URL 입력</label>
								<div class="col-xs-10 col-sm-10 col-md-10 col-lg-10">
									 <label class="input"> 
									<i class="icon-append fa fa-question-circle"></i>
									<input	type="text" placeholder="http://" id="Mainmenu-LINKURL" maxlength="150" value="${resultData.MN_URL}">
									 <b class="tooltip tooltip-top-right"> <i class="fa fa-warning txt-color-teal"></i>  http:// or https://를 붙여주세요</b>
									</label>
								</div>
						    </div>
					    </section>
					</fieldset>
				
						<fieldset class="metaInfo">
			    		<legend class="col-xs-12 col-sm-12 col-md-12 col-lg-12 paddingBottom">
							<div class="divLeft">
								<span>메타 정보</span>
							</div>
						</legend>
						
						<section class="col-xs-12 col-sm-12 col-md-12 col-lg-12 marginTop">
							<div class="form-group">
								<label class="col-xs-2 col-sm-2 col-md-2 col-lg-2 control-label labeltitle">
									설명 내용
								</label>
								<div class="col-xs-10 col-sm-10 col-md-10 col-lg-10">
									 <label class="input"> 
									<i class="icon-append fa fa-question-circle"></i>
									<input	type="text" id="Mainmenu-METADESC" class="form-control" maxlength="200" value="${resultData.MN_META_DESC }">
									 <b class="tooltip tooltip-top-right"> <i class="fa fa-warning txt-color-teal"></i>해당 페이지의 설명을 적어주세요</b>
									</label>
								</div>
						    </div>
					    </section>
					    
					    <section class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
							<div class="form-group">
								<label class="col-xs-2 col-sm-2 col-md-2 col-lg-2 control-label labeltitle">
									키워드 내용
								</label>
								<div class="col-xs-10 col-sm-10 col-md-10 col-lg-10">
									 <label class="input"> 
									<i class="icon-append fa fa-question-circle"></i>
									<input	type="text" id="Mainmenu-METAKEYWORD" class="form-control" maxlength="200" value="${resultData.MN_META_KEYWORD }" >	
									 <b class="tooltip tooltip-top-right"> <i class="fa fa-warning txt-color-teal"></i>해당 페이지의 키워드를 적어주세요</b>
									</label>
								</div>
						    </div>
					    </section>
					</fieldset>
					
					<input type="hidden" id="siteMapFreq" name="MN_CHANGE_FREQ" value="${empty resultData.MN_CHANGE_FREQ ? 'always' : resultData.MN_CHANGE_FREQ }" >
					<input type="hidden" id="siteMapPriority" name="MN_PRIORITY" value="${empty resultData.MN_PRIORITY ? '0.0' : resultData.MN_PRIORITY }" >
											
					<fieldset class="siteMapInfo">
			    		<legend class="col-xs-12 col-sm-12 col-md-12 col-lg-12 paddingBottom">
							<div class="divLeft">
								<span>사이트맵 정보</span>
							</div>
						</legend>						
						
						<section class="col-xs-12 col-sm-12 col-md-12 col-lg-12 marginTop">
							<div class="form-group">
								<label class="col-xs-2 col-sm-2 col-md-2 col-lg-2 control-label labeltitle">변경 빈도수</label>
								<div class="col-xs-10 col-sm-10 col-md-10 col-lg-10">
									<select class="form-control input-sm" id="MN_CHANGE_FREQ" onchange="pf_checkfreq(this.value)">
									<c:forTokens var="item" items="always,hourly,daily,weekly,monthly,yearly,never" delims=",">
										<option value="${item }" ${item eq resultData.MN_CHANGE_FREQ ? 'selected' : '' }>${item }</option>
									</c:forTokens>																							
									</select>
								</div>
						    </div>
					    </section>
					    
					  <section class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
							<div class="form-group">
								<label class="col-xs-2 col-sm-2 col-md-2 col-lg-2 control-label labeltitle">우선순위</label>
								<div class="col-xs-10 col-sm-10 col-md-10 col-lg-10">
									<select class="form-control input-sm" id="MN_PRIORITY" onchange="pf_checkPriority(this.value)">
									<c:forTokens var="item" items="0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0" delims=",">
										<option value="${item }" ${item eq resultData.MN_PRIORITY ? 'selected' : '' }>${item }</option>
									</c:forTokens>
									</select>
								</div>
						    </div>
					    </section>
					</fieldset>
					
					
					<c:if test="${Menu.MN_HOMEDIV_C eq sp:getData('HOMEDIV_ADMIN') }">
					<fieldset class="iconFiledset">
						<section class="col-xs-12 col-sm-12 col-md-12 col-lg-12"> 
							<input type="hidden" placeholder="font-awesome class 이름" maxlength="100" id="Mainmenu-ICONBOX" name="Mainmenu-ICONBOX" value="${resultData.MN_ICON_CSS}">
				          <dl class="dl-horizontal">
				            <dt>
				              <div>메뉴 아이콘</div>
				              <div><i id="menuIconView" class="fa fa-automobile"></i></div>
				            </dt>
				            <dd id="menuIconBox">
				              <%@ include file="/WEB-INF/jsp/dyAdmin/homepage/menu/font_awesome_list_insert.jsp" %>
				            </dd>
				          </dl>
				      </section>
				    </fieldset>
				    </c:if>
				    <c:if test="${Menu.MN_HOMEDIV_C ne sp:getData('HOMEDIV_ADMIN') }">
			    	<fieldset class="pageFiledset" style="padding: 25px 10px;">
			    		<legend class="col-xs-12 col-sm-12 col-md-12 col-lg-12 paddingBottom">
							<div class="divLeft">
								<span>페이지평가 사용여부</span>
							</div>
							<div class="divRight">
								 <label class="radio radio-inline">
									<input type="radio" class="RESEARCH" name="Mainmenu-RESEARCH" value="Y" onclick="pageRatingShowHide(this.value);" ${resultData.MN_RESEARCH eq 'Y' ? 'checked' : '' }>
									<i></i>사용</label>
								<label class="radio radio-inline">
									<input type="radio" class="RESEARCH" name="Mainmenu-RESEARCH" value="N" onclick="pageRatingShowHide(this.value);" ${empty resultData.MN_RESEARCH || resultData.MN_RESEARCH eq 'N' ? 'checked' : '' }>
									<i></i>미사용</label>
							</div>
							<div class="clear"></div>
						</legend>
			    		<section class="col-xs-12 col-sm-6 col-md-6 col-lg-6 pageRating marginTop">
							<div class="form-group">
								<label class="col-xs-2 col-sm-4 col-md-4 col-lg-4 control-label labeltitle">QR-CODE 표시여부</label>
								<div class="col-xs-10 col-sm-8 col-md-8 col-lg-8">
									 <label class="radio radio-inline">
										<input type="radio" name="Mainmenu-QRCODE" value="Y" ${resultData.MN_QRCODE eq 'Y' ? 'checked' : '' }>
										<i></i>표시</label>
									<label class="radio radio-inline">
										<input type="radio" name="Mainmenu-QRCODE" value="N" ${empty resultData.MN_QRCODE || resultData.MN_QRCODE eq 'N' ? 'checked' : '' }>
										<i></i>숨김</label>
								</div>
						    </div>
					    </section>
			    		<section class="col-xs-12 col-sm-12 col-md-12 col-lg-12 pageRating Mainmenu-DEPARTMENTBOX">
							<div class="form-group">
								<label class="col-xs-2 col-sm-2 col-md-2 col-lg-2 control-label labeltitle">담당자 선택</label>
								<div class="col-xs-10 col-sm-10 col-md-10 col-lg-10">
									<select class="form-control input-sm" id="Mainmenu-DEPARTMENT" onchange="pf_chageDepartMentCategory(this.value)">
						              <option value="">선택하세요.</option>
						            <c:forEach items="${homeDivList }" var="homeDivInfo">
						              <option value="${homeDivInfo.MN_KEYNO}">${homeDivInfo.MN_NAME}</option>
						            </c:forEach>
						            </select>
								</div>
						    </div>
					    </section>
			    		<section class="col-xs-12 col-sm-12 col-md-12 col-lg-12 pageRating Mainmenu-DEPARTMENTBOX">
							<div class="form-group">
								<label class="col-xs-2 col-sm-2 col-md-2 col-lg-2"></label>
								<div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
									<select class="form-control input-sm select2" id="Mainmenu-DEPARTMENTUSER">
						              	<option value="">선택하세요.</option>
						            </select>
								</div>
								<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2" style="float: right;">
									<label class="checkbox radio-inline">
									<input type="checkbox" class="Mainmenu-DirectSelect" value="DU_0000000000" onclick="pf_directSelectForm();">
									<i></i>직접입력</label>
								</div>
						    </div>
					    </section>
			    		<section class="col-xs-12 col-sm-12 col-md-12 col-lg-12 pageRatingInfo">
							<div class="form-group">
								<label class="col-xs-2 col-sm-2 col-md-2 col-lg-2 control-label labeltitle">콘텐츠 담당부서</label>
								<div class="col-xs-10 col-sm-10 col-md-10 col-lg-10">
									<label class="input"> 
									<i class="icon-append fa fa-question-circle"></i>
									<input	type="text" placeholder="담당부서를 입력하세요." id="Mainmenu-MANAGERDEP" maxlength="50">
									 <b class="tooltip tooltip-top-right"> <i class="fa fa-warning txt-color-teal"></i> 필요시 입력하세요.</b>
									</label>
								</div>
						    </div>
					    </section>
			    		<section class="col-xs-12 col-sm-6 col-md-6 col-lg-6 pageRatingInfo">
							<div class="form-group">
								<label class="col-xs-2 col-sm-4 col-md-4 col-lg-4 control-label labeltitle">콘텐츠 담당자</label>
								<div class="col-xs-10 col-sm-8 col-md-8 col-lg-8">
									<label class="input"> 
									<i class="icon-append fa fa-question-circle"></i>
									<input	type="text" placeholder="담당자 이름을 입력하세요." id="Mainmenu-MANAGER"  maxlength="50">
									 <b class="tooltip tooltip-top-right"> <i class="fa fa-warning txt-color-teal"></i> 필요시 입력하세요.</b>
									</label>
								</div>
						    </div>
					    </section>
			    		<section class="col-xs-12 col-sm-6 col-md-6 col-lg-6 pageRatingInfo">
							<div class="form-group">
								<label class="col-xs-2 col-sm-4 col-md-4 col-lg-4 control-label labeltitle">담당자 연락처</label>
								<div class="col-xs-10 col-sm-8 col-md-8 col-lg-8">
									<label class="input"> 
									<i class="icon-append fa fa-question-circle"></i>
									<input	type="text" placeholder="담당자 연락처를 입력하세요." id="Mainmenu-MANAGERTEL"  maxlength="20">
									 <b class="tooltip tooltip-top-right"> <i class="fa fa-warning txt-color-teal"></i> 필요시 입력하세요.</b>
									</label>
								</div>
						    </div>
					    </section>
					</fieldset>
					
					<fieldset class="pageFiledset">
			    		<legend class="col-xs-12 col-sm-12 col-md-12 col-lg-12 labeltitle">
							<div class="divLeft">
								<span>공공누리 사용여부</span>
							</div>
							<div class="divRight">
								 <label class="radio radio-inline">
									<input type="radio" class="GONGGONGNULI" name="Mainmenu-GONGNULI_YN" value="Y" onclick="gonggnognuliShowHide(this.value);" ${resultData.MN_GONGNULI_YN eq 'Y' ? 'checked' : '' }>
									<i></i>사용</label>
								<label class="radio radio-inline">
									<input type="radio" class="GONGGONGNULI" name="Mainmenu-GONGNULI_YN" value="N" onclick="gonggnognuliShowHide(this.value);" ${empty resultData.MN_GONGNULI_YN || resultData.MN_GONGNULI_YN eq 'N' ? 'checked' : '' }>
									<i></i>미사용</label>
							</div>
							<div class="clear"></div>
						</legend>
			    		<section class="col-xs-12 col-sm-12 col-md-12 col-lg-12 gonggnogType marginTop">
							<div class="form-group">
								<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
									<ul class="gonggongUL">
										<li>
											<input type="radio" name="Mainmenu-GONGNULI_TYPE" class="Mainmenu-koglType1" value="1" id="insert-koglType1"/>
											<label for="insert-koglType1">
											<img src="/resources/img/codetype/new_img_opencode1.jpg" alt="" style="position:absolute;left:40px;top:2px;vertical-align:middle;width:149px;height:54px;" /> 
											1유형 : 출처표시 (상업적 이용 및 변경 가능)
											</label>
										</li>
										<li>
											<input type="radio" name="Mainmenu-GONGNULI_TYPE" class="Mainmenu-koglType2" value="2" id="insert-koglType2"/>
											<label for="insert-koglType2">
											<img src="/resources/img/codetype/new_img_opencode2.jpg" alt="" style="position:absolute;left:40px;top:2px;vertical-align:middle;width:183px;height:54px;" />  
											2유형 : 출처표시 + 상업적이용금지
											</label>
										</li>
										<li>
											<input type="radio" name="Mainmenu-GONGNULI_TYPE" class="Mainmenu-koglType3" value="3" id="insert-koglType3" />
											<label for="insert-koglType3">
											<img src="/resources/img/codetype/new_img_opencode3.jpg" alt="" style="position:absolute;left:40px;top:2px;vertical-align:middle;width:183px;height:54px;" />  
											3유형 : 출처표시 + 변경금지
											</label>
										</li>
										<li>
											<input type="radio" name="Mainmenu-GONGNULI_TYPE" class="Mainmenu-koglType4" value="4" id="insert-koglType4" />
											<label for="insert-koglType4">
											<img src="/resources/img/codetype/new_img_opencode4.jpg" alt="" style="position:absolute;left:40px;top:2px;vertical-align:middle;width:219px;height:54px;" />  
											4유형 : 출처표시 + 상업적이용금지 + 변경금지
											</label>
										</li>
										<li>
											<input type="radio" name="Mainmenu-GONGNULI_TYPE" class="Mainmenu-koglType5" value="5" id="insert-koglType5" />
											<label for="insert-koglType5">
											<img src="/resources/img/codetype/new_img_opencode0.jpg" alt="" style="position:absolute;left:40px;top:2px;vertical-align:middle;width:219px;height:54px;" />  
											자유이용 불가 (저작권법 제24조의2 제1항 제1호 ~ 4호 중 어느 하나에 해당됨)
											</label>
											<a href="http://www.law.go.kr/법령/저작권법" target="_blank" style="margin-left:10px;font-size:11px;color:#595959;font-family:'돋움', dotum;"> 
											<span style="font-size:10px;color:#595959;">▶</span> 해당사항 확인 (국가법령정보센터)</a>
										</li>
										<li class="gonggongBoard">
											<input type="radio" name="Mainmenu-GONGNULI_TYPE" class="Mainmenu-koglType6" value="0" id="insert-koglType6" />
											<label for="insert-koglType6">
											게시글 작성 시 직접선택
											</label>
										</li>
									</ul>
								</div>
						    </div>
					    </section>
					</fieldset>
					</c:if>
				</div>
				<div id="menuList-tab-content-2" class="tab-pane fade widget-body">
					<br/>
					<input type="hidden" name="action" value="${action }">
	
					<div style="float: right;">
						<a href="javascript:;" onclick="pf_allOpenAndClose(this)"><i class="fa fa-minus" style="color:red;"></i> <font>모두 닫기</font></a>
						<a href="javascript:;" onclick="pf_selectAll(true)"><i class="fa fa-plus" style="color:red;"></i> <font>모두 선택</font></a>
						<a href="javascript:;" onclick="pf_selectAll(false)"><i class="fa fa-minus" style="color:red;"></i> <font>모두 해제</font></a>
					</div>
					
					<div class="tab-content padding-10 authWrap">
						<div class="authList">
							<div class="tree menu-tree">
								<ul>
									<li data-key="${anonymousData.UIA_KEYNO }" class="pageViewLi"> 
										<span>
								  			<i class="fa fa-lg fa-caret-right" ></i> 
								  			<c:out value="비회원" escapeXml="false" />
										</span>
										<div class="settings">
											<div class="checkbox ${anonymousData.UIA_KEYNO }">
												<c:choose>
													<c:when test="${fn:contains(menuData.MN_URL,'/member')}">
														<span style="color:gray;">설정불가(로그인 관련 url)</span>	
													</c:when>
													<c:when test="${fn:contains(MainMenuAuth.MAIN_AUTH_KEY,anonymousData.UIA_KEYNO) }">
														<c:if test="${action eq 'Insert' }">
															<c:if test="${anonymousData.MN_PAGEDIV_C eq sp:getData('MENU_TYPE_PAGE') || (anonymousData.MN_PAGEDIV_C eq sp:getData('MENU_TYPE_SUBMENU') && not empty anonymousData.MN_FORWARD_URL)}">
															<label>
																<c:set var="actionCheck" value="${fn:contains(anonymousData.UIR_KEYNO,sp:getData('AUTHORITY_ROLE_ACTION')) ? 'checked':'' }"/>
																<input type="checkbox" class="checkbox style-3 action" name="actionRole" value="${anonymousData.UIA_KEYNO }">
																<span>수정권한</span>
															</label>
															</c:if>
															<label>
																<c:set var="accessCheck" value="${fn:contains(anonymousData.UIR_KEYNO,sp:getData('AUTHORITY_ROLE_ACCESS')) ? 'checked':'' }"/>
																<c:set var="isBoardClass" value="${menuData.MN_PAGEDIV_C eq sp:getData('MENU_TYPE_BOARD') ? 'board':'' }"/>
																<c:if test="${fn:contains(anonymousData.UIR_KEYNO,sp:getData('AUTHORITY_ROLE_ACCESS'))}">
																	<input type="checkbox" class="checkbox style-3 access ${isBoardClass }" name="accessRole" value="${anonymousData.UIA_KEYNO }">
																	<span>접근권한</span>
																</c:if>
																<c:if test="${!fn:contains(anonymousData.UIR_KEYNO,sp:getData('AUTHORITY_ROLE_ACCESS'))}">
																	<span style="color:gray;" class="noAccess" data-val="${anonymousData.UIA_KEYNO }">접근불가</span>	
																</c:if>
															</label>
															<label class="viewLebel">
																<c:set var="viewChecked" value="${fn:contains(anonymousData.UIR_KEYNO,sp:getData('AUTHORITY_ROLE_VIEW')) ? 'checked':'' }"/>
																<input type="checkbox" class="checkbox style-3 view ${accessCheck}" name="viewRole" value="${anonymousData.UIA_KEYNO }" ${viewChecked}>
																<span>뷰권한</span>
															</label>
															<div class="boardDiv">
																<label class="boardRole">
																	<input type="checkbox" class="checkbox style-3 all" value="">
																	<span>모든 권한</span>
																</label>
																<c:forEach items="${boardAuthorityList }" var="boardAuth">
																<label class="boardRole">
																	<c:set var="roleCheck" value="${fn:contains(anonymousData.UIR_KEYNO,boardAuth.UIR_KEYNO) ? 'checked':'' }"/>
																	<input type="checkbox" class="checkbox style-3 ${boardAuth.UIR_NAME}" name="${boardAuth.UIR_NAME}Role" value="${anonymousData.UIA_KEYNO }" ${roleCheck }>
																	<span>${boardAuth.UIR_COMMENT}</span>
																</label>
																</c:forEach>
															</div>
															<div class="clear"></div>
														</c:if>
														<c:if test="${action eq 'Update' }">
															<c:if test="${anonymousData.MN_PAGEDIV_C eq sp:getData('MENU_TYPE_PAGE') || (anonymousData.MN_PAGEDIV_C eq sp:getData('MENU_TYPE_SUBMENU') && not empty anonymousData.MN_FORWARD_URL)}">
															<label>
																<c:set var="actionCheck" value="${fn:contains(anonymousData.UIR_KEYNO,sp:getData('AUTHORITY_ROLE_ACTION')) ? 'checked':'' }"/>
																<input type="checkbox" class="checkbox style-3 action" name="actionRole" value="${anonymousData.UIA_KEYNO }" ${actionCheck}>
																<span>수정권한</span>
															</label>
															</c:if>
															<label>
																<c:set var="accessCheck" value="${fn:contains(anonymousData.UIR_KEYNO,sp:getData('AUTHORITY_ROLE_ACCESS')) ? 'checked':'' }"/>
																<c:set var="isBoardClass" value="${menuData.MN_PAGEDIV_C eq sp:getData('MENU_TYPE_BOARD') ? 'board':'' }"/>
																<input type="checkbox" class="checkbox style-3 access ${isBoardClass }" name="accessRole" value="${anonymousData.UIA_KEYNO }" ${accessCheck}>
																<span>접근권한 </span>
															</label>
															<label class="viewLebel">
																<c:set var="viewChecked" value="${fn:contains(anonymousData.UIR_KEYNO,sp:getData('AUTHORITY_ROLE_VIEW')) ? 'checked':'' }"/>
																<input type="checkbox" class="checkbox style-3 view ${accessCheck}" name="viewRole" value="${anonymousData.UIA_KEYNO }" ${viewChecked}>
																<span>뷰권한</span>
															</label>
															<div class="boardDiv">
																<label class="boardRole">
																	<input type="checkbox" class="checkbox style-3 all" value="">
																	<span>모든 권한</span>
																</label>
																<c:forEach items="${boardAuthorityList }" var="boardAuth">
																<label class="boardRole">
																	<c:set var="roleCheck" value="${fn:contains(anonymousData.UIR_KEYNO,boardAuth.UIR_KEYNO) ? 'checked':'' }"/>
																	<input type="checkbox" class="checkbox style-3 ${boardAuth.UIR_NAME}" name="${boardAuth.UIR_NAME}Role" value="${anonymousData.UIA_KEYNO }" ${roleCheck }>
																	<span>${boardAuth.UIR_COMMENT}</span>
																</label>
																</c:forEach>
															</div>
															<div class="clear"></div>
														</c:if>
													</c:when>
													<c:otherwise>
														<span style="color:gray;" class="noAccess" data-val="${anonymousData.UIA_KEYNO }">접근불가</span>	
													</c:otherwise>
												</c:choose>
											</div>
										</div>
									</li>	
								</ul>
								<c:set var="beforeDepth" value=""/>
								<c:set var="userCount" value="0"/>
								<c:forEach items="${menuAuthorityUserList}" var="model" varStatus="status">
										
										<c:if test="${model.UIA_MAINKEY eq 'UIA_00000' && model.UIA_DEPTH eq 1 }">
											<ul class="parent_ul">
										</c:if>
										
										<c:if test="${model.CHILD_CNT gt 0 }">
											<li class="parent_li" data-key="${model.UIA_KEYNO }"> 
												<span class="label label-primary">
										  			<i class="fa fa-lg fa-plus-circle"></i> 
										</c:if>
					  					
										<c:if test="${model.CHILD_CNT eq 0 }">
											<li data-key="${model.UIA_KEYNO }" class="pageViewLi"> 
											<span>
									  			<i class="fa fa-lg fa-caret-right" ></i> 
										</c:if>
											
					  						<c:out value="${model.UIA_NAME}" escapeXml="false" />
											</span>
											
											<div class="settings">
												<div class="checkbox ${model.UIA_KEYNO }">
													<c:choose>
														<c:when test="${fn:contains(menuData.MN_URL,'/member')}">
															<span style="color:gray;">설정불가(로그인 관련 url)</span>	
														</c:when>
														<c:when test="${fn:contains(MainMenuAuth.MAIN_AUTH_KEY,model.UIA_KEYNO) }">
															<!-- 부모그룹이 없거나 // 부모 그룹이 있고, 부모 그룹에서 접근권한이 있을경우 -->
															<c:if test="${action eq 'Insert' }">
																<c:if test="${model.MN_PAGEDIV_C eq sp:getData('MENU_TYPE_PAGE') || (model.MN_PAGEDIV_C eq sp:getData('MENU_TYPE_SUBMENU') && not empty model.MN_FORWARD_URL)}">
																<label>
																	<c:set var="actionCheck" value="${fn:contains(model.UIR_KEYNO,sp:getData('AUTHORITY_ROLE_ACTION')) ? 'checked':'' }"/>
																	<input type="checkbox" class="checkbox style-3 action" name="actionRole" value="${model.UIA_KEYNO }">
																	<span>수정권한</span>
																</label>
																</c:if>
																<label>
																	<c:set var="accessCheck" value="${fn:contains(model.UIR_KEYNO,sp:getData('AUTHORITY_ROLE_ACCESS')) ? 'checked':'' }"/>
																	<c:set var="isBoardClass" value="${menuData.MN_PAGEDIV_C eq sp:getData('MENU_TYPE_BOARD') ? 'board':'' }"/>
																	<c:if test="${fn:contains(model.UIR_KEYNO,sp:getData('AUTHORITY_ROLE_ACCESS'))}">
																		<input type="checkbox" class="checkbox style-3 access ${isBoardClass }" name="accessRole" value="${model.UIA_KEYNO }">
																		<span>접근권한 </span>
																	</c:if>
																	<c:if test="${!fn:contains(model.UIR_KEYNO,sp:getData('AUTHORITY_ROLE_ACCESS'))}">
																		<span style="color:gray;" class="noAccess" data-val="${model.UIA_KEYNO }">접근불가</span>	
																	</c:if>
																</label>
																<label class="viewLebel">
																	<c:set var="viewChecked" value="${fn:contains(model.UIR_KEYNO,sp:getData('AUTHORITY_ROLE_VIEW')) ? 'checked':'' }"/>
																	<input type="checkbox" class="checkbox style-3 view ${accessCheck}" name="viewRole" value="${model.UIA_KEYNO }" ${viewChecked}>
																	<span>뷰권한</span>
																</label>
																<div class="boardDiv">
																	<label class="boardRole">
																		<input type="checkbox" class="checkbox style-3 all" value="">
																		<span>모든 권한</span>
																	</label>
																	<c:forEach items="${boardAuthorityList }" var="boardAuth">
																	<label class="boardRole">
																		<c:set var="roleCheck" value="${fn:contains(model.UIR_KEYNO,boardAuth.UIR_KEYNO) ? 'checked':'' }"/>
																		<input type="checkbox" class="checkbox style-3 ${boardAuth.UIR_NAME}" name="${boardAuth.UIR_NAME}Role" value="${model.UIA_KEYNO }" ${roleCheck }>
																		<span>${boardAuth.UIR_COMMENT}</span>
																	</label>
																	</c:forEach>
																</div>
																<div class="clear"></div>
															</c:if>
															<c:if test="${action eq 'Update' }">
																<c:if test="${model.MN_PAGEDIV_C eq sp:getData('MENU_TYPE_PAGE') || (model.MN_PAGEDIV_C eq sp:getData('MENU_TYPE_SUBMENU') && not empty model.MN_FORWARD_URL)}">
																<label>
																	<c:set var="actionCheck" value="${fn:contains(model.UIR_KEYNO,sp:getData('AUTHORITY_ROLE_ACTION')) ? 'checked':'' }"/>
																	<input type="checkbox" class="checkbox style-3 action" name="actionRole" value="${model.UIA_KEYNO }" ${actionCheck}>
																	<span>수정권한</span>
																</label>
																</c:if>
																<label>
																	<c:set var="accessCheck" value="${fn:contains(model.UIR_KEYNO,sp:getData('AUTHORITY_ROLE_ACCESS')) ? 'checked':'' }"/>
																	<c:set var="isBoardClass" value="${menuData.MN_PAGEDIV_C eq sp:getData('MENU_TYPE_BOARD') ? 'board':'' }"/>
																	<input type="checkbox" class="checkbox style-3 access ${isBoardClass }" name="accessRole" value="${model.UIA_KEYNO }" ${accessCheck}>
																	<span>접근권한</span>
																</label>
																<label class="viewLebel">
																	<c:set var="viewChecked" value="${fn:contains(model.UIR_KEYNO,sp:getData('AUTHORITY_ROLE_VIEW')) ? 'checked':'' }"/>
																	<input type="checkbox" class="checkbox style-3 view ${accessCheck}" name="viewRole" value="${model.UIA_KEYNO }" ${viewChecked}>
																	<span>뷰권한</span>
																</label>
																<div class="boardDiv">
																	<label class="boardRole">
																		<input type="checkbox" class="checkbox style-3 all" value="">
																		<span>모든 권한</span>
																	</label>
																	<c:forEach items="${boardAuthorityList }" var="boardAuth">
																	<label class="boardRole">
																		<c:set var="roleCheck" value="${fn:contains(model.UIR_KEYNO,boardAuth.UIR_KEYNO) ? 'checked':'' }"/>
																		<input type="checkbox" class="checkbox style-3 ${boardAuth.UIR_NAME}" name="${boardAuth.UIR_NAME}Role" value="${model.UIA_KEYNO }" ${roleCheck }>
																		<span>${boardAuth.UIR_COMMENT}</span>
																	</label>
																	</c:forEach>
																</div>
																<div class="clear"></div>	
															</c:if>
														</c:when>
														<c:otherwise>
															<span style="color:gray;" class="noAccess" data-val="${model.UIA_KEYNO }">접근불가</span>	
															
															<c:set var="viewChecked" value="${fn:contains(model.UIR_KEYNO,sp:getData('AUTHORITY_ROLE_VIEW')) ? 'checked':'' }"/>
															<label class="viewLebel">
																<input type="checkbox" class="checkbox style-3 view" name="viewRole" value="${model.MN_KEYNO }" ${viewChecked }>
																<span>뷰권한</span>
															</label>
														</c:otherwise>
													</c:choose>
												</div>
											</div>
												<c:if test="${model.CHILD_CNT gt 0}">
													<ul>
												</c:if>
											
												<c:if test="${model.CHILD_CNT eq 0 && model.SIBLING_CNT eq model.UIA_ORDER}">
												</ul>
											</li>
												<c:forEach begin="1" end="${model.UIA_DEPTH - 1}">
											</ul>
												</c:forEach>
												</c:if>
												<c:if test="${model.UIA_DIVISION eq 'A' && model.CHILD_CNT gt 0}">
													<c:set var="endCnt" value="${model.CHILD_CNT }"/>
													<c:set var="parentSibling" value="${model.SIBLING_CNT }"/>
												</c:if>
												
												<c:if test="${model.UIA_DIVISION eq 'U'}">
												<c:set var="userCount" value="${userCount + 1 }"/>
													<c:if test="${userCount eq model.SIBLING_CNT }">
														<c:if test="${parentSibling le 1 }">
														</ul>
														</c:if>
														</li>
															<c:forEach begin="1" end="${endCnt}">
														</ul>
															</c:forEach>
													</c:if>
												</c:if>
												<c:if test="${model.UIA_DIVISION ne 'U'}">
													<c:set var="userCount" value="0"/>
												</c:if>
												
												
										<c:if test="${status.last && model.UIA_DEPTH gt 1}">
											<c:forEach begin="1" end="${model.UIA_DEPTH - 1}">
											</ul>
										</li>
											</c:forEach>
										</c:if>
										<c:set var="beforeDepth" value="${model.UIA_DEPTH }"/>			
									
								</c:forEach>
							</div>
						</div>
					</div>
				</div>
				
				<c:if test="${action eq 'Update' }">
				<div id="menuList-tab-content-3" class="tab-pane fade in widget-body smart-form">
					<br/>
					
					<input type="hidden" id="dethPageDiv"  name="dethPageDiv"   value="${resultData.MN_PAGEDIV_C}" >
					<input type="hidden" id="dethOriORDER" name="dethOriORDER"  value="${resultData.MN_ORDER}" >
					<input type="hidden" id="dethOriMAIN"  name="dethOriMAIN"   value="${resultData.MN_MAINKEY}" >
					<input type="hidden" id="dethCHANGEYN" name="dethCHANGEYN"  value="N" >
					<input type="hidden" id="dethChUrl"    name="dethChUrl"     value="" >
					<fieldset>
						<legend class="col-xs-12 col-sm-12 col-md-12 col-lg-12 paddingBottom">
							<div class="divLeft">
								<span><c:out value="${resultData.MN_NAME}"/></span>
							</div>
						</legend>
						<section class="col-xs-12 col-sm-12 col-md-12 col-lg-12 marginTop">
							<div class="form-group">
								<label class="col-xs-2 col-sm-2 col-md-2 col-lg-2 control-label labeltitle"><span>*</span> 상위메뉴 선택</label>
								<div class="col-xs-10 col-sm-10 col-md-10 col-lg-10">
									<select class="form-control input-sm select2" id="dethSubMenuKey" name="dethSubMenuKey" onchange="pf_changeDethMenu();">
									<c:forEach items="${menuSubMenuList }" var="model">
										<option value="${model.MN_KEYNO }" ${resultData.MN_MAINKEY eq model.MN_KEYNO ? 'selected' : ''} data-url="${model.MN_URL}"><c:out value="${model.MAINNAME}" /> - <c:out value="${model.MN_NAME}"/></option>
									</c:forEach>
									</select>
								</dd>
								</div>
						    </div>
					    </section>
					    </section>
						<section class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
							<div class="form-group">
								<label class="col-xs-2 col-sm-2 col-md-2 col-lg-2 control-label labeltitle">현재 URL</label>
								<div class="col-xs-10 col-sm-10 col-md-10 col-lg-10">
									 <label class="input" for="dethcurrentURL">
										<div class="url-input" style="border: 1px solid #BDBDBD;">
											<span class="url-input-span" id="dethcurrentURL"><c:out value="${resultData.MN_URL }"/></span>
											<div class="clear"></div>
										</div>
									</label>
								</div>
						    </div>
					    </section>
						<section class="col-xs-12 col-sm-12 col-md-12 col-lg-12" id="deth-URLBOX" name="deth-URLBOX">
							<div class="form-group">
								<label class="col-xs-2 col-sm-2 col-md-2 col-lg-2 control-label labeltitle"><span>*</span> 변경 URL 입력</label>
								<div class="col-xs-10 col-sm-10 col-md-10 col-lg-10">
									 <label class="input" for="dethchangeURL">
										<div class="url-input" style="border: 1px solid #BDBDBD;">
											<span class="url-input-span" id="dethpreURL">/test/aaa/bbb</span>
											<i class="icon-append fa fa-question-circle"></i>
											<input type='text' id="dethchangeURL" maxlength="150" style="width: auto;">
										    <b class="tooltip tooltip-top-right"> <i class="fa fa-warning txt-color-teal"></i> 소메뉴형은 띄어쓰기 없이 영문으로 작성되어야되고, 소메뉴형이 아닐경우 마지막은 .do로 끝나야됩니다.</b>
											<div class="clear"></div>
										</div>
									</label>
								</div>
						    </div>
					    </section>
					</fieldset>
				</div>
				</c:if>
				</div>
			
		<ul class="fixed-btns">
			<li>
				<a href="javascript:;" onclick="pf_Mainmenu_action('${action}')" class="btn btn-primary btn-circle btn-lg"><i class="fa fa-save"></i></a>
			</li>
			<li>
				<a href="javascript:;" onclick="pf_moveTop()" class="btn btn-default btn-circle btn-lg"><i class="fa fa-chevron-up"></i></a>
			</li>
		</ul>
		</div>
	</div>
</div>

<%@ include file="/WEB-INF/jsp/dyAdmin/homepage/menu/script/pra_menu_list_insert_script.jsp" %>
<%@ include file="/WEB-INF/jsp/dyAdmin/homepage/menu/script/pra_menu_list_authority_script.jsp" %>
<%@ include file="/WEB-INF/jsp/dyAdmin/homepage/menu/script/pra_menu_list_move_script.jsp" %>
