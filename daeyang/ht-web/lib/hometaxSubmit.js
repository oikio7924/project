/**
 * 전자세금계산서 발행 연동 — 신안소프트 hometaxbill.com
 *
 * 환경 변수:
 *   HOMETAX_INVOICE_PROVIDER=hometaxbill
 *   HOMETAXBILL_ID      신안소프트에서 발급한 회사 아이디
 *   HOMETAXBILL_PASS    비밀번호
 *   HOMETAXBILL_APIKEY  인증키
 *   HOMETAXBILL_HOST    호스트 (기본: www.hometaxbill.com, 테스트: 115.68.1.5)
 */

const http  = require("http");
const https = require("https");

function httpPost(path, body) {
  const host     = String(process.env.HOMETAXBILL_HOST     || "www.hometaxbill.com").trim();
  const protocol = String(process.env.HOMETAXBILL_PROTOCOL || "https").trim().toLowerCase();
  const port = 8084;
  const transport = protocol === "http" ? http : https;
  return new Promise(function (resolve, reject) {
    const data = JSON.stringify(body);
    const options = {
      hostname: host,
      port: port,
      path: path,
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Content-Length": Buffer.byteLength(data),
        "Connection": "keep-alive",
      },
      timeout: 30000,
    };
    if (protocol !== "http") {
      options.rejectUnauthorized = false;
      options.secureOptions = require("crypto").constants.SSL_OP_LEGACY_SERVER_CONNECT;
    }
    const req = transport.request(options, function (res) {
      let text = "";
      res.setEncoding("utf8");
      res.on("data", function (chunk) { text += chunk; });
      res.on("end", function () { resolve({ status: res.statusCode, text }); });
    });
    req.on("timeout", function () { req.destroy(); reject(new Error("요청 시간 초과 (30초)")); });
    req.on("error", reject);
    req.write(data);
    req.end();
  });
}

function toDigits(s) {
  return String(s || "").replace(/[^0-9]/g, "");
}

function yearMonthPrefix(ym) {
  const s = String(ym || "").trim();
  if (!s || s.length < 7) return "";
  const parts = s.split("-");
  const y = parts[0];
  const mo = Number(parts[1]);
  if (!y || !Number.isFinite(mo) || mo < 1 || mo > 12) return "";
  const yy = String(Number(y) % 100).padStart(2, "0");
  const mm = String(mo).padStart(2, "0");
  return yy + "." + mm + "월분 ";
}

function toAmountStr(v) {
  return String(Math.floor(Number(v) || 0));
}

function writeDateOf(yearMonth) {
  const parts = String(yearMonth || "").split("-");
  const y = Number(parts[0]);
  const m = Number(parts[1]);
  if (!y || !m) {
    const t = new Date();
    return (
      t.getFullYear() +
      String(t.getMonth() + 1).padStart(2, "0") +
      String(t.getDate()).padStart(2, "0")
    );
  }
  const lastDay = new Date(y, m, 0).getDate();
  return y + String(m).padStart(2, "0") + String(lastDay).padStart(2, "0");
}

async function submitIssueRecordToHometax(ctx) {
  const issueRecord = ctx.issueRecord || {};
  const provider = String(process.env.HOMETAX_INVOICE_PROVIDER || "")
    .trim()
    .toLowerCase();

  if (provider === "hometaxbill") {
    const htId   = String(process.env.HOMETAXBILL_ID    || "").trim();
    const htPass = String(process.env.HOMETAXBILL_PASS  || "").trim();
    const htKey  = String(process.env.HOMETAXBILL_APIKEY || "").trim();

    if (!htId || !htPass || !htKey) {
      return {
        ok: false,
        message: "HOMETAXBILL_ID / HOMETAXBILL_PASS / HOMETAXBILL_APIKEY 환경변수를 설정하세요.",
      };
    }

    const supplier = ctx.supplier || {};
    const recipient = ctx.recipient || {};
    const yearMonth = String(ctx.yearMonth || issueRecord.yearMonth || "");

    const supplierBizNo = toDigits(supplier.bizNo);
    if (!supplierBizNo) {
      return { ok: false, message: "공급자 사업자번호가 없습니다." };
    }

    const recipientBizNo = toDigits(recipient.bizNo);
    if (!recipientBizNo) {
      return { ok: false, message: "공급받는자 등록번호(사업자번호/주민번호)가 없습니다." };
    }

    // 사업자: "01", 개인(주민번호): "02"
    const partytypecode = recipient.kind === "business" ? "01" : "02";

    // 작성일자: ctx.issueDate 우선, 없으면 오늘 (KST)
    const todayKst = new Intl.DateTimeFormat("en-CA", {
      timeZone: "Asia/Seoul", year: "numeric", month: "2-digit", day: "2-digit",
    }).format(new Date()).replace(/-/g, "");
    const issueDateRaw = ctx.issueDate ? String(ctx.issueDate).replace(/-/g, "") : todayKst;
    const issuedate = issueDateRaw <= todayKst ? issueDateRaw : todayKst;

    // 공급연월일: 귀속월의 말일 (단, 작성일자보다 미래면 작성일자로 제한)
    const supplyDateRaw = writeDateOf(yearMonth);
    const supplydate = supplyDateRaw <= todayKst ? supplyDateRaw : todayKst;

    // 문서번호: 작성일자8자리 + 수급자DB키 + 하이픈 + 발행레코드ID 6자리
    const homemunseo_id = (issuedate + "-" + String(recipient.id || 0).padStart(4, "0") + String(issueRecord.id).padStart(6, "0")).slice(0, 30);

    // 품목 목록: ctx.items 우선, 없으면 recipient.items, 없으면 기본값
    const ctxItems = Array.isArray(ctx.items) && ctx.items.length > 0 ? ctx.items : null;
    const recipientItems = Array.isArray(recipient.items) && recipient.items.length > 0 ? recipient.items : null;
    const items = ctxItems || recipientItems || [
      {
        plantName: "전기안전관리비",
        fixedItemName: "",
        monthlySupply: issueRecord.totalSupply,
        monthlyTax: issueRecord.totalTax,
        note: "",
      },
    ];

    const taxdetailList = items.map(function (it) {
      const supply = Math.floor(Number(it.monthlySupply) || 0);
      const tax    = Math.floor(Number(it.monthlyTax) || 0);
      return {
        subject:     yearMonthPrefix(yearMonth) + (it.fixedItemName || it.plantName || "전기안전관리비"),
        quantity:    Number(it.quantity || 0).toFixed(2),
        unit:        "",
        unitprice:   String(Math.floor(Number(it.unitPrice) || 0)),
        supplyprice: String(supply),
        tax:         String(tax),
        gyymmdd:     supplydate,
        description: it.note || "",
      };
    });

    const body = {
      hometaxbill_id:  htId,
      spass:           htPass,
      apikey:          htKey,
      homemunseo_id:   homemunseo_id,
      signature:       "",
      issueid:         "",
      typecode1:       "01",
      typecode2:       "01",
      description:     "",
      issuedate:       issuedate,
      modifytype:      "",
      purposetype:     "02",
      originalissueid: "",
      si_id:           "",
      si_hcnt:         "",
      si_startdt:      "",
      si_enddt:        "",

      // 공급자
      ir_companynumber:     supplierBizNo,
      ir_biztype:           supplier.bizType  || "",
      ir_companyname:       supplier.corpName || "",
      ir_bizclassification: supplier.bizItem  || "",
      ir_taxnumber:         "",
      ir_ceoname:           supplier.ceoName  || "",
      ir_busename:          supplier.contactDept  || "",
      ir_name:              supplier.contactName  || supplier.ceoName || "",
      ir_cell:              supplier.contactPhone || "",
      ir_email:             supplier.email || "",
      ir_companyaddress:    supplier.address || "",

      // 공급받는자
      ie_companynumber:     recipientBizNo,
      ie_biztype:           recipient.bizType  || "",
      ie_companyname:       recipient.displayName || "",
      ie_bizclassification: recipient.bizItem  || "",
      ie_taxnumber:         "",
      partytypecode:        partytypecode,
      ie_ceoname:           recipient.ceoName  || "",
      ie_busename1:         "",
      ie_name1:             recipient.ceoName  || "",
      ie_cell1:             "",
      ie_email1:            recipient.email || "",
      ie_busename2:         "",
      ie_name2:             "",
      ie_cell2:             "",
      ie_email2:            "",
      ie_companyaddress:    recipient.address || "",

      // 수탁사업자 (미사용)
      su_companynumber: "", su_biztype: "",    su_companyname: "",
      su_bizclassification: "", su_taxnumber: "", su_ceoname: "",
      su_busename: "",      su_name: "",       su_cell: "",
      su_email: "",         su_companyaddress: "",

      // 금액 (명세서 기준: 모두 string 타입)
      cash:        "0",
      scheck:      "0",
      draft:       "0",
      uncollected: "0",
      chargetotal: String(Math.floor(Number(issueRecord.totalSupply) || 0)),
      taxtotal:    String(Math.floor(Number(issueRecord.totalTax) || 0)),
      grandtotal:  String(Math.floor((Number(issueRecord.totalSupply) || 0) + (Number(issueRecord.totalTax) || 0))),

      taxdetailList: taxdetailList,
    };

    console.log("[hometaxbill] 전송 body:", JSON.stringify(body, null, 2));

    try {
      const res = await httpPost("/homtax/post", body);

      const text = res.text;
      let json;
      try { json = JSON.parse(text); } catch (_) { json = {}; }

      if (res.status < 200 || res.status >= 300) {
        const msg = "hometaxbill HTTP 오류 " + res.status + ": " + text.slice(0, 200);
        console.error("[hometaxbill]", msg, "| homemunseo_id:", homemunseo_id);
        return { ok: false, message: msg };
      }

      if (String(json.code) === "0") {
        return {
          ok: true,
          message: "발행 성공: " + (json.msg || "") + (json.jsnumber ? " (접수번호: " + json.jsnumber + ")" : ""),
          confirmNum: json.jsnumber || json.homemunseo_id,
        };
      }

      const errMsg = "hometaxbill 오류 [" + json.code + "]: " + (json.msg || "");
      console.error("[hometaxbill]", errMsg, "| homemunseo_id:", homemunseo_id);
      return { ok: false, message: errMsg };

    } catch (e) {
      const msg = "hometaxbill 통신 오류: " + String(e && e.message || e);
      console.error("[hometaxbill]", msg);
      return { ok: false, message: msg };
    }
  }

  if (provider === "custom") {
    const url = String(process.env.HOMETAX_CUSTOM_WEBHOOK_URL || "").trim();
    if (!url) {
      return { ok: false, message: "HOMETAX_CUSTOM_WEBHOOK_URL 이 비어 있습니다." };
    }
    const res = await fetch(url, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        issueRecord,
        recipient: ctx.recipient || {},
        supplier:  ctx.supplier  || {},
        yearMonth: ctx.yearMonth || "",
      }),
    });
    const j = await res.json().catch(function () { return {}; });
    if (!res.ok) {
      return { ok: false, message: (j && j.message) || "웹훅 응답 오류 HTTP " + res.status };
    }
    return { ok: !!j.ok, message: (j && j.message) || "" };
  }

  if (process.env.HOMETAX_MOCK_FAIL === "1" || process.env.HOMETAX_MOCK_FAIL === "true") {
    return { ok: false, message: "HOMETAX_MOCK_FAIL 테스트용 전송 실패" };
  }

  return {
    ok: true,
    mock: true,
    message:
      "실제 홈택스 API 미연동: 앱 내 전송완료만 반영되었습니다. " +
      "HOMETAX_INVOICE_PROVIDER=hometaxbill 로 설정하면 실제 발행됩니다.",
  };
}

async function checkHometaxIssueStatus(ctx) {
  const provider = String(process.env.HOMETAX_INVOICE_PROVIDER || "").trim().toLowerCase();
  if (provider !== "hometaxbill") return { ok: false, declarestatus: null };

  const htId   = String(process.env.HOMETAXBILL_ID     || "").trim();
  const htPass = String(process.env.HOMETAXBILL_PASS   || "").trim();
  const htKey  = String(process.env.HOMETAXBILL_APIKEY || "").trim();
  if (!htId || !htPass || !htKey) return { ok: false, declarestatus: null };

  const body = {
    hometaxbill_id: htId,
    spass:          htPass,
    apikey:         htKey,
    homemunseo_id:  String(ctx.homemunseoId || ""),
  };

  try {
    const res = await httpPost("/homtax/getpkey", body);
    let json;
    try { json = JSON.parse(res.text); } catch (_) { json = {}; }
    if (res.status < 200 || res.status >= 300) {
      return { ok: false, declarestatus: null, message: "HTTP " + res.status };
    }
    return {
      ok: true,
      declarestatus: String(json.declarestatus || ""),
      msg:  json.msg  || "",
      msg2: json.msg2 || "",
    };
  } catch (e) {
    return { ok: false, declarestatus: null, message: String(e && e.message || e) };
  }
}

module.exports = { submitIssueRecordToHometax, checkHometaxIssueStatus };
