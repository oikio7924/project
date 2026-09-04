package com.tx.common.service.pdf;

import java.awt.Color;
import java.io.File;
import java.io.IOException;


import org.apache.commons.io.FileUtils;

import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.Font.FontFamily;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.Image;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.Rectangle;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.ColumnText;
import com.itextpdf.text.pdf.PdfContentByte;
import com.itextpdf.text.pdf.PdfImportedPage;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfReader;
import com.itextpdf.text.pdf.PdfWriter;

public class PDFController {
	 
	
	public static void main(String[] args) throws IOException, DocumentException {
		
		Document document = new Document(PageSize.A4.rotate());
		 
		// 출력할 pdf 파일
	    PdfWriter writer = PdfWriter.getInstance(document, FileUtils.openOutputStream(new File("D:/workspace/dysystem/src/main/webapp/resources/img/pdf/result/resultout.pdf")));
	    document.open();
	    
	    PdfContentByte canvas = writer.getDirectContent();
		 
	    // 원본 pdf 파일(클래스패스에서 가져옴)
        PdfReader reader = new PdfReader("D:/workspace/dysystem/src/main/webapp/resources/img/pdf/test.pdf");
        
        //test 이미지 
        Image img = Image.getInstance("D:/workspace/dysystem/src/main/webapp/resources/img/pdf/test.png");
        img.setAbsolutePosition(200, 300);
        img.scalePercent(20);
        
        BaseFont base_font = BaseFont.createFont("D:/workspace/dysystem/src/main/webapp/resources/font/NanumGothic.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
        Font f = new Font(base_font,28,Font.BOLD);
        
        //reader.getNumberOfPages();
        // 원본 pdf 에서 페이지를 하나씩 읽어서 출력 pdf 에 추가한다.
        for (int num = 1, size = 3; num <= size; num++) {
            PdfImportedPage page = writer.getImportedPage(reader, num);

            document.newPage();

            // 0, 0 위치에 페이지 추가(참고로 itext에서 좌표 체계는 왼쪽 아래에서 부터 0, 0으로 시작함, 그래프와 비슷함)
            canvas.addTemplate(page, 28, 25);
            // 첫번째 페이지만 상단에 테이블 추가
            if (num == 1) {
            	
            	
            	f = new Font(base_font,28,Font.BOLD);
            	f.setColor(0, 51, 102);
            	ColumnText.showTextAligned(canvas, Element.ALIGN_CENTER, new Phrase("500KW+300KW",f), 590, 448, 0);
            	f = new Font(base_font,32,Font.BOLD);
            	f.setColor(0, 51, 102);
            	ColumnText.showTextAligned(canvas, Element.ALIGN_CENTER, new Phrase("축사 지붕형 태양광",f), 428, 387, 0);
            	
            	f = new Font(base_font,24,Font.BOLD);
            	f.setColor(0, 51, 102);
            	ColumnText.showTextAligned(canvas, Element.ALIGN_CENTER, new Phrase("경상남도 사천시 곤양면 어류길 76 외",f), 437, 337, 0);
            	
//            	makeContent("hello").writeSelectedRows(0, -1, 170, document.top() - 170, canvas);
//            	Paragraph paragraph = new Paragraph("Second paragraph");
//            	makeHeader("1234567", "홍길동").writeSelectedRows(0, -1, 20, document.top() - 50, canvas);
//            	paragraph.setSpacingBefore(380f);
//            	document.add(paragraph);
            	// 워터마트 이미지 추가
//                canvas.addImage(img);
            }else if (num == 3 ) {
            	f = new Font(base_font,16,Font.NORMAL,BaseColor.BLACK);
            	ColumnText.showTextAligned(canvas, Element.ALIGN_LEFT, new Phrase("경상남도 사천시 곤양면 어류길 76 외",f), 172, 418, 0);
            	ColumnText.showTextAligned(canvas, Element.ALIGN_LEFT, new Phrase("약 800KW (500KW + 300KW , 2SET)",f), 172, 373, 0);
            	ColumnText.showTextAligned(canvas, Element.ALIGN_LEFT, new Phrase("100KW x 8대 (에너지관리공단 인증제품)",f), 172, 288, 0);
            	ColumnText.showTextAligned(canvas, Element.ALIGN_LEFT, new Phrase("고정형",f), 172, 243, 0);
            	f = new Font(base_font,12,Font.NORMAL,BaseColor.BLACK);
            	ColumnText.showTextAligned(canvas, Element.ALIGN_LEFT, new Phrase("사천 변전소 두원DL - 2022년 3월 기준 선로연계 가능(약 4,500KW)",f), 172, 113, 0);
            	
            	canvas.addImage(img);
            }

            // 이미지 투명하게 처리
            /*PdfGState state = new PdfGState();
            state.setFillOpacity(0.2f);
            canvas.setGState(state);*/
        }
        document.close();        
	 }
}
