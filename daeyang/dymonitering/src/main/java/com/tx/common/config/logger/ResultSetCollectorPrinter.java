package com.tx.common.config.logger;


import java.util.List;

import net.sf.log4jdbc.ResultSetCollector;

public class ResultSetCollectorPrinter {
	
	
	private int dataMaxLength = 60;
	
	public String printResultSet(ResultSetCollector resultSetCollector) {

		int columnCount = resultSetCollector.getColumnCount();
		int maxLength[] = new int[columnCount];

		for (int column = 1; column <= columnCount; column++) {
			maxLength[column - 1] = resultSetCollector.getColumnName(column)
					.length();
		}
		if (resultSetCollector.getRows() != null) {
			for (List<Object> printRow : resultSetCollector.getRows()) {
				int colIndex = 0;
				for (Object v : printRow) {
					if (v != null) {
						int length = v.toString().length();						
						if (length > maxLength[colIndex]) {
							maxLength[colIndex] = length > dataMaxLength ? dataMaxLength : length;
						}
					}
					colIndex++;
				}
			}
		}
		for (int column = 1; column <= columnCount; column++) {
			maxLength[column - 1] = maxLength[column - 1] + 1;
		}

		print("|");
		for (int column = 1; column <= columnCount; column++) {
			print(padRight("-", maxLength[column - 1]).replaceAll(" ", "-")
					+ "|");
		}
		println();
		print("|");
		for (int column = 1; column <= columnCount; column++) {
			print(padRight(resultSetCollector.getColumnName(column),
					maxLength[column - 1])
					+ "|");
		}
		println();
		print("|");
		for (int column = 1; column <= columnCount; column++) {
			print(padRight("-", maxLength[column - 1]).replaceAll(" ", "-")
					+ "|");
		}
		println();
		if (resultSetCollector.getRows() != null) {
			for (List<Object> printRow : resultSetCollector.getRows()) {
				int colIndex = 0;
				print("|");
				String data = null;
				for (Object v : printRow) {
					
					
					if(v == null){
						data = "null";
					}else{
						data = v.toString().replace(System.getProperty("line.separator"), ""); 
						if(data.length() > dataMaxLength){
							data = data.substring(0, dataMaxLength-3) + "...";
						}
					}
					
					print(padRight(data,maxLength[colIndex]) + "|");
					colIndex++;
				}
				println();
			}
		}
		print("|");
		for (int column = 1; column <= columnCount; column++) {
			print(padRight("-", maxLength[column - 1]).replaceAll(" ", "-")
					+ "|");
		}
		
		println();
		resultSetCollector.reset();
		return sb.toString();
	}

	public static String padRight(String s, int n) {
		
		return String.format("%1$-" + n + "s", s);
	}

	public static String padLeft(String s, int n) {
		return String.format("%1$#" + n + "s", s);
	}
	
	
	void println() {
		sb.append("\n");
	}

	private StringBuffer sb = new StringBuffer();

	void print(String s) {
		sb.append(s);
	}

}

