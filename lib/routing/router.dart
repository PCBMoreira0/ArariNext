import 'package:arari_next/routing/routes.dart';
import 'package:arari_next/ui/viewmodels/dashboard_viewmodel.dart';
import 'package:arari_next/ui/viewmodels/settings_viewmodel.dart';
import 'package:arari_next/ui/views/dashboard_view.dart';
import 'package:arari_next/ui/views/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:arari_next/ui/views/console_view.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case Routes.console:
        return MaterialPageRoute(builder: (_) => ConsoleView());
      
      case Routes.dashboard:
        return MaterialPageRoute(builder: (context) => DashboardView(viewmodel: DashboardViewmodel(repository: context.read())));
       
      case Routes.settings:
        return MaterialPageRoute(builder: (context) => SettingsView(viewmodel: SettingsViewmodel(serial: context.read(), settings: context.read())));
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: Text('Route Error')),
          body: Center(child: Text('Route ERROR')),
        );
      },
    );
  }
}
