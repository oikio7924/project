<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>로그인 - 홈택스 세금계산서</title>
  <style>
    * { box-sizing: border-box; }
    body { margin: 0; font-family: 'Malgun Gothic', sans-serif; min-height: 100vh; display: flex; align-items: center; justify-content: center; background: #ecf0f1; }
    .login-box { width: 100%; max-width: 420px; padding: 2rem; background: #fff; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
    .login-box h1 { margin: 0 0 1.5rem 0; font-size: 1.25rem; text-align: center; }
    .login-box label { display: block; margin-bottom: 0.25rem; font-size: 0.875rem; }
    .login-box input { width: 100%; padding: 0.5rem 0.75rem; margin-bottom: 1rem; border: 1px solid #bdc3c7; border-radius: 4px; }
    .login-box button { width: 100%; padding: 0.75rem; background: #2c3e50; color: #fff; border: none; border-radius: 4px; cursor: pointer; font-size: 1rem; }
    .login-box button:hover { background: #34495e; }
    .msg { color: #e74c3c; font-size: 0.875rem; margin-bottom: 0.5rem; }
    .divider { height: 1px; background: #ecf0f1; margin: 1.25rem 0; }
    .sub-title { margin: 0 0 0.75rem 0; font-size: 1rem; font-weight: 600; color: #2c3e50; }
    .check-row { display: flex; gap: 1rem; align-items: center; margin: 0.25rem 0 0.75rem 0; }
    .check-row label { display: inline-flex; gap: 0.4rem; align-items: center; margin: 0; font-size: 0.9rem; }
    .check-row input[type="checkbox"] { width: auto; margin: 0; }
    .btn-outline { width: 100%; padding: 0.75rem; background: #fff; color: #2c3e50; border: 1px solid #2c3e50; border-radius: 4px; cursor: pointer; font-size: 1rem; }
    .btn-outline:hover { background: #f4f6f7; }

    /* modal */
    .modal-backdrop { position: fixed; inset: 0; background: rgba(0,0,0,0.4); display: none; align-items: center; justify-content: center; padding: 1rem; }
    .modal { width: 100%; max-width: 560px; background: #fff; border-radius: 10px; box-shadow: 0 10px 30px rgba(0,0,0,0.25); overflow: hidden; }
    .modal-header { display: flex; align-items: center; justify-content: space-between; padding: 1rem 1.25rem; background: #2c3e50; color: #fff; }
    .modal-title { font-size: 1.05rem; font-weight: 600; }
    .modal-close { background: transparent; border: none; color: #fff; font-size: 1.4rem; cursor: pointer; line-height: 1; }
    .modal-body { padding: 1.25rem; }
    .grid { display: grid; grid-template-columns: 1fr 1fr; gap: 0.75rem 1rem; }
    .grid .full { grid-column: 1 / -1; }
    .modal-body label { display: block; margin: 0 0 0.25rem 0; font-size: 0.875rem; }
    .modal-body input { width: 100%; padding: 0.5rem 0.75rem; border: 1px solid #bdc3c7; border-radius: 4px; }
    .modal-actions { display: flex; gap: 0.75rem; margin-top: 1rem; }
    .modal-actions button { flex: 1; }
  </style>
</head>
<body>
  <div class="login-box">
    <h1>홈택스 세금계산서 로그인</h1>
    <c:if test="${not empty msg}"><p class="msg">${msg}</p></c:if>
    <form action="${pageContext.request.contextPath}/bill/loginProc.do" method="post" id="loginForm">
      <label for="loginId">아이디</label>
      <input type="text" id="loginId" name="loginId" placeholder="아이디" autocomplete="username">
      <label for="loginPw">비밀번호</label>
      <input type="password" id="loginPw" name="loginPw" placeholder="비밀번호" autocomplete="current-password">
      <div class="check-row">
        <label><input type="checkbox" id="autoLogin" name="autoLogin" value="Y">자동로그인</label>
        <label><input type="checkbox" id="saveId" name="saveId" value="Y">아이디저장</label>
      </div>
      <button type="submit">로그인</button>
    </form>

    <div class="divider"></div>

    <button type="button" class="btn-outline" id="openRegister">회원가입</button>
  </div>

  <div class="modal-backdrop" id="registerBackdrop" aria-hidden="true">
    <div class="modal" role="dialog" aria-modal="true" aria-labelledby="registerTitle">
      <div class="modal-header">
        <div class="modal-title" id="registerTitle">회원가입</div>
        <button type="button" class="modal-close" id="closeRegister" aria-label="닫기">×</button>
      </div>
      <div class="modal-body">
        <form action="${pageContext.request.contextPath}/bill/registerProc.do" method="post" id="registerForm">
          <div class="grid">
            <div>
              <label for="regName">이름</label>
              <input type="text" id="regName" name="regName" placeholder="이름">
            </div>
            <div>
              <label for="regDepartment">부서</label>
              <input type="text" id="regDepartment" name="regDepartment" placeholder="부서">
            </div>
            <div>
              <label for="regPhone">연락처</label>
              <input type="text" id="regPhone" name="regPhone" placeholder="연락처">
            </div>
            <div>
              <label for="regExtensionNo">내선번호</label>
              <input type="text" id="regExtensionNo" name="regExtensionNo" placeholder="내선번호">
            </div>
            <div class="full">
              <label for="regEmail">이메일</label>
              <input type="text" id="regEmail" name="regEmail" placeholder="이메일">
            </div>
            <div>
              <label for="regLoginId">아이디</label>
              <input type="text" id="regLoginId" name="regLoginId" placeholder="아이디" autocomplete="username">
            </div>
            <div>
              <label for="regLoginPw">비밀번호</label>
              <input type="password" id="regLoginPw" name="regLoginPw" placeholder="비밀번호" autocomplete="new-password">
            </div>
          </div>
          <div class="modal-actions">
            <button type="submit">가입하기</button>
            <button type="button" class="btn-outline" id="cancelRegister">취소</button>
          </div>
        </form>
      </div>
    </div>
  </div>

  <script>
    (function(){
      var savedId = localStorage.getItem('hometax_saved_id') || '';
      var savedIdYn = localStorage.getItem('hometax_save_id_yn') === 'Y';
      var autoLoginYn = localStorage.getItem('hometax_auto_login_yn') === 'Y';

      var loginId = document.getElementById('loginId');
      var saveId = document.getElementById('saveId');
      var autoLogin = document.getElementById('autoLogin');
      var loginForm = document.getElementById('loginForm');

      if (savedIdYn && savedId) {
        loginId.value = savedId;
        saveId.checked = true;
      }
      if (autoLoginYn) autoLogin.checked = true;

      loginForm.addEventListener('submit', function(){
        localStorage.setItem('hometax_auto_login_yn', autoLogin.checked ? 'Y' : 'N');
        if (saveId.checked) {
          localStorage.setItem('hometax_save_id_yn', 'Y');
          localStorage.setItem('hometax_saved_id', loginId.value || '');
        } else {
          localStorage.setItem('hometax_save_id_yn', 'N');
          localStorage.removeItem('hometax_saved_id');
        }
      });

      // modal
      var backdrop = document.getElementById('registerBackdrop');
      var openBtn = document.getElementById('openRegister');
      var closeBtn = document.getElementById('closeRegister');
      var cancelBtn = document.getElementById('cancelRegister');
      function open(){
        backdrop.style.display = 'flex';
        backdrop.setAttribute('aria-hidden', 'false');
        setTimeout(function(){ document.getElementById('regName').focus(); }, 0);
      }
      function close(){
        backdrop.style.display = 'none';
        backdrop.setAttribute('aria-hidden', 'true');
      }
      openBtn.addEventListener('click', open);
      closeBtn.addEventListener('click', close);
      cancelBtn.addEventListener('click', close);
      backdrop.addEventListener('click', function(e){
        if (e.target === backdrop) close();
      });
      document.addEventListener('keydown', function(e){
        if (e.key === 'Escape' && backdrop.getAttribute('aria-hidden') === 'false') close();
      });
    })();
  </script>
</body>
</html>
