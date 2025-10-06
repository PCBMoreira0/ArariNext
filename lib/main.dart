import 'package:arari_next/config/settings_manager.dart';
import 'package:arari_next/data/repositories/mavlink_repository.dart';
import 'package:arari_next/data/repositories/packet_repository.dart';
import 'package:arari_next/data/services/serial/serial_connector.dart';
import 'package:arari_next/data/services/serial/serial_service.dart';
import 'package:arari_next/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:arari_next/routing/router.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SettingsManager settingsManager = await SettingsManager.create();

  runApp(MultiProvider(providers: [
    Provider.value(value: settingsManager),
    Provider(create: (context) => SerialService(serial: SerialConnector(), settings: context.read())),
    Provider(create: (context) => MavlinkRepository(serialService: context.read()) as PacketRepository)
  ], child: const ArariNextApp()));
}

class ArariNextApp extends StatefulWidget {
  const ArariNextApp({super.key});

  @override
  State<ArariNextApp> createState() => _ArariNextAppState();
}

class _ArariNextAppState extends State<ArariNextApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MavBoia',
      theme: ThemeData(primarySwatch: Colors.blue),
      // Initially display FirstPage
      initialRoute: Routes.dashboard,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
