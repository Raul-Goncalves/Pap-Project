import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionService {
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/directions/json';
  final String apiKey;

  DirectionService({required this.apiKey});

  Future<List<LatLng>> getRouteCoordinates(LatLng start, LatLng end) async {
    final String url = '$_baseUrl?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<LatLng> routeCoords = [];

      if (data['routes'] != null && data['routes'].isNotEmpty) {
        data['routes'][0]['legs'][0]['steps'].forEach((step) {
          routeCoords.add(LatLng(
            step['end_location']['lat'],
            step['end_location']['lng'],
          ));
        });
      }

      return routeCoords;
    } else {
      throw Exception('Failed to load directions');
    }
  }
}
