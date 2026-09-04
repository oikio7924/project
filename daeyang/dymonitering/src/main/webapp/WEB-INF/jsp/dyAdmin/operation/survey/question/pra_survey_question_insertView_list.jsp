<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<style>
    #insert-article {display: none; }
    .fixed-btns {position: fixed; bottom: 10px; right: 30px; z-index: 100; }
    .fixed-btns>li { display: inline-block;  margin-bottom: 7px; }
</style>

<form:form id="Form" name="Form" method="post" action="">
    <input type="hidden" name="SQ_SM_KEYNO" id="SQ_SM_KEYNO" value="${SM_KEYNO }" />
    <section id="widget-grid">
        <div class="row">
            <article class="col-xs-12 col-sm-12 col-md-12 sortable-grid ui-sortable col-lg-12" id="list-article">
                <div class="jarviswidget jarviswidget-color-blueDark" id="BOARD_TYPE_LIST_1" data-widget-editbutton="false">
                    <header>
                        <span class="widget-icon"> <i class="fa fa-table"></i>
                        </span>
                        <h2>문항 내역</h2>
                    </header>
                    <div class="widget-body ">
                        <div class="widget-body-toolbar bg-color-white">
                            <div class="alert alert-info no-margin fade in">
                                <button type="button" class="close" data-dismiss="alert">×</button>
                                설문 문항 목록 입니다. 문항을 확인하거나 새롭게 등록 할 수 있습니다.
                            </div>
                        </div>
                        <div class="widget-body-toolbar bg-color-white">
                            <div class="row">
                                <div class="col-sm-12 col-md-12 text-align-right" style="float:right;">
                                    <div class="btn-group">
                                        <button class="btn btn-sm btn-primary" type="button" onclick="pf_insertSurvey()">
                                            <i class="fa fa-plus"></i> 문항 등록
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="table-responsive">
                            <jsp:include page="/WEB-INF/jsp/dyAdmin/include/search/pra_search_header_paging.jsp" flush="true">
                                <jsp:param value="/dyAdmin/operation/survey/pagingQuestAjax.do" name="pagingDataUrl" />
                                <jsp:param value="/dyAdmin/operation/survey/excelAjax.do" name="excelDataUrl" />
                            </jsp:include>
                            <fieldset id="tableWrap">
                            </fieldset>
                        </div>
                        <fieldset class="padding-10 text-right">
                            <button class="btn btn-sm btn-default" type="button" onclick="cf_back('/dyAdmin/operation/survey/survey.do')">
                                <i class="fa fa-reorder"></i> 목록으로
                            </button>
                        </fieldset>
                    </div>
                </div>
            </article>

            <article class="col-xs-12 col-sm-12 col-md-12 col-lg-8" id="insert-article">
                <div class="jarviswidget jarviswidget-color-darken" id="wid-id-0" data-widget-editbutton="false">
                    <header>
                        <span class="widget-icon"> <i class="fa fa-table"></i>
                        </span>
                        <h2>설문 문항 등록/수정</h2>
                    </header>
                    <div class="widget-body">
                        <form:form id="insertForm" class="form-horizontal" name="Form" method="post" action="">
                            <div id="inputFormBox">
                            </div>
                        </form:form>
                        <ul class="fixed-btns">
                            <li>
                                <a href="javascript:;" onclick="pf_save()" class="btn btn-primary btn-circle btn-lg" title="저장하기"><i class="fa fa-save"></i></a>
                            </li>
                            <li id="deleteBtn">
                                <a href="javascript:;" onclick="pf_delete()" class="btn btn-danger btn-circle btn-lg" title="삭제하기"><i class="fa fa-trash-o"></i></a>
                            </li>
                            <li>
                                <a href="javascript:;" onclick="pf_togleArticle('N')" class="btn btn-default btn-circle btn-lg" title="위로가기"><i class="fa fa-arrow-right"></i></a>
                            </li>
                        </ul>
                    </div>
                </div>
            </article>
        </div>
    </section>
</form:form>


<script type="text/javascript">
    var ParticipationCnt = '${SmDTO.CNT}'

    function pf_surveyRegist() {

        location.href = '/dyAdmin/operation/survey/insertView.do';
    }

    function pf_surveyActionView(type, sm_keyno) {
        $("#action").val(type);
        $("#SM_KEYNO").val(sm_keyno);
        $("#Form").attr("action", "/dyAdmin/operation/survey/actionView.do");
        $("#Form").submit();
    }

    function pf_resultDetailView(sm_keyno) {
        $("#SM_KEYNO").val(sm_keyno);
        $("#Form").attr("action", "/dyAdmin/operation/survey/result/detailView.do");
        $("#Form").submit();
    }

    function pf_questionDetailView(sm_keyno) {
        $("#SM_KEYNO").val(sm_keyno);
        $("#Form").attr("action", "/dyAdmin/operation/survey/questionListView.do");
        $("#Form").submit();
    }

    <% String excelDataUrl = request.getParameter("excelDataUrl"); %>

    //엑셀 버튼
    function pf_question_excel(url, formId) {
        url = url || 'QuestExcelAjax.do'
        formId = formId || '#Form';
        SQ_SM_KEYNO = '${SM_KEYNO }';

        cf_checkExcelDownload();

        $(formId).attr('action', url);
        $(formId).submit();

    }

    // 저장하기
    function pf_save() {
        var state = false;

        if (ParticipationCnt > 0) {
            cf_smallBox('Form', '설문조사 참여자가 존재합니다.', 3000, '#d24158');
            return state;
        } else {
            $('.quest_option').each(function() {
                var divID = $(this).attr('id').replace('SQ', '');
                pf_optionAppend(divID);
            });
           valcheck();
        }
    }


    //보기 문항 하나로 묶기
    function pf_optionAppend(divID) {
        var data = "";
        var lang = $("#SQO" + divID).find(".option").length;
        var type = $("input[type=radio][name=SM_CNT_TYPE]:checked").val();

        $("#SQO" + divID).find(".option").each(function(i) {
            data += $(this).find(".num2").val();
            data += "_";
            data += $(this).find(".sqo_option").val();
            data += "_";
            if (type == 'S') {
                data += $(this).find(".sqo_value").val();
            } else {
                data += 1;
            }
            
            data += "_";

	    	var numselectBox = $("select[id=SQ_ST_TYPE_row1]").val();	    		
            var length = $(".optiondialog_append_row").find('.num').length; // 현재 옵션 갯수
	    	if(numselectBox == 'O' && $("input:checkbox[id='SQ_orderck']").is(":checked") == true) {            
	            if(i + 1 == lang) {
					data += 'Y';
				} else {
					data += 'N';				
				}
	    	} else {
					data += 'N';					    		
	    	}
            
            if (i + 1 < lang) {
                data += "/";
            }
            
        });

        $("#SQ_OPTION_DATA" + divID).val(data);

    }

    //보기 문항 체크
    function valcheck() {
        var bool = true;

        $("#inputFormBox").each(function() {
            if (!$(this).find("input[name='SQ_NUM']").val().trim()) {
                cf_smallBox('Form', '번호를 작성해 주세요.', 3000, '#d24158');
                $(this).find("input[name='SQ_NUM']").focus();
                bool = false;
                return bool;
            }

            if ($(this).find("select[name='SQ_ST_TYPE']").val() == "") {
                cf_smallBox('Form', '문제 타입을 입력해주세요.', 3000, '#d24158');
                $(this).find("select[name='SQ_ST_TYPE']").focus();
                bool = false;
                return bool;
            }

            if (!$(this).find("input[name='SQ_QUESTION']").val().trim()) {
                cf_smallBox('Form', '질문을 작성해 주세요.', 3000, '#d24158');
                $(this).find("input[name='SQ_QUESTION']").focus();
                bool = false;
                return bool;
            }

            if (!$(this).find("textarea[name='SQ_COMMENT']").val().trim()) {
                cf_smallBox('Form', '문항 설명을 작성해 주세요.', 3000, '#d24158');
                $(this).find("textarea[name='SQ_COMMENT']").focus();
                bool = false;
                return bool;
            }

            if ($(this).find("select[name='SQ_ST_TYPE']").val() != 'T') {
                if ($(this).find(".option").length < 1) {
                    cf_smallBox('Form', '보기는 최소 한개 이상 존재해야합니다.', 3000, '#d24158');
                    bool = false;
                    return bool;
                } else {
                    $(this).find(".optiondialog_append_row .option").each(function() {
                        if ($(this).find("input[name='sqo_option']").val() == "") {
                            cf_smallBox('Form', '보기를 작성해 주세요.', 3000, '#d24158');
                            $(this).find("input[name='sqo_option']").focus();
                            bool = false;
                            return bool;
                        }                        
                        if ($(this).find("input[name='SQO_NUM']").val() == "") {
                            cf_smallBox('Form', '옵션 번호를 작성해 주세요.', 3000, '#d24158');
                            $(this).find("input[name='SQO_NUM']").focus();
                            bool = false;
                            return bool;
                        }
                        var type = $("input[type=radio][name=SM_CNT_TYPE]:checked").val();

                        // S : 점수, H : 인원수
                        if (type == 'S') {
                            if ($(this).find("input[name='sqo_value']").val() == "") {
                                cf_smallBox('Form', '배점을 작성해 주세요.', 3000, '#d24158');
                                $(this).find("input[name='sqo_value']").focus();
                                bool = false;
                                return bool;
                            }
                        }
                    })
                }
            }
        });        
	    if(bool == true) {
	        pf_sq_save();
	    }    
    }

    function pf_sq_save() {
        $("#inputFormBox").each(function() {
            // 번호 중복 검사
            var ck_num = $(this).find("input[name='SQ_NUM']").val(); // 현재 번호
            var sq_keyno = $("input[name='SQ_KEYNO']").val();
            var sq_sm_keyno = $("input[name='SQ_SM_KEYNO']").val();
            $.ajax({
                type: "POST",
                url: "/dyAdmin/operation/survey/RedundancyNumAjax.do",
                data: {
                    "SQ_NUM": ck_num,
                    "SQ_KEYNO": sq_keyno,
                    "SQ_SM_KEYNO": sq_sm_keyno
                },
                success: function(data) {
                    if (data > 0) {
                        cf_smallBox('error', '번호가 중복됩니다.', 3000, '#d24158');
                        return false;
                    } else {
                        cf_smallBoxConfirm('Ding Dong!', '저장 하시겠습니까?', 'success()');
                    }
                },
                error: function() {
                    cf_smallBox('error', '문항 번호 중복검사 에러발생', 3000, '#d24158');
                }
            });

        });

    }

    //성공 콜백 함수   
    function success() {
        var sq_sm_keyno = $("input[name='SQ_SM_KEYNO']").val();

        $.ajax({
            type: "post",
            url: "/dyAdmin/operation/survey/questionUpdateAjax.do",
            data: $("#Form").serialize(),
            success: function(data) {
                $("#inputFormBox").html(data);
                $.ajax({
                    type: "post",
                    url: "/dyAdmin/operation/survey/pagingQuestAjax.do",
                    data: {
                        "SQ_SM_KEYNO": sq_sm_keyno
                    },
                    success: function(data) {
                        $("#tableWrap").html(data);
                        cf_smallBox('success', '등록되었습니다.', 3000);
                    },
                    error: function() {
                        cf_smallBox('error', '문항 목록 재출력 에러발생', 3000, '#d24158');
                    }
                });

            },
            error: function() {
                cf_smallBox('error', '현재 문항 출력 에러발생', 3000, '#d24158');
            }
        });
    }


    //삭제하기
    function pf_delete() {
        if (ParticipationCnt > 0) {
            cf_smallBox('Form', '설문조사 참여자가 존재합니다.', 3000, '#d24158');
            return false;
        } else {
            cf_smallBoxConfirm('Ding Dong!', '정말 삭제 하시겠습니까?', 'sqo_delete()');
        }
    }

    // 삭제 콜백 함수
    function sqo_delete() {
        cf_replaceTrim($("#Form"));
        $("#Form").attr("action", "/dyAdmin/operation/survey/quest_delete.do");
        $("#Form").submit();
    }
</script>