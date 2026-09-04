package com.tx.dyAdmin.homepage.organization.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.dyAdmin.homepage.organization.dto.OrganTree;
import com.tx.dyAdmin.homepage.organization.service.OrganizationService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**글 조직도용 데이터포멧에 맞게 작성
 * @author gwp
 *
 */
@Service("OrganizationService")
public class OrganizationServiceImpl extends EgovAbstractServiceImpl implements OrganizationService {
	/** 공통 컴포넌트 */
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;
	
	private String id = "org";
	
	@Override
	public String doStartTagInternal(String DN_HOMEDIV_C) throws Exception {

		StringBuffer sb = new StringBuffer();

		// 여기서부터 바로 printChildren 시작해도 되나
		// 입력 받은 id 를 적용하기 위해 한번 돌림
		sb.append("<ul id=\"");
		sb.append(id);
		sb.append("\">");

		List<OrganTree> roots = getRoots(DN_HOMEDIV_C);
		for (OrganTree pt : roots) {
			sb.append("<li id=\"");
			sb.append(CommonService.setKeyno(pt.getDN_KEYNO()));
			sb.append("\">");
			sb.append(pt.getDN_NAME());
			if(pt.getChildren().size() > 0){
				sb.append("<ul>");
				printChildren(sb, pt.getChildren());
				sb.append("</ul>");
			}
			sb.append("</li>");
		}

		sb.append("</ul>");


		return sb.toString();
	}

	// 재귀
	private void printChildren(StringBuffer sb, List<OrganTree> children) {
		for (OrganTree pt : children) {
			sb.append("<li id=\"");
			sb.append(CommonService.setKeyno(pt.getDN_KEYNO()));
			sb.append("\">");
			sb.append(pt.getDN_NAME());
			if(pt.getChildren().size() > 0){
				sb.append("<ul>");
				printChildren(sb, pt.getChildren());
				sb.append("</ul>");
			}
			sb.append("</li>");
		}
	}
	
	private List<OrganTree> getRoots(String DN_HOMEDIV_C) {
		OrganTree OrganTree = new OrganTree();
		
		OrganTree.setDN_HOMEDIV_C(DN_HOMEDIV_C);
		List<OrganTree> roots = Component.getList("Organization.DN_getRoot", OrganTree);
		for (OrganTree pt : roots) {
			findChildren(pt);
		}
		
		return roots;
	}

	// 재귀
	private void findChildren(OrganTree pt) {
		List<OrganTree> children = Component.getList("Organization.DN_getChild",pt.getDN_KEYNO());
		pt.setChildren(children);
		
		for (OrganTree c : pt.getChildren()) {
			findChildren(c);
		}
	}
	
	/**
	 * 
	 * 조직도 리스트 가져오기
	 * */
	public List<HashMap<String, Object>> getOrganList(String MN_HOMEDIV_C) throws Exception {
		
		List<HashMap<String, Object>> organList = Component.getList("Organization.DN_getOrganAllList", MN_HOMEDIV_C);
		
		List<HashMap<String, Object>> resultList = new ArrayList<HashMap<String, Object>>();
		
		getChild("DN_0000000000", resultList, organList, 0);
		
		return resultList;
	}
	
	private void getChild(String mainKey, List<HashMap<String, Object>> resultList, List<HashMap<String, Object>> organList, int depth) {
		
		for(HashMap<String, Object> organ : organList){
			if(organ.get("MAINKEY") != null){
				if(mainKey.equals(organ.get("MAINKEY").toString())){
					int Lev = Integer.parseInt(organ.get("DN_LEV").toString());
					String childCnt = organ.get("CHILD_CNT").toString();
					if((Integer.parseInt(childCnt) > 0)|| (Integer.parseInt(childCnt) == 0 && Lev == 1)){
						depth += 1;
					}
					if((Integer.parseInt(childCnt) > 0 && Lev != 1 )){
						depth -= 1;					
					}
					organ.put("DN_DEPTH", depth);
					resultList.add(organ);
					if(Integer.parseInt(childCnt) > 0){
						getChild(organ.get("DN_KEYNO").toString(), resultList, organList, depth);
				}
			}
			}
		}
	}
}
