package com.tx.hometax.dto;

import java.math.BigDecimal;
import java.util.Date;

/**
 * ht_bill_power_plant_recipient_contract (발전소-공급받는자 계약금액, 연도별)
 * 그리드에서 쓰기 위해 recipient 기본정보까지 같이 담는 형태로 매핑 가능
 */
public class BillPowerPlantRecipientContractDTO {
    private Integer id;
    private Integer powerPlantId;
    private Integer recipientId;
    private Integer contractYear;
    /** 동일 발전소/공급받는자/연도 내 품목 순번 */
    private Integer itemNo;

    // 그리드에 표시할 발전소명
    private String powerPlantName;

    private BigDecimal supplyTotal;
    private BigDecimal taxTotal;
    private BigDecimal grandTotal;

    private String useYn;
    private String itemName;
    private String memo;

    private Date createdAt;
    private Date updatedAt;

    // recipient info (그리드용)
    private String recipientType;
    private String corpName;
    private String corpNum;
    private String taxNum;
    private String bizType;
    private String bizClassification;
    private String ceoName;
    private String idNum;
    private String contactName;
    private String contactPhone;
    private String contactEmail;
    private String address;
    private String email;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public Integer getPowerPlantId() { return powerPlantId; }
    public void setPowerPlantId(Integer powerPlantId) { this.powerPlantId = powerPlantId; }
    public Integer getRecipientId() { return recipientId; }
    public void setRecipientId(Integer recipientId) { this.recipientId = recipientId; }
    public Integer getContractYear() { return contractYear; }
    public void setContractYear(Integer contractYear) { this.contractYear = contractYear; }
    public Integer getItemNo() { return itemNo; }
    public void setItemNo(Integer itemNo) { this.itemNo = itemNo; }

    public String getPowerPlantName() { return powerPlantName; }
    public void setPowerPlantName(String powerPlantName) { this.powerPlantName = powerPlantName; }

    public BigDecimal getSupplyTotal() { return supplyTotal; }
    public void setSupplyTotal(BigDecimal supplyTotal) { this.supplyTotal = supplyTotal; }
    public BigDecimal getTaxTotal() { return taxTotal; }
    public void setTaxTotal(BigDecimal taxTotal) { this.taxTotal = taxTotal; }
    public BigDecimal getGrandTotal() { return grandTotal; }
    public void setGrandTotal(BigDecimal grandTotal) { this.grandTotal = grandTotal; }

    public String getUseYn() { return useYn; }
    public void setUseYn(String useYn) { this.useYn = useYn; }
    public String getItemName() { return itemName; }
    public void setItemName(String itemName) { this.itemName = itemName; }
    public String getMemo() { return memo; }
    public void setMemo(String memo) { this.memo = memo; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }

    public String getRecipientType() { return recipientType; }
    public void setRecipientType(String recipientType) { this.recipientType = recipientType; }
    public String getCorpName() { return corpName; }
    public void setCorpName(String corpName) { this.corpName = corpName; }
    public String getCorpNum() { return corpNum; }
    public void setCorpNum(String corpNum) { this.corpNum = corpNum; }
    public String getTaxNum() { return taxNum; }
    public void setTaxNum(String taxNum) { this.taxNum = taxNum; }
    public String getBizType() { return bizType; }
    public void setBizType(String bizType) { this.bizType = bizType; }
    public String getBizClassification() { return bizClassification; }
    public void setBizClassification(String bizClassification) { this.bizClassification = bizClassification; }
    public String getCeoName() { return ceoName; }
    public void setCeoName(String ceoName) { this.ceoName = ceoName; }
    public String getIdNum() { return idNum; }
    public void setIdNum(String idNum) { this.idNum = idNum; }
    public String getContactName() { return contactName; }
    public void setContactName(String contactName) { this.contactName = contactName; }
    public String getContactPhone() { return contactPhone; }
    public void setContactPhone(String contactPhone) { this.contactPhone = contactPhone; }
    public String getContactEmail() { return contactEmail; }
    public void setContactEmail(String contactEmail) { this.contactEmail = contactEmail; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
}

