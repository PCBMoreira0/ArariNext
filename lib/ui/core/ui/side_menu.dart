import 'package:arari_next/routing/routes.dart';
import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Arari Next',
                style: TextStyle(color: Colors.white, fontSize: 24, fontFamily: "impact"),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dataset),
            title: const Text('Dados'),
            onTap: () {
              Navigator.of(context).pushNamed('/dashboard');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configurações'),
            onTap: () {
              Navigator.of(context).pushNamed(Routes.settings);
            },
          ),
        ],
      ),
    );
  }
}
