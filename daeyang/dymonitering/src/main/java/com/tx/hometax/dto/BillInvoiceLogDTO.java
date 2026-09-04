package com.tx.hometax.dto;

import java.math.BigDecimal;
import java.util.Date;

/** ht_bill_invoice_log */
public class BillInvoiceLogDTO {
    private Integer id;
    private Integer powerPlantId;
    private Integer providerId;
    private Integer recipientId;
    private Integer templateId;
    private String subject;
    private String documentNo;
    /** 국세청 전자세금계산서 승인번호 (전송·발행 완료 후 저장) */
    private String approvalNo;
    private String issueDate;
    private BigDecimal supplyTotal;
    private BigDecimal taxTotal;
    private BigDecimal grandTotal;
    private BigDecimal cash;
    private BigDecimal scheck;
    private BigDecimal draft;
    private BigDecimal uncollected;
    private String unit;
    private String quantity;
    private BigDecimal unitPrice;
    private BigDecimal supplyPrice;
    private BigDecimal taxAmount;
    private String description;
    private String purposeType;
    private String partyTypeCode;
    private String typeCode1;
    private String typeCode2;
    private String subKeyno;
    private String sendYn;
    private String status;
    private String errorMsg;
    private Date sentAt;
    private Date createdAt;
    private Date updatedAt;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public Integer getPowerPlantId() { return powerPlantId; }
    public void setPowerPlantId(Integer powerPlantId) { this.powerPlantId = powerPlantId; }
    public Integer getProviderId() { return providerId; }
    public void setProviderId(Integer providerId) { this.providerId = providerId; }
    public Integer getRecipientId() { return recipientId; }
    public void setRecipientId(Integer recipientId) { this.recipientId = recipientId; }
    public Integer getTemplateId() { return templateId; }
    public void setTemplateId(Integer templateId) { this.templateId = templateId; }
    public String getSubject() { return subject; }
    public void setSubject(String subject) { this.subject = subject; }
    public String getDocumentNo() { return documentNo; }
    public void setDocumentNo(String documentNo) { this.documentNo = documentNo; }
    public String getApprovalNo() { return approvalNo; }
    public void setApprovalNo(String approvalNo) { this.approvalNo = approvalNo; }
    public String getIssueDate() { return issueDate; }
    public void setIssueDate(String issueDate) { this.issueDate = issueDate; }
    public BigDecimal getSupplyTotal() { return supplyTotal; }
    public void setSupplyTotal(BigDecimal supplyTotal) { this.supplyTotal = supplyTotal; }
    public BigDecimal getTaxTotal() { return taxTotal; }
    public void setTaxTotal(BigDecimal taxTotal) { this.taxTotal = taxTotal; }
    public BigDecimal getGrandTotal() { return grandTotal; }
    public void setGrandTotal(BigDecimal grandTotal) { this.grandTotal = grandTotal; }
    public BigDecimal getCash() { return cash; }
    public void setCash(BigDecimal cash) { this.cash = cash; }
    public BigDecimal getScheck() { return scheck; }
    public void setScheck(BigDecimal scheck) { this.scheck = scheck; }
    public BigDecimal getDraft() { return draft; }
    public void setDraft(BigDecimal draft) { this.draft = draft; }
    public BigDecimal getUncollected() { return uncollected; }
    public void setUncollected(BigDecimal uncollected) { this.uncollected = uncollected; }
    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }
    public String getQuantity() { return quantity; }
    public void setQuantity(String quantity) { this.quantity = quantity; }
    public BigDecimal getUnitPrice() { return unitPrice; }
    public void setUnitPrice(BigDecimal unitPrice) { this.unitPrice = unitPrice; }
    public BigDecimal getSupplyPrice() { return supplyPrice; }
    public void setSupplyPrice(BigDecimal supplyPrice) { this.supplyPrice = supplyPrice; }
    public BigDecimal getTaxAmount() { return taxAmount; }
    public void setTaxAmount(BigDecimal taxAmount) { this.taxAmount = taxAmount; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getPurposeType() { return purposeType; }
    public void setPurposeType(String purposeType) { this.purposeType = purposeType; }
    public String getPartyTypeCode() { return partyTypeCode; }
    public void setPartyTypeCode(String partyTypeCode) { this.partyTypeCode = partyTypeCode; }
    public String getTypeCode1() { return typeCode1; }
    public void setTypeCode1(String typeCode1) { this.typeCode1 = typeCode1; }
    public String getTypeCode2() { return typeCode2; }
    public void setTypeCode2(String typeCode2) { this.typeCode2 = typeCode2; }
    public String getSubKeyno() { return subKeyno; }
    public void setSubKeyno(String subKeyno) { this.subKeyno = subKeyno; }
    public String getSendYn() { return sendYn; }
    public void setSendYn(String sendYn) { this.sendYn = sendYn; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getErrorMsg() { return errorMsg; }
    public void setErrorMsg(String errorMsg) { this.errorMsg = errorMsg; }
    public Date getSentAt() { return sentAt; }
    public void setSentAt(Date sentAt) { this.sentAt = sentAt; }
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }
}
