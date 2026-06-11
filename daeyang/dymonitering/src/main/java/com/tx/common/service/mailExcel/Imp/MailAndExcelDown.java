package com.tx.common.service.mailExcel.Imp;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Properties;

import javax.mail.BodyPart;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Store;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.springframework.stereotype.Service;

import com.ibm.icu.text.SimpleDateFormat;
import com.ibm.icu.util.Calendar;
import com.tx.common.service.mailExcel.MailAndExcelDownService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;


@Service("MailAndExcelDownService")
public class MailAndExcelDown extends EgovAbstractServiceImpl implements MailAndExcelDownService {
	 
	public ArrayList<HashMap<String, Object>> main(HttpServletResponse res,String hostmap, String user, String passw) throws Exception {
	        String host = hostmap;
	        String username = user;
	        String password = passw;

 	        Properties properties = new Properties();
	        properties.setProperty("mail.store.protocol", "imaps");
	        properties.setProperty("mail.imaps.ssl.protocols", "TLSv1.2");
	        properties.setProperty("mail.imaps.ssl.ciphersuites", "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256");
            
            int endnumber = 500;
            String content = "";
            ArrayList<HashMap<String, Object>> sheet = new ArrayList<HashMap<String, Object>>();

	        try {
		        Session session = Session.getDefaultInstance(properties, null);
	            Store store = session.getStore();
	            store.connect(host, username, password);

	            Folder inbox = store.getFolder("한국전력공사"); //하위폴더일경우 ex) 한국전자인증/한국신재생에너지/국세청  
	            inbox.open(Folder.READ_ONLY);
	            
	            // Get the messages
	            Message[] messages = inbox.getMessages();
	            
	            // Print each mes sage
	            for (int i = messages.length-1 ; i > messages.length-endnumber-1 ; i--) {
	                String title = messages[i].getSubject();
	            	String from = messages[i].getFrom()[0].toString();
	            	 if (messages[i] instanceof MimeMessage) {
	            		 MimeMessage mimeMessage = (MimeMessage) messages[i];
	            		 content =  extractContent(mimeMessage);
	            	 }
	            	
	            	
	                if(from.contains("kepco@kepco.co.kr") && !content.isEmpty() && title.contains("신재생에너지 요금안내")) {

	                	Document document  = Jsoup.parseBodyFragment(content);
	                	String selector = "body > table:nth-child(3) > tbody > tr > td > font > strong";
	                	Element tags = document.selectFirst(selector);
	                	
	                	if(tags == null ) continue;
	                	
                		String tep = tags .text().toString();
                		
                		String name = tep.substring(0,tep.lastIndexOf("발전소")); 
                		String date = tep.substring(tep.lastIndexOf("발전소")+4 ,tep.indexOf("월분")).trim(); 
                		String price = tep.substring(tep.indexOf("기준")+2,tep.indexOf("원 입니다.")); 
                		
                		//날짜에 따라 분리
                		SimpleDateFormat yMonth = new SimpleDateFormat("yyyy.MM");
                		
                		Calendar cal = Calendar.getInstance();
                		
                		cal.add(cal.MONTH, -1);
                		
                		if(!yMonth.format(cal.getTime()).toString().equals(date)) {
                			
                			System.out.println("시간 다름 종료");
                			break;
                		}
                		
                		HashMap<String, Object> map = new HashMap<String, Object>();
                		map.put("name",name);
                		map.put("price",price);
                		map.put("date",date);
                		
                		System.out.println(name);
                		sheet.add(map);	
	                }
	            }
	            
	            inbox.close(true);
		        store.close();
		        System.out.println("끝!!");
		        
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	        return sheet;
	    }
	
	//내용 Multpart부분 타입 수정부
	 private static String extractContent(MimeMessage mimeMessage) {
		 String msg = "";   
		 try {
	            Object content = mimeMessage.getContent();
	            
	            if (content instanceof MimeMultipart) {
	                MimeMultipart multipart = (MimeMultipart) content;

	                // MimeMultipart의 각 BodyPart를 처리
	                for (int i = 0; i < multipart.getCount(); i++) {
	                    BodyPart bodyPart = multipart.getBodyPart(i);

	                    // BodyPart의 내용을 처리
	                    msg = processBodyPart(bodyPart);
	                }
	            } else {
	                // 단일 부분인 경우
	                System.out.println("Content: " + content);
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
		 return msg;
	    }

	    // 내용 타입에 따른 추출부
	    private static String processBodyPart(BodyPart bodyPart) throws MessagingException, IOException {
	        //System.out.println("Content Type: " + bodyPart.getContentType());
	    	String msg = "";
	        // Content-Type에 따라 다르게 처리 가능
	        if (bodyPart.isMimeType("text/plain")) {
	            // 텍스트 형식 처리
	        	msg  = bodyPart.getContent().toString();
	        } else if (bodyPart.isMimeType("text/html")) {
	        	msg  = bodyPart.getContent().toString();
	        } else {
	            // 기타 형식 처리
	            msg  = bodyPart.getContent().toString();
	        }
	        return msg;
	    }
	    
	    
	    //엑셀 정리 및 다운로드 부분
	    public void ExcelDown( ArrayList<ArrayList<String>> dataSheet, HttpServletResponse res) throws Exception{
	    	
	    	
	    	
	    	
	    	//excel sheet 생성
	    	 Workbook workbook = new XSSFWorkbook();
	    	 Sheet sheet = workbook.createSheet("Sheet1"); // 엑셀 sheet 이름
	         sheet.setDefaultColumnWidth(28); // 디폴트 너비 설정
	    	
	         /**
	          * header font style
	          */
	         XSSFFont headerXSSFFont = (XSSFFont) workbook.createFont();
	         headerXSSFFont.setColor(new XSSFColor(new byte[]{(byte) 255, (byte) 255, (byte) 255}, null));

	         /**
	          * header cell style
	          */
	         XSSFCellStyle headerXssfCellStyle = (XSSFCellStyle) workbook.createCellStyle();

	         // 테두리 설정
	         headerXssfCellStyle.setBorderLeft(BorderStyle.THIN);
	         headerXssfCellStyle.setBorderRight(BorderStyle.THIN);
	         headerXssfCellStyle.setBorderTop(BorderStyle.THIN);
	         headerXssfCellStyle.setBorderBottom(BorderStyle.THIN);

	         // 배경 설정
	         headerXssfCellStyle.setFillForegroundColor(new XSSFColor(new byte[]{(byte) 34, (byte) 37, (byte) 41}, null));
	         headerXssfCellStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
	         headerXssfCellStyle.setFont(headerXSSFFont);

	         /**
	          * body cell style
	          */
	         XSSFCellStyle bodyXssfCellStyle = (XSSFCellStyle) workbook.createCellStyle();

	         // 테두리 설정
	         bodyXssfCellStyle.setBorderLeft(BorderStyle.THIN);
	         bodyXssfCellStyle.setBorderRight(BorderStyle.THIN);
	         bodyXssfCellStyle.setBorderTop(BorderStyle.THIN);
	         bodyXssfCellStyle.setBorderBottom(BorderStyle.THIN);
	         
	         

	         /**
	          * header data
	          */
	         int rowCount = 0; // 데이터가 저장될 행
	         String headerNames[] = new String[]{"태양광 이름", "공급가액", "날짜"};

	         Row headerRow = null;
	         Cell headerCell = null;

	         headerRow = sheet.createRow(rowCount++);
	         
	         for(int i=0; i<headerNames.length; i++) {
	             headerCell = headerRow.createCell(i);
	             headerCell.setCellValue(headerNames[i]); // 데이터 추가
	             headerCell.setCellStyle(headerXssfCellStyle); // 스타일 추가
	         }

	         Row bodyRow = null;
	         Cell bodyCell = null;

	         for(ArrayList<String> data : dataSheet) {
	             bodyRow = sheet.createRow(rowCount++);

	             for(int i=0; i<data.size(); i++) {
	                 bodyCell = bodyRow.createCell(i);
	                 bodyCell.setCellValue(data.get(i).toString()); // 데이터 추가
	                 bodyCell.setCellStyle(bodyXssfCellStyle); // 스타일 추가
	             }
	         }
	         
	         /**
	          * download
	          */
	         String fileName = "dy_mail_excelDown";

	         res.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
	         res.setHeader("Content-Disposition", "attachment;filename=" + fileName + ".xlsx");
	         ServletOutputStream servletOutputStream = res.getOutputStream();

	         workbook.write(servletOutputStream);
	         workbook.close();
	         servletOutputStream.flush();
	         servletOutputStream.close();
	    }
	    
}
