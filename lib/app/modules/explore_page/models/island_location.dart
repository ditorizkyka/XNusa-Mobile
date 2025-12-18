import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class IslandLocation {
  final String name;
  final LatLng position;
  final String description;
  final String info;
  final Color color;

  IslandLocation({
    required this.name,
    required this.position,
    required this.description,
    required this.info,
    required this.color,
  });

  factory IslandLocation.fromJson(Map<String, dynamic> json) {
    return IslandLocation(
      name: json['name'] ?? '',
      position: LatLng(
        double.parse(json['lat'].toString()),
        double.parse(json['lng'].toString()),
      ),
      description: json['description'] ?? '',
      info: json['info'] ?? '',
      color: _hexToColor(json['color_hex']),
    );
  }

  static Color _hexToColor(String? hexString) {
    if (hexString == null) return Colors.blue;
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    try {
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (e) {
      return Colors.blue;
    }
  }
}
