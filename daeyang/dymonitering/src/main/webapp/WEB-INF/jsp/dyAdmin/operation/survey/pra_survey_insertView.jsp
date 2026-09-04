<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<style>
    .optionBtn,
    .column_size_dp {
        display: none;
    }

    .option {
        margin-left: 15px;
        margin-top: 5px;
    }

    .option .num {
        margin-right: 5px;
    }

    .marginLeft {
        margin-left: 10px;
    }

    .optiondialog_append_row {
        margin-bottom: 10px;
    }

    .sq-column-row {
        padding: 20px 0 10px;
        border-top: 1px solid #777;
    }
</style>

<div id="content">
    <form:form id="Form" name="Form" method="post" action="">
        <input type="hidden" name="SM_REGNM" value="${userInfo.UI_ID }" />
        <input type="hidden" id="SM_KEYNO" name="SM_KEYNO" value="${SmDTO.SM_KEYNO }" />
        <input type="hidden" id="SQ_KEYNO" name="SQ_KEYNO" />
        <input type="hidden" id="action" name="action" value="${action}" />

        <section id="widget-grid">
            <div class="row">
                <article class="col-sm-12 col-md-12 col-lg-12">
                    <div class="jarviswidget jarviswidget-color-blueDark" id="" data-widget-editbutton="false">
                        <header>
                            <span class="widget-icon"> <i class="fa fa-table"></i>
                            </span>
                            <h2>설문지   ${action eq 'Insert' ? '등록하기' : '상세보기' }</h2>
                        </header>

                        <div>
                            <div class="widget-body-toolbar bg-color-white">
                                <div class="alert alert-info no-margin fade in">
                                    <button type="button" class="close" data-dismiss="alert">×</button>
                                    ${action eq 'Insert' ? '설문지를 작성합니다' : '작성된 설문지를 확입합니다.' } <br>
                                    <c:if test="${action eq 'Update' }">
                                        <span style="color: red;">* 참여자가 있는 설문조사는 수정하실 수 없습니다.</span>
                                        <br>
                                    </c:if>
                                    <span style="color: red;">* 표시는 필수 입력 항목입니다.</span>
                                </div>
                            </div>

                            <div class="widget-body no-padding smart-form">
                                <fieldset>
                                    <div class="row">
                                        <section class="col col-12">
                                            <h6>설문지   ${action eq 'Insert' ? '등록하기' : '상세보기' }</h6>
                                        </section>
                                    </div>

                                    <div class="row">
                                        <section class="col col-6">
                                            <label class="col-md-2 control-label"><span class="nessSpan">*</span> 설문 제목</label>
                                            <div class="col-md-9">
                                                <label class="input"> <i class="icon-prepend fa fa-edit"></i> <input class="checkTrim" type="text" id="SM_TITLE" name="SM_TITLE" placeholder="설문지 제목" maxlength="50" value="${SmDTO.SM_TITLE }" />
                                                </label>
                                            </div>
                                        </section>
                                        <section class="col col-6">
                                            <label class="col-md-2 control-label"><span class="nessSpan">*</span> 홈페이지 선택</label>
                                            <div class="col-md-9">
                                                <select class="form-control input-sm" id="SM_MN_KEYNO" name="SM_MN_KEYNO">
                                                    <option value="">홈페이지 선택</option>
                                                    <c:forEach items="${homeDivList }" var="model">
                                                        <option value="${model.MN_KEYNO }" ${model.MN_KEYNO eq SmDTO.SM_MN_KEYNO ? 'selected' : '' }>${model.MN_NAME }</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </section>
                                    </div>

                                    <div class="row">
                                        <section class="col col-6">
                                            <label class="col-md-2 control-label"><span class="nessSpan">*</span> 설문 시작일</label>
                                            <div class="input-group col-9">
                                                <input name="SM_STARTDT" id="SM_STARTDT" type="text" class="form-control datepicker" data-dateformat="yy-mm-dd" value="${SmDTO.SM_STARTDT }" maxlength="10" autocomplete="off"> <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
                                            </div>
                                        </section>
                                        <section class="col col-6">
                                            <label class="col-md-2 control-label"><span class="nessSpan">*</span> 설문 종료일</label>
                                            <div class="input-group col-9">
                                                <input name="SM_ENDDT" id="SM_ENDDT" type="text" class="form-control datepicker" data-dateformat="yy-mm-dd" value="${SmDTO.SM_ENDDT }" maxlength="10" autocomplete="off"> <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
                                            </div>
                                        </section>
                                    </div>
                                    <c:if test="${fn:length(surveySkinList) > 0 }">
                                        <div class="row">
                                            <section class="col col-6">
                                                <label class="col-md-2 control-label"><span class="nessSpan">*</span>설문 스킨</label>
                                                <div class="col-md-9">
                                                    <select class="form-control input-sm" id="SM_SS_KEYNO" name="SM_SS_KEYNO">
                                                        <option value="basic">스킨을 적용하시지 않으면 기본 스킨이 자동으로 적용됩니다.(스킨 없음)</option>
                                                        <c:forEach items="${surveySkinList }" var="model" varStatus="status">
                                                            <option value="${model.SS_KEYNO}" ${model.SS_KEYNO eq SmDTO.SM_SS_KEYNO ? 'selected' : '' }>${model.SS_SKIN_NAME }</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </section>

                                        </div>
                                    </c:if>
                                    <div class="row">
                                        <section class="col col-12">
                                            <label class="col-md-1 control-label"><span class="nessSpan">*</span> 설문 내용</label>
                                            <div class="col-md-11">
                                                <label class="input"> <textarea class="checkTrim" id="SM_EXP" name="SM_EXP" placeholder="설문 기초 설명" rows="5" style="width: 100%; resize: none;" maxlength="2000">${SmDTO.SM_EXP }</textarea>
                                                </label>
                                            </div>
                                        </section>

                                        <section class="col col-6">
                                            <label class="col-md-2 control-label">실명 사용여부</label>
                                            <div class="col-sm-12 col-md-9">
                                                <label class="radio radio-inline no-margin"> <input type="radio" name="SM_IDYN" value="Y" class="radiobox style-2" data-bv-field="rating" ${SmDTO.SM_IDYN eq 'Y' ? 'checked' :''}> <span>사용</span>
                                                </label> <label class="radio radio-inline no-margin"> <input type="radio" name="SM_IDYN" value="N" class="radiobox style-2" data-bv-field="rating" ${empty SmDTO.SM_IDYN || SmDTO.SM_IDYN eq 'N' ? 'checked' :''}>
                                                    <span>미사용</span>
                                                </label>
                                            </div>
                                        </section>
                                        <section class="col col-6">
                                            <label class="col-md-2 control-label">보기배점방식</label>
                                            <div class="col-sm-12 col-md-9">
                                                <label class="radio radio-inline no-margin"> <input type="radio" name="SM_CNT_TYPE" value="S" class="radiobox style-2" data-bv-field="rating" ${SmDTO.SM_CNT_TYPE eq 'S' ? 'checked' :''} onclick="pf_bogiShowHide('S');"> <span>점수</span>
                                                </label> <label class="radio radio-inline no-margin"> <input type="radio" name="SM_CNT_TYPE" value="H" class="radiobox style-2" data-bv-field="rating" ${empty SmDTO.SM_CNT_TYPE || SmDTO.SM_CNT_TYPE eq 'H' ? 'checked' :''} onclick="pf_bogiShowHide('H');"> <span>인원수</span>
                                                </label>
                                            </div>
                                        </section>
                                    </div>
                                </fieldset>
                                <div class="text-right" style="padding: 20px;">
                                    <button class="btn btn-sm btn-primary" id="Board_Edit" type="button" onclick="pf_smAction('${action}')">
                                        <i class="fa fa-floppy-o"></i> 저장
                                    </button>
                                    <c:if test="${action eq 'Update' }">
                                        <button class="btn btn-sm btn-danger" id="Board_Edit" type="button" onclick="pf_smDelete()">
                                            <i class="fa fa-floppy-o"></i> 삭제
                                        </button>
                                    </c:if>
                                    <button class="btn btn-sm btn-default" id="Board_Delete" type="button" onclick="cf_back('/dyAdmin/operation/survey/survey.do')">
                                        <i class="fa fa-times"></i> 목록으로
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </article>
            </div>
        </section>
    </form:form>
</div>

<%@ include file="/WEB-INF/jsp/dyAdmin/operation/survey/script/pra_survey_insertView_script.jsp"%>