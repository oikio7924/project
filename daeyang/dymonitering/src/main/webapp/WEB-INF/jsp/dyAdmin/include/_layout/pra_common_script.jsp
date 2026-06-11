<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<script type="text/javascript">
var resourceType;

//불러온 데이터를 화면에 세팅한다.
function pf_settingData(scopeType, rmType, result){
	var data = result;
	var keyno = '';
	var actiontype = 'insert';
	var REGNM = '작성자 없음';
	var REGDT = '작성일 없음';
	var MODNM = '최근 게시물 수정자 없음';
	var MODDT = '게시물 수정이력 없음';
	var RM_FILE_NAME = '';
	var RM_DATA = '';
	var RMH_COMMENT = '';
	var viewVersion = '';
	
	if(data){
		actiontype	 	= 'update';   
		keyno	 		= data.RM_KEYNO;   
		REGNM 			= data.RM_REGNM;   
		REGDT 			= data.RM_REGDT;   
		if(typeof data.RM_MODNM != 'undefined'){
			MODNM 		= data.RM_MODNM;   
		}
		if(typeof data.RM_MODDT != 'undefined'){
			MODDT 		= data.RM_MODDT;   
		}
		RM_FILE_NAME 	= data.RM_FILE_NAME;
		viewVersion 	= data.viewVersion;
		RM_DATA 		= data.RM_DATA;
	}
	
	$("#actionType").val(actiontype);
	$("#RM_KEYNO").val(keyno);
	$("#RM_FILE_NAME").val(RM_FILE_NAME);
	$("#REGNM").text(REGNM);
	$("#REGDT").text(REGDT);
	$("#MODNM").text(MODNM);
	$("#MODDT").text(MODDT);
	$("#RMH_COMMENT").val(RMH_COMMENT);
	$("#RM_SCOPE").val(scopeType);
	
	$("#historyVersionTd").hide();
	if(viewVersion){	//현재 버전 표시
		$("#viewVersion").text(viewVersion);
		$("#versionTd").show();
	}else{
		$("#viewVersion").text(viewVersion);
		$("#versionTd").hide();
	} 
	editor.setValue(RM_DATA);
	
	if(rmType == 'css' || rmType == 'js'){	//리소스일 경우
		
		if(scopeType == 'custom'){
			$("#TITLE_NAME").attr('disabled',false);
			pf_jsMenuList($("#MN_HOMEDIV_C").val(),keyno);
			$("#resourcesMenuDiv").css('width','30%').css('float','left').css('overflow-y','scroll').css('height','740px');
			$("#resourcesForm").css('width','70%').css('float','left');
		}else{
			$("#TITLE_NAME").attr('disabled',true);
			$("#menuListUl").empty();
			$("#resourcesMenuDiv").removeAttr('style');
			$("#resourcesForm").removeAttr('style');
		}
	}
	
	if(rmType == 'index'){	//인덱스일 경우 robots, index는 이름 변경 안됨
		
		if(!RM_DATA){
			var filename = $('#TITLE_NAME').val();
			if(filename == 'index'){
				editor.setValue($('#form_li_data_A').text());
			}else if(filename == 'robots'){
				editor.setValue($('#form_li_data_B').text());
			}else{
				editor.setValue('');
			}
		}else{
			editor.setValue(RM_DATA);
		}
		
		if(scopeType == 'custom'){
			$("#TITLE_NAME").attr('disabled',false);
			$("#RM_FILE_NAME").attr('readOnly', false);
		}else{
			$("#TITLE_NAME").attr('disabled',true);
			$("#RM_FILE_NAME").val(scopeType);
			$("#RM_FILE_NAME").attr('readOnly', true);
		}
	}
	
	//히스토리를 세팅한다.
	pf_dataHistory(keyno);
}

//데이터 히스토리 세팅
function pf_dataHistory(rmKey){
		
	if(rmKey){
		$.ajax({
			type: "POST",
			url: "/dyAdmin/homepage/common/"+resourceType+"/dataHistoryAjax.do", 
			data : {"RM_KEYNO"	: rmKey},
			success : function(result){
				var historyList = result;
				//초기화
				$("#intro-history").empty();
				$("#compareData").empty();
				
				var temp = '';
				if(historyList.length > 0){
					$.each(historyList, function(i){
						var history = historyList[i]
						temp += '<tr>';
				    	temp += '	<td class="text-align-center">'+history.RMH_VERSION+'</td>';
				    	temp += '	<td class="text-align-center">'+history.RMH_MODNM+'</td>';
				    	temp += '	<td class="text-align-center">'+history.RMH_COMMENT+'</td>';
				    	temp += '	<td class="text-align-center">'+history.RMH_STDT+' ~ '+history.RMH_ENDT+'</td>';
				    	temp += '	<td class="text-align-center">';
				    	temp += '	<a class="btn btn-default btn-xs" href="javascript:;" onclick="pf_introUse(\''+history.RMH_KEYNO+'\');"><i class="fa fa-repeat"></i> 복원</a>';
				    	if(i != 0){
				    		temp += '	<a class="btn btn-default btn-xs" href="javascript:;" onclick="pf_compareData(\''+history.RMH_KEYNO+'\',\''+history.RMH_RM_KEYNO+'\');"><i class="fa fa-repeat"></i> 최신 데이터와 비교</a>';
				    	}
				    	temp += '	<a class="btn btn-default btn-xs" href="javascript:;" onclick="pf_compareData(\''+history.RMH_KEYNO+'\');"><i class="fa fa-repeat"></i> 변경사항</a>';
				    	temp += '	</td>';
			    		temp += '</tr>';
					})
				}
				$("#intro-history").html(temp);
				
			},
			error : function(){	
				cf_smallBox('error', '에러발생', 3000,'#d24158');
			}
		});
	}else{
		$("#intro-history").html('');
	}
}

function pf_HomeDivChange(value){
	$("#RM_KEYNO").val('');
	$("#MN_HOMEDIV_C").val(value);
    cf_loading();
    $("#Form").submit();
}

function pf_setHomeName(){
	$('#homeName').val($('#HOMEDIV_C option:selected').text());
}

//복원
function pf_introUse(RMH_KEYNO){
	
	cf_loading();
	
	setTimeout(function(){
		$.ajax({
			type: "POST",
			url: "/dyAdmin/homepage/common/recovery/dataReturnAjax.do",
			data : {"RMH_KEYNO":RMH_KEYNO},
			success : function(data){
				editor.setValue(data.DATA)
				//복원 버전 표시
				$("#historyVersionTd").show();
				$("#historyViewVersion").text(data.viewVersion);
				
				cf_smallBox('success', '데이터를 성공적으로 불러왔습니다', 3000);
				cf_scroll('LayoutTab');
			},
			error : function(){	
				cf_smallBox('error', '에러발생', 3000,'#d24158');
			}
		 }).done(function(){
			cf_loading_out();
		});
	},100)
}


//비교하기
function pf_compareData(RMH_KEY1, RM_KEY2){
	cf_loading();
	
	setTimeout(function(){
	$.ajax({
		type: "POST",
		url: "/dyAdmin/homepage/common/compare/dataCompareAjax.do",
		data: "RMH_KEYNO=" + RMH_KEY1 + "&RM_KEYNO=" + RM_KEY2,
		async: false,
		success : function(obj){
			var dmp = new diff_match_patch();
			var diff;
			
			if(RM_KEY2 == undefined){
				diff = dmp.diff_main(obj.length == 1 ? "": obj[1].RM_DATA, obj[0].RM_DATA);
			}else{
				diff = dmp.diff_main(obj[0].RM_DATA, obj[1].RM_DATA);
			}
		    dmp.diff_cleanupSemantic(diff)
		    
		    var ds = dmp.diff_prettyHtml(diff);
	    	$('#compareData').html(ds);
	    	cf_scroll('compareData_wrap');
		},
		error: function(){
			cf_smallBox('error', '데이터를 가져올수없습니다. 관리자한테 문의하세요.', 3000,'#d24158');
			return false;
		}
		}).done(function(){
			cf_loading_out();
			});
	},100)
}


function pf_validate(id, text){
	if(!$("#"+id).val()){
	  cf_smallBox('error', text+'을(를) 입력해주세요.', 3000,'#d24158');
      $("#"+id).focus()
      return false;
    }
	return true;
}


function pf_beforeDistributeCk(allck){
 
	var rst = {
       msg : "전체 배포를 하시겠습니까?",
       status : true
    }
	
	$("#DISTRIBUTE_TYPE").val(allck);
	if(allck == 'false'){
		if($("#RM_KEYNO").val() == null || $("#RM_KEYNO").val() == ''){
			cf_smallBox('error', '저장한 후 배포가능합니다.', 3000,'#d24158');
            rst.status = false;
			return false;
		}
        rst.msg = "정말 배포를 하시겠습니까?" ;
	}
    return rst;
}

function pf_beforeActionCk(){
	
	//저장하기 전 현재 버전을 input값에 추가
	var currentVersion = $('#viewVersion').text();
	if(currentVersion){
	  	currentVersion = Number(currentVersion);
	  	$('#currentVersion').val(currentVersion);
	}
	
}



////////////////////////////탭 추가할 경우////////////////////////

//추가버튼
function pf_addNewJs(){
	var liCnt = $("#LayoutTab").find('li').length+1;
	var cloneLi = 	'<li class="sq-column-row customli" data-order="'+liCnt+'">';
		cloneLi += 	'	<a class="customeBtn" data-toggle="tab" aria-expanded="true" data-scope="custom">';
		cloneLi += 	'	<input type="text" class="form-control customTitle" value="직접설정" name="custom_title_'+liCnt+'" maxlength="20" readonly="readonly" style="width:93px;">';
		cloneLi += 	'	</a>';
		cloneLi += 	'	<button type="button" class="close closeBtn" data-dismiss="alert" onclick="pf_closeTab(this);" style="margin-top: 0px;float: right;">×</button>';
		cloneLi += 	'	<div class="clear"></div>';
		cloneLi += 	'</li>';
	$('#tabPlus').before(cloneLi);
	pf_clickLi('true');
}

////////////////////////////탭 추가할 경우////////////////////////


///////////////////////////탭 삭제할 경우/////////////////////////

//탭삭제
function pf_closeTab(obj){
	$li = $(obj).closest('li');
	var key 	= $li.data('keyno') || '';
	var order 	= $li.data('order');
	var fileName = $li.data('filenm');
	
	if(key){
		if(confirm('삭제하시겠습니까?')){
			cf_loading();
			setTimeout(function(){
				$.ajax({
					type: "POST",
					url: "/dyAdmin/homepage/common/"+resourceType+"/DeleteAjax.do",
					async:false,
					data : {
							"RM_KEYNO":key,
							"RM_ORDER":order,
							"homeName" : $('#homeName').val(),
							"RM_MN_HOMEDIV_C" : $('#RM_MN_HOMEDIV_C').val(),
							"RM_FILE_NAME" : fileName
						},
					success : function(data){
						cf_smallBox('success', '삭제되었습니다.', 3000);
						pf_removeLi($li);
					},
					error : function(){	
						cf_smallBox('error', '에러발생', 3000,'#d24158');
					}
				 }).done(function(){
					cf_loading_out();
				});
			},100)
		}
	}else{
		pf_removeLi($li);
	}
}

function pf_removeLi(obj){
	$(obj).remove();
	pf_clickLi($('#LayoutTab li').hasClass('active'));
}

///////////////////////////탭 삭제할 경우/////////////////////////



////////////타이틀 직접 입력시////////////////////////////


//입력된 글자에 따라 width값 조절
function pf_liTextSize(){
	$('#LayoutTab li.customli').each(function(i){
		var value = $(this).find('input').val();
		pf_textSize(value,$(this));
	});
}

//입력된 글자에 따라 width값 조절
function pf_textSize(value, obj){
	$('#widget-grid').append('<span id="virtual_dom">' + value + '</span>'); 
    var inputWidth =  $('#virtual_dom').width() + 45; // 글자 하나의 대략적인 크기 
	if(obj){
		$(obj).find('input').css('width', inputWidth);
	}else{
	    $("#LayoutTab li.active").find('input').css('width', inputWidth);
	}
    $('#virtual_dom').remove();
}

function pf_titleInsert(val){
	$("#LayoutTab li.active").find('input').val(val);
	pf_textSize(val);
}

/* 한글입력 방지 */
function fn_press_han(obj){
	$(obj).val($(obj).val().replace(/[\ㄱ-ㅎㅏ-ㅣ|가-힣]/gi,''))
}


////////////타이틀 직접 입력시////////////////////////////
</script>