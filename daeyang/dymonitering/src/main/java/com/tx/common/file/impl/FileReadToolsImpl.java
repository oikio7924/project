package com.tx.common.file.impl;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;
import org.apache.pdfbox.text.PDFTextStripperByArea;
import org.apache.poi.hssf.extractor.ExcelExtractor;
import org.apache.poi.hwpf.HWPFDocument;
import org.apache.poi.hwpf.extractor.WordExtractor;
import org.apache.poi.openxml4j.opc.OPCPackage;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.xssf.extractor.XSSFExcelExtractor;
import org.apache.poi.xwpf.extractor.XWPFWordExtractor;
import org.springframework.stereotype.Service;

import com.tx.common.file.FileReadTools;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import kr.dogfoot.hwplib.object.HWPFile;
import kr.dogfoot.hwplib.reader.HWPReader;
import kr.dogfoot.hwplib.tool.textextractor.TextExtractMethod;
import kr.dogfoot.hwplib.tool.textextractor.TextExtractor;



@SuppressWarnings("deprecation")
@Service("FileReadTools")
public class FileReadToolsImpl extends EgovAbstractServiceImpl implements FileReadTools{
	
	public String fileRead(String path){
	    File inFile = new File(path);
	    StringBuilder list = new StringBuilder();
	    String line = new String();
	  
	    try(BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(inFile), "UTF-8"));) {
	  
	    	while ((line = br.readLine()) != null)
	        list.append(line); 
	    	
	    } catch (FileNotFoundException e) {
	    	System.out.println("FileNotFoundException 에러");
	    } catch (IOException e) {
	    	System.out.println("IOException 에러");
	    } 
	    return list.toString();
	}
	  
	public String excelRead(String path){
	    String content = "";
	    try ( FileInputStream fs = new FileInputStream(new File(path));
	  	      OPCPackage d = OPCPackage.open(fs);
	  	      ){
	      XSSFExcelExtractor xe = new XSSFExcelExtractor(d);
	      xe.setFormulasNotResults(true);
	      xe.setIncludeSheetNames(true);
	      content = xe.getText();
	      xe.close();
	    } catch (Exception exception) {
	    	System.out.println("excelRead 에러");
	    }
	    return content;
	}
	  
	public String excelReadXls(String path){
	  String content = "";
	  try (POIFSFileSystem fs = new POIFSFileSystem(new FileInputStream(path));
		   ExcelExtractor ex = new ExcelExtractor(fs);){
		    ex.setFormulasNotResults(true);
		    ex.setIncludeSheetNames(true);
		    content = ex.getText();
	  } catch (Exception exception) {
    	System.out.println("excelReadXls 에러");
	  }
	  return content;
	}
	
	
	public String readDoc(String path){
	  String content = "";
	  try(POIFSFileSystem fs = new POIFSFileSystem(new FileInputStream(path));
		  HWPFDocument doc = new HWPFDocument(fs);
		  WordExtractor we = new WordExtractor(doc);
		  ) {
		 
		 content = we.getText();
		
	  } catch (Exception exception) {
		  System.out.println("readDoc 에러");
	  }
	  return content;
	}
	
	public String readDocx(String path){
	  String content = "";
	  try(FileInputStream fs = new FileInputStream(new File(path));
		  OPCPackage d = OPCPackage.open(fs);
		  ) {
		  XWPFWordExtractor xw = new XWPFWordExtractor(d);
	    content = xw.getText();
	    xw.close();
	  } catch (Exception exception) {
		  System.out.println("readDocx 에러");
	  }
	  return content;
	}
	
	public String readPdf(String path){
	   String content = "";
		   
	   try{
		   PDDocument document = PDDocument.load(new File(path));
		   PDFTextStripperByArea stripper = new PDFTextStripperByArea();
		   stripper.setSortByPosition(true);
		   PDFTextStripper Tstripper = new PDFTextStripper();
		   Tstripper.setStartPage(1);
		   Tstripper.setEndPage(document.getNumberOfPages());
		   String st = Tstripper.getText(document);
		   content = st;
		   document.close();
		} catch (IOException e) {
			System.out.println("readPdf 에러");
		}
	   return content;
	 }
	
	public String readHwp(String path){
		String content = "";

		HWPFile hwpFile;
		String hwpText = "";
		try {
			hwpFile = HWPReader.fromFile(path);
			hwpText = TextExtractor.extract(hwpFile, TextExtractMethod.InsertControlTextBetweenParagraphText);
		} catch (Exception e) {
			e.printStackTrace();
		}
		content = hwpText;
		return content;
	}
	
	
}
