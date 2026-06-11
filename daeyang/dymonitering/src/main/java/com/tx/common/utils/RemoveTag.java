package com.tx.common.utils;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class RemoveTag {
	
	
	public static String remove(String contents) {
		
		
		Pattern SCRIPTS = Pattern.compile("<script([^'\"]|\"[^\"]*\"|'[^']*')*?</script>",Pattern.DOTALL);
		Pattern STYLE = Pattern.compile("<style[^>]*>.*</style>",Pattern.DOTALL);
//		Pattern TAGS = Pattern.compile("<(/)?([a-zA-Z0-9:]*)(\\s[a-zA-Z0-9]*=[^>]*)?(\\s)*(/)?>");
		Pattern TAGS = Pattern.compile("<[^>]*>");	//주석이 안지워져서 이걸로
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
		
		return contents;
		
        
	}
	
}
