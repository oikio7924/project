package com.tx.common.config.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
/**
 * desc 값이 있을경우 desc 값이 저장됨
 * type 이 hashmap일 경우 ActivityHistoryService를 호출해서 desc값을 셋팅해줘야됨
 * homeDiv 홈페이지 메뉴 코드 url로 메뉴정보를 알수없을경우 이값을 참조한다.
 * @author admin
 *
 */
public @interface CheckActivityHistory {

	public String desc() default "";
	
	public String type() default "";
	
	public String homeDiv() default "";
}
