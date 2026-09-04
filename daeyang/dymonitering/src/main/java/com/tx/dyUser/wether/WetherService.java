package com.tx.dyUser.wether;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.Charset;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;



public class WetherService {

	Date date = new Date();
	DateFormat format = new SimpleDateFormat("yyyyMMdd");
	DateFormat format2 = new SimpleDateFormat("HHmm");
	String dates = format.format(date);
	
	//동네 예보
	public  ArrayList< HashMap<String, Object>> wetherService() throws Exception{
		
		String url = "http://apis.data.go.kr/1360000/VilageFcstInfoService/getVilageFcst?serviceKey="
		   		+ "dQsCZl8ZlcJHAjjmit2miCTpY042aQYG2P%2Bbnq%2BuVToDqFAVoVv%2Bdx%2FUbDLF6RvjVqVdYHAw%2FGrlbMyCSbdbHA%3D%3D"
		   		+ "&pageNo=1"
		   		+ "&numOfRows=307"
		   		+ "&dataType=JSON"
		   		+ "&base_date="+dates
		   		+ "&base_time=0500"
		   		+ "&nx=59&ny=79&";
		   
		   JSONObject json = readJsonFromUrl(url);
		   
		   JSONArray jsonList = (((json.getJSONObject("response")).getJSONObject("body")).getJSONObject("items")).getJSONArray("item");
		   
		   ArrayList<HashMap<String, Object>> list = new ArrayList<>();
		   /***
		    * POP	강수확률
		    * PTY	강수형태
		    * T3H	3시간 기온
		    * SKY	하늘상태
		    * - 하늘상태(SKY) 코드 : 맑음(1), 구름많음(3), 흐림(4) 
			- 강수형태(PTY) 코드 : 없음(0), 비(1), 비/눈(2), 눈(3), 소나기(4), 빗방울(5), 빗방울/눈날림(6), 눈날림(7)
			여기서 비/눈은 비와 눈이 섞여 오는 것을 의미 (진눈개비)
		    * 
		    * 
		    */
		   HashMap<String, Object> map = new HashMap<>();
		   for(int i=0; i<jsonList.length();i++) {
			   JSONObject j = jsonList.getJSONObject(i);
			  
			   
			   if(j.getString("fcstTime").equals("0900")) {
				   if(j.getString("category").equals("POP")) {map.put("rainRateAm", j.getString("fcstValue"));}
				   if(j.getString("category").equals("PTY")) {
					   if(j.getString("fcstValue").equals("1")) {
						   map.put("skyAm","비");
					   }else if(j.getString("fcstValue").equals("2")) {
						   map.put("skyAm","비/눈");
					   }else if(j.getString("fcstValue").equals("3")) {
						   map.put("skyAm","눈");
					   }else if(j.getString("fcstValue").equals("4")) {
						   map.put("skyAm","소나기");
					   }else if(j.getString("fcstValue").equals("5")) {
						   map.put("skyAm","빗방울");
					   }else if(j.getString("fcstValue").equals("6")) {
						   map.put("skyAm","빗방울/눈날림");
					   }else if(j.getString("fcstValue").equals("7")) {
						   map.put("skyAm","눈날림");
					   }
					   map.put("raintypeAm", j.getString("fcstValue"));
				   }
				   if(j.getString("category").equals("SKY")) {
					   if(map.get("raintypeAm").equals("0")) {
						   if(j.getString("fcstValue").equals("3")){
							   map.put("skyAm","구름많음");
						   }else if(j.getString("fcstValue").equals("4")) {
							   map.put("skyAm","흐림");
						   }else {
							   map.put("skyAm","맑음");
						   }
					   }
				   }
				   if(j.getString("category").equals("T3H")) {
					   map.put("temperatureAm", j.getString("fcstValue"));
					   map.put("NowDate", j.getString("fcstDate"));
					   map.put("temperatureMin", j.getString("fcstValue"));
				   }
			   }else if(j.getString("fcstTime").equals("1800")) {
				   if(j.getString("category").equals("POP")) {map.put("rainRatePm", j.getString("fcstValue"));}
				   if(j.getString("category").equals("PTY")) {
					   if(j.getString("fcstValue").equals("1")) {
						   map.put("skyPm","비");
					   }else if(j.getString("fcstValue").equals("2")) {
						   map.put("skyPm","비/눈");
					   }else if(j.getString("fcstValue").equals("3")) {
						   map.put("skyPm","눈");
					   }else if(j.getString("fcstValue").equals("4")) {
						   map.put("skyPm","소나기");
					   }else if(j.getString("fcstValue").equals("5")) {
						   map.put("skyPm","빗방울");
					   }else if(j.getString("fcstValue").equals("6")) {
						   map.put("skyPm","빗방울/눈날림");
					   }else if(j.getString("fcstValue").equals("7")) {
						   map.put("skyPm","눈날림");
					   }
					   map.put("raintypePm", j.getString("fcstValue"));
				   }
				   if(j.getString("category").equals("SKY")) {
					   if(map.get("raintypePm").equals("0")) {
						   if(j.getString("fcstValue").equals("3")){
							   map.put("skyPm","구름많음");
						   }else if(j.getString("fcstValue").equals("4")) {
							   map.put("skyPm","흐림");
						   }else {
							   map.put("skyPm","맑음");
						   }
					   }
				   }
				   if(j.getString("category").equals("T3H")) {
					   map.put("temperaturePm", j.getString("fcstValue"));
					   list.add(map);
					   map = new HashMap<>();
				   }
			   }else if(j.getString("fcstTime").equals("1500")) {
				   if(j.getString("category").equals("TMX")) {
					   String temp = j.getString("fcstValue").substring(0,(j.getString("fcstValue").indexOf(".")));
					   System.out.println(temp); 
					   map.put("temperatureMax", temp);
				   }
			   }
		   }
		   return list;
	}

	public  HashMap<String,Object> All_Date(String region) throws Exception{
		String regId = "";
		
		if(region.equals("나주")) regId = "11F20503";
		
		//강수량 + 날씨상태
		String url = "http://apis.data.go.kr/1360000/MidFcstInfoService/getMidLandFcst?"
				+ "serviceKey=dQsCZl8ZlcJHAjjmit2miCTpY042aQYG2P%2Bbnq%2BuVToDqFAVoVv%2Bdx%2FUbDLF6RvjVqVdYHAw%2FGrlbMyCSbdbHA%3D%3D"
				+ "&pageNo=1"
				+ "&numOfRows=10"
				+ "&dataType=JSON"
				+ "&regId="+ regId
				+ "&tmFc="+dates+"0600&";
		 
		String url2 = "http://apis.data.go.kr/1360000/MidFcstInfoService/getMidTa?"
				+ "serviceKey=dQsCZl8ZlcJHAjjmit2miCTpY042aQYG2P%2Bbnq%2BuVToDqFAVoVv%2Bdx%2FUbDLF6RvjVqVdYHAw%2FGrlbMyCSbdbHA%3D%3D"
				+ "&pageNo=1"
				+ "&numOfRows=10"
				+ "&dataType=JSON"
				+ "&regId=" + regId
				+ "&tmFc="+dates+"0600&";
		
		
		 JSONObject json = readJsonFromUrl(url);
		 JSONObject json2 = readJsonFromUrl(url2);
		 JSONArray jsonList = (((json.getJSONObject("response")).getJSONObject("body")).getJSONObject("items")).getJSONArray("item");
		 JSONArray jsonList2 = (((json2.getJSONObject("response")).getJSONObject("body")).getJSONObject("items")).getJSONArray("item");
		 
		 //강수량 sky
		 ArrayList<HashMap<String,Object>> futureList = wetherService();

		 JSONObject j = jsonList.getJSONObject(0);
		 JSONObject j2 = jsonList2.getJSONObject(0);
		 
		 
		 //한번에 정리!
		 for(int i=5;i<8;i++) {
			 HashMap<String, Object> map = new HashMap<>();
			 //날씨 설정 +1
			 Calendar cal = Calendar.getInstance();
			 cal.setTime(date);
			 cal.add(Calendar.DATE, i-2);
			 String futureDate = format.format(cal.getTime());	
			 //am 부터 
		 	 map.put("NowDate", futureDate);
			 map.put("rainRateAm", j.getInt("rnSt"+i+"Am"));
			 map.put("skyAm", j.getString("wf"+i+"Am"));
			 map.put("temperatureAm", j2.getInt("taMin"+i));
			 //pm설정
			 map.put("rainRatePm", j.getInt("rnSt"+i+"Pm"));
			 map.put("skyPm", j.getString("wf"+i+"Pm"));
			 map.put("temperaturePm", j2.getInt("taMax"+i));
			 //최대값 최소값
			 map.put("temperatureMin",j2.getInt("taMin"+i));
			 map.put("temperatureMax",j2.getInt("taMax"+i));
			 
			 futureList.add(map);
		 }
		 futureList = Make_CloudData(futureList);
		 HashMap<String, Object> map = new HashMap<>();
		 map = futureList.get(0);
		 map.put("region", region);
		 return map;
	}
	
	
	//일일 데이터 가져오기 (저장하지않고 바로 등록)
	public ArrayList<String> AjaxDate(String region) throws Exception{
		ArrayList<String> list = new ArrayList<>();
		ArrayList<String> list_temp = new ArrayList<>();
		
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		cal.add(Calendar.HOUR, -1);
		String futureDate = format2.format(cal.getTime());
		
		String nx = "" , ny ="";
		if(region.equals("나주")) {nx="59"; ny="69";}
		else if(region.equals("광주")) {nx="57"; ny="73";}
		
		String url = "http://apis.data.go.kr/1360000/VilageFcstInfoService/getUltraSrtFcst?"
				+ "serviceKey=dQsCZl8ZlcJHAjjmit2miCTpY042aQYG2P%2Bbnq%2BuVToDqFAVoVv%2Bdx%2FUbDLF6RvjVqVdYHAw%2FGrlbMyCSbdbHA%3D%3D"
				+ "&pageNo=1&numOfRows=25"
				+ "&dataType=JSON"
				+ "&base_date=" + dates
				+ "&base_time="+futureDate
				+ "&nx="+nx+"&ny="+ny;
		System.out.println(url);
		
		try {
			JSONObject json = readJsonFromUrl(url);
			JSONArray jsonList = (((json.getJSONObject("response")).getJSONObject("body")).getJSONObject("items")).getJSONArray("item");
			
			for(int i=0; i<jsonList.length();i++) {
				JSONObject j = jsonList.getJSONObject(i);
				
				if(j.getString("category").equals("PTY")) {
					list.add(j.getString("fcstTime"));
					list_temp.add(j.getString("fcstValue"));
				}
				if(j.getString("category").equals("T1H")) {
					list.add(j.getString("fcstValue"));
				}
				if(j.getString("category").equals("SKY")) {
					list.add(j.getString("fcstValue"));
				}
			}
			list.addAll(list_temp);
		}catch (Exception e) {
			System.out.println("날씨데이터 API 에러");
		}
		
		return list;
	}
	
	
	//url 파싱하는거 
	private String jsonReadAll(Reader reader) throws IOException {
			StringBuilder sb = new StringBuilder();
			int cp;
			while ((cp = reader.read()) != -1) {
				sb.append((char) cp);
			}
			return sb.toString();
		}
	   
	   public JSONObject readJsonFromUrl(String url) throws IOException, JSONException {
			InputStream is = new URL(url).openStream();
			try {
				BufferedReader rd = new BufferedReader(new InputStreamReader(is, Charset.forName("UTF-8")));
				String jsonText = jsonReadAll(rd);
				JSONObject json = new JSONObject(jsonText);
				return json;
			} finally {
				is.close();
			}

		}
	
	   public ArrayList<HashMap<String,Object>> Make_CloudData(ArrayList<HashMap<String,Object>> list) throws Exception {
		   
		   for(HashMap<String,Object> m : list) {
			   double cloud_a = 0.0;
			   String a = m.get("skyAm").toString();
			   String p = m.get("skyPm").toString();
			   
			   if(a.equals("맑음")) {
				   cloud_a += 2;
			   }else if(a.equals("구름많음")) {cloud_a += 5;
			   }else if(a.equals("흐림")) {cloud_a += 7;
				   }else {cloud_a += 9;}
			   if(p.equals("맑음")) {
				   cloud_a += 2;
			   }else if(p.equals("구름많음")) {cloud_a += 5;
			   }else if(p.equals("흐림")) {cloud_a += 7;
			   }else {cloud_a += 9;}
			   m.put("CLOUDRATE", cloud_a/2);
		   }
		   
		   return list;
	   }
	   
	   
	   
	   /**
	    * 
	    * @return
	    * @throws 일일 지역별 날씨 데이터 출력 ex) 0900 -> 30분 단위 (초단기 실황 날씨), 일출 일몰 관련 처리는 문서 참조하여 지역 잘 확인 하기
	    */
	   public  ArrayList<String> Daily_Wether(String region ) throws Exception{
		   
		   ArrayList<String> list = new ArrayList<String>();
		   
		   Calendar cal = Calendar.getInstance();
		   cal.setTime(date);
		   cal.add(Calendar.HOUR, -1);
		   String time = format2.format(cal.getTime());
		   
		   String nx = "" , ny ="";
		   if(region.equals("나주")) {nx="59"; ny="69";}
		   else if(region.equals("광주")) {nx="59"; ny="69";}
		   else if(region.equals("해남")) {nx="54"; ny="61";}
		   else if(region.equals("화성")) {nx="59"; ny="120";}
		   else if(region.equals("세종")) {nx="67"; ny="104";}
		   else if(region.equals("영암")) {nx="55"; ny="68";}
		   else if(region.equals("김제")) {nx="59"; ny="88";}
		   else if(region.equals("곡성")) {nx="66"; ny="77";}
		   else if(region.equals("남원")) {nx="68"; ny="80";}
		   else if(region.equals("음성")) {nx="74"; ny="113";}
		   else if(region.equals("진천")) {nx="68"; ny="111";}
		   else if(region.equals("부산")) {nx="98"; ny="76";}
		   else if(region.equals("부안")) {nx="56"; ny="87";}
		   else if(region.equals("안성")) {nx="65"; ny="113";}
		   else if(region.equals("포천")) {nx="63"; ny="132";}
		   
		 

		   
			String url = "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtFcst?"
					+ "serviceKey=dQsCZl8ZlcJHAjjmit2miCTpY042aQYG2P%2Bbnq%2BuVToDqFAVoVv%2Bdx%2FUbDLF6RvjVqVdYHAw%2FGrlbMyCSbdbHA%3D%3D"
					+ "&pageNo=1"
					+ "&numOfRows=60"
					+ "&dataType=JSON"
					+ "&base_date="+dates+"&base_time="+time
					+ "&nx="+nx+"&ny="+ny;
			 
			 JSONObject json = readJsonFromUrl(url);
			 JSONArray jsonList = null;
			 
			 System.out.println(url);
			 
			 try {
				 jsonList = (((json.getJSONObject("response")).getJSONObject("body")).getJSONObject("items")).getJSONArray("item");
			} catch (Exception e) {
				System.out.println("json데이터 에러");
				jsonList = null;
			}
			 int count = 0;
			 
			 if(jsonList != null) {
				 for(int i=0; i<jsonList.length();i++) {
					   JSONObject j = jsonList.getJSONObject(i);
					   String value = j.getString("fcstValue");
					   
					   //날짜 등록
					   if(j.getString("category").equals("LGT")) {
						   value = j.getString("fcstTime");
						   list.add(value);
					   }
					   //날씨
					   if(j.getString("category").equals("PTY")) {
						   if(j.getString("fcstValue").equals("1"))  		value = "비"; 
						   else if(j.getString("fcstValue").equals("2"))  	value = "비/눈";
						   else if(j.getString("fcstValue").equals("3"))  	value = "눈";
						   else if(j.getString("fcstValue").equals("4")) 	value = "소나기";
						   else if(j.getString("fcstValue").equals("5")) 	value = "빗방울";
						   else if(j.getString("fcstValue").equals("6")) 	value = "빗방울/눈날림";
						   else if(j.getString("fcstValue").equals("7")) 	value = "눈날림";
						   else value = "맑음";
						   count += 1;
						   list.add(value);
					   }
					   //시간당 강수량
					   if(j.getString("category").equals("RN1")) {
						   list.add(value);
					   }
					   //하늘 상태
					   if(j.getString("category").equals("SKY")) {
						   if(j.getString("fcstValue").equals("3")){
							   value = "구름많음";
						   }else if(j.getString("fcstValue").equals("4")) {
							   value = "흐림";
						   }else {
							   value = "맑음";
						   }
						   list.add(value);
					   }
					   //온도
					   if(j.getString("category").equals("T1H")) {
						   list.add(value);
					   }
					   //습도
					   if(j.getString("category").equals("REH")) {
						   list.add(value);
					   }
					   //풍향
					   if(j.getString("category").equals("WSD")) {
						   list.add(value);
					   }
				 }
				 
				 list.add(Integer.toString(count)); //갯수 혹시모르니깐..
				 list.add(region);
				 
			 }
			 
			 return list;
		}
	   
	   /**
	    * 선셋, 선라이즈 데이터 가져오기 (해당 지역별 많이 없기때문에 엑셀에서 확인후 등록 처리) 
	    */
	   public ArrayList<String> Sunrise_setData(String region)throws Exception{
		   ArrayList<String> list = new ArrayList<String>();
		   
		   String area = "";
		   if(region.equals("나주")) area = URLEncoder.encode("광주", "utf-8");
		   if(region.equals("광주")) area = URLEncoder.encode("광주", "utf-8");
		   if(region.equals("해남")) area = URLEncoder.encode("해남", "utf-8");
		   if(region.equals("화성")) area = URLEncoder.encode("화성", "utf-8");
		   if(region.equals("세종")) area = URLEncoder.encode("세종", "utf-8");
		   if(region.equals("영암")) area = URLEncoder.encode("목포", "utf-8");
		   if(region.equals("김제")) area = URLEncoder.encode("부안", "utf-8");
		   if(region.equals("남원")) area = URLEncoder.encode("남원", "utf-8");
		   if(region.equals("곡성")) area = URLEncoder.encode("남원", "utf-8");
		   if(region.equals("음성")) area = URLEncoder.encode("충주", "utf-8");
		   if(region.equals("진천")) area = URLEncoder.encode("충주", "utf-8");
		   if(region.equals("부산")) area = URLEncoder.encode("부산", "utf-8");
		   if(region.equals("부안")) area = URLEncoder.encode("부안", "utf-8");
		   if(region.equals("안성")) area = URLEncoder.encode("천안", "utf-8");
		   if(region.equals("포천")) area = URLEncoder.encode("천안", "utf-8");

		   String urlstr = "http://apis.data.go.kr/B090041/openapi/service/RiseSetInfoService/getAreaRiseSetInfo?serviceKey=dQsCZl8ZlcJHAjjmit2miCTpY042aQYG2P%2Bbnq%2BuVToDqFAVoVv%2Bdx%2FUbDLF6RvjVqVdYHAw%2FGrlbMyCSbdbHA%3D%3D&locdate="+dates+"&location="+area;
		   
		   DocumentBuilderFactory dbFactoty = DocumentBuilderFactory.newInstance();
		   DocumentBuilder dBuilder = dbFactoty.newDocumentBuilder();
		   Document doc = dBuilder.parse(urlstr);
			
			// root tag 
			doc.getDocumentElement().normalize();
			System.out.println("Root element :" + doc.getDocumentElement().getNodeName());
			
			// 파싱할 tag
			NodeList nList = doc.getElementsByTagName("item");
			//System.out.println("파싱할 리스트 수 : "+ nList.getLength());
			
			for(int temp = 0; temp < nList.getLength(); temp++){
				Node nNode = nList.item(temp);
				if(nNode.getNodeType() == Node.ELEMENT_NODE){
					Element eElement = (Element) nNode;
					list.add(getTagValue("sunrise", eElement));
					list.add(getTagValue("sunset", eElement));
				}	
			}
			return list;
		   }
		   
		   // tag값의 정보를 가져오는 메소드
		   public String getTagValue(String tag, Element eElement) {
			    NodeList nlList = eElement.getElementsByTagName(tag).item(0).getChildNodes();
			    Node nValue = (Node) nlList.item(0);
			    if(nValue == null) 
			        return null;
			    return nValue.getNodeValue();
			}
}
