import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:xnusa_mobile/app/modules/message_page/models/chat_model.dart';

class Websocket {
  WebSocketChannel? _channel;
  final String _wsUrl = 'ws://327301e81fe7.ngrok-free.app/nusaai/api/ws/chat';

  void connect() {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(_wsUrl));
      print("WS: Connected");
    } catch (e) {
      print("WS Error: $e");
    }
  }

  void sendRequest(ChatRequest request) {
    if (_channel != null) {
      final jsonString = jsonEncode(request.toJson());
      print("WS Sending: $jsonString");
      _channel!.sink.add(jsonString);
    } else {
      print("WS Error: Channel is null");
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
