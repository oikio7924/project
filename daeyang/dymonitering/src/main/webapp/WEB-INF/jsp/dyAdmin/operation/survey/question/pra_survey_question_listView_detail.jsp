<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<style>
.help-block {color:#468847;}

.except-${formActionType} {display:none;}

<c:if test="${resultData.HM_MN_HOMEDIV_C eq sp:getData('HOMEDIV_ADMIN')}">
.except-admin {display:none;}
</c:if>

#Form{ text-align: left; }

.ck_maxmin { display:none; margin: 0 0 15px 0px; }
.radio_order { display:none; margin: 0; }
.sq_checkbox { width: 18px; height: 18px; vertical-align: -5px; }
.SQ_orderck { width: 18px; height: 18px; vertical-align: -5px; }

.req { display:none; }

input[name='SQ_CK_MIN'], input[name='SQ_CK_MAX']  { text-align:center; width: 40px; height: 20px; }

input[name='SQ_CK_MIN']::-webkit-outer-spin-button,
input[name='SQ_CK_MIN']::-webkit-inner-spin-button,
input[name='SQ_CK_MAX']::-webkit-outer-spin-button,
input[name='SQ_CK_MAX']::-webkit-inner-spin-button {
    -webkit-appearance: none;
    margin: 0;
}

.typeO { display: none; }

input[name='SQO_NUM'] {
	border: none;
    font-style: italic;
    background-color: #eee;
    font-size: 13px;
    font-weight: 400;
    width: 10px;

}
</style>


<fieldset>
    <legend>기본 정보</legend>
    	<input type="hidden" name="SQ_KEYNO" value="${sq.SQ_KEYNO}">
		<input type="hidden" name="action" id="action" value="${action }" />
		<input type='hidden' id='SQ_OPTION_DATA_row1' name='SQ_OPTION_DATA'>

 		<div class="form-group">
            <label class="col-md-2 control-label">카테고리 텍스트</label>
            <div class="col-md-10">
                <div class="input-group" style="margin-bottom: 10px;">
                    <textarea class="checkTrim" id="SQ_KG_TEXT" name="SQ_KG_TEXT" placeholder="카테고리 분류 텍스트입니다." rows="5" style="width:100%; resize: none;" maxlength="2000" onkeyup="pf_checkLength('SQ_KG_TEXT',2000)">${sq.SQ_KG_TEXT }</textarea>
                    <span class="input-group-addon length" id="SQ_KG_TEXT_length">(0/2000자)</span>
                </div>
            </div>
        </div>
		 <div class="form-group">
            <label class="col-md-2 control-label"><span class="nessSpan">* </span>번호</label>
            <div class="smart-form col-md-10">
                <div class="input-group" style="margin-bottom: 10px;">
                    <label class="input" style="border: 1px solid rgb(169, 169, 169); float:left;"> <i class="icon-prepend ">No.</i>
                        <input type="text" id="SQ_NUM" name="SQ_NUM" value="${sq.SQ_NUM }" maxlength="200" style="border: hidden;" />
                    </label>
                   		<span class="note" style="color: red; margin-left: 10px;"> * 중복된 번호는 입력하실 수 없습니다.</span>
                </div>
            </div>
        </div>

        <div class="form-group except-admin">
            <label class="col-md-2 control-label"><span class="nessSpan">* </span>문제 타입 선택</label>
            <div class="col-md-10" style="margin-bottom: 10px;">
                <select class="form-control" name="SQ_ST_TYPE" id="SQ_ST_TYPE_row1" onchange="pf_surveyTypeChange('_row1');">
                    <option value="">문제 타입 선택</option>
                    <option value="T" ${sq.SQ_ST_TYPE eq 'T' ? 'selected' : '' }>주관식(텍스트박스)</option>
                    <option value="R" ${sq.SQ_ST_TYPE eq 'R' ? 'selected' : '' }>객관식(라디오)</option>
                    <option value="O" ${sq.SQ_ST_TYPE eq 'O' ? 'selected' : '' }>객관식(라디오, 기타)</option>
                    <option value="C" ${sq.SQ_ST_TYPE eq 'C' ? 'selected' : '' }>객관식(체크박스)</option>
                </select>
            </div>
        </div>
        </div>
        <div class="form-group except-admin">
            <label class="col-md-2 control-label"><span class="nessSpan">* </span>질문</label>
            <div class="smart-form col-md-10">
                <div class="input-group" style="margin-bottom: 10px;">
                    <label class="input" style="border: 1px solid rgb(169, 169, 169);"> <i class="icon-prepend ">Q</i>
                        <input type="text" id="SQ_QUESTION" name="SQ_QUESTION" value="${sq.SQ_QUESTION }" maxlength="200" style="border: hidden;" onkeyup="pf_checkLength('SQ_QUESTION',200)" />
                    </label>
                    <span class="input-group-addon length" id="SQ_QUESTION_length">(0/200자)</span>
                </div>
            </div>
        </div>

        <div class="form-group except-admin">
            <label class="col-md-2 control-label"><span class="nessSpan">* </span>문항 설명</label>
            <div class="col-md-10">
                <div class="input-group" style="margin-bottom: 10px;">
                    <textarea class="checkTrim" id="SQ_COMMENT" name="SQ_COMMENT" placeholder="문항 설명입니다." rows="5" style="width:100%; resize: none;" maxlength="2000" onkeyup="pf_checkLength('SQ_COMMENT',2000)">${sq.SQ_COMMENT }</textarea>
                    <span class="input-group-addon length" id="SQ_COMMENT_length">(0/2000자)</span>
                </div>
            </div>
        </div>
</fieldset>

<fieldset class="quest_option" id="SQ_row1">
    <legend>문항 옵션</legend>
    <section class="form-group" style="line-height: 32px;">
        <label class="col-md-1 control-label" style="margin-right: 5px;">보기배점방식</label>
        <label class="radio radio-inline no-margin">
            <input type="radio" name="SM_CNT_TYPE" value="S" class="radiobox style-2" data-bv-field="rating" ${SmDTO.SM_CNT_TYPE eq 'S' ? 'checked' :''} onclick="pf_bogiShowHide('S');"> <span>점수</span>
        </label>
        <label class="radio radio-inline no-margin">
            <input type="radio" name="SM_CNT_TYPE" value="H" class="radiobox style-2" data-bv-field="rating" ${empty SmDTO.SM_CNT_TYPE || SmDTO.SM_CNT_TYPE eq 'H' ? 'checked' :''} onclick="pf_bogiShowHide('H');"> <span>인원수</span>
        </label>
        <span class="option_dp ${sq.SQ_ST_TYPE eq 'T' ? 'optionBtn' : ''}" style="float: right;">
            <a href="javascript:;" onclick="pf_addOption('_row1')" class="btn btn-info btn-xs" style="text-align: right;">옵션 추가</a>
        </span>
    </section>

    <section class="form-group" style="line-height: 10px;">
     <div class="ck_maxmin count1">
        <label class="col-md-1 control-label" style="margin-right: 5px;">입력 방식</label>
        <label class="radio radio-inline no-margin">
            <input type="radio" name="SQ_REQYN" value="Y" class="radiobox style-2" data-bv-field="rating" ${empty sq.SQ_REQYN || sq.SQ_REQYN eq 'Y' ? 'checked' :''} onclick="pf_setReqType('Y');"><span>필수 입력</span>
        </label>
        <label class="radio radio-inline no-margin">
            <input type="radio" name="SQ_REQYN" value="N" class="radiobox style-2" data-bv-field="rating" ${sq.SQ_REQYN eq 'N' ? 'checked' :''} onclick="pf_setReqType('N');"><span>선택 입력</span>
        </label>
	    <div class="note req" style="color: red; margin-left: 12px; margin-top: 12px;">* 필수 입력 방식은 반드시 1개 이상의 선택 갯수가 필요합니다.</div>
       </div>
    </section>

    <section class="form-group" style="line-height: 32px; margin-left: 14px;">
        <div class="ck_maxmin count1">
            <span>
                체크박스는 최소 <input type="number" class="ck_min_number_row1" name="SQ_CK_MIN" value="${sq.SQ_CK_MIN eq null ? 1 : sq.SQ_CK_MIN }" />개 ~
                최대 <input type="number" class="ck_max_number_row1" name="SQ_CK_MAX" value="${sq.SQ_CK_MAX eq null ? 1 : sq.SQ_CK_MAX }" /> 개까지 체크 가능합니다.
                <div class="note" style="color: red;">* 최대 갯수를 입력하지 않을 시 기본적으로 1이 들어갑니다.</div>
            </span>
        </div>
        <div class="radio_order count1">
            <input type="checkbox" class="sq_checkbox" id="sq_check_1" <c:if test="${sq.SQ_ORDER_TYPE eq 'Y' }">checked</c:if>>
            <input type="hidden" name="SQ_ORDER_TYPE" id="SQ_ORDER_TYPE" value="${sq.SQ_ORDER_TYPE eq null ? 'N' : sq.SQ_ORDER_TYPE }">
            <span class="note" style="color: red;"> * 체크하시면 옵션 외 기타의견을 항상 입력받습니다.</span>
        </div>
        
        <div class="radio_order typeO">
        	<input type='hidden' id='SQ_IN_ORDER_TYPE' name='SQ_IN_ORDER_TYPE' value="${sq.SQ_IN_ORDER_TYPE eq null ? 'N' : sq.SQ_IN_ORDER_TYPE }">        
	        <input type="checkbox" class="SQ_orderck" id="SQ_orderck" <c:if test="${sq.SQ_IN_ORDER_TYPE eq 'Y' }">checked</c:if>>
	        <span class="note" style="color: red;"> * 체크하시면 마지막 옵션을 선택시 기타의견을 입력받습니다.</span>	        
        </div>                        
    </section>

    <div class="form-group">
        <label class="col-md-2 control-label"></label>
        <div id="optiondialog_append_row1" class="optiondialog_append_row">
            <div id="SQO_row1" class="sqo-column-row">

                <c:forEach items="${SQO }" var="sqo" varStatus="sqoc">
                    <c:if test="${sq.SQ_KEYNO eq sqo.SQO_SQ_KEYNO }">
                        <div class="option col col-xs-12 col-sm-12 col-md-12 col-lg-12" id="option_row${sqo.SQO_NUM}">
                            <input type="hidden" class="sqo_keyno" name="sqo_keyno" id="SQO_KEYNO_row${sqo.SQO_NUM }" value="${sqo.SQO_KEYNO }">
                            <div class="col-xs-12 col-sm-12 col-md-12 col-lg-9" style="margin-bottom: 5px;">
                                <div class="input-group">
                                    <span class="input-group-addon"><i class="num" val="${sqo.SQO_NUM }"><input type="text" name="SQO_NUM" class="num2" value="${sqo.SQO_NUM}"></i></span>
                                    <input type="text" class="form-control sqo_option" name="sqo_option" id="SQ_OPTION_row${sqo.SQO_NUM }" value="${sqo.SQO_OPTION }" maxlength="250">
                                    <span class="input-group-addon"><i class="fa fa-check"></i></span>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-12 col-md-12 col-lg-2 bogiscore">
                                <div class="input-group marginLeft">
                                    <span class="input-group-addon"><i>배점</i></span>
                                    <input type="number" class="form-control sqo_value" name="sqo_value" id="SQ_VALUE_row${sqo.SQO_NUM }" value="${sqo.SQO_VALUE }" oninput="cf_maxLengthCheck(this)" max="999" maxlength="3">
                                    <span class="input-group-addon"><i class="fa fa-check"></i></span>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-12 col-md-12 col-lg-1">
                                <div class="input-group marginLeft">
                                    <a href="javascript:;" class="btn btn-default btn-circle" onclick="pf_optionDel('_row1','_row${sqo.SQO_NUM }')"><i class="glyphicon glyphicon-remove"></i></a>
                                </div>
                            </div>                            
                        </div>
                    </c:if>
                </c:forEach>  
            </div>
        </div>
    </div>
</fieldset>

<script>
    $(function() {

    	var length = $(".optiondialog_append_row").find('.num').length; // 현재 옵션 갯수
    	if($("input:checkbox[id='SQ_orderck']").is(":checked") == true) {
			$('input[id="SQ_OPTION_row'+length+'"]').attr("readonly", "true");
		} else {    		
			$('input[id="SQ_OPTION_row'+length+'"]').removeAttr("readonly");	    		
		}
    	
        var req = $('input[name=SQ_REQYN]:checked').val();
        if (req == 'Y') {
        	$(".req").show();
        } else if(req == 'N'){
        	$(".req").hide();
        }

        pf_order();
        
        pf_check();
        ck_Validation();
        pf_setnum();

        pf_bogiShowHide('${SmDTO.SM_CNT_TYPE}')

        action = '${action}';

        if (action != 'insert') {
            $('.input-group-addon.length').each(function() {
                var id = $(this).attr('id').replace('_length', '');
                var maxLength = $('#' + id).attr('maxlength');
                pf_checkLength(id, maxLength);
            })
            $("#deleteBtn").show();
        } else {
        	$("#deleteBtn").hide();
        }
    });

    
    // 내부 기타의견 체크박스 설정
    function pf_order() {     	
        $('input:checkbox[id="SQ_orderck"]').change(function() {
	    	var numselectBox = $("select[id=SQ_ST_TYPE_row1]").val();	    		
            var length = $(".optiondialog_append_row").find('.num').length; // 현재 옵션 갯수
	    	if(numselectBox == 'O' && $("input:checkbox[id='SQ_orderck']").is(":checked") == true) {
					$('input[id="SQ_OPTION_row'+length+'"]').attr("readonly", "true");
					$('input[id="SQ_IN_ORDER_TYPE"]').val("Y")
	    	} else {
					$('input[id="SQ_OPTION_row'+length+'"]').removeAttr("readonly");	    		
					$('input[id="SQ_IN_ORDER_TYPE"]').val("N")
	    	}
	    });
    }
    
    // 입력방식 알림창
    function pf_setReqType(type) {
        if (type == 'Y') {
       	   $(".req").show();
        	$('input[name=SQ_CK_MIN]').val('1');
        	$('input[name=SQ_CK_MAX]').val('1');
        } else {
       	   $(".req").hide();
        }
    }


    function pf_setnum() {
    	var tr_cnt = $('#dt_basic >tbody tr td a').length + 1;
      	var sq_num = $('input[name=SQ_NUM]').val();
      	if(sq_num == "") {
      		$('input[name=SQ_NUM]').val(tr_cnt);
      	}
    }


    function pf_checkLength(id, maxLength) {
        var letterLength = $('#' + id).val().length;
        if (letterLength > maxLength) {
            letterLength = maxLength;
        }
        var text = '(' + letterLength + '/' + maxLength + '자)'

        $('#' + id + "_length").text(text);
    }

    //보기배점방식 체크
    function pf_bogiShowHide(type) {
        if (type == 'S') {
            $(".bogiscore").show();
        } else {
            $(".bogiscore").hide();
        }
    }

    //보기 추가
    function pf_addOption(divID) {
    	
    	if($("input:checkbox[id='SQ_orderck']").is(":checked") == true) {
    		cf_smallBox('Form', '기타의견 체크박스를 선택하시면 옵션 추가를 하실 수 없습니다.', 3000, '#d24158');  
    		return false;
    	}
    	
        var sm_cnt_type = $("input[type=radio][name=SM_CNT_TYPE]:checked").val();
        var getLast = $("#SQO" + divID).find(".option .num").length
        var num = getLast * 1 + 1;
        var param_div = "_row" + num;
        var html = "";
        //		html	+="<div class='option' id='option_row"+num+"'>";
        //		html	+="<span class='num'>"+num+"</span>";
        //		html	+="<input type='text' name='sqo_option' class='sqo_option' id='SQO_OPTION"+param_div+"' maxlength='250'>";
        //		html	+="<span class='bogiscore'>배점:<input type='number' class='sqo_value' name='sqo_value' id='SQ_VALUE"+param_div+"' maxlength='3'></span>";
        //		html	+="<button class='btn btn-xs btn-default' id='Board_Delete' type='button' onclick=pf_optionDel('"+divID+"','"+param_div+"')>";
        //		html	+="<i class='fa  fa-times-circle'></i>";
        //		html	+="</button>";
        //		html	+="</div>";

        html += '	<div class="option col col-xs-12 col-sm-12 col-md-12 col-lg-12" id="option_row' + num + '">';
        html += '		<div class="col-xs-12 col-sm-12 col-md-12 col-lg-9" style="margin-bottom: 5px;">';
        html += '			<div class="input-group">';
        html += '				<span class="input-group-addon"><i class="num" val="' + num + '"><input type="text" name="SQO_NUM" class="num2" value="' + num + '"></i></span>';
        html += '				<input type="text" class="form-control sqo_option" name="sqo_option" id="SQ_OPTION' + param_div + '" maxlength="250">';
        html += '				<span class="input-group-addon"><i class="fa fa-check"></i></span>';
        html += '			</div>';
        html += '		</div>';
        html += '		<div class="col-xs-12 col-sm-12 col-md-12 col-lg-2 bogiscore">';
        html += '			<div class="input-group marginLeft">';
        html += '				<span class="input-group-addon"><i>배점</i></span>';
        html += '				<input type="number" class="form-control sqo_value" name="sqo_value" id="SQ_VALUE' + param_div + '" oninput="cf_maxLengthCheck(this)" max="999" maxlength="3">';
        html += '				<span class="input-group-addon"><i class="fa fa-check"></i></span>';
        html += '			</div>';
        html += '		</div>';
        html += '		<div class="col-xs-12 col-sm-12 col-md-12 col-lg-1">';
        html += '			<div class="input-group marginLeft">';
        html += '				<div class="input-group marginLeft">';
        html += '					<a href="javascript:;" class="btn btn-default btn-circle" onclick="pf_optionDel(\'' + divID + '\',\'' + param_div + '\')"><i class="glyphicon glyphicon-remove"></i></a>';
        html += '				</div>';
        html += '			</div>';
        html += '		</div>';
        html += '	</div>';

        $("#SQO" + divID).append(html);
        pf_bogiShowHide(sm_cnt_type);
        if (sm_cnt_type == "H") {
            $("#SQ_VALUE").attr("readonly", "true");
        } else {
            $("#SQ_VALUE").attr("readonly", "false");
        }
        pf_check();
        ck_Validation();
    }

    //보기 삭제
    function pf_optionDel(divNum, sqoDivID) {
        $("#SQO" + divNum).find("#option" + sqoDivID).remove();
        resetBogiCnt(divNum);
        ck_Validation();
    }

    //보기 순서 리셋
    function resetBogiCnt(num) {
        $row = $("#SQO" + num).find(".option");
        $row.each(function(i) {
            $(this).find('.num2').text(i + 1)
        })
    }

    //설문 문제 타입 체크 후 후처리
    function pf_check() {
        // 객관식(라디오) 기타의견 사용 체크 여부 확인
        $('input:checkbox[id="sq_check_1"]').change(function() {
            if ($(this).is(":checked") == true) {
                $(this).parent().find("#SQ_ORDER_TYPE").val('Y');
            } else {
                $(this).parent().find("#SQ_ORDER_TYPE").val('N');
            }
        });

        // 특정 유형이 아니면 체크박스, 라디오 기타의견 입력창 안뜨게
        // T : 주관식, R : 객관식(라디오), C : 객관식(체크박스)
        var numselectBox = $("select[id=SQ_ST_TYPE_row1]").val();
        if (numselectBox == 'C') {
            $('.ck_maxmin.count1').show();
            $('.radio_order.count1').hide();
            $('.quest_option').show();
            $('input:checkbox[id="sq_check_1"]').parent().find("#SQ_ORDER_TYPE").val('N');
			$('input[id="SQ_IN_ORDER_TYPE"]').val("N")
            $('.typeO').hide();
        } else if (numselectBox == 'R') {
            $('.quest_option').show();
            $('.ck_maxmin.count1').hide();
            $('.radio_order.count1').show();
            $('.typeO').hide();
        } else if(numselectBox == 'O') {
            $('.quest_option').show();
            $('.ck_maxmin.count1').hide();
            $('.radio_order.count1').show();
            $('.typeO').show();
        } else if (numselectBox == 'T' || numselectBox == '') {
            $('.quest_option').hide();
            $('.ck_maxmin.count1').hide();
            $('.radio_order.count1').hide();
            $('input:checkbox[id="sq_check_1"]').parent().find("#SQ_ORDER_TYPE").val('N');
			$('input[id="SQ_IN_ORDER_TYPE"]').val("N")
            $('.typeO').hide();
        }
    }

    //체크박스 최소/대값 유효성 검사
    function ck_Validation() {

        $('input[name=SQ_CK_MIN], input[name=SQ_CK_MAX]').off("click").on('click', function() {
            var ck_class = $(this).attr("class");
            var ck_count = ck_class.substring(17);

            $(".ck_max_number_row" + ck_count + ", .ck_min_number_row" + ck_count).off("change").on('change', function() {
                count = $(this).val() - 1; // 최소값
                ck_count2 = count + 1; // 최대값
                ck_length = $("#optiondialog_append_row" + ck_count).find('.num').length; // 현재 옵션 갯수

                var req = $('input[name=SQ_REQYN]:checked').val();

                if(req == 'Y') {
                    if (count < 0) {
                        cf_smallBox('Form', '1 이상의 양수만 입력 해 주세요.', 3000, '#d24158');
                        $(this).val('1');
                        $(this).focus();
                        return false;
                    }
                } else if(req == 'N') {
                    if (count < -1) {
                        cf_smallBox('Form', '0 이상의 양수만 입력 해 주세요.', 3000, '#d24158');
                        $(this).val('0');
                        $(this).focus();
                        return false;
                    }
                }

                if (ck_count2 > ck_length) {
                    cf_smallBox('Form', '체크박스 갯수보다 많은 숫자는 입력하실 수 없습니다.', 3000, '#d24158');
                    $(this).val(ck_length);
                    $(this).focus();
                    return false;
                }

                var min = $('.ck_min_number_row' + ck_count).val();
                var max = $('.ck_max_number_row' + ck_count).val();

                if (max != "") {
                    if (min > max) {
                        cf_smallBox('Form', '최소값은 최댓값보다 클 수 없습니다.', 3000, '#d24158');
                        $('.ck_min_number_row' + ck_count).val('1');
                        $('.ck_max_number_row' + ck_count).val(ck_length);
                        $('.ck_min_number_row' + ck_count).focus();
                        return false;
                    }
                }
            });
        });
    }

    //문제타입 선택에 따른 옵션 T:주 , R:객(라), C:객(체), O:객(라,기)
    function pf_surveyTypeChange(divID) {
		var length = $(".optiondialog_append_row").find('.num').length; // 현재 옵션 갯수
        
		var ChangeSelectBox = $("#SQ_ST_TYPE" + divID).val();
        if (ChangeSelectBox == 'R') {
			$('input[id="SQ_OPTION_row'+length+'"]').removeAttr("readonly");	    		
            $("#SQ" + divID).find('.option_dp, .optiondialog_append_row').show();
        } else if (ChangeSelectBox == 'O') {
        	if($("input:checkbox[id='SQ_orderck']").is(":checked") == true) {
				$('input[id="SQ_OPTION_row'+length+'"]').attr("readonly", "true");
    		} else {    		
				$('input[id="SQ_OPTION_row'+length+'"]').removeAttr("readonly");	    		
    		}
            $("#SQ" + divID).find('.option_dp, .optiondialog_append_row').show();
        } else if (ChangeSelectBox == 'C') {
			$('input[id="SQ_OPTION_row'+length+'"]').removeAttr("readonly");	    		
            $("#SQ" + divID).find('.option_dp, .optiondialog_append_row').show();
        } else {
			$('input[id="SQ_OPTION_row'+length+'"]').removeAttr("readonly");	    		
            $("#SQ" + divID).find('.option_dp, .optiondialog_append_row').hide();
        }
        pf_check();
    }
</script>
