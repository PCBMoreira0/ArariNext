import 'package:flutter/material.dart';
import 'package:arari_next/ui/console_ui.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/console':
        return MaterialPageRoute(builder: (_) => Console());
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
