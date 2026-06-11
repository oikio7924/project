/**
 * 계산 관련 js
 */
//최대공약수 binary방식
function gcd(u, v) {
    if(u === v) return u;
    if(u === 0) return v;
    if(v === 0) return u;
    if (~u & 1){
		if (v & 1){
			return gcd(u >> 1, v);
		}else{
			return gcd(u >> 1, v >> 1) << 1;
		}
    }
    if(~v & 1){
    	return gcd(u, v >> 1);
    }
    if(u > v){
    	return gcd((u - v) >> 1, v);
    }
    return gcd((v - u) >> 1, u);
}

//최소공배수
function lcm(u, v){
	return (u*v)/gcd(u,v);
}
