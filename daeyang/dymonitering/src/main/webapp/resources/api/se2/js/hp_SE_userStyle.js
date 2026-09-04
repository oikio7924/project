nhn.husky.SE_userStyle = jindo.$Class({
	name : "SE_userStyle",
	$init : function(elAppContainer) {
		this._assignHTMLObjects(elAppContainer);
	},
	_assignHTMLObjects : function(elAppContainer) {
		this.oDropdownLayer = cssquery.getSingle("DIV.husky_seditor_userStyle_layer", elAppContainer);
		// div 레이어안에 있는 input button을 cssquery로 찾는 부분.
		this.oInputButton = cssquery.getSingle(".se_button_time", elAppContainer);
		
		this.elFontNameLabel = jindo.$$.getSingle("SPAN.husky_se2m_current_userStyle", elAppContainer);
		this.sDefaultText = this.elFontNameLabel.innerHTML;
	},
	$ON_MSG_APP_READY : function() {
		this.oApp.exec("REGISTER_UI_EVENT", [ "userStyle", "click", "SE_TOGGLE_USERSTYPE_LAYER" ]);
		// input button에 click 이벤트를 할당.
		this.oApp.registerBrowserEvent(this.oInputButton, 'click','PASTE_NOW_DATE');
		
		this.oApp.registerBrowserEvent(this.oDropdownLayer, "click", "EVENT_USERSTYLE_LAYER_CLICKED", []);
	},
	$ON_SE_TOGGLE_USERSTYPE_LAYER : function(){
		 this.oApp.exec("TOGGLE_TOOLBAR_ACTIVE_LAYER", [this.oDropdownLayer]);
	},
	
	$ON_EVENT_USERSTYLE_LAYER_CLICKED : function(wev){
		var type = wev.element.innerText;
		
		if(type == '제목'){
			this.oApp.exec("SET_WYSIWYG_STYLE", [{
				"fontSize":"18pt",
				"color":"#414042"
				}]);
		}else if(type == '본문'){
			this.oApp.exec("SET_WYSIWYG_STYLE", [{
				"fontSize":"10pt",
				"color":"#414042"
				}]);
		}
		this.oApp.delayedExec("EXECCOMMAND", ["justifycenter", false, false], 0);
		this.oApp.exec("SET_LINE_STYLE", ["lineHeight", 1.5]);
		this.oApp.exec("SET_FONTFAMILY", ["notokr", ""]);
		this.oApp.exec("HIDE_ACTIVE_LAYER", []);

		this.oApp.exec("CHECK_STYLE_CHANGE", []);
		
		this.elFontNameLabel.innerText = type;
	}
	
});