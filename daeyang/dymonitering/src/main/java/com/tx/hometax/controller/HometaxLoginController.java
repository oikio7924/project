package com.tx.hometax.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.tx.common.security.password.MyPasswordEncoder;
import com.tx.common.service.component.ComponentService;
import com.tx.hometax.dto.BillUserDTO;

/**
 * hometax 전용 로그인
 * /bill/login.do → 로그인 화면
 * /bill/loginProc.do → 로그인 처리 후 /bill.do 로 이동
 */
@Controller
public class HometaxLoginController {

    private static final String HOMETAX_SESSION_KEY = "HOMETAX_LOGIN_ID";
    private static final String HOMETAX_SESSION_USER_ID = "HOMETAX_USER_ID";
    private static final String HOMETAX_SESSION_ROLE = "HOMETAX_ROLE";
    private static final String HOMETAX_SESSION_DEFAULT_PROVIDER_ID = "HOMETAX_DEFAULT_PROVIDER_ID";

    @Autowired
    private ComponentService Component;

    @Autowired
    private MyPasswordEncoder MyPasswordEncoder;

    /** 로그인 화면 */
    @RequestMapping(value = "/bill/login.do", method = RequestMethod.GET)
    public ModelAndView loginForm(HttpServletRequest req) {
        ModelAndView mv = new ModelAndView("/hometax/login/hometax_login");
        return mv;
    }

    /** 로그인 처리 (ht_bill_user 연동) */
    @RequestMapping(value = "/bill/loginProc.do", method = RequestMethod.POST)
    public ModelAndView loginProc(
            HttpServletRequest req,
            HttpServletResponse res,
            @RequestParam(value = "loginId", required = false) String loginId,
            @RequestParam(value = "loginPw", required = false) String loginPw,
            RedirectAttributes redirectAttributes) {

        if (loginId == null || loginId.trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("msg", "아이디를 입력하세요.");
            return new ModelAndView("redirect:/bill/login.do");
        }
        if (loginPw == null || loginPw.trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("msg", "비밀번호를 입력하세요.");
            return new ModelAndView("redirect:/bill/login.do");
        }

        BillUserDTO user = null;
        try {
            user = Component.getData("hometax.selectBillUserByLoginId", loginId.trim());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("msg", "로그인 처리 중 오류가 발생했습니다.");
            return new ModelAndView("redirect:/bill/login.do");
        }

        if (user == null) {
            redirectAttributes.addFlashAttribute("msg", "존재하지 않는 아이디입니다.");
            return new ModelAndView("redirect:/bill/login.do");
        }
        if (user.getUseYn() == null || !"Y".equalsIgnoreCase(user.getUseYn())) {
            redirectAttributes.addFlashAttribute("msg", "사용할 수 없는 계정입니다.");
            return new ModelAndView("redirect:/bill/login.do");
        }
        if (user.getLoginPw() == null || !MyPasswordEncoder.matches(loginPw, user.getLoginPw())) {
            redirectAttributes.addFlashAttribute("msg", "비밀번호가 올바르지 않습니다.");
            return new ModelAndView("redirect:/bill/login.do");
        }

        HttpSession session = req.getSession(true);
        session.setAttribute(HOMETAX_SESSION_KEY, loginId.trim());
        session.setAttribute(HOMETAX_SESSION_USER_ID, user.getId());
        session.setAttribute(HOMETAX_SESSION_ROLE, user.getRole());
        session.setAttribute(HOMETAX_SESSION_DEFAULT_PROVIDER_ID, user.getDefaultProviderId());

        return new ModelAndView("redirect:/bill.do");
    }

    /** 계정 생성 (로그인 화면에서 생성) */
    @RequestMapping(value = "/bill/registerProc.do", method = RequestMethod.POST)
    public ModelAndView registerProc(
            HttpServletRequest req,
            @RequestParam(value = "regLoginId", required = false) String regLoginId,
            @RequestParam(value = "regLoginPw", required = false) String regLoginPw,
            @RequestParam(value = "regName", required = false) String regName,
            @RequestParam(value = "regDepartment", required = false) String regDepartment,
            @RequestParam(value = "regPhone", required = false) String regPhone,
            @RequestParam(value = "regExtensionNo", required = false) String regExtensionNo,
            @RequestParam(value = "regEmail", required = false) String regEmail,
            RedirectAttributes redirectAttributes) {

        if (regLoginId == null || regLoginId.trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("msg", "회원가입 아이디를 입력하세요.");
            return new ModelAndView("redirect:/bill/login.do");
        }
        if (regLoginPw == null || regLoginPw.trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("msg", "회원가입 비밀번호를 입력하세요.");
            return new ModelAndView("redirect:/bill/login.do");
        }

        String loginId = regLoginId.trim();
        try {
            Integer cnt = Component.getCount("hometax.countBillUserByLoginId", loginId);
            if (cnt != null && cnt > 0) {
                redirectAttributes.addFlashAttribute("msg", "이미 사용 중인 아이디입니다.");
                return new ModelAndView("redirect:/bill/login.do");
            }

            BillUserDTO dto = new BillUserDTO();
            dto.setLoginId(loginId);
            dto.setLoginPw(MyPasswordEncoder.encode(regLoginPw));
            dto.setName(regName != null ? regName.trim() : null);
            dto.setDepartment(regDepartment != null ? regDepartment.trim() : null);
            dto.setPhone(regPhone != null ? regPhone.trim() : null);
            dto.setExtensionNo(regExtensionNo != null ? regExtensionNo.trim() : null);
            dto.setEmail(regEmail != null ? regEmail.trim() : null);
            dto.setUseYn("Y");
            dto.setRole("USER");
            dto.setDefaultProviderId(null); // DB에서 직접 세팅 가능

            Component.createData("hometax.insertBillUser", dto);
            redirectAttributes.addFlashAttribute("msg", "계정이 생성되었습니다. 로그인해주세요.");
            return new ModelAndView("redirect:/bill/login.do");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("msg", "계정 생성 실패: " + e.getMessage());
            return new ModelAndView("redirect:/bill/login.do");
        }
    }

    /** 로그아웃 */
    @RequestMapping("/bill/logout.do")
    public ModelAndView logout(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.removeAttribute(HOMETAX_SESSION_KEY);
            session.removeAttribute(HOMETAX_SESSION_USER_ID);
            session.removeAttribute(HOMETAX_SESSION_ROLE);
            session.removeAttribute(HOMETAX_SESSION_DEFAULT_PROVIDER_ID);
        }
        return new ModelAndView("redirect:/bill/login.do");
    }

    /** 세션 키 (인터셉터에서 사용) */
    public static String getSessionKey() {
        return HOMETAX_SESSION_KEY;
    }

    public static String getDefaultProviderSessionKey() {
        return HOMETAX_SESSION_DEFAULT_PROVIDER_ID;
    }
}
