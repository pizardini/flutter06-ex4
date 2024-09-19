import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter06/endereco.dart';
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
  final TextEditingController _cepController = TextEditingController();
  var buscaRua = '';
  var buscaBairro = '';
  var buscaCidade = '';
  var buscaEstado = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
	body: Center(
	  child: Column(
	    children: [
	      TextField(
		controller: _cepController,
		decoration: const InputDecoration(labelText: 'Digite o CEP'),
	      ),
	      Text('Rua: $buscaRua'),
        Text('Bairro: $buscaBairro'),
        Text('Cidade: $buscaCidade'),
        Text('Estado: $buscaEstado'),
	      TextButton(
		onPressed: buscaCEP,
		child: const Text('Buscar'),
	      ),
	    ],
	  ),
	),
      ),
    );
  }

void buscaCEP() async {
  String cep = _cepController.text;
  String url = 'https://viacep.com.br/ws/$cep/json/';

  final resposta = await http.get(Uri.parse(url));

  if (resposta.statusCode == 200) {
    final jsonDecodificado = jsonDecode(resposta.body);
    if (jsonDecodificado['erro'] != null) {
      // Caso o CEP não exista
      _showAlertDialog('CEP não encontrado', 'Por favor, verifique o CEP e tente novamente.');
    } else {
      final endereco = Endereco.fromJson(jsonDecodificado);

      setState(() {
        buscaRua = endereco.rua;
        buscaBairro = endereco.bairro;
        buscaCidade = endereco.cidade;
        buscaEstado = endereco.estado;
      });
    }
  } else {
    setState(() {
      buscaRua = '';
      buscaBairro = '';
      buscaCidade = '';
      buscaEstado = '';
    });

    _showAlertDialog('Erro', 'Ocorreu um erro ao buscar o CEP.');
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