import 'package:arari_next/data/repositories/settings/local_settings_repository.dart';
import 'package:arari_next/data/repositories/settings/settings_repository.dart';
import 'package:arari_next/data/services/file/file_storage_service.dart';
import 'package:arari_next/data/services/file/local_file_storage_service.dart';
import 'package:arari_next/providers.dart';
import 'package:arari_next/routing/routes.dart';
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
      providers: appProviders(
        fileStorageService: fileStorageService,
        settingsRepository: settingsRepository,
      ),
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
