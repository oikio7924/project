/*package com.tx.common.service.pdf;

import java.io.File;
import java.io.IOException;


import org.apache.commons.io.FileUtils;

import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Font;
import com.itextpdf.text.Image;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.Rectangle;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfContentByte;
import com.itextpdf.text.pdf.PdfDocument;
import com.itextpdf.text.pdf.PdfImportedPage;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfPage;
import com.itextpdf.text.pdf.PdfReader;
import com.itextpdf.text.pdf.PdfString;
import com.itextpdf.text.pdf.PdfWriter;

public class PDFController2 {
	 
	public static final String DEST = "results/chapter02/canvas_return.pdf";
	
	public static void main(String[] args) throws IOException, DocumentException {
		File file = new File(DEST);
        file.getParentFile().mkdirs();
        new PDFController2().createPdf(DEST);
        
	 }
	

    public void createPdf(String dest) throws IOException {
        //Initialize PDF document
        PdfDocument pdf = new PdfDocument(new PdfWriter(dest));

        PdfPage page = pdf.addNewPage();
        pdfCanvas pdfCanvas = new PdfCanvas(page);
        Rectangle rectangle = new Rectangle(36, 650, 100, 100);
        pdfCanvas.rectangle(rectangle);
        pdfCanvas.stroke();
        Canvas canvas1 = new Canvas(pdfCanvas, rectangle);
        PdfFont font = PdfFontFactory.createFont(StandardFonts.TIMES_ROMAN);
        PdfFont bold = PdfFontFactory.createFont(StandardFonts.TIMES_BOLD);
        Text title = new Text("The Strange Case of Dr. Jekyll and Mr. Hyde").setFont(bold);
        Text author = new Text("Robert Louis Stevenson").setFont(font);
        Paragraph p = new Paragraph().add(title).add(" by ").add(author);
        canvas1.add(p);
        canvas1.close();

        PdfPage page2 = pdf.addNewPage();
        PdfCanvas pdfCanvas2 = new PdfCanvas(page2);
        Canvas canvas2 = new Canvas(pdfCanvas2, rectangle);
        canvas2.add(new Paragraph("Dr. Jekyll and Mr. Hyde"));
        canvas2.close();

        PdfPage page1 = pdf.getFirstPage();
        PdfCanvas pdfCanvas1 = new PdfCanvas(
            page1.newContentStreamBefore(), page1.getResources(), pdf);
        rectangle = new Rectangle(100, 700, 100, 100);
        pdfCanvas1.saveState()
                .setFillColor(ColorConstants.CYAN)
                .rectangle(rectangle)
                .fill()
                .restoreState();
        Canvas canvas = new Canvas(pdfCanvas1, rectangle);
        canvas.add(new Paragraph("Dr. Jekyll and Mr. Hyde"));
        canvas.close();

        //Close document
        pdf.close();
    }
	
	
}*/