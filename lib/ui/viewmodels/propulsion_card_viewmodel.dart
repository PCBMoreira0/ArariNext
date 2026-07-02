import 'package:arari_next/data/repositories/packet_repository.dart';
import 'package:arari_next/domain/telemetry/full_boat_data.dart';
import 'package:arari_next/domain/telemetry/motor_eletrical_data.dart';
import 'package:arari_next/domain/telemetry/motor_state_data.dart';
import 'package:flutter/material.dart';

class PropulsionCardViewmodel {
  final ValueNotifier<MotorEletricalData> motorEletricalDataValueNotifier =
      ValueNotifier(MotorEletricalData.empty());

  final ValueNotifier<MotorStateData> motorStateDataValueNotifier =
      ValueNotifier(MotorStateData.empty());

  final ValueNotifier<MotorInstance> currentInstanceNotifier = ValueNotifier(MotorInstance.right);

  final PacketRepository packetRepository;

  PropulsionCardViewmodel({required this.packetRepository}) {
    packetRepository.data.listen((data) => onNewDataReceived(data));
  }

  void toggleInstance() {
    currentInstanceNotifier.value = currentInstanceNotifier.value == MotorInstance.left ? MotorInstance.right : MotorInstance.left;
  }

  void onNewDataReceived(FullBoatData? newData) {
    if (newData == null) return;
    if (currentInstanceNotifier.value == MotorInstance.left) {
      motorEletricalDataValueNotifier.value = newData.motorEletricalDataLeft;
      motorStateDataValueNotifier.value = newData.motorStateDataLeft;
    } else {
      motorEletricalDataValueNotifier.value = newData.motorEletricalDataRight;
      motorStateDataValueNotifier.value = newData.motorStateDataRight;
    }
  }
}
