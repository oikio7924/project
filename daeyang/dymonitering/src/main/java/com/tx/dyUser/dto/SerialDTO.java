package com.tx.dyUser.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SerialDTO {
	public String method; 
	public String types;
	
	public String time;          
    
	public String DP_KEYNO = "";
	public String DI_NAME = "";
	
	public String Vpv1 = "";
	public String Ipv1 = "";
	public String Vpv2 = "";
	public String Ipv2 = "";
	public String Vpv3 = "";
	public String Ipv3 = "";
	public String Vpv4 = "";
	public String Ipv4 = "";
	public String Vpv5 = "";
	public String Ipv5 = "";
	public String Vpv6 = "";
	public String Ipv6 = "";
	public String Vpv7 = "";
	public String Ipv7 = "";
	public String Vpv8 = "";
	public String Ipv8 = "";
	public String Vpv9 = "";
	public String Ipv9 = "";
	public String Vpv10 = "";
	public String Ipv10 = "";
	public String Vpv11 = "";
	public String Ipv11 = "";
	public String Vpv12 = "";
	public String Ipv12 = "";
	public String Vpv13 = "";
	public String Ipv13 = "";
	public String Vpv14 = "";
	public String Ipv14 = "";
	public String Vpv15 = "";
	public String Ipv15 = "";
	public String Vpv16 = "";
	public String Ipv16 = "";
	public String Vpv17 = "";
	public String Ipv17 = "";
	public String Vpv18 = "";
	public String Ipv18 = "";
	public String Vpv19 = "";
	public String Ipv19 = "";
	public String Vpv20 = "";
	public String Ipv20 = "";
	public String Vpv21 = "";
	public String Ipv21 = "";
	public String Vpv22 = "";
	public String Ipv22 = "";
	public String Vpv23 = "";
	public String Ipv23 = "";
	public String Vpv24 = "";
	public String Ipv24 = "";

	public String voltage_of_phase_A_to_B = "";
	public String voltage_of_phase_B_to_C = "";
	public String voltage_of_phase_C_to_A = "";
	public String Phase_voltage_of_phase_A = "";
	public String Phase_voltage_of_phase_B = "";
	public String Phase_voltage_of_phase_C = "";
	public String Current_of_phase_A = "";
	public String Current_of_phase_B = "";
	public String Current_of_phase_C = "";
	public String Active_Power = "";
	public String Grid_Frequency = "";
	public String Internal_temperature = "";
	public String Cumulative_Generation = "";
	public String Daily_Generation = "";
	public String Cabinet_Temperature_2 = "";
	public String DSP_Error_Code = "";
	public String DSP_Alarm_Code = "";
	public String PV_String_Fault_Bit = "";
	public String Temperature_Fault_Bit = "";
	public String Slave_DSP_ErrorCode = "";
	public String Slave_DSP_AlarmCode = "";
	
	// Lombok이 underscore 포함 필드의 getter를 제대로 생성하지 못할 수 있어 명시적 추가
	public String getSlave_DSP_AlarmCode() {
		return Slave_DSP_AlarmCode;
	}
	
	public void setSlave_DSP_AlarmCode(String slave_DSP_AlarmCode) {
		Slave_DSP_AlarmCode = slave_DSP_AlarmCode;
	}
	
	public String Total_Generation_Hour = "";
	public String Safety_Code = "";
	public String Work_Mode = "" ;
	
	// 케이스타 추가 필드
	public String Frequency_of_phase_A = "";
	public String Frequency_of_phase_B = "";
	public String Frequency_of_phase_C = "";
	public String Ppv1 = "";
	public String Ppv2 = "";
	public String Ppv3 = "";
	public String Ppv4 = "";
	public String Ppv5 = "";
	public String Ppv6 = "";
	public String Ppv7 = "";
	public String Ppv8 = "";
	public String Ppv9 = "";
	public String Ppv10 = "";
	public String Ppv11 = "";
	public String Ppv12 = "";
	public String Istr1 = "";
	public String Istr2 = "";
	public String Istr3 = "";
	public String Istr4 = "";
	public String Istr5 = "";
	public String Istr6 = "";
	public String Istr7 = "";
	public String Istr8 = "";
	public String Istr9 = "";
	public String Istr10 = "";
	public String Istr11 = "";
	public String Istr12 = "";
	public String Istr13 = "";
	public String Istr14 = "";
	public String Istr15 = "";
	public String Istr16 = "";
	public String Istr17 = "";
	public String Istr18 = "";
	public String Istr19 = "";
	public String Istr20 = "";
	public String Istr21 = "";
	public String Istr22 = "";
	public String Istr23 = "";
	public String Istr24 = "";
	
	// 다쓰테크 추가 필드
	public String Phase = "";
	public String PowerCapacity = "";
	public String RatedLineVoltage = "";
	
	// dy_inverter_data_main 저장용 필드
	public String DDM_DPP_KEYNO = "";
	public String DDM_P_DATA = "";
	public String DDM_D_DATA = "";
	public String DDM_T_HOUR = "";
	public String DDM_STATUS = "";
	public String DDM_ACTIVE_P = "";
	public String DDM_CUL_DATA = "";
	
	// Lombok이 underscore 포함 필드의 getter/setter를 제대로 생성하지 못할 수 있어 명시적 추가
	public String getDDM_DPP_KEYNO() {
		return DDM_DPP_KEYNO;
	}
	
	public void setDDM_DPP_KEYNO(String DDM_DPP_KEYNO) {
		this.DDM_DPP_KEYNO = DDM_DPP_KEYNO;
	}
	
	public String getDDM_P_DATA() {
		return DDM_P_DATA;
	}
	
	public void setDDM_P_DATA(String DDM_P_DATA) {
		this.DDM_P_DATA = DDM_P_DATA;
	}
	
	public String getDDM_D_DATA() {
		return DDM_D_DATA;
	}
	
	public void setDDM_D_DATA(String DDM_D_DATA) {
		this.DDM_D_DATA = DDM_D_DATA;
	}
	
	public String getDDM_T_HOUR() {
		return DDM_T_HOUR;
	}
	
	public void setDDM_T_HOUR(String DDM_T_HOUR) {
		this.DDM_T_HOUR = DDM_T_HOUR;
	}
	
	public String getDDM_STATUS() {
		return DDM_STATUS;
	}
	
	public void setDDM_STATUS(String DDM_STATUS) {
		this.DDM_STATUS = DDM_STATUS;
	}
	
	public String getDDM_ACTIVE_P() {
		return DDM_ACTIVE_P;
	}
	
	public void setDDM_ACTIVE_P(String DDM_ACTIVE_P) {
		this.DDM_ACTIVE_P = DDM_ACTIVE_P;
	}
	
	public String getDDM_CUL_DATA() {
		return DDM_CUL_DATA;
	}
	
	public void setDDM_CUL_DATA(String DDM_CUL_DATA) {
		this.DDM_CUL_DATA = DDM_CUL_DATA;
	}

}
