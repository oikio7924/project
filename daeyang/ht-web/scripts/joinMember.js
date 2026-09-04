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
  CorpNum:   process.env.POPBILL_CORP_NUM,     // 사업자번호 (하이픈 제외)
  CEOName:   process.env.POPBILL_CEO_NAME,
  CorpName:  process.env.POPBILL_CORP_NAME,
  Addr:      process.env.POPBILL_ADDR,
  BizType:   process.env.POPBILL_BIZ_TYPE,
  BizClass:  process.env.POPBILL_BIZ_CLASS,
  ID:        process.env.POPBILL_JOIN_ID,      // 팝빌 로그인 아이디 (영문+숫자, 6~20자)
  Password:  process.env.POPBILL_JOIN_PASSWORD, // 비밀번호 (영문+숫자+특수문자, 8자 이상)
  ContactName:  process.env.POPBILL_CONTACT_NAME,
  ContactEmail: process.env.POPBILL_CONTACT_EMAIL,
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
