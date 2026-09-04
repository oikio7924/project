<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<script type="text/javascript">

//Qr코드 다운로드
function pf_getQrCode(){
	
	cf_replaceTrim($("#qrcodeList"));

	  $.ajax({
			type: "POST",
			url: "/dyAdmin/operation/qrcode/insertAjax.do",
			data: $('#qrcodeList').serializeArray(),
			async:false,
			success : function(data){
				if(data != ''){
				
					$("#qrimg").attr("src",data.THUMBNAIL_PUBLIC_PATH);
					$("#CQ_FS_KEYNO").attr("value",data.CQ_FS_KEYNO);
					$("#encodeFsKey").val(data.CQ_FS_KEYNO);
					var qrcodeName = document.getElementById('qrcodeName');
					qrcodeName.innerHTML = data.CQ_NAME;
					$('#grimgWrap').css('width',$('#CQ_WIDTH').val() || 150)
					$('#grimgInner').css('height',$('#CQ_HEIGHT').val() || 150)
					
					$('#qr_download').show();
				}else{
					alert('QR코드 만드는중 에러 발생. 관리자한테 문의하세요.')	
				}
			},
			error: function(){
				alert('QR코드 만드는중 에러 발생. 관리자한테 문의하세요.')
				return false;
			}
		});
	
}

// Qr코드 빈칸 확인
function QrCode_Save(){
	if(document.qrcodeList.CQ_URL.value.trim()==""){
		alert('URL 주소를 입력해주세요');
	}else{
		pf_getQrCode();
	}
	
}

// Qr코드 다운로드
function QrCode_Download(){
	
 var data = document.getElementById('encodeFsKey').value;
 cf_download(data);
	
}

</script>

<style>
	.btn_margin{
	 margin: 10px;
	}

	.qrcode_margin{
	 margin: 8px;
	}

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
					<h2>Qr코드 관리</h2>

				</header>
				<!-- widget div-->
				<div>

					<!-- widget content -->
					<div class="widget-body no-padding">

					  	<div role="content">

									<!-- widget content -->
									
									<form id="qrcodeList" name="qrcodeList" method="post" >
									<div class="widget-body">	
										<div class="bs-example necessT" style="text-align: left; margin: 0 10px;">
									         <span class="colorR fs12">*표시는 필수 입력 항목입니다.</span>
									     </div>														
										<div class="btn_margin">
				 						  <b><span class="nessSpan">*</span> QR코드 URL</b><input type="text"  size="67" id="CQ_URL" name="CQ_URL" class="qrcode_margin checkTrim" maxlength="200"><br>
				 			    <!--  <b>QR코드 이름 </b> --><input type="hidden" size="52" id="CQ_NAME" name="CQ_NAME" value="" class="qrcode_margin">
										  <b>QR코드 너비 </b><input type="number" size="10" id="CQ_WIDTH" name="CQ_WIDTH" class="qrcode_margin" oninput="cf_maxLengthCheck(this)" max="99999999999" maxlength="4">px &nbsp;
									      <b>QR코드 높이 </b><input type="number" size="10" id="CQ_HEIGHT" name="CQ_HEIGHT" class="qrcode_margin" oninput="cf_maxLengthCheck(this)" max="99999999999" maxlength="4">px<br>	
									      <font style="color: red;">(기본 사이즈는 150 x 150 px 입니다.)</font>	<br>
									      
									      
									      <div id="grimgWrap" style="border: 1px solid gray; width: 200px;  margin-top: 10px;">
									        <div  id="grimgInner" style="border: 1px solid gray; text-align: center; height: 200px;">
									          <img id="qrimg" alt="" style="width:100%;height:100%;">
									        </div>
									        <div style="margin-top : 10px; text-align: center;height:50px;">
									          <b>Qr코드 이름 : <font id="qrcodeName"></font> </b>
									          <input type="hidden" id="CQ_FS_KEYNO" name="CQ_FS_KEYNO" value="">
									          <input type="hidden" id="encodeFsKey" name="encodeFsKey" value="">
									        </div>
									      </div>								
										</div>
										<input class="btn_margin btn btn-sm btn-primary" type="button" onclick="QrCode_Save()" value="QRCODE 저장">
										<input class="btn_margin btn btn-success" type="button" onclick="QrCode_Download()" value="QRCODE 다운로드" id="qr_download" style="display:none;">
									</div>
									</form>
									<!-- end widget content -->

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
	
</script>