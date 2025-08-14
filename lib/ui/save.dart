import 'package:flutter/material.dart';

/// Flutter code sample for [Drawer].

void main() => runApp(const DrawerApp());

class DrawerApp extends StatelessWidget {
  const DrawerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: DrawerNavegacao());
  }
}

class DrawerNavegacao extends StatefulWidget {
  const DrawerNavegacao({super.key});

  @override
  State<DrawerNavegacao> createState() => _DrawerNavegacao();
}

class _DrawerNavegacao extends State<DrawerNavegacao> {
  String selectedPage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
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
                setState(() {
                  selectedPage = 'rastreio';
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.show_chart),
              title: const Text('Gráficos'),
              onTap: () {
                setState(() {
                  selectedPage = 'graficos';
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.dataset),
              title: const Text('Dados'),
              onTap: () {
                setState(() {
                  selectedPage = 'dados';
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Mapa'),
              onTap: () {
                setState(() {
                  selectedPage = 'mapa';
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configurações'),
              onTap: () {
                setState(() {
                  selectedPage = 'configuracoes';
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.replay),
              title: const Text('Playback'),
              onTap: () {
                setState(() {
                  selectedPage = 'playback';
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.terminal),
              title: const Text('Console'),
              onTap: () {
                setState(() {
                  selectedPage = 'console';
                });
              },
            ),
          ],
        ),
      ),
      body: Center(child: Text('Page: $selectedPage')),
    );
  }
}
