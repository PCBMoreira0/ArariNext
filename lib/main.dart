import 'package:arari_next/data/repositories/dashboard/dashboard_repository.dart';
import 'package:arari_next/data/repositories/dashboard/dashboard_repository_impl.dart';
import 'package:arari_next/data/repositories/packet/telemetry_repository.dart';
import 'package:arari_next/data/services/datasource/mqtt_datasource.dart';
import 'package:arari_next/data/services/datasource/serial_datasource_interface.dart';
import 'package:arari_next/data/services/pipeline/mavlink_mapper.dart';
import 'package:arari_next/data/services/pipeline/mavlink_telemetry_source.dart';
import 'package:arari_next/data/services/pipeline/telemetry_source_interface.dart';
import 'package:arari_next/managers/connection_manager.dart';
import 'package:arari_next/managers/settings_manager.dart';
import 'package:arari_next/data/repositories/settings/local_settings_repository.dart';
import 'package:arari_next/data/repositories/packet/telemetry_repository_interface.dart';
import 'package:arari_next/data/repositories/settings/settings_repository.dart';
import 'package:arari_next/data/services/datasource/data_source_interface.dart';
import 'package:arari_next/data/services/file/file_storage_service.dart';
import 'package:arari_next/data/services/file/local_file_storage_service.dart';
import 'package:arari_next/data/services/logging/logging_service_influx.dart';
import 'package:arari_next/data/services/datasource/serial_datasource.dart';
import 'package:arari_next/mocks/mock_serial_datasource_random.dart';
import 'package:arari_next/routing/routes.dart';
import 'package:arari_next/ui/core/history_store.dart';
import 'package:arari_next/ui/core/ui/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:arari_next/routing/router.dart';
import 'package:nativeapi/nativeapi.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final windowManager = WindowManager.instance;
  final window = windowManager.getCurrent();
  window?.setMinimumSize(400, double.infinity);
  window?.show();
  window?.center();

  FileStorageService fileStorageService = LocalFileStorageService();

  SettingsRepository settingsRepository = LocalSettingsRepository(
    fileStorageService: fileStorageService,
  );

  await settingsRepository.initialize();

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: fileStorageService),
        Provider.value(value: settingsRepository),
        Provider(
          create: (context) => SerialDatasource() as ISerialDatasource,
          dispose: (context, value) => value.dispose(),
        ),
        Provider(
          create: (context) => MqttDatasource(),
          dispose: (context, value) => value.dispose(),
        ),
        Provider<IDataSource>(
          create: (context) => context.read<ISerialDatasource>(),
        ),
        Provider(
          create: (context) =>
              ConnectionManager(mqtt: context.read(), serial: context.read()),
          dispose: (context, value) => value.dispose(),
        ),
        Provider(
          create: (context) =>
              SettingsManager(settingsRepository: context.read()),
        ),
        Provider(
          create: (context) =>
              DashboardRepositoryImpl(fileStorageService: context.read())
                  as DashboardRepository,
        ),

        Provider.value(value: LoggingServiceInflux()),

        Provider(
          create: (context) =>
              MavlinkTelemetrySource(
                    source: context.read(),
                    mapper: MavlinkMapper(),
                  )
                  as ITelemetrySource,
          dispose: (context, value) => value.dispose(),
        ),
        Provider(
          create: (context) =>
              TelemetryRepository(source: context.read())
                  as ITelemetryRepository,
          dispose: (context, value) => value.dispose(),
        ),
        Provider(
          create: (context) => HistoryStore(packetRepository: context.read()),
          dispose: (context, value) => value.dispose(),
        ),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MavBoia',
      theme: themeProvider.lightTheme,
      darkTheme: themeProvider.darkTheme,
      themeMode: themeProvider.themeMode,
      // Carrega a pagina inicial.
      initialRoute: Routes.dashboard,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
