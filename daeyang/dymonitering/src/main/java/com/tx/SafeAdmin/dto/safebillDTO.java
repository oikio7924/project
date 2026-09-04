package com.tx.SafeAdmin.dto;

public class safebillDTO {
	
	
	//공급자 정보
	public String dbp_keyno;
	public String dbp_id;
	public String dbp_pass;
	public String dbp_apikey;
	public String dbp_co_num;
	public String dbp_biztype;
	public String dbp_name;
	public String dbp_bizclassification;
	public String dbp_ceoname;
	public String dbp_busename;
	public String dbp_ir_name;
	public String dbp_ir_cell;	
	public String dbp_email	;
	public String dbp_address;	
	public String dbp_date ;
	public String dbp_sub_keyno;	
	public String dbp_homemunseo_id;	
	public String dbp_subkey1;	
	public String dbp_subkey2;	
	public String dbp_subkey3;
	public String dbp_UI_KEYNO;
	
	//공급 받는자 정보
	public String dbs_keyno;
	public String dbs_co_num;
	public String dbs_biztype;
	public String dbs_name;
	public String dbs_bizclassification;
	public String dbs_taxnum;
	public String dbs_ceoname;
	public String dbs_busename1;
	public String dbs_name1;
	public String dbs_cell1;
	public String dbs_email1;
	public String dbs_busename2;
	public String dbs_name2;
	public String dbs_cell2;
	public String dbs_email2;
	public String dbs_address;
	public String dbs_date;
	public String dbs_homeid;
	public String dbs_UI_KEYNO;
	
	
	//로그정보
	public String  dbl_keyno;
	public String  dbl_provider_key;	
	public String  dbl_supplied_key;	
	public String  dbl_issuedate;	
	public String  dbl_cash;	
	public String  dbl_scheck;	
	public String  dbl_draft;
	public String  dbl_uncollected;	
	public String  dbl_chargetotal;
	public String  dbl_taxtotal;	
	public String  dbl_grandtotal;	
	public String  dbl_subject;	
	public String  dbl_unit;	
	public String  dbl_quantity;	
	public String  dbl_unitprice;
	public String  dbl_supplyprice;	
	public String  dbl_tax;	
	public String  dbl_description;	
	public String  dbl_sub_keyno;	
	public String  dbl_checkYN;	
	public String  dbl_p_name;	
	public String  dbl_s_name;
	public String  dbl_purposetype;	
	public String  dbl_partytypecode;	
	public String  dbl_issueid;	
	public String  dbl_typecode1;	
	public String  dbl_typecode2;
	public String  dbl_sub_description;	
	public String  dbl_sub_issuedate;	
	public String  dbl_si_hcnt;	
	public String  Conn_date;	
	public String  dbl_status;
	public String  dbl_errormsg;	
	public String  dbl_homeid;
	public String  dbl_UI_KEYNO;
	
	//세금계산서 정보
	public String hometaxbill_id;
	public String spass;
	public String apikey;
	public String homemunseo_id;
	public String signature;
	public String issueid;
	public String typecode1;
	public String typecode2;
	public String description;
	public String issuedate;
	public String modifytype;
	public String purposetype;
	public String originalissueid;
	public String si_id;
	public String si_hcnt;
	public String si_startdt;
	public String si_enddt;
	public String ir_companynumber;
	public String ir_biztype;
	public String ir_companyname;
	public String ir_bizclassification;
	public String ir_ceoname;
	public String ir_busename;
	public String ir_name;
	public String ir_cell;
	public String ir_email;
	public String ir_companyaddress;
	public String ie_companynumber;
	public String ie_biztype;
	public String ie_companyname;
	public String ie_bizclassification;
	public String ie_taxnumber;
	public String partytypecode;
	public String ie_ceoname;
	public String ie_busename1;
	public String ie_name1;
	public String ie_cell1;
	public String ie_email1;
	public String ie_busename2;
	public String ie_name2;
	public String ie_cell2;
	public String ie_email2;
	public String ie_companyaddress;
	public String su_companynumber;
	public String su_biztype;
	public String su_companyname;
	public String su_bizclassification;
	public String su_taxnumber;
	public String su_ceoname;
	public String su_busename;
	public String su_name;
	public String su_cell;
	public String su_email;
	public String su_companyaddress;
	public String cash;
	public String scheck;
	public String draft;
	public String uncollected;
	public String chargetotal;
	public String taxtotal;
	public String grandtotal;
	public String supplyprice;
	public String quantity;
	public String unit;
	public String subject;
	public String sub_issuedate;
	public String tax;
	public String unitprice;
	public String sub_description;
	
	public String getDbp_keyno() {
		return dbp_keyno;
	}
	public void setDbp_keyno(String dbp_keyno) {
		this.dbp_keyno = dbp_keyno;
	}
	public String getDbp_id() {
		return dbp_id;
	}
	public void setDbp_id(String dbp_id) {
		this.dbp_id = dbp_id;
	}
	public String getDbp_pass() {
		return dbp_pass;
	}
	public void setDbp_pass(String dbp_pass) {
		this.dbp_pass = dbp_pass;
	}
	public String getDbp_apikey() {
		return dbp_apikey;
	}
	public void setDbp_apikey(String dbp_apikey) {
		this.dbp_apikey = dbp_apikey;
	}
	public String getDbp_co_num() {
		return dbp_co_num;
	}
	public void setDbp_co_num(String dbp_co_num) {
		this.dbp_co_num = dbp_co_num;
	}
	public String getDbp_biztype() {
		return dbp_biztype;
	}
	public void setDbp_biztype(String dbp_biztype) {
		this.dbp_biztype = dbp_biztype;
	}
	public String getDbp_name() {
		return dbp_name;
	}
	public void setDbp_name(String dbp_name) {
		this.dbp_name = dbp_name;
	}
	public String getDbp_bizclassification() {
		return dbp_bizclassification;
	}
	public void setDbp_bizclassification(String dbp_bizclassification) {
		this.dbp_bizclassification = dbp_bizclassification;
	}
	public String getDbp_ceoname() {
		return dbp_ceoname;
	}
	public void setDbp_ceoname(String dbp_ceoname) {
		this.dbp_ceoname = dbp_ceoname;
	}
	public String getDbp_busename() {
		return dbp_busename;
	}
	public void setDbp_busename(String dbp_busename) {
		this.dbp_busename = dbp_busename;
	}
	public String getDbp_ir_name() {
		return dbp_ir_name;
	}
	public void setDbp_ir_name(String dbp_ir_name) {
		this.dbp_ir_name = dbp_ir_name;
	}
	public String getDbp_ir_cell() {
		return dbp_ir_cell;
	}
	public void setDbp_ir_cell(String dbp_ir_cell) {
		this.dbp_ir_cell = dbp_ir_cell;
	}
	public String getDbp_email() {
		return dbp_email;
	}
	public void setDbp_email(String dbp_email) {
		this.dbp_email = dbp_email;
	}
	public String getDbp_address() {
		return dbp_address;
	}
	public void setDbp_address(String dbp_address) {
		this.dbp_address = dbp_address;
	}
	public String getDbp_date() {
		return dbp_date;
	}
	public void setDbp_date(String dbp_date) {
		this.dbp_date = dbp_date;
	}
	public String getDbp_sub_keyno() {
		return dbp_sub_keyno;
	}
	public void setDbp_sub_keyno(String dbp_sub_keyno) {
		this.dbp_sub_keyno = dbp_sub_keyno;
	}
	public String getDbp_homemunseo_id() {
		return dbp_homemunseo_id;
	}
	public void setDbp_homemunseo_id(String dbp_homemunseo_id) {
		this.dbp_homemunseo_id = dbp_homemunseo_id;
	}
	public String getDbp_subkey1() {
		return dbp_subkey1;
	}
	public void setDbp_subkey1(String dbp_subkey1) {
		this.dbp_subkey1 = dbp_subkey1;
	}
	public String getDbp_subkey2() {
		return dbp_subkey2;
	}
	public void setDbp_subkey2(String dbp_subkey2) {
		this.dbp_subkey2 = dbp_subkey2;
	}
	public String getDbp_subkey3() {
		return dbp_subkey3;
	}
	public void setDbp_subkey3(String dbp_subkey3) {
		this.dbp_subkey3 = dbp_subkey3;
	}
	
	public String getDbp_UI_KEYNO() {
		return dbp_UI_KEYNO;
	}
	public void setDbp_UI_KEYNO(String dbp_UI_KEYNO) {
		this.dbp_UI_KEYNO = dbp_UI_KEYNO;
	}
	public String getDbs_UI_KEYNO() {
		return dbs_UI_KEYNO;
	}
	public void setDbs_UI_KEYNO(String dbs_UI_KEYNO) {
		this.dbs_UI_KEYNO = dbs_UI_KEYNO;
	}
	public String getDbl_UI_KEYNO() {
		return dbl_UI_KEYNO;
	}
	public void setDbl_UI_KEYNO(String dbl_UI_KEYNO) {
		this.dbl_UI_KEYNO = dbl_UI_KEYNO;
	}
	public String getDbs_keyno() {
		return dbs_keyno;
	}
	public void setDbs_keyno(String dbs_keyno) {
		this.dbs_keyno = dbs_keyno;
	}
	public String getDbs_co_num() {
		return dbs_co_num;
	}
	public void setDbs_co_num(String dbs_co_num) {
		this.dbs_co_num = dbs_co_num;
	}
	public String getDbs_biztype() {
		return dbs_biztype;
	}
	public void setDbs_biztype(String dbs_biztype) {
		this.dbs_biztype = dbs_biztype;
	}
	public String getDbs_name() {
		return dbs_name;
	}
	public void setDbs_name(String dbs_name) {
		this.dbs_name = dbs_name;
	}
	public String getDbs_bizclassification() {
		return dbs_bizclassification;
	}
	public void setDbs_bizclassification(String dbs_bizclassification) {
		this.dbs_bizclassification = dbs_bizclassification;
	}
	public String getDbs_taxnum() {
		return dbs_taxnum;
	}
	public void setDbs_taxnum(String dbs_taxnum) {
		this.dbs_taxnum = dbs_taxnum;
	}
	public String getDbs_ceoname() {
		return dbs_ceoname;
	}
	public void setDbs_ceoname(String dbs_ceoname) {
		this.dbs_ceoname = dbs_ceoname;
	}
	public String getDbs_busename1() {
		return dbs_busename1;
	}
	public void setDbs_busename1(String dbs_busename1) {
		this.dbs_busename1 = dbs_busename1;
	}
	public String getDbs_name1() {
		return dbs_name1;
	}
	public void setDbs_name1(String dbs_name1) {
		this.dbs_name1 = dbs_name1;
	}
	public String getDbs_cell1() {
		return dbs_cell1;
	}
	public void setDbs_cell1(String dbs_cell1) {
		this.dbs_cell1 = dbs_cell1;
	}
	public String getDbs_email1() {
		return dbs_email1;
	}
	public void setDbs_email1(String dbs_email1) {
		this.dbs_email1 = dbs_email1;
	}
	public String getDbs_busename2() {
		return dbs_busename2;
	}
	public void setDbs_busename2(String dbs_busename2) {
		this.dbs_busename2 = dbs_busename2;
	}
	public String getDbs_name2() {
		return dbs_name2;
	}
	public void setDbs_name2(String dbs_name2) {
		this.dbs_name2 = dbs_name2;
	}
	public String getDbs_cell2() {
		return dbs_cell2;
	}
	public void setDbs_cell2(String dbs_cell2) {
		this.dbs_cell2 = dbs_cell2;
	}
	public String getDbs_email2() {
		return dbs_email2;
	}
	public void setDbs_email2(String dbs_email2) {
		this.dbs_email2 = dbs_email2;
	}
	public String getDbs_address() {
		return dbs_address;
	}
	public void setDbs_address(String dbs_address) {
		this.dbs_address = dbs_address;
	}
	public String getDbs_date() {
		return dbs_date;
	}
	public void setDbs_date(String dbs_date) {
		this.dbs_date = dbs_date;
	}
	public String getDbs_homeid() {
		return dbs_homeid;
	}
	public void setDbs_homeid(String dbs_homeid) {
		this.dbs_homeid = dbs_homeid;
	}
	public String getDbl_keyno() {
		return dbl_keyno;
	}
	public void setDbl_keyno(String dbl_keyno) {
		this.dbl_keyno = dbl_keyno;
	}
	public String getDbl_provider_key() {
		return dbl_provider_key;
	}
	public void setDbl_provider_key(String dbl_provider_key) {
		this.dbl_provider_key = dbl_provider_key;
	}
	public String getDbl_supplied_key() {
		return dbl_supplied_key;
	}
	public void setDbl_supplied_key(String dbl_supplied_key) {
		this.dbl_supplied_key = dbl_supplied_key;
	}
	public String getDbl_issuedate() {
		return dbl_issuedate;
	}
	public void setDbl_issuedate(String dbl_issuedate) {
		this.dbl_issuedate = dbl_issuedate;
	}
	public String getDbl_cash() {
		return dbl_cash;
	}
	public void setDbl_cash(String dbl_cash) {
		this.dbl_cash = dbl_cash;
	}
	public String getDbl_scheck() {
		return dbl_scheck;
	}
	public void setDbl_scheck(String dbl_scheck) {
		this.dbl_scheck = dbl_scheck;
	}
	public String getDbl_draft() {
		return dbl_draft;
	}
	public void setDbl_draft(String dbl_draft) {
		this.dbl_draft = dbl_draft;
	}
	public String getDbl_uncollected() {
		return dbl_uncollected;
	}
	public void setDbl_uncollected(String dbl_uncollected) {
		this.dbl_uncollected = dbl_uncollected;
	}
	public String getDbl_chargetotal() {
		return dbl_chargetotal;
	}
	public void setDbl_chargetotal(String dbl_chargetotal) {
		this.dbl_chargetotal = dbl_chargetotal;
	}
	public String getDbl_taxtotal() {
		return dbl_taxtotal;
	}
	public void setDbl_taxtotal(String dbl_taxtotal) {
		this.dbl_taxtotal = dbl_taxtotal;
	}
	public String getDbl_grandtotal() {
		return dbl_grandtotal;
	}
	public void setDbl_grandtotal(String dbl_grandtotal) {
		this.dbl_grandtotal = dbl_grandtotal;
	}
	public String getDbl_subject() {
		return dbl_subject;
	}
	public void setDbl_subject(String dbl_subject) {
		this.dbl_subject = dbl_subject;
	}
	public String getDbl_unit() {
		return dbl_unit;
	}
	public void setDbl_unit(String dbl_unit) {
		this.dbl_unit = dbl_unit;
	}
	public String getDbl_quantity() {
		return dbl_quantity;
	}
	public void setDbl_quantity(String dbl_quantity) {
		this.dbl_quantity = dbl_quantity;
	}
	public String getDbl_unitprice() {
		return dbl_unitprice;
	}
	public void setDbl_unitprice(String dbl_unitprice) {
		this.dbl_unitprice = dbl_unitprice;
	}
	public String getDbl_supplyprice() {
		return dbl_supplyprice;
	}
	public void setDbl_supplyprice(String dbl_supplyprice) {
		this.dbl_supplyprice = dbl_supplyprice;
	}
	public String getDbl_tax() {
		return dbl_tax;
	}
	public void setDbl_tax(String dbl_tax) {
		this.dbl_tax = dbl_tax;
	}
	public String getDbl_description() {
		return dbl_description;
	}
	public void setDbl_description(String dbl_description) {
		this.dbl_description = dbl_description;
	}
	public String getDbl_sub_keyno() {
		return dbl_sub_keyno;
	}
	public void setDbl_sub_keyno(String dbl_sub_keyno) {
		this.dbl_sub_keyno = dbl_sub_keyno;
	}
	public String getDbl_checkYN() {
		return dbl_checkYN;
	}
	public void setDbl_checkYN(String dbl_checkYN) {
		this.dbl_checkYN = dbl_checkYN;
	}
	public String getDbl_p_name() {
		return dbl_p_name;
	}
	public void setDbl_p_name(String dbl_p_name) {
		this.dbl_p_name = dbl_p_name;
	}
	public String getDbl_s_name() {
		return dbl_s_name;
	}
	public void setDbl_s_name(String dbl_s_name) {
		this.dbl_s_name = dbl_s_name;
	}
	public String getDbl_purposetype() {
		return dbl_purposetype;
	}
	public void setDbl_purposetype(String dbl_purposetype) {
		this.dbl_purposetype = dbl_purposetype;
	}
	public String getDbl_partytypecode() {
		return dbl_partytypecode;
	}
	public void setDbl_partytypecode(String dbl_partytypecode) {
		this.dbl_partytypecode = dbl_partytypecode;
	}
	public String getDbl_issueid() {
		return dbl_issueid;
	}
	public void setDbl_issueid(String dbl_issueid) {
		this.dbl_issueid = dbl_issueid;
	}
	public String getDbl_typecode1() {
		return dbl_typecode1;
	}
	public void setDbl_typecode1(String dbl_typecode1) {
		this.dbl_typecode1 = dbl_typecode1;
	}
	public String getDbl_typecode2() {
		return dbl_typecode2;
	}
	public void setDbl_typecode2(String dbl_typecode2) {
		this.dbl_typecode2 = dbl_typecode2;
	}
	public String getDbl_sub_description() {
		return dbl_sub_description;
	}
	public void setDbl_sub_description(String dbl_sub_description) {
		this.dbl_sub_description = dbl_sub_description;
	}
	public String getDbl_sub_issuedate() {
		return dbl_sub_issuedate;
	}
	public void setDbl_sub_issuedate(String dbl_sub_issuedate) {
		this.dbl_sub_issuedate = dbl_sub_issuedate;
	}
	public String getDbl_si_hcnt() {
		return dbl_si_hcnt;
	}
	public void setDbl_si_hcnt(String dbl_si_hcnt) {
		this.dbl_si_hcnt = dbl_si_hcnt;
	}
	public String getConn_date() {
		return Conn_date;
	}
	public void setConn_date(String conn_date) {
		Conn_date = conn_date;
	}
	public String getDbl_status() {
		return dbl_status;
	}
	public void setDbl_status(String dbl_status) {
		this.dbl_status = dbl_status;
	}
	public String getDbl_errormsg() {
		return dbl_errormsg;
	}
	public void setDbl_errormsg(String dbl_errormsg) {
		this.dbl_errormsg = dbl_errormsg;
	}
	public String getDbl_homeid() {
		return dbl_homeid;
	}
	public void setDbl_homeid(String dbl_homeid) {
		this.dbl_homeid = dbl_homeid;
	}
	public String getHometaxbill_id() {
		return hometaxbill_id;
	}
	public void setHometaxbill_id(String hometaxbill_id) {
		this.hometaxbill_id = hometaxbill_id;
	}
	public String getSpass() {
		return spass;
	}
	public void setSpass(String spass) {
		this.spass = spass;
	}
	public String getApikey() {
		return apikey;
	}
	public void setApikey(String apikey) {
		this.apikey = apikey;
	}
	public String getHomemunseo_id() {
		return homemunseo_id;
	}
	public void setHomemunseo_id(String homemunseo_id) {
		this.homemunseo_id = homemunseo_id;
	}
	public String getSignature() {
		return signature;
	}
	public void setSignature(String signature) {
		this.signature = signature;
	}
	public String getIssueid() {
		return issueid;
	}
	public void setIssueid(String issueid) {
		this.issueid = issueid;
	}
	public String getTypecode1() {
		return typecode1;
	}
	public void setTypecode1(String typecode1) {
		this.typecode1 = typecode1;
	}
	public String getTypecode2() {
		return typecode2;
	}
	public void setTypecode2(String typecode2) {
		this.typecode2 = typecode2;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getIssuedate() {
		return issuedate;
	}
	public void setIssuedate(String issuedate) {
		this.issuedate = issuedate;
	}
	public String getModifytype() {
		return modifytype;
	}
	public void setModifytype(String modifytype) {
		this.modifytype = modifytype;
	}
	public String getPurposetype() {
		return purposetype;
	}
	public void setPurposetype(String purposetype) {
		this.purposetype = purposetype;
	}
	public String getOriginalissueid() {
		return originalissueid;
	}
	public void setOriginalissueid(String originalissueid) {
		this.originalissueid = originalissueid;
	}
	public String getSi_id() {
		return si_id;
	}
	public void setSi_id(String si_id) {
		this.si_id = si_id;
	}
	public String getSi_hcnt() {
		return si_hcnt;
	}
	public void setSi_hcnt(String si_hcnt) {
		this.si_hcnt = si_hcnt;
	}
	public String getSi_startdt() {
		return si_startdt;
	}
	public void setSi_startdt(String si_startdt) {
		this.si_startdt = si_startdt;
	}
	public String getSi_enddt() {
		return si_enddt;
	}
	public void setSi_enddt(String si_enddt) {
		this.si_enddt = si_enddt;
	}
	public String getIr_companynumber() {
		return ir_companynumber;
	}
	public void setIr_companynumber(String ir_companynumber) {
		this.ir_companynumber = ir_companynumber;
	}
	public String getIr_biztype() {
		return ir_biztype;
	}
	public void setIr_biztype(String ir_biztype) {
		this.ir_biztype = ir_biztype;
	}
	public String getIr_companyname() {
		return ir_companyname;
	}
	public void setIr_companyname(String ir_companyname) {
		this.ir_companyname = ir_companyname;
	}
	public String getIr_bizclassification() {
		return ir_bizclassification;
	}
	public void setIr_bizclassification(String ir_bizclassification) {
		this.ir_bizclassification = ir_bizclassification;
	}
	public String getIr_ceoname() {
		return ir_ceoname;
	}
	public void setIr_ceoname(String ir_ceoname) {
		this.ir_ceoname = ir_ceoname;
	}
	public String getIr_busename() {
		return ir_busename;
	}
	public void setIr_busename(String ir_busename) {
		this.ir_busename = ir_busename;
	}
	public String getIr_name() {
		return ir_name;
	}
	public void setIr_name(String ir_name) {
		this.ir_name = ir_name;
	}
	public String getIr_cell() {
		return ir_cell;
	}
	public void setIr_cell(String ir_cell) {
		this.ir_cell = ir_cell;
	}
	public String getIr_email() {
		return ir_email;
	}
	public void setIr_email(String ir_email) {
		this.ir_email = ir_email;
	}
	public String getIr_companyaddress() {
		return ir_companyaddress;
	}
	public void setIr_companyaddress(String ir_companyaddress) {
		this.ir_companyaddress = ir_companyaddress;
	}
	public String getIe_companynumber() {
		return ie_companynumber;
	}
	public void setIe_companynumber(String ie_companynumber) {
		this.ie_companynumber = ie_companynumber;
	}
	public String getIe_biztype() {
		return ie_biztype;
	}
	public void setIe_biztype(String ie_biztype) {
		this.ie_biztype = ie_biztype;
	}
	public String getIe_companyname() {
		return ie_companyname;
	}
	public void setIe_companyname(String ie_companyname) {
		this.ie_companyname = ie_companyname;
	}
	public String getIe_bizclassification() {
		return ie_bizclassification;
	}
	public void setIe_bizclassification(String ie_bizclassification) {
		this.ie_bizclassification = ie_bizclassification;
	}
	public String getIe_taxnumber() {
		return ie_taxnumber;
	}
	public void setIe_taxnumber(String ie_taxnumber) {
		this.ie_taxnumber = ie_taxnumber;
	}
	public String getPartytypecode() {
		return partytypecode;
	}
	public void setPartytypecode(String partytypecode) {
		this.partytypecode = partytypecode;
	}
	public String getIe_ceoname() {
		return ie_ceoname;
	}
	public void setIe_ceoname(String ie_ceoname) {
		this.ie_ceoname = ie_ceoname;
	}
	public String getIe_busename1() {
		return ie_busename1;
	}
	public void setIe_busename1(String ie_busename1) {
		this.ie_busename1 = ie_busename1;
	}
	public String getIe_name1() {
		return ie_name1;
	}
	public void setIe_name1(String ie_name1) {
		this.ie_name1 = ie_name1;
	}
	public String getIe_cell1() {
		return ie_cell1;
	}
	public void setIe_cell1(String ie_cell1) {
		this.ie_cell1 = ie_cell1;
	}
	public String getIe_email1() {
		return ie_email1;
	}
	public void setIe_email1(String ie_email1) {
		this.ie_email1 = ie_email1;
	}
	public String getIe_busename2() {
		return ie_busename2;
	}
	public void setIe_busename2(String ie_busename2) {
		this.ie_busename2 = ie_busename2;
	}
	public String getIe_name2() {
		return ie_name2;
	}
	public void setIe_name2(String ie_name2) {
		this.ie_name2 = ie_name2;
	}
	public String getIe_cell2() {
		return ie_cell2;
	}
	public void setIe_cell2(String ie_cell2) {
		this.ie_cell2 = ie_cell2;
	}
	public String getIe_email2() {
		return ie_email2;
	}
	public void setIe_email2(String ie_email2) {
		this.ie_email2 = ie_email2;
	}
	public String getIe_companyaddress() {
		return ie_companyaddress;
	}
	public void setIe_companyaddress(String ie_companyaddress) {
		this.ie_companyaddress = ie_companyaddress;
	}
	public String getSu_companynumber() {
		return su_companynumber;
	}
	public void setSu_companynumber(String su_companynumber) {
		this.su_companynumber = su_companynumber;
	}
	public String getSu_biztype() {
		return su_biztype;
	}
	public void setSu_biztype(String su_biztype) {
		this.su_biztype = su_biztype;
	}
	public String getSu_companyname() {
		return su_companyname;
	}
	public void setSu_companyname(String su_companyname) {
		this.su_companyname = su_companyname;
	}
	public String getSu_bizclassification() {
		return su_bizclassification;
	}
	public void setSu_bizclassification(String su_bizclassification) {
		this.su_bizclassification = su_bizclassification;
	}
	public String getSu_taxnumber() {
		return su_taxnumber;
	}
	public void setSu_taxnumber(String su_taxnumber) {
		this.su_taxnumber = su_taxnumber;
	}
	public String getSu_ceoname() {
		return su_ceoname;
	}
	public void setSu_ceoname(String su_ceoname) {
		this.su_ceoname = su_ceoname;
	}
	public String getSu_busename() {
		return su_busename;
	}
	public void setSu_busename(String su_busename) {
		this.su_busename = su_busename;
	}
	public String getSu_name() {
		return su_name;
	}
	public void setSu_name(String su_name) {
		this.su_name = su_name;
	}
	public String getSu_cell() {
		return su_cell;
	}
	public void setSu_cell(String su_cell) {
		this.su_cell = su_cell;
	}
	public String getSu_email() {
		return su_email;
	}
	public void setSu_email(String su_email) {
		this.su_email = su_email;
	}
	public String getSu_companyaddress() {
		return su_companyaddress;
	}
	public void setSu_companyaddress(String su_companyaddress) {
		this.su_companyaddress = su_companyaddress;
	}
	public String getCash() {
		return cash;
	}
	public void setCash(String cash) {
		this.cash = cash;
	}
	public String getScheck() {
		return scheck;
	}
	public void setScheck(String scheck) {
		this.scheck = scheck;
	}
	public String getDraft() {
		return draft;
	}
	public void setDraft(String draft) {
		this.draft = draft;
	}
	public String getUncollected() {
		return uncollected;
	}
	public void setUncollected(String uncollected) {
		this.uncollected = uncollected;
	}
	public String getChargetotal() {
		return chargetotal;
	}
	public void setChargetotal(String chargetotal) {
		this.chargetotal = chargetotal;
	}
	public String getTaxtotal() {
		return taxtotal;
	}
	public void setTaxtotal(String taxtotal) {
		this.taxtotal = taxtotal;
	}
	public String getGrandtotal() {
		return grandtotal;
	}
	public void setGrandtotal(String grandtotal) {
		this.grandtotal = grandtotal;
	}
	public String getSupplyprice() {
		return supplyprice;
	}
	public void setSupplyprice(String supplyprice) {
		this.supplyprice = supplyprice;
	}
	public String getQuantity() {
		return quantity;
	}
	public void setQuantity(String quantity) {
		this.quantity = quantity;
	}
	public String getUnit() {
		return unit;
	}
	public void setUnit(String unit) {
		this.unit = unit;
	}
	public String getSubject() {
		return subject;
	}
	public void setSubject(String subject) {
		this.subject = subject;
	}
	public String getSub_issuedate() {
		return sub_issuedate;
	}
	public void setSub_issuedate(String sub_issuedate) {
		this.sub_issuedate = sub_issuedate;
	}
	public String getTax() {
		return tax;
	}
	public void setTax(String tax) {
		this.tax = tax;
	}
	public String getUnitprice() {
		return unitprice;
	}
	public void setUnitprice(String unitprice) {
		this.unitprice = unitprice;
	}
	public String getSub_description() {
		return sub_description;
	}
	public void setSub_description(String sub_description) {
		this.sub_description = sub_description;
	}
	

	
	
}
