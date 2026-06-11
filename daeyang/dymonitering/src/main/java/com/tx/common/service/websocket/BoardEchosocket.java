package com.tx.common.service.websocket;

import java.io.IOException;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.json.Json;
import javax.json.JsonObject;
import javax.json.JsonWriter;
import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;


@ServerEndpoint("/boardEcho")
@Controller
public class BoardEchosocket {
	static List<HashMap<String, Object>> sessionUsers = new ArrayList<>(); 
	static List<Session> sessionList = new ArrayList<>(); 
	
	@OnMessage
	public void onMessage(String message, Session userSession) throws IOException {
		if(StringUtils.isNotBlank(message)){
			String strs[] = message.split(",");
			
			if(strs.length > 1){
				String type = strs[0];
				String num = strs[1];
				if("view".equals(type)){
					for (HashMap<String, Object> user : sessionUsers) {
						if(((Session)user.get("session")).getId().equals(userSession.getId())){
							user.put("boardID", num);
						}
					}
				}else if("new".equals(type)){
					if(StringUtils.isNoneBlank(num)){
						for (HashMap<String, Object> user : sessionUsers) {
							String boardNum = user.get("boardID").toString();
							if(num.equals(boardNum)){
								if(!((Session)user.get("session")).getId().equals(userSession.getId())){
									((Session)user.get("session")).getBasicRemote().sendText("success,"+strs[2]);
								}
							}
						}
					}
				}
			}
		}
	}

	@OnOpen
	public void onOpen(Session userSession) {
		HashMap<String, Object> userMap = new HashMap<>();
		userMap.put("session", userSession);
		userMap.put("boardID", "");
		sessionUsers.add(userMap);
	}

	@OnClose
    public void onClose(Session userSession){	    
        try {
            for (HashMap<String, Object> user : sessionUsers) {
                String id = ((Session)user.get("session")).getId();
                if(id.equals(userSession.getId())){
                    sessionUsers.remove(user);
                }
            }
        } catch (Exception e) {
            System.out.println("client socket is now force disconnected...");
        }        
    }
	
	@OnError
	public void onError (Session session, Throwable e) {
		System.out.println("에러 onError :: " + e.getMessage());
	}
	
	/**
	* json타입의 메시지 만들기
	* @param username
	* @param message
	* @return
	*/
	public String buildJsonData(String username,String message){
		JsonObject jsonObject = Json.createObjectBuilder().add("message", username+" : "+message).build();
		StringWriter stringwriter = new StringWriter();
		try(JsonWriter jsonWriter = Json.createWriter(stringwriter)){
			jsonWriter.write(jsonObject);
		};
		return stringwriter.toString();
	}


}
