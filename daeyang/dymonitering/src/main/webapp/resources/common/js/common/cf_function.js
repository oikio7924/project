var token = $("meta[name='_csrf']").attr("content");

$.ajaxSetup({
	  headers: {
	    'X-CSRF-Token': token,
	    'AJAX': true
	  },
	  statusCode :{
		  401 : function() {
			  alert("인증에 실패 했습니다.");
              location.href = "/jcia/index.do"; 
		  },
		  403 : function() {
			  alert("세션이 만료가 되었습니다.");
			  location.href = "/jcia/index.do";  
		  }
	  }
	});


//=======================공유==========================
//페이스북
function facebook(){
	var url = encodeURIComponent(document.URL); 
	window.open("http://www.facebook.com/share.php?u=" + url);
}
//트위터
function twitter(){
	var url = encodeURIComponent(document.URL);
	window.open("https://twitter.com/intent/tweet?url="+url); // text 파라미터 삭제함
}
//밴드
function band(title){
	var url = encodeURIComponent(document.URL);
	window.open("http://www.band.us/plugin/share?body="+encodeURIComponent(title)+encodeURIComponent("\n")+location.href+"&route="+location.href, "share_band", "width=410, height=540, resizable=no");

}
//구글+
function google(){
	var url = encodeURIComponent(document.URL);
	window.open("https://plus.google.com/share?url="+url);
}

//카카오스토리
function cf_kakaoStroryShare2() {
	var url = document.URL;
	Kakao.Story.share({  
	    url: url/*,  
	    text: '${SNSInfo.TITLE }'*/
	});
}

//블로그
function cf_blog(){
	var url = document.URL
	window.open("http://blog.naver.com/openapi/share?url="+url);
}

$(function(){
	// 메인메뉴
	$mainMenu = $('.mainMenuUl > li')
	$mainSubMenu = $('.mainSubMenuUl')
	$subMenuBg = $('.bgSubMenuWrap_01')
	$mainSubMenu_subMenuBg = $('.mainSubMenuUl,.bgSubMenuWrap_01')
	$mainMenu_subMenuBg = $('.mainMenuUl,.bgSubMenuWrap_01')
	
	$mainSubMenu_subMenuBg.hide();
	
	
	$mainMenu_subMenuBg.on('mouseover',function(){
		$mainSubMenu_subMenuBg.stop().slideDown();
	});
	
	$mainMenu_subMenuBg.on('mouseleave',function(){
		$mainSubMenu_subMenuBg.stop().slideUp();
	});
	
	
	$mainMenu.on('mouseover',function(){
		$(this).addClass('active');
	});
	
	$mainMenu.on('mouseleave',function(){
		$(this).removeClass('active');
	});	
		
	
	
	
	//모바일 서브 메뉴
	$('.headerMobileMain .menuIcon button').on('click',function(){		
		$('.mobileMainMenuWrap').show();		
	});
	
	//모바일 서브 메뉴
	$('.mobileMaMenu > li').on('click',function(){	
		$(this).addClass('active');
		var unactive= $('.mobileMaMenu > li').not($(this));
		unactive.removeClass('active');
		$('.mobileSubMenu',unactive).slideUp();		
		$('.mobileSubMenu',this).slideToggle();		
	});
	
	//모바일 서브 닫기버튼
	$('.mobileMenuInnerWrap .closeBtn').on('click',function(){		
		$('.mobileMainMenuWrap').hide();		
	});
	
	// 탭 지정
	tabFucNomal('.mainNoticeTab li','.mainNoticeTabCon');
	
	// 스트롤 탑 버튼
	$('.footerScrollUp').on('click',function(){
        $('html, body').stop().animate({scrollTop : 0},700)
	});
	
	//서브 sns 공유 버튼
	var toggleSnsNum = 1;
	$('.subSnsShareBtn').on('click',function(){
		if(toggleSnsNum == 1){
			$('.subSnsBtnBox').animate({marginRight:'0px'});
			toggleSnsNum = 0;
			$(this).css('color','#005ab1');
		} else {
			//모바일
			if(window.matchMedia('(max-width: 920px)').matches){
				$('.subSnsBtnBox').animate({marginRight:'-90px'});
				toggleSnsNum = 1;
				$(this).css('color','#888');
			} else {
			//PC
				$('.subSnsBtnBox').animate({marginRight:'-110px'});
				toggleSnsNum = 1;
				$(this).css('color','#888');
			}
		}
	});
	
	//개인정보취급방침 - 팝업띄우기
	$('.privacyPopBtn').on('click',function(){
		$('.popUpPrivacyWrap').show();
	});
	
	$('.popUpPrivacyWrap .btnBoard_01').on('click',function(){
		$('.popUpPrivacyWrap').hide();
	});	
	
	
	//이메일무단수집거부 - 팝업띄우기
	$('.emailPopBtn').on('click',function(){
		$('.popUpPrivacyEmailWrap').show();
	});
	
	$('.popUpPrivacyEmailWrap .btnBoard_01').on('click',function(){
		$('.popUpPrivacyEmailWrap').hide();
	});	
	
	
	//저작권정책 - 팝업띄우기
	$('.copyrightPopBtn').on('click',function(){
		$('.popUpCopyrightWrap').show();
	});
	
	$('.popUpCopyrightWrap .btnBoard_01').on('click',function(){
		$('.popUpCopyrightWrap').hide();
	});	
	
	//모바일 통합검색

	$('.headerMobileMain .searchIcon button').on('click',function(){		
		$('.searchHeaderMobileWrap').stop().slideDown();		
	});
	
	$('.searchHeaderMobileWrap .btnCloseSearchMoHeader').on('click',function(){		
		$('.searchHeaderMobileWrap').stop().slideUp();		
	});

});

function pf_search(id){
	if(!$('#'+id).val()){
		alert('검색어를 입력해주세요.');
		$('#'+id).focus();
		return false;
	}
	location.href="/jcia/search.do?searchKeyword="+$('#'+id).val();
}

//탭 부분
var sc = "";
var a = "";

function tabFucNomal(tabTitle,tabContents) {
	init(tabTitle,tabContents);
//	if(window.innerWidth > 120){
		$(tabTitle).on('click',function(){
			setTab($(this).index());
			return false;
		});	
//	}
}


function init(tabTitle,tabContents) {
	sc = $(tabContents);
	a = $(tabTitle);
	a.eq(0).addClass('active');
	sc.hide();
	sc.eq(0).show();	
}


function setTab(what) {
	sc.hide();
	sc.eq(what).fadeIn();
	a.removeClass('active');
	a.eq(what).addClass('active');	
}

function cf_regExp(str){  
    var reg = /[\{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]/gi
    //특수문자 검증
    if(reg.test(str)){
      //특수문자 제거후 리턴
      return str.replace(reg, " ");    
    } else {
      //특수문자가 없으므로 본래 문자 리턴
      return str;
    }  
  }
