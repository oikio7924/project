var getDate = "";
var ConversionDate = "";
//일정 넣기
function insertSchedule(day, txt){
  var schedule = $('<li>').addClass('tronixSchedules').html(txt);
  var schedules = $('<ul>').append(schedule); //스케쥴 세팅
  $('#tronix'+day).append(schedules); // 해당 날짜에 스케쥴 붙이기
}

//이전달 보기
function prevMonth(){
  $('#calendar_div').html('');
  setMonth = setMonth - 1;
  $('#calendar_div').showCalendar(setMonth);
}  

//다음달 보기
function nextMonth(){  
	var tourType = $(".package_tour_box").text();
	var cal = $(".year_month").text().replace(/ /g, '');
	if(tourType == "패키지투어 온라인신청" && cal == "2016.12"	){ //2017년 패키지가 사라질 수 있어서 12월 이후 선택안되도록 조건을 줌
	  return;
	}else {
	  	$('#calendar_div').html('');
	  	setMonth = setMonth + 1;
	  	$('#calendar_div').showCalendar(setMonth);
	}	
}

//이번달의 1일 초기화
$.fn.initCalendar = function(thisMonth){
  this.now = new Date();
  if(ConversionDate != null && ConversionDate != ""){
	  this.now = new Date(ConversionDate);  
  }
  this.now.setDate(1);
  this.now.setMonth(thisMonth - 1);
  return this.now.getMonth();
};

//다음날 날짜 설정하고 오늘 날짜 리턴
$.fn.getDateForCalendar = function(){ 
  var tmpDate = this.now.getDate();
  this.now.setDate(tmpDate + 1);
  return tmpDate;
};

//이번달 리턴
$.fn.getMonth = function(){
  return this.now.getMonth();
};

//요일 리턴
$.fn.getThisDay = function(){
  return this.now.getDay();
};

//전체태그 출력
$.fn.showCalendarTag = function(){
  $(this).append(this.cal);
};

// 월간태그에 주간태그 추가
$.fn.addWeekTag = function(){
  if(this.tr != null){
    $(this.cal).append(this.tr);
    this.tr = null;
  }
};

// 이번달  첫주 빈칸 설정
$.fn.initFristWeekEmptyTag = function(text){
  var weekDateCntForMonth = this.getThisDay(); // 오늘의 요일
  for(var i=0; i < weekDateCntForMonth; i++){
    this.addDateTag();
  }
};

//이번달  마지막주 빈칸 설정
$.fn.initLastWeekEmptyTag = function(text){
  var weekDateCntForMonth = this.getThisDay(); // 오늘의 요일
  if(weekDateCntForMonth > 0){
    for(var i=weekDateCntForMonth; i < 7; i++){
      this.addDateTag();
    }
  }
};

//  전체태그 초기화
$.fn.intCalendarTag = function(){
  
  var sun = $('<th>').attr('scope','col').addClass('tronixTh').addClass('sun').html('일');
  var mon = $('<th>').attr('scope','col').addClass('tronixTh').html('월');
  var tue = $('<th>').attr('scope','col').addClass('tronixTh').html('화');
  var wed = $('<th>').attr('scope','col').addClass('tronixTh').html('수'); 
  var thu = $('<th>').attr('scope','col').addClass('tronixTh').html('목'); 
  var fri = $('<th>').attr('scope','col').addClass('tronixTh').html('금');
  var sat = $('<th>').attr('scope','col').addClass('tronixTh').addClass('sat').html('토');
  
  this.cal = $('<table>').addClass('tronixTable');
  
  this.colTitle = $('<tr>').addClass('colTitle');
  this.thead = $('<thead>').addClass('tronixThead').append(this.colTitle);
  $(this.cal).append(this.thead );
  $(this.cal).append($('<tbody>'));
  $(this.colTitle).append(sun);
  $(this.colTitle).append(mon);
  $(this.colTitle).append(tue);
  $(this.colTitle).append(wed);
  $(this.colTitle).append(thu);
  $(this.colTitle).append(fri);
  $(this.colTitle).append(sat);
};

//주간태그 초기화
$.fn.intWeekTag = function(){
  this.tr = $('<tr>').addClass('tronixTr');
};

//주간태그에 날짜태그 추가
$.fn.addDateTag = function(text){
  if(text == null){
    text = '';
  }     
  this.td = $("<td onclick=\"javascript:if($(this).hasClass(\'clickDay\')) { $(this).removeClass(\'clickDay\'); return; } $(\'.tronixTable\').find(\'td\').removeClass(\'clickDay\'); if($(this).hasClass(\'ticketDay\')) $(this).addClass(\'clickDay\'); \">").addClass('tronixTd').attr('id', 'tronix' + text).html("<span>"+text+"</span>");
  
  if(this.tr != null){
    $(this.tr).append(this.td);
    this.td = null;
  }
};

//월, 달 제목 생성
$.fn.initYearMonthTag = function(){
  if(this.now != null){
    var prevMonth = "<a href='javascript:;' onclick='prevMonth()'><img class='prevMonth' src='/resources/img/calendar/cal_btn_01.png'></a>";
    var nextMonth = "<a href='javascript:;' onclick='nextMonth()'><img class='nextMonth' src='/resources/img/calendar/cal_btn_02.png'></a>";
    var yearMonth = prevMonth + this.now.getFullYear() + '.  ' + (this.now.getMonth() + 1 ) + nextMonth;
    var ftMonth = this.now.getMonth()+1;
    if(parseInt(this.now.getMonth()+1) < 10 ){
    	ftMonth = "0" + ftMonth;
    }
    getDate = this.now.getFullYear() +"-" + ftMonth;
    $('<h3>').addClass('year_month').append(yearMonth).appendTo(this);
  }
};

// 달력 생성
$.fn.showCalendar = function(thisMonth){
  var tmpMonth = this.initCalendar(thisMonth); // 달력 월 초기화
  var weekDateCntForMonth = this.getThisDay(); // 오늘의 요일
  this.initYearMonthTag(); // 년월 출력
  
  this.intCalendarTag(); // 전체 태그 생성
  this.intWeekTag(); // 주간 태그 생성
  this.initFristWeekEmptyTag(); // 첫주의 빈칸 생성
  
  //달력 날짜 생성
  while(tmpMonth == this.getMonth()){
    var tmpdate = this.getDateForCalendar();
    
    if( weekDateCntForMonth != 0 && (weekDateCntForMonth%7) == 0){
      //주가 바뀜
      this.addWeekTag();
      this.intWeekTag();
    }
    this.addDateTag(tmpdate); // 날짜 추가
    
    weekDateCntForMonth++;
  }
  
  //마지막주 빈칸 생성 및 추가
  this.initLastWeekEmptyTag();
  this.addWeekTag();
  
  this.showCalendarTag(); // 달력 출력 

  $('.tronixTd:first-child').find('span').addClass('tronixSunday'); // 일요일 클래스 설정
  $('.tronixTd:last-child').find('span').addClass('tronixSaturday'); // 토요일 클래스 설정
  SetSchedule(getDate);
};

//설정한 달의 마지막 일자 구하기
function lastDay(getDate){ 
   var d, s = "";           
   d = new Date(getDate.split("-")[0],getDate.split("-")[1], "");                      
   s += d.getFullYear()+ "-";                       
   s += (d.getMonth()+1 > 9 ? d.getMonth()+1 : "0" + (d.getMonth()+1)) + "-";            
   s += d.getDate() > 9 ? d.getDate() : "0" + d.getDate();                   
   return(s);                             
}


function dateToString(d){
	var s = '';
	 s += d.getFullYear()+ "-";                       
	   s += (d.getMonth()+1 > 9 ? d.getMonth()+1 : "0" + (d.getMonth()+1)) + "-";            
	   s += d.getDate() > 9 ? d.getDate() : "0" + d.getDate();                   
	   return(s);
}