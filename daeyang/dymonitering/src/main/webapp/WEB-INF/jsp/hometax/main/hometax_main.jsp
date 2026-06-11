<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>
<!DOCTYPE html>
<html>
<head>
  <%@ include file="/WEB-INF/jsp/hometax/include/hometax_head.jsp" %>
  <style>
    .calendar-wrap { background: #fff; border-radius: 8px; padding: 0.75rem 1rem; flex: 1; display: flex; flex-direction: column; min-height: 0; overflow: hidden; }
    .calendar-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.5rem; flex-shrink: 0; }
    .calendar-header .calendar-title { flex: 1; text-align: center; font-size: 1.2rem; font-weight: 600; color: #2c3e50; }
    .calendar-header .nav-month { flex: 0 0 90px; }
    .calendar-header .nav-right { text-align: right; }
    .nav-month a { padding: 0.4rem 0.8rem; background: #2c3e50; color: #fff; text-decoration: none; border-radius: 4px; font-size: 0.9rem; }
    .nav-month a:hover { background: #34495e; }
    .calendar-table-wrap { flex: 1; min-height: 0; overflow: hidden; }
    .calendar-table { width: 100%; height: 100%; border-collapse: collapse; table-layout: fixed; }
    .calendar-table th { border: 1px solid #bdc3c7; padding: 6px 4px; background: #34495e; color: #fff; font-size: 0.9rem; }
    .calendar-table td { border: 1px solid #bdc3c7; padding: 4px; vertical-align: top; cursor: pointer; font-size: 0.85rem; height: 8vh; min-height: 44px; }
    .calendar-table td:hover { background: #ecf0f1; }
    .calendar-table .other-month { color: #bdc3c7; background: #f8f9fa; }
    .calendar-table .other-month .day-events { color: #bdc3c7; }
    .calendar-table .today { background: #d5f4e6; border: 2px solid #27ae60; }
    .calendar-table .sun { background: #fdf0f4; }
    .calendar-table .sat { background: #f0eef5; }
    .day-num { display: block; font-weight: 600; font-size: 0.95rem; color: #2c3e50; margin-bottom: 2px; text-align: left; }
    .day-events { list-style: none; margin: 0; padding: 0; text-align: left; }
    .day-events li { padding: 1px 0; border-bottom: 1px solid #eee; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; font-size: 0.8em; }
    .day-events li:last-child { border-bottom: none; }
    .day-events .event-title { font-weight: 500; color: #2c3e50; }
    .day-events .event-memo { color: #7f8c8d; font-size: 0.75em; }
    .month-invoice-summary { background: #2c3e50; color: #fff; border-radius: 8px; padding: 0.9rem 1.2rem; margin-bottom: 1rem; flex-shrink: 0; }
    .month-invoice-summary .label { font-size: 0.95rem; opacity: 0.9; }
    .month-invoice-summary .value { font-size: 1.4rem; font-weight: 700; }
  </style>
</head>
<body>
  <div class="hometax-wrap">
    <%@ include file="/WEB-INF/jsp/hometax/include/hometax_sidebar.jsp" %>
    <div class="hometax-main">
      <div class="calendar-wrap">
        <div class="month-invoice-summary">
          이번달 세금계산서 발행건수
          <span class="value">(총 <c:out value="${monthInvoiceTotal != null ? monthInvoiceTotal : 0}"/>건 / 발행완료 <c:out value="${monthInvoiceCompleted != null ? monthInvoiceCompleted : 0}"/>건)</span>
        </div>
        <div class="calendar-header">
          <div class="nav-month nav-left"><a href="#" id="prevMonth">◀ 이전</a></div>
          <span class="calendar-title" id="currentMonth"></span>
          <div class="nav-month nav-right"><a href="#" id="nextMonth">다음 ▶</a></div>
        </div>
        <div class="calendar-table-wrap">
          <table class="calendar-table">
            <thead><tr><th>일</th><th>월</th><th>화</th><th>수</th><th>목</th><th>금</th><th>토</th></tr></thead>
            <tbody id="calendarBody"></tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
  <script>
    (function(){
      var now = new Date();
      var year = now.getFullYear();
      var month = now.getMonth();
      var scheduleMap = {};

      function getEventsForDate(dateStr) {
        return scheduleMap[dateStr] || [];
      }

      function render(){
        var first = new Date(year, month, 1);
        var last = new Date(year, month + 1, 0);
        var startDay = first.getDay();
        var days = last.getDate();
        var prevLast = new Date(year, month, 0).getDate();
        var html = '';
        var cell = 0, day = 1, prevDay = prevLast - startDay + 1;
        var prevMonth = month === 0 ? 11 : month - 1;
        var prevYear = month === 0 ? year - 1 : year;
        var nextMonth = month === 11 ? 0 : month + 1;
        var nextYear = month === 11 ? year + 1 : year;
        for (var i = 0; i < 6; i++) {
          html += '<tr>';
          for (var j = 0; j < 7; j++) {
            var dateStr, dayNum, isCurrentMonth, cls = '', colCls = (j === 0) ? ' sun' : (j === 6) ? ' sat' : '';
            if (cell < startDay) {
              dayNum = prevDay++;
              dateStr = prevYear + '-' + String(prevMonth+1).padStart(2,'0') + '-' + String(dayNum).padStart(2,'0');
              isCurrentMonth = false;
            } else if (day <= days) {
              dayNum = day++;
              dateStr = year + '-' + String(month+1).padStart(2,'0') + '-' + String(dayNum).padStart(2,'0');
              isCurrentMonth = true;
              if (year === now.getFullYear() && month === now.getMonth() && dayNum === now.getDate()) cls = ' today';
            } else {
              dayNum = day - days;
              dateStr = nextYear + '-' + String(nextMonth+1).padStart(2,'0') + '-' + String(dayNum).padStart(2,'0');
              isCurrentMonth = false;
              day++;
            }
            var events = getEventsForDate(dateStr);
            var eventHtml = '';
            events.forEach(function(ev){
              eventHtml += '<li><span class="event-title">' + (ev.title ? ev.title.replace(/</g,'&lt;') : '(제목 없음)') + '</span>' +
                (ev.memo ? ' <span class="event-memo">' + ev.memo.replace(/</g,'&lt;') + '</span>' : '') + '</li>';
            });
            var tdCls = (isCurrentMonth ? 'day' : 'other-month') + cls + colCls;
            html += '<td class="' + tdCls + '" data-date="' + dateStr + '">' +
              '<span class="day-num">' + dayNum + '</span>' +
              '<ul class="day-events">' + eventHtml + '</ul></td>';
            cell++;
          }
          html += '</tr>';
        }
        document.getElementById('calendarBody').innerHTML = html;
        document.getElementById('currentMonth').textContent = year + '년 ' + (month + 1) + '월';
        document.querySelectorAll('.calendar-table td').forEach(function(td){
          td.addEventListener('click', function(){ openSchedulePopup(this.getAttribute('data-date')); });
        });
      }

      function openSchedulePopup(dateStr) {
        alert('날짜 ' + dateStr + ' 일정 (팝업/API 연동은 다음 단계에서 구현)');
      }

      document.getElementById('prevMonth').onclick = function(e){ e.preventDefault(); month--; if(month<0){ month=11; year--; } render(); };
      document.getElementById('nextMonth').onclick = function(e){ e.preventDefault(); month++; if(month>11){ month=0; year++; } render(); };
      document.getElementById('menu-main').classList.add('on');
      render();
    })();
  </script>
</body>
</html>
