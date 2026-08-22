import 'package:arari_next/data/repositories/dashboard/dashboard_repository.dart';
import 'package:arari_next/data/repositories/dashboard/dashboard_repository_impl.dart';
import 'package:arari_next/data/repositories/packet/telemetry_repository.dart';
import 'package:arari_next/data/repositories/packet/telemetry_repository_interface.dart';
import 'package:arari_next/data/repositories/settings/settings_repository.dart';
import 'package:arari_next/data/services/datasource/mqtt_datasource.dart';
import 'package:arari_next/data/services/datasource/mqtt_datasource_interface.dart';
import 'package:arari_next/data/services/datasource/serial_datasource.dart';
import 'package:arari_next/data/services/datasource/serial_datasource_interface.dart';
import 'package:arari_next/data/services/file/file_storage_service.dart';
import 'package:arari_next/data/services/logging/logging_service_influx.dart';
import 'package:arari_next/data/services/pipeline/mavlink_mapper.dart';
import 'package:arari_next/data/services/pipeline/mavlink_telemetry_source.dart';
import 'package:arari_next/data/services/pipeline/telemetry_source_interface.dart';
import 'package:arari_next/managers/connection_manager.dart';
import 'package:arari_next/managers/settings_manager.dart';
import 'package:arari_next/ui/core/history_store.dart';
import 'package:arari_next/ui/core/ui/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> appProviders({
  required FileStorageService fileStorageService,
  required SettingsRepository settingsRepository,
}) {
  return [
    // ============================================================
    // Infrastructure / External Services
    // ============================================================
    Provider.value(value: fileStorageService),

    Provider.value(value: settingsRepository),

    Provider.value(value: LoggingServiceInflux()),

    // ============================================================
    // Data Sources
    // ============================================================
    Provider<ISerialDatasource>(
      create: (_) => SerialDatasource(),
      dispose: (_, value) => value.dispose(),
    ),

    Provider<IMqttDataSource>(
      create: (_) => MqttDatasource(),
      dispose: (_, value) => value.dispose(),
    ),

    // ============================================================
    // Connection
    // ============================================================
    Provider<ConnectionManager>(
      create: (context) =>
          ConnectionManager(serial: context.read(), mqtt: context.read()),
      dispose: (_, value) => value.dispose(),
    ),

    // ============================================================
    // Telemetry Pipeline
    // ============================================================
    Provider<ITelemetrySource>(
      create: (context) => MavlinkTelemetrySource(
        source: context.read<ISerialDatasource>(),
        mapper: MavlinkMapper(),
      ),
      dispose: (_, value) => value.dispose(),
    ),

    // ============================================================
    // Repositories
    // ============================================================
    Provider<DashboardRepository>(
      create: (context) =>
          DashboardRepositoryImpl(fileStorageService: context.read()),
    ),

    Provider<ITelemetryRepository>(
      create: (context) =>
          TelemetryRepository(source: context.read<ITelemetrySource>()),
      dispose: (_, value) => value.dispose(),
    ),

    // ============================================================
    // Managers
    // ============================================================
    Provider<SettingsManager>(
      create: (context) => SettingsManager(settingsRepository: context.read()),
    ),

    // ============================================================
    // Application State
    // ============================================================
    Provider<HistoryStore>(
      create: (context) => HistoryStore(packetRepository: context.read()),
      dispose: (_, value) => value.dispose(),
    ),

    ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
  ];
}
