// JavaScript Document
$(function(){

  // 메인 notice 탭
  tab('.notice-tab',0)

  //메인 캘린더 닫기
  $('.btn-cal-close').on('click',function(){
      $('.main-calendar-wrap').slideUp();
  })    


  // 메인 PC 캘린더 팝업 - 닫기
  $('.ma-cal-list-pop .btn-clo-p').on('click',function(){
      $('.cal-day-ul li').removeClass('active');
      $('.ma-cal-list-pop').hide();
  })

  // 메인 PC 캘린더 팝업 - 나타나기
  $('.cal-day-ul li').on('click',function(){
      $('.cal-day-ul li').removeClass('active');
      $(this).addClass('active');

      var poLeft = $(this).position().left;
      var poLNum = poLeft + 13;

      $('.ma-cal-list-pop').css('left', poLNum).show();
  })



  //특정 스크롤 넘으면 클래스 추가
  var sec5Img = [];
  var sec5Top = [];
  var sec5ImgLen = $('.move').length;

  var scrollTop;
  var sec5Top;

  $(window).load(function(){
      for (var i = 0; i < sec5ImgLen; i++) {
          sec5Img[i] = $('.move').eq(i);
          sec5Top[i] = $('.move').eq(i).offset().top;
      }

      //윈도우 로드시 클래스 추가
      scrollTopAddClass(); 
      
  }).scroll(function(){

      //스크롤시 클래스 추가
      scrollTopAddClass();
  });


  // 브라우저 크기를 넘기면 'on'클래스 추가
  function scrollTopAddClass() {

    scrollTop = $(this).scrollTop();
    var viewGuide = scrollTop+$(window).height()/2; // 브라우저 절반크기에서 클래스 추가

    for (var i = 0; i < sec5ImgLen; i++) {
        if(viewGuide > sec5Top[i]){ sec5Img[i].addClass('on'); }
    }
    
  }


  //2019-12-10

  //수묵비엔날레 돋보기
  //보기
  $('.pamphlet-wrap ul li a').on('click',function(){
    var imgAdd = $(this).find('img').attr('src');
    $('.modal_pamphlet .img-box .img-ph').attr('src',imgAdd);
    $('.modal_pamphlet').css('display','block');
  })

  // 닫기
  $('.modal_pamphlet .btn-close').on('click',function(){
    $('.modal_pamphlet').css('display','none');
  })


  //전시 행사장 탭
  tab('.tab_event_1',0)
  tab('.tab_event_2',0)
  tab('.tab_event_3',0)
  tab('.tab_event_4',0)

  //지도 이미지 보이기 버튼
  $('.btn-map-vw2').on('mouseenter',function(){
      $('.map-in-att-box .img-map-box').css('display','block');
  })
  $('.map-in-att-box').on('mouseleave',function(){
      $('.map-in-att-box .img-map-box').css('display','none');
  })


  // 목포시 
  $('.ul-sigh-1 li').eq(0).addClass('on');
  $('.s-in-con').eq(0).css('display','block');


  $('.name-sight1').on('click',function(){
    $(this).next('.ul-sigh-1').slideDown();
  })

  
  // 목포시 탭부분 제이쿼리
  $('.ul-sigh-1 li').on('click',function(){

    $('.ul-sigh-1 li').removeClass('on');
    $(this).addClass('on');
    var aData = $('.ul-sigh-1 li.on a').html();
    $('.name-sight1').html(aData);
    $('.sight-view-list-box .con-box .tab-con-box .cb p').html(aData);
    $('.ul-sigh-1').slideUp();

    var aId = $(this).attr('data');

    $('.s-in-con').css('display','none');
    $(aId).css('display','block');


    //이전 다음 버튼 누를때
    var nPrev = $(this).index() - 1;
    var nNext = $(this).index() + 1;
    var nAll = $('.ul-sigh-1 li').length;

    if(nPrev < 0) {
      nPrev = nAll - 1;
    }

    if(nNext > ( nAll - 1)) {
      nNext = 0;
    }

    var pName = $('.ul-sigh-1 li').eq(nPrev).html();
    var pData = $('.ul-sigh-1 li').eq(nPrev).attr('data');

    var nName = $('.ul-sigh-1 li').eq(nNext).html();
    var nData = $('.ul-sigh-1 li').eq(nNext).attr('data');

    $('.btn-sigh-mok.prev').html(pName);
    $('.btn-sigh-mok.prev').attr('data',pData);
    $('.btn-sigh-mok.prev').attr('data-num',nPrev);

    $('.btn-sigh-mok.next').html(nName);
    $('.btn-sigh-mok.next').attr('data',nData);
    $('.btn-sigh-mok.next').attr('data-num',nNext);

  })


  //이전버튼 누를때
  $('.btn-sigh-mok.prev').on('click',function(){
    var nData = $(this).attr('data');
    var nName = $(this).html();

    $('.name-sight1').html(nName);
    $('.sight-view-list-box .con-box .tab-con-box .cb p').html(nName);

    var nPrev2 = $(this).attr('data-num');
    var nNext2 = $('.btn-sigh-mok.next').attr('data-num');
    var nAll = $('.ul-sigh-1 li').length;

    $('.ul-sigh-1 li').removeClass('on');
    $('.ul-sigh-1 li').eq(nPrev2).addClass('on');

    $('.s-in-con').css('display','none');
    $(nData).css('display','block');

    nPrev2 = parseInt(nPrev2) - 1;
    nNext2 = parseInt(nNext2) - 1;

    if(nPrev2 < 0) {
      nPrev2 = nAll - 1;
    }

    if(nNext2 < 0) {
      nNext2 = nAll - 1;
    }

    var newName = $('.ul-sigh-1 li').eq(nPrev2).text();
    var newData = $('.ul-sigh-1 li').eq(nPrev2).attr('data');
    $(this).html(newName);
    $(this).attr('data',newData);
    $(this).attr('data-num',nPrev2);

    //다음버튼도 변경
    var newNName = $('.ul-sigh-1 li').eq(nNext2).text();
    var newNData = $('.ul-sigh-1 li').eq(nNext2).attr('data');
    $('.btn-sigh-mok.next').html(newNName);
    $('.btn-sigh-mok.next').attr('data',newNData);
    $('.btn-sigh-mok.next').attr('data-num',nNext2);
  });


  //다음버튼 누를때
  $('.btn-sigh-mok.next').on('click',function(){
    var nData = $(this).attr('data');
    var nName = $(this).html();

    $('.name-sight1').html(nName);
    $('.sight-view-list-box .con-box .tab-con-box .cb p').html(nName);

    var nNext2 = $(this).attr('data-num');
    var nPrev2 = $('.btn-sigh-mok.prev').attr('data-num');
    var nAll = $('.ul-sigh-1 li').length;

    $('.ul-sigh-1 li').removeClass('on');
    $('.ul-sigh-1 li').eq(nNext2).addClass('on');


    $('.s-in-con').css('display','none');
    $(nData).css('display','block');

    nNext2 = parseInt(nNext2) + 1;
    nPrev2 = parseInt(nPrev2) + 1;

    if(nNext2 >= nAll) {
      nNext2 = 0;
    }

    if(nPrev2 >= nAll) {
      nPrev2 = 0;
    }

    var newName = $('.ul-sigh-1 li').eq(nNext2).text();
    var newData = $('.ul-sigh-1 li').eq(nNext2).attr('data');
    $(this).html(newName);
    $(this).attr('data',newData);
    $(this).attr('data-num',nNext2);

    //이전버튼도 변경
    var newPName = $('.ul-sigh-1 li').eq(nPrev2).text();
    var newPData = $('.ul-sigh-1 li').eq(nPrev2).attr('data');
    $('.btn-sigh-mok.prev').html(newPName);
    $('.btn-sigh-mok.prev').attr('data',newPData);
    $('.btn-sigh-mok.prev').attr('data-num',nPrev2);

  });


});




//로그인 회원정보 찾기 팝업 열기
function loginSearchPopShow() {
    $('.sub_login_search_user_pop').show();
}

//로그인 회원정보 찾기 팝업 닫기
function loginSearchPopHide() {
    $('.sub_login_search_user_pop').hide();
}



// 사이트맵 열기
function siteMapShow() {
    $('#siteMap-wrap').fadeIn();
    $('.black-siteMap').fadeIn();
}

// 사이트맵 닫기
function siteMapHide() {
    $('#siteMap-wrap').fadeOut();
    $('.black-siteMap').fadeOut();
}


// 메인 비디오 팝업 열기
function mainVideoPopShow() {
    $('.m-si-prMovie-popUp').fadeIn();
    $('.black-prMovie-pop').fadeIn();
}

// 메인 비디오 팝업 닫기
function mainVideoPopHide() {
    $('.m-si-prMovie-popUp').fadeOut();
    $('.black-prMovie-pop').fadeOut();

    var $prMoAdd = $('.m-si-prMovie-popUp .video-box').find('iframe').attr('src');

    $('.m-si-prMovie-popUp .video-box').find('iframe').attr('src','');
    $('.m-si-prMovie-popUp .video-box').find('iframe').attr('src',$prMoAdd);
}




//스크롤이동
function scollMove(id) {
    $("html, body").stop().animate({
        scrollTop:$(id).offset().top
    },500,"easeInOutCubic")
}



//누르면 페이지 위로 올라감.
function browserTop() {
	$("html, body").stop().animate({
		scrollTop:0
	},500,"easeInOutCubic")
}



//탭부분
function tab(e, num){
    var num = num || 0;
    var menu = $(e).children();
    var con = $(e+'_con').children();
    var select = $(menu).eq(num);
    var i = num;

    select.addClass('active');
    con.hide();
    con.eq(num).show();

    menu.click(function(){
        if(select!==null){
            select.removeClass("active");
            con.eq(i).hide();
        }

        select = $(this);	
        i = $(this).index();

        select.addClass('active');
        con.eq(i).show();
    });
}



/*---------------------------------------------------------------------------------------------------------------------------
 *   Top Zoom Control Function
 *--------------------------------------------------------------------------------------------------------------------------*/

var nowZoom = 100;

function zoomOut() {   // 화면크기축소
   nowZoom = nowZoom - 10;
   if(nowZoom <= 70) nowZoom = 70;   // 화면크기 최대 축소율 70%
   zooms();
}

function zoomIn() {   // 화면크기확대
   nowZoom = nowZoom + 10;
   if(nowZoom >= 200) nowZoom = 200;   // 화면크기 최대 확대율 200%
   zooms();
}

function zoomReset() {
   nowZoom = 100;   // 원래 화면크기로 되돌아가기
   zooms();
}

function zooms() {
   document.body.style.zoom = nowZoom + "%";
   if(nowZoom == 70) {
      alert("더 이상 축소할 수 없습니다.");   // 화면 축소율이 70% 이하일 경우 경고창
   }
   if(nowZoom == 200) {
      alert("더 이상 확대할 수 없습니다.");   // 화면 확대율이 200% 이상일 경우 경고창
   }
}



/*---------------------------------------------------------------------------------------------------------------------------
 *  File Field
 *--------------------------------------------------------------------------------------------------------------------------*/
$(function(){

  var fileTarget = $('.file_upload');

  fileTarget.on('change', function(){
      if(window.FileReader){
          var filename = $(this)[0].files[0].name;
      } else {
          var filename = $(this).val().split('/').pop().split('\\').pop();
      }

      $(this).siblings('.upload_name').val(filename);
  });
    
});