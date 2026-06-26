import 'dart:io';

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
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (!Platform.isAndroid && !Platform.isIOS) {
      widget.viewmodel.downloadSettings();
    }

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
          if (!Platform.isAndroid && !Platform.isIOS)
            _SerialSettings(viewmodel: widget.viewmodel),
          SizedBox(height: 40.0),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: logTextController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Digite o caminho',
                    labelText: 'Diretório do Log',
                  ),
                  onChanged: (value) {
                    widget.viewmodel.setLogDirectory(value);
                  },
                  validator: (value) {
                    final regex = RegExp(r'^[^\\]*$');
                    if (value == null || value.isEmpty) {
                      return 'O campo não pode ficar vazio';
                    }
                    if (!regex.hasMatch(value)) {
                      return 'O campo não pode conter \'\\\'';
                    }
                    return null;
                  },
                ),
                ListenableBuilder(
                  listenable: widget.viewmodel,
                  builder: (context, child) {
                    return ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          widget.viewmodel.toggleLogging();
                        }
                      },
                      child: Text(
                        widget.viewmodel.isLogOpen ? 'Finalizar' : 'Começar',
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

handleError(Object e, BuildContext context) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text("Ocorreu um erro: $e"),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
    ),
  );
}

class _SerialSettings extends StatelessWidget {
  final SettingsViewmodel _viewModel;

  const _SerialSettings({super.key, required SettingsViewmodel viewmodel})
    : _viewModel = viewmodel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownMenu(
          dropdownMenuEntries: _viewModel.serialPorts
              .map(
                (entrie) =>
                    DropdownMenuEntry(value: entrie, label: entrie),
              )
              .toList(),
          initialSelection: _viewModel.selectedSerialPort,
          label: const Text("Porta Serial"),
          enableSearch: false,
          onSelected: (value) async {
            if (value != null) {
              await _viewModel.setSerialPort(value);
            }
          },
        ),
        SizedBox(height: 20.0),
        DropdownMenu(
          dropdownMenuEntries: _viewModel.baudRates
              .map(
                (entrie) =>
                    DropdownMenuEntry(value: entrie, label: entrie.toString()),
              )
              .toList(),
          initialSelection: _viewModel.selectedBaudrate,
          onSelected: (value) async {
            if (value != null) {
              await _viewModel.setBaudrate(value);
            }
          },
          label: const Text("Baudrate"),
          enableSearch: false,
        ),
        SizedBox(height: 20.0),
        ListenableBuilder(
          listenable: _viewModel,
          builder: (context, child) => ElevatedButton(
            onPressed: () {
              try {
                _viewModel.toggleSerialPort();
              } catch (e) {
                handleError(e, context);
              }
            },
            child: Text(_viewModel.isSerialConnected ? 'Desconectar' : 'Conectar'),
          ),
        ),
      ],
    );
  }
}
