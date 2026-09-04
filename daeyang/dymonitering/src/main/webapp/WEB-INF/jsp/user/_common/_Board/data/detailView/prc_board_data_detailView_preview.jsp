<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<style>

/**** 갤러리 팝업 ****/
/*검정배경*/
.pic-pop-black {display:none; position: fixed; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.7); z-index: 5055;} 


.picture-popUp1 {display:none; width: 1250px; position: absolute; left: 50%; margin-left:-625px; top: 5%; z-index: 5060; background-color: #1e2430; border:7px solid #aaa;}

.picture-popUp1 .top {width: 100%; background-color: #273856; height: 83px;}
.picture-popUp1 .top:after { visibility: hidden;display:block;font-size: 0;content:".";clear: both;height: 0;*zoom:1;}
.picture-popUp1 .top .lb {float: left; padding: 27px 0 0 30px;}
.picture-popUp1 .top .rb {float: right; padding: 17px 30px 0 0;}
.picture-popUp1 .logo {display: inline-block; vertical-align: middle; padding-right: 16px; border-right:1px solid #666;}
.picture-popUp1 .sbj-box {display: inline-block; vertical-align: middle; padding-left: 16px;}
.picture-popUp1 .sbj-box h2 {font-size: 24px; font-weight: 500; color: #fff;}
.picture-popUp1 .btn-close i {font-size: 50px; color: #fff;}

.picture-popUp1 .slide-con {padding: 55px 0 45px;}
.picture-popUp1 .gallery-pop {width: 90%; margin:0 auto; position: relative; overflow:hidden;}
.picture-popUp1 .btn {position: absolute; top: 45%; z-index: 500;}
.picture-popUp1 .btn.sw-prev {left: 50px;}
.picture-popUp1 .btn.sw-next {right: 50px;}
.picture-popUp1 .gallery-pop .img-b {text-align: center;}
.picture-popUp1 .gallery-pop .img-b img {max-width: 100%;}
.picture-popUp1 .gallery-pop .txt-b {padding:20px 100px 0 0;}
.picture-popUp1 .gallery-pop .txt-b .name {font-size: 18px; font-weight: 500; color: #fff; letter-spacing: -0.02em;}
.picture-popUp1 .slide-con .ga-pop-page {position: absolute; right: 0; bottom: 0; color: #fff; text-align: right; font-size: 16px; padding-right: 5px; color: #aaa;}
.picture-popUp1 .slide-con .ga-pop-page .swiper-pagination-current {font-weight: 600; color: #fff;}

.picture-popUp1 .slide-thum {padding: 0 10px; margin-bottom: 15px; position: relative;}
.picture-popUp1 .slide-thum .btn {position: absolute; top: 40%; width: 30px; height: 30px; background-color: rgba(0, 0, 0, 0.8); text-align: center;}
.picture-popUp1 .slide-thum .btn.swt-prev {left: 10px; padding-right: 3px;}
.picture-popUp1 .slide-thum .btn.swt-next {right: 10px; padding-left: 3px;}
.picture-popUp1 .gallery-pop-thumbs {width: 100%; height: 190px;}
.picture-popUp1 .gallery-pop-thumbs .swiper-wrapper {height: 100%;}
.picture-popUp1 .gallery-pop-thumbs .swiper-wrapper .swiper-slide {height: 100%; background-size: cover; background-position: center center;}
.picture-popUp1 .gallery-pop-thumbs .swiper-wrapper .swiper-slide-thumb-active {border:3px solid #0b64ae;}

.imgViewer { overflow-y:auto; height: 100%;}

.center {text-align: center; font-size: 2em; color: #fff; position:absolute; top:230px; left:250px;}
#viewer{position:relative; }

@media screen and (max-width:1250px){
	.picture-popUp1 {width: 95%; left: 2.5%; margin-left:0;}

	.picture-popUp1 .slide-con {padding: 55px 70px 45px;}
	.picture-popUp1 .gallery-pop {width: 100%;}
	.picture-popUp1 .btn {}
	.picture-popUp1 .btn.sw-prev {left: 10px;}
	.picture-popUp1 .btn.sw-next {right: 10px;}
}



@media screen and (max-width:999px){
	.picture-popUp1 {width: 95%; left: 2.5%; margin-left:0; border-width: 3px;position:fixed}

	.picture-popUp1 .top {height: 60px;}
	.picture-popUp1 .top .lb {float: left; padding: 20px 0 0 15px;}
	.picture-popUp1 .top .rb {float: right; padding: 15px 15px 0 0;}
	.picture-popUp1 .logo {padding-right: 10px;}
	.picture-popUp1 .logo img {width: 90px;}
	.picture-popUp1 .sbj-box {padding-left: 5px;}
	.picture-popUp1 .sbj-box h2 {font-size: 15px;}
	.picture-popUp1 .btn-close {}
	.picture-popUp1 .btn-close i {font-size: 30px;}

	.picture-popUp1 .slide-con {padding: 30px 50px 20px;}
	.picture-popUp1 .gallery-pop {width: 100%;}
	.picture-popUp1 .slide-con .btn {top: 40%;}
	.picture-popUp1 .slide-con .btn.sw-prev {left: 10px;}
	.picture-popUp1 .slide-con .btn.sw-next {right: 10px;}
	.picture-popUp1 .slide-con .btn img {width: 30px;}
	.picture-popUp1 .gallery-pop .txt-b {padding:10px 50px 0 0;}
	.picture-popUp1 .gallery-pop .txt-b .name {font-size: 13px;}
	.picture-popUp1 .slide-con .ga-pop-page {font-size: 13px;}

	.picture-popUp1 .slide-thum {padding: 0 5px; margin-bottom: 10px;}
	.picture-popUp1 .slide-thum .btn {top: 40%; width: 20px; height: 20px; padding-top: 5px;}
	.picture-popUp1 .slide-thum .btn img {width: 6px;}
	.picture-popUp1 .slide-thum .btn.swt-prev {left: 5px; }
	.picture-popUp1 .slide-thum .btn.swt-next {right: 5px;}
	.picture-popUp1 .gallery-pop-thumbs {height: 100px;}

</style>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
<!-- 서브페이지 - 사진 팝업 -->
<div class="picture-popUp1">
	<div class="top"> <!-- top -->
		<div class="lb">
			<div class="sbj-box">
				<h2>미리보기</h2>
			</div>
		</div>
		<div class="rb">
		
				<button type="button" class="btn-close openDoor" title="새창열기" >
					<i class="xi-plus"></i>
				</button>
			
			<button type="button" class="btn-close" title="닫기" onclick="galleryPopHide()">
				<i class="xi-close-thin"></i>
			</button>
		</div>
	</div>

	<div class="slide-con"> <!-- 슬라이드 박스 -->
		<div class="wiper-container gallery-pop"> <!-- 슬라이드 -->
			<div class="txt-b center">미리보기 파일을 불러오는 중입니다. <br>로딩이 오래걸리면 미리보기를 다시 눌러주세요. </div>
			<div class="swiper-wrapper" style="height:600px;">

			</div>
			<div class="ga-pop-page"></div>
		</div>
	</div>

</div>
<div class="pic-pop-black" onclick="galleryPopHide()"></div>
<!-- 서브페이지 - 사진 팝업 끝!!!! -->

<script>


$(function(){
	$('.picture-popUp1').appendTo('.sub-in-content');
});


//이미지 슬라이드 사라지기
function galleryPopHide() {
    $('.pic-pop-black').fadeOut();
    $('.picture-popUp1').hide();
}

function load() {
	$('.center').hide();
}

</script>
</script>
