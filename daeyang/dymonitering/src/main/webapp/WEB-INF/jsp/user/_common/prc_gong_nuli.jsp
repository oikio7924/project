<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>

<style>
.resultCode{position:relative;margin:0;padding:0;margin-top:5px;background:#fff;border:1px solid #dbdbdb;font-size:12px;color:#292929;font-weight:bold;}
</style>

<c:choose>
	<c:when test="${currentMenu.MN_GONGNULI_TYPE eq '1' }">
		<div class="resultCode codeView01"  style="padding:25px 15px 30px 190px;"><img src="/resources/img/codetype/new_img_opencode1.jpg" alt="" style="position:absolute;left:20px;top:12%;vertical-align:middle;width:149px;height:54px;" /> 본 공공저작물은 공공누리 "출처표시" 조건에 따라 이용할 수 있습니다.</div>
	</c:when>
	<c:when test="${currentMenu.MN_GONGNULI_TYPE eq '2' }">
		<div class="resultCode codeView02" style="padding:25px 15px 30px 225px;"><img src="/resources/img/codetype/new_img_opencode2.jpg" alt="" style="position:absolute;left:20px;top:12%;vertical-align:middle;width:183px;height:54px;" /> 본 공공저작물은 공공누리  “출처표시+상업적이용금지”  조건에  따라  이용할  수  있습니다.</div>
	</c:when>
	<c:when test="${currentMenu.MN_GONGNULI_TYPE eq '3' }">
		<div class="resultCode codeView03" style="padding:25px 15px 30px 225px;"><img src="/resources/img/codetype/new_img_opencode3.jpg" alt="" style="position:absolute;left:20px;top:12%;vertical-align:middle;width:183px;height:54px;" /> 본 공공저작물은 공공누리  “출처표시+변경금지”  조건에  따라  이용할  수  있습니다.</div>
	</c:when>
	<c:when test="${currentMenu.MN_GONGNULI_TYPE eq '4' }">
		<div class="resultCode codeView04" style="padding:25px 15px 30px 260px;"><img src="/resources/img/codetype/new_img_opencode4.jpg" alt="" style="position:absolute;left:20px;top:12%;vertical-align:middle;width:219px;height:54px;" /> 본 공공저작물은 공공누리 “출처표시+상업적이용금지+변경금지”  조건에  따라  이용할  수  있습니다.</div>
	</c:when>
	<c:when test="${currentMenu.MN_GONGNULI_TYPE eq '5' }">
		<div class="resultCode codeView05" style="padding:17px 15px  17px 60px;"><img src="/resources/img/codetype/new_img_opencode5.jpg" alt="" style="position:absolute;left:20px;top:25%;vertical-align:middle;width:27px;height:27px;" /> 자유이용을 불가합니다.</div>
	</c:when>
	<c:otherwise>
		<c:choose>
			<c:when test="${BoardNotice.BN_GONGNULI_TYPE eq '1' }">
				<div class="resultCode codeView01"  style="padding:25px 15px 30px 190px;"><img src="/resources/img/codetype/new_img_opencode1.jpg" alt="" style="position:absolute;left:20px;top:12%;vertical-align:middle;width:149px;height:54px;" /> 본 공공저작물은 공공누리 "출처표시" 조건에 따라 이용할 수 있습니다.</div>
			</c:when>
			<c:when test="${BoardNotice.BN_GONGNULI_TYPE eq '2' }">
				<div class="resultCode codeView02" style="padding:25px 15px 30px 225px;"><img src="/resources/img/codetype/new_img_opencode2.jpg" alt="" style="position:absolute;left:20px;top:12%;vertical-align:middle;width:183px;height:54px;" /> 본 공공저작물은 공공누리  “출처표시+상업적이용금지”  조건에  따라  이용할  수  있습니다.</div>
			</c:when>
			<c:when test="${BoardNotice.BN_GONGNULI_TYPE eq '3' }">
				<div class="resultCode codeView03" style="padding:25px 15px 30px 225px;"><img src="/resources/img/codetype/new_img_opencode3.jpg" alt="" style="position:absolute;left:20px;top:12%;vertical-align:middle;width:183px;height:54px;" /> 본 공공저작물은 공공누리  “출처표시+변경금지”  조건에  따라  이용할  수  있습니다.</div>
			</c:when>
			<c:when test="${BoardNotice.BN_GONGNULI_TYPE eq '4' }">
				<div class="resultCode codeView04" style="padding:25px 15px 30px 260px;"><img src="/resources/img/codetype/new_img_opencode4.jpg" alt="" style="position:absolute;left:20px;top:12%;vertical-align:middle;width:219px;height:54px;" /> 본 공공저작물은 공공누리 “출처표시+상업적이용금지+변경금지”  조건에  따라  이용할  수  있습니다.</div>
			</c:when>
			<c:when test="${BoardNotice.BN_GONGNULI_TYPE eq '5' }">
				<div class="resultCode codeView05" style="padding:17px 15px  17px 60px;"><img src="/resources/img/codetype/new_img_opencode5.jpg" alt="" style="position:absolute;left:20px;top:25%;vertical-align:middle;width:27px;height:27px;" /> 자유이용을 불가합니다.</div>
			</c:when>
		</c:choose>
	</c:otherwise>
</c:choose>
