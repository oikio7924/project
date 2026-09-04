<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<style>
    .tab-pane {
        margin-top: 20px;
        padding-top: 20px;
        border-top: 1px solid #eee;
    }

    .sq_row {
        margin-bottom: 25px;
    }

    .sqo_row {
        margin: 5px 0px 0px 15px;
    }

    .sqo_row label.option {
        width: 50%;
    }

    .sqo_row textarea {
        width: 100%
    }

    .srm_option,
    .TopTitle {
        display: inline-block;
    }

    .srm_result {
        display: inline-block;
        float: right;
    }

    .jarviswidget>div {
        padding: 13px 13px
    }

    .excelBtn {
        float: right;
        margin-top: 25px;
    }

    .BoxCommon {
        border-width: 0;
        padding: 10px;
        -webkit-border-radius: 0;
        border-color: #9cb4c5;
        color: #305d8c;
        background-color: #d6dde7;
        display: inline-block;
        word-break: break-all;
    }

    .resultBox {
        margin-bottom: 20px;
        margin-top: 0;
    }

    .resultBox2 {
        margin-top: 5px;
        margin-right: 5px;
    }

    .sq_question {
        font-size: 16px;
    }

    .sqo_main {
        margin-top: 10px;
    }

    .progress {
        margin-bottom: 2px;
    }
    
    .ui-draggable {
		max-height: 650px;
		overflow-y:auto; 
		position: fixed;
		top:150px !important;
	}
</style>



<form:form id="Form" name="Form" method="post" action="">
    <input type="hidden" name="SM_REGNM" value="${userInfo.UI_ID }" />
    <input type="hidden" id="SM_KEYNO" name="SM_KEYNO" value="${SmDTO.SM_KEYNO }" />
    <input type="hidden" id="SRM_KEYNO" name="SRM_KEYNO" value="" />
    <input type="hidden" name="SM_IDYN" value="${SmDTO.SM_IDYN }" />
    <section id="widget-grid">
        <div class="jarviswidget jarviswidget-color-blueDark" id="" data-widget-editbutton="false">
            <header>
                <span class="widget-icon"> <i class="fa fa-table"></i>
                </span>
                <h2>설문지 결과 확인</h2>
                <ul id="widget-tab-1" class="nav nav-tabs pull-right">
                    <li class="active">
                        <a data-toggle="tab" href="#hr1"> <i class="fa fa-lg fa-arrow-circle-o-down"></i> <span class="hidden-mobile hidden-tablet"> 결과 </span> </a>
                    </li>
                    <li>
                        <a data-toggle="tab" href="#hr2"> <i class="fa fa-lg fa-arrow-circle-o-down"></i> <span class="hidden-mobile hidden-tablet"> 설문작성 목록 </span></a>
                    </li>
                </ul>
            </header>

            <div class="widget-body-toolbar bg-color-white">
                <div class="alert alert-info no-margin fade in">
                    <button type="button" class="close" data-dismiss="alert">×</button>
                    설문 결과를 확인합니다.
                </div>
            </div>
            <div>
                <div class="widget-body" style="text-align: left;">
                    <fieldset>
                        <div class="sm_main">
                            <div class="sm_row">
                                <legend>
                                    <div>
                                        <h2 class="TopTitle">${SmDTO.SM_TITLE }</h2>
                                        <button type="button" class="btn btn-sm btn-primary excelBtn" onclick="pf_excel2()">
                                            <i class="fa fa-file-excel-o"></i> 엑셀
                                        </button>
                                    </div>
                                </legend>
                                <p>설문기간: ${SmDTO.SM_STARTDT } ~ ${SmDTO.SM_ENDDT }</p>
                                <p>참여인원 : ${SmDTO.CNT }명</p>
                                <p>설 명 :
                                    <pre>${SmDTO.SM_EXP }</pre>
                                </p>
                            </div>
                        </div>
                    </fieldset>
                    <div class="tab-content">

                        <div class="tab-pane fade in active" id="hr1">
                            <fieldset>
                                <div class="sq_main" id="sq_main">
                                    <h4>각 문항에 대한 설문 결과 입니다.</h4><br>
                                    <c:forEach items="${sq_list }" var="sq" varStatus="sqc">
                                        <div class="sq_row">
                                            <input type="hidden" name="SQ_KEYNO" value="${sq.SQ_KEYNO }">
                                            <input type="hidden" name="SQ_ST_TYPE" id="SQ_ST_TYPE_${sqc.count }" value="${sq.SQ_ST_TYPE }">
                                            <input type="hidden" name="SQ_OPTION_DATA" id="SQ_OPTION_DATA_${sqc.count }">
                                            <div class="sq_question">${sq.SQ_NUM }.&nbsp;${sq.SQ_QUESTION }</div>

                                            <div class="sqo_main">
                                                <c:if test="${sq.SQ_ST_TYPE eq 'T' }">
                                                    <div class="sqo_row">
                                                        <c:forEach items="${srmList_an }" var="srm_an">
                                                            <c:if test="${sq.SQ_KEYNO == srm_an.SRD_SQ_KEYNO }">
                                                                <div class="BoxCommon resultBox">
                                                                    <c:out value="${srm_an.SRD_DATA }" />
                                                                </div>
                                                            </c:if>
                                                        </c:forEach>
                                                    </div>
                                                </c:if>

                                                <c:if test="${sq.SQ_ST_TYPE eq 'R' || sq.SQ_ST_TYPE eq 'O' || sq.SQ_ST_TYPE eq 'C' }">
                                                    <div class="inline-group">
                                                        <c:forEach items="${srmList_op }" var="srm_op" varStatus="srmc">
                                                            <c:if test="${sq.SQ_KEYNO eq srm_op.SQO_SQ_KEYNO }">
                                                                <div class="sqo_row" id="sqo_row_${srmc.count }">
                                                                    <label class="option">
                                                                        <i></i>
                                                                        <div class="srm_option">${srm_op.SQO_NUM}.&nbsp;${srm_op.SQO_OPTION }</div>
                                                                        <c:if test="${SmDTO.SM_CNT_TYPE eq 'S' }">
                                                                            <div class="srm_result"> (배점: ${srm_op.SQO_VALUE } * 선택인원: ${srm_op.CNT_CHOICE } = 총점: ${srm_op.SUM_VAL })</div>
                                                                        </c:if>
                                                                        <div class="clear"></div>
                                                                        <div class="progress">
                                                                            <input type="hidden" class="CNT_CHOICE" value="${srm_op.CNT_CHOICE }">
                                                                            <div class="progressbar">
                                                                                <div class="progresslabel">${srm_op.CNT_CHOICE }명</div>
                                                                            </div>
                                                                        </div>
                                                                    </label>
                                                                </div>
                                                            </c:if>
                                                        </c:forEach>
                                                    </div>
                                                    <c:if test="${sq.SQ_ST_TYPE eq 'R' || sq.SQ_ST_TYPE eq 'O' && sq.SQ_ORDER_TYPE eq 'Y'}">
                                                        <div class="sqo_row">
                                                            <br>
                                                            <div>기타 의견</div><br>
                                                            <c:forEach items="${srmList_an }" var="srm_an">
                                                                <c:if test="${sq.SQ_KEYNO == srm_an.SRD_SQ_KEYNO }">
                                                                    <c:if test="${srm_an.SRD_DATA ne '' }">
                                                                        <div class="BoxCommon resultBox">
                                                                            <c:out value="${srm_an.SRD_DATA }" />
                                                                        </div>
                                                                    </c:if>
                                                                </c:if>
                                                            </c:forEach>
                                                        </div>
                                                    </c:if>
                                                     <c:if test="${sq.SQ_ST_TYPE eq 'O' && sq.SQ_IN_ORDER_TYPE eq 'Y'}">
	                                                    <div class="sqo_row">
                                                            <br>
                                                            <div>기타 의견(선택형)</div><br>
                                                            <c:forEach items="${srmList_an2 }" var="srm_an2">
                                                                <c:if test="${sq.SQ_KEYNO == srm_an2.SRD_SQ_KEYNO }">
                                                                    <c:if test="${srm_an.SRD_IN_DATA ne '' }">
	                                                                    <div class="BoxCommon resultBox">
	                                                                        <c:out value="${srm_an2.SRD_IN_DATA }" />
	                                                                     </div>
                                                                     </c:if>
                                                                </c:if>
                                                            </c:forEach>
                                                        </div>
                                                    </c:if>
                                                </c:if>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </fieldset>

                        </div>

                        <div class="tab-pane fade" id="hr2">
                            <div class="table-responsive">
                                <jsp:include page="/WEB-INF/jsp/dyAdmin/include/search/pra_search_header_paging.jsp" flush="true">
                                    <jsp:param value="/dyAdmin/operation/survey/result/detailView/pagingAjax.do" name="pagingDataUrl" />
                                    <jsp:param value="/dyAdmin/operation/survey/result/detailView/excelAjax.do" name="excelDataUrl" />
                                </jsp:include>
                                <fieldset id="tableWrap">
                                </fieldset>
                            </div>
                        </div>

                        <fieldset class="padding-10 text-right">
                            <button class="btn btn-sm btn-default" type="button" onclick="cf_back('/dyAdmin/operation/survey/survey.do')">
                                <i class="fa fa-reorder"></i> 목록으로
                            </button>
                        </fieldset>


                    </div>
                </div>
            </div>
        </div>
    </section>
</form:form>

<script type="text/javascript">
    $(function() {

        /* 휴일 추가 팝업 */
        cf_setttingDialog('#survey_data', '설문답변 상세내용');

        pf_porgressBar();
    });

    //프로그래스바 설정
    function pf_porgressBar() {
        var panel = '${SmDTO.SM_PANEL_CNT}';
        $("#sq_main .sq_row").each(function() {
            $(this).find(".progress").each(function(i) {
                var val = $(this).find(".CNT_CHOICE").val();
                var num = val / panel * 100;
                $(this).find(".progressbar").progressbar({
                    value: num
                });
            });
        });
    }


    /* 설문답변 상세보기 모달창 오픈 */
    function pf_openSurveyData(key) {
        $('#survey_data').dialog('open');

        $.ajax({
            url: '/dyAdmin/operation/survey/result/dataAjax.do',
            type: 'POST',
            data: {
                "SRM_KEYNO": key
            },
            async: false,
            success: function(data) {

                var temp = '';

                $.each(data, function(i) {
                    temp += '<div class="sq_row">';
                    var typeText = (data[i].SQ_ST_TYPE == 'T') ? '주관식' : '객관식';

                    temp += '<div class="sq_question">' + data[i].SQ_NUM + '.&nbsp;' + data[i].SQ_QUESTION + '(' + typeText + ')</div>'
                    temp += '<div style="margin: 5px 0px 0px 15px;">'
                    if (data[i].SQ_ST_TYPE == 'T') { // 주관식
                        var srd_data = data[i].SRD_DATA;
                        if (typeof srd_data == 'undefined') {
                            temp += '';
                        } else {
                            temp += '<div class="BoxCommon resultBox2">' + srd_data + '</div>';
                        }
                    } else { //객관식
                        var keyList = data[i].ALL_SQO_KEYNO.split('||');
                        var numList = data[i].ALL_SQO_NUM.split('||');
                        var optionList = data[i].ALL_SQO_OPTION.split('||');
                        var valueList = data[i].ALL_SQO_VALUE.split('||');

                        $.each(keyList, function(j) {
                            if (data[i].SELECTED_SQ_KEYNO.indexOf(keyList[j]) != -1) {
                                temp += '<div style="margin-bottom:3px;font-weight:bold;color:#bd239b"><font style="border: 1px solid #bd239b;border-radius: 100px;padding: 0px 5px;">' + numList[j] + '</font>'
                            } else {
                                temp += '<div style="margin-bottom:3px;color:gray">' + numList[j]
                            }
                            temp += '.&nbsp;' + optionList[j] + '</div>'
                        })
                        if (data[i].SQ_ST_TYPE == 'R') { //  객관식(기타의견 있으면)
	                        if(data[i].SQ_ORDER_TYPE == 'Y' && data[i].SRD_DATA != "") {                        		
	                        	temp += '<br><span>기타 의견</span><br>';
	                            var srd_data = data[i].SRD_DATA;
                                if (typeof srd_data == 'undefined') {
                                    temp += '';
                                } else {
                                    temp += '<div class="BoxCommon resultBox2">' + srd_data + '</div>';
                                }
                        	}
                        } else if(data[i].SQ_ST_TYPE == 'O') {
                            if(data[i].SQ_ORDER_TYPE == 'Y' && data[i].SRD_DATA != "") {                        		
	                        	temp += '<br><span>기타 의견</span><br>';
	                            var srd_data = data[i].SRD_DATA;
                                if (typeof srd_data == 'undefined') {
                                    temp += '';
                                } else {
                                    temp += '<div class="BoxCommon resultBox2">' + srd_data + '</div>';
                                }
                        	}
                            if(data[i].SQ_IN_ORDER_TYPE == 'Y' && data[i].SRD_IN_DATA != ""){
                            	temp += '<br><br><span>기타 의견(선택형)</span><br>';
                                var srd_data = data[i].SRD_IN_DATA;
                                if (typeof srd_data == 'undefined') {
                                    temp += '';
                                } else {
                                    temp += '<div class="BoxCommon resultBox2">' + srd_data + '</div>';
                                }
                            }                            
                        } 
                    }
                    temp += '</div></div></div>';
                })

                $('#survey_data').html(temp);

            },
            error: function() {
                cf_smallBox('error', '에러!! 관리자한테 문의하세요', 3000, '#d24158');
            }
        });
    }

    /* 설문답변 삭제하기 */
    function pf_deleteSuveryData(key) {
        $("input[name=SRM_KEYNO]").val(key);
        cf_smallBoxConfirm('Ding Dong!', '정말 삭제 하시겠습니까?', 'result_delete()');
    }

    // 삭제 콜백 함수
    function result_delete() {
        $("#Form").attr("action", "/dyAdmin/operation/survey/deleteResultData.do");
        $("#Form").submit();
    }

    //엑셀 버튼
    function pf_excel2() {
        $('#Form').attr('action', "/dyAdmin/operation/survey/result/detailExcel.do");
        $('#Form').submit();
    }
</script>

<!-- 휴일 추가 팝업 CONTENT -->
<div id="survey_data" title="휴일 추가">
</div>