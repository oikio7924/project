package com.tx.common.config.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

import javax.validation.Constraint;
import javax.validation.Payload;

import com.tx.common.service.member.validator.IdDupleChkValidator;

@Target({ElementType.METHOD, ElementType.FIELD, ElementType.ANNOTATION_TYPE, ElementType.CONSTRUCTOR, ElementType.PARAMETER})
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = {IdDupleChkValidator.class})
public @interface IdDupleChk {
	String message() default "이미 존재하는 아이디 입니다.";
	Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}
