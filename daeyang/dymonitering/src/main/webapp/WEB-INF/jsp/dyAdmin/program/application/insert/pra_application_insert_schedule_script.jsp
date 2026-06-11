<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script src="/resources/common/js/calendar/TronixCalendar.js"></script>
<link rel="stylesheet" type="text/css" media="screen" href="/resources/common/css/calendar/TronixCalendar.css">
<script src="/resources/common/js/clockpicker/clockpicker.js"></script>
<script>
var ScheduleCnt = 1;
var scheduleList = [];
// var scheduleGroups = new Array();
var Timenumber = 0;
var setMonth = new Date().getMonth() + 1;
//ConversionDate = "2017-1" //달력 오픈 년,월을 지정해야 하는경우 사용. 미사용 시 현재 년월 오픈
function SetSchedule(getDate){
   $(".tronixSchedules").remove();
   $.each(scheduleList,function(i){
      if(!scheduleList[i]){
         return true;
      }
      
      var schedule = scheduleList[i];
      var st_date = schedule.st_date;
      var en_date = schedule.en_date;

      var day = schedule.day;               //반복일
      
      var stEnter = new Date(st_date);       //입력한 시작일
      var enEnter = new Date(en_date);       //입력한 종료일

      var nowStD = new Date(getDate+"-01");   //그 달의 첫날
      
      var lastday = lastDay(getDate);         //마지막일자 및 변수값세팅
      var nowEnD = new Date(lastday);         //그 달의 마지막날
      
      var curDate = new Date();            //현재 날짜
      var current = curDate.getFullYear() +""+ cf_setTwoDigit(curDate.getMonth() + 1)
      
      var Endcurrent = parseInt(current) + 2;   //현재날짜에서부터 3달 후 까지
      
      var index = parseInt(lastday.split("-")[2]); //일 갯수
      for(var i = 1; i <= index; i++){         //루프의 현재 일자 구하기
         var date_num = lastday.split("-")[0] + "" + lastday.split("-")[1]; 
      }

//       var betweenDay = (enEnter.getTime() - stEnter.getTime())/1000/60/60/24 + 1; 
      var betweenDay2 = (nowEnD.getDate() - nowStD.getDate()) + 1; 
      var tempDate = nowStD;
      
      for(var i = 0; i < betweenDay2; i++){
         if(st_date){
            if(stEnter <= tempDate && tempDate <= enEnter){

               var temp = tempDate.getDate();
               var times = schedule.times;

               if(day.length != 0){
                  for(var k = 0; k < day.length; k++){
                     if(day[k] == tempDate.getDay()){
                        pf_scheduleList(temp, times);
                     }
                     
                  }
               }else if(day.length == 0){
                  pf_scheduleList(temp, times);
               }
            }
         }else{
            if(current <= date_num && date_num <= Endcurrent){
               
               var temp = tempDate.getDate();
               var times = schedule.times;
                  
               if(day.length != 0){
                  for(var k = 0; k < day.length; k++){
                     if(day[k] == tempDate.getDay()){
                        pf_scheduleList(temp, times);
                     }
                  }
               }else if(day.length == 0){
                  pf_scheduleList(temp, times);
               }   
            }   
         }
         tempDate.setDate(tempDate.getDate() + 1); 
      }
   });
   
   return false;
}

//스케줄에 표시하기
function pf_scheduleList(temp, times){
var maxinum = $("#AP_LIMIT_PERSON").val();
   $.each(times,function(j){
      
      var tempTime = times[j].st_h
      
      if(times[j].en_h){
         tempTime += " ~ " + times[j].en_h                
      }
      if(times[j].title){
         tempTime += " "+ times[j].title + " ";
      }else{
         tempTime += " 신청가능 ";
      }
      
      if(times[j].cnt){
         tempTime += "(" + times[j].cnt + ")";
      }else{
         tempTime += "(" + maxinum + ")";
      }
      
      insertSchedule(temp,tempTime);   
   });
}

//일정 넣기 함수
function insertSchedule(day, txt){
   if($('#tronix'+day +" ul").length == 0){
      $('#tronix'+day).append('<ul></ul>');
   }
   $ul = $('#tronix'+day +" ul");
   var schedule = $('<li>').addClass('tronixSchedules').text(txt);
   
  $ul.append(schedule); // 해당 날짜에 스케쥴 붙이기
}

//스케줄 없을 때 표시
function pf_blank(){
   var blank = document.getElementById('scheduleList').innerHTML;
   
   if(blank == ''){
      var temp = '<div class="panel panel-default BlankDiv" id="BlankDiv">';
         temp += '<div class="panel-heading" style="padding: 10px;">';
         temp += '<h4 class="panel-title" style="font-weight: bold;">';
         temp += '등록된 예약시간이 없습니다.';
         temp += '</h4></div></div>';
      $("#scheduleList").append(temp);
   }
}


$(function(){
	 setTimeout("$('.clockpicker').clockpicker()", 300);   
   pf_blank();
   
   var now = new Date();
   var today;
   today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
   today = today.getFullYear()+"-"+cf_setTwoDigit(today.getMonth()+1)+"-"+cf_setTwoDigit(today.getDate());
   
   //스케줄 등록 레이어창
   cf_setttingDialog('#scheduleInsert','스케줄 등록','추가','pf_schduleInsert("","", "I")');
   
   $("#calendar_div").showCalendar(setMonth);
   
   //달력 처리       
   $.ui.dialog.prototype._focusTabbable = $.noop;
   
   
   datepickerOption.onSelect = function(selectedDate) {
         $('#end_date').datepicker('option', 'minDate', selectedDate);         
      } 
      $('#start_date').datepicker(datepickerOption)
      
      
      datepickerOption.onSelect = function(selectedDate) {
       $('#start_date').datepicker('option', 'maxDate', selectedDate);
      }
      $('#end_date').datepicker(datepickerOption);
   
   
   <c:if test="${not empty ScheduleMain}">
      <c:forEach items="${ScheduleMain }" var="model" varStatus="index"> 
      
      var schedule = new Object();      
         schedule.st_date = '${model.ASM_STDT }'
         schedule.en_date = '${model.ASM_ENDT }'
         
         var dayTemp = '${model.ASM_DAY }';
         if(dayTemp){
            schedule.day = dayTemp.split(',');
         }else{
            schedule.day = [];
         }
               
         
         var times = [];
         <c:forEach items="${ScheduleSub}" var="model2" varStatus="index2">
         <c:if test='${model.ASM_KEYNO == model2.ASS_ASM_KEYNO}'>
            var time = new Object();
            time.st_h = '${model2.ASS_ST_TIME }'
            time.en_h = '${model2.ASS_EN_TIME }'
            time.cnt = '${model2.ASS_MAXIMUM }'
            time.title = '${model2.ASS_SUBTITLE }'
            
            times.push(time);
         </c:if>
         </c:forEach>
         
         schedule.times = times;
         scheduleList[ScheduleCnt] = schedule;
         
         $scheduleData = $('#scheduleInsert .scheduleInsert').clone();
         
         var stDate = scheduleList[ScheduleCnt].st_date;
         var enDate = scheduleList[ScheduleCnt].en_date;
         
         /* 리스트 버튼 */
         var ListButton =  '<div class="panel panel-default">';
            ListButton += '<div class="panel-heading">';
            ListButton += '<h4 class="panel-title addBtn'+ScheduleCnt+'">';
             ListButton += '<a data-toggle="collapse" data-parent="#scheduleList" href="#collapseOne-'+ScheduleCnt+'" aria-expanded="false" class="collapsed">';
             ListButton += '<i class="fa fa-fw fa-plus-circle txt-color-green"></i> <i class="fa fa-fw fa-minus-circle txt-color-red"></i>';
             
             if(stDate){
                ListButton += '예약일 : ' + stDate + '~' + enDate;                
             }else if(!stDate){
                ListButton += '예약일 ' + '(매일)';         
             }
             
             ListButton += '</a>';
             ListButton += '</h4>';
             ListButton += '</div>';

             ListButton += '<div id="collapseOne-'+ScheduleCnt+'" class="panel-collapse collapse" style="">';
             ListButton += '<div class="panel-body scheduleDataAdd'+ScheduleCnt+'" style="padding: 15px;">';
             
             ListButton += '<div style="text-align:right; margin: 13px;">';
             ListButton += '<button class="btn btn-sm btn-warning" style="margin-left:10px;" type="button" onclick="pf_schduleInsert(this.parentNode, '+ScheduleCnt+' ,\'U\')"><i class="fa fa-plus-circle"></i> 수정</button>';
             ListButton += '<button class="btn btn-sm btn-danger" style="margin-left:10px;" type="button" onclick="pf_scheduleAddDelete(this.parentNode, '+ScheduleCnt+')"><i class="fa fa-trash-o"></i> 삭제</button>';
             ListButton += '</div>';
             ListButton += '</div>'; 
             ListButton += '</div>';
         
         $scheduleData.addClass('add'+ScheduleCnt);
         
         var st_date = schedule.st_date;
         var en_date = schedule.en_date;
          var time = schedule.times;
          
          $scheduleData.find('#start_date').val(st_date);
          $scheduleData.find('#end_date').val(en_date);
         
          $daycheck = $scheduleData.find('input[name=repeat]');
          
          if(dayTemp){
             $scheduleData.find('input[name=repeat]').each(function(){
                if(dayTemp.indexOf($(this).data('number')) != -1){
                   $(this).prop('checked',true);
                }
             });
          }
          
          $.each(time, function(i){
             if(!time[i]){
               return true;
            }
             var timedata = time[i];
             
             var timeTemp = $scheduleData.find('.em_time').eq(i);
             if($(timeTemp).length == 0){
                timeTemp = $scheduleData.find('.em_time').eq(0).clone();      
             }
             
             $(timeTemp).find('.st_hour').val(timedata.st_h);
             $(timeTemp).find('.en_hour').val(timedata.en_h);
             $(timeTemp).find('.changeCnt').val(timedata.cnt);
             $(timeTemp).find('.GSS_SUBTITLE').val(timedata.title);
             $scheduleData.find('.em_time_wrap').append(timeTemp)
             
          });
                
         $scheduleData.find('#start_date').attr('id', "start_date"+ScheduleCnt).removeClass('hasDatepicker');
         $scheduleData.find('#end_date').attr('id', "end_date"+ScheduleCnt).removeClass('hasDatepicker');
         
         $(".BlankDiv").remove();
         $('#scheduleList').append(ListButton);
         $('.scheduleDataAdd'+ScheduleCnt).prepend($scheduleData);
         
         //달력 처리       
         datepickerOption.onSelect = function(selectedDate) {
            $scheduleData.find('.end_date').datepicker('option', 'minDate', selectedDate);
            } 
         $scheduleData.find('.start_date').datepicker(datepickerOption);
         
            datepickerOption.onSelect = function(selectedDate) {
               $scheduleData.find('.start_date').datepicker('option', 'maxDate', selectedDate);
            }
            $scheduleData.find('.end_date').datepicker(datepickerOption);
            
            $scheduleData.find('.end_date').datepicker('option', 'minDate', st_date);
            $scheduleData.find('.start_date').datepicker('option', 'maxDate', en_date);
            
         ScheduleCnt++;
         
       </c:forEach>
         SetSchedule(getDate);
   </c:if>
   
});





//시간 추가
function pf_addTimeContainer(obj){
   
   $timeWrap = $(obj).parents('tr').find('.em_time_wrap');
   $time = $(obj).parents('tr').find('.em_time').eq(0);
   var clone = $time.clone();
   clone.find("input").val("");
   clone.find("#st_hour").attr("id", "st_hour"+Timenumber);
   clone.find("#en_hour").attr("id", "en_hour"+Timenumber);
    $timeWrap.append(clone);
    Timenumber += 1;
  	setTimeout("$('.clockpicker').clockpicker()", 300); 
}

//시간 삭제
function pf_removeTimeContainer(obj){
   $(obj).remove();
}

//추가한 스케줄 삭제
function pf_scheduleAddDelete(obj, num){
   
   if(!pf_applyLimit()){
      return false;
   }
   if(confirm("선택하신 스케줄을 삭제하시겠습니까?")){
      $(obj).parent().parent().parent().remove();
      scheduleList[num] = null;
      pf_blank();
      SetSchedule(getDate);      
   }
}

//스케줄 추가/수정 
function pf_schduleInsert(obj, num, type){
  	setTimeout("$('.clockpicker').clockpicker()", 300);
   if(!pf_applyLimit()){
      return false;
   }
   
   num = num || ScheduleCnt;
   
   if(type == 'I'){
      $obj = $('#scheduleInsert');
   }else{
      $obj = $(obj).parent();   
   }
   
//    $obj.find(".tronixSchedules").remove();
   
   //반복일 선택
   var day = [];
   $obj.find('input[name=repeat]:checked').each(function(i){
      day.push($(this).data('number'));
   });
   
   
   var start_date = $obj.find(".start_date").val();
   var end_date = $obj.find(".end_date").val();
   
   if(!end_date){
      alert("종료일자를 선택해주세요.");
      return false;
   }else if(!start_date){
      alert("시작일자를 선택해주세요.");
      return false;
   }
   
   var value_check = true;
   $obj.find(".em_time").each(function(index){
   var st_h = $(".st_hour", this).val();
   var en_h = $(".en_hour", this).val();
      if(!st_h){
         alert("시작 시간을 선택해주세요.");
         value_check = false;
         
         return false;
      }
   });
   if(!value_check){
      return false;
   }
   
   var schedule = new Object(); //객체생성
   
   $st_date = $obj.find(".start_date").val();
   $en_date = $obj.find(".end_date").val();
   
   schedule.st_date = $st_date;
   schedule.en_date = $en_date;   
   schedule.day = day;

   var times = [];
   $obj.find('.em_time').each(function(){
      
      var time = new Object();
      time.st_h = $(".st_hour",this).val();
      time.en_h = $(".en_hour",this).val();
      
      $cnt = $(".changeCnt", this).val();
      $title = $(".GSS_SUBTITLE", this).val();
      if($cnt){
         time.cnt = $(".changeCnt",this).val();         
      }else{
         time.cnt = $("#AP_LIMIT_PERSON").val();
      }
      
      if($title){
         time.title = $(".GSS_SUBTITLE",this).val();         
      }else{
         time.title = "신청가능";
      }
      times.push(time);
   });
   
   if(type=='I'){
      $('#scheduleInsert').dialog('close');
      
      //스케줄 아래에 목록 추가하기
      $schedule = $('#scheduleInsert .scheduleInsert').clone();
      
      /* 리스트 버튼 */
      var ListButton =  '<div class="panel panel-default">';
         ListButton += '<div class="panel-heading">';
         ListButton += '<h4 class="panel-title addBtn'+ScheduleCnt+'">';
          ListButton += '<a data-toggle="collapse" data-parent="#scheduleList" href="#collapseOne-'+ScheduleCnt+'" aria-expanded="false" class="collapsed">';
          ListButton += '<i class="fa fa-fw fa-plus-circle txt-color-green"></i> <i class="fa fa-fw fa-minus-circle txt-color-red"></i>';
          
          if(schedule.st_date){
             ListButton += '예약일 : ' + schedule.st_date + '~' + schedule.en_date;                
          }else if(!schedule.st_date){
             ListButton += '예약일' + '(매일)';         
          }
          
          ListButton += '</a>';
          ListButton += '</h4>';
          ListButton += '</div>';

          ListButton += '<div id="collapseOne-'+ScheduleCnt+'" class="panel-collapse collapse" style="">';
          ListButton += '<div class="panel-body scheduleDataAdd'+ScheduleCnt+'" style="padding: 15px;">';
          
          ListButton += '<div style="text-align:right; margin: 13px;">';
          ListButton += '<button class="btn btn-sm btn-warning" style="margin-left:10px;" type="button" onclick="pf_schduleInsert(this.parentNode, '+ScheduleCnt+' ,\'U\')"><i class="fa fa-plus-circle"></i> 수정</button>';
          ListButton += '<button class="btn btn-sm btn-danger" style="margin-left:10px;" type="button" onclick="pf_scheduleAddDelete(this.parentNode, '+ScheduleCnt+')"><i class="fa fa-trash-o"></i> 삭제</button>';
          ListButton += '</div>';
          ListButton += '</div>'; 
          ListButton += '</div>';

         $schedule.addClass('add'+ScheduleCnt);
      
       $('#scheduleInsert .em_time').each(function(Timenumber){
          
          var st_hour = $('.st_hour',this).val();
          var en_hour = $('.en_hour',this).val();
          $time = $schedule.find('.em_time').eq(Timenumber);
          
          $time.find('.st_hour').val(st_hour);
          $time.find('.en_hour').val(en_hour);
         
       }); 
      
      $schedule.find('#start_date').attr('id', "start_date"+ScheduleCnt).removeClass('hasDatepicker');
      $schedule.find('#end_date').attr('id', "end_date"+ScheduleCnt).removeClass('hasDatepicker');
      
      $(".BlankDiv").remove();
      $('#scheduleList').append(ListButton);
      $('.scheduleDataAdd'+ScheduleCnt).prepend($schedule);
      
      //달력 처리       
      datepickerOption.onSelect = function(selectedDate) {
         $schedule.find('.end_date').datepicker('option', 'minDate', selectedDate);
         } 
         $('#start_date'+ScheduleCnt).datepicker(datepickerOption);
         
         datepickerOption.onSelect = function(selectedDate) {
            $schedule.find('.start_date').datepicker('option', 'maxDate', selectedDate);
         }
         $('#end_date'+ScheduleCnt).datepicker(datepickerOption);
         
      ScheduleCnt++;
   }

   schedule.times = times;
   scheduleList[num] = schedule;
   SetSchedule(getDate);
   
}

//스케줄 다이얼로그 열기
function pf_Addschedule(){
   
   if(pf_applyLimit()){
      var gm_max = $("#AP_LIMIT_PERSON").val();
      if(!gm_max || gm_max == 0){
         alert("기본 최대 인원수를 입력해주세요");
         
         $('.nav-tabs li a').eq(0).trigger('click');
         setTimeout(function(){
            $("#AP_LIMIT_PERSON").focus();   
         },300)
         return false;
      }
      $("#scheduleInsert").find('#start_date, #end_date').val('').datepicker('option', {minDate: null, maxDate: null});
      $("#scheduleInsert").find("#start_date, #end_date, .st_hour, .st_min, .en_hour, .en_min, .changeCnt, .GSS_SUBTITLE").val("");
      $("#scheduleInsert input[name=repeat]").prop("checked", false);
      $('#scheduleInsert').dialog('open');
      $('#scheduleInsert .em_time:not(:first-of-type)').remove();
   }
   
   
}

</script>