// import 'package:arari_next/ui/core/utils/layout_constraint.dart';
// import 'package:arari_next/ui/core/utils/layout_mode.dart';
// import 'package:arari_next/ui/core/widgets/cards/custom_card_widget.dart';
// import 'package:arari_next/ui/core/widgets/gauge/battery_gauge.dart';
// import 'package:arari_next/ui/core/widgets/gauge/value_gauge.dart';
// import 'package:arari_next/ui/viewmodels/battery_card_viewmodel.dart';
// import 'package:flutter/material.dart';

// class OldBatteryCard
//  extends StatelessWidget {
//   final BatteryCardViewmodel viewModel;

//   const OldBatteryCard({super.key, required this.viewModel});

//   final double valueTextSize = 16;

//   @override
//   Widget build(BuildContext context) {
//     return CustomCard(
//       title: "Bateria",
//       child: LayoutBuilder(
//         builder: (context, constraints) {
//           LayoutMode layoutMode = LayoutMode(
//             layouts: [
//               _FullLayout(viewModel: viewModel, minHeight: 124, minWidth: 232),
//               _MinimumLayout(viewModel: viewModel, minHeight: 100, minWidth: 160),
//               _CompactLayout(viewModel: viewModel, minHeight: 105, minWidth: 54),
//               _UltraCompactLayout(viewModel: viewModel),
//             ],
//           );

//           return layoutMode.buildLayout(constraints);
//         },
//       ),
//     );
//   }
// }

// class _UltraCompactLayout extends LayoutConstraint {
//   final BatteryCardViewmodel viewModel;

//   _UltraCompactLayout({
//     required this.viewModel,
//     super.minHeight,
//     super.minWidth,
//   });

//   @override
//   Widget build() {
//     return Center(
//       child: FittedBox(
//         fit: BoxFit.contain,
//         child: ValueListenableBuilder(
//           valueListenable: viewModel.fullBoatDataValueNotifier,
//           builder: (context, value, child) {
//             return ValueGauge(
//               value: '${value.bmsData.stateOfCharge}',
//               unit: '%',
//               label: 'SoC',
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// class _CompactLayout extends LayoutConstraint {
//   final BatteryCardViewmodel viewModel;

//   _CompactLayout({required this.viewModel, super.minHeight, super.minWidth});

//   @override
//   Widget build() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Expanded(
//           child: ValueListenableBuilder(
//             valueListenable: viewModel.fullBoatDataValueNotifier,
//             builder: (context, value, child) {
//               return BatteryGauge(level: value.bmsData.stateOfCharge);
//             },
//           ),
//         ),
//         ValueListenableBuilder(
//           valueListenable: viewModel.fullBoatDataValueNotifier,
//           builder: (context, value, child) {
//             return ValueGauge(
//               value: '${value.bmsData.stateOfCharge}',
//               unit: '%',
//               valueStyle: TextStyle(fontSize: 16),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }

// class _MinimumLayout extends LayoutConstraint {
//   final BatteryCardViewmodel viewModel;
//   final double valueTextSize;

//   _MinimumLayout({
//     required this.viewModel,
//     this.valueTextSize = 16,
//     super.minHeight,
//     super.minWidth,
//   });

//   @override
//   Widget build() {
//     return Row(
//       children: [
//         _CompactLayout(viewModel: viewModel).build(),

//         const SizedBox(width: 15),

//         Expanded(
//           child: Column(
//             children: [
//               Expanded(
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Center(
//                         child: ValueListenableBuilder(
//                           valueListenable: viewModel.fullBoatDataValueNotifier,
//                           builder: (context, value, child) {
//                             return ValueGauge(
//                               value: '${value.bmsData.totalVoltage}',
//                               label: 'Tensão',
//                               unit: 'V',
//                               valueStyle: TextStyle(fontSize: valueTextSize),
//                             );
//                           },
//                         ),
//                       ),
//                     ),

//                     Expanded(
//                       child: Center(
//                         child: ValueListenableBuilder(
//                           valueListenable: viewModel.fullBoatDataValueNotifier,
//                           builder: (context, value, child) {
//                             return ValueGauge(
//                               value: '${value.bmsData.batteryCurrent}',
//                               label: 'Corrente',
//                               unit: 'A',
//                               valueStyle: TextStyle(fontSize: valueTextSize),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               Expanded(
//                 child: Center(
//                   child: ValueListenableBuilder(
//                     valueListenable: viewModel.fullBoatDataValueNotifier,
//                     builder: (context, value, child) {
//                       return ValueGauge(
//                         unit: 'h',
//                         value:
//                             '${value.batteryRemainingTimeEstimation.hora}:${value.batteryRemainingTimeEstimation.minuto}',
//                         label: 'Tempo Restante',
//                         valueStyle: TextStyle(fontSize: valueTextSize),
//                       );
//                     },
//                   ),
//                 ),
//               ), // Linha
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _FullLayout extends LayoutConstraint {
//   final double valueTextSize;
//   final BatteryCardViewmodel viewModel;

//   _FullLayout({
//     required this.viewModel,
//     this.valueTextSize = 16,
//     super.minHeight,
//     super.minWidth,
//   });

//   @override
//   Widget build() {
//     return Row(
//       children: [
//         _CompactLayout(viewModel: viewModel).build(),

//         const SizedBox(width: 15),

//         Expanded(
//           child: Column(
//             children: [
//               // Linha 1
//               Expanded(
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Center(
//                         child: ValueListenableBuilder(
//                           valueListenable: viewModel.fullBoatDataValueNotifier,
//                           builder: (context, value, child) {
//                             return ValueGauge(
//                               value: '${value.bmsData.totalVoltage}',
//                               label: 'Tensão',
//                               unit: 'V',
//                               valueStyle: TextStyle(fontSize: valueTextSize),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: Center(
//                         child: ValueListenableBuilder(
//                           valueListenable: viewModel.fullBoatDataValueNotifier,
//                           builder: (context, value, child) {
//                             return ValueGauge(
//                               value: '${value.bmsData.batteryCurrent}',
//                               label: 'Corrente',
//                               unit: 'A',
//                               valueStyle: TextStyle(fontSize: valueTextSize),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               // Linha 2
//               Expanded(
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Center(
//                         child: ValueListenableBuilder(
//                           valueListenable: viewModel.fullBoatDataValueNotifier,
//                           builder: (context, value, child) {
//                             return ValueGauge(
//                               unit: 'h',
//                               value:
//                                   '${value.batteryRemainingTimeEstimation.hora}:${value.batteryRemainingTimeEstimation.minuto}',
//                               label: 'Tempo Restante',
//                               valueStyle: TextStyle(fontSize: valueTextSize),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: Center(
//                         child: ValueListenableBuilder(
//                           valueListenable: viewModel.fullBoatDataValueNotifier,
//                           builder: (context, value, child) {
//                             return ValueGauge(
//                               value:
//                                   '${value.batteryTimeWithoutGeneration.hora}:${value.batteryTimeWithoutGeneration.minuto}',
//                               label: 'Tempo s/ geração',
//                               unit: 'h',
//                               valueStyle: TextStyle(fontSize: valueTextSize),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               Expanded(
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Center(
//                         child: ValueListenableBuilder(
//                           valueListenable: viewModel.fullBoatDataValueNotifier,
//                           builder: (context, value, child) {
//                             return ValueGauge(
//                               unit: 'ºC',
//                               value: '${value.bmsData.temperatures[0]}',
//                               label: 'Temperatura 1',
//                               valueStyle: TextStyle(fontSize: valueTextSize),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: Center(
//                         child: ValueListenableBuilder(
//                           valueListenable: viewModel.fullBoatDataValueNotifier,
//                           builder: (context, value, child) {
//                             return ValueGauge(
//                               unit: 'ºC',
//                               value: '${value.bmsData.temperatures[1]}',
//                               label: 'Temperatura 2',
//                               valueStyle: TextStyle(fontSize: valueTextSize),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
