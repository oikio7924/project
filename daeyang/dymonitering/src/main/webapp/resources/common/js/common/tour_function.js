
var popUpImgSlide;
var popUpImgSlideThum;
function tour_popImg(){
	//팝업 이미지 - 슬라이드 - new
	popUpImgSlide = $('.popSlide-pic').not('.slick-initialized').slick({
		slidesToShow: 1,
		slidesToScroll: 1,
		arrows: false,
		fade: true,
		asNavFor: '.popSlide-thum'
	});
	console.log(popUpImgSlide)
	popUpImgSlideThum = $('.popSlide-thum').not('.slick-initialized').slick({
		asNavFor: '.popSlide-pic',
		slidesToShow: 5,
		slidesToScroll: 1,
		dots: false,
		arrows: false,
		centerMode: true,
		focusOnSelect: true,
		centerPadding: '0'
	});
	
	popUpImgSlideThum.on('click', function(e){
	});
}
function tour_prevCK(type){
	popUpImgSlideThum.slick(type);
	picListThumH();
}
function tour_prevCK2(type){
	popUpImgSlide.slick(type);
	picListThumH();
}

//사진슬라이드 이미지 크기에 맞춰 슬라이드 높이값 조절
function picListThumH() {
	//슬라이드 높이값 조절
	//$('.pic-in-slide').height(parseInt($('.pic-in-slide .slick-active').height()));
	//슬라이드 이미지 마진값으로 가운데 정렬
	var num = $('.popSlide-pic .img-b').height() - $('.popSlide-pic .slick-current .img-b img').height();
	var num2 = num/2;
	$('.popSlide-pic .slick-current .img-b img').css('margin-top',num2);
}


function tour_popOpen(){
	$("#pop_bg_opacity").show();
	$("#receipt_pop_box").show();
	tour_popImg();
}
function tour_popOpen2(){
	$("#pop_bg_opacity, #receipt_pop_box").hide();
}


/******
 * 버스 길찾기
******/
function beforeSearchBusRoute(){
	var startVal = $("#slng_pf").val();
	var endVal = $("#slat_pf").val();


	if(startVal == "" || endVal == ""){
		return false;
	}
	return true;
}
