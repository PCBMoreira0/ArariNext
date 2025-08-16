import 'dart:typed_data';
import 'package:dart_mavlink/mavlink_dialect.dart';
import 'package:dart_mavlink/mavlink_message.dart';
import 'package:dart_mavlink/types.dart';

/// Component ids (values) for the different types and instances of onboard hardware/software that might make up a MAVLink system (autopilot, cameras, servos, GPS systems, avoidance systems etc.).
/// Components must use the appropriate ID in their source address when sending messages. Components can also use IDs to determine if they are the intended recipient of an incoming message. The MAV_COMP_ID_ALL value is used to indicate messages that must be processed by all components.
/// When creating new entries, components that can have multiple instances (e.g. cameras, servos etc.) should be allocated sequential values. An appropriate number of values should be left free after these components to allow the number of instances to be expanded.
///
/// MAV_COMPONENT
typedef MavComponent = int;

/// Target id (target_component) used to broadcast messages to all components of the receiving system. Components should attempt to process messages with this component ID and forward to components on any other interfaces. Note: This is not a valid *source* component id for a message.
///
/// MAV_COMP_ID_ALL
const MavComponent mavCompIdAll = 0;

/// TTGO Lora Radio(100mW)
///
/// MAV_COMP_ID_RADIO_915
const MavComponent mavCompIdRadio915 = 1;

/// EByte Lora Radio(2W)
///
/// MAV_COMP_ID_RADIO_433
const MavComponent mavCompIdRadio433 = 2;

/// Message sent via internet
///
/// MAV_COMP_ID_INTERNET
const MavComponent mavCompIdInternet = 3;

/// Represents the status of the battery. Derived from input register 3200.
///
/// MPPT_BATTERY_STATUS
typedef MpptBatteryStatus = int;

/// All monitored parameters are normal. For battery (ID=3200): Voltage Normal (D3-D0=00H), Temp Normal (D7-D4=00H), Internal Resistance Normal (D8=0), Rated Voltage ID Normal (D15=0).
///
/// MPPT_STATUS_NORMAL
const MpptBatteryStatus mpptStatusNormal = 0;

/// Battery overvoltage detected (e.g., ID=3200, D3-D0 = 01H).
///
/// MPPT_STATUS_OVERVOLTAGE
const MpptBatteryStatus mpptStatusOvervoltage = 1;

/// Battery undervoltage detected (e.g., ID=3200, D3-D0 = 02H).
///
/// MPPT_STATUS_UNDERVOLTAGE
const MpptBatteryStatus mpptStatusUndervoltage = 2;

/// Battery low voltage disconnect activated (e.g., ID=3200, D3-D0 = 03H).
///
/// MPPT_STATUS_VOLTAGE_LOW_VOLT_DISCONNECT
const MpptBatteryStatus mpptStatusVoltageLowVoltDisconnect = 3;

/// A general battery voltage fault detected (e.g., ID=3200, D3-D0 = 04H).
///
/// MPPT_STATUS_VOLTAGE_FAULT
const MpptBatteryStatus mpptStatusVoltageFault = 4;

/// Over temperature detected (e.g., ID=3200, D7-D4 = 01H).
///
/// MPPT_STATUS_TEMP_OVER
const MpptBatteryStatus mpptStatusTempOver = 5;

/// Low temperature detected (e.g., ID=3200, D7-D4 = 02H).
///
/// MPPT_STATUS_TEMP_LOW
const MpptBatteryStatus mpptStatusTempLow = 6;

/// Battery internal resistance is abnormal (e.g., ID=3200, D8 = 1).
///
/// MPPT_STATUS_INTERNAL_RESISTANCE_ABNORMAL
const MpptBatteryStatus mpptStatusInternalResistanceAbnormal = 7;

/// Wrong identification for rated voltage (e.g., ID=3200, D15 = 1).
///
/// MPPT_STATUS_RATED_VOLTAGE_ID_WRONG
const MpptBatteryStatus mpptStatusRatedVoltageIdWrong = 8;

/// The status is unknown or not yet determined.
///
/// MPPT_STATUS_UNKNOWN
const MpptBatteryStatus mpptStatusUnknown = 255;

/// Represents the primary status of the charging equipment. Derived by interpreting bits in input register 3201. The reported status may depend on the priority logic implemented in the monitoring software if multiple conditions are present.
///
/// MPPT_CHARGING_EQUIPMENT_STATUS
typedef MpptChargingEquipmentStatus = int;

/// Equipment is running mode, else standby (register 3201: D0=1 = running). Typically implies no active charging and no faults.
///
/// MPPT_CHARGING_STATUS_RUNNING_STANDBY
const MpptChargingEquipmentStatus mpptChargingStatusRunningStandby = 0;

/// Equipment has detected a fault (D1=1=Fault)
///
/// MPPT_CHARGING_STATUS_NORMAL_FAULT
const MpptChargingEquipmentStatus mpptChargingStatusNormalFault = 1;

/// Equipment is in float charging mode (register 3201: D0=1, D1=0 (No Fault), D3-D2=01H (Float), and D15-D14=00H (Input Volt Normal)).
///
/// MPPT_CHARGING_STATUS_FLOAT
const MpptChargingEquipmentStatus mpptChargingStatusFloat = 2;

/// Equipment is in boost charging mode (register 3201: D0=1, D1=0 (No Fault), D3-D2=02H (Boost), and D15-D14=00H (Input Volt Normal)).
///
/// MPPT_CHARGING_STATUS_BOOST
const MpptChargingEquipmentStatus mpptChargingStatusBoost = 3;

/// Equipment is in equalization charging mode (register 3201: D0=1, D1=0 (No Fault), D3-D2=03H (Equalization), and D15-D14=00H (Input Volt Normal)).
///
/// MPPT_CHARGING_STATUS_EQUALIZATION
const MpptChargingEquipmentStatus mpptChargingStatusEqualization = 4;

/// No power connected to input (register 3201: D15-D14=01H). Equipment may be off or in a pre-start state.
///
/// MPPT_CHARGING_INPUT_VOLTAGE_NONE
const MpptChargingEquipmentStatus mpptChargingInputVoltageNone = 5;

/// Input voltage is too high (register 3201: D15-D14=02H). This may lead to a fault condition (D1=1).
///
/// MPPT_CHARGING_INPUT_VOLTAGE_HIGH
const MpptChargingEquipmentStatus mpptChargingInputVoltageHigh = 6;

/// General input voltage error detected (register 3201: D15-D14=03H). This may lead to a fault condition (D1=1).
///
/// MPPT_CHARGING_INPUT_VOLTAGE_ERROR
const MpptChargingEquipmentStatus mpptChargingInputVoltageError = 7;

/// PV input short circuit detected (register 3201: D4=1. Typically, D1=1 will also be set).
///
/// MPPT_CHARGING_FAULT_PV_SHORT
const MpptChargingEquipmentStatus mpptChargingFaultPvShort = 8;

/// Fault on the load side, such as load over current (D9=1), load short circuit (D8=1), or load MOSFET short (D7=1) (register 3201. Typically, D1=1 will also be set).
///
/// MPPT_CHARGING_FAULT_LOAD_SIDE
const MpptChargingEquipmentStatus mpptChargingFaultLoadSide = 9;

/// Input over current detected (register 3201: D10=1. Typically, D1=1 will also be set).
///
/// MPPT_CHARGING_FAULT_INPUT_OVERCURRENT
const MpptChargingEquipmentStatus mpptChargingFaultInputOvercurrent = 10;

/// Internal MOSFET short circuit detected (Charging MOSFET D13=1, Charging or Anti-reverse MOSFET D12=1, or Anti-reverse MOSFET D11=1) (register 3201. Typically, D1=1 will also be set).
///
/// MPPT_CHARGING_FAULT_MOSFET_SHORT
const MpptChargingEquipmentStatus mpptChargingFaultMosfetShort = 11;

/// A general system fault is active (register 3201: D1=1), not covered by other more specific fault entries in this enum.
///
/// MPPT_CHARGING_FAULT_SYSTEM
const MpptChargingEquipmentStatus mpptChargingFaultSystem = 12;

/// Equipment is running but not actively charging (register 3201: D0=1, D1=0 (No Fault), D3-D2=00H (No Charging), and D15-D14=00H (Input Volt Normal)).
///
/// MPPT_CHARGING_STATUS_NO_CHARGING
const MpptChargingEquipmentStatus mpptChargingStatusNoCharging = 13;

/// The charging equipment status is unknown or not yet determined.
///
/// MPPT_CHARGING_STATUS_UNKNOWN
const MpptChargingEquipmentStatus mpptChargingStatusUnknown = 255;

///
/// Flags to describe the charge/discharge status of a battery system, designed to be packed into a single byte.
/// The status is composed of three parts:
/// 1. Operational State (2 bits, bits 0-1): Indicates if the system is stationary, charging, or discharging.
/// - 0 (00b): Stationary
/// - 1 (01b): Charging
/// - 2 (10b): Discharging
/// - 3 (11b): Reserved for future use.
/// 2. Charge MOSFET State (1 bit, bit 2): Indicates if the charge MOSFET is ON (1) or OFF (0).
/// 3. Discharge MOSFET State (1 bit, bit 3): Indicates if the discharge MOSFET is ON (1) or OFF (0).
///
/// The enum entries provide values that can be ORed together to form the complete status byte.
/// For example, to represent 'Charging' with 'Charge MOS ON' and 'Discharge MOS OFF':
/// (CHARGE_DISCHARGE_STATE_CHARGING | CHARGE_DISCHARGE_CHARGE_MOS_ON)
/// This would result in a value of (1 | 4) = 5.
///
/// To decode:
/// - state = value and 0x03;
/// - charge_mos_on = (value and CHARGE_DISCHARGE_CHARGE_MOS_ON) != 0
/// - discharge_mos_on = (value and CHARGE_DISCHARGE_DISCHARGE_MOS_ON) != 0
///
///
/// BMS_CHARGE_DISCHARGE_STATUS_FLAGS
typedef BmsChargeDischargeStatusFlags = int;

/// Operational state is Stationary (neither charging nor discharging). This value (00b) occupies bits 0-1.
///
/// CHARGE_DISCHARGE_STATE_STATIONARY
const BmsChargeDischargeStatusFlags chargeDischargeStateStationary = 1;

/// Operational state is Charging. This value (01b) occupies bits 0-1.
///
/// CHARGE_DISCHARGE_STATE_CHARGING
const BmsChargeDischargeStatusFlags chargeDischargeStateCharging = 2;

/// Operational state is Discharging. This value (10b) occupies bits 0-1.
///
/// CHARGE_DISCHARGE_STATE_DISCHARGING
const BmsChargeDischargeStatusFlags chargeDischargeStateDischarging = 4;

/// Charge MOSFET is ON. This flag occupies bit 2. If this flag is not set, Charge MOS is OFF.
///
/// CHARGE_DISCHARGE_CHARGE_MOS_ON
const BmsChargeDischargeStatusFlags chargeDischargeChargeMosOn = 8;

/// Discharge MOSFET is ON. This flag occupies bit 3. If this flag is not set, Discharge MOS is OFF.
///
/// CHARGE_DISCHARGE_DISCHARGE_MOS_ON
const BmsChargeDischargeStatusFlags chargeDischargeDischargeMosOn = 16;

/// Flags for Byte 0 of the Daly BMS failure status: Voltage-related failures.
///
/// DALY_FAILURE_BYTE0_VOLTAGE_FLAGS
typedef DalyFailureByte0VoltageFlags = int;

/// Cell voltage high level 1 alarm.
///
/// DALY_FAILURE_CELL_VOLT_HIGH_LVL1
const DalyFailureByte0VoltageFlags dalyFailureCellVoltHighLvl1 = 1;

/// Cell voltage high level 2 alarm.
///
/// DALY_FAILURE_CELL_VOLT_HIGH_LVL2
const DalyFailureByte0VoltageFlags dalyFailureCellVoltHighLvl2 = 2;

/// Cell voltage low level 1 alarm.
///
/// DALY_FAILURE_CELL_VOLT_LOW_LVL1
const DalyFailureByte0VoltageFlags dalyFailureCellVoltLowLvl1 = 4;

/// Cell voltage low level 2 alarm.
///
/// DALY_FAILURE_CELL_VOLT_LOW_LVL2
const DalyFailureByte0VoltageFlags dalyFailureCellVoltLowLvl2 = 8;

/// Sum voltage high level 1 alarm.
///
/// DALY_FAILURE_SUM_VOLT_HIGH_LVL1
const DalyFailureByte0VoltageFlags dalyFailureSumVoltHighLvl1 = 16;

/// Sum voltage high level 2 alarm.
///
/// DALY_FAILURE_SUM_VOLT_HIGH_LVL2
const DalyFailureByte0VoltageFlags dalyFailureSumVoltHighLvl2 = 32;

/// Sum voltage low level 1 alarm.
///
/// DALY_FAILURE_SUM_VOLT_LOW_LVL1
const DalyFailureByte0VoltageFlags dalyFailureSumVoltLowLvl1 = 64;

/// Sum voltage low level 2 alarm.
///
/// DALY_FAILURE_SUM_VOLT_LOW_LVL2
const DalyFailureByte0VoltageFlags dalyFailureSumVoltLowLvl2 = 128;

/// Flags for Byte 1 of the Daly BMS failure status: Temperature-related failures.
///
/// DALY_FAILURE_BYTE1_TEMP_FLAGS
typedef DalyFailureByte1TempFlags = int;

/// Charge temperature high level 1 alarm.
///
/// DALY_FAILURE_CHG_TEMP_HIGH_LVL1
const DalyFailureByte1TempFlags dalyFailureChgTempHighLvl1 = 1;

/// Charge temperature high level 2 alarm.
///
/// DALY_FAILURE_CHG_TEMP_HIGH_LVL2
const DalyFailureByte1TempFlags dalyFailureChgTempHighLvl2 = 2;

/// Charge temperature low level 1 alarm.
///
/// DALY_FAILURE_CHG_TEMP_LOW_LVL1
const DalyFailureByte1TempFlags dalyFailureChgTempLowLvl1 = 4;

/// Charge temperature low level 2 alarm.
///
/// DALY_FAILURE_CHG_TEMP_LOW_LVL2
const DalyFailureByte1TempFlags dalyFailureChgTempLowLvl2 = 8;

/// Discharge temperature high level 1 alarm.
///
/// DALY_FAILURE_DISCHG_TEMP_HIGH_LVL1
const DalyFailureByte1TempFlags dalyFailureDischgTempHighLvl1 = 16;

/// Discharge temperature high level 2 alarm.
///
/// DALY_FAILURE_DISCHG_TEMP_HIGH_LVL2
const DalyFailureByte1TempFlags dalyFailureDischgTempHighLvl2 = 32;

/// Discharge temperature low level 1 alarm.
///
/// DALY_FAILURE_DISCHG_TEMP_LOW_LVL1
const DalyFailureByte1TempFlags dalyFailureDischgTempLowLvl1 = 64;

/// Discharge temperature low level 2 alarm.
///
/// DALY_FAILURE_DISCHG_TEMP_LOW_LVL2
const DalyFailureByte1TempFlags dalyFailureDischgTempLowLvl2 = 128;

/// Flags for Byte 2 of the Daly BMS failure status: Current and SOC related failures.
///
/// DALY_FAILURE_BYTE2_CURRENT_SOC_FLAGS
typedef DalyFailureByte2CurrentSocFlags = int;

/// Charge overcurrent level 1 alarm.
///
/// DALY_FAILURE_CHG_OVERCURRENT_LVL1
const DalyFailureByte2CurrentSocFlags dalyFailureChgOvercurrentLvl1 = 1;

/// Charge overcurrent level 2 alarm.
///
/// DALY_FAILURE_CHG_OVERCURRENT_LVL2
const DalyFailureByte2CurrentSocFlags dalyFailureChgOvercurrentLvl2 = 2;

/// Discharge overcurrent level 1 alarm.
///
/// DALY_FAILURE_DISCHG_OVERCURRENT_LVL1
const DalyFailureByte2CurrentSocFlags dalyFailureDischgOvercurrentLvl1 = 4;

/// Discharge overcurrent level 2 alarm.
///
/// DALY_FAILURE_DISCHG_OVERCURRENT_LVL2
const DalyFailureByte2CurrentSocFlags dalyFailureDischgOvercurrentLvl2 = 8;

/// SOC high level 1 alarm.
///
/// DALY_FAILURE_SOC_HIGH_LVL1
const DalyFailureByte2CurrentSocFlags dalyFailureSocHighLvl1 = 16;

/// SOC high level 2 alarm.
///
/// DALY_FAILURE_SOC_HIGH_LVL2
const DalyFailureByte2CurrentSocFlags dalyFailureSocHighLvl2 = 32;

/// SOC low level 1 alarm.
///
/// DALY_FAILURE_SOC_LOW_LVL1
const DalyFailureByte2CurrentSocFlags dalyFailureSocLowLvl1 = 64;

/// SOC low level 2 alarm.
///
/// DALY_FAILURE_SOC_LOW_LVL2
const DalyFailureByte2CurrentSocFlags dalyFailureSocLowLvl2 = 128;

/// Flags for Byte 3 of the Daly BMS failure status: Differential voltage/temperature failures. Bits 4-7 are reserved.
///
/// DALY_FAILURE_BYTE3_DIFFERENTIAL_FLAGS
typedef DalyFailureByte3DifferentialFlags = int;

/// Differential voltage level 1 alarm.
///
/// DALY_FAILURE_DIFF_VOLT_LVL1
const DalyFailureByte3DifferentialFlags dalyFailureDiffVoltLvl1 = 1;

/// Differential voltage level 2 alarm.
///
/// DALY_FAILURE_DIFF_VOLT_LVL2
const DalyFailureByte3DifferentialFlags dalyFailureDiffVoltLvl2 = 2;

/// Differential temperature level 1 alarm.
///
/// DALY_FAILURE_DIFF_TEMP_LVL1
const DalyFailureByte3DifferentialFlags dalyFailureDiffTempLvl1 = 4;

/// Differential temperature level 2 alarm.
///
/// DALY_FAILURE_DIFF_TEMP_LVL2
const DalyFailureByte3DifferentialFlags dalyFailureDiffTempLvl2 = 8;

/// Flags for Byte 4 of the Daly BMS failure status: MOSFET and related sensor failures.
///
/// DALY_FAILURE_BYTE4_MOSFET_SENSOR_FLAGS
typedef DalyFailureByte4MosfetSensorFlags = int;

/// Charge MOS temperature high alarm.
///
/// DALY_FAILURE_CHG_MOS_TEMP_HIGH_ALARM
const DalyFailureByte4MosfetSensorFlags dalyFailureChgMosTempHighAlarm = 1;

/// Discharge MOS temperature high alarm.
///
/// DALY_FAILURE_DISCHG_MOS_TEMP_HIGH_ALARM
const DalyFailureByte4MosfetSensorFlags dalyFailureDischgMosTempHighAlarm = 2;

/// Charge MOS temperature sensor error.
///
/// DALY_FAILURE_CHG_MOS_TEMP_SENSOR_ERR
const DalyFailureByte4MosfetSensorFlags dalyFailureChgMosTempSensorErr = 4;

/// Discharge MOS temperature sensor error.
///
/// DALY_FAILURE_DISCHG_MOS_TEMP_SENSOR_ERR
const DalyFailureByte4MosfetSensorFlags dalyFailureDischgMosTempSensorErr = 8;

/// Charge MOS adhesion error.
///
/// DALY_FAILURE_CHG_MOS_ADHESION_ERR
const DalyFailureByte4MosfetSensorFlags dalyFailureChgMosAdhesionErr = 16;

/// Discharge MOS adhesion error.
///
/// DALY_FAILURE_DISCHG_MOS_ADHESION_ERR
const DalyFailureByte4MosfetSensorFlags dalyFailureDischgMosAdhesionErr = 32;

/// Charge MOS open circuit error.
///
/// DALY_FAILURE_CHG_MOS_OPEN_CIRCUIT_ERR
const DalyFailureByte4MosfetSensorFlags dalyFailureChgMosOpenCircuitErr = 64;

/// Discharge MOS open circuit error (Corrected from 'Discrg' in PDF).
///
/// DALY_FAILURE_DISCHG_MOS_OPEN_CIRCUIT_ERR
const DalyFailureByte4MosfetSensorFlags dalyFailureDischgMosOpenCircuitErr =
    128;

/// Flags for Byte 5 of the Daly BMS failure status: System/Component failures.
///
/// DALY_FAILURE_BYTE5_SYSTEM_COMPONENT_FLAGS
typedef DalyFailureByte5SystemComponentFlags = int;

/// AFE collect chip error.
///
/// DALY_FAILURE_AFE_COLLECT_CHIP_ERR
const DalyFailureByte5SystemComponentFlags dalyFailureAfeCollectChipErr = 1;

/// Voltage collect dropped.
///
/// DALY_FAILURE_VOLTAGE_COLLECT_DROPPED
const DalyFailureByte5SystemComponentFlags dalyFailureVoltageCollectDropped = 2;

/// Cell temperature sensor error.
///
/// DALY_FAILURE_CELL_TEMP_SENSOR_ERR
const DalyFailureByte5SystemComponentFlags dalyFailureCellTempSensorErr = 4;

/// EEPROM error.
///
/// DALY_FAILURE_EEPROM_ERR
const DalyFailureByte5SystemComponentFlags dalyFailureEepromErr = 8;

/// RTC error.
///
/// DALY_FAILURE_RTC_ERR
const DalyFailureByte5SystemComponentFlags dalyFailureRtcErr = 16;

/// Precharge failure.
///
/// DALY_FAILURE_PRECHARGE_FAILURE
const DalyFailureByte5SystemComponentFlags dalyFailurePrechargeFailure = 32;

/// Communication failure (external).
///
/// DALY_FAILURE_COMMUNICATION_FAILURE
const DalyFailureByte5SystemComponentFlags dalyFailureCommunicationFailure = 64;

/// Internal communication failure.
///
/// DALY_FAILURE_INTERNAL_COMM_FAILURE
const DalyFailureByte5SystemComponentFlags dalyFailureInternalCommFailure = 128;

/// Flags for Byte 6 of the Daly BMS failure status: Other faults. Bits 4-7 are reserved.
///
/// DALY_FAILURE_BYTE6_OTHER_FAULTS_FLAGS
typedef DalyFailureByte6OtherFaultsFlags = int;

/// Current module fault.
///
/// DALY_FAILURE_CURRENT_MODULE_FAULT
const DalyFailureByte6OtherFaultsFlags dalyFailureCurrentModuleFault = 1;

/// Sum voltage detect fault.
///
/// DALY_FAILURE_SUM_VOLTAGE_DETECT_FAULT
const DalyFailureByte6OtherFaultsFlags dalyFailureSumVoltageDetectFault = 2;

/// Short circuit protect fault.
///
/// DALY_FAILURE_SHORT_CIRCUIT_PROTECT_FAULT
const DalyFailureByte6OtherFaultsFlags dalyFailureShortCircuitProtectFault = 4;

/// Low voltage forbidden charge fault.
///
/// DALY_FAILURE_LOW_VOLT_FORBIDDEN_CHG_FAULT
const DalyFailureByte6OtherFaultsFlags dalyFailureLowVoltForbiddenChgFault = 8;

/// ESC Gear status derived from bits 2-0 from message II, byte 3
///
/// EZKONTROL_STATUS_GEAR
typedef EzkontrolStatusGear = int;

/// Gear: NO (Neutral/No Gear)
///
/// EZKONTROL_GEAR_NO
const EzkontrolStatusGear ezkontrolGearNo = 0;

/// Gear: R (Reverse)
///
/// EZKONTROL_GEAR_R
const EzkontrolStatusGear ezkontrolGearR = 1;

/// Gear: N (Neutral)
///
/// EZKONTROL_GEAR_N
const EzkontrolStatusGear ezkontrolGearN = 2;

/// Gear: D1 (Drive 1)
///
/// EZKONTROL_GEAR_D1
const EzkontrolStatusGear ezkontrolGearD1 = 3;

/// Gear: D2 (Drive 2)
///
/// EZKONTROL_GEAR_D2
const EzkontrolStatusGear ezkontrolGearD2 = 4;

/// Gear: D3 (Drive 3)
///
/// EZKONTROL_GEAR_D3
const EzkontrolStatusGear ezkontrolGearD3 = 5;

/// Gear: S (Sport/Special)
///
/// EZKONTROL_GEAR_S
const EzkontrolStatusGear ezkontrolGearS = 6;

/// Gear: P (Park)
///
/// EZKONTROL_GEAR_P
const EzkontrolStatusGear ezkontrolGearP = 7;

/// ESC operation mode derived from bits 6-4 from message II, byte 3
///
/// EZKONTROL_STATUS_OPERATION_MODE
typedef EzkontrolStatusOperationMode = int;

/// Operation Mode: Stop
///
/// EZKONTROL_OP_MODE_STOP
const EzkontrolStatusOperationMode ezkontrolOpModeStop = 0;

/// Operation Mode: Drive
///
/// EZKONTROL_OP_MODE_DRIVE
const EzkontrolStatusOperationMode ezkontrolOpModeDrive = 1;

/// Operation Mode: Cruise
///
/// EZKONTROL_OP_MODE_CRUISE
const EzkontrolStatusOperationMode ezkontrolOpModeCruise = 2;

/// Operation Mode: EBS (Electronic Braking System)
///
/// EZKONTROL_OP_MODE_EBS
const EzkontrolStatusOperationMode ezkontrolOpModeEbs = 3;

/// Operation Mode: Hold
///
/// EZKONTROL_OP_MODE_HOLD
const EzkontrolStatusOperationMode ezkontrolOpModeHold = 4;

/// Status flags from Byte 3 of EZkontrol MCU Message II (Brake, DC Contactor).
///
/// EZKONTROL_STATUS_BYTE3_FLAGS
typedef EzkontrolStatusByte3Flags = int;

/// Brake is active.
///
/// EZKONTROL_STATUS_BRAKE_ACTIVE
const EzkontrolStatusByte3Flags ezkontrolStatusBrakeActive = 8;

/// DC Contactor is ON.
///
/// EZKONTROL_STATUS_DC_CONTACTOR_ON
const EzkontrolStatusByte3Flags ezkontrolStatusDcContactorOn = 128;

/// Error flags from Byte 4 of EZkontrol MCU Message II.
///
/// EZKONTROL_ERROR_BYTE4_FLAGS
typedef EzkontrolErrorByte4Flags = int;

/// Error: Overcurrent.
///
/// EZKONTROL_ERROR_OVERCURRENT
const EzkontrolErrorByte4Flags ezkontrolErrorOvercurrent = 1;

/// Error: Overload.
///
/// EZKONTROL_ERROR_OVERLOAD
const EzkontrolErrorByte4Flags ezkontrolErrorOverload = 2;

/// Error: Overvoltage.
///
/// EZKONTROL_ERROR_OVERVOLTAGE
const EzkontrolErrorByte4Flags ezkontrolErrorOvervoltage = 4;

/// Error: Undervoltage.
///
/// EZKONTROL_ERROR_UNDERVOLTAGE
const EzkontrolErrorByte4Flags ezkontrolErrorUndervoltage = 8;

/// Error: Controller Overheat.
///
/// EZKONTROL_ERROR_CONTROLLER_OVERHEAT
const EzkontrolErrorByte4Flags ezkontrolErrorControllerOverheat = 16;

/// Error: Motor Overheat.
///
/// EZKONTROL_ERROR_MOTOR_OVERHEAT
const EzkontrolErrorByte4Flags ezkontrolErrorMotorOverheat = 32;

/// Error: Motor Stalled.
///
/// EZKONTROL_ERROR_MOTOR_STALLED
const EzkontrolErrorByte4Flags ezkontrolErrorMotorStalled = 64;

/// Error: Motor Out of phase.
///
/// EZKONTROL_ERROR_MOTOR_OUT_OF_PHASE
const EzkontrolErrorByte4Flags ezkontrolErrorMotorOutOfPhase = 128;

/// Error flags from Byte 5 of EZkontrol MCU Message II.
///
/// EZKONTROL_ERROR_BYTE5_FLAGS
typedef EzkontrolErrorByte5Flags = int;

/// Error: Motor Sensor.
///
/// EZKONTROL_ERROR_MOTOR_SENSOR
const EzkontrolErrorByte5Flags ezkontrolErrorMotorSensor = 1;

/// Error: Motor AUX Sensor.
///
/// EZKONTROL_ERROR_MOTOR_AUX_SENSOR
const EzkontrolErrorByte5Flags ezkontrolErrorMotorAuxSensor = 2;

/// Error: Encoder Misaligned.
///
/// EZKONTROL_ERROR_ENCODER_MISALIGNED
const EzkontrolErrorByte5Flags ezkontrolErrorEncoderMisaligned = 4;

/// Error: Anti-Runaway Engaged.
///
/// EZKONTROL_ERROR_ANTI_RUNAWAY_ENGAGED
const EzkontrolErrorByte5Flags ezkontrolErrorAntiRunawayEngaged = 8;

/// Error: Main Accelerator.
///
/// EZKONTROL_ERROR_MAIN_ACCELERATOR
const EzkontrolErrorByte5Flags ezkontrolErrorMainAccelerator = 16;

/// Error: AUX Accelerator.
///
/// EZKONTROL_ERROR_AUX_ACCELERATOR
const EzkontrolErrorByte5Flags ezkontrolErrorAuxAccelerator = 32;

/// Error: Pre-charge.
///
/// EZKONTROL_ERROR_PRE_CHARGE
const EzkontrolErrorByte5Flags ezkontrolErrorPreCharge = 64;

/// Error: DC Contactor fault (distinct from status).
///
/// EZKONTROL_ERROR_DC_CONTACTOR_FAULT
const EzkontrolErrorByte5Flags ezkontrolErrorDcContactorFault = 128;

/// Error flags from Byte 6 of EZkontrol MCU Message II.
///
/// EZKONTROL_ERROR_BYTE6_FLAGS
typedef EzkontrolErrorByte6Flags = int;

/// Error: Power valve.
///
/// EZKONTROL_ERROR_POWER_VALVE
const EzkontrolErrorByte6Flags ezkontrolErrorPowerValve = 1;

/// Error: Current Sensor.
///
/// EZKONTROL_ERROR_CURRENT_SENSOR
const EzkontrolErrorByte6Flags ezkontrolErrorCurrentSensor = 2;

/// Error: Auto-tune.
///
/// EZKONTROL_ERROR_AUTO_TUNE
const EzkontrolErrorByte6Flags ezkontrolErrorAutoTune = 4;

/// Error: RS485 communication.
///
/// EZKONTROL_ERROR_RS485
const EzkontrolErrorByte6Flags ezkontrolErrorRs485 = 8;

/// Error: CAN communication.
///
/// EZKONTROL_ERROR_CAN_COMM
const EzkontrolErrorByte6Flags ezkontrolErrorCanComm = 16;

/// Error: Software.
///
/// EZKONTROL_ERROR_SOFTWARE
const EzkontrolErrorByte6Flags ezkontrolErrorSoftware = 32;

/// Specifies the datatype of a MAVLink parameter.
///
/// MAV_PARAM_TYPE
typedef MavParamType = int;

/// 8-bit unsigned integer
///
/// MAV_PARAM_TYPE_UINT8
const MavParamType mavParamTypeUint8 = 1;

/// 8-bit signed integer
///
/// MAV_PARAM_TYPE_INT8
const MavParamType mavParamTypeInt8 = 2;

/// 16-bit unsigned integer
///
/// MAV_PARAM_TYPE_UINT16
const MavParamType mavParamTypeUint16 = 3;

/// 16-bit signed integer
///
/// MAV_PARAM_TYPE_INT16
const MavParamType mavParamTypeInt16 = 4;

/// 32-bit unsigned integer
///
/// MAV_PARAM_TYPE_UINT32
const MavParamType mavParamTypeUint32 = 5;

/// 32-bit signed integer
///
/// MAV_PARAM_TYPE_INT32
const MavParamType mavParamTypeInt32 = 6;

/// 64-bit unsigned integer
///
/// MAV_PARAM_TYPE_UINT64
const MavParamType mavParamTypeUint64 = 7;

/// 64-bit signed integer
///
/// MAV_PARAM_TYPE_INT64
const MavParamType mavParamTypeInt64 = 8;

/// 32-bit floating-point
///
/// MAV_PARAM_TYPE_REAL32
const MavParamType mavParamTypeReal32 = 9;

/// 64-bit floating-point
///
/// MAV_PARAM_TYPE_REAL64
const MavParamType mavParamTypeReal64 = 10;

/// Indicates the severity level, generally used for status messages to indicate their relative urgency. Based on RFC-5424 using expanded definitions at: http://www.kiwisyslog.com/kb/info:-syslog-message-levels/.
///
/// MAV_SEVERITY
typedef MavSeverity = int;

/// System is unusable. This is a "panic" condition.
///
/// MAV_SEVERITY_EMERGENCY
const MavSeverity mavSeverityEmergency = 0;

/// Action should be taken immediately. Indicates error in non-critical systems.
///
/// MAV_SEVERITY_ALERT
const MavSeverity mavSeverityAlert = 1;

/// Action must be taken immediately. Indicates failure in a primary system.
///
/// MAV_SEVERITY_CRITICAL
const MavSeverity mavSeverityCritical = 2;

/// Indicates an error in secondary/redundant systems.
///
/// MAV_SEVERITY_ERROR
const MavSeverity mavSeverityError = 3;

/// Indicates about a possible future error if this is not resolved within a given timeframe. Example would be a low battery warning.
///
/// MAV_SEVERITY_WARNING
const MavSeverity mavSeverityWarning = 4;

/// An unusual event has occurred, though not an error condition. This should be investigated for the root cause.
///
/// MAV_SEVERITY_NOTICE
const MavSeverity mavSeverityNotice = 5;

/// Normal operational messages. Useful for logging. No action is required for these messages.
///
/// MAV_SEVERITY_INFO
const MavSeverity mavSeverityInfo = 6;

/// Useful non-operational messages that can assist in debugging. These should not occur during normal operation.
///
/// MAV_SEVERITY_DEBUG
const MavSeverity mavSeverityDebug = 7;

/// Instrumentation PCBs
///
/// INSTRUMENTATION
class Instrumentation implements MavlinkMessage {
  static const int _mavlinkMessageId = 1;

  static const int _mavlinkCrcExtra = 83;

  static const int mavlinkEncodedLength = 22;

  @override
  int get mavlinkMessageId => _mavlinkMessageId;

  @override
  int get mavlinkCrcExtra => _mavlinkCrcExtra;

  /// Seconds since Unix time
  ///
  /// MAVLink type: uint32_t
  ///
  /// timestamp_seconds
  final uint32_t timestampSeconds;

  ///
  ///
  /// MAVLink type: int16_t
  ///
  /// units: cA
  ///
  /// battery_current
  final int16_t batteryCurrent;

  ///
  ///
  /// MAVLink type: int16_t
  ///
  /// units: cA
  ///
  /// motor_current_left
  final int16_t motorCurrentLeft;

  ///
  ///
  /// MAVLink type: int16_t
  ///
  /// units: cA
  ///
  /// motor_current_right
  final int16_t motorCurrentRight;

  ///
  ///
  /// MAVLink type: int16_t
  ///
  /// units: cA
  ///
  /// mppt_current
  final int16_t mpptCurrent;

  ///
  ///
  /// MAVLink type: int16_t
  ///
  /// units: cA
  ///
  /// auxiliary_battery_current
  final int16_t auxiliaryBatteryCurrent;

  ///
  ///
  /// MAVLink type: uint16_t
  ///
  /// units: cV
  ///
  /// battery_voltage
  final uint16_t batteryVoltage;

  ///
  ///
  /// MAVLink type: uint16_t
  ///
  /// units: cV
  ///
  /// auxiliary_battery_voltage
  final uint16_t auxiliaryBatteryVoltage;

  ///
  ///
  /// MAVLink type: uint16_t
  ///
  /// units: W/m^2
  ///
  /// irradiance
  final uint16_t irradiance;

  /// Milliseconds within Unix time
  ///
  /// MAVLink type: uint16_t
  ///
  /// timestamp_milliseconds
  final uint16_t timestampMilliseconds;

  Instrumentation({
    required this.timestampSeconds,
    required this.batteryCurrent,
    required this.motorCurrentLeft,
    required this.motorCurrentRight,
    required this.mpptCurrent,
    required this.auxiliaryBatteryCurrent,
    required this.batteryVoltage,
    required this.auxiliaryBatteryVoltage,
    required this.irradiance,
    required this.timestampMilliseconds,
  });

  Instrumentation copyWith({
    uint32_t? timestampSeconds,
    int16_t? batteryCurrent,
    int16_t? motorCurrentLeft,
    int16_t? motorCurrentRight,
    int16_t? mpptCurrent,
    int16_t? auxiliaryBatteryCurrent,
    uint16_t? batteryVoltage,
    uint16_t? auxiliaryBatteryVoltage,
    uint16_t? irradiance,
    uint16_t? timestampMilliseconds,
  }) {
    return Instrumentation(
      timestampSeconds: timestampSeconds ?? this.timestampSeconds,
      batteryCurrent: batteryCurrent ?? this.batteryCurrent,
      motorCurrentLeft: motorCurrentLeft ?? this.motorCurrentLeft,
      motorCurrentRight: motorCurrentRight ?? this.motorCurrentRight,
      mpptCurrent: mpptCurrent ?? this.mpptCurrent,
      auxiliaryBatteryCurrent:
          auxiliaryBatteryCurrent ?? this.auxiliaryBatteryCurrent,
      batteryVoltage: batteryVoltage ?? this.batteryVoltage,
      auxiliaryBatteryVoltage:
          auxiliaryBatteryVoltage ?? this.auxiliaryBatteryVoltage,
      irradiance: irradiance ?? this.irradiance,
      timestampMilliseconds:
          timestampMilliseconds ?? this.timestampMilliseconds,
    );
  }

  factory Instrumentation.parse(ByteData data_) {
    if (data_.lengthInBytes < Instrumentation.mavlinkEncodedLength) {
      var len = Instrumentation.mavlinkEncodedLength - data_.lengthInBytes;
      var d =
          data_.buffer.asUint8List().sublist(0, data_.lengthInBytes) +
          List<int>.filled(len, 0);
      data_ = Uint8List.fromList(d).buffer.asByteData();
    }
    var timestampSeconds = data_.getUint32(0, Endian.little);
    var batteryCurrent = data_.getInt16(4, Endian.little);
    var motorCurrentLeft = data_.getInt16(6, Endian.little);
    var motorCurrentRight = data_.getInt16(8, Endian.little);
    var mpptCurrent = data_.getInt16(10, Endian.little);
    var auxiliaryBatteryCurrent = data_.getInt16(12, Endian.little);
    var batteryVoltage = data_.getUint16(14, Endian.little);
    var auxiliaryBatteryVoltage = data_.getUint16(16, Endian.little);
    var irradiance = data_.getUint16(18, Endian.little);
    var timestampMilliseconds = data_.getUint16(20, Endian.little);

    return Instrumentation(
      timestampSeconds: timestampSeconds,
      batteryCurrent: batteryCurrent,
      motorCurrentLeft: motorCurrentLeft,
      motorCurrentRight: motorCurrentRight,
      mpptCurrent: mpptCurrent,
      auxiliaryBatteryCurrent: auxiliaryBatteryCurrent,
      batteryVoltage: batteryVoltage,
      auxiliaryBatteryVoltage: auxiliaryBatteryVoltage,
      irradiance: irradiance,
      timestampMilliseconds: timestampMilliseconds,
    );
  }

  @override
  ByteData serialize() {
    var data_ = ByteData(mavlinkEncodedLength);
    data_.setUint32(0, timestampSeconds, Endian.little);
    data_.setInt16(4, batteryCurrent, Endian.little);
    data_.setInt16(6, motorCurrentLeft, Endian.little);
    data_.setInt16(8, motorCurrentRight, Endian.little);
    data_.setInt16(10, mpptCurrent, Endian.little);
    data_.setInt16(12, auxiliaryBatteryCurrent, Endian.little);
    data_.setUint16(14, batteryVoltage, Endian.little);
    data_.setUint16(16, auxiliaryBatteryVoltage, Endian.little);
    data_.setUint16(18, irradiance, Endian.little);
    data_.setUint16(20, timestampMilliseconds, Endian.little);
    return data_;
  }
}

/// Temperature data for motor and MPPT.
///
/// TEMPERATURES
class Temperatures implements MavlinkMessage {
  static const int _mavlinkMessageId = 2;

  static const int _mavlinkCrcExtra = 87;

  static const int mavlinkEncodedLength = 14;

  @override
  int get mavlinkMessageId => _mavlinkMessageId;

  @override
  int get mavlinkCrcExtra => _mavlinkCrcExtra;

  /// Seconds since Unix time
  ///
  /// MAVLink type: uint32_t
  ///
  /// timestamp_seconds
  final uint32_t timestampSeconds;

  /// Left side of battery pack
  ///
  /// MAVLink type: int16_t
  ///
  /// units: cdegC
  ///
  /// temperature_battery_left
  final int16_t temperatureBatteryLeft;

  /// Right side of battery pack
  ///
  /// MAVLink type: int16_t
  ///
  /// units: cdegC
  ///
  /// temperature_battery_right
  final int16_t temperatureBatteryRight;

  /// MPPT temperature on its left side.
  ///
  /// MAVLink type: int16_t
  ///
  /// units: cdegC
  ///
  /// temperature_mppt_left
  final int16_t temperatureMpptLeft;

  /// MPPT temperature on its left side.
  ///
  /// MAVLink type: int16_t
  ///
  /// units: cdegC
  ///
  /// temperature_mppt_right
  final int16_t temperatureMpptRight;

  /// Milliseconds within Unix time
  ///
  /// MAVLink type: uint16_t
  ///
  /// timestamp_milliseconds
  final uint16_t timestampMilliseconds;

  Temperatures({
    required this.timestampSeconds,
    required this.temperatureBatteryLeft,
    required this.temperatureBatteryRight,
    required this.temperatureMpptLeft,
    required this.temperatureMpptRight,
    required this.timestampMilliseconds,
  });

  Temperatures copyWith({
    uint32_t? timestampSeconds,
    int16_t? temperatureBatteryLeft,
    int16_t? temperatureBatteryRight,
    int16_t? temperatureMpptLeft,
    int16_t? temperatureMpptRight,
    uint16_t? timestampMilliseconds,
  }) {
    return Temperatures(
      timestampSeconds: timestampSeconds ?? this.timestampSeconds,
      temperatureBatteryLeft:
          temperatureBatteryLeft ?? this.temperatureBatteryLeft,
      temperatureBatteryRight:
          temperatureBatteryRight ?? this.temperatureBatteryRight,
      temperatureMpptLeft: temperatureMpptLeft ?? this.temperatureMpptLeft,
      temperatureMpptRight: temperatureMpptRight ?? this.temperatureMpptRight,
      timestampMilliseconds:
          timestampMilliseconds ?? this.timestampMilliseconds,
    );
  }

  factory Temperatures.parse(ByteData data_) {
    if (data_.lengthInBytes < Temperatures.mavlinkEncodedLength) {
      var len = Temperatures.mavlinkEncodedLength - data_.lengthInBytes;
      var d =
          data_.buffer.asUint8List().sublist(0, data_.lengthInBytes) +
          List<int>.filled(len, 0);
      data_ = Uint8List.fromList(d).buffer.asByteData();
    }
    var timestampSeconds = data_.getUint32(0, Endian.little);
    var temperatureBatteryLeft = data_.getInt16(4, Endian.little);
    var temperatureBatteryRight = data_.getInt16(6, Endian.little);
    var temperatureMpptLeft = data_.getInt16(8, Endian.little);
    var temperatureMpptRight = data_.getInt16(10, Endian.little);
    var timestampMilliseconds = data_.getUint16(12, Endian.little);

    return Temperatures(
      timestampSeconds: timestampSeconds,
      temperatureBatteryLeft: temperatureBatteryLeft,
      temperatureBatteryRight: temperatureBatteryRight,
      temperatureMpptLeft: temperatureMpptLeft,
      temperatureMpptRight: temperatureMpptRight,
      timestampMilliseconds: timestampMilliseconds,
    );
  }

  @override
  ByteData serialize() {
    var data_ = ByteData(mavlinkEncodedLength);
    data_.setUint32(0, timestampSeconds, Endian.little);
    data_.setInt16(4, temperatureBatteryLeft, Endian.little);
    data_.setInt16(6, temperatureBatteryRight, Endian.little);
    data_.setInt16(8, temperatureMpptLeft, Endian.little);
    data_.setInt16(10, temperatureMpptRight, Endian.little);
    data_.setUint16(12, timestampMilliseconds, Endian.little);
    return data_;
  }
}

///
///
/// GPS
class Gps implements MavlinkMessage {
  static const int _mavlinkMessageId = 3;

  static const int _mavlinkCrcExtra = 37;

  static const int mavlinkEncodedLength = 20;

  @override
  int get mavlinkMessageId => _mavlinkMessageId;

  @override
  int get mavlinkCrcExtra => _mavlinkCrcExtra;

  ///
  ///
  /// MAVLink type: int32_t
  ///
  /// units: degE7
  ///
  /// latitude
  final int32_t latitude;

  ///
  ///
  /// MAVLink type: int32_t
  ///
  /// units: degE7
  ///
  /// longitude
  final int32_t longitude;

  /// Seconds since Unix time
  ///
  /// MAVLink type: uint32_t
  ///
  /// timestamp_seconds
  final uint32_t timestampSeconds;

  ///
  ///
  /// MAVLink type: uint16_t
  ///
  /// units: cm/s
  ///
  /// speed
  final uint16_t speed;

  /// Milliseconds within Unix time
  ///
  /// MAVLink type: uint16_t
  ///
  /// timestamp_milliseconds
  final uint16_t timestampMilliseconds;

  /// Direction of movement(not heading)
  ///
  /// MAVLink type: uint8_t
  ///
  /// units: deg
  ///
  /// course
  final uint8_t course;

  /// Direction of the bow (source not from GPS, but from IMU)
  ///
  /// MAVLink type: uint8_t
  ///
  /// units: deg
  ///
  /// heading
  final uint8_t heading;

  ///
  ///
  /// MAVLink type: uint8_t
  ///
  /// satellites_visible
  final uint8_t satellitesVisible;

  /// Horizontal dilution of precision. Represents quality of GPS constellation. Values close to 1 are best. Above 5 is poor
  ///
  /// MAVLink type: uint8_t
  ///
  /// hdop
  final uint8_t hdop;

  Gps({
    required this.latitude,
    required this.longitude,
    required this.timestampSeconds,
    required this.speed,
    required this.timestampMilliseconds,
    required this.course,
    required this.heading,
    required this.satellitesVisible,
    required this.hdop,
  });

  Gps copyWith({
    int32_t? latitude,
    int32_t? longitude,
    uint32_t? timestampSeconds,
    uint16_t? speed,
    uint16_t? timestampMilliseconds,
    uint8_t? course,
    uint8_t? heading,
    uint8_t? satellitesVisible,
    uint8_t? hdop,
  }) {
    return Gps(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      timestampSeconds: timestampSeconds ?? this.timestampSeconds,
      speed: speed ?? this.speed,
      timestampMilliseconds:
          timestampMilliseconds ?? this.timestampMilliseconds,
      course: course ?? this.course,
      heading: heading ?? this.heading,
      satellitesVisible: satellitesVisible ?? this.satellitesVisible,
      hdop: hdop ?? this.hdop,
    );
  }

  factory Gps.parse(ByteData data_) {
    if (data_.lengthInBytes < Gps.mavlinkEncodedLength) {
      var len = Gps.mavlinkEncodedLength - data_.lengthInBytes;
      var d =
          data_.buffer.asUint8List().sublist(0, data_.lengthInBytes) +
          List<int>.filled(len, 0);
      data_ = Uint8List.fromList(d).buffer.asByteData();
    }
    var latitude = data_.getInt32(0, Endian.little);
    var longitude = data_.getInt32(4, Endian.little);
    var timestampSeconds = data_.getUint32(8, Endian.little);
    var speed = data_.getUint16(12, Endian.little);
    var timestampMilliseconds = data_.getUint16(14, Endian.little);
    var course = data_.getUint8(16);
    var heading = data_.getUint8(17);
    var satellitesVisible = data_.getUint8(18);
    var hdop = data_.getUint8(19);

    return Gps(
      latitude: latitude,
      longitude: longitude,
      timestampSeconds: timestampSeconds,
      speed: speed,
      timestampMilliseconds: timestampMilliseconds,
      course: course,
      heading: heading,
      satellitesVisible: satellitesVisible,
      hdop: hdop,
    );
  }

  @override
  ByteData serialize() {
    var data_ = ByteData(mavlinkEncodedLength);
    data_.setInt32(0, latitude, Endian.little);
    data_.setInt32(4, longitude, Endian.little);
    data_.setUint32(8, timestampSeconds, Endian.little);
    data_.setUint16(12, speed, Endian.little);
    data_.setUint16(14, timestampMilliseconds, Endian.little);
    data_.setUint8(16, course);
    data_.setUint8(17, heading);
    data_.setUint8(18, satellitesVisible);
    data_.setUint8(19, hdop);
    return data_;
  }
}

/// MPPT data fields
///
/// MPPT
class Mppt implements MavlinkMessage {
  static const int _mavlinkMessageId = 4;

  static const int _mavlinkCrcExtra = 26;

  static const int mavlinkEncodedLength = 14;

  @override
  int get mavlinkMessageId => _mavlinkMessageId;

  @override
  int get mavlinkCrcExtra => _mavlinkCrcExtra;

  /// Seconds since Unix time
  ///
  /// MAVLink type: uint32_t
  ///
  /// timestamp_seconds
  final uint32_t timestampSeconds;

  /// Solar array voltage,ID=3100
  ///
  /// MAVLink type: uint16_t
  ///
  /// units: cV
  ///
  /// pv_voltage
  final uint16_t pvVoltage;

  /// Solar array current,ID=3101
  ///
  /// MAVLink type: int16_t
  ///
  /// units: cV
  ///
  /// pv_current
  final int16_t pvCurrent;

  /// Battery voltage,ID=3104
  ///
  /// MAVLink type: uint16_t
  ///
  /// units: cV
  ///
  /// battery_voltage
  final uint16_t batteryVoltage;

  /// Net battery current(positive=charging),ID=331B
  ///
  /// MAVLink type: int16_t
  ///
  /// units: cA
  ///
  /// battery_current
  final int16_t batteryCurrent;

  /// Milliseconds within Unix time
  ///
  /// MAVLink type: uint16_t
  ///
  /// timestamp_milliseconds
  final uint16_t timestampMilliseconds;

  Mppt({
    required this.timestampSeconds,
    required this.pvVoltage,
    required this.pvCurrent,
    required this.batteryVoltage,
    required this.batteryCurrent,
    required this.timestampMilliseconds,
  });

  Mppt copyWith({
    uint32_t? timestampSeconds,
    uint16_t? pvVoltage,
    int16_t? pvCurrent,
    uint16_t? batteryVoltage,
    int16_t? batteryCurrent,
    uint16_t? timestampMilliseconds,
  }) {
    return Mppt(
      timestampSeconds: timestampSeconds ?? this.timestampSeconds,
      pvVoltage: pvVoltage ?? this.pvVoltage,
      pvCurrent: pvCurrent ?? this.pvCurrent,
      batteryVoltage: batteryVoltage ?? this.batteryVoltage,
      batteryCurrent: batteryCurrent ?? this.batteryCurrent,
      timestampMilliseconds:
          timestampMilliseconds ?? this.timestampMilliseconds,
    );
  }

  factory Mppt.parse(ByteData data_) {
    if (data_.lengthInBytes < Mppt.mavlinkEncodedLength) {
      var len = Mppt.mavlinkEncodedLength - data_.lengthInBytes;
      var d =
          data_.buffer.asUint8List().sublist(0, data_.lengthInBytes) +
          List<int>.filled(len, 0);
      data_ = Uint8List.fromList(d).buffer.asByteData();
    }
    var timestampSeconds = data_.getUint32(0, Endian.little);
    var pvVoltage = data_.getUint16(4, Endian.little);
    var pvCurrent = data_.getInt16(6, Endian.little);
    var batteryVoltage = data_.getUint16(8, Endian.little);
    var batteryCurrent = data_.getInt16(10, Endian.little);
    var timestampMilliseconds = data_.getUint16(12, Endian.little);

    return Mppt(
      timestampSeconds: timestampSeconds,
      pvVoltage: pvVoltage,
      pvCurrent: pvCurrent,
      batteryVoltage: batteryVoltage,
      batteryCurrent: batteryCurrent,
      timestampMilliseconds: timestampMilliseconds,
    );
  }

  @override
  ByteData serialize() {
    var data_ = ByteData(mavlinkEncodedLength);
    data_.setUint32(0, timestampSeconds, Endian.little);
    data_.setUint16(4, pvVoltage, Endian.little);
    data_.setInt16(6, pvCurrent, Endian.little);
    data_.setUint16(8, batteryVoltage, Endian.little);
    data_.setInt16(10, batteryCurrent, Endian.little);
    data_.setUint16(12, timestampMilliseconds, Endian.little);
    return data_;
  }
}

/// MPPT error codes
///
/// MPPT_STATE
class MpptState implements MavlinkMessage {
  static const int _mavlinkMessageId = 5;

  static const int _mavlinkCrcExtra = 40;

  static const int mavlinkEncodedLength = 10;

  @override
  int get mavlinkMessageId => _mavlinkMessageId;

  @override
  int get mavlinkCrcExtra => _mavlinkCrcExtra;

  /// Seconds since Unix time
  ///
  /// MAVLink type: uint32_t
  ///
  /// timestamp_seconds
  final uint32_t timestampSeconds;

  /// Status of the battery,ID=3200.
  ///
  /// MAVLink type: uint16_t
  ///
  /// enum: [MpptBatteryStatus]
  ///
  /// battery_status
  final MpptBatteryStatus batteryStatus;

  /// Status of the MPPT,ID=3201.
  ///
  /// MAVLink type: uint16_t
  ///
  /// enum: [MpptChargingEquipmentStatus]
  ///
  /// charging_equipment_status
  final MpptChargingEquipmentStatus chargingEquipmentStatus;

  /// Milliseconds within Unix time
  ///
  /// MAVLink type: uint16_t
  ///
  /// timestamp_milliseconds
  final uint16_t timestampMilliseconds;

  MpptState({
    required this.timestampSeconds,
    required this.batteryStatus,
    required this.chargingEquipmentStatus,
    required this.timestampMilliseconds,
  });

  MpptState copyWith({
    uint32_t? timestampSeconds,
    MpptBatteryStatus? batteryStatus,
    MpptChargingEquipmentStatus? chargingEquipmentStatus,
    uint16_t? timestampMilliseconds,
  }) {
    return MpptState(
      timestampSeconds: timestampSeconds ?? this.timestampSeconds,
      batteryStatus: batteryStatus ?? this.batteryStatus,
      chargingEquipmentStatus:
          chargingEquipmentStatus ?? this.chargingEquipmentStatus,
      timestampMilliseconds:
          timestampMilliseconds ?? this.timestampMilliseconds,
    );
  }

  factory MpptState.parse(ByteData data_) {
    if (data_.lengthInBytes < MpptState.mavlinkEncodedLength) {
      var len = MpptState.mavlinkEncodedLength - data_.lengthInBytes;
      var d =
          data_.buffer.asUint8List().sublist(0, data_.lengthInBytes) +
          List<int>.filled(len, 0);
      data_ = Uint8List.fromList(d).buffer.asByteData();
    }
    var timestampSeconds = data_.getUint32(0, Endian.little);
    var batteryStatus = data_.getUint16(4, Endian.little);
    var chargingEquipmentStatus = data_.getUint16(6, Endian.little);
    var timestampMilliseconds = data_.getUint16(8, Endian.little);

    return MpptState(
      timestampSeconds: timestampSeconds,
      batteryStatus: batteryStatus,
      chargingEquipmentStatus: chargingEquipmentStatus,
      timestampMilliseconds: timestampMilliseconds,
    );
  }

  @override
  ByteData serialize() {
    var data_ = ByteData(mavlinkEncodedLength);
    data_.setUint32(0, timestampSeconds, Endian.little);
    data_.setUint16(4, batteryStatus, Endian.little);
    data_.setUint16(6, chargingEquipmentStatus, Endian.little);
    data_.setUint16(8, timestampMilliseconds, Endian.little);
    return data_;
  }
}

/// Battery information.
///
/// BMS
class Bms implements MavlinkMessage {
  static const int _mavlinkMessageId = 6;

  static const int _mavlinkCrcExtra = 65;

  static const int mavlinkEncodedLength = 45;

  @override
  int get mavlinkMessageId => _mavlinkMessageId;

  @override
  int get mavlinkCrcExtra => _mavlinkCrcExtra;

  /// Seconds since Unix time
  ///
  /// MAVLink type: uint32_t
  ///
  /// timestamp_seconds
  final uint32_t timestampSeconds;

  /// Voltage of each cell.
  ///
  /// MAVLink type: uint16_t[16]
  ///
  /// units: mV
  ///
  /// voltages
  final List<int16_t> voltages;

  /// Temperature of the battery
  ///
  /// MAVLink type: int16_t[2]
  ///
  /// units: cdegC
  ///
  /// temperatures
  final List<int16_t> temperatures;

  /// Battery current
  ///
  /// MAVLink type: int16_t
  ///
  /// units: dA
  ///
  /// current_battery
  final int16_t currentBattery;

  /// Milliseconds within Unix time
  ///
  /// MAVLink type: uint16_t
  ///
  /// timestamp_milliseconds
  final uint16_t timestampMilliseconds;

  /// Remaining battery energy. Values: [0-100]
  ///
  /// MAVLink type: int8_t
  ///
  /// units: %
  ///
  /// state_of_charge
  final int8_t stateOfCharge;

  Bms({
    required this.timestampSeconds,
    required this.voltages,
    required this.temperatures,
    required this.currentBattery,
    required this.timestampMilliseconds,
    required this.stateOfCharge,
  });

  Bms copyWith({
    uint32_t? timestampSeconds,
    List<int16_t>? voltages,
    List<int16_t>? temperatures,
    int16_t? currentBattery,
    uint16_t? timestampMilliseconds,
    int8_t? stateOfCharge,
  }) {
    return Bms(
      timestampSeconds: timestampSeconds ?? this.timestampSeconds,
      voltages: voltages ?? this.voltages,
      temperatures: temperatures ?? this.temperatures,
      currentBattery: currentBattery ?? this.currentBattery,
      timestampMilliseconds:
          timestampMilliseconds ?? this.timestampMilliseconds,
      stateOfCharge: stateOfCharge ?? this.stateOfCharge,
    );
  }

  factory Bms.parse(ByteData data_) {
    if (data_.lengthInBytes < Bms.mavlinkEncodedLength) {
      var len = Bms.mavlinkEncodedLength - data_.lengthInBytes;
      var d =
          data_.buffer.asUint8List().sublist(0, data_.lengthInBytes) +
          List<int>.filled(len, 0);
      data_ = Uint8List.fromList(d).buffer.asByteData();
    }
    var timestampSeconds = data_.getUint32(0, Endian.little);
    var voltages = MavlinkMessage.asUint16List(data_, 4, 16);
    var temperatures = MavlinkMessage.asInt16List(data_, 36, 2);
    var currentBattery = data_.getInt16(40, Endian.little);
    var timestampMilliseconds = data_.getUint16(42, Endian.little);
    var stateOfCharge = data_.getInt8(44);

    return Bms(
      timestampSeconds: timestampSeconds,
      voltages: voltages,
      temperatures: temperatures,
      currentBattery: currentBattery,
      timestampMilliseconds: timestampMilliseconds,
      stateOfCharge: stateOfCharge,
    );
  }

  @override
  ByteData serialize() {
    var data_ = ByteData(mavlinkEncodedLength);
    data_.setUint32(0, timestampSeconds, Endian.little);
    MavlinkMessage.setUint16List(data_, 4, voltages);
    MavlinkMessage.setInt16List(data_, 36, temperatures);
    data_.setInt16(40, currentBattery, Endian.little);
    data_.setUint16(42, timestampMilliseconds, Endian.little);
    data_.setInt8(44, stateOfCharge);
    return data_;
  }
}

///
/// Daly BMS battery failure status (corresponds to original message 0x98).
/// Contains multiple bytes of failure flags and a final fault code.
/// Also includes temperatures and status bitfield of the battery management system (FET states, stationary, charging or discharging)
///
///
/// BMS_STATUS
class BmsStatus implements MavlinkMessage {
  static const int _mavlinkMessageId = 7;

  static const int _mavlinkCrcExtra = 161;

  static const int mavlinkEncodedLength = 19;

  @override
  int get mavlinkMessageId => _mavlinkMessageId;

  @override
  int get mavlinkCrcExtra => _mavlinkCrcExtra;

  /// Seconds since Unix time
  ///
  /// MAVLink type: uint32_t
  ///
  /// timestamp_seconds
  final uint32_t timestampSeconds;

  /// Temperature of the battery
  ///
  /// MAVLink type: int16_t[2]
  ///
  /// units: cdegC
  ///
  /// temperatures
  final List<int16_t> temperatures;

  /// Milliseconds within Unix time
  ///
  /// MAVLink type: uint16_t
  ///
  /// timestamp_milliseconds
  final uint16_t timestampMilliseconds;

  /// Charge/Discharge FET status and current charging status
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [BmsChargeDischargeStatusFlags]
  ///
  /// status
  final BmsChargeDischargeStatusFlags status;

  /// Failure flags: Voltage related (Byte 0).
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [DalyFailureByte0VoltageFlags]
  ///
  /// failure_flags_byte0
  final DalyFailureByte0VoltageFlags failureFlagsByte0;

  /// Failure flags: Temperature related (Byte 1).
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [DalyFailureByte1TempFlags]
  ///
  /// failure_flags_byte1
  final DalyFailureByte1TempFlags failureFlagsByte1;

  /// Failure flags: Current and SOC related (Byte 2).
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [DalyFailureByte2CurrentSocFlags]
  ///
  /// failure_flags_byte2
  final DalyFailureByte2CurrentSocFlags failureFlagsByte2;

  /// Failure flags: Differential V/T related (Byte 3).
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [DalyFailureByte3DifferentialFlags]
  ///
  /// failure_flags_byte3
  final DalyFailureByte3DifferentialFlags failureFlagsByte3;

  /// Failure flags: MOSFET and sensor related (Byte 4).
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [DalyFailureByte4MosfetSensorFlags]
  ///
  /// failure_flags_byte4
  final DalyFailureByte4MosfetSensorFlags failureFlagsByte4;

  /// Failure flags: System/Component related (Byte 5).
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [DalyFailureByte5SystemComponentFlags]
  ///
  /// failure_flags_byte5
  final DalyFailureByte5SystemComponentFlags failureFlagsByte5;

  /// Failure flags: Other faults (Byte 6).
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [DalyFailureByte6OtherFaultsFlags]
  ///
  /// failure_flags_byte6
  final DalyFailureByte6OtherFaultsFlags failureFlagsByte6;

  /// Raw fault code (Byte 7 from original message).
  ///
  /// MAVLink type: uint8_t
  ///
  /// fault_code_byte7
  final uint8_t faultCodeByte7;

  BmsStatus({
    required this.timestampSeconds,
    required this.temperatures,
    required this.timestampMilliseconds,
    required this.status,
    required this.failureFlagsByte0,
    required this.failureFlagsByte1,
    required this.failureFlagsByte2,
    required this.failureFlagsByte3,
    required this.failureFlagsByte4,
    required this.failureFlagsByte5,
    required this.failureFlagsByte6,
    required this.faultCodeByte7,
  });

  BmsStatus copyWith({
    uint32_t? timestampSeconds,
    List<int16_t>? temperatures,
    uint16_t? timestampMilliseconds,
    BmsChargeDischargeStatusFlags? status,
    DalyFailureByte0VoltageFlags? failureFlagsByte0,
    DalyFailureByte1TempFlags? failureFlagsByte1,
    DalyFailureByte2CurrentSocFlags? failureFlagsByte2,
    DalyFailureByte3DifferentialFlags? failureFlagsByte3,
    DalyFailureByte4MosfetSensorFlags? failureFlagsByte4,
    DalyFailureByte5SystemComponentFlags? failureFlagsByte5,
    DalyFailureByte6OtherFaultsFlags? failureFlagsByte6,
    uint8_t? faultCodeByte7,
  }) {
    return BmsStatus(
      timestampSeconds: timestampSeconds ?? this.timestampSeconds,
      temperatures: temperatures ?? this.temperatures,
      timestampMilliseconds:
          timestampMilliseconds ?? this.timestampMilliseconds,
      status: status ?? this.status,
      failureFlagsByte0: failureFlagsByte0 ?? this.failureFlagsByte0,
      failureFlagsByte1: failureFlagsByte1 ?? this.failureFlagsByte1,
      failureFlagsByte2: failureFlagsByte2 ?? this.failureFlagsByte2,
      failureFlagsByte3: failureFlagsByte3 ?? this.failureFlagsByte3,
      failureFlagsByte4: failureFlagsByte4 ?? this.failureFlagsByte4,
      failureFlagsByte5: failureFlagsByte5 ?? this.failureFlagsByte5,
      failureFlagsByte6: failureFlagsByte6 ?? this.failureFlagsByte6,
      faultCodeByte7: faultCodeByte7 ?? this.faultCodeByte7,
    );
  }

  factory BmsStatus.parse(ByteData data_) {
    if (data_.lengthInBytes < BmsStatus.mavlinkEncodedLength) {
      var len = BmsStatus.mavlinkEncodedLength - data_.lengthInBytes;
      var d =
          data_.buffer.asUint8List().sublist(0, data_.lengthInBytes) +
          List<int>.filled(len, 0);
      data_ = Uint8List.fromList(d).buffer.asByteData();
    }
    var timestampSeconds = data_.getUint32(0, Endian.little);
    var temperatures = MavlinkMessage.asInt16List(data_, 4, 2);
    var timestampMilliseconds = data_.getUint16(8, Endian.little);
    var status = data_.getUint8(10);
    var failureFlagsByte0 = data_.getUint8(11);
    var failureFlagsByte1 = data_.getUint8(12);
    var failureFlagsByte2 = data_.getUint8(13);
    var failureFlagsByte3 = data_.getUint8(14);
    var failureFlagsByte4 = data_.getUint8(15);
    var failureFlagsByte5 = data_.getUint8(16);
    var failureFlagsByte6 = data_.getUint8(17);
    var faultCodeByte7 = data_.getUint8(18);

    return BmsStatus(
      timestampSeconds: timestampSeconds,
      temperatures: temperatures,
      timestampMilliseconds: timestampMilliseconds,
      status: status,
      failureFlagsByte0: failureFlagsByte0,
      failureFlagsByte1: failureFlagsByte1,
      failureFlagsByte2: failureFlagsByte2,
      failureFlagsByte3: failureFlagsByte3,
      failureFlagsByte4: failureFlagsByte4,
      failureFlagsByte5: failureFlagsByte5,
      failureFlagsByte6: failureFlagsByte6,
      faultCodeByte7: faultCodeByte7,
    );
  }

  @override
  ByteData serialize() {
    var data_ = ByteData(mavlinkEncodedLength);
    data_.setUint32(0, timestampSeconds, Endian.little);
    MavlinkMessage.setInt16List(data_, 4, temperatures);
    data_.setUint16(8, timestampMilliseconds, Endian.little);
    data_.setUint8(10, status);
    data_.setUint8(11, failureFlagsByte0);
    data_.setUint8(12, failureFlagsByte1);
    data_.setUint8(13, failureFlagsByte2);
    data_.setUint8(14, failureFlagsByte3);
    data_.setUint8(15, failureFlagsByte4);
    data_.setUint8(16, failureFlagsByte5);
    data_.setUint8(17, failureFlagsByte6);
    data_.setUint8(18, faultCodeByte7);
    return data_;
  }
}

///
/// Electrical data from EZkontrol ESC based on CAN Message I, including accelerator opening for higher frequency publishing.
/// Phase current is excluded because it updates too rapidly for low bandwidth links
///
///
/// EZKONTROL_MCU_METER_DATA_I
class EzkontrolMcuMeterDataI implements MavlinkMessage {
  static const int _mavlinkMessageId = 8;

  static const int _mavlinkCrcExtra = 194;

  static const int mavlinkEncodedLength = 14;

  @override
  int get mavlinkMessageId => _mavlinkMessageId;

  @override
  int get mavlinkCrcExtra => _mavlinkCrcExtra;

  /// Seconds since Unix time
  ///
  /// MAVLink type: uint32_t
  ///
  /// timestamp_seconds
  final uint32_t timestampSeconds;

  /// 0.1V/bit, offset= 0
  ///
  /// MAVLink type: uint16_t
  ///
  /// units: dV
  ///
  /// bus_voltage
  final uint16_t busVoltage;

  /// 0.1A/bit, offset= -32000
  ///
  /// MAVLink type: int16_t
  ///
  /// units: dA
  ///
  /// bus_current
  final int16_t busCurrent;

  /// 0.1rpm/bit, offset= -32000
  ///
  /// MAVLink type: int16_t
  ///
  /// units: drpm/bit
  ///
  /// rpm
  final int16_t rpm;

  /// Milliseconds within Unix time
  ///
  /// MAVLink type: uint16_t
  ///
  /// timestamp_milliseconds
  final uint16_t timestampMilliseconds;

  /// 1%/bit, throttle signal
  ///
  /// MAVLink type: uint8_t
  ///
  /// accelerator_opening
  final uint8_t acceleratorOpening;

  /// 0 for left motor, 1 for right motor
  ///
  /// MAVLink type: uint8_t
  ///
  /// instance
  final uint8_t instance;

  EzkontrolMcuMeterDataI({
    required this.timestampSeconds,
    required this.busVoltage,
    required this.busCurrent,
    required this.rpm,
    required this.timestampMilliseconds,
    required this.acceleratorOpening,
    required this.instance,
  });

  EzkontrolMcuMeterDataI copyWith({
    uint32_t? timestampSeconds,
    uint16_t? busVoltage,
    int16_t? busCurrent,
    int16_t? rpm,
    uint16_t? timestampMilliseconds,
    uint8_t? acceleratorOpening,
    uint8_t? instance,
  }) {
    return EzkontrolMcuMeterDataI(
      timestampSeconds: timestampSeconds ?? this.timestampSeconds,
      busVoltage: busVoltage ?? this.busVoltage,
      busCurrent: busCurrent ?? this.busCurrent,
      rpm: rpm ?? this.rpm,
      timestampMilliseconds:
          timestampMilliseconds ?? this.timestampMilliseconds,
      acceleratorOpening: acceleratorOpening ?? this.acceleratorOpening,
      instance: instance ?? this.instance,
    );
  }

  factory EzkontrolMcuMeterDataI.parse(ByteData data_) {
    if (data_.lengthInBytes < EzkontrolMcuMeterDataI.mavlinkEncodedLength) {
      var len =
          EzkontrolMcuMeterDataI.mavlinkEncodedLength - data_.lengthInBytes;
      var d =
          data_.buffer.asUint8List().sublist(0, data_.lengthInBytes) +
          List<int>.filled(len, 0);
      data_ = Uint8List.fromList(d).buffer.asByteData();
    }
    var timestampSeconds = data_.getUint32(0, Endian.little);
    var busVoltage = data_.getUint16(4, Endian.little);
    var busCurrent = data_.getInt16(6, Endian.little);
    var rpm = data_.getInt16(8, Endian.little);
    var timestampMilliseconds = data_.getUint16(10, Endian.little);
    var acceleratorOpening = data_.getUint8(12);
    var instance = data_.getUint8(13);

    return EzkontrolMcuMeterDataI(
      timestampSeconds: timestampSeconds,
      busVoltage: busVoltage,
      busCurrent: busCurrent,
      rpm: rpm,
      timestampMilliseconds: timestampMilliseconds,
      acceleratorOpening: acceleratorOpening,
      instance: instance,
    );
  }

  @override
  ByteData serialize() {
    var data_ = ByteData(mavlinkEncodedLength);
    data_.setUint32(0, timestampSeconds, Endian.little);
    data_.setUint16(4, busVoltage, Endian.little);
    data_.setInt16(6, busCurrent, Endian.little);
    data_.setInt16(8, rpm, Endian.little);
    data_.setUint16(10, timestampMilliseconds, Endian.little);
    data_.setUint8(12, acceleratorOpening);
    data_.setUint8(13, instance);
    return data_;
  }
}

/// Status data from EZkontrol ESC based on CAN Message II, excluding accelerator opening. Temperatures have an offset of -40 degrees Celsius.
///
/// EZKONTROL_MCU_METER_DATA_II
class EzkontrolMcuMeterDataIi implements MavlinkMessage {
  static const int _mavlinkMessageId = 9;

  static const int _mavlinkCrcExtra = 17;

  static const int mavlinkEncodedLength = 14;

  @override
  int get mavlinkMessageId => _mavlinkMessageId;

  @override
  int get mavlinkCrcExtra => _mavlinkCrcExtra;

  /// Seconds since Unix time
  ///
  /// MAVLink type: uint32_t
  ///
  /// timestamp_seconds
  final uint32_t timestampSeconds;

  /// Milliseconds within Unix time
  ///
  /// MAVLink type: uint16_t
  ///
  /// timestamp_milliseconds
  final uint16_t timestampMilliseconds;

  /// Controller temperature. Actual value = MAVLink value - 40. Unit: degC
  ///
  /// MAVLink type: int8_t
  ///
  /// controller_temperature
  final int8_t controllerTemperature;

  /// Motor temperature. Actual value = MAVLink value - 40. Unit: degC
  ///
  /// MAVLink type: int8_t
  ///
  /// motor_temperature
  final int8_t motorTemperature;

  /// Gear, brake, operation mode and DC contactor.
  ///
  /// MAVLink type: uint8_t
  ///
  /// status
  final uint8_t status;

  /// Error flags from Byte 4.
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [EzkontrolErrorByte4Flags]
  ///
  /// error_flags_byte4
  final EzkontrolErrorByte4Flags errorFlagsByte4;

  /// Error flags from Byte 5.
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [EzkontrolErrorByte5Flags]
  ///
  /// error_flags_byte5
  final EzkontrolErrorByte5Flags errorFlagsByte5;

  /// Error flags from Byte 6.
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [EzkontrolErrorByte6Flags]
  ///
  /// error_flags_byte6
  final EzkontrolErrorByte6Flags errorFlagsByte6;

  /// Life signal counter derived from bits 7-4 from byte 7, msg II.
  ///
  /// MAVLink type: uint8_t
  ///
  /// life_signal
  final uint8_t lifeSignal;

  /// 0 for left motor, 1 for right motor
  ///
  /// MAVLink type: uint8_t
  ///
  /// instance
  final uint8_t instance;

  EzkontrolMcuMeterDataIi({
    required this.timestampSeconds,
    required this.timestampMilliseconds,
    required this.controllerTemperature,
    required this.motorTemperature,
    required this.status,
    required this.errorFlagsByte4,
    required this.errorFlagsByte5,
    required this.errorFlagsByte6,
    required this.lifeSignal,
    required this.instance,
  });

  EzkontrolMcuMeterDataIi copyWith({
    uint32_t? timestampSeconds,
    uint16_t? timestampMilliseconds,
    int8_t? controllerTemperature,
    int8_t? motorTemperature,
    uint8_t? status,
    EzkontrolErrorByte4Flags? errorFlagsByte4,
    EzkontrolErrorByte5Flags? errorFlagsByte5,
    EzkontrolErrorByte6Flags? errorFlagsByte6,
    uint8_t? lifeSignal,
    uint8_t? instance,
  }) {
    return EzkontrolMcuMeterDataIi(
      timestampSeconds: timestampSeconds ?? this.timestampSeconds,
      timestampMilliseconds:
          timestampMilliseconds ?? this.timestampMilliseconds,
      controllerTemperature:
          controllerTemperature ?? this.controllerTemperature,
      motorTemperature: motorTemperature ?? this.motorTemperature,
      status: status ?? this.status,
      errorFlagsByte4: errorFlagsByte4 ?? this.errorFlagsByte4,
      errorFlagsByte5: errorFlagsByte5 ?? this.errorFlagsByte5,
      errorFlagsByte6: errorFlagsByte6 ?? this.errorFlagsByte6,
      lifeSignal: lifeSignal ?? this.lifeSignal,
      instance: instance ?? this.instance,
    );
  }

  factory EzkontrolMcuMeterDataIi.parse(ByteData data_) {
    if (data_.lengthInBytes < EzkontrolMcuMeterDataIi.mavlinkEncodedLength) {
      var len =
          EzkontrolMcuMeterDataIi.mavlinkEncodedLength - data_.lengthInBytes;
      var d =
          data_.buffer.asUint8List().sublist(0, data_.lengthInBytes) +
          List<int>.filled(len, 0);
      data_ = Uint8List.fromList(d).buffer.asByteData();
    }
    var timestampSeconds = data_.getUint32(0, Endian.little);
    var timestampMilliseconds = data_.getUint16(4, Endian.little);
    var controllerTemperature = data_.getInt8(6);
    var motorTemperature = data_.getInt8(7);
    var status = data_.getUint8(8);
    var errorFlagsByte4 = data_.getUint8(9);
    var errorFlagsByte5 = data_.getUint8(10);
    var errorFlagsByte6 = data_.getUint8(11);
    var lifeSignal = data_.getUint8(12);
    var instance = data_.getUint8(13);

    return EzkontrolMcuMeterDataIi(
      timestampSeconds: timestampSeconds,
      timestampMilliseconds: timestampMilliseconds,
      controllerTemperature: controllerTemperature,
      motorTemperature: motorTemperature,
      status: status,
      errorFlagsByte4: errorFlagsByte4,
      errorFlagsByte5: errorFlagsByte5,
      errorFlagsByte6: errorFlagsByte6,
      lifeSignal: lifeSignal,
      instance: instance,
    );
  }

  @override
  ByteData serialize() {
    var data_ = ByteData(mavlinkEncodedLength);
    data_.setUint32(0, timestampSeconds, Endian.little);
    data_.setUint16(4, timestampMilliseconds, Endian.little);
    data_.setInt8(6, controllerTemperature);
    data_.setInt8(7, motorTemperature);
    data_.setUint8(8, status);
    data_.setUint8(9, errorFlagsByte4);
    data_.setUint8(10, errorFlagsByte5);
    data_.setUint8(11, errorFlagsByte6);
    data_.setUint8(12, lifeSignal);
    data_.setUint8(13, instance);
    return data_;
  }
}

/// State of bilge pumps.
///
/// PUMPS
class Pumps implements MavlinkMessage {
  static const int _mavlinkMessageId = 10;

  static const int _mavlinkCrcExtra = 246;

  static const int mavlinkEncodedLength = 7;

  @override
  int get mavlinkMessageId => _mavlinkMessageId;

  @override
  int get mavlinkCrcExtra => _mavlinkCrcExtra;

  /// Seconds since Unix time
  ///
  /// MAVLink type: uint32_t
  ///
  /// timestamp_seconds
  final uint32_t timestampSeconds;

  /// Milliseconds within Unix time
  ///
  /// MAVLink type: uint16_t
  ///
  /// timestamp_milliseconds
  final uint16_t timestampMilliseconds;

  /// Bitmask of pump states. Bit 0: Pump Left, Bit 1: Pump Right
  ///
  /// MAVLink type: uint8_t
  ///
  /// pump_states
  final uint8_t pumpStates;

  Pumps({
    required this.timestampSeconds,
    required this.timestampMilliseconds,
    required this.pumpStates,
  });

  Pumps copyWith({
    uint32_t? timestampSeconds,
    uint16_t? timestampMilliseconds,
    uint8_t? pumpStates,
  }) {
    return Pumps(
      timestampSeconds: timestampSeconds ?? this.timestampSeconds,
      timestampMilliseconds:
          timestampMilliseconds ?? this.timestampMilliseconds,
      pumpStates: pumpStates ?? this.pumpStates,
    );
  }

  factory Pumps.parse(ByteData data_) {
    if (data_.lengthInBytes < Pumps.mavlinkEncodedLength) {
      var len = Pumps.mavlinkEncodedLength - data_.lengthInBytes;
      var d =
          data_.buffer.asUint8List().sublist(0, data_.lengthInBytes) +
          List<int>.filled(len, 0);
      data_ = Uint8List.fromList(d).buffer.asByteData();
    }
    var timestampSeconds = data_.getUint32(0, Endian.little);
    var timestampMilliseconds = data_.getUint16(4, Endian.little);
    var pumpStates = data_.getUint8(6);

    return Pumps(
      timestampSeconds: timestampSeconds,
      timestampMilliseconds: timestampMilliseconds,
      pumpStates: pumpStates,
    );
  }

  @override
  ByteData serialize() {
    var data_ = ByteData(mavlinkEncodedLength);
    data_.setUint32(0, timestampSeconds, Endian.little);
    data_.setUint16(4, timestampMilliseconds, Endian.little);
    data_.setUint8(6, pumpStates);
    return data_;
  }
}

/// Request to read the onboard parameter with the param_id string id. Onboard parameters are stored as key[const char*] -> value[float]. This allows to send a parameter to any other component (such as the GCS) without the need of previous knowledge of possible parameter names. Thus the same GCS can store different parameters for different autopilots. See also https://mavlink.io/en/services/parameter.html for a full documentation of QGroundControl and IMU code.
///
/// PARAM_REQUEST_READ
class ParamRequestRead implements MavlinkMessage {
  static const int _mavlinkMessageId = 20;

  static const int _mavlinkCrcExtra = 151;

  static const int mavlinkEncodedLength = 18;

  @override
  int get mavlinkMessageId => _mavlinkMessageId;

  @override
  int get mavlinkCrcExtra => _mavlinkCrcExtra;

  /// Parameter index. Send -1 to use the param ID field as identifier (else the param id will be ignored)
  ///
  /// MAVLink type: int16_t
  ///
  /// param_index
  final int16_t paramIndex;

  /// Onboard parameter id, terminated by NULL if the length is less than 16 human-readable chars and WITHOUT null termination (NULL) byte if the length is exactly 16 chars - applications have to provide 16+1 bytes storage if the ID is stored as string
  ///
  /// MAVLink type: char[16]
  ///
  /// param_id
  final List<char> paramId;

  ParamRequestRead({required this.paramIndex, required this.paramId});

  ParamRequestRead copyWith({int16_t? paramIndex, List<char>? paramId}) {
    return ParamRequestRead(
      paramIndex: paramIndex ?? this.paramIndex,
      paramId: paramId ?? this.paramId,
    );
  }

  factory ParamRequestRead.parse(ByteData data_) {
    if (data_.lengthInBytes < ParamRequestRead.mavlinkEncodedLength) {
      var len = ParamRequestRead.mavlinkEncodedLength - data_.lengthInBytes;
      var d =
          data_.buffer.asUint8List().sublist(0, data_.lengthInBytes) +
          List<int>.filled(len, 0);
      data_ = Uint8List.fromList(d).buffer.asByteData();
    }
    var paramIndex = data_.getInt16(0, Endian.little);
    var paramId = MavlinkMessage.asInt8List(data_, 2, 16);

    return ParamRequestRead(paramIndex: paramIndex, paramId: paramId);
  }

  @override
  ByteData serialize() {
    var data_ = ByteData(mavlinkEncodedLength);
    data_.setInt16(0, paramIndex, Endian.little);
    MavlinkMessage.setInt8List(data_, 2, paramId);
    return data_;
  }
}

/// Emit the value of a onboard parameter. The inclusion of param_count and param_index in the message allows the recipient to keep track of received parameters and allows him to re-request missing parameters after a loss or timeout. The parameter microservice is documented at https://mavlink.io/en/services/parameter.html
///
/// PARAM_VALUE
class ParamValue implements MavlinkMessage {
  static const int _mavlinkMessageId = 22;

  static const int _mavlinkCrcExtra = 220;

  static const int mavlinkEncodedLength = 25;

  @override
  int get mavlinkMessageId => _mavlinkMessageId;

  @override
  int get mavlinkCrcExtra => _mavlinkCrcExtra;

  /// Onboard parameter value
  ///
  /// MAVLink type: float
  ///
  /// param_value
  final float paramValue;

  /// Total number of onboard parameters
  ///
  /// MAVLink type: uint16_t
  ///
  /// param_count
  final uint16_t paramCount;

  /// Index of this onboard parameter
  ///
  /// MAVLink type: uint16_t
  ///
  /// param_index
  final uint16_t paramIndex;

  /// Onboard parameter id, terminated by NULL if the length is less than 16 human-readable chars and WITHOUT null termination (NULL) byte if the length is exactly 16 chars - applications have to provide 16+1 bytes storage if the ID is stored as string
  ///
  /// MAVLink type: char[16]
  ///
  /// param_id
  final List<char> paramId;

  /// Onboard parameter type.
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [MavParamType]
  ///
  /// param_type
  final MavParamType paramType;

  ParamValue({
    required this.paramValue,
    required this.paramCount,
    required this.paramIndex,
    required this.paramId,
    required this.paramType,
  });

  ParamValue copyWith({
    float? paramValue,
    uint16_t? paramCount,
    uint16_t? paramIndex,
    List<char>? paramId,
    MavParamType? paramType,
  }) {
    return ParamValue(
      paramValue: paramValue ?? this.paramValue,
      paramCount: paramCount ?? this.paramCount,
      paramIndex: paramIndex ?? this.paramIndex,
      paramId: paramId ?? this.paramId,
      paramType: paramType ?? this.paramType,
    );
  }

  factory ParamValue.parse(ByteData data_) {
    if (data_.lengthInBytes < ParamValue.mavlinkEncodedLength) {
      var len = ParamValue.mavlinkEncodedLength - data_.lengthInBytes;
      var d =
          data_.buffer.asUint8List().sublist(0, data_.lengthInBytes) +
          List<int>.filled(len, 0);
      data_ = Uint8List.fromList(d).buffer.asByteData();
    }
    var paramValue = data_.getFloat32(0, Endian.little);
    var paramCount = data_.getUint16(4, Endian.little);
    var paramIndex = data_.getUint16(6, Endian.little);
    var paramId = MavlinkMessage.asInt8List(data_, 8, 16);
    var paramType = data_.getUint8(24);

    return ParamValue(
      paramValue: paramValue,
      paramCount: paramCount,
      paramIndex: paramIndex,
      paramId: paramId,
      paramType: paramType,
    );
  }

  @override
  ByteData serialize() {
    var data_ = ByteData(mavlinkEncodedLength);
    data_.setFloat32(0, paramValue, Endian.little);
    data_.setUint16(4, paramCount, Endian.little);
    data_.setUint16(6, paramIndex, Endian.little);
    MavlinkMessage.setInt8List(data_, 8, paramId);
    data_.setUint8(24, paramType);
    return data_;
  }
}

/// Set a parameter value (write new value to permanent storage).
/// The receiving component should acknowledge the new parameter value by broadcasting a PARAM_VALUE message (broadcasting ensures that multiple GCS all have an up-to-date list of all parameters). If the sending GCS did not receive a PARAM_VALUE within its timeout time, it should re-send the PARAM_SET message. The parameter microservice is documented at https://mavlink.io/en/services/parameter.html.
///
///
/// PARAM_SET
class ParamSet implements MavlinkMessage {
  static const int _mavlinkMessageId = 23;

  static const int _mavlinkCrcExtra = 22;

  static const int mavlinkEncodedLength = 21;

  @override
  int get mavlinkMessageId => _mavlinkMessageId;

  @override
  int get mavlinkCrcExtra => _mavlinkCrcExtra;

  /// Onboard parameter value
  ///
  /// MAVLink type: float
  ///
  /// param_value
  final float paramValue;

  /// Onboard parameter id, terminated by NULL if the length is less than 16 human-readable chars and WITHOUT null termination (NULL) byte if the length is exactly 16 chars - applications have to provide 16+1 bytes storage if the ID is stored as string
  ///
  /// MAVLink type: char[16]
  ///
  /// param_id
  final List<char> paramId;

  /// Onboard parameter type.
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [MavParamType]
  ///
  /// param_type
  final MavParamType paramType;

  ParamSet({
    required this.paramValue,
    required this.paramId,
    required this.paramType,
  });

  ParamSet copyWith({
    float? paramValue,
    List<char>? paramId,
    MavParamType? paramType,
  }) {
    return ParamSet(
      paramValue: paramValue ?? this.paramValue,
      paramId: paramId ?? this.paramId,
      paramType: paramType ?? this.paramType,
    );
  }

  factory ParamSet.parse(ByteData data_) {
    if (data_.lengthInBytes < ParamSet.mavlinkEncodedLength) {
      var len = ParamSet.mavlinkEncodedLength - data_.lengthInBytes;
      var d =
          data_.buffer.asUint8List().sublist(0, data_.lengthInBytes) +
          List<int>.filled(len, 0);
      data_ = Uint8List.fromList(d).buffer.asByteData();
    }
    var paramValue = data_.getFloat32(0, Endian.little);
    var paramId = MavlinkMessage.asInt8List(data_, 4, 16);
    var paramType = data_.getUint8(20);

    return ParamSet(
      paramValue: paramValue,
      paramId: paramId,
      paramType: paramType,
    );
  }

  @override
  ByteData serialize() {
    var data_ = ByteData(mavlinkEncodedLength);
    data_.setFloat32(0, paramValue, Endian.little);
    MavlinkMessage.setInt8List(data_, 4, paramId);
    data_.setUint8(20, paramType);
    return data_;
  }
}

/// Status generated by radio and injected into MAVLink stream.
///
/// RADIO_STATUS
class RadioStatus implements MavlinkMessage {
  static const int _mavlinkMessageId = 109;

  static const int _mavlinkCrcExtra = 44;

  static const int mavlinkEncodedLength = 10;

  @override
  int get mavlinkMessageId => _mavlinkMessageId;

  @override
  int get mavlinkCrcExtra => _mavlinkCrcExtra;

  /// Seconds since Unix time
  ///
  /// MAVLink type: uint32_t
  ///
  /// timestamp_seconds
  final uint32_t timestampSeconds;

  /// Count of radio packet receive errors (since boot).
  ///
  /// MAVLink type: uint16_t
  ///
  /// rxerrors
  final uint16_t rxerrors;

  /// Milliseconds within Unix time
  ///
  /// MAVLink type: uint16_t
  ///
  /// timestamp_milliseconds
  final uint16_t timestampMilliseconds;

  /// Radio instance, 0 for primary radio, 1 for secondary radio.
  ///
  /// MAVLink type: uint8_t
  ///
  /// instance
  final uint8_t instance;

  /// Local (message sender) received signal strength indication in device-dependent units/scale. Values: [0-254], UINT8_MAX: invalid/unknown.
  ///
  /// MAVLink type: uint8_t
  ///
  /// rssi
  final uint8_t rssi;

  RadioStatus({
    required this.timestampSeconds,
    required this.rxerrors,
    required this.timestampMilliseconds,
    required this.instance,
    required this.rssi,
  });

  RadioStatus copyWith({
    uint32_t? timestampSeconds,
    uint16_t? rxerrors,
    uint16_t? timestampMilliseconds,
    uint8_t? instance,
    uint8_t? rssi,
  }) {
    return RadioStatus(
      timestampSeconds: timestampSeconds ?? this.timestampSeconds,
      rxerrors: rxerrors ?? this.rxerrors,
      timestampMilliseconds:
          timestampMilliseconds ?? this.timestampMilliseconds,
      instance: instance ?? this.instance,
      rssi: rssi ?? this.rssi,
    );
  }

  factory RadioStatus.parse(ByteData data_) {
    if (data_.lengthInBytes < RadioStatus.mavlinkEncodedLength) {
      var len = RadioStatus.mavlinkEncodedLength - data_.lengthInBytes;
      var d =
          data_.buffer.asUint8List().sublist(0, data_.lengthInBytes) +
          List<int>.filled(len, 0);
      data_ = Uint8List.fromList(d).buffer.asByteData();
    }
    var timestampSeconds = data_.getUint32(0, Endian.little);
    var rxerrors = data_.getUint16(4, Endian.little);
    var timestampMilliseconds = data_.getUint16(6, Endian.little);
    var instance = data_.getUint8(8);
    var rssi = data_.getUint8(9);

    return RadioStatus(
      timestampSeconds: timestampSeconds,
      rxerrors: rxerrors,
      timestampMilliseconds: timestampMilliseconds,
      instance: instance,
      rssi: rssi,
    );
  }

  @override
  ByteData serialize() {
    var data_ = ByteData(mavlinkEncodedLength);
    data_.setUint32(0, timestampSeconds, Endian.little);
    data_.setUint16(4, rxerrors, Endian.little);
    data_.setUint16(6, timestampMilliseconds, Endian.little);
    data_.setUint8(8, instance);
    data_.setUint8(9, rssi);
    return data_;
  }
}

/// Send a key-value pair as float. The use of this message is discouraged for normal packets, but a quite efficient way for testing new messages and getting experimental debug output.
///
/// NAMED_VALUE_FLOAT
class NamedValueFloat implements MavlinkMessage {
  static const int _mavlinkMessageId = 251;

  static const int _mavlinkCrcExtra = 79;

  static const int mavlinkEncodedLength = 24;

  @override
  int get mavlinkMessageId => _mavlinkMessageId;

  @override
  int get mavlinkCrcExtra => _mavlinkCrcExtra;

  /// Timestamp (time since system boot).
  ///
  /// MAVLink type: uint32_t
  ///
  /// units: ms
  ///
  /// time_boot_ms
  final uint32_t timeBootMs;

  /// Floating point value
  ///
  /// MAVLink type: float
  ///
  /// value
  final float value;

  /// Seconds since Unix time
  ///
  /// MAVLink type: uint32_t
  ///
  /// timestamp_seconds
  final uint32_t timestampSeconds;

  /// Milliseconds within Unix time
  ///
  /// MAVLink type: uint16_t
  ///
  /// timestamp_milliseconds
  final uint16_t timestampMilliseconds;

  /// Name of the debug variable
  ///
  /// MAVLink type: char[10]
  ///
  /// name
  final List<char> name;

  NamedValueFloat({
    required this.timeBootMs,
    required this.value,
    required this.timestampSeconds,
    required this.timestampMilliseconds,
    required this.name,
  });

  NamedValueFloat copyWith({
    uint32_t? timeBootMs,
    float? value,
    uint32_t? timestampSeconds,
    uint16_t? timestampMilliseconds,
    List<char>? name,
  }) {
    return NamedValueFloat(
      timeBootMs: timeBootMs ?? this.timeBootMs,
      value: value ?? this.value,
      timestampSeconds: timestampSeconds ?? this.timestampSeconds,
      timestampMilliseconds:
          timestampMilliseconds ?? this.timestampMilliseconds,
      name: name ?? this.name,
    );
  }

  factory NamedValueFloat.parse(ByteData data_) {
    if (data_.lengthInBytes < NamedValueFloat.mavlinkEncodedLength) {
      var len = NamedValueFloat.mavlinkEncodedLength - data_.lengthInBytes;
      var d =
          data_.buffer.asUint8List().sublist(0, data_.lengthInBytes) +
          List<int>.filled(len, 0);
      data_ = Uint8List.fromList(d).buffer.asByteData();
    }
    var timeBootMs = data_.getUint32(0, Endian.little);
    var value = data_.getFloat32(4, Endian.little);
    var timestampSeconds = data_.getUint32(8, Endian.little);
    var timestampMilliseconds = data_.getUint16(12, Endian.little);
    var name = MavlinkMessage.asInt8List(data_, 14, 10);

    return NamedValueFloat(
      timeBootMs: timeBootMs,
      value: value,
      timestampSeconds: timestampSeconds,
      timestampMilliseconds: timestampMilliseconds,
      name: name,
    );
  }

  @override
  ByteData serialize() {
    var data_ = ByteData(mavlinkEncodedLength);
    data_.setUint32(0, timeBootMs, Endian.little);
    data_.setFloat32(4, value, Endian.little);
    data_.setUint32(8, timestampSeconds, Endian.little);
    data_.setUint16(12, timestampMilliseconds, Endian.little);
    MavlinkMessage.setInt8List(data_, 14, name);
    return data_;
  }
}

/// Send a key-value pair as integer. The use of this message is discouraged for normal packets, but a quite efficient way for testing new messages and getting experimental debug output.
///
/// NAMED_VALUE_INT
class NamedValueInt implements MavlinkMessage {
  static const int _mavlinkMessageId = 252;

  static const int _mavlinkCrcExtra = 106;

  static const int mavlinkEncodedLength = 24;

  @override
  int get mavlinkMessageId => _mavlinkMessageId;

  @override
  int get mavlinkCrcExtra => _mavlinkCrcExtra;

  /// Timestamp (time since system boot).
  ///
  /// MAVLink type: uint32_t
  ///
  /// units: ms
  ///
  /// time_boot_ms
  final uint32_t timeBootMs;

  /// Signed integer value
  ///
  /// MAVLink type: int32_t
  ///
  /// value
  final int32_t value;

  /// Seconds since Unix time
  ///
  /// MAVLink type: uint32_t
  ///
  /// timestamp_seconds
  final uint32_t timestampSeconds;

  /// Milliseconds within Unix time
  ///
  /// MAVLink type: uint16_t
  ///
  /// timestamp_milliseconds
  final uint16_t timestampMilliseconds;

  /// Name of the debug variable
  ///
  /// MAVLink type: char[10]
  ///
  /// name
  final List<char> name;

  NamedValueInt({
    required this.timeBootMs,
    required this.value,
    required this.timestampSeconds,
    required this.timestampMilliseconds,
    required this.name,
  });

  NamedValueInt copyWith({
    uint32_t? timeBootMs,
    int32_t? value,
    uint32_t? timestampSeconds,
    uint16_t? timestampMilliseconds,
    List<char>? name,
  }) {
    return NamedValueInt(
      timeBootMs: timeBootMs ?? this.timeBootMs,
      value: value ?? this.value,
      timestampSeconds: timestampSeconds ?? this.timestampSeconds,
      timestampMilliseconds:
          timestampMilliseconds ?? this.timestampMilliseconds,
      name: name ?? this.name,
    );
  }

  factory NamedValueInt.parse(ByteData data_) {
    if (data_.lengthInBytes < NamedValueInt.mavlinkEncodedLength) {
      var len = NamedValueInt.mavlinkEncodedLength - data_.lengthInBytes;
      var d =
          data_.buffer.asUint8List().sublist(0, data_.lengthInBytes) +
          List<int>.filled(len, 0);
      data_ = Uint8List.fromList(d).buffer.asByteData();
    }
    var timeBootMs = data_.getUint32(0, Endian.little);
    var value = data_.getInt32(4, Endian.little);
    var timestampSeconds = data_.getUint32(8, Endian.little);
    var timestampMilliseconds = data_.getUint16(12, Endian.little);
    var name = MavlinkMessage.asInt8List(data_, 14, 10);

    return NamedValueInt(
      timeBootMs: timeBootMs,
      value: value,
      timestampSeconds: timestampSeconds,
      timestampMilliseconds: timestampMilliseconds,
      name: name,
    );
  }

  @override
  ByteData serialize() {
    var data_ = ByteData(mavlinkEncodedLength);
    data_.setUint32(0, timeBootMs, Endian.little);
    data_.setInt32(4, value, Endian.little);
    data_.setUint32(8, timestampSeconds, Endian.little);
    data_.setUint16(12, timestampMilliseconds, Endian.little);
    MavlinkMessage.setInt8List(data_, 14, name);
    return data_;
  }
}

/// Status text message. These messages are printed in yellow in the COMM console of QGroundControl. WARNING: They consume quite some bandwidth, so use only for important status and error messages. If implemented wisely, these messages are buffered on the MCU and sent only at a limited rate (e.g. 10 Hz).
///
/// STATUSTEXT
class Statustext implements MavlinkMessage {
  static const int _mavlinkMessageId = 253;

  static const int _mavlinkCrcExtra = 83;

  static const int mavlinkEncodedLength = 60;

  @override
  int get mavlinkMessageId => _mavlinkMessageId;

  @override
  int get mavlinkCrcExtra => _mavlinkCrcExtra;

  /// Severity of status. Relies on the definitions within RFC-5424.
  ///
  /// MAVLink type: uint8_t
  ///
  /// enum: [MavSeverity]
  ///
  /// severity
  final MavSeverity severity;

  /// Status text message, without null termination character
  ///
  /// MAVLink type: char[50]
  ///
  /// text
  final List<char> text;

  /// Unique (opaque) identifier for this statustext message.  May be used to reassemble a logical long-statustext message from a sequence of chunks.  A value of zero indicates this is the only chunk in the sequence and the message can be emitted immediately.
  ///
  /// MAVLink type: uint16_t
  ///
  /// Extensions field for MAVLink 2.
  ///
  /// id
  final uint16_t id;

  /// This chunk's sequence number; indexing is from zero.  Any null character in the text field is taken to mean this was the last chunk.
  ///
  /// MAVLink type: uint8_t
  ///
  /// Extensions field for MAVLink 2.
  ///
  /// chunk_seq
  final uint8_t chunkSeq;

  /// Seconds since Unix time
  ///
  /// MAVLink type: uint32_t
  ///
  /// Extensions field for MAVLink 2.
  ///
  /// timestamp_seconds
  final uint32_t timestampSeconds;

  /// Milliseconds within Unix time
  ///
  /// MAVLink type: uint16_t
  ///
  /// Extensions field for MAVLink 2.
  ///
  /// timestamp_milliseconds
  final uint16_t timestampMilliseconds;

  Statustext({
    required this.severity,
    required this.text,
    required this.id,
    required this.chunkSeq,
    required this.timestampSeconds,
    required this.timestampMilliseconds,
  });

  Statustext copyWith({
    MavSeverity? severity,
    List<char>? text,
    uint16_t? id,
    uint8_t? chunkSeq,
    uint32_t? timestampSeconds,
    uint16_t? timestampMilliseconds,
  }) {
    return Statustext(
      severity: severity ?? this.severity,
      text: text ?? this.text,
      id: id ?? this.id,
      chunkSeq: chunkSeq ?? this.chunkSeq,
      timestampSeconds: timestampSeconds ?? this.timestampSeconds,
      timestampMilliseconds:
          timestampMilliseconds ?? this.timestampMilliseconds,
    );
  }

  factory Statustext.parse(ByteData data_) {
    if (data_.lengthInBytes < Statustext.mavlinkEncodedLength) {
      var len = Statustext.mavlinkEncodedLength - data_.lengthInBytes;
      var d =
          data_.buffer.asUint8List().sublist(0, data_.lengthInBytes) +
          List<int>.filled(len, 0);
      data_ = Uint8List.fromList(d).buffer.asByteData();
    }
    var severity = data_.getUint8(0);
    var text = MavlinkMessage.asInt8List(data_, 1, 50);
    var id = data_.getUint16(51, Endian.little);
    var chunkSeq = data_.getUint8(53);
    var timestampSeconds = data_.getUint32(54, Endian.little);
    var timestampMilliseconds = data_.getUint16(58, Endian.little);

    return Statustext(
      severity: severity,
      text: text,
      id: id,
      chunkSeq: chunkSeq,
      timestampSeconds: timestampSeconds,
      timestampMilliseconds: timestampMilliseconds,
    );
  }

  @override
  ByteData serialize() {
    var data_ = ByteData(mavlinkEncodedLength);
    data_.setUint8(0, severity);
    MavlinkMessage.setInt8List(data_, 1, text);
    data_.setUint16(51, id, Endian.little);
    data_.setUint8(53, chunkSeq);
    data_.setUint32(54, timestampSeconds, Endian.little);
    data_.setUint16(58, timestampMilliseconds, Endian.little);
    return data_;
  }
}

/// Send a debug value. The index is used to discriminate between values. These values show up in the plot of QGroundControl as DEBUG N.
///
/// DEBUG
class Debug implements MavlinkMessage {
  static const int _mavlinkMessageId = 254;

  static const int _mavlinkCrcExtra = 46;

  static const int mavlinkEncodedLength = 9;

  @override
  int get mavlinkMessageId => _mavlinkMessageId;

  @override
  int get mavlinkCrcExtra => _mavlinkCrcExtra;

  /// Timestamp (time since system boot).
  ///
  /// MAVLink type: uint32_t
  ///
  /// units: ms
  ///
  /// time_boot_ms
  final uint32_t timeBootMs;

  /// DEBUG value
  ///
  /// MAVLink type: float
  ///
  /// value
  final float value;

  /// index of debug variable
  ///
  /// MAVLink type: uint8_t
  ///
  /// ind
  final uint8_t ind;

  Debug({required this.timeBootMs, required this.value, required this.ind});

  Debug copyWith({uint32_t? timeBootMs, float? value, uint8_t? ind}) {
    return Debug(
      timeBootMs: timeBootMs ?? this.timeBootMs,
      value: value ?? this.value,
      ind: ind ?? this.ind,
    );
  }

  factory Debug.parse(ByteData data_) {
    if (data_.lengthInBytes < Debug.mavlinkEncodedLength) {
      var len = Debug.mavlinkEncodedLength - data_.lengthInBytes;
      var d =
          data_.buffer.asUint8List().sublist(0, data_.lengthInBytes) +
          List<int>.filled(len, 0);
      data_ = Uint8List.fromList(d).buffer.asByteData();
    }
    var timeBootMs = data_.getUint32(0, Endian.little);
    var value = data_.getFloat32(4, Endian.little);
    var ind = data_.getUint8(8);

    return Debug(timeBootMs: timeBootMs, value: value, ind: ind);
  }

  @override
  ByteData serialize() {
    var data_ = ByteData(mavlinkEncodedLength);
    data_.setUint32(0, timeBootMs, Endian.little);
    data_.setFloat32(4, value, Endian.little);
    data_.setUint8(8, ind);
    return data_;
  }
}

class MavlinkDialectArariboat implements MavlinkDialect {
  static const int mavlinkVersion = 3;

  @override
  int get version => mavlinkVersion;

  @override
  MavlinkMessage? parse(int messageID, ByteData data) {
    switch (messageID) {
      case 1:
        return Instrumentation.parse(data);
      case 2:
        return Temperatures.parse(data);
      case 3:
        return Gps.parse(data);
      case 4:
        return Mppt.parse(data);
      case 5:
        return MpptState.parse(data);
      case 6:
        return Bms.parse(data);
      case 7:
        return BmsStatus.parse(data);
      case 8:
        return EzkontrolMcuMeterDataI.parse(data);
      case 9:
        return EzkontrolMcuMeterDataIi.parse(data);
      case 10:
        return Pumps.parse(data);
      case 20:
        return ParamRequestRead.parse(data);
      case 22:
        return ParamValue.parse(data);
      case 23:
        return ParamSet.parse(data);
      case 109:
        return RadioStatus.parse(data);
      case 251:
        return NamedValueFloat.parse(data);
      case 252:
        return NamedValueInt.parse(data);
      case 253:
        return Statustext.parse(data);
      case 254:
        return Debug.parse(data);
      default:
        return null;
    }
  }

  @override
  int crcExtra(int messageID) {
    switch (messageID) {
      case 1:
        return Instrumentation._mavlinkCrcExtra;
      case 2:
        return Temperatures._mavlinkCrcExtra;
      case 3:
        return Gps._mavlinkCrcExtra;
      case 4:
        return Mppt._mavlinkCrcExtra;
      case 5:
        return MpptState._mavlinkCrcExtra;
      case 6:
        return Bms._mavlinkCrcExtra;
      case 7:
        return BmsStatus._mavlinkCrcExtra;
      case 8:
        return EzkontrolMcuMeterDataI._mavlinkCrcExtra;
      case 9:
        return EzkontrolMcuMeterDataIi._mavlinkCrcExtra;
      case 10:
        return Pumps._mavlinkCrcExtra;
      case 20:
        return ParamRequestRead._mavlinkCrcExtra;
      case 22:
        return ParamValue._mavlinkCrcExtra;
      case 23:
        return ParamSet._mavlinkCrcExtra;
      case 109:
        return RadioStatus._mavlinkCrcExtra;
      case 251:
        return NamedValueFloat._mavlinkCrcExtra;
      case 252:
        return NamedValueInt._mavlinkCrcExtra;
      case 253:
        return Statustext._mavlinkCrcExtra;
      case 254:
        return Debug._mavlinkCrcExtra;
      default:
        return -1;
    }
  }
}
