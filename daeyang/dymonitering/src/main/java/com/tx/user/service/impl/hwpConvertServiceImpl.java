package com.tx.user.service.impl;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.file.Files;
import java.nio.file.Paths;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import com.tx.common.config.tld.SiteProperties;
import com.tx.common.file.dto.FileSub;
import com.tx.common.service.component.CommonService;
import com.tx.common.service.component.ComponentService;
import com.tx.user.service.hwpConvertService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;



@Service("ConvertThread")
public class hwpConvertServiceImpl extends EgovAbstractServiceImpl implements hwpConvertService  {
	
	@Autowired ComponentService Component;
	@Autowired CommonService CommonService;

	/**
	 * hwp -> xhtml 변환
	 * @param outputPath
	 * @param path
	 * @param runCommand
	 * @param fileKey
	 * @param domain
	 * @throws Exception
	 */	
	@Async
	@Override
	public void conventHwp(String outputPath, String path, StringBuilder runCommand, String fileKey, String domain)
			throws Exception {
		
		String error = "N";
		
		System.out.println("==============>>>>>>>>>>>> THREAD START");
		
		try {
			runCommand.append("hwp5html --output=" + outputPath + " " + path);
			Files.createDirectories(Paths.get(outputPath)); // Output 경로를 생성해 준다.

			// 명령어를 수행
			Process process = Runtime.getRuntime().exec(runCommand.toString());
			int exitStatus = process.waitFor();
			BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(process.getInputStream()));
			StringBuilder stringBuilder = new StringBuilder(exitStatus == 0 ? "SUCCESS:" : "ERROR:");
			String currentLine = bufferedReader.readLine();

			while (currentLine != null) {
				stringBuilder.append(currentLine);
				currentLine = bufferedReader.readLine();
			}
			// 변환에 실패한 경우 예외 처리
			if (stringBuilder.toString().equals("ERROR:")) {
				System.out.println("python hwp to xthml 파일 변환 에러");
				error = "Y";
			}
			System.out.println("outputPath::" + outputPath + "// path::" + path);
		} catch (Exception e) {
			error = "Y";
			System.out.println("hwp to xthml 변환 로직에 오류가 발생하였습니다.");
		}
		
		System.out.println("hwp to xthml 변환 과정이 종료되었습니다.");
		
		StringBuilder outPath = new StringBuilder()
				.append(outputPath.replace(SiteProperties.getString("RESOURCE_PATH"), domain + "/resources/"))
				.append("/index.xhtml");

		if("N".equals(error)){
		FileSub sub = FileSub.builder().FS_KEYNO(fileKey)
				.FS_CONVERT_PATH(outPath.toString())
				.FS_CONVERT_CHK("Y")
				.build();
		
			Component.updateData("File.updateConvChk", sub);
		}
		
		System.out.println("==============>>>>>>>>>>>> THREAD END");
	}

}