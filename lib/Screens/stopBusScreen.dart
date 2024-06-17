import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class stopBusScreen extends StatefulWidget {
  @override
  _stopBusScreen createState() => _stopBusScreen();
}

class _stopBusScreen extends State<stopBusScreen> {
  List<dynamic> stops = [];

  @override
  void initState() {
    super.initState();
    _loadStops();
  }

  Future<void> _loadStops() async {
    try {
      String data = await rootBundle.loadString('assets/routes.json');
      final jsonResult = json.decode(data);
      List<dynamic> routes = jsonResult['routes'];

      if (routes != null && routes.isNotEmpty) {
        setState(() {
          var line11 = routes.firstWhere((route) => route['line'] == 11, orElse: () => null);
          if (line11 != null) {
            stops = line11['stops'];
          } else {
            print('Nenhuma linha com ID 11 encontrada.');
          }
        });
      } else {
        print('Nenhuma rota carregada.');
      }
    } catch (e) {
      print('Erro ao carregar rotas: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paradas da Rota ID 11'),
      ),
      body: stops.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: stops.length,
        itemBuilder: (context, index) {
          var stop = stops[index];
          return ListTile(
            title: Text('${stop['id']}. ${stop['name'] ?? 'Nome não disponível'}'),
          );
        },
      ),
    );
  }
}