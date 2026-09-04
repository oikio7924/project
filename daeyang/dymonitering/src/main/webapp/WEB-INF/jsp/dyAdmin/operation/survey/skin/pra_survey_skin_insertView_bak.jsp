<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>
<%@ include file="/WEB-INF/jsp/dyAdmin/include/CodeMirror_Include.jsp" %>
<script type="text/javascript" src="/resources/common/js/common/diff_match_patch.js"></script>
<style>
  .customTitle { width: 90px; height: 20px; }
</style>

<section id="widget-grid" class="">

    <div class="row">

        <article class="col-xs-12 col-sm-12 col-md-12 col-lg-12">

            <div class="jarviswidget jarviswidget-color-darken" id="wid-id-0" data-widget-editbutton="false">
                <header>
                    <span class="widget-icon"> <i class="fa fa-table"></i>
                    </span>
                    <h2>설문 스킨 설정</h2>
                </header>
                <div>
                    <div class="jarviswidget-editbox"></div>
                    <div class="widget-body">
                        <div class="widget-body-toolbar bg-color-white">
                            <div class="alert alert-info no-margin fade in">
                                <button type="button" class="close" data-dismiss="alert">×</button>
                                설문 관리 스킨을 등록 / 수정하실 수 있습니다.<br>
	                            <span style="color: red;">* 현재 적용되고 있는 스킨은 삭제하실 수 없습니다.</span>                                
                            </div>
                        </div>
                        <form:form id="Form" method="post">
                            <input type="hidden" name="SS_KEYNO" id="SS_KEYNO" value="">
                            <input type="hidden" name="action" id="action" value="${action}">
                            <input type="hidden" name="SS_DATA" id="SS_DATA_TEMP" value="">

                            <div id="myTabContent1" class="tab-content padding-10 form-horizontal bv-form">
                                <div>
                                    <table id="" class="table table-bordered table-striped">
                                        <colgroup>
                                            <col style="width: 20%;">
                                            <col style="width: 30%;">
                                            <col style="width: 20%;">
                                            <col style="width: 30%;">
                                        </colgroup>
                                        <tbody>
                                            <c:if test="${!empty count }">
                                                <tr>
                                                    <td>작성자</td>
                                                    <td id="REGNM">
                                                    </td>
                                                    <td>작성일</td>
                                                    <td id="REGDT">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>최근 게시물 수정자</td>
                                                    <td id="MODNM">
                                                    </td>
                                                    <td>최근 게시물 수정일자</td>
                                                    <td id="MODDT">
                                                    </td>
                                                </tr>
                                            </c:if>
                                            <tr>
                                                <td><span class="nessSpan">*</span>스킨 이름</td>
                                                <td colspan="3">
                                                    <input type="text" class="form-control" name="SS_SKIN_NAME" id="SS_SKIN_NAME" data-bv-field="fullName" maxlength="500" placeholder="수정하시려면 입력해주세요.">
                                            </tr>
                                            <tr>
                                                <td><span class="nessSpan">*</span>코멘트</td>
                                                <td colspan="3">
                                                    <input type="text" class="form-control" name="SSH_COMMENT" id="SSH_COMMENT" data-bv-field="fullName" maxlength="500" placeholder="no message">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="4">내용</td>
                                            </tr>
                                            <tr>
                                                <td colspan="4">
                                                    <textarea class="form-control ckWebEditor" id="SS_DATA" style="width:100%;height:500px;min-width:260px;" data-bv-field="content"></textarea>
                                                </td>
                                            </tr>

                                            <tr>
                                                <td colspan="4">
                                                    <fieldset class="padding-10 text-right">
                                                        <button type="button" onclick="pf_skinInsert();" class="btn btn-sm btn-primary">
                                                            <i class="fa fa-floppy-o"></i> 저장
                                                        </button>
                                                     	<c:if test="${action eq 'update'}">
                                                        <button class="btn btn-sm btn-danger" id="Board_Edit" type="button" onclick="pf_skinDelete()">
                                                            <i class="fa fa-floppy-o"></i> 삭제
                                                        </button>
														</c:if>
                                                        <button class="btn btn-sm btn-default" type="button" onclick="cf_back('/dyAdmin/operation/survey/surveyskin.do')"> 
															<i class="fa fa-reorder"></i> 목록으로
														</button> 
                                                    </fieldset>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                    </div>
                    </form:form>

                    <c:if test="${!empty count }">

                        <div class="row">
                            <article class="col-sm-12 col-md-12 col-lg-12">
                                <div class="jarviswidget jarviswidget-color-green" id="" data-widget-editbutton="false" data-widget-custombutton="false">
                                    <header>
                                        <span class="widget-icon"> <i class="fa fa-edit"></i></span>
                                        <h2>히스토리</h2>
                                    </header>
                                    <div>
                                        <div class="jarviswidget-editbox"></div>
                                        <div class="widget-body">
                                            <div class="table-responsive">
                                                <table id="datatable_fixed_column" class="table table-bordered table-hover" width="100%">
                                                    <colgroup>
                                                        <col width="5%">
                                                        <col width="10%">
                                                        <col width="">
                                                        <col width="20%">
                                                        <col width="25%">
                                                    </colgroup>
                                                    <thead>
                                                        <tr>
                                                            <th class="text-align-center">버전</th>
                                                            <th class="text-align-center">작성자</th>
                                                            <th class="text-align-center">코멘트</th>
                                                            <th class="text-align-center">게시기간</th>
                                                            <th class="text-align-center">기능</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody id="intro-history">
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </article>
                        </div>

                        <div class="row">
                            <article class="col-sm-12 col-md-12 col-lg-12">
                                <div class="jarviswidget jarviswidget-color-green" id="compareData_wrap" data-widget-editbutton="false" data-widget-custombutton="false">
                                    <header>
                                        <span class="widget-icon"> <i class="fa fa-edit"></i></span>
                                        <h2>소스 비교</h2>
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
                    </c:if>
                    
                </div>
            </div>
    </div>
    </article>
    </div>
</section>

<script type="text/javascript">
var editor = null;

$(function(){
	editor = codeMirror('htmlmixed','SS_DATA')
	if('${action}'=='insert') pf_getSkinFormData("basic","survey");
	pf_clickLi();
});


function pf_clickLi(){
	var scopeType = $("#surveySkinTab li").data('scope');
	pf_data(scopeType);
}

function pf_data(scopeType){	
	var keyno = '${SS_KEYNO}';

	$.ajax({
		type: "POST",
		url: "/dyAdmin/operation/survey/skindataAjax.do",
		data : {
				"SS_KEYNO" : keyno
				},
		success : function(result){
			var data = result.SkinData;
			var historyList = result.SkinDataHistory;
			
			//ì´ê¸°í
			$("#intro-history").empty();
			$("#compareData").empty();
			
			var keyno = '';
			var REGNM = 'ìì±ì ìì';
			var REGDT = 'ìì±ì¼ ìì';
			var MODNM = 'ìµê·¼ ê²ìë¬¼ ìì ì ìì';
			var MODDT = 'ê²ìë¬¼ ìì ì´ë ¥ ìì';
			var SS_DATA = '';
			var SS_SKIN_NAME = "";
			
			if(data){
				keyno	 		= data.SS_KEYNO;
				REGNM 			= data.SS_REGNM;   
				REGDT 			= data.SS_REGDT;
				if(typeof data.SS_MODNM != 'undefined'){
					MODNM 			= data.SS_MODNM;
				}
				if(typeof data.SS_MODDT != 'undefined'){
					MODDT 			= data.SS_MODDT;
				}
				SS_DATA 		= data.SS_DATA;	
				SS_SKIN_NAME 	= data.SS_SKIN_NAME;					
			}
			
			$("#SS_KEYNO").val(keyno)
			$("#REGNM").text(REGNM)
			$("#REGDT").text(REGDT)
			$("#MODNM").text(MODNM)
			$("#MODDT").text(MODDT)
			$("#SS_SKIN_NAME").val(SS_SKIN_NAME);
			
			editor.setValue(SS_DATA);
			
			
			// ì ì¥ì liì keyno ê° ì¤ì í´ì ì­ì ê° ë°ë¡ ê°ë¥íëë¡ íë ì½ë
			$("#surveySkinTab li[class*=active]").attr("data-keyno", keyno);			
			
			// DBìì ê°ì ¸ì¬ ì¤í¨ ì ë³´ê° ìê±°ë ê³µë°±ì¼ ë ê¸°ë³¸ ì¤í¨ ì ë³´ë¥¼ ì¤ì 
			if(SS_DATA == '') {
				pf_form_change();
			}
			
			var temp = '';
			if(historyList.length > 0){
				$.each(historyList, function(i){
					var history = historyList[i]
					temp += '<tr>';
			    	temp += '	<td class="text-align-center">'+history.SSH_VERSION+'</td>';
			    	temp += '	<td class="text-align-center">'+history.SSH_MODNM+'</td>';
			    	temp += '	<td class="text-align-center">'+history.SSH_COMMENT+'</td>';
			    	temp += '	<td class="text-align-center">'+history.SSH_STDT+' ~ '+history.SSH_ENDT+'</td>';
			    	temp += '	<td class="text-align-center">';
			    	temp += '	<a class="btn btn-default btn-xs" href="#" onclick="pf_introUse(\''+history.SSH_KEYNO+'\');"><i class="fa fa-repeat"></i> ë³µì</a>';
			    	if(i != 0){
			    		temp += '	<a class="btn btn-default btn-xs" href="javascript:;" onclick="pf_compareData(\''+history.SSH_KEYNO+'\',\''+history.SSH_SS_KEYNO+'\');"><i class="fa fa-repeat"></i> ìµì  ë°ì´í°ì ë¹êµ</a>';
			    	}
		    		temp += '	<a class="btn btn-default btn-xs" href="javascript:;" onclick="pf_compareData(\''+history.SSH_KEYNO+'\');"><i class="fa fa-repeat"></i> ë³ê²½ì¬í­</a>';
			    	temp += '	</td>';
		    		temp += '</tr>';
				})
			$("#intro-history").html(temp)
			}
			
			// ì ì¥, ì¤í¨ ì í ì ì½ë©í¸ ë¦¬ì
			$('input[name=SSH_COMMENT]').val('');

		},
		error : function(){	
			cf_smallBox('error', 'ìë¬ë°ì', 3000,'#d24158');
		}
	});
}


//저장하기(유효성 검사)
function pf_skinInsert(){
	$('#SS_ORDER').val($('#surveySkinTab li[class*=active]').data('order'));
	$("#SS_DATA_TEMP").val(editor.getValue())

	if(!$("#SS_SKIN_NAME").val()){
      cf_smallBox('error', '스킨이름을 입력해주세요.', 3000,'#d24158');
      return false;
	}
		
	if(!$("#SS_DATA_TEMP").val()){
      cf_smallBox('error', '내용을 입력해주세요.', 3000,'#d24158');
      return false;
    }
	
	if(!$("#SSH_COMMENT").val()){
	  cf_smallBox('error', '코멘트를 입력해주세요.', 3000,'#d24158');
	  return false;
	 }
	
	// 스킨 이름 중복 검사
	var SkinName = $("#SS_SKIN_NAME").val(); // 현재 이름
		$.ajax({
			type: "POST",
			url: "/dyAdmin/operation/survey/RedundancyAjax.do",
			data : {
				 "SS_SKIN_NAME" : SkinName,
				 "SS_KEYNO" : $("#SS_KEYNO").val()
			},
			success : function(data){
				if(data > 0){
					cf_smallBox('error', '스킨이름이 중복됩니다.', 3000,'#d24158');
			  		return false;
			  	} else {
			  		cf_smallBoxConfirm('Ding Dong!', '저장 하시겠습니까?','pf_submit()');		  		
			  	}			
			},
			error : function(){	
				cf_smallBox('error', '스킨이름 중복검사 에러발생', 3000,'#d24158');
			}
		});      
	
} 

//삭제하기(유효성 검사)
function pf_skinDelete() {
	
	$.ajax({
		type: "POST",
		url: "/dyAdmin/operation/survey/useSkinAjax.do",
		data : {
			 "SS_KEYNO" : $("#SS_KEYNO").val()
		},
		success : function(data){
			if(data > 0){
				cf_smallBox('error', '사용중인 스킨은 삭제하실 수 없습니다.', 3000,'#d24158');
		  		return false;
		  	} else {
		  		cf_smallBoxConfirm('Ding Dong!', '삭제 하시겠습니까?','pf_delete()');		  		
		  	}			
		},
		error : function(){	
			cf_smallBox('error', '스킨 사용여부 판단 에러발생', 3000,'#d24158');
		}
	});      	
}

//저장하기
function pf_submit(){
    $("#Form").attr("action", "/dyAdmin/operation/surveyskin/insert.do");
    $("#Form").submit();
}

// 삭제하기
function pf_delete() {
   	$("#Form").attr("action", "/dyAdmin/operation/surveyskin/delete.do");
 	$("#Form").submit();	
}

//복원
function pf_introUse(SSH_KEYNO){
	cf_loading();
	
	setTimeout(function(){
		$.ajax({
			type: "POST",
			url: "/dyAdmin/operation/survey/returnPageAjax.do",
			data : {"SSH_KEYNO":SSH_KEYNO},
			success : function(data){
				editor.setValue(data)
			},
			error : function(){	
			}
		 }).done(function(){
			cf_loading_out();
		});
	},100)
}


//비교하기
function pf_compareData(SSH_KEY1, SS_KEY2){
	cf_loading();
	
	setTimeout(function(){
	$.ajax({
		type: "POST",
		url: "/dyAdmin/operation/survey/compareAjax.do",
		data: "SSH_KEYNO=" + SSH_KEY1 + "&SS_KEYNO=" + SS_KEY2,
		async: false,
		success : function(obj){
			var dmp = new diff_match_patch();
			var diff;
			
			if(SS_KEY2 == undefined){
				diff = dmp.diff_main(obj.length == 1 ? "": obj[1].SS_DATA, obj[0].SS_DATA);
			}else{
				diff = dmp.diff_main(obj[0].SS_DATA, obj[1].SS_DATA);
			}
		    dmp.diff_cleanupSemantic(diff)
		    
		    var ds = dmp.diff_prettyHtml(diff);
	    	$('#compareData').html(ds)
		},
		error: function(){
			cf_smallBox('error', '데이터를 가져올 수 없습니다. 관리자한테 문의하세요.', 3000,'#d24158');
			return false;
		}
		}).done(function(){
			cf_loading_out();
			});
	},100)
}

</script>