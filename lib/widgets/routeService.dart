import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class routeService{
  final String apiKey;

  routeService({required this.apiKey});

  Future<Set<Polyline>> getRouteBetweenStops(List<dynamic> stops) async {
    Set<Polyline> polylines = {};

    try {
      for (int i = 0; i < stops.length - 1; i++) {
        String origin = '${stops[i]['latitude']},${stops[i]['longitude']}';
        String destination = '${stops[i + 1]['latitude']},${stops[i + 1]['longitude']}';
        String url =
            'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$apiKey';

        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          Map<String, dynamic> data = json.decode(response.body);
          List<LatLng> routePoints = [];

          if (data['routes'] != null && data['routes'].isNotEmpty) {
            List<dynamic> legs = data['routes'][0]['legs'];
            for (var leg in legs) {
              List<dynamic> steps = leg['steps'];
              for (var step in steps) {
                String polylinePoints = step['polyline']['points'];
                List<LatLng> decodedPoints = _decodePolyline(polylinePoints);
                routePoints.addAll(decodedPoints);
              }
            }
          }

          Polyline segmentPolyline = Polyline(
            polylineId: PolylineId('${stops[i]['name']}-${stops[i + 1]['name']}'),
            color: Colors.indigo.shade900.withOpacity(0.5),
            width: 5,
            points: routePoints,
          );

          polylines.add(segmentPolyline);
        } else {
          print('Falha ao carregar rota entre ${stops[i]['name']} e ${stops[i + 1]['name']}: ${response.statusCode}');
          return polylines;
        }
      }
    } catch (e) {
      print('Erro ao carregar rota: $e');
    }

    return polylines;
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = PolylinePoints()
        .decodePolyline(encoded)
        .map((PointLatLng point) => LatLng(point.latitude, point.longitude))
        .toList();
    return points;
  }

}