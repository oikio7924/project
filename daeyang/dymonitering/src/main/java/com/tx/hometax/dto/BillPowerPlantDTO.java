package com.tx.hometax.dto;

import java.util.Date;

/** ht_bill_power_plant (발전소 마스터) */
public class BillPowerPlantDTO {
    private Integer id;
    private String memberType;
    private String partyType; // 01=사업자, 02=개인
    private String bizOwnerType; // 사업자 구분: P=개인사업자, C=법인사업자

    private String corpName;
    private String ceoName;
    private String corpNum;
    /** 업태 (사업자) */
    private String bizType;
    /** 업종 (사업자) */
    private String bizClassification;
    private String idNum;

    private String mobilePhone;
    private String address;
    private String email;

    private String paymentMethod;
    /** 사업자등록증 PDF 저장 파일명 */
    private String bizLicenseFile;
    private String contractInfo;
    private String contractDetail;
    private String monitoring;
    private String memo;

    private String useYn;
    private Date createdAt;
    private Date updatedAt;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public String getMemberType() { return memberType; }
    public void setMemberType(String memberType) { this.memberType = memberType; }
    public String getPartyType() { return partyType; }
    public void setPartyType(String partyType) { this.partyType = partyType; }
    public String getBizOwnerType() { return bizOwnerType; }
    public void setBizOwnerType(String bizOwnerType) { this.bizOwnerType = bizOwnerType; }
    public String getCorpName() { return corpName; }
    public void setCorpName(String corpName) { this.corpName = corpName; }
    public String getCeoName() { return ceoName; }
    public void setCeoName(String ceoName) { this.ceoName = ceoName; }
    public String getCorpNum() { return corpNum; }
    public void setCorpNum(String corpNum) { this.corpNum = corpNum; }
    public String getBizType() { return bizType; }
    public void setBizType(String bizType) { this.bizType = bizType; }
    public String getBizClassification() { return bizClassification; }
    public void setBizClassification(String bizClassification) { this.bizClassification = bizClassification; }
    public String getIdNum() { return idNum; }
    public void setIdNum(String idNum) { this.idNum = idNum; }
    public String getMobilePhone() { return mobilePhone; }
    public void setMobilePhone(String mobilePhone) { this.mobilePhone = mobilePhone; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
    public String getBizLicenseFile() { return bizLicenseFile; }
    public void setBizLicenseFile(String bizLicenseFile) { this.bizLicenseFile = bizLicenseFile; }
    public String getContractInfo() { return contractInfo; }
    public void setContractInfo(String contractInfo) { this.contractInfo = contractInfo; }
    public String getContractDetail() { return contractDetail; }
    public void setContractDetail(String contractDetail) { this.contractDetail = contractDetail; }
    public String getMonitoring() { return monitoring; }
    public void setMonitoring(String monitoring) { this.monitoring = monitoring; }
    public String getMemo() { return memo; }
    public void setMemo(String memo) { this.memo = memo; }
    public String getUseYn() { return useYn; }
    public void setUseYn(String useYn) { this.useYn = useYn; }
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }
}

