import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter06/local.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MaterialApp(
    home: MainApp(),
  ));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _longController = TextEditingController();
  var temperatura = '';
  var umidade = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
	body: Center(
	  child: Column(
	    children: [
	      TextField(
		      controller: _latController,
		      decoration: const InputDecoration(labelText: 'Digite a latitude'),
	      ),
        TextField(
          controller: _longController,
          decoration: const InputDecoration(labelText: 'Digite a Longitude'),
        ),
	      Text('Temperatura: $temperatura°C'),
        Text('Umidade: $umidade%'),
	      TextButton(
		onPressed: buscaTemp,
		child: const Text('Buscar'),
	      ),
	    ],
	  ),
	),
      ),
    );
  }

void buscaTemp() async {
  String latUser = _latController.text;
  String longUser = _longController.text;
  String url = 'https://api.open-meteo.com/v1/forecast?latitude=$latUser&longitude=$longUser&current=temperature_2m,relative_humidity_2m&timezone=America%2FSao_Paulo&forecast_days=1';
  final resposta = await http.get(Uri.parse(url));

  if (resposta.statusCode == 200) {
    final jsonDecodificado = jsonDecode(resposta.body);
    // if (jsonDecodificado['erro'] != null) {
    //   _showAlertDialog('Localização não encontrada', 'Por favor, verifique e tente novamente.');
    // } else {
      final local = Local.fromJson(jsonDecodificado);

      setState(() {
        temperatura = local.temp.toString();
        umidade = local.umi.toString();
      });
    // }
  } else {
    setState(() {
      temperatura = '';
    });

    _showAlertDialog('Erro', 'Ocorreu um erro ao buscar o Local.');
  }
}

void _showAlertDialog(String title, String content) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
}