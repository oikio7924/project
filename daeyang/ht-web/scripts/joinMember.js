/**
 * 팝빌 연동회원 등록 (최초 1회만 실행)
 * 실행: node scripts/joinMember.js
 */
require("dotenv").config();
const popbill = require("popbill");

popbill.config({
  LinkID: process.env.POPBILL_LINK_ID,
  SecretKey: process.env.POPBILL_SECRET_KEY,
  IsTest: process.env.POPBILL_IS_TEST === "true",
  IPRestrictOnOff: false,
  UseStaticIP: false,
  UseLocalTimeYN: true,
});

const svc = popbill.TaxinvoiceService();

const joinForm = {
  LinkID:    process.env.POPBILL_LINK_ID,
  CorpNum:   "1858701989",       // 대양에스코 사업자번호 (하이픈 제외)
  CEOName:   "김형기",
  CorpName:  "대양에스코",
  Addr:      "전라남도 나주시 봉황면 운곡용곡길 16",
  BizType:   "서비스업",
  BizClass:  "전기안전관리대행",
  ID:        "daeesco0715",     // 팝빌 로그인 아이디 (영문+숫자, 6~20자)
  Password:  "qwer4321!",     // 비밀번호 (영문+숫자+특수문자, 8자 이상)
  ContactName:  "김형기",
  ContactEmail: "dy0164@dycompany.co.kr",
  ContactTEL:   "",
  ContactHP:    "",
};

svc.joinMember(
  joinForm,
  function (result) {
    console.log("✅ 연동회원 등록 성공!");
    console.log("결과:", JSON.stringify(result, null, 2));
  },
  function (err) {
    console.error("❌ 등록 실패:", err.code, err.message);
  }
);
