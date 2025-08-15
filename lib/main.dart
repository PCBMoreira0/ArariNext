import 'package:flutter/material.dart';
import 'package:arari_next/routing/router.dart';

void main() => runApp(Mavboia());

class Mavboia extends StatefulWidget {
  const Mavboia({super.key});

  @override
  State<Mavboia> createState() => _MavboiaState();
}

class _MavboiaState extends State<Mavboia> {
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
      initialRoute: '/console',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
