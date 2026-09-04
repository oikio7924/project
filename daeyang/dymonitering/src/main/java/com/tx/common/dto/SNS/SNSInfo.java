package com.tx.common.dto.SNS;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.tx.common.config.tld.SiteProperties;

import lombok.Data;

/**
 * SNS META Tag 정보 VO
 * @author 이재령  2016/07/11
 *
 */
@Data
public class SNSInfo {
	
	
	public SNSInfo(){
		IMG_WIDTH = SiteProperties.getInt("SNS_IMAGE_WIDTH");
		IMG_HEIGHT = SiteProperties.getInt("SNS_IMAGE_HEIGHT");
	}
	
	private String TITLE,DESC,IMG,URL;
	
	private String description, keywords;
	
	private Integer IMG_WIDTH,IMG_HEIGHT;

	public void setContents(String contents){
		if(contents == null) return;
		
		Pattern SCRIPTS = Pattern.compile("<script([^'\"]|\"[^\"]*\"|'[^']*')*?</script>",Pattern.DOTALL);
		Pattern STYLE = Pattern.compile("<style[^>]*>.*</style>",Pattern.DOTALL);
		Pattern TAGS = Pattern.compile("<(/)?([a-zA-Z0-9:]*)(\\s[a-zA-Z0-9]*=[^>]*)?(\\s)*(/)?>");
//		Pattern nTAGS = Pattern.compile("<\\w+\\s+[^<]*\\s*>");
		Pattern ENTITY_REFS = Pattern.compile("&[^;]+;");
		Pattern WHITESPACE = Pattern.compile("\\s\\s+");

		Matcher m;

		m = SCRIPTS.matcher(contents);
		contents = m.replaceAll("");

		m = STYLE.matcher(contents);
		contents = m.replaceAll("");

		m = TAGS.matcher(contents);
		contents = m.replaceAll("");

		m = ENTITY_REFS.matcher(contents);
		contents = m.replaceAll("");

		m = WHITESPACE.matcher(contents);
        contents = m.replaceAll(" ").replaceAll("'", "");
		if(contents.length() > 200){
			contents = contents.substring(0,200);
		}
		this.DESC = contents;
	}
	
	
}
