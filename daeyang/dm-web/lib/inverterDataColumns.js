/**
 * dm_inverter_data INSERT 컬럼 순서 (schema.sql 정의 순서와 동일)
 * dy_inverter_data 수집 코드와 맞출 때 이 배열을 사용하세요.
 */
const DM_INVERTER_DATA_COLUMNS = [
  "DP_KEYNO",
  "DI_NAME",
  "Conn_date",
  "Work_Mode",
  "Safety_Code",
  "Active_Power",
  "Daily_Generation",
  "Cumulative_Generation",
  "Total_Generation_Hour",
  "Grid_Frequency",
  "voltage_of_phase_A_to_B",
  "voltage_of_phase_B_to_C",
  "voltage_of_phase_C_to_A",
  "Phase_voltage_of_phase_A",
  "Phase_voltage_of_phase_B",
  "Phase_voltage_of_phase_C",
  "Current_of_phase_A",
  "Current_of_phase_B",
  "Current_of_phase_C",
  "Frequency_of_phase_A",
  "Frequency_of_phase_B",
  "Frequency_of_phase_C",
  "Vpv1", "Ipv1", "Vpv2", "Ipv2", "Vpv3", "Ipv3", "Vpv4", "Ipv4",
  "Vpv5", "Ipv5", "Vpv6", "Ipv6", "Vpv7", "Ipv7", "Vpv8", "Ipv8",
  "Vpv9", "Ipv9", "Vpv10", "Ipv10", "Vpv11", "Ipv11", "Vpv12", "Ipv12",
  "Vpv13", "Ipv13", "Vpv14", "Ipv14", "Vpv15", "Ipv15", "Vpv16", "Ipv16",
  "Vpv17", "Ipv17", "Vpv18", "Ipv18", "Vpv19", "Ipv19", "Vpv20", "Ipv20",
  "Vpv21", "Ipv21", "Vpv22", "Ipv22", "Vpv23", "Ipv23", "Vpv24", "Ipv24",
  "Istr1", "Istr2", "Istr3", "Istr4", "Istr5", "Istr6", "Istr7", "Istr8",
  "Istr9", "Istr10", "Istr11", "Istr12", "Istr13", "Istr14", "Istr15", "Istr16",
  "Istr17", "Istr18", "Istr19", "Istr20", "Istr21", "Istr22", "Istr23", "Istr24",
  "Ppv1", "Ppv2", "Ppv3", "Ppv4", "Ppv5", "Ppv6", "Ppv7", "Ppv8", "Ppv9", "Ppv10", "Ppv11", "Ppv12",
  "Internal_temperature",
  "Cabinet_Temperature_2",
  "DSP_Error_Code",
  "DSP_Alarm_Code",
  "Slave_DSP_ErrorCode",
  "Slave_DSP_AlarmCode",
  "PV_String_Fault_Bit",
  "Temperature_Fault_Bit",
  "Phase",
  "PowerCapacity",
  "RatedLineVoltage",
];

function buildInsertSql(tableName) {
  const table = tableName || "dm_inverter_data";
  const cols = DM_INVERTER_DATA_COLUMNS.join(", ");
  const placeholders = DM_INVERTER_DATA_COLUMNS.map(function () {
    return "?";
  }).join(", ");
  return "INSERT INTO " + table + " (" + cols + ") VALUES (" + placeholders + ")";
}

function valuesFromObject(data) {
  return DM_INVERTER_DATA_COLUMNS.map(function (col) {
    return data[col] != null ? data[col] : null;
  });
}

module.exports = {
  DM_INVERTER_DATA_COLUMNS,
  buildInsertSql,
  valuesFromObject,
};
