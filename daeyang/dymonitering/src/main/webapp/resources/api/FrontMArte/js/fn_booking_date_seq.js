// 날짜 및 회차선택 
function selectDate(date) {
	var date = date.replace(/-/gi, "");
	$('#PLAY_DATE').val(date);
	var params = $('form[name=frmDateSeq]').serialize();
	$.ajax({
		type : 'post',
		url : 'booking_date_seq_add.do',
		data : params,
		dataType : 'html',
		success : function(html) {
			$('#ListBox').empty();
			$(html).appendTo('#ListBox');
		}
	});
}
  
// 좌석정보 이동
function goSeat(play_date, play_seq_cd, play_st_time, play_seq_nm, phymap_nbr) {
	
	var frm = document.frmDateSeq;
	
	frm.PLAY_SEQ_NM.value = encSpecialChar(play_seq_nm);
	
	frm.action = 'booking_seat.do?PLAY_DATE=' + play_date + '&PLAY_SEQ_CD=' + play_seq_cd + '&PLAY_ST_TIME=' + play_st_time + '&PHYMAP_NBR=' + phymap_nbr;
	frm.method = 'post';
	frm.submit();
}

// 행사선택 이동
function goProgram() {
	
	var frm = document.frmDateSeq;
	
	frm.PLAY_COMPANY_CD.value = '';
	frm.PLACE_CD.value = '';
	frm.REG_COMPANY_CD.value = '';
	frm.PROGRAM_CD.value = '';
	frm.pageNum.value = '';
	
	frm.action = 'booking_program.do';
	frm.method = 'post';
	frm.submit();
}

function leadingZeros(n, digits) {

    var zero = '';
    n = n.toString();
    if (n.length < digits) {
        for (i = 0; i < digits - n.length; i++)
            zero += '0';
    }
    return zero + n;

}

 
function getToDay() {
    var d = new Date();
    var s =  leadingZeros(d.getFullYear(), 4) + '-' +  leadingZeros(d.getMonth() + 1, 2) + '-' +   leadingZeros(d.getDate(), 2);
    return s;
}

function convertToDay( vDate ) {
    var s =  leadingZeros(vDate.getFullYear(), 4) + '-' +  leadingZeros(vDate.getMonth() + 1, 2) + '-' +   leadingZeros(vDate.getDate(), 2);
    return s;
}


