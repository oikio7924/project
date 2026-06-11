package com.tx.hometax.controller;

import java.math.BigDecimal;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.tx.common.service.component.ComponentService;
import com.tx.hometax.dto.BillProviderDTO;
import com.tx.hometax.dto.BillRecipientDTO;
import com.tx.hometax.dto.BillPowerPlantDTO;
import com.tx.hometax.dto.BillPowerPlantRecipientContractDTO;
import com.tx.hometax.dto.BillUserDTO;
import com.tx.hometax.dto.BillInvoiceLogDTO;
import org.codehaus.jackson.map.ObjectMapper;

/**
 * hometax 전용 메인·메뉴 페이지 (달력, 공급자, 공급받는자, 발행내역)
 * 진입 URL: /bill.do
 */
@Controller
public class HometaxController {

    @Autowired
    private ComponentService Component;
    private static final String BIZ_LICENSE_DIR = ".hometax/biz-license";

    /** 메인 = 달력 */
    @RequestMapping("/bill.do")
    public ModelAndView main(HttpServletRequest req) {
        ModelAndView mv = new ModelAndView("/hometax/main/hometax_main");
        try {
            Calendar cal = Calendar.getInstance();
            int y = cal.get(Calendar.YEAR);
            int m = cal.get(Calendar.MONTH) + 1;
            cal.set(y, m - 1, 1);
            String startDate = String.format("%04d-%02d-%02d", y, m, 1);
            int lastDay = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
            String endDate = String.format("%04d-%02d-%02d", y, m, lastDay);
            Map<String, String> param = new HashMap<>();
            param.put("startDate", startDate);
            param.put("endDate", endDate);
            Integer total = Component.getCount("hometax.countInvoiceLogByMonth", param);
            Integer completed = Component.getCount("hometax.countInvoiceLogCompletedByMonth", param);
            mv.addObject("monthInvoiceTotal", total != null ? total : 0);
            mv.addObject("monthInvoiceCompleted", completed != null ? completed : 0);
        } catch (Exception e) {
            mv.addObject("monthInvoiceTotal", 0);
            mv.addObject("monthInvoiceCompleted", 0);
        }
        return mv;
    }

    /** 공급자 목록 */
    @RequestMapping("/bill/supplier.do")
    public ModelAndView supplier(HttpServletRequest req) {
        ModelAndView mv = new ModelAndView("/hometax/supplier/hometax_supplier_list");
        try {
            List<BillProviderDTO> list = Component.getList("hometax.selectProviderList", null);
            mv.addObject("providerList", list != null ? list : java.util.Collections.emptyList());
        } catch (Exception e) {
            mv.addObject("providerList", java.util.Collections.emptyList());
        }
        return mv;
    }

    /** 공급자 저장 (등록/수정) */
    @RequestMapping(value = "/bill/supplier/save.do", method = RequestMethod.POST)
    public ModelAndView supplierSave(@ModelAttribute BillProviderDTO dto, RedirectAttributes ra) {
        try {
            if (dto.getId() != null && dto.getId() > 0) {
                Component.updateData("hometax.updateProvider", dto);
                ra.addFlashAttribute("message", "수정되었습니다.");
            } else {
                if (dto.getUseYn() == null || dto.getUseYn().isEmpty()) dto.setUseYn("Y");
                Component.createData("hometax.insertProvider", dto);
                ra.addFlashAttribute("message", "등록되었습니다.");
            }
        } catch (Exception e) {
            ra.addFlashAttribute("message", "저장 실패: " + e.getMessage());
        }
        return new ModelAndView("redirect:/bill/supplier.do");
    }

    /** 공급자 삭제 */
    @RequestMapping("/bill/supplier/delete.do")
    public ModelAndView supplierDelete(@RequestParam("id") Integer id, RedirectAttributes ra) {
        try {
            Map<String, Object> param = new HashMap<>();
            param.put("id", id);
            Component.deleteData("hometax.deleteProvider", param);
            ra.addFlashAttribute("message", "삭제되었습니다.");
        } catch (Exception e) {
            ra.addFlashAttribute("message", "삭제 실패: " + e.getMessage());
        }
        return new ModelAndView("redirect:/bill/supplier.do");
    }

    /** 공급자 선택 삭제 */
    @RequestMapping(value = "/bill/supplier/deleteSelected.do", method = RequestMethod.POST)
    public ModelAndView supplierDeleteSelected(
            @RequestParam(value = "ids", required = false) List<Integer> ids,
            RedirectAttributes ra) {
        try {
            if (ids == null || ids.isEmpty()) {
                ra.addFlashAttribute("message", "삭제할 공급자를 선택하세요.");
            } else {
                Map<String, Object> param = new HashMap<>();
                param.put("ids", ids);
                Component.deleteData("hometax.deleteProviders", param);
                ra.addFlashAttribute("message", "삭제되었습니다.");
            }
        } catch (Exception e) {
            ra.addFlashAttribute("message", "삭제 실패: " + e.getMessage());
        }
        return new ModelAndView("redirect:/bill/supplier.do");
    }

    /** 공급받는자 목록 */
    @RequestMapping("/bill/recipient.do")
    public ModelAndView recipient(HttpServletRequest req) {
        ModelAndView mv = new ModelAndView("/hometax/recipient/hometax_recipient_list");
        try {
            // 그리드 기본값(연도)
            int gridYear = Calendar.getInstance().get(Calendar.YEAR);
            String yearParam = req.getParameter("year");
            if (yearParam != null && !yearParam.trim().isEmpty()) {
                try { gridYear = Integer.parseInt(yearParam.trim()); } catch (Exception ignore) {}
            }

            mv.addObject("gridYear", gridYear);

            // 공급받는자(발전소-공급받는자 계약) 그리드 데이터
            Map<String, Object> contractParam = new HashMap<>();
            contractParam.put("contractYear", gridYear);
            List<BillPowerPlantRecipientContractDTO> contractRows =
                    Component.getList("hometax.selectPowerPlantRecipientContractGridAll", contractParam);

            // 발행완료(O): ht_bill_invoice_log 의 power_plant_id + send_yn='Y'
            Map<String, Object> invParam = new HashMap<>();
            invParam.put("contractYear", gridYear);
            List<BillInvoiceLogDTO> invoiceLogs =
                    Component.getList("hometax.selectInvoiceLogListByYear", invParam);

            Map<String, Set<Integer>> sentMonthsMap = new HashMap<>(); // key: powerPlantId-recipientId
            if (invoiceLogs != null) {
                for (BillInvoiceLogDTO log : invoiceLogs) {
                    if (log == null) continue;
                    if (log.getRecipientId() == null) continue;
                    if (log.getPowerPlantId() == null) continue;
                    if (!"Y".equalsIgnoreCase(log.getSendYn())) continue;

                    String issue = log.getIssueDate();
                    if (issue == null || issue.length() < 6) continue; // yyyyMMdd
                    int y;
                    int m;
                    try {
                        y = Integer.parseInt(issue.substring(0, 4));
                        m = Integer.parseInt(issue.substring(4, 6));
                    } catch (Exception ignore) { continue; }

                    if (y != gridYear) continue;
                    if (m < 1 || m > 12) continue;

                    String key = log.getPowerPlantId() + "-" + log.getRecipientId();
                    sentMonthsMap.computeIfAbsent(key, k -> new HashSet<>()).add(m);
                }
            }

            // JSP 그리드 포맷에 맞춰 row Map 구성
            List<Map<String, Object>> gridRows = new ArrayList<>();
            int no = 1;
            if (contractRows != null) {
                for (BillPowerPlantRecipientContractDTO c : contractRows) {
                    if (c == null) continue;
                    Map<String, Object> row = new HashMap<>();
                    row.put("contractId", c.getId());
                    row.put("no", no++);
                    row.put("providerId", c.getPowerPlantId()); // JSP: 발전소번호
                    row.put("recipientId", c.getRecipientId());
                    row.put("powerPlantName", c.getPowerPlantName());

                    String idValue = "";
                    if ("01".equals(c.getRecipientType())) {
                        idValue = c.getCorpNum();
                    } else {
                        idValue = c.getIdNum();
                    }
                    row.put("idValue", idValue != null ? idValue : "");

                    row.put("corpName", c.getCorpName());
                    row.put("recipientType", c.getRecipientType());
                    row.put("taxNum", c.getTaxNum());
                    row.put("bizType", c.getBizType());
                    row.put("bizClassification", c.getBizClassification());
                    row.put("ceoName", c.getCeoName());
                    row.put("contactName", c.getContactName());
                    row.put("contactPhone", c.getContactPhone());
                    row.put("contactEmail", c.getContactEmail());
                    row.put("address", c.getAddress());
                    row.put("email", c.getEmail());

                    String key = (c.getPowerPlantId() != null ? c.getPowerPlantId() : -1) + "-" + (c.getRecipientId() != null ? c.getRecipientId() : -1);
                    Set<Integer> sentSet = sentMonthsMap.getOrDefault(key, java.util.Collections.emptySet());
                    row.put("sentMonths", new ArrayList<>(sentSet));

                    row.put("supplyTotal", c.getSupplyTotal() != null ? c.getSupplyTotal() : BigDecimal.ZERO);
                    row.put("taxTotal", c.getTaxTotal() != null ? c.getTaxTotal() : BigDecimal.ZERO);
                    row.put("grandTotal", c.getGrandTotal() != null ? c.getGrandTotal() : BigDecimal.ZERO);
                    row.put("itemName", c.getItemName() != null ? c.getItemName() : "");
                    row.put("itemNo", c.getItemNo() != null ? c.getItemNo() : 1);

                    String approvalNo = "";
                    try {
                        Map<String, Object> apParam = new HashMap<>();
                        apParam.put("powerPlantId", c.getPowerPlantId());
                        apParam.put("recipientId", c.getRecipientId());
                        apParam.put("contractYear", gridYear);
                        Object av = Component.getData("hometax.selectLatestInvoiceApprovalNo", apParam);
                        if (av != null) {
                            String s = String.valueOf(av).trim();
                            if (!s.isEmpty()) {
                                approvalNo = s;
                            }
                        }
                    } catch (Exception ignore) { /* approval_no 컬럼 미적용·조회 없음 */ }
                    row.put("approvalNo", approvalNo);

                    gridRows.add(row);
                }
            }
            mv.addObject("gridRows", gridRows);

            // 기존 폼(JS/엑셀 업로드) 호환용 데이터(현재 그리드 화면만 보여도 필요할 수 있음)
            List<BillProviderDTO> providers = Component.getList("hometax.selectProviderList", null);
            mv.addObject("providerList", providers != null ? providers : java.util.Collections.emptyList());

            HttpSession session = req.getSession(false);
            if (session != null) {
                Object v = session.getAttribute(HometaxLoginController.getDefaultProviderSessionKey());
                if (v instanceof Integer) {
                    mv.addObject("defaultProviderId", (Integer) v);
                } else if (v != null) {
                    try {
                        mv.addObject("defaultProviderId", Integer.valueOf(String.valueOf(v)));
                    } catch (Exception ignore) { /* ignore */ }
                }

                Object userId = session.getAttribute("HOMETAX_USER_ID");
                if (userId != null) {
                    try {
                        Map<String, Object> u = new HashMap<>();
                        u.put("id", Integer.valueOf(String.valueOf(userId)));
                        BillUserDTO user = Component.getData("hometax.selectBillUserById", u);
                        if (user != null) {
                            mv.addObject("loginUserDepartment", user.getDepartment());
                            mv.addObject("loginUserPhone", user.getPhone());
                            mv.addObject("loginUserEmail", user.getEmail());
                        }
                    } catch (Exception ignore) { /* ignore */ }
                }
            }
        } catch (Exception e) {
            mv.addObject("powerPlantList", java.util.Collections.emptyList());
            mv.addObject("providerList", java.util.Collections.emptyList());
            mv.addObject("gridRows", java.util.Collections.emptyList());
        }
        return mv;
    }

    /** 공급받는자 저장 (등록/수정) */
    @RequestMapping(value = "/bill/recipient/save.do", method = RequestMethod.POST)
    public ModelAndView recipientSave(@ModelAttribute BillRecipientDTO dto, RedirectAttributes ra) {
        try {
            if (dto.getId() != null && dto.getId() > 0) {
                Component.updateData("hometax.updateRecipient", dto);
                ra.addFlashAttribute("message", "수정되었습니다.");
            } else {
                if (dto.getUseYn() == null || dto.getUseYn().isEmpty()) dto.setUseYn("Y");
                Component.createData("hometax.insertRecipient", dto);
                ra.addFlashAttribute("message", "등록되었습니다.");
            }
        } catch (Exception e) {
            ra.addFlashAttribute("message", "저장 실패: " + e.getMessage());
        }
        return new ModelAndView("redirect:/bill/recipient.do");
    }

    /** 공급받는자 그리드 저장(공급가액/세액/합계/품목) */
    @RequestMapping(value = "/bill/recipient/gridSave.do", method = RequestMethod.POST)
    public void recipientGridSave(
            @RequestParam(value = "rowsJson", required = false) String rowsJson,
            @RequestParam(value = "contractYear", required = false) Integer contractYear,
            HttpServletResponse resp) throws java.io.IOException {

        Map<String, Object> result = new HashMap<>();
        if (contractYear == null) {
            contractYear = Calendar.getInstance().get(Calendar.YEAR);
        }
        if (rowsJson == null || rowsJson.trim().isEmpty()) {
            result.put("message", "저장할 행을 선택하세요.");
            writeJsonResponse(resp, result);
            return;
        }

        int success = 0;
        int fail = 0;
        String firstFail = null;
        try {
            ObjectMapper mapper = new ObjectMapper();
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> rows = mapper.readValue(rowsJson, List.class);
            if (rows == null || rows.isEmpty()) {
                result.put("message", "저장할 행을 선택하세요.");
                writeJsonResponse(resp, result);
                return;
            }

            List<Map<String, Object>> normalizedRows = new ArrayList<>();
            java.util.LinkedHashMap<String, Map<String, Object>> groupMap = new java.util.LinkedHashMap<>();
            for (Map<String, Object> row : rows) {
                try {
                    if (row == null) continue;
                    Integer ppId = toInt(row.get("powerPlantId"));
                    Integer rcId = toInt(row.get("recipientId"));
                    if (ppId == null || rcId == null) continue;
                    Integer itemNo = toInt(row.get("itemNo"));
                    if (itemNo == null || itemNo < 1) itemNo = 1;

                    Map<String, Object> nrow = new HashMap<>();
                    nrow.put("powerPlantId", ppId);
                    nrow.put("recipientId", rcId);
                    nrow.put("itemNo", itemNo);
                    nrow.put("itemName", row.get("itemName"));
                    nrow.put("supplyTotal", row.get("supplyTotal"));
                    nrow.put("taxTotal", row.get("taxTotal"));
                    nrow.put("grandTotal", row.get("grandTotal"));
                    normalizedRows.add(nrow);

                    String key = ppId + ":" + rcId;
                    if (!groupMap.containsKey(key)) {
                        Map<String, Object> g = new HashMap<>();
                        g.put("powerPlantId", ppId);
                        g.put("recipientId", rcId);
                        g.put("contractYear", contractYear);
                        groupMap.put(key, g);
                    }
                } catch (Exception e) {
                    fail++;
                    if (firstFail == null) firstFail = e.getMessage();
                }
            }

            // 삭제된 품목행 반영을 위해 그룹 단위로 기존 항목 정리 후 재저장
            for (Map<String, Object> g : groupMap.values()) {
                Component.deleteData("hometax.deletePowerPlantRecipientContractItems", g);
            }

            for (Map<String, Object> row : normalizedRows) {
                try {
                    Integer ppId = toInt(row.get("powerPlantId"));
                    Integer rcId = toInt(row.get("recipientId"));

                    BillPowerPlantRecipientContractDTO c = new BillPowerPlantRecipientContractDTO();
                    c.setPowerPlantId(ppId);
                    c.setRecipientId(rcId);
                    c.setContractYear(contractYear);
                    c.setItemNo(toInt(row.get("itemNo")) != null ? toInt(row.get("itemNo")) : 1);
                    c.setSupplyTotal(toBigDecimal(row.get("supplyTotal")));
                    c.setTaxTotal(toBigDecimal(row.get("taxTotal")));
                    c.setGrandTotal(toBigDecimal(row.get("grandTotal")));
                    c.setItemName(row.get("itemName") != null ? String.valueOf(row.get("itemName")).trim() : "");
                    c.setUseYn("Y");

                    Component.createData("hometax.insertPowerPlantRecipientContract", c);
                    success++;
                } catch (Exception e) {
                    fail++;
                    if (firstFail == null) firstFail = e.getMessage();
                }
            }
        } catch (Exception e) {
            result.put("message", "저장 실패: " + e.getMessage());
            writeJsonResponse(resp, result);
            return;
        }

        String msg = "저장 완료: 성공 " + success + "건";
        if (fail > 0) {
            msg += " / 실패 " + fail + "건";
            if (!isBlank(firstFail)) msg += " (첫 실패: " + firstFail + ")";
        }
        result.put("message", msg);
        result.put("successCount", success);
        result.put("failCount", fail);
        writeJsonResponse(resp, result);
    }

    /** 계약자 관리(발전소) 목록 */
    @RequestMapping("/bill/contractor.do")
    public ModelAndView contractor(HttpServletRequest req) {
        ModelAndView mv = new ModelAndView("/hometax/contractor/hometax_contractor_list");
        try {
            int contractYear = Calendar.getInstance().get(Calendar.YEAR);
            String yearParam = req.getParameter("year");
            if (yearParam != null && !yearParam.trim().isEmpty()) {
                try { contractYear = Integer.parseInt(yearParam.trim()); } catch (Exception ignore) {}
            }
            mv.addObject("contractYear", contractYear);

            List<BillPowerPlantDTO> list = Component.getList("hometax.selectPowerPlantList", null);
            mv.addObject("powerPlantList", list != null ? list : java.util.Collections.emptyList());
        } catch (Exception e) {
            mv.addObject("powerPlantList", java.util.Collections.emptyList());
            mv.addObject("contractYear", Calendar.getInstance().get(Calendar.YEAR));
        }
        return mv;
    }

    /** 계약자 저장(등록/수정) + 공급받는자 자동 동기화 */
    @RequestMapping(value = "/bill/contractor/save.do", method = RequestMethod.POST)
    public ModelAndView contractorSave(
            HttpServletRequest req,
            @ModelAttribute BillPowerPlantDTO dto,
            @RequestParam(value = "bizLicensePdf", required = false) MultipartFile bizLicensePdf,
            RedirectAttributes ra) {
        try {
            BillPowerPlantDTO before = null;
            if (dto.getId() != null && dto.getId() > 0) {
                before = getPowerPlantById(dto.getId());
            }
            if (before != null && isBlank(dto.getBizLicenseFile())) {
                dto.setBizLicenseFile(before.getBizLicenseFile());
            }
            if (bizLicensePdf != null && !bizLicensePdf.isEmpty()) {
                String saved = saveBizLicensePdf(bizLicensePdf);
                dto.setBizLicenseFile(saved);
            }

            if (dto.getId() != null && dto.getId() > 0) {
                Component.updateData("hometax.updatePowerPlant", dto);
                syncRecipientFromPowerPlant(req, dto);
                ra.addFlashAttribute("message", "수정되었습니다.");
            } else {
                if (dto.getUseYn() == null || dto.getUseYn().isEmpty()) dto.setUseYn("Y");
                if (dto.getPartyType() == null || dto.getPartyType().isEmpty()) dto.setPartyType("01");
                Component.createData("hometax.insertPowerPlant", dto);
                syncRecipientFromPowerPlant(req, dto);
                ra.addFlashAttribute("message", "등록되었습니다.");
            }
        } catch (Exception e) {
            ra.addFlashAttribute("message", "저장 실패: " + e.getMessage());
        }
        return new ModelAndView("redirect:/bill/contractor.do");
    }

    /** 계약자 사업자등록증 PDF 브라우저 보기 */
    @RequestMapping(value = "/bill/contractor/license/view.do", method = RequestMethod.GET)
    public void contractorBizLicenseView(
            @RequestParam(value = "id", required = false) Integer id,
            HttpServletResponse resp) throws IOException {
        if (id == null || id <= 0) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        BillPowerPlantDTO p = getPowerPlantById(id);
        if (p == null || isBlank(p.getBizLicenseFile())) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        Path f = getBizLicenseDirPath().resolve(p.getBizLicenseFile()).normalize();
        if (!Files.exists(f) || !Files.isRegularFile(f)) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        resp.setContentType("application/pdf");
        resp.setHeader("Content-Disposition", "inline; filename=\"biz-license.pdf\"");
        Files.copy(f, resp.getOutputStream());
    }

    /** 계약자 저장 시 공급받는자 자동 반영 (기본 공급자 + 상호명 + 주소 기준 업서트) */
    private void syncRecipientFromPowerPlant(HttpServletRequest req, BillPowerPlantDTO p) {
        try {
            if (p == null) return;
            HttpSession session = req != null ? req.getSession(false) : null;
            Integer providerId = null;
            if (session != null) {
                Object v = session.getAttribute(HometaxLoginController.getDefaultProviderSessionKey());
                if (v != null) {
                    try { providerId = Integer.valueOf(String.valueOf(v)); } catch (Exception ignore) {}
                }
            }
            // 세션에 default_provider_id가 비어있는 경우(테이블 재생성/로그인 상태 등)도 대비
            if (providerId == null && session != null) {
                try {
                    Object userId = session.getAttribute("HOMETAX_USER_ID");
                    if (userId != null) {
                        Map<String, Object> u = new HashMap<>();
                        u.put("id", Integer.valueOf(String.valueOf(userId)));
                        BillUserDTO user = Component.getData("hometax.selectBillUserById", u);
                        if (user != null) providerId = user.getDefaultProviderId();
                    }
                } catch (Exception ignore) {}
            }
            if (providerId == null) {
                System.err.println("[syncRecipientFromPowerPlant] defaultProviderId is null. recipient sync skipped.");
                return;
            }

            BillRecipientDTO r = new BillRecipientDTO();
            r.setProviderId(providerId);
            r.setRecipientType("02".equals(p.getPartyType()) ? "02" : "01");
            r.setCorpName(p.getCorpName());
            r.setCeoName(p.getCeoName());
            r.setAddress(p.getAddress());
            r.setEmail(p.getEmail());
            r.setUseYn(isBlank(p.getUseYn()) ? "Y" : p.getUseYn());
            r.setContactPhone(p.getMobilePhone());
            if ("02".equals(r.getRecipientType())) {
                r.setIdNum(p.getIdNum());
                r.setCorpNum(null);
                r.setBizType(null);
                r.setBizClassification(null);
            } else {
                r.setCorpNum(p.getCorpNum());
                r.setIdNum(null);
                // 계약자(발전소) 마스터의 업태/업종을 공급받는자에 반영 (기존에는 exists만 유지해 NULL 고정됨)
                r.setBizType(p.getBizType());
                r.setBizClassification(p.getBizClassification());
            }

            BillRecipientDTO exists = null;
            if (p.getId() != null && p.getId() > 0) {
                Map<String, Object> byPowerPlant = new HashMap<>();
                byPowerPlant.put("powerPlantId", p.getId());
                exists = Component.getData("hometax.selectRecipientByPowerPlantLatest", byPowerPlant);
            }
            if (exists == null) {
                Map<String, Object> byIdentity = new HashMap<>();
                byIdentity.put("providerId", providerId);
                byIdentity.put("recipientType", r.getRecipientType());
                byIdentity.put("corpNum", r.getCorpNum());
                byIdentity.put("idNum", r.getIdNum());
                exists = Component.getData("hometax.selectRecipientByProviderAndIdentity", byIdentity);
            }
            if (exists == null) {
                Map<String, Object> key = new HashMap<>();
                key.put("providerId", providerId);
                key.put("corpName", p.getCorpName());
                key.put("address", p.getAddress());
                exists = Component.getData("hometax.selectRecipientByProviderAndNameAddress", key);
            }

            Integer recipientId;
            if (exists != null && exists.getId() != null) {
                // 기존 연락 담당자·세금계산서 등은 유지, 식별/기본정보는 계약자(p) 기준 동기화
                r.setId(exists.getId());
                r.setTaxNum(exists.getTaxNum());
                r.setContactName(exists.getContactName());
                r.setContactEmail(exists.getContactEmail());
                if (isBlank(r.getContactPhone())) r.setContactPhone(exists.getContactPhone());
                Component.updateData("hometax.updateRecipient", r);
                recipientId = exists.getId();
            } else {
                Component.createData("hometax.insertRecipient", r);
                recipientId = r.getId();
            }

            // 공급받는자 그리드 노출을 위해 계약자-공급받는자 연결 row(당해연도)도 보장
            if (p.getId() != null && p.getId() > 0 && recipientId != null && recipientId > 0) {
                BillPowerPlantRecipientContractDTO c = new BillPowerPlantRecipientContractDTO();
                c.setPowerPlantId(p.getId());
                c.setRecipientId(recipientId);
                c.setContractYear(Calendar.getInstance().get(Calendar.YEAR));
                c.setSupplyTotal(BigDecimal.ZERO);
                c.setTaxTotal(BigDecimal.ZERO);
                c.setGrandTotal(BigDecimal.ZERO);
                c.setUseYn("Y");
                Component.createData("hometax.insertPowerPlantRecipientContract", c);
            }
        } catch (Exception ignore) {
            // 계약자 저장 실패로 전파하지 않음 (보조 동기화)
        }
    }

    /** 계약자(발전소) 일괄 삭제 */
    @RequestMapping(value = "/bill/contractor/delete.do", method = RequestMethod.POST)
    public ModelAndView contractorDeleteSelected(
            @RequestParam(value = "ids", required = false) List<Integer> ids,
            RedirectAttributes ra) {
        try {
            if (ids == null || ids.isEmpty()) {
                ra.addFlashAttribute("message", "삭제할 발전소를 선택하세요.");
            } else {
                Map<String, Object> param = new HashMap<>();
                param.put("ids", ids);
                // 삭제시 계약금액 데이터도 같이 제거 (그리드 join 기준이 power_plant_id)
                Component.deleteData("hometax.deletePowerPlantContractsByIds", param);
                Component.deleteData("hometax.deletePowerPlants", param);
                ra.addFlashAttribute("message", "삭제되었습니다.");
            }
        } catch (Exception e) {
            ra.addFlashAttribute("message", "삭제 실패: " + e.getMessage());
        }
        return new ModelAndView("redirect:/bill/contractor.do");
    }

    /** 계약자 관리: 엑셀로 계약자(발전소) 정보 일괄 등록 - 발전소 선택 없이 엑셀만으로 등록 */
    @RequestMapping(value = "/bill/contractor/importContractorExcel.do", method = RequestMethod.POST)
    public ModelAndView contractorImportContractorExcel(
            HttpServletRequest req,
            @RequestParam(value = "excelFile", required = false) MultipartFile excelFile,
            RedirectAttributes ra) {

        if (excelFile == null || excelFile.isEmpty()) {
            ra.addFlashAttribute("message", "엑셀 파일을 선택하세요.");
            return new ModelAndView("redirect:/bill/contractor.do");
        }

        int total = 0;
        int success = 0;
        int fail = 0;
        String firstFailMsg = null;

        try (XSSFWorkbook wb = new XSSFWorkbook(excelFile.getInputStream())) {
            Sheet sheet = wb.getNumberOfSheets() > 0 ? wb.getSheetAt(0) : null;
            if (sheet == null) {
                ra.addFlashAttribute("message", "엑셀 시트가 없습니다.");
                return new ModelAndView("redirect:/bill/contractor.do");
            }

            DataFormatter fmt = new DataFormatter();
            Row headerRow = sheet.getRow(0);
            if (headerRow == null) {
                ra.addFlashAttribute("message", "엑셀 1행(헤더)이 비어있습니다.");
                return new ModelAndView("redirect:/bill/contractor.do");
            }

            int colMemberType = -1, colPartyType = -1, colBizOwnerType = -1, colCorpName = -1, colCeoName = -1;
            int colCorpNum = -1, colBizType = -1, colBizClassification = -1, colIdNum = -1, colMobilePhone = -1, colEmail = -1, colAddress = -1;
            int colPaymentMethod = -1, colContractInfo = -1, colContractDetail = -1, colMonitoring = -1, colMemo = -1, colUseYn = -1;

            for (int c = 0; c < headerRow.getLastCellNum(); c++) {
                String v = fmt.formatCellValue(headerRow.getCell(c));
                if (v == null) v = "";
                String vn = v.trim().replace(" ", "");
                if (vn.contains("회원유형")) colMemberType = c;
                else if (vn.contains("구분") && !vn.contains("사업자구분")) colPartyType = c;
                else if (vn.contains("사업자구분")) colBizOwnerType = c;
                else if (vn.contains("상호명") || vn.equals("상호")) colCorpName = c;
                else if (vn.contains("대표자")) colCeoName = c;
                else if (vn.contains("사업자등록번호") || vn.contains("사업자번호")) colCorpNum = c;
                else if (vn.contains("업태")) colBizType = c;
                else if (vn.contains("업종")) colBizClassification = c;
                else if (vn.contains("주민등록번호") || vn.contains("주민번호")) colIdNum = c;
                else if (vn.contains("휴대전화") || vn.contains("연락처") || vn.contains("전화")) colMobilePhone = c;
                else if (vn.contains("이메일") || vn.equals("email")) colEmail = c;
                else if (vn.contains("주소")) colAddress = c;
                else if (vn.contains("결제방식")) colPaymentMethod = c;
                else if (vn.contains("계약정보")) colContractInfo = c;
                else if (vn.contains("계약상세")) colContractDetail = c;
                else if (vn.contains("모니터링")) colMonitoring = c;
                else if (vn.contains("메모")) colMemo = c;
                else if (vn.contains("사용")) colUseYn = c;
                else if ((vn.equals("이름") || vn.equals("성명")) && colCorpName < 0) colCorpName = c;
            }

            if (colCorpName < 0) {
                ra.addFlashAttribute("message", "엑셀 헤더에 상호명(또는 이름/성명) 컬럼이 필요합니다.");
                return new ModelAndView("redirect:/bill/contractor.do");
            }

            for (int r = 1; r <= sheet.getLastRowNum(); r++) {
                Row row = sheet.getRow(r);
                if (row == null) continue;

                String memberType = colMemberType >= 0 ? fmt.formatCellValue(row.getCell(colMemberType)).trim() : "";
                String partyType = colPartyType >= 0 ? fmt.formatCellValue(row.getCell(colPartyType)).trim() : "";
                String bizOwnerType = colBizOwnerType >= 0 ? fmt.formatCellValue(row.getCell(colBizOwnerType)).trim() : "";
                String corpName = colCorpName >= 0 ? fmt.formatCellValue(row.getCell(colCorpName)).trim() : "";
                String ceoName = colCeoName >= 0 ? fmt.formatCellValue(row.getCell(colCeoName)).trim() : "";
                String corpNum = colCorpNum >= 0 ? fmt.formatCellValue(row.getCell(colCorpNum)).trim() : "";
                String bizType = colBizType >= 0 ? fmt.formatCellValue(row.getCell(colBizType)).trim() : "";
                String bizClassification = colBizClassification >= 0 ? fmt.formatCellValue(row.getCell(colBizClassification)).trim() : "";
                String idNum = colIdNum >= 0 ? fmt.formatCellValue(row.getCell(colIdNum)).trim() : "";
                String mobilePhone = colMobilePhone >= 0 ? fmt.formatCellValue(row.getCell(colMobilePhone)).trim() : "";
                String email = colEmail >= 0 ? fmt.formatCellValue(row.getCell(colEmail)).trim() : "";
                String address = colAddress >= 0 ? fmt.formatCellValue(row.getCell(colAddress)).trim() : "";
                String paymentMethod = colPaymentMethod >= 0 ? fmt.formatCellValue(row.getCell(colPaymentMethod)).trim() : "";
                String contractInfo = colContractInfo >= 0 ? fmt.formatCellValue(row.getCell(colContractInfo)).trim() : "";
                String contractDetail = colContractDetail >= 0 ? fmt.formatCellValue(row.getCell(colContractDetail)).trim() : "";
                String monitoring = colMonitoring >= 0 ? fmt.formatCellValue(row.getCell(colMonitoring)).trim() : "";
                String memo = colMemo >= 0 ? fmt.formatCellValue(row.getCell(colMemo)).trim() : "";
                String useYn = colUseYn >= 0 ? fmt.formatCellValue(row.getCell(colUseYn)).trim() : "";

                if (corpName == null || corpName.isEmpty()) continue;
                total++;

                try {
                    BillPowerPlantDTO dto = new BillPowerPlantDTO();
                    String memberTypeNorm = isBlank(memberType) ? "" : memberType.replace(" ", "");
                    dto.setMemberType(isBlank(memberType) ? null : memberType);

                    // 회원유형 우선 매핑: 개인/개인사업자/법인사업자
                    if ("개인".equals(memberTypeNorm)) {
                        dto.setPartyType("02");
                        dto.setBizOwnerType(null);
                        dto.setCorpName(corpName);
                        dto.setIdNum(idNum != null ? idNum : "");
                        dto.setCeoName(ceoName);
                        dto.setCorpNum(null);
                    } else if ("개인사업자".equals(memberTypeNorm)) {
                        dto.setPartyType("01");
                        dto.setBizOwnerType("P");
                        dto.setCorpName(corpName);
                        dto.setCeoName(ceoName);
                        dto.setCorpNum(corpNum);
                        dto.setIdNum(null);
                    } else if ("법인사업자".equals(memberTypeNorm)) {
                        dto.setPartyType("01");
                        dto.setBizOwnerType("C");
                        dto.setCorpName(corpName);
                        dto.setCeoName(ceoName);
                        dto.setCorpNum(corpNum);
                        dto.setIdNum(null);
                    } else {
                        // 회원유형이 비어있으면 기존 구분/사업자구분 컬럼으로 fallback
                        boolean isPersonal = "02".equals(partyType) || "개인".equals(partyType);
                        if (isPersonal) {
                            dto.setPartyType("02");
                            dto.setBizOwnerType(null);
                            dto.setCorpName(corpName);
                            dto.setIdNum(idNum != null ? idNum : "");
                            dto.setCeoName(ceoName);
                            dto.setCorpNum(null);
                        } else {
                            dto.setPartyType("01");
                            dto.setBizOwnerType("C".equals(bizOwnerType) || "법인".equals(bizOwnerType) ? "C" : "P");
                            dto.setCorpName(corpName);
                            dto.setCeoName(ceoName);
                            dto.setCorpNum(corpNum);
                            dto.setIdNum(null);
                        }
                    }
                    dto.setMobilePhone(mobilePhone);
                    dto.setEmail(email);
                    dto.setAddress(address);
                    dto.setBizType(isBlank(bizType) ? null : bizType);
                    dto.setBizClassification(isBlank(bizClassification) ? null : bizClassification);
                    dto.setPaymentMethod("DIRECT".equals(paymentMethod) || "직접".equals(paymentMethod) ? "DIRECT" : "AUTO");
                    dto.setContractInfo(contractInfo);
                    dto.setContractDetail(contractDetail);
                    dto.setMonitoring(monitoring);
                    dto.setMemo(memo);
                    dto.setUseYn("N".equals(useYn) ? "N" : "Y");

                    Map<String, Object> key = new HashMap<>();
                    key.put("corpName", dto.getCorpName());
                    key.put("address", dto.getAddress());
                    BillPowerPlantDTO exists = Component.getData("hometax.selectPowerPlantByImportKey", key);
                    if (exists != null && exists.getId() != null) {
                        // 기존 값 보존: 엑셀 셀이 비어있으면 기존 기본정보 유지
                        if (isBlank(dto.getMemberType())) dto.setMemberType(exists.getMemberType());
                        if (isBlank(dto.getBizOwnerType())) dto.setBizOwnerType(exists.getBizOwnerType());
                        if (isBlank(dto.getCorpName())) dto.setCorpName(exists.getCorpName());
                        if (isBlank(dto.getCeoName())) dto.setCeoName(exists.getCeoName());
                        if (isBlank(dto.getCorpNum())) dto.setCorpNum(exists.getCorpNum());
                        if (isBlank(dto.getBizType())) dto.setBizType(exists.getBizType());
                        if (isBlank(dto.getBizClassification())) dto.setBizClassification(exists.getBizClassification());
                        if (isBlank(dto.getIdNum())) dto.setIdNum(exists.getIdNum());
                        if (isBlank(dto.getMobilePhone())) dto.setMobilePhone(exists.getMobilePhone());
                        if (isBlank(dto.getAddress())) dto.setAddress(exists.getAddress());
                        if (isBlank(dto.getEmail())) dto.setEmail(exists.getEmail());
                        if (isBlank(dto.getPaymentMethod())) dto.setPaymentMethod(exists.getPaymentMethod());
                        if (isBlank(dto.getContractInfo())) dto.setContractInfo(exists.getContractInfo());
                        if (isBlank(dto.getContractDetail())) dto.setContractDetail(exists.getContractDetail());
                        if (isBlank(dto.getMonitoring())) dto.setMonitoring(exists.getMonitoring());
                        if (isBlank(dto.getMemo())) dto.setMemo(exists.getMemo());
                        if (isBlank(dto.getUseYn())) dto.setUseYn(exists.getUseYn());
                        dto.setId(exists.getId());
                        Component.updateData("hometax.updatePowerPlant", dto);
                        syncRecipientFromPowerPlant(req, dto);
                    } else {
                        Component.createData("hometax.insertPowerPlant", dto);
                        syncRecipientFromPowerPlant(req, dto);
                    }
                    success++;
                } catch (Exception e) {
                    fail++;
                    if (firstFailMsg == null) firstFailMsg = e.getMessage();
                }
            }

        } catch (Exception e) {
            ra.addFlashAttribute("message", "엑셀 처리 실패: " + e.getMessage());
            return new ModelAndView("redirect:/bill/contractor.do");
        }

        String msg = "계약자 엑셀 일괄등록: 총 " + total + "건 / 성공 " + success + "건 / 실패 " + fail + "건";
        if (fail > 0 && firstFailMsg != null && !firstFailMsg.trim().isEmpty()) {
            msg += " (첫 실패: " + firstFailMsg + ")";
        }
        ra.addFlashAttribute("message", msg);
        return new ModelAndView("redirect:/bill/contractor.do");
    }

    /** 계약자 관리: 개인 수급자 엑셀 일괄 등록 + 발전소별 계약 row 생성 */
    @RequestMapping(value = "/bill/contractor/importRecipientExcel.do", method = RequestMethod.POST)
    public ModelAndView contractorImportRecipientExcel(
            HttpServletRequest req,
            @RequestParam(value = "excelFile", required = false) MultipartFile excelFile,
            @RequestParam(value = "powerPlantIds", required = false) String powerPlantIds,
            @RequestParam(value = "contractYear", required = false) Integer contractYear,
            RedirectAttributes ra) {

        if (excelFile == null || excelFile.isEmpty()) {
            ra.addFlashAttribute("message", "엑셀 파일을 선택하세요.");
            return new ModelAndView("redirect:/bill/contractor.do");
        }

        if (powerPlantIds == null || powerPlantIds.trim().isEmpty()) {
            ra.addFlashAttribute("message", "엑셀 업로드할 발전소를 선택하세요.");
            return new ModelAndView("redirect:/bill/contractor.do");
        }

        List<Integer> powerPlantIdList = new ArrayList<>();
        try {
            for (String s : powerPlantIds.split(",")) {
                if (s == null) continue;
                s = s.trim();
                if (s.isEmpty()) continue;
                powerPlantIdList.add(Integer.valueOf(s));
            }
        } catch (Exception e) {
            ra.addFlashAttribute("message", "발전소 선택값이 올바르지 않습니다.");
            return new ModelAndView("redirect:/bill/contractor.do");
        }
        if (powerPlantIdList.isEmpty()) {
            ra.addFlashAttribute("message", "엑셀 업로드할 발전소를 선택하세요.");
            return new ModelAndView("redirect:/bill/contractor.do");
        }

        if (contractYear == null) {
            contractYear = Calendar.getInstance().get(Calendar.YEAR);
        }

        HttpSession session = req.getSession(false);
        Integer defaultProviderId = null;
        String loginDepartment = null;
        String loginPhone = null;
        String loginEmail = null;

        if (session != null) {
            Object v = session.getAttribute(HometaxLoginController.getDefaultProviderSessionKey());
            if (v != null) {
                try { defaultProviderId = Integer.valueOf(String.valueOf(v)); } catch (Exception ignore) {}
            }

            Object userId = session.getAttribute("HOMETAX_USER_ID");
            if (userId != null) {
                try {
                    Map<String, Object> u = new HashMap<>();
                    u.put("id", Integer.valueOf(String.valueOf(userId)));
                    BillUserDTO user = Component.getData("hometax.selectBillUserById", u);
                    if (user != null) {
                        loginDepartment = user.getDepartment();
                        loginPhone = user.getPhone();
                        loginEmail = user.getEmail();
                    }
                } catch (Exception ignore) {}
            }
        }

        if (defaultProviderId == null) {
            ra.addFlashAttribute("message", "기본 공급자가 지정되지 않았습니다.");
            return new ModelAndView("redirect:/bill/contractor.do");
        }

        int total = 0;
        int success = 0;
        int fail = 0;
        String firstFailMsg = null;

        try (XSSFWorkbook wb = new XSSFWorkbook(excelFile.getInputStream())) {
            Sheet sheet = wb.getNumberOfSheets() > 0 ? wb.getSheetAt(0) : null;
            if (sheet == null) {
                ra.addFlashAttribute("message", "엑셀 시트가 없습니다.");
                return new ModelAndView("redirect:/bill/contractor.do");
            }

            DataFormatter fmt = new DataFormatter();

            int headerRowIdx = 0;
            Row headerRow = sheet.getRow(headerRowIdx);
            if (headerRow == null) {
                ra.addFlashAttribute("message", "엑셀 1행(헤더)이 비어있습니다.");
                return new ModelAndView("redirect:/bill/contractor.do");
            }

            int colName = -1;
            int colIdNum = -1;
            int colAddr = -1;
            int colEmail = -1;

            for (int c = 0; c < headerRow.getLastCellNum(); c++) {
                String v = fmt.formatCellValue(headerRow.getCell(c));
                if (v == null) v = "";
                v = v.trim();

                String vn = v.replace(" ", "");
                String vnLower = vn.toLowerCase();

                // 성명/이름/대표자 모두 이름 컬럼으로 인식
                if ("성명".equals(vn) || "이름".equals(vn) || vn.contains("대표자")) {
                    colName = c;
                }

                if (vn.contains("주민등록번호") || vn.equals("주민번호") || vn.contains("주민번호")) {
                    colIdNum = c;
                }

                if (vn.contains("주소")) colAddr = c;

                if (vn.contains("이메일") || vnLower.equals("email") || vnLower.contains("e-mail")) {
                    colEmail = c;
                }
            }

            if (colName < 0 || colIdNum < 0) {
                ra.addFlashAttribute("message", "엑셀 헤더(1행) 매핑 실패: 성명/주민번호 컬럼을 확인해주세요.");
                return new ModelAndView("redirect:/bill/contractor.do");
            }

            for (int r = headerRowIdx + 1; r <= sheet.getLastRowNum(); r++) {
                Row row = sheet.getRow(r);
                if (row == null) continue;

                String name = colName >= 0 && row.getCell(colName) != null ? fmt.formatCellValue(row.getCell(colName)).trim() : "";
                String idNum = colIdNum >= 0 && row.getCell(colIdNum) != null ? fmt.formatCellValue(row.getCell(colIdNum)).trim() : "";
                String addr = colAddr >= 0 && row.getCell(colAddr) != null ? fmt.formatCellValue(row.getCell(colAddr)).trim() : "";
                String email = colEmail >= 0 && row.getCell(colEmail) != null ? fmt.formatCellValue(row.getCell(colEmail)).trim() : "";

                if ((name == null || name.isEmpty()) && (idNum == null || idNum.isEmpty())) continue;
                total++;

                try {
                    BillRecipientDTO dto = new BillRecipientDTO();
                    dto.setProviderId(defaultProviderId);
                    dto.setRecipientType("02");
                    dto.setIdNum(idNum);
                    dto.setCorpName(name);
                    dto.setAddress(addr);
                    dto.setEmail(email);
                    dto.setUseYn("Y");

                    // 발행담당자 기본값 (로그인 계정)
                    dto.setContactName(loginDepartment);
                    dto.setContactPhone(loginPhone);
                    dto.setContactEmail(loginEmail);

                    Component.createData("hometax.insertRecipient", dto);
                    Integer recipientId = dto.getId();
                    if (recipientId == null || recipientId <= 0) {
                        throw new RuntimeException("수급자 id 생성 실패");
                    }

                    // 선택된 발전소마다 계약 row 생성(금액 0으로 시작)
                    for (Integer ppId : powerPlantIdList) {
                        if (ppId == null) continue;
                        BillPowerPlantRecipientContractDTO cdto = new BillPowerPlantRecipientContractDTO();
                        cdto.setPowerPlantId(ppId);
                        cdto.setRecipientId(recipientId);
                        cdto.setContractYear(contractYear);
                        cdto.setSupplyTotal(BigDecimal.ZERO);
                        cdto.setTaxTotal(BigDecimal.ZERO);
                        cdto.setGrandTotal(BigDecimal.ZERO);
                        cdto.setUseYn("Y");
                        Component.createData("hometax.insertPowerPlantRecipientContract", cdto);
                    }

                    success++;
                } catch (Exception e) {
                    fail++;
                    if (firstFailMsg == null) {
                        firstFailMsg = e.getMessage();
                    }
                }
            }

        } catch (Exception e) {
            ra.addFlashAttribute("message", "엑셀 처리 실패: " + e.getMessage());
            return new ModelAndView("redirect:/bill/contractor.do");
        }

        String msg = "엑셀 등록 완료: 총 " + total + "건 / 성공 " + success + "건 / 실패 " + fail + "건";
        if (fail > 0 && firstFailMsg != null && !firstFailMsg.trim().isEmpty()) {
            msg += " (첫 실패 사유: " + firstFailMsg + ")";
        }
        ra.addFlashAttribute("message", msg);
        return new ModelAndView("redirect:/bill/contractor.do");
    }

    /** 계약자 관리: 엑셀 일괄등록 AJAX - 업로드 내용을 JSON으로 반환하여 왼쪽 계약자 내용에 반영 */
    @RequestMapping(value = "/bill/contractor/importRecipientExcelAjax.do", method = RequestMethod.POST)
    public void contractorImportRecipientExcelAjax(
            HttpServletRequest req,
            HttpServletResponse resp,
            @RequestParam(value = "excelFile", required = false) MultipartFile excelFile,
            @RequestParam(value = "powerPlantIds", required = false) String powerPlantIds,
            @RequestParam(value = "contractYear", required = false) Integer contractYear) throws java.io.IOException {

        Map<String, Object> result = new HashMap<>();
        result.put("rows", new ArrayList<Map<String, String>>());

        if (excelFile == null || excelFile.isEmpty()) {
            result.put("message", "엑셀 파일을 선택하세요.");
            writeJsonResponse(resp, result);
            return;
        }
        if (powerPlantIds == null || powerPlantIds.trim().isEmpty()) {
            result.put("message", "엑셀 업로드할 발전소를 선택하세요.");
            writeJsonResponse(resp, result);
            return;
        }

        List<Integer> powerPlantIdList = new ArrayList<>();
        try {
            for (String s : powerPlantIds.split(",")) {
                if (s == null) continue;
                s = s.trim();
                if (s.isEmpty()) continue;
                powerPlantIdList.add(Integer.valueOf(s));
            }
        } catch (Exception e) {
            result.put("message", "발전소 선택값이 올바르지 않습니다.");
            writeJsonResponse(resp, result);
            return;
        }
        if (powerPlantIdList.isEmpty()) {
            result.put("message", "엑셀 업로드할 발전소를 선택하세요.");
            writeJsonResponse(resp, result);
            return;
        }

        if (contractYear == null) {
            contractYear = Calendar.getInstance().get(Calendar.YEAR);
        }

        HttpSession session = req.getSession(false);
        Integer defaultProviderId = null;
        String loginDepartment = null;
        String loginPhone = null;
        String loginEmail = null;

        if (session != null) {
            Object v = session.getAttribute(HometaxLoginController.getDefaultProviderSessionKey());
            if (v != null) {
                try { defaultProviderId = Integer.valueOf(String.valueOf(v)); } catch (Exception ignore) {}
            }
            Object userId = session.getAttribute("HOMETAX_USER_ID");
            if (userId != null) {
                try {
                    Map<String, Object> u = new HashMap<>();
                    u.put("id", Integer.valueOf(String.valueOf(userId)));
                    BillUserDTO user = Component.getData("hometax.selectBillUserById", u);
                    if (user != null) {
                        loginDepartment = user.getDepartment();
                        loginPhone = user.getPhone();
                        loginEmail = user.getEmail();
                    }
                } catch (Exception ignore) {}
            }
        }

        if (defaultProviderId == null) {
            result.put("message", "기본 공급자가 지정되지 않았습니다.");
            writeJsonResponse(resp, result);
            return;
        }

        int total = 0;
        int success = 0;
        int fail = 0;
        String firstFailMsg = null;
        @SuppressWarnings("unchecked")
        List<Map<String, String>> parsedRows = (List<Map<String, String>>) result.get("rows");

        try (XSSFWorkbook wb = new XSSFWorkbook(excelFile.getInputStream())) {
            Sheet sheet = wb.getNumberOfSheets() > 0 ? wb.getSheetAt(0) : null;
            if (sheet == null) {
                result.put("message", "엑셀 시트가 없습니다.");
                writeJsonResponse(resp, result);
                return;
            }

            DataFormatter fmt = new DataFormatter();
            int headerRowIdx = 0;
            Row headerRow = sheet.getRow(headerRowIdx);
            if (headerRow == null) {
                result.put("message", "엑셀 1행(헤더)이 비어있습니다.");
                writeJsonResponse(resp, result);
                return;
            }

            int colName = -1;
            int colIdNum = -1;
            int colAddr = -1;
            int colEmail = -1;

            for (int c = 0; c < headerRow.getLastCellNum(); c++) {
                String v = fmt.formatCellValue(headerRow.getCell(c));
                if (v == null) v = "";
                v = v.trim();
                String vn = v.replace(" ", "");
                String vnLower = vn.toLowerCase();
                if ("성명".equals(vn) || "이름".equals(vn) || vn.contains("대표자")) colName = c;
                if (vn.contains("주민등록번호") || vn.equals("주민번호") || vn.contains("주민번호")) colIdNum = c;
                if (vn.contains("주소")) colAddr = c;
                if (vn.contains("이메일") || vnLower.equals("email") || vnLower.contains("e-mail")) colEmail = c;
            }

            if (colName < 0 || colIdNum < 0) {
                result.put("message", "엑셀 헤더(1행) 매핑 실패: 성명/주민번호 컬럼을 확인해주세요.");
                writeJsonResponse(resp, result);
                return;
            }

            for (int r = headerRowIdx + 1; r <= sheet.getLastRowNum(); r++) {
                Row row = sheet.getRow(r);
                if (row == null) continue;

                String name = colName >= 0 && row.getCell(colName) != null ? fmt.formatCellValue(row.getCell(colName)).trim() : "";
                String idNum = colIdNum >= 0 && row.getCell(colIdNum) != null ? fmt.formatCellValue(row.getCell(colIdNum)).trim() : "";
                String addr = colAddr >= 0 && row.getCell(colAddr) != null ? fmt.formatCellValue(row.getCell(colAddr)).trim() : "";
                String email = colEmail >= 0 && row.getCell(colEmail) != null ? fmt.formatCellValue(row.getCell(colEmail)).trim() : "";

                if ((name == null || name.isEmpty()) && (idNum == null || idNum.isEmpty())) continue;
                total++;

                Map<String, String> rowData = new HashMap<>();
                rowData.put("name", name != null ? name : "");
                rowData.put("idNum", idNum != null ? idNum : "");
                rowData.put("address", addr != null ? addr : "");
                rowData.put("email", email != null ? email : "");
                parsedRows.add(rowData);

                try {
                    BillRecipientDTO dto = new BillRecipientDTO();
                    dto.setProviderId(defaultProviderId);
                    dto.setRecipientType("02");
                    dto.setIdNum(idNum);
                    dto.setCorpName(name);
                    dto.setAddress(addr);
                    dto.setEmail(email);
                    dto.setUseYn("Y");
                    dto.setContactName(loginDepartment);
                    dto.setContactPhone(loginPhone);
                    dto.setContactEmail(loginEmail);

                    Component.createData("hometax.insertRecipient", dto);
                    Integer recipientId = dto.getId();
                    if (recipientId == null || recipientId <= 0) {
                        throw new RuntimeException("수급자 id 생성 실패");
                    }
                    for (Integer ppId : powerPlantIdList) {
                        if (ppId == null) continue;
                        BillPowerPlantRecipientContractDTO cdto = new BillPowerPlantRecipientContractDTO();
                        cdto.setPowerPlantId(ppId);
                        cdto.setRecipientId(recipientId);
                        cdto.setContractYear(contractYear);
                        cdto.setSupplyTotal(BigDecimal.ZERO);
                        cdto.setTaxTotal(BigDecimal.ZERO);
                        cdto.setGrandTotal(BigDecimal.ZERO);
                        cdto.setUseYn("Y");
                        Component.createData("hometax.insertPowerPlantRecipientContract", cdto);
                    }
                    success++;
                } catch (Exception e) {
                    fail++;
                    if (firstFailMsg == null) firstFailMsg = e.getMessage();
                }
            }

        } catch (Exception e) {
            result.put("message", "엑셀 처리 실패: " + e.getMessage());
            writeJsonResponse(resp, result);
            return;
        }

        String msg = "엑셀 등록 완료: 총 " + total + "건 / 성공 " + success + "건 / 실패 " + fail + "건";
        if (fail > 0 && firstFailMsg != null && !firstFailMsg.trim().isEmpty()) {
            msg += " (첫 실패 사유: " + firstFailMsg + ")";
        }
        result.put("message", msg);
        writeJsonResponse(resp, result);
    }

    private boolean isBlank(String v) {
        return v == null || v.trim().isEmpty();
    }

    private BillPowerPlantDTO getPowerPlantById(Integer id) {
        if (id == null || id <= 0) return null;
        Map<String, Object> param = new HashMap<>();
        param.put("id", id);
        return Component.getData("hometax.selectPowerPlantOne", param);
    }

    private Path getBizLicenseDirPath() throws IOException {
        String home = System.getProperty("user.home");
        Path dir = Paths.get(home, BIZ_LICENSE_DIR.split("/"));
        Files.createDirectories(dir);
        return dir;
    }

    private String saveBizLicensePdf(MultipartFile file) throws IOException {
        String original = file.getOriginalFilename();
        String ext = "";
        if (original != null) {
            int idx = original.lastIndexOf('.');
            if (idx >= 0) ext = original.substring(idx).toLowerCase();
        }
        if (!".pdf".equals(ext)) {
            throw new IllegalArgumentException("사업자등록증은 PDF 파일만 업로드할 수 있습니다.");
        }
        String savedName = UUID.randomUUID().toString().replace("-", "") + ".pdf";
        Path target = getBizLicenseDirPath().resolve(savedName);
        Files.copy(file.getInputStream(), target, StandardCopyOption.REPLACE_EXISTING);
        return savedName;
    }

    private Integer toInt(Object v) {
        if (v == null) return null;
        try {
            String s = String.valueOf(v).trim();
            if (s.isEmpty()) return null;
            return Integer.valueOf(s);
        } catch (Exception e) {
            return null;
        }
    }

    private BigDecimal toBigDecimal(Object v) {
        if (v == null) return BigDecimal.ZERO;
        try {
            String s = String.valueOf(v).replace(",", "").trim();
            if (s.isEmpty()) return BigDecimal.ZERO;
            return new BigDecimal(s);
        } catch (Exception e) {
            return BigDecimal.ZERO;
        }
    }

    private void writeJsonResponse(HttpServletResponse resp, Map<String, Object> data) throws java.io.IOException {
        resp.setContentType("application/json;charset=UTF-8");
        resp.setCharacterEncoding("UTF-8");
        ObjectMapper mapper = new ObjectMapper();
        mapper.writeValue(resp.getWriter(), data);
    }

    /** 공급받는자(개인) 엑셀 업로드 등록 */
    @RequestMapping(value = "/bill/recipient/importExcel.do", method = RequestMethod.POST)
    public ModelAndView recipientImportExcel(
            HttpServletRequest req,
            @RequestParam(value = "excelFile", required = false) MultipartFile excelFile,
            RedirectAttributes ra) {

        if (excelFile == null || excelFile.isEmpty()) {
            ra.addFlashAttribute("message", "엑셀 파일을 선택하세요.");
            return new ModelAndView("redirect:/bill/recipient.do");
        }

        HttpSession session = req.getSession(false);
        Integer defaultProviderId = null;
        String loginDepartment = null;
        String loginPhone = null;
        String loginEmail = null;
        if (session != null) {
            Object v = session.getAttribute(HometaxLoginController.getDefaultProviderSessionKey());
            if (v != null) {
                try { defaultProviderId = Integer.valueOf(String.valueOf(v)); } catch (Exception ignore) {}
            }
            Object userId = session.getAttribute("HOMETAX_USER_ID");
            if (userId != null) {
                try {
                    Map<String, Object> u = new HashMap<>();
                    u.put("id", Integer.valueOf(String.valueOf(userId)));
                    BillUserDTO user = Component.getData("hometax.selectBillUserById", u);
                    if (user != null) {
                        loginDepartment = user.getDepartment();
                        loginPhone = user.getPhone();
                        loginEmail = user.getEmail();
                    }
                } catch (Exception ignore) {}
            }
        }

        if (defaultProviderId == null) {
            ra.addFlashAttribute("message", "기본 공급자가 지정되지 않았습니다. (로그인 계정의 default_provider_id 확인)");
            return new ModelAndView("redirect:/bill/recipient.do");
        }

        int total = 0;
        int success = 0;
        int fail = 0;
        String firstFailMsg = null;

        try (XSSFWorkbook wb = new XSSFWorkbook(excelFile.getInputStream())) {
            Sheet sheet = wb.getNumberOfSheets() > 0 ? wb.getSheetAt(0) : null;
            if (sheet == null) {
                ra.addFlashAttribute("message", "엑셀 시트가 없습니다.");
                return new ModelAndView("redirect:/bill/recipient.do");
            }

            DataFormatter fmt = new DataFormatter();

            // 엑셀의 노란 헤더바는 고정이라고 가정: 1행(= index 0)을 헤더로 사용
            int headerRowIdx = 0;
            Row headerRow = sheet.getRow(headerRowIdx);
            if (headerRow == null) {
                ra.addFlashAttribute("message", "엑셀 1행(헤더)이 비어있습니다.");
                return new ModelAndView("redirect:/bill/recipient.do");
            }

            int colName = -1;
            int colIdNum = -1;
            int colAddr = -1;
            int colEmail = -1;

            for (int c = 0; c < headerRow.getLastCellNum(); c++) {
                String v = fmt.formatCellValue(headerRow.getCell(c));
                if (v == null) v = "";
                v = v.trim();

                // 공백 제거(예: "주민 등록번호")
                String vn = v.replace(" ", "");
                String vnLower = vn.toLowerCase();

                // 이름/성명: "성명" 또는 "이름"
                // 사용자 엑셀에서 "대표자"가 들어오는 경우도 성명 컬럼으로 같이 인식
                if ("성명".equals(vn) || "이름".equals(vn) || vn.contains("대표자")) colName = c;

                // 주민번호: "주민등록번호" 또는 "주민번호"
                if (vn.contains("주민등록번호") || vn.equals("주민번호") || vn.contains("주민번호")) colIdNum = c;

                // 주소
                if (vn.contains("주소")) colAddr = c;

                // 이메일: "이메일" 또는 "email"
                if (vn.contains("이메일") || vnLower.equals("email") || vnLower.contains("e-mail")) colEmail = c;
            }

            // 최소 키: 성명 + 주민번호
            if (colName < 0 || colIdNum < 0) {
                ra.addFlashAttribute("message", "엑셀 헤더(1행) 매핑 실패: 성명/주민번호 컬럼을 확인해주세요.");
                return new ModelAndView("redirect:/bill/recipient.do");
            }

            // 데이터 행 처리 (헤더 다음 줄부터)
            for (int r = headerRowIdx + 1; r <= sheet.getLastRowNum(); r++) {
                Row row = sheet.getRow(r);
                if (row == null) continue;

                String name = colName >= 0 && row.getCell(colName) != null ? fmt.formatCellValue(row.getCell(colName)).trim() : "";
                String idNum = colIdNum >= 0 && row.getCell(colIdNum) != null ? fmt.formatCellValue(row.getCell(colIdNum)).trim() : "";
                String addr = colAddr >= 0 && row.getCell(colAddr) != null ? fmt.formatCellValue(row.getCell(colAddr)).trim() : "";
                String email = colEmail >= 0 && row.getCell(colEmail) != null ? fmt.formatCellValue(row.getCell(colEmail)).trim() : "";

                // 완전 빈 줄은 스킵
                if ((name == null || name.isEmpty()) && (idNum == null || idNum.isEmpty())) continue;
                total++;

                try {
                    BillRecipientDTO dto = new BillRecipientDTO();
                    dto.setProviderId(defaultProviderId);
                    dto.setRecipientType("02");
                    dto.setIdNum(idNum);
                    dto.setCorpName(name);
                    dto.setAddress(addr);
                    dto.setEmail(email);
                    dto.setUseYn("Y");

                    // 발행담당자 기본값 (로그인 계정)
                    dto.setContactName(loginDepartment);
                    dto.setContactPhone(loginPhone);
                    dto.setContactEmail(loginEmail);

                    Component.createData("hometax.insertRecipient", dto);
                    success++;
                } catch (Exception e) {
                    fail++;
                    if (firstFailMsg == null) {
                        firstFailMsg = e.getMessage();
                    }
                }
            }
        } catch (Exception e) {
            ra.addFlashAttribute("message", "엑셀 처리 실패: " + e.getMessage());
            return new ModelAndView("redirect:/bill/recipient.do");
        }

        String msg = "엑셀 등록 완료: 총 " + total + "건 / 성공 " + success + "건 / 실패 " + fail + "건";
        if (fail > 0 && firstFailMsg != null && !firstFailMsg.trim().isEmpty()) {
            msg += " (첫 실패 사유: " + firstFailMsg + ")";
        }
        ra.addFlashAttribute("message", msg);
        return new ModelAndView("redirect:/bill/recipient.do");
    }

    /** 공급받는자 삭제 */
    @RequestMapping("/bill/recipient/delete.do")
    public ModelAndView recipientDelete(@RequestParam("id") Integer id, RedirectAttributes ra) {
        try {
            Map<String, Object> param = new HashMap<>();
            param.put("id", id);
            Component.deleteData("hometax.deleteRecipient", param);
            ra.addFlashAttribute("message", "삭제되었습니다.");
        } catch (Exception e) {
            ra.addFlashAttribute("message", "삭제 실패: " + e.getMessage());
        }
        return new ModelAndView("redirect:/bill/recipient.do");
    }

    /** 발행내역 */
    @RequestMapping("/bill/history.do")
    public ModelAndView history(HttpServletRequest req) {
        ModelAndView mv = new ModelAndView("/hometax/history/hometax_history_list");
        try {
            List<?> list = Component.getListNoParam("hometax.selectInvoiceLogList");
            mv.addObject("invoiceLogList", list != null ? list : java.util.Collections.emptyList());
        } catch (Exception e) {
            mv.addObject("invoiceLogList", java.util.Collections.emptyList());
        }
        return mv;
    }

    /** 내 계정 설정 */
    @RequestMapping("/bill/account.do")
    public ModelAndView account(HttpServletRequest req) {
        ModelAndView mv = new ModelAndView("/hometax/account/hometax_account");
        try {
            HttpSession session = req.getSession(false);
            if (session != null) {
                Object userId = session.getAttribute("HOMETAX_USER_ID");
                if (userId != null) {
                    Map<String, Object> u = new HashMap<>();
                    u.put("id", Integer.valueOf(String.valueOf(userId)));
                    BillUserDTO user = Component.getData("hometax.selectBillUserById", u);
                    mv.addObject("user", user);
                }
            }
            List<BillProviderDTO> providers = Component.getList("hometax.selectProviderList", null);
            mv.addObject("providerList", providers != null ? providers : java.util.Collections.emptyList());
        } catch (Exception e) {
            mv.addObject("providerList", java.util.Collections.emptyList());
        }
        return mv;
    }

    /** 내 계정 설정 저장 */
    @RequestMapping(value = "/bill/account/save.do", method = RequestMethod.POST)
    public ModelAndView accountSave(
            HttpServletRequest req,
            @RequestParam(value = "defaultProviderId", required = false) Integer defaultProviderId,
            @RequestParam(value = "department", required = false) String department,
            @RequestParam(value = "phone", required = false) String phone,
            @RequestParam(value = "email", required = false) String email,
            RedirectAttributes ra) {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("HOMETAX_USER_ID") == null) {
            ra.addFlashAttribute("message", "로그인 정보가 없습니다.");
            return new ModelAndView("redirect:/bill/login.do");
        }

        try {
            BillUserDTO dto = new BillUserDTO();
            dto.setId(Integer.valueOf(String.valueOf(session.getAttribute("HOMETAX_USER_ID"))));
            dto.setDefaultProviderId(defaultProviderId);
            dto.setDepartment(department != null ? department.trim() : null);
            dto.setPhone(phone != null ? phone.trim() : null);
            dto.setEmail(email != null ? email.trim() : null);

            Component.updateData("hometax.updateBillUserProfile", dto);

            session.setAttribute(HometaxLoginController.getDefaultProviderSessionKey(), defaultProviderId);
            ra.addFlashAttribute("message", "저장되었습니다.");
        } catch (Exception e) {
            ra.addFlashAttribute("message", "저장 실패: " + e.getMessage());
        }
        return new ModelAndView("redirect:/bill/account.do");
    }
}
