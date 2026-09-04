package com.tx.dyAdmin.admin.ipfilter.service;

import java.util.ArrayList;

/**
 * IP 체크 기본 노드
 * @author 이재령
 *
 */
public class NumberNode {
	
	NumberNode parent;
	ArrayList<NumberNode> child;
	String number;
	int lv;
	
	public NumberNode(NumberNode parent,String number){
		this.parent = parent;
		this.number = number;
		child = new ArrayList<NumberNode>();
		if(parent == null){
			lv = 0;
		}else{
			lv = parent.lv + 1;
		}
		
	}
	
	/**
	 * 해당 넘버를 가지고 있는 child 노드를 리턴
	 * @param number
	 * @return
	 */
	public NumberNode getChild(String number){
		for(NumberNode n : child){
			if(lv == 3 && n.number.equals("*")){
				return n;
			}else{
				if(n.number.equals(number)){
					return n;
				}
			}
		}
		return null;
	}
	
	/**
	 * 자식노드 추가 하고 추가한 노드 리턴
	 * @param node
	 * @return
	 */
	public NumberNode addChild(String number){
		
		NumberNode c = new NumberNode(this, number);
		if(number.equals("*")){
			for(NumberNode n1 : child) {
				for(NumberNode n2 : n1.child) {
					n2.parent = c;
				}
			}
			child.clear();
			
		}
		child.add(c);
		
		return c;
	}
	
	
	
}
