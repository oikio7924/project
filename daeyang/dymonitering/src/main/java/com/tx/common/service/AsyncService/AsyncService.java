package com.tx.common.service.AsyncService;

import javax.servlet.http.HttpServletResponse;

import com.tx.test.dto.billDTO;

public interface AsyncService {

   public String sendApi(billDTO bill, String tocken) throws Exception;
   
   public void allSendNTS(billDTO bill, String subkey) throws Exception;
   
   public void sendNTS(billDTO bill, String dbl_keyno) throws Exception;
	
}
