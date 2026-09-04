<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>


<script>
var boardCalendarCk = false;
var date = new Date();
var d = date.getDate();
var m = date.getMonth();
var y = date.getFullYear();

$(function(){
	
	if('${BoardType.BT_CALENDAR_YN}' == 'Y') boardCalendarCk = true;
	
	if(boardCalendarCk){
		setDateTitle('default');
		settingCalendar();
	}
	
	var searchCondition ='${BoardNotice.searchCondition}'
	if(searchCondition){
		$('#searchCondition').val('${BoardNotice.searchCondition}');
		$('#searchKeyword').val('${BoardNotice.searchKeyword}');
		$('#orderCondition').val('${BoardNotice.orderCondition}');
	}
	if(keywordList){
		$('#searchKeyword').autocomplete({
			source: keywordList,
			focus: function( event, ui ) {
				return false; 
			}
		});
	}
	
})
//페이지 이동
function pf_LinkPage(num){
	
	$('#Form').attr('action',location.pathname + pf_getParams(num) )
	$('#Form').submit();
}

function pf_getParams(num){
	num = num || 1;
	
	var params =  '?pageIndex='+num;
	if('${category}'){
		params += '&category=${category}';
	}
	
	return params;
}

//검색
function pf_boardSearch(){
	pf_LinkPage(1);
}

//상세보기
function pf_DetailMove(bn_keyno){
	var read = '${boardAuthList.read}';
	
	if(read == 'false'){
		alert('접근권한이 없습니다. 로그인을 하시거나 접근권한을 확인하세요.')
		return false;
	}
	$('#Form').attr('action','${tilesUrl}/Board/'+bn_keyno+'/detailView.do'+ pf_getParams('${paginationInfo.currentPageNo}'));
	$('#Form').submit();
}
function pf_NotMyContents(){
	alert('비밀글 입니다.')	
}

//게시글 삭제
function pf_deleteMove(bnkey, fmkey, thumb){
	if(confirm("삭제 하시겠습니까?")== true){
			$('#BN_KEYNO').val(bnkey)
			$('#BN_FM_KEYNO').val(fmkey)
			$('#BN_THUMBNAIL').val(thumb)
		if('${BoardType.BT_DEL_MANAGE_YN}' == 'Y' && '${BoardType.BT_DEL_POLICY}' == 'L'){
			$('#Form').attr('action','${tilesUrl}/Board/'+bnkey+'/deleteView.do');
		}else{
			$("#Form").attr("action", '${tilesUrl }/Board/delete.do');
		}
			$('#Form').submit();
	}
}
//게시글 수정 페이지로 이동
function pf_UpdateMove(bnkey){
	$('#BN_KEYNO').val(bnkey)
	$("#Form").attr("action", '${tilesUrl }/BoardData/actionView.do');
	$("#Form").submit();
}

//글쓰기
function pf_RegistMove() {
	var write = '${boardAuthList.write}';

	if(write == 'false'){
		if(!cf_checkLogin()){
			return false;
		}
		alert('글쓰기 권한이 없습니다. 관리자한테 문의하세요.');
		return false;
	}
	
	$("#Form").attr("action", "${tilesUrl }/BoardData/actionView.do");
	$("#Form").submit();
}

//비밀번호 창 open
function pf_openPWD(bnkey){
	$('#pwdBN_KEYNO').val(bnkey);
	$('#board_pwd_confirm').fadeIn();
	$('#pwdBN_PWD').focus();
}

//비밀번호 창 close
function pf_closePwd(){
	$('#board_pwd_confirm').fadeOut();
}

//비밀번호 확인
function pf_checkPwd(){
	if(!$('#pwdBN_PWD').val()){
		alert('비밀번호를 입력하여주세요.')
		$('#pwdBN_PWD').focus();
		return false;
	}
	
	$.ajax({
	    type   : "post",
	    url    : "${tilesUrl }/Board/checkPwdAjax.do",
	    data   : $('#pwdForm').serializeArray(),
	    success:function(data){
	    	if(data){
	    		$('#BN_PWD').val($('#pwdBN_PWD').val())
	    		$('#Form').attr('action','${tilesUrl}/Board/'+$('#pwdBN_KEYNO').val()+'/detailView.do');
	    		$('#Form').submit();
	    	}else{
	    		alert('비밀번호를 확인하여주세요.')
	    	}
	    },
	    error: function(jqXHR, textStatus, exception) {
	    	cf_loading_out();
	    	alert('error: '+textStatus+": "+exception);
	    }
	});
}

//게시물 이동
function pf_moveBoardData(key){
	$('#Form').attr('action','${tilesUrl}/Board/'+key+'/moveView.do');
	$('#Form').submit();
}

	
//카테고리 이동
function pf_moveCategory(num){	
	if(num){
		location.href = location.pathname+"?category="+num;
	}else{
		location.href = location.pathname
	}
	
}

////////////캘린더형일 경우에 사용////////////////
function settingCalendar(){
	
	$('#calendar').fullCalendar({
		
        header: {
			left: '',			        	
        	center: '',
	        right: ''
	    },
	    height: "auto",
	    lang:"ko",
	    selectable: true,
	  	select: function(start, end, allDay) {
			$('#fc_create').click();
	
			started = start;
			ended = end;
	
			$(".antosubmit").on("click", function() {
			  var title = $("#title").val();
			  if (end) {
				ended = end;
			  }
	
			  categoryClass = $("#event_type").val();
	
			  if (title) {
				calendar.fullCalendar('renderEvent', {
					title: title,
					start: started,
					end: end,
					allDay: allDay
				  },
				  true // make the event "stick"
				);
			  }
	
			  $('#title').val('');
	
			  calendar.fullCalendar('unselect');
	
			  $('.antoclose').click();
	
			  return false;
			});
		},
        events: function(start, end, timezone, callback){
        	var options = "&start="+start.unix()+"&end="+end.unix();
            //이벤트 리스트
        	callback(getEvents(options));
        },
        eventRender: function(event, element) {
            if(event.className[0] == 'holiday'){
            	$day = $('.fc-day-top[data-date='+event.start._i+']');
            	$day.addClass('fc-holiday');
            	$day.find('.fc-day-number').after('<span class="fc-day-title">'+event.title+'</span>')
            	return false;
            } 
        },
        
        eventClick: function(calEvent, jsEvent, view) {
        	/* var detailNumber = calEvent.className[0].replace('detail-','');
        	pf_DetailMove(detailNumber) */
        	
        	$('#fc_edit').click();
			$('#title2').val(calEvent.title);

			categoryClass = $("#event_type").val();

			$(".antosubmit2").on("click", function() {
			  calEvent.title = $("#title2").val();

			  calendar.fullCalendar('updateEvent', calEvent);
			  $('.antoclose2').click();
			});

			calendar.fullCalendar('unselect');
        },
        editable: true,
        eventMouseover: function(event, jsEvent, view){
	       // $(this).css("color", "green")
        },
      	eventMouseout: function(event, jsEvent, view){
	       // $(this).css("color", "white")
      	}/* ,events: [{
			title: 'All Day Event',
			start: new Date(y, m, 1)
		  }, {
			title: 'ㅋㅋ',
			start: '2021-08-05',
			end: '2021-08-10'
		  }, {
			title: 'Meeting',
			start: new Date(y, m, d, 10, 30),
			allDay: false
		  }, {
			title: 'Lunch',
			start: new Date(y, m, d + 14, 12, 0),
			end: new Date(y, m, d, 14, 0),
			allDay: false
		  }, {
			title: 'Click for Google',
			start: new Date(y, m, 28),
			end: new Date(y, m, 29),
			url: 'http://google.com/'
		  }] */
    });
	
    $('#prevYear').click(function(){
    	y -= 1;
    	setDateTitle();
    })
    $('#prevMonth').click(function(){
    	if(m == 0){
    		m = 11;
    		y -= 1;
    	}else{
	    	m -= 1;
    	}
    	setDateTitle();
    })
    $('#nextYear').click(function(){
    	y += 1;
    	setDateTitle();
    })
    $('#nextMonth').click(function(){
    	if(m == 11){
    		m = 0;
    		y += 1;
    	}else{
	    	m += 1;
    	}
    	setDateTitle();
    })
}

function setDateTitle(type){
	
	if(type == undefined){
		$('#calendar').fullCalendar('gotoDate',new Date(y,m));
	}
	var mString = (m+1)+ '';
	
	console.log(mString);
	
	$('.date_box').text(y+"."+ ( mString.length == 1 ? '0'+mString:mString ) )
}


function getEvents(options){
	
	var events = [];
	$.ajax({
		type: "POST",
		url: "/common/Board/main/viewAjax.do",
		data: "MN_KEYNO=${menu.MN_KEYNO}"+options,
		async:false,
		success : function(result){
			var eventList = result.eventList;
			
			$.each(eventList,function(i){
				var endDate = new Date(eventList[i].BN_ENDT);
				endDate.setDate(endDate.getDate()+1)
				
				events.push({
                       title: eventList[i].BN_NAME,
                       start: eventList[i].BN_STDT,
                       end: endDate.format(),
                       allDay:true,
//                        className: 'detail-'+Number(eventList[i].BN_KEYNO.substring(5,20))
                       /*, backgroundColor: '#b8e096' */
                   });
			})
			var holidayList = result.holidayList;
			$.each(holidayList,function(i){
				events.push({
                       title: holidayList[i].THM_NAME,
                       start: holidayList[i].THM_DATE,
                       allDay:true,
//                        className: "holiday"
                       /* , rendering:'background'
                       , backgroundColor: 'gray' */ 
                   });
			})
		},
		error: function(){
			alert('알수없는 에러 발생. 관리자한테 문의하세요.')
			return false;
		}
	});
	return events;
}

function selectBoardList(keyno){
	pf_LinkPage(1)
}

</script>