package com.tx.dyAdmin.member.dto;

import com.tx.common.dto.Common;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper=false)
public class LicenseDTO extends Common {
	
	private static final long serialVersionUID = -3793808669767332434L;
	
	private String  
					//main ,main_liUpdate, main_liInsert, main_liView
					dlm_keyno,
					dlm_address,//지번
					dlm_street,//신청지번
					dlm_area,//필지면적
					dlm_land,//지목
					dlm_use,//용도지구
					dlm_usage,//용도지역
					dlm_dpp_keyno,//발전소키
					dlm_type,//신청구분
					dlm_purpose,//신청목적
					dlm_trueAddress,//주소
					dlm_connDate,//허가접수일
					dlm_endDate,//허가처리예정일
					
					
					//sub
					dls_keyno,
					dls_dpp_keyno,
					dls_conn, //접수일
					dls_name, //실무담당자
					dls_depart,//실무담당부서
					dls_phone, //실무담당연락처
					dls_email, //실무담당이메일
					dls_other, //비고
					dls_name2, //처리기관명
					dls_depart2, //처리가관기관담당부서
					dls_phone2, //처리기관담당연락처
					dls_other2, //비고2
					dls_name3, //감리업체
					dls_depart3, //담당부서2
					dls_phone3, //담당연락처2
					dls_other3, //비고2
					dls_now, //등록현황 키값
					dls_endDate, //처리예정일
					dls_usernumber, //
					dls_volum,
					
					//other
					savetype,
					
					
					//신청내역테이블 dy_license_app, app_liUpdate, app_liInsert, app_liView
					dls_app_dpp_keyno,
					dls_app_plant,
					dls_app_vol1,
					dls_app_vol2,
					dls_app_address,
					dls_app_form,
					dls_app_appDate,
					dls_app_dueDate,
					dls_app_appNum,
					dls_app_cusNum,
					dls_app_appPeriod,
					dls_app_module,
					dls_app_inverter,
					dls_app_appModule,
					dls_app_weight,
					dls_app_jsgDate,
					dls_app_swgDate,
					dls_app_jgjDate,
					dls_app_jgpDate,

					//담당자 테이블dy_license_man,man_liUpdate, man_liInsert, man_liView
					dls_man_dpp_keyno,
					dls_man_ceoName,
					dls_man_ceoAddress,
					dls_man_ceoPhone,
					dls_man_ceoEmail,
					dls_man_daeName,
					dls_man_daeDepart,
					dls_man_daePostion,
					dls_man_daePhone,
					dls_man_daeEmail,
					dls_man_govName,
					dls_man_govDepart,
					dls_man_govPhone,
					dls_man_serCoName,
					dls_man_serName,
					dls_man_serDepart,
					dls_man_serPhone,
					dls_man_serEmail,
					dls_man_gamName,
					dls_man_gamPeriod,
					dls_man_type,
					
					//설비구성 테이블dy_license_com, com_liView, com_liInsert, com_liUpdate
					dls_com_dpp_keyno,
					dls_com_moName,
					dls_com_moVolum,
					dls_com_moQuantity,
					dls_com_moEtc,
					dls_com_inName,
					dls_com_invVolum,
					dls_com_inQuantity,
					dls_com_inEtc,
					dls_com_connName,
					dls_com_connVolum,
					dls_com_connQuantity,
					dls_com_connEtc
					;
}
