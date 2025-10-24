import 'package:arari_next/ui/viewmodels/settings_viewmodel.dart';
import 'package:arari_next/ui/core/ui/side_menu.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({required this.viewmodel, super.key});

  final SettingsViewmodel viewmodel;

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  TextEditingController logTextController = TextEditingController();
  @override
  void initState() {
    super.initState();

    widget.viewmodel.downloadSettings();
    logTextController.text = widget.viewmodel.loggingPath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Configurações")),
      drawer: const SideMenu(),
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: <Widget>[
          ListenableBuilder(
            listenable: widget.viewmodel,
            builder: (context, child) => ElevatedButton(
              onPressed: () {
                try {
                  widget.viewmodel.toggleSerialPort();
                } catch (e) {
                  handleError(e);
                }
              },
              child: Text(
                widget.viewmodel.isSerialOpen ? 'Desconectar' : 'Conectar',
              ),
            ),
          ),
          SizedBox(height: 20.0),
          DropdownMenu(
            dropdownMenuEntries: widget.viewmodel.serialPorts
                .map(
                  (entrie) =>
                      DropdownMenuEntry(value: entrie, label: entrie.name),
                )
                .toList(),
            initialSelection: widget.viewmodel.selectedSerialPort,
            label: const Text("Porta Serial"),
            enableSearch: false,
            onSelected: (value) async {
              if (value != null) {
                await widget.viewmodel.setSerialPort(value);
              }
            },
          ),
          SizedBox(height: 20.0),
          DropdownMenu(
            dropdownMenuEntries: widget.viewmodel.baudRates
                .map(
                  (entrie) => DropdownMenuEntry(
                    value: entrie,
                    label: entrie.toString(),
                  ),
                )
                .toList(),
            initialSelection: widget.viewmodel.selectedBaudrate,
            onSelected: (value) async {
              if (value != null) {
                await widget.viewmodel.setBaudrate(value);
              }
            },
            label: const Text("Baudrate"),
            enableSearch: false,
          ),
          SizedBox(height: 20.0),
          TextField(
            controller: logTextController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Digite o caminho',
              labelText: 'Diretório do Log',
            ),
            onSubmitted: (value) => widget.viewmodel.setLogDirectory(value),
          ),
          ListenableBuilder(
            listenable: widget.viewmodel,
            builder: (context, child) {
              return ElevatedButton(
                onPressed: () async {
                  widget.viewmodel.toggleLogging();
                },
                child: Text(
                  widget.viewmodel.isLogOpen ? 'Finalizar' : 'Começar',
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  handleError(Object e) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Ocorreu um erro: $e"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }
}
