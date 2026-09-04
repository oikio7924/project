<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>


<!-- widget grid -->
<form:form id="Form" name="Form" method="post" action="" class="form-inline" role="form">
<section id="widget-grid" class="">
	<div class="row">
		<article class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
			<!-- Widget ID (each widget will need unique ID)-->
			<div class="jarviswidget jarviswidget-color-blueDark" id="wid-id-0"
				data-widget-editbutton="false">
				<header>
					<span class="widget-icon"> <i class="fa fa-table"></i>
					</span>
					<h2>할인정책 리스트</h2>
				</header>
				<div class="widget-body" >
					<div class="widget-body-toolbar bg-color-white">
						<div class="alert alert-info no-margin fade in">
							<button type="button" class="close" data-dismiss="alert">×</button>
							할인정책 리스트를 확인합니다.
						</div> 
					</div>
					<div class="widget-body-toolbar bg-color-white">
						<div class="row"> 
							<div class="col-sm-12 col-md-2 text-align-right" style="float:right;">
								<div class="btn-group">  
									<button class="btn btn-sm btn-primary" type="button" onclick="pf_openInsert();" >
										<i class="fa fa-plus"></i>추가
									</button>
								</div>
							</div>
						</div>
					</div>
					<div class="table-responsive">
						<jsp:include page="/WEB-INF/jsp/dyAdmin/include/search/pra_search_header_paging.jsp" flush="true">
							<jsp:param value="/dyAdmin/program/discount/pagingAjax.do" name="pagingDataUrl" />
							<jsp:param value="/dyAdmin/program/discount/excelAjax.do" name="excelDataUrl" />
						</jsp:include>
						<fieldset id="tableWrap">
						</fieldset>
					</div>
				</div>
			</div>
		</article>
	</div>
</section>
</form:form>
<!-- end widget grid -->


<!-- 할인정책 추가 다이얼로그창  -->
<div id="insertDiscount" title="할인정책 추가">
  <form:form action="/dyAdmin/program/discount/insert.do" id="insertDiscountForm" method="post">
	  <div class="widget-body no-padding smart-form">
	   <br/>
	    <fieldset>
	    	<div class="bs-example necessT">
		         <span class="colorR fs12">*표시는 필수 입력 항목입니다.</span>
		    </div>
    		<section class="col col-12">  
	          	<dl class="dl-horizontal">
		            <dt><span class="nessSpan">*</span> 사용 여부</dt>
		            <dd>
		            	<div class="inline-group">
							<label class="radio"> <input type="radio" name="AD_USE" value="Y" checked="checked"> <i></i>사용</label> 
							<label class="radio"> <input type="radio" name="AD_USE" value="N"> <i></i>미사용</label>
						</div>
		            </dd>
	        	</dl>
	      	</section>
	      	<section class="col col-12"> 
	        	<dl class="dl-horizontal">
		         	<dt><span class="nessSpan">*</span> 정책 이름</dt>
		          	<dd>
			            <label class="input"> 
			            	<i class="icon-append fa fa-question-circle"></i>
			                <input type="text" name="AD_NAME" class="AD_NAME checkTrim" placeholder="정책 이름을 입력하세요" maxlength="100"/>
			                <b class="tooltip tooltip-top-right"><i class="fa fa-warning txt-color-teal"></i> 정책 이름을 입력하세요.</b>
			            </label>
		          	</dd>
	        	</dl>
	      	</section>
	      	<section class="col col-12">  
	          	<dl class="dl-horizontal">
	            	<dt><span class="nessSpan">*</span> 할인 금액</dt>
	            	<dd>
	            		<label class="input" style="width: 200px;float: left;margin-right: 10px;"> 
			            	<i class="icon-append fa fa-question-circle"></i>
			                <input type="number" name="AD_MONEY" class="AD_MONEY" oninput="cf_maxLengthCheck(this)" max="99999" maxlength="5"/>
			                <b class="tooltip tooltip-top-right"><i class="fa fa-warning txt-color-teal"></i> 숫자만 입력하세요.</b>
			            </label>
			            <label class="select" style="width: 100px;float: left;">
							<select name="AD_TYPE" class="AD_TYPE">
								<option value="A">%</option>
								<option value="B">원</option>
							</select> <i></i> 
						</label>
               		</dd>
	          	</dl>
	      	</section>
	      	<section class="col col-12">  
	          	<dl class="dl-horizontal">
	            	<dt><span class="nessSpan">*</span> 기본적용 여부</dt>
	            	<dd>
		            	<p>* 체크시 프로그램 생성시 기본 할인가로 들어갑니다.</p>
		            	<div class="inline-group">
							<label class="radio"> <input type="radio" name="AD_DEFAULT_YN" value="Y" checked="checked"> <i></i>예</label> 
							<label class="radio"> <input type="radio" name="AD_DEFAULT_YN" value="N"> <i></i>아니요</label>
						</div>
	            	</dd>
	          	</dl>
	      	</section>
	       	<section class="col col-12"> 
	        	<dl class="dl-horizontal">
	          		<dt><span class="nessSpan">*</span> 설명</dt>
	          		<dd>
	          			<label class="textarea textarea-resizable"> 										
							<textarea rows="4" class="custom-scroll AD_COMENT checkTrim" name="AD_COMENT" maxlength="1000"></textarea> 
						</label>
	          		</dd>
	        	</dl>
	      	</section>
	    </fieldset>
	  </div>
  </form:form>
</div>


<!-- 할인정책 수정 다이얼로그창  -->
<div id="updateDiscount" title="할인정책 수정">
  	<form:form action="/dyAdmin/program/discount/update.do" id="updateDiscountForm" method="post">
 		<input type="hidden" name="AD_KEYNO" value="">
	  	<div class="widget-body no-padding smart-form">
	   <br/>
	    <fieldset>
	    	<div class="bs-example necessT">
		         <span class="colorR fs12">*표시는 필수 입력 항목입니다.</span>
		    </div>
    		<section class="col col-12">  
	          	<dl class="dl-horizontal">
		            <dt>사용 여부</dt>
		            <dd>
		            	<div class="inline-group">
							<label class="radio"> <input type="radio" name="AD_USE" value="Y" checked="checked"> <i></i>사용</label> 
							<label class="radio"> <input type="radio" name="AD_USE" value="N"> <i></i>미사용</label>
						</div>
		            </dd>
	        	</dl>
	      	</section>
	      	<section class="col col-12"> 
	        	<dl class="dl-horizontal">
		         	<dt><span class="nessSpan">*</span> 정책 이름</dt>
		          	<dd>
			            <label class="input"> 
			            	<i class="icon-append fa fa-question-circle"></i>
			                <input type="text" name="AD_NAME" class="AD_NAME" placeholder="정책 이름을 입력하세요" maxlength="100"/>
			                <b class="tooltip tooltip-top-right"><i class="fa fa-warning txt-color-teal"></i> 정책 이름을 입력하세요.</b>
			            </label>
		          	</dd>
	        	</dl>
	      	</section>
	      	<section class="col col-12">  
	          	<dl class="dl-horizontal">
	            	<dt><span class="nessSpan">*</span> 할인 금액</dt>
	            	<dd>
	            		<label class="input" style="width: 200px;float: left;margin-right: 10px;"> 
			            	<i class="icon-append fa fa-question-circle"></i>
			                <input type="number" name="AD_MONEY" class="AD_MONEY" oninput="cf_maxLengthCheck(this)" max="99999" maxlength="5"/>
			                <b class="tooltip tooltip-top-right"><i class="fa fa-warning txt-color-teal"></i> 숫자만 입력하세요.</b>
			            </label>
			            <label class="select" style="width: 100px;float: left;">
							<select name="AD_TYPE" class="AD_TYPE">
								<option value="A">%</option>
								<option value="B">원</option>
							</select> <i></i> 
						</label>
               		</dd>
	          	</dl>
	      	</section>
	      	<section class="col col-12">  
	          	<dl class="dl-horizontal">
	            	<dt>기본적용 여부</dt>
	            	<dd>
		            	<p>* 체크시 프로그램 생성시 기본 할인가로 들어갑니다.</p>
		            	<div class="inline-group">
							<label class="radio"> <input type="radio" name="AD_DEFAULT_YN" value="Y" checked="checked"> <i></i>예</label> 
							<label class="radio"> <input type="radio" name="AD_DEFAULT_YN" value="N"> <i></i>아니요</label>
						</div>
	            	</dd>
	          	</dl>
	      	</section>
	       	<section class="col col-12"> 
	        	<dl class="dl-horizontal">
	          		<dt><span class="nessSpan">*</span> 설명</dt>
	          		<dd>
	          			<label class="textarea textarea-resizable"> 										
							<textarea rows="4" class="custom-scroll AD_COMENT" name="AD_COMENT" maxlength="1000"></textarea> 
						</label>
	          		</dd>
	        	</dl>
	      	</section>
	    </fieldset>
	  </div>
  </form:form>
</div>

<!-- 할인정책 수정 다이얼로그창  -->
<div id="discountComent" title="할인정책 설명">
     <pre></pre>
</div>

<script type="text/javascript">
var memberTable;
$(function(){
	cf_setttingDialog('#insertDiscount',"할인정책 추가","저장","pf_insert()");
	cf_setttingDialog('#updateDiscount',"할인정책 수정","수정","pf_update()");
	cf_setttingDialog('#discountComent',"할인정책 설명");
	var key = '';
});

function pf_openInsert(){
	$('#insertDiscount input[type=text],#insertDiscount input[type=file]').val('');
	$('#placeimg_img').hide();
	$('#insertDiscount').dialog('open')
}

function pf_openUpdate(key){
	$.ajax({
        url: '/dyAdmin/program/discount/dataAjax.do',
        type: 'POST',
        data: {
       	 "AD_KEYNO":key
        },
        async: false,  
        success: function(data) {
        	 $('#updateDiscount input[name=AD_KEYNO]').val(data.AD_KEYNO);
             $('#updateDiscount input[name=AD_NAME]').val(data.AD_NAME);
             $('#updateDiscount input[name=AD_MONEY]').val(data.AD_MONEY);
             $('#updateDiscount select[name=AD_TYPE]').val(data.AD_TYPE);
             $('#updateDiscount textarea[name=AD_COMENT]').html(data.AD_COMENT);
             $('#updateDiscount input[name=AD_USE][value='+data.AD_USE+']').attr('checked',true);
             $('#updateDiscount input[name=AD_DEFAULT_YN][value='+data.AD_DEFAULT_YN+']').attr('checked',true);
             $('#updateDiscount').dialog('open');
             
       	},
       	error :function(){
    	   	alert('에러!! 관리자한테 문의하세요');
    	   	state = false;
       	}
  	});
}


function pf_insert(){
	
	if(!pf_formCheck('insertDiscount')){
		return false;
	}
	
	
	if(confirm('저장하시겠습니까?')){
		cf_replaceTrim($("#insertDiscountForm"));
		$('#insertDiscountForm').submit();	
	}
	
	
}

function pf_update(){
	
	if(!pf_formCheck('updateDiscount')){
		return false;
	}
	
	if(confirm('수정하시겠습니까?')){
		$('#updateDiscountForm').submit();
	}
}

function pf_formCheck(id){
	if(!cf_checkVal('#' + id + ' .AD_NAME','정책이름을 입력하여주세요.')){
		return false;
	}
	
	var discount = $('#' + id + ' .AD_MONEY').val();
	var checkDiscount = true;
	if(!discount){
		alert('할인 금액을 입력하여주세요.');
		checkDiscount = false;
	}else{
		var discountType = $('#' + id + ' .AD_TYPE').val();
		discount = Number(discount);
		if(discountType == 'A' && (discount < 1 || discount > 100)){
			alert('할인률은 1~100% 사이의 값만 가능합니다.');
			checkDiscount = false;
		}else if(discountType == 'B' && discount < 1 ){
			alert('할인금액은 1원 보다 커야됩니다.');
			checkDiscount = false;
		}
	}
	
	if(!checkDiscount){
		$('#' + id + ' .AD_MONEY').focus();
		return false;
	}
	
	if(!cf_checkVal('#' + id + ' .AD_COMENT','정책설명을 입력하여주세요.')){
		return false;
	}
	return true;
}


function pf_delete(key){
	if(confirm('정말 삭제하시겠습니까?')){
		location.href='/dyAdmin/program/discount/delete.do?key='+key
	}
}

function pf_openComent(obj){
	$('#discountComent').dialog('open');
	$('#discountComent pre').html($(obj).parent().find('span').html());
}

</script>