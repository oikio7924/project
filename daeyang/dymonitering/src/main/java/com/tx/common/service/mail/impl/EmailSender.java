package com.tx.common.service.mail.impl;

import javax.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.stereotype.Component;

import com.tx.common.config.tld.SiteProperties;

@Component
@EnableAsync
public class EmailSender {
	
	@Autowired
	protected JavaMailSender mailSender;
	
	
	// 메일전송
		@Async
		public void sendEmail(String reciver, String subject, String content) throws Exception{
			MimeMessage msg = mailSender.createMimeMessage();
	        MimeMessageHelper helper = new MimeMessageHelper(msg, false,"UTF-8");
	        helper.setSubject(subject);
	        helper.setTo(reciver);
	        helper.setFrom(SiteProperties.getString("EMAIL_SENDER"),SiteProperties.getString("EMAIL_SENDER_NAME"));
	        helper.setText(content, true);
	        try{
	        	mailSender.send(msg);
	        }catch (Exception e) {
	        	System.out.println("메일전송 에러 :: " + e.getMessage());
			}
			
		}
		@Async
		public void sendEmail(String reciver,String sender, String subject, String content) throws Exception{
			MimeMessage msg = mailSender.createMimeMessage();
	        MimeMessageHelper helper = new MimeMessageHelper(msg, false,"UTF-8");
	        helper.setSubject(subject);
	        helper.setTo(reciver);
	        helper.setFrom(sender);
	        helper.setText(content, true);
	        
	        
	        try{
	        	mailSender.send(msg);
	        }catch (Exception e) {
	        	System.out.println("메일전송 에러 :: " + e.getMessage());
			}
			
		}
		
		@Async
		public void sendEmail(String reciver,String sender,String senderName, String subject, String content) throws Exception{
			MimeMessage msg = mailSender.createMimeMessage();
	        MimeMessageHelper helper = new MimeMessageHelper(msg, false,"UTF-8");
	        helper.setSubject(subject);
	        helper.setTo(reciver);
	        helper.setFrom(sender,senderName);
	        helper.setText(content, true);
	        
	        
	        try{
	        	mailSender.send(msg);
	        }catch (Exception e) {
	        	System.out.println("메일전송 에러 :: " + e.getMessage());
			}
			
		}

	
}