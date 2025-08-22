import 'package:arari_next/ui/core/ui/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:arari_next/ui/viewmodels/console_viewmodel.dart';
import 'package:arari_next/domain/models/console_log.dart';

class ConsoleView extends StatefulWidget {
  const ConsoleView({super.key});

  @override
  State<ConsoleView> createState() => _ConsoleViewState();
}

class _ConsoleViewState extends State<ConsoleView> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  ConsoleViewModel _logsNotifier =  ConsoleViewModel();
  
  @override
  Widget build(BuildContext context) {
    //todo: change cache size to be injected from settings.

    return Scaffold(
      appBar: AppBar(
        title: const Text('Console'),
        backgroundColor: Colors.blueAccent,
      ),
      drawer: const SideMenu(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              // condição para retornar caixa vazia se não houver nada na lista, se não da erro na renderização.
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.black),
                ),
                margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: LogListBody(listNotifer: _logsNotifier)
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
              height: 50,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.11),
                    blurRadius: 40,
                    spreadRadius: 0.0,
                  ),
                ],
              ),
              child: TextField(
                controller: _controller,
                onSubmitted: (textoDaCaixa) => {
                  _logsNotifier.log(LogType.input, textoDaCaixa),
                  _controller.clear(),
                  if (textoDaCaixa.toLowerCase() == 'clear')
                    {_logsNotifier.clear()},
                  setState(() {}),
                },
                decoration: InputDecoration(
                  labelText: "Escreva a mensagem a ser enviada.",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LogListBody extends StatelessWidget {
  const LogListBody({super.key, required this.listNotifer});

  final ConsoleViewModel listNotifer;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(listenable: listNotifer, 
    builder: (BuildContext context, Widget? child) {
      print('DrewList');
      if (listNotifer.isNotEmpty()) {
        print('${listNotifer.logs.first.contents}' );
      }
      if (listNotifer.logs.isNotEmpty) {
        final List<ConsoleLog> list = listNotifer.logs;
        return ListView.builder(
                        itemCount: listNotifer.logs.length,
                         prototypeItem: SizedBox(
                          child: LogBody(log: list.first),
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return LogBody(log: list[index]);
                        },
                      );
      } else {
        return SizedBox.expand();
      }
    });
  }
}

class LogBody extends StatelessWidget {
  const LogBody({super.key, required this.log});

  final ConsoleLog log;

  @override
  Widget build(BuildContext context) {
    return SizedBox(child: Text('[${log.datetime.hour}:${log.datetime.minute}:${log.datetime.second}](${log.type.name}): ${log.contents}'),);
  }

}