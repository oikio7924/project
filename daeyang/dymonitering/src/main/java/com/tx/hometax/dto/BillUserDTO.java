package com.tx.hometax.dto;

import java.util.Date;

/** ht_bill_user */
public class BillUserDTO {
    private Integer id;
    private String loginId;
    private String loginPw;
    private String name;
    private String department;
    private String phone;
    private String extensionNo;
    private String email;
    private String useYn;
    private String role;
    private Integer defaultProviderId;
    private Date createdAt;
    private Date updatedAt;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public String getLoginId() { return loginId; }
    public void setLoginId(String loginId) { this.loginId = loginId; }
    public String getLoginPw() { return loginPw; }
    public void setLoginPw(String loginPw) { this.loginPw = loginPw; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getExtensionNo() { return extensionNo; }
    public void setExtensionNo(String extensionNo) { this.extensionNo = extensionNo; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getUseYn() { return useYn; }
    public void setUseYn(String useYn) { this.useYn = useYn; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    public Integer getDefaultProviderId() { return defaultProviderId; }
    public void setDefaultProviderId(Integer defaultProviderId) { this.defaultProviderId = defaultProviderId; }
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }
}
