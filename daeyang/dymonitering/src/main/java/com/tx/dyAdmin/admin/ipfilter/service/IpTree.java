package com.tx.dyAdmin.admin.ipfilter.service;

import java.util.List;

/**
 * IP 체크 트리구조 
 * @author 이재령
 * IP 규칙
 * 1.		1.2.3.4  : 단일
 * 2.		1.2.3.* : 0 ~ 255
 * 3.		*는 네번째 넘버만 가능
 */
public class IpTree {
	
	final static public String delimiter = "\\.";
	
	
	private NumberNode root;
	//private ArrayList
	
	
	public IpTree(List<Object> list) {
		root = new NumberNode(null, "root");
		makeTree(list);
	}
	/**
	 * 트리구조 빌드
	 * @param list
	 */
	private void makeTree(List<Object> list) {
		NumberNode now;
		NumberNode child;
		for(Object i : list){
			String ip = (String)i;
			now = root;
			String ipNumber[] = ip.split(delimiter);
			for(String number : ipNumber){
				child = now.getChild(number);
				if(child == null) child = now.addChild(number);
				now = child;
			}
		}
		
	}
	/**
	 * 노드 추가
	 * @param node
	 */
	public void addTree(String node){
		NumberNode now;
		NumberNode child;
		now = root;
		String ipNumber[] = node.split(delimiter);
		for(String number : ipNumber){
			child = now.getChild(number);
			if(child == null) child = now.addChild(number);
			now = child;
		}
		
	}
	/**
	 * 노드 삭제
	 * @param ip
	 */
	public void removeTree(String node) {
		NumberNode now;
		NumberNode child = null;
		now = root;
		String ipNumber[] = node.split(delimiter);
		for(String number : ipNumber){
			child = now.getChild(number);
			now = child;
		}
		if(now != null){
			NumberNode p = now.parent;
			p.child.remove(child);
		}
	}
	
	/**
	 * 노드 수정
	 * @param ip
	 */
	public void updateTree(String beforeNode, String newNode) {
		
		removeTree(beforeNode);
		addTree(newNode);
	}
	
	public void printTree(){
		printTree(root);
	}
	public void printTree(NumberNode node){
		for(int i=0 ; i < node.child.size();i++){
			
			printTree(node.child.get(i));
		}
	}
	
	public NumberNode getRoot(){
		return root;
	}

	
	
}
