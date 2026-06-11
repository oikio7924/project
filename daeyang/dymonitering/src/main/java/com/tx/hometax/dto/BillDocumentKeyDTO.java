package com.tx.hometax.dto;

import java.util.Date;

/** ht_bill_document_key */
public class BillDocumentKeyDTO {
    private Integer id;
    private Integer providerId;
    private String prefix;
    private Integer nextNo;
    private Date updatedAt;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public Integer getProviderId() { return providerId; }
    public void setProviderId(Integer providerId) { this.providerId = providerId; }
    public String getPrefix() { return prefix; }
    public void setPrefix(String prefix) { this.prefix = prefix; }
    public Integer getNextNo() { return nextNo; }
    public void setNextNo(Integer nextNo) { this.nextNo = nextNo; }
    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }
}
