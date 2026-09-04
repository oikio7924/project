<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>
<link type="text/css" rel="stylesheet" href="/resources/common/css/gonggongnuli.css">
<script>
	$(function(){
		 
		$('#koglType1').click(function(){
			$(".codeView02, .codeView03,.codeView04,.codeView05").addClass('hide');
			$(".codeView01").removeClass('hide');
		}); //type1 check
		$('#koglType2').click(function(){
			$(".codeView01, .codeView03,.codeView04,.codeView05").addClass('hide');
			$(".codeView02").removeClass('hide');
		}); //type2 check
		$('#koglType3').click(function(){
			$(".codeView02, .codeView01,.codeView04,.codeView05").addClass('hide');
			$(".codeView03").removeClass('hide');
		}); //type3 check
		$('#koglType4').click(function(){
			$(".codeView02, .codeView03,.codeView01,.codeView05").addClass('hide');
			$(".codeView04").removeClass('hide');
		}); //type4 check
		$('#koglType5').click(function(){
			$(".codeView02, .codeView03,.codeView04,.codeView01").addClass('hide');
			$(".codeView05").removeClass('hide');
		}); //적용불가 check
	})	
</script>

<div>
	<div class="gonggong-div">
		<h3 class="gonggong-h3">공공누리 적용</h3>
		<p class="gonggong-p">저작권법 24조의2에 따라 국가나 지방자치단체, 공공기관이 업무상 작성하여 공표한 저작물이나 저작재산권 전부를 보유한 저작물은 국민이 허락 없이 이용할 수 있으며, 이에 따라 개방기관은 공공저작물 자유이용에 관한 표시를 하여야 합니다. </p>
	<a href="http://www.kogl.or.kr/info/freeUse.do" target="_blank"><span>▶</span> 상세내용 : 공공누리 홈페이지 참조</a>
	</div>

	<div class="gong-divWrap">
		<h4><img src="/resources/img/codetype/title_codetype.gif" alt="공공누리 유형선택 open 공공저작물 자유이용 허락표시 기준적용"/></h4>
		<ul>
			<li>
				<input type="radio" name="rgt_type_code" id="koglType1" value="1" ${empty BoardNotice.BN_GONGNULI_TYPE || BoardNotice.BN_GONGNULI_TYPE eq '1' ? 'checked' : ''}/>
				<label for="koglType1">
				<img src="/resources/img/codetype/new_img_opencode1.jpg" alt="" style="width:149px;" /> 
				1유형 : 출처표시 (상업적 이용 및 변경 가능)
				</label>
			</li>
			<li>
				<input type="radio" name="rgt_type_code" id="koglType2" value="2" ${BoardNotice.BN_GONGNULI_TYPE eq '2' ? 'checked' : ''}/>
				<label for="koglType2">
				<img src="/resources/img/codetype/new_img_opencode2.jpg" alt="" style="width:183px;" />  
				2유형 : 출처표시 + 상업적이용금지
				</label>
			</li>
			<li>
				<input type="radio" name="rgt_type_code" id="koglType3" value="3" ${BoardNotice.BN_GONGNULI_TYPE eq '3' ? 'checked' : ''}/>
				<label for="koglType3">
				<img src="/resources/img/codetype/new_img_opencode3.jpg" alt="" style="width:183px;" />  
				3유형 : 출처표시 + 변경금지
				</label>
			</li>
			<li>
				<input type="radio" name="rgt_type_code" id="koglType4" value="4" ${BoardNotice.BN_GONGNULI_TYPE eq '4' ? 'checked' : ''}/>
				<label for="koglType4">
				<img src="/resources/img/codetype/new_img_opencode4.jpg" alt="" style="width:219px;" />  
				4유형 : 출처표시 + 상업적이용금지 + 변경금지
				</label>
			</li>
			<li>
				<input type="radio" name="rgt_type_code" id="koglType5" value="5" ${BoardNotice.BN_GONGNULI_TYPE eq '5' ? 'checked' : ''}/>
				<label for="koglType5">
				<img src="/resources/img/codetype/new_img_opencode0.jpg" alt="" style="width:219px;" />  
				자유이용 불가 (저작권법 제24조의2 제1항 제1호 ~ 4호 중 어느 하나에 해당됨)
				</label>
				<a href="http://www.law.go.kr/법령/저작권법" target="_blank"> 
				<span style="font-size:10px;color:#595959;">▶</span> 해당사항 확인 (국가법령정보센터)</a>
			</li>
		</ul>
		
		<h5 class="gonggong-h5"><img src="/resources/img/codetype/title_ex.gif" alt="유형선택 적용예시"/></h5>
		<div class="gonggong-h5-div codeView01"  style="padding:25px 15px 30px 190px;"><img src="/resources/img/codetype/new_img_opencode1.jpg" alt="" style="width:149px;" /> 본 공공저작물은 공공누리 "출처표시" 조건에 따라 이용할 수 있습니다.</div>
		<div class="gonggong-h5-div codeView02 hide" style="padding:25px 15px 30px 225px;"><img src="/resources/img/codetype/new_img_opencode2.jpg" alt="" style="width:183px;" /> 본 공공저작물은 공공누리  “출처표시+상업적이용금지”  조건에  따라  이용할  수  있습니다.</div>
		<div class="gonggong-h5-div codeView03 hide" style="padding:25px 15px 30px 225px;"><img src="/resources/img/codetype/new_img_opencode3.jpg" alt="" style="width:183px;" /> 본 공공저작물은 공공누리  “출처표시+변경금지”  조건에  따라  이용할  수  있습니다.</div>
		<div class="gonggong-h5-div codeView04 hide" style="padding:25px 15px 30px 260px;"><img src="/resources/img/codetype/new_img_opencode4.jpg" alt="" style="width:219px;" /> 본 공공저작물은 공공누리 “출처표시+상업적이용금지+변경금지”  조건에  따라  이용할  수  있습니다.</div>
		<div class="gonggong-h5-div codeView05 hide" style="padding:17px 15px  17px 60px;"><img src="/resources/img/codetype/img_opencode0_1.jpg" alt="" style="width:27px;" /> 자유이용을 불가합니다.</div>
	</div>
	<div class="gonggong-comment">
		<p> <strong style="font-size:11px;color:#dd494e;font-weight:bold;">공공누리 제2~4유형</strong> 의 적용은 공동저작물 등 제3자의 권리가 포함된 저작물에 한하여 제3자의 이용허락 범위에 따라 <strong style="font-size:11px;color:#dd494e;font-weight:bold;">제한적으로 적용</strong></p>
		<p> &middot; 공공저작권 관련 상담센터 <span style="margin-left:10px;"> <img src="/resources/img/codetype/icon_codetel.gif"  alt="전화" />1670-0052</span></p>
	</div>
</div> 