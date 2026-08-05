import 'package:arari_next/routing/routes.dart';
import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Arari Next',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                  fontFamily: "impact", 
                ) ?? TextStyle(
                  color: colorScheme.onPrimaryContainer,
                  fontSize: 24,
                  fontFamily: "impact",
                ),
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
            leading: const Icon(Icons.graphic_eq),
            title: const Text('Gráficos'),
            onTap: () {
              Navigator.of(context).pushNamed('/chart');
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