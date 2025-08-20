import 'package:arari_next/ui/core/ui/side_menu.dart';
import 'package:flutter/material.dart';
import 'dashboard_view.dart';

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

  @override
  Widget build(BuildContext context) {
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
                child: Builder(
                  builder: (context) {
                    if (uartMessages.isNotEmpty) {
                      return ListView.builder(
                        itemCount: uartMessages.length,
                        prototypeItem: SizedBox(
                          child: Text(uartMessages.first),
                        ),
                        itemBuilder: (context, index) {
                          return SizedBox(child: Text(uartMessages[index]));
                        },
                      );
                    } else {
                      return SizedBox.expand();
                    }
                  },
                ),
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
                  uartMessages.add(textoDaCaixa),
                  _controller.clear(),
                  if (textoDaCaixa.toLowerCase() == 'clear')
                    {uartMessages.clear()},
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
