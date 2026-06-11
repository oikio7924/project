<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>
<div class="subRightContentsTopWrap">
	<div class="titleBox clearfix">
    	<h1>
    		<c:if test="${currentMenu.MN_LEV eq '2' }">
    		${currentMenu.MN_NAME }
	    	</c:if>
	    	<c:if test="${currentMenu.MN_LEV eq '3' }">
    		${currentMenu.HIGH_MN_NAME }
	    	</c:if>
    	</h1>
    	<div class="printBox viewPc">
         	<ul class="text_size clearfix">
             	<li class="text_print">
                 	<a href="javascript:;" onclick="cf_print()"><img src="/resources/img/sub/img_subTopPrintFont_02_print.jpg" alt="인쇄"></a>
                 </li>
                 <li class="text_name">
                 	<img src="/resources/img/sub/img_subTopPrintFont_02_fontSize.jpg" alt="폰트크기 글자">
                 </li>
             	<li class="text_increase">
                 	<a href="javascript:;" onclick="pf_resizeFont('subRightContentsBottomWrap','increase')"><img src="/resources/img/sub/img_subTopPrintFont_02_fontSize_Plus.jpg" alt="폰트크기 증가"></a>
                 </li>
             	<li class="text_decrease">
                 	<a href="javascript:;" onclick="pf_resizeFont('subRightContentsBottomWrap','decrease')"><img src="/resources/img/sub/img_subTopPrintFont_02_fontSize_Minus.jpg" alt="폰트크기 감소"></a>
                 </li>
             	<li class="text_reset">
                 	<a href="javascript:;" onclick="pf_resizeFont('subRightContentsBottomWrap','initial')"><img src="/resources/img/sub/img_subTopPrintFont_02_fontSize_Reset.jpg" alt="폰트크기 되돌리기"></a>
                 </li>
             </ul>
         </div>
    </div>
    <div class="addressBox viewPC clearfix">
    <c:if test="${currentMenu.MN_DEP ne '' }">
    	<p>담당부서 : <c:out value="${currentMenu.MN_DEP}"/></p>
    </c:if>
    </div>
    
</div>
<c:if test="${currentMenu.MN_LEV eq '3' }">
	<div class="subMenuTabBox viewPc"> <!------- PC버전의 서브탭 ----->
		<c:set var="index" value="0"/>
		<c:choose>
		<c:when test="${currentMenu.MN_MAINKEY eq 'MN_0000000307' ||  currentMenu.MN_MAINKEY eq 'MN_0000000278' }"> 
		<!-- 지역기관·단체소식   //  경영공시  -->
			<c:forEach items="${ menuList}" var="model" varStatus="status">
			<c:if test="${model.MN_LEV eq '3' && model.MN_MAINKEY eq currentMenu.MN_MAINKEY }">
				<c:set var="index" value="${index + 1}"/>
				<c:if test="${index mod 4 eq 1 }">
				<ul class="subMenuRow subMenuRowW04">
				</c:if>
				<sec:authorize url="${model.MN_URL}">
				<li class="${model.MN_KEYNO eq currentMenu.MN_KEYNO ? 'active':'' }">
					<a href="javascript:;" onclick="pf_moveMenu('${model.MN_REAL_URL}','${model.MN_PAGEDIV_C }','${model.MN_NEWLINK}')">
						${model.MN_NAME }
					</a>
				</li>
				</sec:authorize>
				<c:if test="${status.last || index mod 4 eq 0 }">
				</ul>
				</c:if>
			</c:if>
			</c:forEach>
		</c:when>
		<c:otherwise>
			<c:forEach items="${ menuList}" var="model" varStatus="status">
			<c:if test="${model.MN_LEV eq '3' && model.MN_MAINKEY eq currentMenu.MN_MAINKEY }">
				<c:set var="index" value="${index + 1}"/>
				<c:if test="${index mod 3 eq 1 }">
				<ul class="subMenuRow">
				</c:if>
				<sec:authorize url="${model.MN_URL}">
				<li class="${model.MN_KEYNO eq currentMenu.MN_KEYNO ? 'active':'' }">
					<a href="javascript:;" onclick="pf_moveMenu('${model.MN_REAL_URL}','${model.MN_PAGEDIV_C }','${model.MN_NEWLINK}')">
						${model.MN_NAME }
					</a>
				</li>
				</sec:authorize>
				<c:if test="${status.last || index mod 3 eq 0 }">
				</ul>
				</c:if>
			</c:if>
			</c:forEach>
		</c:otherwise>
		</c:choose>
	</div>
	<div class="mobileSubMenuTab viewMobile"> <!------- 모바일버전의 서브탭 ----->
	    <p class="title"><a href="javascript:;">${currentMenu.MN_NAME }</a></p>
	    <ul class="menuList">
	    	<c:forEach items="${ menuList}" var="model" varStatus="status">
			<c:if test="${model.MN_LEV eq '3' && model.MN_MAINKEY eq currentMenu.MN_MAINKEY }">
				<sec:authorize url="${model.MN_URL}">
				<li class="${model.MN_KEYNO eq currentMenu.MN_KEYNO ? 'active':'' }">
					<a href="javascript:;" onclick="pf_moveMenu('${model.MN_REAL_URL}','${model.MN_PAGEDIV_C }','${model.MN_NEWLINK}')">
						${model.MN_NAME }
					</a>
				</li>
				</sec:authorize>
			</c:if>
			</c:forEach>
	    </ul>
	</div>
	
</c:if>


<script>


function pf_resizeFont(name,act){
	$('.'+name+" *").not('.no_resize_font, br').each(function(){
		if(!$(this).data("fs-initial")){
			$(this).data("fs-initial",$(this).css("font-size"));	
		}
		$(this).data("fs",$(this).css("font-size"));	
		set_font_size($(this),act)
	});
}

function set_font_size($el, act)
{
    var x = 0;
    var fs = $el.data("fs");
    var unit = fs.replace(/[0-9\.]/g, "");
    var fsize = parseFloat(fs.replace(/[^0-9\.]/g, ""));
    var nfsize;

    if(!fsize)
        return true;

    if(unit == "em")
        x = 1;

    if(act == "increase") {
        nfsize = (fsize * 1.2);
    }else if(act == "decrease"){
        nfsize = (fsize / 1.2);
    }else if(act == "initial"){
    	var fs2 = $el.data("fs-initial");
    	var fsize2 = parseFloat(fs2.replace(/[^0-9\.]/g, ""));
    	nfsize  = fsize2;
    }else{
    	return false;
    }

    nfsize = nfsize.toFixed(x);

    $el.css("font-size", nfsize+unit);
    $el.data("fs", nfsize+unit);
}



</script>
