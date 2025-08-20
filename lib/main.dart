import 'package:arari_next/config/settings_manager.dart';
import 'package:arari_next/data/repositories/mavlink_repository.dart';
import 'package:arari_next/data/services/fake_serial_service.dart';
import 'package:arari_next/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:arari_next/routing/router.dart';
import 'package:provider/provider.dart';

void main() async {
  SettingsManager settingsManager = await SettingsManager.create();

  runApp(MultiProvider(providers: [
    Provider.value(value: settingsManager),
    Provider.value(value: FakeSerialService()),
    Provider(create: (context) => MavlinkRepository(serialService: context.read()))
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
      initialRoute: Routes.console,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
