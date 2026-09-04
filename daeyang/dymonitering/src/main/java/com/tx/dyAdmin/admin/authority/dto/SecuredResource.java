package com.tx.dyAdmin.admin.authority.dto;

import lombok.Data;

@Data
public class SecuredResource {

		private String 	USR_KEYNO
						, USR_PATTERN
						, USR_UIR_KEYNO
						, USR_MN_KEYNO
						, UIA_KEYNO;
		
		private Integer USR_ORDER= null;
		
		public SecuredResource(String _USR_KEYNO,String _UIA_KEYNO) {
			this.USR_KEYNO = _USR_KEYNO;
			this.UIA_KEYNO = _UIA_KEYNO;
		}
		
		public SecuredResource(String _USR_KEYNO, String _USR_PATTERN, int _USR_ORDER, String _USR_UIR_KEYNO,String _USR_MN_KEYNO) {
			this.USR_KEYNO = _USR_KEYNO;
			this.USR_PATTERN = _USR_PATTERN;
			this.USR_ORDER = _USR_ORDER;
			this.USR_UIR_KEYNO = _USR_UIR_KEYNO;
			this.USR_MN_KEYNO = _USR_MN_KEYNO;
		}

}
