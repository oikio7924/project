# hometax 전용 패키지·폴더 구조

기존 사이트와 분리해 두기 위한 전용 구조입니다. (진입 URL은 /bill.do 또는 /hometax.do 로 매핑 가능)

---

## 1. Java 패키지 (src/main/java/com/tx/hometax/)

```
com.tx.hometax
├── controller          # URL 매핑
│   ├── HometaxController.java       # /bill.do 또는 /hometax.do, 메인·달력·메뉴 페이지
│   └── HometaxLoginController.java  # /bill/login.do, 로그인
├── service             # 비즈니스 로직 (선택)
│   ├── HometaxScheduleService.java
│   ├── HometaxProviderService.java
│   └── ...
├── dto                  # 요청/응답·엔티티
│   ├── BillUserDTO.java
│   ├── BillScheduleDTO.java
│   ├── BillProviderDTO.java
│   ├── BillRecipientDTO.java
│   ├── BillInvoiceTemplateDTO.java
│   ├── BillInvoiceLogDTO.java
│   └── BillDocumentKeyDTO.java
└── (mapper 인터페이스는 common 방식에 맞추거나 hometax.mapper 패키지)
```

---

## 2. JSP (src/main/webapp/WEB-INF/jsp/hometax/)

```
jsp/hometax/
├── layout/
│   └── hometax_layout.jsp          # 공통 레이아웃 (달력 가운데 + 옆 메뉴)
├── login/
│   └── hometax_login.jsp           # 전용 로그인
├── main/
│   └── hometax_main.jsp            # 메인 = 달력
├── schedule/
│   └── hometax_schedule_popup.jsp  # 날짜 클릭 시 일정 팝업
├── supplier/                        # 공급자
│   ├── hometax_supplier_list.jsp
│   └── hometax_supplier_form.jsp
├── recipient/                       # 공급받는자
│   ├── hometax_recipient_list.jsp
│   └── hometax_recipient_form.jsp
└── history/                         # 발행내역
    └── hometax_history_list.jsp
```

---

## 3. MyBatis 매퍼 (src/main/resources/mapper/mysql/hometax/)

```
mapper/mysql/hometax/
└── Hometax_SQL.xml                 # namespace 예: hometax
    # bill_schedule, bill_provider, bill_recipient,
    # bill_invoice_template, bill_invoice_log, bill_document_key, bill_user
```

※ DB 테이블명은 기존 그대로 `bill_*` 사용.

---

## 4. 정리

| 구분     | 경로 |
|----------|------|
| 컨트롤러 | `com.tx.hometax.controller` |
| DTO      | `com.tx.hometax.dto` |
| 서비스   | `com.tx.hometax.service` (선택) |
| JSP      | `WEB-INF/jsp/hometax/` |
| 매퍼 XML | `mapper/mysql/hometax/Hometax_SQL.xml` |

이렇게 두면 hometax 관련 코드·화면·쿼리가 한곳에 모여 있고, 기존 bill 폴더 및 dyAdmin / SafeAdmin / user 쪽과 섞이지 않습니다.
