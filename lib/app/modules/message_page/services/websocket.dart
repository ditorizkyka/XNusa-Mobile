import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:xnusa_mobile/app/modules/message_page/models/chat_model.dart';

class Websocket {
  WebSocketChannel? _channel;
  bool get isConnected => _channel != null;
  final String _baseUrl = dotenv.env['BASE_URL'] ?? "";

  Future<bool> connect() async {
    try {
      _channel = WebSocketChannel.connect(
        Uri.parse("ws://${_baseUrl}/nusaai/api/ws/chat"),
      );
      print("WS: Attempting to connect...");
      await _channel!.ready;
      print("WS: Connected");
      return true;
    } catch (e) {
      print("WS: Error ($e)");
      _channel = null;
      return false;
    }
  }

  void resetChannel() {
    _channel = null;
  }

  void sendRequest(ChatRequest request) {
    if (_channel != null) {
      final jsonString = jsonEncode(request.toJson());
      print("WS: Sending $jsonString");
      _channel!.sink.add(jsonString);
    } else {
      print("WS: Error (Channel is null)");
    }
  }

  Stream get messagesStream {
    if (_channel != null) {
      return _channel!.stream;
    }
    return const Stream.empty();
  }

  void disconnect() {
    if (_channel != null) {
      _channel!.sink.close(status.goingAway);
    }
  }
}
