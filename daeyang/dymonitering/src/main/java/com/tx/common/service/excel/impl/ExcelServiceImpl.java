package com.tx.common.service.excel.impl;

import static org.hamcrest.CoreMatchers.is;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellValue;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.FormulaEvaluator;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.common.service.excel.ExcelService;
import com.tx.dyAdmin.homepage.organization.dto.OrganDTO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;

@Service("ExcelService")
public class ExcelServiceImpl extends EgovAbstractServiceImpl implements ExcelService {
	
	@Autowired
	ComponentService Component;
	@Autowired
	CommonService CommonService;
	
	/** 프로퍼티 정보 읽기 */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;
	
public ArrayList<ArrayList<String>> readFilter_And_Insert(MultipartFile file) throws IOException {
		
		int cells = 15;	// 셀의 수
		
		//프로퍼티 경로 불러오기
		String propertiespath = propertiesService.getString("FilePath");
		
		String filePath = propertiespath + file.getOriginalFilename();
		
		File saveFile = new File(filePath);  // 적용 후
		try {
			file.transferTo(saveFile); // 실제 파일 저장메서드(filewriter 작업을 손쉽게 한방에 처리해준다.)
		} catch (IllegalStateException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		FileInputStream fis = new FileInputStream(filePath);
		
		@SuppressWarnings("resource")
		XSSFWorkbook workbook = new XSSFWorkbook(fis);
		FormulaEvaluator evaluator = workbook.getCreationHelper().createFormulaEvaluator();
		int rowindex = 0;
		int columnindex = 0;		
		ArrayList<ArrayList<String>> filters = new ArrayList<ArrayList<String>>();		
		
		int sheetCn = workbook.getNumberOfSheets();	// 시트 수
		for(int sheetnum=0; sheetnum<sheetCn; sheetnum++) {	// 시트 수만큼 반복
			
			int sheetnum2=sheetnum+1;
			System.out.println("sheet = " + sheetnum2);
			
			XSSFSheet sheet = workbook.getSheetAt(sheetnum);	// 읽어올 시트 선택
			int rows = sheet.getPhysicalNumberOfRows();    // 행의 수
			XSSFRow row = null;
			
			for (rowindex = 1; rowindex < rows; rowindex++) {	// 행의 수만큼 반복

				row = sheet.getRow(rowindex);	// rowindex 에 해당하는 행을 읽는다

				if (row != null) {
					cells = row.getPhysicalNumberOfCells();    // 열의 수
					
					if(cells != 0) {
						
						ArrayList<String> filter = new ArrayList<String>();	// 한 행을 읽어서 저장할 변수 선언
						
						for (columnindex = 1; columnindex <= cells; columnindex++) {	// 열의 수만큼 반복
							XSSFCell cell_filter = row.getCell(columnindex-1);	// 셀값을 읽는다
							String value = "";
							
							// 셀이 빈값일경우를 위한 널체크
							if (cell_filter == null) {
								value = " ";
							} else {
								// 타입별로 내용 읽기
								switch (cell_filter.getCellType()) {
								case FORMULA:
									value = evaluator.evaluate(cell_filter).formatAsString();
									value = value.replace("\"", "");
									
									break;
								case NUMERIC:		
									value = cell_filter.getNumericCellValue() + "";
									int val = value.indexOf(".");
									
									// .0일때  처리
									if(value.substring(val, value.length()).equals(".0")){ 
										value = value.substring(0, val);
									}
									
									// 날짜 형식인 경우 처리
									if (DateUtil.isCellDateFormatted(cell_filter)) {
										SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
										value = dateFormat.format(cell_filter.getDateCellValue());
									}
									break;
								case STRING:
									value = cell_filter.getStringCellValue() + "";
									break;
								case BLANK:
									value = cell_filter.getBooleanCellValue() + "";
									break;
								case ERROR:
									value = cell_filter.getErrorCellValue() + "";
									break;
								}
							}
							//24.06.10 형식일 경우 2024-06-10으로 insert(FORMULA, STRING 값을 처리
							if (value.matches("\\d{2}\\.\\d{2}\\.\\d{2}")) {
                                value = "20" + value.substring(0, 2) + "-" + value.substring(3, 5) + "-" + value.substring(6, 8);
                            }
							
							filter.add(value);	//읽은 셀들을 filter에 추가 (행)
						}
						filters.add(filter); //filter(행)을 filters(열)에 추가
					}// if(cells != 0)
				}
			}
		}
		fis.close();	//파일 읽기 종료
		return filters;	//리스트 반환
	}

	public void createExcelWorkBook(HttpServletResponse response) throws Exception{
		
		String[] sheetName = {"조직도","조직원"};
		List<String> headerList = null; 
		
		XSSFWorkbook workbook = new XSSFWorkbook();
		
		// 테이블 헤더용 스타일
		XSSFCellStyle headStyle = workbook.createCellStyle();
		// 가는 경계선을 가집니다.
		headStyle.setBorderTop(BorderStyle.THIN);
		headStyle.setBorderBottom(BorderStyle.THIN);
		headStyle.setBorderLeft(BorderStyle.THIN);
		headStyle.setBorderRight(BorderStyle.THIN);
		// 데이터는 가운데 정렬합니다.
		headStyle.setAlignment(HorizontalAlignment.CENTER);
		headStyle.setFillForegroundColor(new XSSFColor(new byte[] {(byte) 255,(byte) 217,(byte) 31}, null));
		headStyle.setFillPattern(FillPatternType.FINE_DOTS);

		// 데이터용 경계 스타일 테두리만 지정
		XSSFCellStyle bodyStyle = workbook.createCellStyle();
		bodyStyle.setBorderTop(BorderStyle.THIN);
		bodyStyle.setBorderBottom(BorderStyle.THIN);
		bodyStyle.setBorderLeft(BorderStyle.THIN);
		bodyStyle.setBorderRight(BorderStyle.THIN);
		
		for (int i = 0; i < sheetName.length; i++) {
			
			// 시트 생성
			XSSFSheet sheet = workbook.createSheet(sheetName[i]);
			// 헤더 행 생
			Row headerRow = sheet.createRow(0);
			Cell headerCell;
			
			headerList = new ArrayList<>();
			if(i == 0){
				headerList.add("키");
				headerList.add("메인키");
				headerList.add("순서");
				headerList.add("부서명");
				headerList.add("임시부서 여부");
			}else{
				headerList.add("성명");
				headerList.add("부서명");
				headerList.add("직위");
				headerList.add("담당업무");
				headerList.add("연락처");
			}
			
			for(int j=0; j<headerList.size(); j++) {
				headerCell = headerRow.createCell(j); 
				headerCell.setCellValue(headerList.get(j));
				headerCell.setCellStyle(headStyle);
			}
			
			if(i==1){
				Row bodyRow = sheet.createRow(1);
				Cell bodyCell = bodyRow.createCell(0);
				bodyCell.setCellValue("소계");
				bodyCell.setCellStyle(bodyStyle);
			}
		}
        
        // 컨텐츠 타입과 파일명 지정
        response.setContentType("ms-vnd/excel");
        response.setHeader("Content-Disposition", "attachment;filename=organ_sample.xlsx");

        // 엑셀 출력
        workbook.write(response.getOutputStream());

        workbook.close();
	}
	
	public void createExcelData(HttpServletResponse response, List<HashMap<String,Object>> result) throws IOException{
		
		String sheetName = "발전량";
		List<String> headerList = null; 
		
		XSSFWorkbook workbook = new XSSFWorkbook();
		
		// 테이블 헤더용 스타일
		XSSFCellStyle headStyle = workbook.createCellStyle();
		// 가는 경계선을 가집니다.
		headStyle.setBorderTop(BorderStyle.THIN);
		headStyle.setBorderBottom(BorderStyle.THIN);
		headStyle.setBorderLeft(BorderStyle.THIN);
		headStyle.setBorderRight(BorderStyle.THIN);
		// 데이터는 가운데 정렬합니다.
		headStyle.setAlignment(HorizontalAlignment.CENTER);
		headStyle.setFillForegroundColor(new XSSFColor(new byte[] {(byte) 255,(byte) 217,(byte) 31}, null));
		headStyle.setFillPattern(FillPatternType.FINE_DOTS);
		
		// 데이터용 경계 스타일 테두리만 지정
		XSSFCellStyle bodyStyle = workbook.createCellStyle();
		bodyStyle.setBorderTop(BorderStyle.THIN);
		bodyStyle.setBorderBottom(BorderStyle.THIN);
		bodyStyle.setBorderLeft(BorderStyle.THIN);
		bodyStyle.setBorderRight(BorderStyle.THIN);
		
		// 시트 생성
		XSSFSheet sheet = workbook.createSheet(sheetName);
			
		// 헤더 행 생성
		Row headerRow = sheet.createRow(0);
		Cell headerCell;
		
		headerList = new ArrayList<>();
		
		// 해시맵의 키로 헤더행의 값 설정
		HashMap<String, Object> firstResultList = result.get(0);
		for(String key: firstResultList.keySet()){
			headerList.add(key);
		}
		
		//헤더 셀 생성
		for(int j=0; j<headerList.size(); j++) {
			headerCell = headerRow.createCell(j); 
			headerCell.setCellValue(headerList.get(j));
			headerCell.setCellStyle(headStyle);
		}
		
		// 바디 행 및 셀 생성
		for(int i=1; i<result.size()+1; i++) {
			
			HashMap<String, Object> reSdataList = result.get(i-1);
			List<String> keyList = new ArrayList<>(reSdataList.keySet());
			Row bodyRow = sheet.createRow(i);
			
			for(int k=0; k < reSdataList.size(); k++) {
				Cell bodyCell = bodyRow.createCell(k);
				String keys = keyList.get(k);
				
				switch (reSdataList.get(keys).getClass().getSimpleName()){
				case "String": bodyCell.setCellValue((String)reSdataList.get(keys)); break;
				case "Double": bodyCell.setCellValue((double) reSdataList.get(keys)); break;
				case "Integer": bodyCell.setCellValue((double) reSdataList.get(keys)); break;
				case "Timestamp": bodyCell.setCellValue((double) reSdataList.get(keys));break;
				}
				bodyCell.setCellStyle(bodyStyle);
			}
		}

		// 컨텐츠 타입과 파일명 지정
		response.setContentType("ms-vnd/excel");
		response.setHeader("Content-Disposition", "attachment;filename=organ_sample.xlsx");
		
		// 엑셀 출력
		workbook.write(response.getOutputStream());
		
		workbook.close();
	}
	
	
	public void ExcelInsert(MultipartFile file, String organHomeKey) throws Exception {
		
		List<HashMap<String,Object>> organList = new ArrayList<HashMap<String,Object>>();
		List<String> keyMapList = new ArrayList<String>();;
		List<HashMap<String,Object>> userList = new ArrayList<HashMap<String,Object>>();
		
		String[] organArr = {"key","mainKey","lev","organNM","tempYN"};
		String[] userArr = {"name","organNM","spot","task","tel"};
		
		//엑셀파일
		File convfile = new File(file.getOriginalFilename());
		file.transferTo(convfile);
		
		
		//엑셀 파일 오픈
		XSSFWorkbook wb = new XSSFWorkbook(new FileInputStream(convfile));
		
		setOrganMapList(wb,0,organList,organArr,"organ",keyMapList);
		setOrganMapList(wb,1,userList,userArr,"user",null);
		
		wb.close();
		convfile.delete();
		
		for (HashMap<String,Object> organ : organList) {
			OrganDTO organDTO = new OrganDTO();
			String key = keyMapList.get(Integer.parseInt((String)organ.get(organArr[0]))-1).toString();
			String dnName = (String)organ.get(organArr[3]);
			String mainKey = "";
			
			if(StringUtils.isNotBlank((String)organ.get(organArr[1]))){
				mainKey = keyMapList.get(Integer.parseInt((String)organ.get(organArr[1]))-1).toString();
			}
			
			organDTO.setDN_KEYNO(key);
			organDTO.setDN_MAINKEY(mainKey);
			organDTO.setDN_LEV(Integer.parseInt((String)organ.get(organArr[2])));
			organDTO.setDN_NAME(dnName);
			organDTO.setDN_TEMP((String)organ.get(organArr[4]));
			organDTO.setDN_HOMEDIV_C(organHomeKey);
			Component.createData("Organization.DN_excelInsert", organDTO);
			
			for (HashMap<String,Object> user : userList) {
				String dudnNM = (String)user.get(userArr[1]);
				
				if(dnName.equals(dudnNM)){
					OrganDTO organDTO2 = new OrganDTO();
					organDTO2.setDU_KEYNO(CommonService.getTableKey("DU"));
					organDTO2.setDU_DN_KEYNO(key);
					organDTO2.setDU_NAME((String)user.get(userArr[0]));
					organDTO2.setDU_ROLE((String)user.get(userArr[2]));
					organDTO2.setDU_CONTENTS((String)user.get(userArr[3]));
					organDTO2.setDU_TEL((String)user.get(userArr[4]));
					organDTO2.setDU_LEV((Integer) user.get("lev"));
					Component.createData("Organization.DU_excelInsert", organDTO2);
				}
			}
		}
		
	}
	
	private void setOrganMapList(XSSFWorkbook wb, int sheetNum, List<HashMap<String, Object>> valMapList
			, String[] trArr, String type, List<String> keyMapList) {
		// TODO Auto-generated method stub
		
		Integer duMaxLev = 0;
		Integer startLev = 1;
		
		XSSFSheet sheet=wb.getSheetAt(sheetNum);
		int rows = sheet.getPhysicalNumberOfRows();
		for (int i = 1; i < rows; i++) {
			//행을읽는다
		    XSSFRow row=sheet.getRow(i);
		    
		    if(row != null){
		    	//셀이 비어있으면 다음데이터로 넘어감 
		    	if (row.getCell(0) == null) {
		    		continue;
		    	}
		    	
		    	if("소계".equals(row.getCell(0).toString())){
	    			XSSFCell cell = row.getCell(1);
					duMaxLev = Integer.parseInt(getCellValue(cell,wb));
					continue;
				}else{
					//셀의 수
					int cells=row.getPhysicalNumberOfCells();
					HashMap<String, Object> valMap = new HashMap<String, Object>();
					for (int j = 0; j <= cells; j++) {
						XSSFCell cell = row.getCell(j);
						String value="";
						//셀이 빈값일경우를 위한 널체크
						if(cell==null){
							continue;
						}else{
							//타입별로 내용 읽기
							value = getCellValue(cell,wb);
						}
						valMap.put(trArr[j], value);
						
						if("organ".equals(type) && "key".equals(trArr[j]) && StringUtils.isNotEmpty(value)){
							keyMapList.add(CommonService.getTableKey("DN"));
						}
						
					}
					if("user".equals(type)) valMap.put("lev",startLev++);
					valMapList.add(valMap);
				}
		    	if("user".equals(type)) if(startLev >= duMaxLev) startLev = 1;
		    }
		}
	}

	@SuppressWarnings("incomplete-switch")
	private String getCellValue(XSSFCell cell, XSSFWorkbook wb) {
		String value = "";
		switch (cell.getCellType()){
		case FORMULA:
			FormulaEvaluator formulaEval = wb.getCreationHelper().createFormulaEvaluator();
			if( cell != null ) {
				CellValue evaluate = formulaEval.evaluate(cell);
				if( evaluate != null ) value = evaluate.formatAsString();
			}
			value = String.valueOf(Math.round(Double.parseDouble(value)));
			break;
		case NUMERIC:
			value = String.valueOf(Math.round(cell.getNumericCellValue()));
			break;
		case STRING:
			value=(String)cell.getStringCellValue();
			break;
		case BLANK:
			value="";
			break;
		case ERROR:
			value=cell.getErrorCellValue()+"";
			break;
		}
		
		return value;
	}
	
	
}
