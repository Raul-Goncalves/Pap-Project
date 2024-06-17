import 'dart:convert';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionService {
  final String apiKey;

  DirectionService({required this.apiKey});

  Future<DirectionsResponse> route({
    required String origin,
    required String destination,
    required TravelMode travelMode,
  }) async {
    String url = 'https://maps.googleapis.com/maps/api/directions/json?' +
        'origin=$origin' +
        '&destination=$destination' +
        '&mode=${_parseTravelMode(travelMode)}' +
        '&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return DirectionsResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load directions');
    }
  }

  String _parseTravelMode(TravelMode mode) {
    switch (mode) {
      case TravelMode.driving:
        return 'driving';
      case TravelMode.transit:
        return 'transit';
      case TravelMode.bicycling:
        return 'bicycling';
      case TravelMode.walking:
        return 'walking';
      default:
        throw Exception('Unknown travel mode');
    }
  }
}

class DirectionsResponse {
  final bool isOkay;
  final String? errorMessage;
  final List<Route> routes;

  DirectionsResponse({
    required this.isOkay,
    this.errorMessage,
    required this.routes,
  });

  factory DirectionsResponse.fromJson(Map<String, dynamic> json) {
    List<Route> routes = [];
    if (json['routes'] != null) {
      json['routes'].forEach((route) {
        routes.add(Route.fromJson(route));
      });
    }
    return DirectionsResponse(
      isOkay: json['status'] == 'OK',
      errorMessage: json['error_message'],
      routes: routes,
    );
  }
}

class Route {
  final OverviewPolyline? overviewPolyline;

  Route({this.overviewPolyline});

  factory Route.fromJson(Map<String, dynamic> json) {
    return Route(
      overviewPolyline: json['overview_polyline'] != null
          ? OverviewPolyline.fromJson(json['overview_polyline'])
          : null,
    );
  }
}

class OverviewPolyline {
  final String? points;

  OverviewPolyline({this.points});

  factory OverviewPolyline.fromJson(Map<String, dynamic> json) {
    return OverviewPolyline(
      points: json['points'],
    );
  }
}
