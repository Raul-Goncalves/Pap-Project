import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class ubiScreen extends StatefulWidget {
  const ubiScreen({super.key});

  @override
  State<ubiScreen> createState() => _ubiScreenState();
}

class _ubiScreenState extends State<ubiScreen> {
  List<dynamic> stops = [];

  @override
  void initState() {
    super.initState();
    _loadStops();
  }


  Future<void> _loadStops() async {
    try {
      String data = await rootBundle.loadString('assets/rotas/rotaUBI_IDA.json');
      final jsonResult = json.decode(data);
      List<dynamic> routes = jsonResult['rota'];

      if (routes != null && routes.isNotEmpty) {
        setState(() {
          var line11 = routes.firstWhere((route) => route['line'] == 1,
              orElse: () => null);
          if (line11 != null) {
            stops = line11['stops'];
            stops = stops.where((stop) => stop["name"] != "ponto").toList();
          } else {
            print('Nenhuma linha com ID 1 encontrada.');
          }
        });
      } else {
        print('Nenhuma rota carregada.');
      }
    } catch (e) {
      print('Erro ao carregar rotas: $e');
    }
  }

  void _goToHomeScreen(double latitude, double longitude, String stopName) {
    Navigator.pushNamed(
      context,
      '/homeScreen',
      arguments: {
        'latitude': latitude,
        'longitude': longitude,
        'stopName': stopName,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade900,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Rota do Onibus UBI:",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: stops.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: stops.length,
          itemBuilder: (context, index) {
            var stop = stops[index];
            String id = stop['id'].toString();
            String name = stop['name'] ?? 'Nome não disponível';
            double latitude = double.parse(stop['latitude'].toString());
            double longitude = double.parse(stop['longitude'].toString());

            return Container(
              margin: EdgeInsets.symmetric(vertical: 5.0),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '$id - $name',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.location_on, color: Colors.indigo.shade900),
                    onPressed: () {
                      _goToHomeScreen(latitude, longitude, name);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

