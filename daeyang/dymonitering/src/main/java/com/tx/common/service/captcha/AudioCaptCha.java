package com.tx.common.service.captcha;


import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import cn.apiclub.captcha.Captcha;
import cn.apiclub.captcha.audio.AudioCaptcha;
import cn.apiclub.captcha.audio.producer.VoiceProducer;
import cn.apiclub.captcha.servlet.CaptchaServletUtil;



public class AudioCaptCha {

    public void getAudioCaptCha(HttpServletRequest req, HttpServletResponse res, String answer)

      throws IOException{


/*
        HttpSession session = req.getSession();
        
        //Captcha.NAME = 'simpleCaptcha'
        Captcha captcha = (Captcha) session.getAttribute(Captcha.NAME);
        String getAnswer = answer; 

        if ( getAnswer == null || getAnswer.equals("") ) getAnswer = captcha.getAnswer();

 

        AudioCaptcha audiocaptcha = new AudioCaptcha.Builder()
                           //.addAnswer(new DefaultTextProducer(6, getAnswer.toCharArray())) 또는 다음과 같이...
                           .addAnswer(new SetTextProducer(getAnswer))
                           .addNoise() //잡음추가
                           .build();



       CaptchaServletUtil.writeAudio(res, audiocaptcha.getChallenge());*/
       
       
       HttpSession session = req.getSession();
       Captcha captcha = (Captcha) session.getAttribute(Captcha.NAME);
       String getAnswer = answer;
       AudioCaptcha audiocaptcha = null;
       if ( getAnswer == null || "".equals(getAnswer) ) getAnswer = captcha.getAnswer();
       
       String lan = req.getParameter("lan");
       if( lan != null && "kor".equals(lan)) {
           VoiceProducer vProd = new SetKorVoiceProducer(); //한글 음성을 생성해주는 객체 생성
           audiocaptcha = new AudioCaptcha.Builder()
           .addAnswer(new SetTextProducer(getAnswer))
           .addVoice(vProd) //한글음성생성기를 AudioCaptcha에 적용
           .addNoise()
           .build();
       } else {            
           audiocaptcha = new AudioCaptcha.Builder()
           .addAnswer(new SetTextProducer(getAnswer))
           .addNoise()
           .build();
       }
                     
//       String agent = req.getParameter("agent"); //브라우저마다 응답을 달리해야할경우 이용.
       CaptchaServletUtil.writeAudio(res, audiocaptcha.getChallenge());
       

    }
}
