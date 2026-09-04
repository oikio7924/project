$(function(){

	//PC 메뉴
    if (matchMedia("screen and (min-width: 1000px)").matches) {
        // 1000px 이상에서 사용할 JavaScript
        $('#gnb ul > li').on('click', function(){
            $('#gnb ul > li').removeClass('on');
            $(this).addClass('on');
    
            menuBar();
        })
    
        menuBar();
    }

    function menuBar(){
        var gnbLiWidth, gnbLipos, number;

        gnbLiWidth = parseInt($('#gnb ul > li.on').css('width'))
        gnbLipos = $('#gnb ul > li.on').offset().left;
    
        number = gnbLipos + gnbLiWidth;
    
        $('.menu_bar').css('width',number);
    }

})






//탭부분
function tab(e, num) {
    var num = num || 0;
    var menu = $(e).children();
    var con = $(e + '_con').children();
    var select = $(menu).eq(num);
    var i = num;

    select.addClass('active');
    con.hide();
    con.eq(num).show();

    menu.click(function () {
        if (select !== null) {
            select.removeClass("active");
            con.eq(i).hide();
        }

        select = $(this);
        i = $(this).index();

        select.addClass('active');
        con.eq(i).show();
    });
}