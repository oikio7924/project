package com.tx.dyAdmin.operation.survey.dto;

import com.tx.common.dto.Common;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * @SurDTO
 * 설문지 등록을 담당.
 * 
 * @author 김영탁
 * @version 1.0
 * @since 2017-03-09
 */ 

@Data
@EqualsAndHashCode(callSuper=false)
public class SmDTO extends Common {
	
	private static final long serialVersionUID = 1251301280729605203L;

	//  설문지 기본키
    private String SM_KEYNO;

    //  설문지 제목
    private String SM_TITLE;

    //  설문지 기초 설명
    private String SM_EXP;

    //  설문시작일
    private String SM_STARTDT;

    //  설문종료일
    private String SM_ENDDT;

    //  작성자
    private String SM_REGNM;

    //  작성일
    private String SM_REGDT;

    //  익명여부
    private String SM_IDYN;

    //  설문 홈페이지사용여부
    private String SM_HOMEYN;

    //  설문삭제여부 
    private String SM_DELYN;
    
    // 설문참여인원
    private String SM_PANEL_CNT;
    
    // 설문점수타입 (점수 / 사람수)
    // 점수 : S / 사람수 : H
    private String SM_CNT_TYPE;
    
    private String SM_MN_KEYNO;

    // 설문 스킨 KEY값
    private String SM_SS_KEYNO;

}
