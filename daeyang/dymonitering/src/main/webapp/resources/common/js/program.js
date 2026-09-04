
//결제 만료일 계산
function pf_expired(now_date, charge_expired){
	var yy = parseInt(now_date.substr(0, 4), 10);
    var mm = parseInt(now_date.substr(5, 2), 10);
    var dd = parseInt(now_date.substr(8), 10);
    
    d = new Date(yy, mm - 1, dd + parseInt(charge_expired));
    yy = d.getFullYear();
    mm = d.getMonth() + 1; mm = (mm < 10) ? '0' + mm : mm;
    dd = d.getDate(); dd = (dd < 10) ? '0' + dd : dd;
    
    return '' + yy + '-' +  mm  + '-' + dd;
    
}