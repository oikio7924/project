package com.tx.common.config.logger;


import java.io.File;
import java.io.FileWriter;
import java.util.Date;

import org.apache.commons.lang3.StringUtils;

import com.ibm.icu.text.SimpleDateFormat;

import lombok.Data;
import lombok.EqualsAndHashCode;
import net.sf.log4jdbc.ResultSetCollector;
import net.sf.log4jdbc.Slf4jSpyLogDelegator;
import net.sf.log4jdbc.Spy;
import net.sf.log4jdbc.tools.LoggingType;

/**
 * logOff : false -> 모든 로그 출력
 * logOff : true - > sql 쿼리가  -- LOG OFF 로 시작하면 로그 출력 X
 * @author admin
 *
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class Log4JdbcCustomFormatter extends Slf4jSpyLogDelegator {

    private LoggingType loggingType = LoggingType.DISABLED;

    private String margin = "";
    
    private String sqlPrefix = "SQL : ";
    
    private boolean logOff = false;
    
    private String logOffMsg = "-- LOG OFF";
    
    private double slowQueryLogTime = 0.1;
    
    private String slowQueryLogPath;
    
    public enum CurrentLogStatus {
        DISABLED, VIEW
    }
    
    private CurrentLogStatus currentLogStatus = CurrentLogStatus.VIEW;
    
    
    public int getMargin() {
        return margin.length();
    }

    public void setMargin(int n) {
        margin = String.format("%1$#" + n + "s", "");
    }


    public Log4JdbcCustomFormatter() {
    }
    
    
    public void setDelayLogTime(double _slowQueryLogTime){
    	slowQueryLogTime = _slowQueryLogTime;
    }
    
    public void setDelayLogPath(String _slowQueryLogPath){
    	slowQueryLogPath = _slowQueryLogPath;
    }


    
    @Override
    public String sqlOccured(Spy spy, String methodCall, String rawSql) {
    	
        if (loggingType == LoggingType.DISABLED) {
            return "";
        }
        
        if( rawSql == null){
        	return "";
        }
        
        StringBuffer sql = new StringBuffer();
        sql.append(sqlPrefix).append(QueryName.query).append("\n\n");
        QueryName.query = "";
        String lines[] = rawSql.split("\n");
        
        if(logOff && lines[0].trim().equals(logOffMsg)){
        	currentLogStatus = CurrentLogStatus.DISABLED;
        	return "";
        }else{
        	getSqlOnlyLogger().info("\n\n");
        	currentLogStatus = CurrentLogStatus.VIEW;
        }
        
        for(String line : lines){
        	if(StringUtils.isNotBlank(line)){
        		sql.append(line).append("\n");
        	}
        }
        getSqlOnlyLogger().info(sql.toString());
        return rawSql;
    }
    
   

	public void sqlTimingOccured(Spy spy, long execTime, String methodCall, String rawSql)
    {
		
		if (loggingType == LoggingType.DISABLED) {
            return;
        }
		
		if(currentLogStatus == CurrentLogStatus.VIEW){
			StringBuffer sql = new StringBuffer();
			sql.append(" {실행시간 :: ");
			double time = execTime/1000.0;
			sql.append(time);
			sql.append("초}");
			if(time > slowQueryLogTime){
				printDelayLog(sql.toString(),rawSql);
			}
			getSqlOnlyLogger().info(sql.toString());
		}
    }

	/**
	 * delayTime 보다 늦은 쿼리를 파일로 저장
	 * @param log
	 * @param rawSql 
	 */
	private void printDelayLog(String excuteTime, String rawSql) {
		// TODO Auto-generated method stub
		
		if(checkDelayLogPath()){
			
			SimpleDateFormat sdf = new SimpleDateFormat("YYYY-MM-dd");
			
			String fileName = "slowQueryLog."+sdf.format(new Date())+".log";
			
			File file = new File(slowQueryLogPath + fileName);
			
			try(FileWriter fw = new FileWriter(file, true)){
				fw.write(excuteTime+"\r\n");
				fw.write(rawSql+"\r\n");
				fw.write("******************************************************************\r\n");
				fw.flush();
				
			}catch (Exception e) {
				System.out.println("로그 에러 : " + e.getMessage());
			}
		}
	}

	private boolean checkDelayLogPath() {
		// TODO Auto-generated method stub
		
		if(StringUtils.isEmpty(slowQueryLogPath)) return false;
		
		File logPath = new File(slowQueryLogPath);
		if(logPath.exists() && logPath.isDirectory()){
			return true;
		}else{
			System.err.println("delayLogPath 경로 잘못됨 확인바람 :: "+ slowQueryLogPath);
			return false;
		}
		
		
	}

	@Override
    public void resultSetCollected(ResultSetCollector resultSetCollector) {
		
		if (loggingType == LoggingType.DISABLED) {
            return;
        }
		
		if(currentLogStatus == CurrentLogStatus.VIEW){
	        String resultTable = new ResultSetCollectorPrinter().printResultSet(resultSetCollector);
	        String sqls[] = resultTable.split("\n");
	        for (int i = 0; i < sqls.length; i++) {
	        	getSqlOnlyLogger().info(sqls[i]);
	        }
		}
    }
	
    @Override
    public String sqlOccured(Spy spy, String methodCall, String[] sqls) {
        String s = "";
        for (int i = 0; i < sqls.length; i++) {
            s += sqlOccured(spy, methodCall, sqls[i]) + String.format("%n");
        }
        return s;
    }

}
