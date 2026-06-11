package com.tx.common.service.checkPersonal;

import org.codehaus.plexus.util.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.tx.common.config.SettingData;
import com.tx.common.config.annotation.CheckActivityHistory;
import com.tx.common.security.password.MyPasswordEncoder;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.dyAdmin.admin.board.dto.BoardPersonal;
import com.tx.dyAdmin.admin.board.dto.BoardType;
import com.tx.dyAdmin.admin.board.service.PersonalfilterService;

@Controller
public class PersonalController {
	/** 공통 컴포넌트 */
	@Autowired
	ComponentService Component;
	@Autowired
	CommonService CommonService;

	/** 암호화 */
	@Autowired
	MyPasswordEncoder passwordEncoder;

	/** 내용에서 개인정보보안 */
	@Autowired
	PersonalfilterService PersonalService;

	
	
	
	
	/**
	 * 개인정보보안
	 * 
	 * @param BN_CONTENTS
	 * @param BT_PERSONAL
	 * @return
	 * @throws Exception
	 */
	
	@RequestMapping(value = "/common/Board/data/checkPersonalAjax.do")
	@CheckActivityHistory(type = "hashmap", homeDiv = SettingData.HOMEDIV_ADMIN)
	@ResponseBody
	public BoardPersonal BoardDataPersonal(@RequestParam(value= "BN_CONTENTS", required=false) String BN_CONTENTS,
			@RequestParam(value ="BT_KEYNO" ) String BT_KEYNO
			) {
		//key 
		BoardPersonal boardPersonal = new BoardPersonal();
		BoardType BoardType = Component.getData("BoardType.BT_getData",BT_KEYNO);
		//key로 데이터 가져와서 값있을때만 로직타세요
			if(StringUtils.isNotEmpty(BoardType.getBT_PERSONAL()) && !BoardType.getBT_PERSONAL().equals(null)) {
			 boardPersonal = PersonalService.PersonalfilterCheck(BN_CONTENTS,BoardType.getBT_PERSONAL());
			}else {
			 boardPersonal.setResultBoolean(true);
			}
		return boardPersonal;
	}
	
}
