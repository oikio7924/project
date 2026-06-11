package com.tx.hometax.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.tx.hometax.controller.HometaxLoginController;

/**
 * /bill/** 영역 로그인 체크
 */
public class HometaxAuthInterceptor extends HandlerInterceptorAdapter {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {

        String uri = request.getRequestURI();
        String ctx = request.getContextPath() == null ? "" : request.getContextPath();
        String path = ctx.isEmpty() ? uri : uri.substring(ctx.length());

        // 로그인/회원가입/로그아웃은 예외
        if (path.equals("/bill/login.do")
                || path.equals("/bill/loginProc.do")
                || path.equals("/bill/registerProc.do")
                || path.equals("/bill/logout.do")) {
            return true;
        }

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute(HometaxLoginController.getSessionKey()) == null) {
            response.sendRedirect(ctx + "/bill/login.do");
            return false;
        }
        return true;
    }
}

