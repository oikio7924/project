<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<c:set var="homekey" value="${currentMenu.MN_URL }"/>
<c:set var="lang" value="${fn:substring(homekey, 1, 3)}"/>
<c:choose>
	<c:when test="${lang eq 'en' }">
		
		<c:set var="language_default_Subject" value="Subject"/>
		<c:set var="language_default_Number" value="NO"/>
		<c:set var="language_default_con" value="Contents"/>
		<c:set var="language_default_writer" value="Writer"/>
		<c:set var="language_default_date" value="Date"/>
		<c:set var="language_default_hits" value="Hits"/>
		<c:set var="language_default_all" value="All"/>
		<c:set var="language_default_total" value="All post"/>
		<c:set var="language_default_board" value="Board"/>
		<c:set var="language_default_case" value="Cases"/>
		<c:set var="language_default_page" value="page"/>
		<c:set var="language_default_notice" value="Notice"/>
		<c:set var="language_default_empty" value="No content"/>
		<c:set var="language_default_write" value="Write"/>
		<c:set var="language_default_Next" value="Next"/>
		<c:set var="language_default_Prev" value="Prev"/>
		<c:set var="language_default_move" value="Move"/>
		<c:set var="language_default_delete" value="Delete"/>
		<c:set var="language_default_modify" value="Modify"/>
		<c:set var="language_default_list" value="List"/>
		<c:set var="language_default_Attachment" value="Attachment"/>
	
		<c:set var="language_order_latest" value="The latest"/>
		<c:set var="language_order_hits" value="By views"/>
		
		<c:set var="language_search" value="Search"/>
		<c:set var="language_search_text" value="Please enter your search term"/>
		
		<c:set var="language_alert_1" value="You do not have access. Please log in or check access privileges."/>
		<c:set var="language_alert_2" value="this is a secret."/>
		<c:set var="language_alert_3" value="Are you sure you want to delete?"/>
		<c:set var="language_alert_4" value="You do not have permission to write. Please contact your administrator."/>
		<c:set var="language_alert_5" value="The post has been deleted."/>
		<c:set var="language_alert_6" value="Login is required. Are you sure you want to sign in?"/>
		
		<c:set var="language_alt_1" value="Secret icon"/>
		<c:set var="language_alt_2" value="Reply icon"/>
		<c:set var="language_alt_3" value="New icon"/>
		<c:set var="language_alt_4" value="Link icon"/>
		<c:set var="language_alt_5" value="Attached file icon"/>
		
		
	</c:when>
	<c:when test="${lang eq 'zh' }">
		
		<c:set var="language_default_Subject" value="标题"/>
		<c:set var="language_default_Number" value="沒有"/>
		<c:set var="language_default_con" value="內容"/>
		<c:set var="language_default_writer" value="作家"/>
		<c:set var="language_default_date" value="日期"/>
		<c:set var="language_default_hits" value="點擊"/>
		<c:set var="language_default_all" value="所有 "/>
		<c:set var="language_default_total" value="全部帖子 "/>
		<c:set var="language_default_board" value="Board"/>
		<c:set var="language_default_case" value="個案例 "/>
		<c:set var="language_default_page" value="頁"/>
		<c:set var="language_default_notice" value="注意"/>
		<c:set var="language_default_empty" value="無內容"/>
		<c:set var="language_default_write" value="寫"/>
		<c:set var="language_default_Next" value="下一个"/>
		<c:set var="language_default_Prev" value="以前"/>
		<c:set var="language_default_move" value="Move"/>
		<c:set var="language_default_delete" value="Delete"/>
		<c:set var="language_default_modify" value="Modify"/>
		<c:set var="language_default_list" value="名单"/>
		<c:set var="language_default_Attachment" value="附件"/>
	
		<c:set var="language_order_latest" value="最新的"/>
		<c:set var="language_order_hits" value="通過意見"/>
		
		<c:set var="language_search" value="搜索"/>
		<c:set var="language_search_text" value="請輸入您的搜索字詞 "/>
		
		<c:set var="language_alert_1" value="你沒有權限請登錄或查看訪問權限。"/>
		<c:set var="language_alert_2" value="這是一個秘密。"/>
		<c:set var="language_alert_3" value="Are you sure you want to delete?"/>
		<c:set var="language_alert_4" value="你沒有寫權限。請聯繫您的管理員。"/>
		<c:set var="language_alert_5" value="該帖子已被刪除。"/>
		<c:set var="language_alert_6" value="您需要登錄。你想簽？"/>
		
		<c:set var="language_alt_1" value="秘密圖標"/>
		<c:set var="language_alt_2" value="揭秘圖標"/>
		<c:set var="language_alt_3" value="新圖標"/>
		<c:set var="language_alt_4" value="鏈接圖標"/>
		<c:set var="language_alt_5" value="附件圖標"/>
		
		
	</c:when>
	<c:otherwise>
		
		<c:set var="language_default_Subject" value="제목"/>
		<c:set var="language_default_Number" value="번호"/>
		<c:set var="language_default_con" value="내용"/>
		<c:set var="language_default_writer" value="작성자"/>
		<c:set var="language_default_date" value="작성일"/>
		<c:set var="language_default_hits" value="조회"/>
		<c:set var="language_default_all" value="모두"/>
		<c:set var="language_default_total" value="총 게시물"/>
		<c:set var="language_default_board" value="게시판"/>
		<c:set var="language_default_case" value="건"/>
		<c:set var="language_default_page" value="페이지"/>
		<c:set var="language_default_notice" value="공지"/>
		<c:set var="language_default_empty" value="내용없음"/>
		<c:set var="language_default_write" value="글쓰기"/>
		<c:set var="language_default_Next" value="다음글"/>
		<c:set var="language_default_Prev" value="이전글"/>
		<c:set var="language_default_move" value="이동"/>
		<c:set var="language_default_delete" value="삭제"/>
		<c:set var="language_default_modify" value="수정"/>
		<c:set var="language_default_list" value="목록"/>
		<c:set var="language_default_Attachment" value="첨부"/>
	
		<c:set var="language_order_latest" value="최신순"/>
		<c:set var="language_order_hits"  value="조회수순"/>
		
		<c:set var="language_search" value="검색"/>
		<c:set var="language_search_text" value="검색어를 입력하세요"/>
		
		<c:set var="language_alert_1" value="접근권한이 없습니다. 로그인을 하시거나 접근권한을 확인하세요."/>
		<c:set var="language_alert_2" value="비밀글 입니다."/>
		<c:set var="language_alert_3" value="삭제 하시겠습니까?"/>
		<c:set var="language_alert_4" value="글쓰기 권한이 없습니다. 관리자한테 문의하세요."/>
		<c:set var="language_alert_5" value="삭제된 게시물입니다."/>
		<c:set var="language_alert_6" value="로그인이 필요합니다. 로그인 하시겠습니까?"/>
		
		<c:set var="language_alt_1" value="비밀글 아이콘"/>
		<c:set var="language_alt_2" value="답글 아이콘"/>
		<c:set var="language_alt_3" value="새글 아이콘"/>
		<c:set var="language_alt_4" value="링크 아이콘"/>
		<c:set var="language_alt_5" value="첨부파일 아이콘"/>
	
	</c:otherwise>

</c:choose>