import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/ingestion_model.dart';

class Ingestion {
  final String _baseUrl = dotenv.env['BASE_URL'] ?? '';

  Future<String?> getIngestionKey() async {
    final envKey = dotenv.env['INGESTION_KEY'];
    if (envKey != null && envKey.isNotEmpty) {
      return envKey;
    }
    return null;
  }

  Future<IngestionResponse> ingest({
    required String description,
    Map<String, dynamic>? metadata,
  }) async {
    final key = await getIngestionKey();

    if (key == null || key.isEmpty) {
      throw Exception('Ingestion key not available.');
    }

    final uri = Uri.parse('https://${_baseUrl}/nusaai/api/ingest/thread');

    final body = jsonEncode({
      'description': description,
      'metadata': metadata ?? {},
    });

    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json', 'INGESTION-KEY': key},
      body: body,
    );

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      try {
        final Map<String, dynamic> json = jsonDecode(resp.body);
        return IngestionResponse.fromJson(json);
      } catch (e) {
        throw Exception('Ingestion: failed to parse JSON body: ${resp.body}');
      }
    }

    try {
      final Map<String, dynamic> json = jsonDecode(resp.body);
      return IngestionResponse.fromJson(json);
    } catch (_) {
      throw Exception('Ingestion failed: HTTP ${resp.statusCode} ${resp.body}');
    }
  }
}
