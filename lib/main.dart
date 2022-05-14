import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

void main() {
  runApp(const MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String chave = "6d46aa86";
  String request = "https://api.hgbrasil.com/finance/stock_price?key=";

  String buscarTitulo = "";
  String _nomeAcao = "--";
  String _tiuloAcao = "--";
  String _valoracao = "--";

  final _chaveTitulo = GlobalKey<FormState>();

  final acaoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bolsa de valores"),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.white70,
      body: body(),
    );
  }

  Widget body() {
    return Container(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _chaveTitulo,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "Entre com o titulo da sua ação",
                style: TextStyle(fontSize: 20.0),
              ),
              TextField(
                controller: acaoController,
                decoration: const InputDecoration(
                    fillColor: Colors.white, filled: true),
                onChanged: (String valor) {
                  buscarTitulo = valor;
                },
              ),
              ElevatedButton.icon(
                  onPressed: () {
                    _buscarTitulo();
                  },
                  icon: const Icon(Icons.search),
                  label: const Text("Buscar")),
              Text("Nome da Ação: $_nomeAcao"),
              Text("titulo da Ação: $_tiuloAcao"),
              Text("Valor da Ação: $_valoracao")
            ],
          ),
        ));
  }

  _buscarTitulo() async {
    try {
      var url = Uri.parse(
          "https://api.hgbrasil.com/finance/stock_price?key=6d46aa86&symbol=$buscarTitulo");

      var response = await http.get(url);

      Map<dynamic, dynamic> resposta = jsonDecode(response.body);
      Map<dynamic, dynamic> acao = resposta["results"];
      acao = acao[buscarTitulo.toUpperCase()];

      setState(() {
        _nomeAcao = acao["name"].toString();
        _tiuloAcao = acao["symbol"].toString();
        _valoracao = acao["price"].toString();
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
