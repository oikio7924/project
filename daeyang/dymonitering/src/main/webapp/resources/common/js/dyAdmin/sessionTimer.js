var loginTime = 1;

function sessionTimer()
{
	var hour = Math.floor(loginTime / (60 * 60));
	var min = Math.floor(( loginTime / 60 ) % 60)
	var sec = Math.floor( loginTime  % 60)
	postMessage((hour == 0 ? '' : hour+'시간 ') + (min == 0 ? '' : min+'분 ') + (sec == 0 ? '' : sec+'초 '));
	loginTime++;
}

onmessage = function(e) {
    // the passed-in data is available via e.data
	setInterval(sessionTimer,1000);
};

