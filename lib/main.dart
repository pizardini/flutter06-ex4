import 'dart:convert';
import 'dart:core';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'moeda.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(home: const MainApp()));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final TextEditingController _dataController = TextEditingController();
  var cot2024 = '';
  var cot2023 = '';
  var cot2022 = '';
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _updateDateController(_selectedDate);
  }

  void _updateDateController(DateTime date) {
  String formattedDate = DateFormat('yyyy-MM-dd').format(date);
  _dataController.text = formattedDate;
}

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _updateDateController(_selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              TextField(
                controller: _dataController,
                decoration: const InputDecoration(labelText: 'Data selecionada'),
                readOnly: true,
                onTap: () => _selectDate(context),
              ),
              Text('Cotação do dólar em 2024: $cot2024'),
              Text('Cotação do dólar em 2021: $cot2023'),
              Text('Cotação do dólar em 2022: $cot2022'),
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
  String data = _dataController.text;
  DateTime dataDateTime = DateTime.parse(data);

  List<String> cotacoes = [];

  for (int anos = 0; anos <= 2; anos++) {
    DateTime dataModificada = DateTime(dataDateTime.year - anos, dataDateTime.month, dataDateTime.day);
    DateTime dataSubtraida = DateTime(dataModificada.year, dataModificada.month, dataModificada.day - 1);

    String data1 = DateFormat('yyyyMMdd').format(dataSubtraida);
    String data2 = DateFormat('yyyyMMdd').format(dataModificada);

    String url = 'https://economia.awesomeapi.com.br/json/daily/USD-BRL/?start_date=$data1&end_date=$data2';

    final resposta = await http.get(Uri.parse(url));

    if (resposta.statusCode == 200) {

      final jsonDecodificado = jsonDecode(resposta.body);
      final moeda = Moeda.fromJson(jsonDecodificado[0]);

      cotacoes.add(moeda.bid.toString());

    } else {
      _showAlertDialog('Erro', 'Ocorreu um erro ao buscar a moeda.');
    }
  }

  setState(() {
    cot2024 = cotacoes[0];
    cot2023 = cotacoes[1];
    cot2022 = cotacoes[2];
  });
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