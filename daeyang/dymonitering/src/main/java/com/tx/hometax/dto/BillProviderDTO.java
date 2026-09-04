package com.tx.hometax.dto;

import java.util.Date;

/** ht_bill_provider */
public class BillProviderDTO {
    private Integer id;
    private String corpNum;
    private String bizType;
    private String bizClassification;
    private String corpName;
    private String ceoName;
    private String contactName;
    private String contactPhone;
    private String email;
    private String address;
    private String lastDocumentNo;
    private String useYn;
    private Date createdAt;
    private Date updatedAt;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public String getCorpNum() { return corpNum; }
    public void setCorpNum(String corpNum) { this.corpNum = corpNum; }
    public String getBizType() { return bizType; }
    public void setBizType(String bizType) { this.bizType = bizType; }
    public String getBizClassification() { return bizClassification; }
    public void setBizClassification(String bizClassification) { this.bizClassification = bizClassification; }
    public String getCorpName() { return corpName; }
    public void setCorpName(String corpName) { this.corpName = corpName; }
    public String getCeoName() { return ceoName; }
    public void setCeoName(String ceoName) { this.ceoName = ceoName; }
    public String getContactName() { return contactName; }
    public void setContactName(String contactName) { this.contactName = contactName; }
    public String getContactPhone() { return contactPhone; }
    public void setContactPhone(String contactPhone) { this.contactPhone = contactPhone; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public String getLastDocumentNo() { return lastDocumentNo; }
    public void setLastDocumentNo(String lastDocumentNo) { this.lastDocumentNo = lastDocumentNo; }
    public String getUseYn() { return useYn; }
    public void setUseYn(String useYn) { this.useYn = useYn; }
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }
}
