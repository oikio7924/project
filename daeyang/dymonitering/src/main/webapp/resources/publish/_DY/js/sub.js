$(document).ready(function(){
	
	/**************************************
		서브 윗쪽 sns 버튼
	***************************************/
	
	var bCheck = true;	
	$(".snsBox .icon button").on('click',function(){
		
		bCheck = !bCheck;
		var ulWidth = $('.snsBox ul').width() + 15; 
		if(bCheck == true){
			$('.snsBox ul').animate({margin:"0 0px 0 9px;"});				
		} else {
			$('.snsBox ul').animate({margin:"0 -"+ulWidth+"px 0 9px;"});
		}
		
	});
	
	
	/******************************
	안에 탭부분
	*******************************/
	
	$('.circleTapUl li').click(function() {
		setTab($(this).index());
		return false;
		});	  
	  
	var sc = $('.tabCircleContentsWrap');
	var a = $('.circleTapUl li');
	a.eq(0).addClass('active');
	sc.hide();
	sc.eq(0).show();
	function setTab(what) {
		sc.hide();
		sc.eq(what).show();
		a.removeClass('active');
		a.eq(what).addClass('active');
	}; 
	
	
	//게시판 기존 본문 이미지 url 변경 처리
	/*$('.boardDetailViewBox img').each(function(){
		var src = $(this).attr('src').replace('http://www.gjcf.or.kr','');
		$(this).attr('src',src);
	})*/
	
	
});

