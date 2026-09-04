package com.tx.dyAdmin.power.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.tx.common.config.annotation.CheckActivityHistory;
import com.tx.common.dto.Common;
import com.tx.common.security.password.MyPasswordEncoder;
import com.tx.common.security.rsa.service.RsaService;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.service.page.PageAccess;
import com.tx.common.service.weakness.WeaknessService;
import com.tx.dyAdmin.admin.code.service.CodeService;
import com.tx.dyAdmin.member.dto.UserDTO;
import com.tx.dyAdmin.power.dto.PowerDTO;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
public class AdminPowerController {

	
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	
	/** 암호화 */
	@Autowired MyPasswordEncoder passwordEncoder;
	
	/** RSA */
	@Autowired RsaService RsaService;
	
	/** 페이지 처리 출 */
	@Autowired private PageAccess PageAccess;
	
	@Autowired WeaknessService WeaknessService;
	
	@Autowired CodeService CodeService;

	/**
	 * 발전소 리스트
	 * @param req
	 * @param UserDTO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/powerPlant/view.do")
	@CheckActivityHistory(desc="발전소 등록 리스트")
	public ModelAndView adminPowerView(HttpServletRequest req
			,@ModelAttribute UserDTO UserDTO
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/power/pra_power_list.adm");
		
		mv.addObject("member",Component.getListNoParam("member.UI_USER_SELECT"));
		
		return mv;
	}
	
	/**
	 * 발전소 리스트 - 페이징 ajax
	 * @param req
	 * @param search
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/powerPlant/pagingAjax.do")
	public ModelAndView adminMemberViewPaging(HttpServletRequest req,
			Common search
			) throws Exception {
		
		ModelAndView mv  = new ModelAndView("/dyAdmin/power/pra_power_list_data");

		List<HashMap<String,Object>> searchList = Component.getSearchList(req);
		
		Map<String,Object> map = CommonService.ConverObjectToMap(search);
		
		if(searchList != null){
			map.put("searchList", searchList);
		}
		
		PaginationInfo pageInfo = PageAccess.getPagInfo(search.getPageIndex(),"power.Pw_getListCnt",map, search.getPageUnit(), 10);
		
		map.put("firstIndex", pageInfo.getFirstRecordIndex());
		map.put("lastIndex", pageInfo.getLastRecordIndex());
		map.put("recordCountPerPage", pageInfo.getRecordCountPerPage());
		
		mv.addObject("paginationInfo", pageInfo);
		
		List<HashMap<String,Object>> resultList = Component.getList("power.Pw_getList", map); 
		mv.addObject("resultList", resultList);
		mv.addObject("search", search);
		return mv;
	}
		
	/**
	 * 발전소 excel
	 * @param req
	 * @param res
	 * @param search
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/dyAdmin/powerPlant/excelAjax.do")
	public ModelAndView adminPowerExcelAjax(HttpServletRequest req
			, HttpServletResponse res
			, Common search
			) throws Exception {
		ModelAndView mv  = new ModelAndView("/dyAdmin/power/excel/pra_power_list_excel");
		
		List<HashMap<String,Object>> searchList = Component.getSearchList(req);
		
		Map<String,Object> map = CommonService.ConverObjectToMap(search);
		
		if(searchList != null){
			map.put("searchList", searchList);
		}
		
		List<HashMap<String,Object>> resultList = Component.getList("power.Pw_getList", map); 
		mv.addObject("resultList", resultList);
		mv.addObject("search", search);
		
		try {
            
			Cookie cookie = new Cookie("fileDownload", "true");
	        cookie.setPath("/");
	        res.addCookie(cookie);
            
        } catch (Exception e) {
            System.out.println("쿠키 에러 :: "+e.getMessage());
        }
		return mv;
		
	}
	
	
	/**
	 * 발전소 등록
	 * 
	 */
	@RequestMapping(value="/dyAdmin/powerPlant/Inverter_insert.do")
	@ResponseBody
	public void IveterInsert(HttpServletRequest req, PowerDTO pwdto) throws Exception {
		Component.createData("power.Pw_insert", pwdto);
		ChangeSN(pwdto);
	}
	
	/**
	 * 발전소 수정
	 * 
	 */
	@RequestMapping(value="/dyAdmin/powerPlant/Inverter_update.do")
	@ResponseBody
	public void IveterUpdate(HttpServletRequest req, PowerDTO pwdto) throws Exception {
		Component.updateData("power.Pw_update", pwdto);
		ChangeSN(pwdto);
	}
	
	/**
	 * 발전소 데이터 가져요기
	 * 
	 */
	@RequestMapping(value="/dyAdmin/powerPlant/Inverter_data.do")
	@ResponseBody
	public PowerDTO IveterDetail(HttpServletRequest req, PowerDTO pwdto) throws Exception {
		
		pwdto = Component.getData("power.Pw_getData", pwdto);
		return pwdto;
	}
	
	
	public void ChangeSN( PowerDTO power) throws Exception {
		
		if(power != null) {
			if(power.getDPP_SN() != null) {
				String[] list = power.getDPP_SN().toString().split(",");
				int firstNum = 151;
				String str = "";
				ArrayList<String> Stringlist = new ArrayList<String>();
				
				for(int j=0;j<list.length;j++) {
					String finall = "AA55807F000111";
					String l = list[j];
					String temp = "";
					
					/*if(j == 0) {
						firstNum = Integer.parseInt((l.substring(l.length()-4,l.length())),16);
						firstNum = Integer.parseInt(Integer.toString(firstNum),16);
					}*/
					
					int num = 0;
					for(int i = 0;i<l.length();i++) {
						temp += Integer.toHexString((int)l.charAt(i));
						if( i < 4 || (7 < i && i < 11) || (11< i && i <16)) {
							num += Integer.parseInt(Integer.toHexString((int)l.charAt(i)));
						}
					}
					finall += temp + "0"+ (j+1) + "05";
					finall += Integer.toHexString(num+ (j+1)-firstNum);
					Stringlist.add(finall);
				}
				str = StringUtils.join(Stringlist, ",");
				power.setDPP_SN_NUM(str);
				Component.getData("power.Pw_SN_update", power);
			}
		}
	}
	
}
