package com.tx.hometax.dto;

import java.util.Date;

/** ht_bill_recipient (01=사업자, 02=개인주민, 03=외국인) */
public class BillRecipientDTO {
    private Integer id;
    private Integer providerId;
    private String recipientType;
    private String corpNum;
    private String taxNum;
    private String bizType;
    private String bizClassification;
    private String corpName;
    private String ceoName;
    private String idNum;
    private String contactName;
    private String contactPhone;
    private String contactEmail;
    private String email;
    private String address;
    private String useYn;
    private Date createdAt;
    private Date updatedAt;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public Integer getProviderId() { return providerId; }
    public void setProviderId(Integer providerId) { this.providerId = providerId; }
    public String getRecipientType() { return recipientType; }
    public void setRecipientType(String recipientType) { this.recipientType = recipientType; }
    public String getCorpNum() { return corpNum; }
    public void setCorpNum(String corpNum) { this.corpNum = corpNum; }
    public String getTaxNum() { return taxNum; }
    public void setTaxNum(String taxNum) { this.taxNum = taxNum; }
    public String getBizType() { return bizType; }
    public void setBizType(String bizType) { this.bizType = bizType; }
    public String getBizClassification() { return bizClassification; }
    public void setBizClassification(String bizClassification) { this.bizClassification = bizClassification; }
    public String getCorpName() { return corpName; }
    public void setCorpName(String corpName) { this.corpName = corpName; }
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
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public String getUseYn() { return useYn; }
    public void setUseYn(String useYn) { this.useYn = useYn; }
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }
}
