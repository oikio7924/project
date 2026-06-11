package com.tx.dyAdmin.admin.code.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.tx.common.config.SettingData;
import com.tx.common.config.annotation.CheckActivityHistory;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.dyAdmin.admin.code.dto.MainCode;
import com.tx.dyAdmin.admin.code.dto.SubCode;
import com.tx.dyAdmin.admin.code.service.CodeService;

@Controller
public class AdminCodeController {

	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	@Autowired CodeService CodeService;

	// 상위 코드 목록 페이지 호출
	@RequestMapping(value = "/dyAdmin/admin/code.do")
	@CheckActivityHistory(desc="상위 코드 목록 페이지 방문")
	public String GetMainCodeList(Model model) throws Exception {
		model.addAttribute("list", Component.getListNoParam("Code.AMC_GetList"));
		return "/dyAdmin/admin/code/pra_code_view.adm";
	}

	// 서브 코드 목록 페이지 호출
	@RequestMapping(value = "/dyAdmin/func/sub/code.do")
	@CheckActivityHistory(desc="서브 코드 목록 페이지 방문")
	public String GetSubCodeList(@ModelAttribute("MC_IN_C")String MC_IN_C, 
			@ModelAttribute ("MainCode") MainCode Maincode, 
			Model model) throws Exception {
		
		Maincode = Component.getData("Code.AMC_Getdata", Maincode);
		model.addAttribute("list", CodeService.getCodeListAll(MC_IN_C));
		model.addAttribute("result", Maincode);
		model.addAttribute("mirrorPage", "/dyAdmin/admin/code.do");
		return "/dyAdmin/admin/code/pra_subcode_view.adm";
	}
	
	// 상위 코드 등록 페이지 호출
	@RequestMapping(value = "/dyAdmin/admin/code/sub/insertView.do")
	@CheckActivityHistory(desc="상위 코드 등록 페이지 방문")
	public String GetMainCodeListRegist(@ModelAttribute("MC_IN_C")String MC_IN_C, Model model) throws Exception {
		model.addAttribute("list", CodeService.getCodeListisUse(MC_IN_C, true));
		model.addAttribute("mirrorPage", "/dyAdmin/admin/code.do");
		return "/dyAdmin/admin/code/pra_code_regist.adm";
	}
		

	// 상위 코드 등록 작업
	@RequestMapping(value = "/dyAdmin/admin/code/main/insert.do")
	@CheckActivityHistory(desc="상위 코드 등록 작업", homeDiv= SettingData.HOMEDIV_ADMIN)
	@Transactional
	public String InsertMainCodeRegist(
			@ModelAttribute ("MainCode") MainCode Maincode, 
			Model model) throws Exception {
		
		Maincode.setMC_KEYNO(CommonService.getTableKey("MC"));
		
		String MaxIn_C= Component.getData("Code.AMC_maxINC", Maincode);
		
		char firstMaxIn_C = MaxIn_C.charAt(1);
		char secondMaxIn_C = MaxIn_C.charAt(0);
		
		if(firstMaxIn_C+1>90){
			secondMaxIn_C= (char)(secondMaxIn_C+1);
			firstMaxIn_C = 'A';
		}else{
			firstMaxIn_C = (char)(firstMaxIn_C+1);
		}
		String tempIN_C;
		
		tempIN_C = ""+secondMaxIn_C+firstMaxIn_C;
		
		Maincode.setMC_IN_C(tempIN_C.trim());
		
		Component.createData("Code.AMC_insertCode", Maincode);
		CodeService.setCodeOne(Maincode.getMC_IN_C());
		
		return "redirect:/dyAdmin/admin/code.do";
	}	
		
	
	// 메인코드 수정하기 
	@RequestMapping(value = "/dyAdmin/admin/code/main/update.do")
	@CheckActivityHistory(desc="메인 코드 수정 작업", homeDiv= SettingData.HOMEDIV_ADMIN)
	@Transactional
	public String updateMainCode(
			@ModelAttribute ("MainCode") MainCode Maincode, 
			Model model) throws Exception {
		
		Component.updateData("Code.AMC_updatCode", Maincode);		
		CodeService.setCodeOne(Maincode.getMC_IN_C());
		model.addAttribute("mirrorPage", "/dyAdmin/admin/code.do");
		return "/dyAdmin/admin/code/pra_code_regist.adm";
	}
	
	// 메인코드 삭제하기 
	@RequestMapping(value = "/dyAdmin/admin/code/main/delete.do")
	@CheckActivityHistory(desc="메인 코드 삭제 작업", homeDiv= SettingData.HOMEDIV_ADMIN)
	@Transactional
	public String deleteMainCode(
			@ModelAttribute ("MainCode") MainCode Maincode, 
			@ModelAttribute ("SubCode") SubCode SubCode, 
			Model model) throws Exception {
		
		Component.updateData("Code.MC_delete", Maincode);	
		SubCode.setSC_MC_IN_C(Maincode.getMC_IN_C());
		Component.updateData("Code.SC_deleteCode", SubCode);
		CodeService.setCodeOne(Maincode.getMC_IN_C());
		return "redirect:/dyAdmin/admin/code.do";
	}
			
		
	// 서브코드 삭제 하기 
	@RequestMapping(value = "/dyAdmin/admin/code/sub/deleteAjax.do")
	@CheckActivityHistory(desc="서브 코드 삭제 작업", homeDiv= SettingData.HOMEDIV_ADMIN)
	@ResponseBody
	public void deleteSubCode(
			@ModelAttribute ("SubCode") SubCode Subcode, 
			Model model) throws Exception {
		Subcode = Component.getData("Code.SC_getDetail", Subcode);
		Component.deleteData("Code.ASC_deleteCode", Subcode);
		//메인코드 최근수정일 변경
		Component.updateData("Code.MC_updateDate", Subcode);
		CodeService.setCodeOne(Subcode.getSC_MC_IN_C());
		
	}	
	
	
	
	// 서브코드 수정하기 
	@RequestMapping(value = "/dyAdmin/admin/code/sub/updateAjax.do")
	@CheckActivityHistory(desc="서브 코드 수정 작업", homeDiv= SettingData.HOMEDIV_ADMIN)
	@Transactional
	@ResponseBody
	public void updateSubCode(
		@ModelAttribute ("SubCode") SubCode Subcode,
		Model model) throws Exception {
		SubCode tempSubCode = Component.getData("Code.ASC_getDetail", Subcode);
		int i = Component.getData("Code.ASC_countCODELV", Subcode); 
		
		if(tempSubCode.getSC_CODELV().equals(Subcode.getSC_CODELV())){
			Component.updateData("Code.ASC_updateCode", Subcode);
		}else{
			if( i > 0){
				Component.updateData("Code.ASC_ResetsubCodeLV", Subcode);
			}
			Component.updateData("Code.ASC_updateCode", Subcode);
		}
		//메인코드 최근수정일 변경
		Component.updateData("Code.MC_updateDate", Subcode);
		CodeService.setCodeOne(Subcode.getSC_MC_IN_C());	
	}	
	
	//서브코드 등록하기
	@RequestMapping(value = "/dyAdmin/admin/code/sub/insertAjax.do")
	@CheckActivityHistory(desc="서브 코드 등록 작업", homeDiv= SettingData.HOMEDIV_ADMIN)
	@Transactional
	@ResponseBody
	public void insertSubCode(
		@ModelAttribute ("SubCode") SubCode Subcode,
		Model model) throws Exception {
		
		Subcode.setSC_KEYNO(CommonService.getTableKey("SC"));
		
		int i = Component.getData("Code.ASC_countCODELV", Subcode); 
		
		if( i > 0){
			Component.updateData("Code.ASC_ResetsubCodeLV", Subcode);
				
		}
		Component.updateData("Code.ASC_insertCode", Subcode);
		//메인코드 최근수정일 변경
		Component.updateData("Code.MC_updateDate", Subcode);
		CodeService.setCodeOne(Subcode.getSC_MC_IN_C());
	}
	
	
}
