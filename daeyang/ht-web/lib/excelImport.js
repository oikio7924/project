/**
 * 대양 관리대장·전자세금계산서 엑셀 → 공급받는자 + 품목
 * (상호명, 주민/사업자번호, 공급가, 회원유형 등.)
 */
const XLSX = require("xlsx");

function cellStr(v) {
  if (v === undefined || v === null) return "";
  return String(v).trim();
}

function normHeader(s) {
  return cellStr(s).replace(/\s+/g, "");
}

function parseMoney(v) {
  const s = cellStr(v).replace(/,/g, "").replace(/\s/g, "");
  if (s === "") return 0;
  const n = parseFloat(s);
  return Number.isFinite(n) ? n : 0;
}

function normalizeBizNoKey(v) {
  const d = cellStr(v).replace(/\D/g, "");
  if (d.length === 10) return d;
  return "";
}

function normalizeResidentKey(v) {
  const d = cellStr(v).replace(/\D/g, "");
  if (d.length === 13) return d;
  return "";
}

function formatBizNoDisplay(digits) {
  if (digits.length !== 10) return digits;
  return digits.slice(0, 3) + "-" + digits.slice(3, 5) + "-" + digits.slice(5);
}

function formatResidentFromDigits(digits13) {
  if (digits13.length !== 13) return digits13;
  return digits13.slice(0, 6) + "-" + digits13.slice(6);
}

function parseMemberKindText(t) {
  const s = cellStr(t);
  if (!s) return null;
  if (s.includes("개인사업자")) return { kind: "business", bizSubtype: "sole" };
  if (s.includes("일반사업자")) return { kind: "business", bizSubtype: "sole" };
  if (s.includes("개인")) return { kind: "individual", bizSubtype: null };
  if (s.includes("비영리") || s.includes("국가기관"))
    return { kind: "business", bizSubtype: "nonprofit" };
  if (s.includes("발전사업자") || s.includes("법인"))
    return { kind: "business", bizSubtype: "corp" };
  return null;
}

function inferKind(memberText, hasBiz10, hasRes13) {
  const hint = parseMemberKindText(memberText);
  if (hasBiz10) {
    if (hint && hint.kind === "business")
      return { kind: "business", bizSubtype: hint.bizSubtype || "sole" };
    return { kind: "business", bizSubtype: "sole" };
  }
  if (hasRes13) return { kind: "individual", bizSubtype: null };
  if (hint) return hint;
  return { kind: "individual", bizSubtype: null };
}

function scoreColumnForField(headerNorm, field) {
  const h = headerNorm;
  switch (field) {
    case "bizNo":
      if (h.includes("주민")) return 0;
      if (h.includes("사업자등록번호")) return 100;
      if (h.includes("공급받는자") && (h.includes("등록번호") || h.includes("사업자"))) return 100;
      if (h.includes("매입") && h.includes("등록")) return 95;
      if (h.includes("사업자번호") && !h.includes("공급자")) return 55;
      if ((h === "등록번호" || h.includes("등록번호")) && !h.includes("공급자")) return 40;
      return 0;
    case "residentNo":
      if (h.includes("주민등록번호")) return 100;
      return 0;
    case "displayName":
      if (h.includes("상호명")) return 100;
      if (h.includes("공급받는자") && (h.includes("상호") || h.includes("법인명"))) return 95;
      if (h.includes("거래처")) return 75;
      if ((h.includes("상호") || h.includes("법인명")) && !h.includes("공급자")) return 70;
      return 0;
    case "ceoName":
      if (h.includes("대표자")) return 95;
      if (h.includes("공급받는자") && h.includes("성명")) return 90;
      if (h === "성명" && !h.includes("공급자")) return 50;
      return 0;
    case "address":
      if (h.includes("공급받는자") && (h.includes("주소") || h.includes("사업장"))) return 100;
      if (h.includes("사업장소재지") && !h.includes("공급자")) return 85;
      if (h.includes("주소") && !h.includes("공급자")) return 60;
      return 0;
    case "email":
      if (h.includes("이메일") || h.includes("e-mail") || h.includes("email")) return 85;
      return 0;
    case "memberType":
      if (h.includes("회원유형") || h.includes("회원구분") || h.includes("사업유형")) return 95;
      return 0;
    case "bizType":
      if (h.includes("업태") && !h.includes("공급자")) return 92;
      return 0;
    case "bizItem":
      if (h.includes("종목") && !h.includes("공급자")) return 92;
      return 0;
    case "plantName":
      /* 발전소명 열: 헤더가 정확히 '발전소명'일 때만(공백 제거 후 비교) */
      if (h === "발전소명") return 100;
      return 0;
    case "fixedItemName":
      /* 품목명 열: 헤더가 정확히 '품목명'일 때만 → DB 고정 품목명 */
      if (h === "품목명") return 100;
      return 0;
    case "contractInfo":
      if (h.includes("계약정보")) return 95;
      return 0;
    case "contractName":
      if (h.includes("계약명")) return 95;
      return 0;
    case "svcSafety":
      if (h.includes("안전관리")) return 90;
      return 0;
    case "svcTax":
      if (h === "세무" || h === "계약상세세무") return 90;
      return 0;
    case "svcBilling":
      if (h === "청구" || h === "계약상세청구") return 90;
      return 0;
    case "svcMonitoring":
      if (h.includes("모니터링")) return 90;
      return 0;
    case "paymentMethod":
      if (h.includes("결제방식") || h.includes("결제방법")) return 95;
      return 0;
    case "supply":
      if (h.includes("합계")) return 0;
      if (h.includes("공급가액")) return 100;
      if (h.includes("공급가")) return 98;
      if (h.includes("공급가격")) return 85;
      if (h === "금액" || h.includes("공급금액")) return 45;
      return 0;
    case "tax":
      if (h.includes("세액") && !h.includes("합계")) return 100;
      if (h.includes("부가세")) return 90;
      return 0;
    case "contactPhone":
      if (h.includes("휴대전화")) return 100;
      if (h.includes("휴대폰")) return 95;
      if (h === "연락처") return 80;
      if (h.includes("핸드폰")) return 90;
      return 0;
    case "receptionCapacity":
      if (h.includes("수전용량")) return 100;
      if (h.includes("수전")) return 80;
      return 0;
    case "generationCapacity":
      if (h.includes("태양광용량")) return 100;
      if (h.includes("발전용량")) return 100;
      if (h.includes("발전") && h.includes("kw")) return 95;
      return 0;
    case "recipientMemo":
      /* 관리 메모는 헤더가 정확히 '메모란' 또는 '메모'일 때만 허용 */
      if (h === "메모란") return 100;
      if (h === "메모") return 98;
      return 0;
    case "itemNote":
      if (h.includes("비고") && h.includes("품목")) return 99;
      if (h.includes("품목비고")) return 99;
      return 0;
    default:
      return 0;
  }
}

function mapHeaderRow(headerCells) {
  const fields = [
    "bizNo",
    "residentNo",
    "displayName",
    "ceoName",
    "address",
    "email",
    "contactPhone",
    "receptionCapacity",
    "generationCapacity",
    "memberType",
    "bizType",
    "bizItem",
    "plantName",
    "fixedItemName",
    "contractInfo",
    "contractName",
    "svcSafety",
    "svcTax",
    "svcBilling",
    "svcMonitoring",
    "paymentMethod",
    "supply",
    "tax",
    "recipientMemo",
    "itemNote",
  ];
  const scores = [];
  for (let c = 0; c < headerCells.length; c++) {
    const hn = normHeader(headerCells[c]);
    if (!hn) continue;
    for (let f = 0; f < fields.length; f++) {
      const field = fields[f];
      const sc = scoreColumnForField(hn, field);
      if (sc > 0) scores.push({ field, col: c, sc });
    }
  }
  scores.sort(function (a, b) {
    if (b.sc !== a.sc) return b.sc - a.sc;
    return b.col - a.col;
  });
  const colMap = {};
  const usedCols = {};
  const usedFields = {};
  for (let i = 0; i < scores.length; i++) {
    const x = scores[i];
    if (usedFields[x.field] || usedCols[x.col]) continue;
    usedFields[x.field] = true;
    usedCols[x.col] = true;
    colMap[x.field] = x.col;
  }
  return colMap;
}

function combineHeaderRows(row1, row2) {
  const len = Math.max((row1 || []).length, (row2 || []).length);
  const out = [];
  for (let c = 0; c < len; c++) {
    const a = normHeader(cellStr((row1 || [])[c]));
    const b = normHeader(cellStr((row2 || [])[c]));
    out.push(a + b || a || b || "");
  }
  return out;
}

function qualityColMap(cm) {
  let s = 0;
  if (cm.displayName !== undefined) s += 4;
  if (cm.supply !== undefined) s += 4;
  if (cm.bizNo !== undefined) s += 3;
  if (cm.residentNo !== undefined) s += 3;
  if (cm.tax !== undefined) s += 1;
  if (cm.plantName !== undefined || cm.fixedItemName !== undefined || cm.contractInfo !== undefined) s += 2;
  if (cm.memberType !== undefined) s += 1;
  return s;
}

function findBestHeaderRow(matrix) {
  const maxScan = Math.min(matrix.length, 50);
  let best = { score: -1, headerRow: 0, dataStartRow: 1, colMap: {} };
  for (let r = 0; r < maxScan; r++) {
    const row = matrix[r] || [];
    const next = matrix[r + 1] || [];
    const combined = combineHeaderRows(row, next);
    const cm1 = mapHeaderRow(row);
    const cm2 = mapHeaderRow(combined);
    const q1 = qualityColMap(cm1);
    const q2 = qualityColMap(cm2);
    if (q2 > q1 && q2 > best.score) {
      best = { score: q2, headerRow: r, dataStartRow: r + 2, colMap: cm2 };
    } else if (q1 > best.score) {
      best = { score: q1, headerRow: r, dataStartRow: r + 1, colMap: cm1 };
    }
  }
  return best;
}

function pickSheet(workbook) {
  const names = workbook.SheetNames || [];
  if (names.length === 0) return null;
  let best = { name: names[0], score: -1 };
  for (let i = 0; i < names.length; i++) {
    const sn = names[i];
    const sh = workbook.Sheets[sn];
    const matrix = XLSX.utils.sheet_to_json(sh, { header: 1, defval: "", raw: false });
    const h = findBestHeaderRow(matrix);
    if (h.score > best.score)
      best = {
        name: sn,
        score: h.score,
        matrix,
        headerRow: h.headerRow,
        dataStartRow: h.dataStartRow,
        colMap: h.colMap,
      };
  }
  if (best.matrix) return best;
  const sh = workbook.Sheets[names[0]];
  const matrix = XLSX.utils.sheet_to_json(sh, { header: 1, defval: "", raw: false });
  const h = findBestHeaderRow(matrix);
  return {
    name: names[0],
    score: h.score,
    matrix,
    headerRow: h.headerRow,
    dataStartRow: h.dataStartRow,
    colMap: h.colMap,
  };
}

function getCell(row, col) {
  if (col === undefined || col === null) return "";
  return row[col];
}

function parseWorkbookBuffer(buffer) {
  const workbook = XLSX.read(buffer, { type: "buffer", cellDates: true });
  const picked = pickSheet(workbook);
  if (!picked || !picked.matrix) {
    return { error: "엑셀 시트를 읽을 수 없습니다." };
  }
  const matrix = picked.matrix;
  const headerRow = picked.headerRow;
  const dataStartRow = picked.dataStartRow;
  let colMap = picked.colMap;
  if (!colMap || Object.keys(colMap).length === 0) {
    const combined = combineHeaderRows(matrix[headerRow] || [], matrix[headerRow + 1] || []);
    colMap = mapHeaderRow(combined.length ? combined : matrix[headerRow] || []);
  }

  const dataRows = [];

  for (let r = dataStartRow; r < matrix.length; r++) {
    const row = matrix[r] || [];

    const rawBiz = cellStr(getCell(row, colMap.bizNo));
    const rawRes = cellStr(getCell(row, colMap.residentNo));

    const digitsFromRow = normalizeBizNoKey(rawBiz);
    const resFromRow = normalizeResidentKey(rawRes);
    let bizDigits = digitsFromRow.length === 10 ? digitsFromRow : "";
    let resDigits = resFromRow.length === 13 ? resFromRow : "";

    if (digitsFromRow.length === 10) resDigits = "";
    else if (resFromRow.length === 13) bizDigits = "";

    const bizDisplay =
      bizDigits.length === 10
        ? formatBizNoDisplay(bizDigits)
        : rawBiz || "";
    const resDisplay =
      resDigits.length === 13
        ? cellStr(rawRes) || formatResidentFromDigits(resDigits)
        : "";

    const rawNameEarly = cellStr(getCell(row, colMap.displayName));
    const displayName = rawNameEarly;
    const ceoName = cellStr(getCell(row, colMap.ceoName));
    const address = cellStr(getCell(row, colMap.address));
    const email = cellStr(getCell(row, colMap.email));
    const contactPhone = cellStr(getCell(row, colMap.contactPhone));
    const receptionCapacity  = parseMoney(getCell(row, colMap.receptionCapacity));
    const generationCapacity = parseMoney(getCell(row, colMap.generationCapacity));
    const rawMem = cellStr(getCell(row, colMap.memberType));
    const rawBizType = cellStr(getCell(row, colMap.bizType));
    const rawBizItem = cellStr(getCell(row, colMap.bizItem));

    const plantRaw = cellStr(getCell(row, colMap.plantName));
    const fixedRaw = cellStr(getCell(row, colMap.fixedItemName));
    const supply = parseMoney(getCell(row, colMap.supply));
    const tax = colMap.tax !== undefined ? parseMoney(getCell(row, colMap.tax)) : NaN;

    const plantNameVal = plantRaw;

    const rawRecMemo = cellStr(getCell(row, colMap.recipientMemo));

    function isChecked(col) {
      const v = cellStr(getCell(row, col));
      return v !== "" && v !== "0";
    }
    const svcSafety  = isChecked(colMap.svcSafety);
    const svcTax     = isChecked(colMap.svcTax);
    const svcBilling = isChecked(colMap.svcBilling);

    // 모니터링 열: O/○/1 → DY, 그 외 텍스트("솔라링" 등) → 해당 텍스트, 빈값 → 미사용
    const monitoringRaw = cellStr(getCell(row, colMap.svcMonitoring));
    const svcMonitoring = monitoringRaw !== "" && monitoringRaw !== "0";
    var monitoringTypeFromExcel = "";
    if (svcMonitoring) {
      const mv = monitoringRaw.toUpperCase();
      if (mv === "O" || mv === "○" || mv === "1") {
        monitoringTypeFromExcel = "DY";
      } else {
        monitoringTypeFromExcel = monitoringRaw;
      }
    }

    // 결제방식: "자동이체(CMS)" → "cms", "직접송금" → "direct", 그 외 원문 보존
    const paymentRaw = cellStr(getCell(row, colMap.paymentMethod));
    const paymentMethod = paymentRaw;

    const hasBiz = bizDigits.length === 10;
    const hasRes = resDigits.length === 13;
    if (!hasBiz && !hasRes && !displayName && !plantNameVal && !fixedRaw && supply === 0) continue;

    const kindInfo = inferKind(rawMem, hasBiz, hasRes);

    const plantPart = plantNameVal;
    const item = {
      plantName: plantPart,
      fixedItemName: fixedRaw,
      monthlySupply: supply,
      monthlyTax: Number.isFinite(tax) ? tax : Math.floor(supply * 0.1),
      note: cellStr(getCell(row, colMap.itemNote)),
      receptionCapacity: receptionCapacity,
      generationCapacity: generationCapacity,
      internalMemo: rawRecMemo,
      svcSafety: isChecked(colMap.svcSafety),
      svcTax: isChecked(colMap.svcTax),
      svcBilling: isChecked(colMap.svcBilling),
      svcMonitoring: svcMonitoring,
      monitoringType: monitoringTypeFromExcel,
      paymentMethod: paymentMethod,
    };

    dataRows.push({
      bizDigits: bizDigits,
      residentDigits: resDigits,
      bizDisplay: bizDisplay,
      residentDisplay: resDisplay,
      displayName: displayName,
      ceoName: ceoName,
      address: address,
      email: email,
      contactPhone: contactPhone,
      receptionCapacity: receptionCapacity,
      generationCapacity: generationCapacity,
      bizType: rawBizType,
      bizItem: rawBizItem,
      internalMemo: rawRecMemo,
      svcSafety,
      svcTax,
      svcBilling,
      svcMonitoring,
      monitoringType: monitoringTypeFromExcel,
      paymentMethod,
      kind: kindInfo.kind,
      bizSubtype: kindInfo.bizSubtype,
      item: item,
    });
  }

  const groups = {};
  for (let i = 0; i < dataRows.length; i++) {
    const dr = dataRows[i];
    let key;
    if (dr.bizDigits.length === 10) key = "b:" + dr.bizDigits;
    else if (dr.residentDigits.length === 13) key = "r:" + dr.residentDigits;
    else key = "n:" + (dr.displayName || dr.bizDisplay || "이름없음");

    if (!groups[key]) {
      groups[key] = {
        key,
        bizDigits: dr.bizDigits,
        residentDigits: dr.residentDigits,
        bizDisplay: dr.bizDisplay,
        residentDisplay: dr.residentDisplay,
        displayName: dr.displayName,
        ceoName: dr.ceoName,
        address: dr.address,
        email: dr.email,
        contactPhone: dr.contactPhone || "",
        receptionCapacity:  dr.receptionCapacity  || 0,
        generationCapacity: dr.generationCapacity || 0,
        bizType: dr.bizType || "",
        bizItem: dr.bizItem || "",
        internalMemo: dr.internalMemo || "",
        svcSafety:     dr.svcSafety     || false,
        svcTax:        dr.svcTax        || false,
        svcBilling:    dr.svcBilling    || false,
        svcMonitoring: dr.svcMonitoring || false,
        monitoringType: dr.monitoringType || "",
        paymentMethod:  dr.paymentMethod  || "",
        kind: dr.kind,
        bizSubtype: dr.bizSubtype,
        items: [],
      };
    }
    const g = groups[key];
    if (!g.displayName && dr.displayName) g.displayName = dr.displayName;
    if (!g.bizDisplay && dr.bizDisplay) g.bizDisplay = dr.bizDisplay;
    if (!g.residentDisplay && dr.residentDisplay) g.residentDisplay = dr.residentDisplay;
    if (!g.ceoName && dr.ceoName) g.ceoName = dr.ceoName;
    if (!g.address && dr.address) g.address = dr.address;
    if (!g.email && dr.email) g.email = dr.email;
    if (!g.contactPhone && dr.contactPhone) g.contactPhone = dr.contactPhone;
    if (!g.receptionCapacity  && dr.receptionCapacity)  g.receptionCapacity  = dr.receptionCapacity;
    if (!g.generationCapacity && dr.generationCapacity) g.generationCapacity = dr.generationCapacity;
    if (!g.bizType && dr.bizType) g.bizType = dr.bizType;
    if (!g.bizItem && dr.bizItem) g.bizItem = dr.bizItem;
    if (dr.internalMemo) g.internalMemo = dr.internalMemo;
    if (dr.svcSafety)     g.svcSafety     = true;
    if (dr.svcTax)        g.svcTax        = true;
    if (dr.svcBilling)    g.svcBilling    = true;
    if (dr.svcMonitoring) g.svcMonitoring = true;
    if (dr.monitoringType) g.monitoringType = dr.monitoringType;
    if (dr.paymentMethod)  g.paymentMethod  = dr.paymentMethod;

    const it = dr.item;
    if (
      it.plantName ||
      cellStr(it.fixedItemName) ||
      it.monthlySupply !== 0 ||
      it.monthlyTax !== 0 ||
      it.note
    ) {
      g.items.push(it);
    }
  }

  const recipients = Object.keys(groups).map(function (k) {
    return groups[k];
  });

  return {
    sheetName: picked.name,
    headerRow: headerRow + 1,
    dataStartRow: dataStartRow + 1,
    colMap,
    recipients,
  };
}

module.exports = {
  parseWorkbookBuffer,
  normalizeBizNoKey,
  normalizeResidentKey,
  formatBizNoDisplay,
};
