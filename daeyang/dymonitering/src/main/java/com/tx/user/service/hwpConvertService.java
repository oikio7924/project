package com.tx.user.service;

public interface hwpConvertService {
	
	/**
	 * hwp -> xhtml 변환
	 * @param outputPath
	 * @param path
	 * @param runCommand
	 * @param fileKey
	 * @param domain
	 * @throws Exception
	 */	
	public void conventHwp(String outputPath, String path, StringBuilder runCommand, String fileKey, String domain)
			throws Exception;

}