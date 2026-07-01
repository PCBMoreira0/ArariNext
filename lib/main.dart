import 'package:arari_next/config/settings_manager.dart';
import 'package:arari_next/data/repositories/local_settings_repository.dart';
import 'package:arari_next/data/repositories/mavlink_repository.dart';
import 'package:arari_next/data/repositories/packet_repository.dart';
import 'package:arari_next/data/repositories/settings_repository.dart';
import 'package:arari_next/data/services/data_source_interface.dart';
import 'package:arari_next/data/services/file_storage_service.dart';
import 'package:arari_next/data/services/local_file_storage_service.dart';
import 'package:arari_next/data/services/logging_service_influx.dart';
import 'package:arari_next/data/services/serial/serial_datasource.dart';
import 'package:arari_next/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:arari_next/routing/router.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FileStorageService fileStorageService = LocalFileStorageService();

  SettingsRepository settingsRepository = LocalSettingsRepository(
    fileStorageService: fileStorageService,
  );

  settingsRepository.initialize();

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: fileStorageService),
        Provider.value(value: settingsRepository),
        Provider(
          create: (context) =>
              SettingsManager(settingsRepository: context.read()),
        ),
        Provider.value(value: LoggingServiceInflux()),

        Provider(create: (context) => SerialDatasource()),
        Provider<IDataSource>(
          create: (context) => context.read<SerialDatasource>(),
        ),
        Provider(
          create: (context) =>
              MavlinkRepository(dataSource: context.read(), log: context.read())
                  as PacketRepository,
        ),
      ],
      child: const ArariNextApp(),
    ),
  );
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
      // Carrega a pagina inicial.
      initialRoute: Routes.dashboard,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
