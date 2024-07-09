import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:papproject/Screens/homeScreen.dart';
import 'package:papproject/Screens/lines/n11Screen.dart';

class routeScreen extends StatefulWidget {
  const routeScreen({super.key});

  @override
  _routeScreenState createState() => _routeScreenState();
}

class _routeScreenState extends State<routeScreen> {
  bool isIda = true;

  void toggleRoute() {
    setState(() {
      isIda = !isIda;
    });

    String message = isIda ? "Rota de Ida" : "Rota de Volta";

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey[800]!,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> _loadStopsFromJson(BuildContext context, String jsonPath) async {
    try {
      String data = await rootBundle.loadString(jsonPath);
      final jsonResult = json.decode(data);

      if (jsonResult.containsKey('rota') && jsonResult['rota'] is List) {
        List<dynamic> routes = jsonResult['rota'];

        if (routes.isNotEmpty && routes[0].containsKey('stops') && routes[0]['stops'] is List) {
          List<dynamic> stops = routes[0]['stops'];
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => homeScreen(stops: stops),
            ),
          );
        } else {
          throw Exception('Formato de JSON inesperado');
        }
      } else {
        throw Exception('Formato de JSON inesperado');
      }
    } catch (e) {
      print('Erro ao carregar paragens: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade900,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Rotas",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: toggleRoute,
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 200),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return RotationTransition(
                    turns: animation,
                    child: child,
                  );
                },
                child: Icon(
                  Icons.arrow_forward,
                  key: UniqueKey(),
                  color: isIda ? Colors.green : Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        crossAxisCount: 2,
        children: [
          _buildRouteContainer(context, "UBI", "Universidade", () {
            _loadStopsFromJson(context, "assets/rotas/rotaUBI_IDA.json");
          }),
          _buildRouteContainer(context, "N10", "Biquinha - Terminal", () {
            _loadStopsFromJson(context, "assets/rotas/rota10_IDA.json");
          }),
          _buildRouteContainer(context, "N11", "PoloIV - Hospital", () {
            _loadStopsFromJson(context, "assets/rotas/rota11_IDA.json");
          }),
          _buildRouteContainer(context, "N12", "Biquinha - C.Saúde", () {
            _loadStopsFromJson(context, "assets/rotas/rota12_IDA.json");
          }),
        ],
      ),
    );
  }

  Widget _buildRouteContainer(BuildContext context, String title, String subtitle, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.indigo.shade900,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}