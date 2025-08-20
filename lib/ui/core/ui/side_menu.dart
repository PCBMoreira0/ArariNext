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
            child: Text(
              'Páginas:',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.radar),
            title: const Text('Rastreio'),
            onTap: () {
              Navigator.of(context).pushNamed('/tracker');
            },
          ),
          ListTile(
            leading: const Icon(Icons.show_chart),
            title: const Text('Gráficos'),
            onTap: () {
              Navigator.of(context).pushNamed('/graph');
            },
          ),
          ListTile(
            leading: const Icon(Icons.dataset),
            title: const Text('Dados'),
            onTap: () {
              Navigator.of(context).pushNamed('/dashboard');
            },
          ),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Mapa'),
            onTap: () {
              Navigator.of(context).pushNamed('/map');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configurações'),
            onTap: () {
              Navigator.of(context).pushNamed(Routes.settings);
            },
          ),
          ListTile(
            leading: const Icon(Icons.replay),
            title: const Text('Playback'),
            onTap: () {
              Navigator.of(context).pushNamed('/playback');
            },
          ),
          ListTile(
            leading: const Icon(Icons.terminal),
            title: const Text('Console'),
            onTap: () {
              Navigator.of(context).pushNamed(Routes.console);
            },
          ),
        ],
      ),
    );
  }
}
