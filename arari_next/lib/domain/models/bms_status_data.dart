import 'package:arari_next/domain/models/iboat_data.dart';

enum BMSStatus{
  charge, discharge
}

enum FailureFlag {
  // Byte 0
  cellVoltHighLevel1,
  cellVoltHighLevel2,
  cellVoltLowLevel1,
  cellVoltLowLevel2,
  sumVoltHighLevel1,
  sumVoltHighLevel2,
  sumVoltLowLevel1,
  sumVoltLowLevel2,

  // Byte 1
  chgTempHighLevel1,
  chgTempHighLevel2,
  chgTempLowLevel1,
  chgTempLowLevel2,
  dischgTempHighLevel1,
  dischgTempHighLevel2,
  dischgTempLowLevel1,
  dischgTempLowLevel2,

  // Byte 2
  chgOvercurrentLevel1,
  chgOvercurrentLevel2,
  dischgOvercurrentLevel1,
  dischgOvercurrentLevel2,
  socHighLevel1,
  socHighLevel2,
  socLowLevel1,
  socLowLevel2,

  // Byte 3
  diffVoltLevel1,
  diffVoltLevel2,
  diffTempLevel1,
  diffTempLevel2,
  reserved34,
  reserved35,
  reserved36,
  reserved37,

  // Byte 4
  chgMosTempHighAlarm,
  dischgMosTempHighAlarm,
  chgMosTempSensorErr,
  dischgMosTempSensorErr,
  chgMosAdhesionErr,
  dischgMosAdhesionErr,
  chgMosOpenCircuitErr,
  dischgMosOpenCircuitErr,

  // Byte 5
  afeCollectChipErr,
  voltageCollectDropped,
  cellTempSensorErr,
  eepromErr,
  rtcErr,
  prechargeFailure,
  communicationFailure,
  internalCommunicationFailure,

  // Byte 6
  currentModuleFault,
  sumVoltageDetectFault,
  shortCircuitProtectFault,
  lowVoltForbiddenChgFault,
}


final class BMSStatusData implements IBoatData {
  final List<double> temperatures;
  final BMSStatus status;
  final List<FailureFlag> failureFlags;
  
  BMSStatusData._({required List<double> temperatures, required this.status, required List<FailureFlag> failureFlags}) 
    : temperatures = List.unmodifiable(temperatures),
    failureFlags = List.unmodifiable(failureFlags);

  factory BMSStatusData({
        required List<double> temperatures, 
        required status, 
        int failureFlagsByte0 = 0, 
        int failureFlagsByte1 = 0, 
        int failureFlagsByte2 = 0, 
        int failureFlagsByte3 = 0, 
        int failureFlagsByte4 = 0, 
        int failureFlagsByte5 = 0, 
        int failureFlagsByte6 = 0
    }) {
        List<FailureFlag> failureFlags = [];

        // Byte 0
        for (int i = 0; i < 8; i++)
        {
            if((failureFlagsByte0 & (128 >> i)) != 0)
            {
                failureFlags.add(FailureFlag.values[(i + 8 * 0)]);
            }
        }
    
        // Byte 1
        for (int i = 0; i < 8; i++)
        {
            if ((failureFlagsByte1 & (128 >> i)) != 0)
            {
                failureFlags.add(FailureFlag.values[(i + 8 * 1)]);
            }
        }
    
        // Byte 2
        for (int i = 0; i < 8; i++)
        {
            if ((failureFlagsByte2 & (128 >> i)) != 0)
            {
                failureFlags.add(FailureFlag.values[(i + 8 * 2)]);
            }
        }
    
        // Byte 3
        for (int i = 0; i < 8; i++)
        {
            if ((failureFlagsByte3 & (128 >> i)) != 0)
            {
                failureFlags.add(FailureFlag.values[(i + 8 * 3)]);
            }
        }
    
        // Byte 4
        for (int i = 0; i < 8; i++)
        {
            if ((failureFlagsByte4 & (128 >> i)) != 0)
            {
                failureFlags.add(FailureFlag.values[(i + 8 * 4)]);
            }
        }
    
        // Byte 5
        for (int i = 0; i < 8; i++)
        {
            if ((failureFlagsByte5 & (128 >> i)) != 0)
            {
                failureFlags.add(FailureFlag.values[(i + 8 * 5)]);
            }
        }
    
        // Byte 6
        for (int i = 0; i < 4; i++)
        {
            if ((failureFlagsByte6 & (128 >> i)) != 0)
            {
                failureFlags.add(FailureFlag.values[(i + 8 * 6)]);
            }
        }

        return BMSStatusData._(temperatures: temperatures, status: status, failureFlags: failureFlags);
  }
}