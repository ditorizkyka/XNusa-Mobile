import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/websocket.dart';
import '../models/chat_model.dart';

class MessagePageController extends GetxController {
  final Websocket _websocket = Websocket();

  final TextEditingController textController = TextEditingController();

  var chatMessages = <ChatMessage>[].obs;
  var currentConversationId = "".obs;
  var isLoading = false.obs;

  bool get isReady => currentConversationId.value.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    _connectAndListen();
    startNewConversation();
  }

  @override
  void onClose() {
    _websocket.disconnect();
    textController.dispose();
    super.onClose();
  }

  void _connectAndListen() {
    _websocket.connect();

    _websocket.messagesStream.listen(
      (rawMessage) {
        try {
          final Map<String, dynamic> jsonMap = jsonDecode(rawMessage);
          final event = ChatEvent.fromJson(jsonMap);
          _handleEvent(event);
        } catch (e) {
          print("Error parsing message: $e");
        }
      },
      onError: (error) {
        print("WS Stream Error: $error");
        // Opt: Handle Reconnect
      },
      onDone: () {
        print("WS Closed");
      },
    );
  }

  void _handleEvent(ChatEvent chatEvent) {
    if (chatEvent.conversationId != null &&
        chatEvent.conversationId!.isNotEmpty) {
      currentConversationId.value = chatEvent.conversationId!;
    }

    switch (chatEvent.event) {
      case 'CONVERSATION_STARTED':
        //TODO...

        print("Conversation started ID: ${chatEvent.conversationId}");
        isLoading.value = false;
        break;

      case 'CONVERSATION_RESUMED':
        // TODO...
        print("Conversation resumed");
        break;

      case 'TOKEN':
        _appendToken(chatEvent.text ?? "");
        break;

      case 'DONE':
        _finalizeMessage();
        break;

      case 'ERROR':
        Get.snackbar("Error", chatEvent.text ?? "Unknown error");
        isLoading.value = false;
        break;

      default:
        //TODO...
        print("Unknown event: ${chatEvent.event}");
    }
  }

  void _appendToken(String token) {
    if (chatMessages.isEmpty || chatMessages.last.isUser) {
      // If the last message was from user or empty.
      chatMessages.add(
        ChatMessage(content: token, isUser: false, isStreaming: true),
      );
    } else {
      // If the last message was from server.
      var lastMsg = chatMessages.last;
      lastMsg.content += token;
      chatMessages.refresh();
    }
  }

  void _finalizeMessage() {
    if (chatMessages.isNotEmpty && !chatMessages.last.isUser) {
      chatMessages.last.isStreaming = false;
      chatMessages.refresh();
    }
    isLoading.value = false;
  }

  // ACTION
  // Start new conversation.
  void startNewConversation() {
    chatMessages.clear();
    currentConversationId.value = "";
    _websocket.sendRequest(ChatRequest(action: "NEW_CONVERSATION"));
  }

  // Send message.
  void sendMessage() {
    String text = textController.text;
    if (text.trim().isEmpty) return;

    if (currentConversationId.value.isEmpty) {
      Get.snackbar("Wait a moment", "Connecting...");
      return;
    }

    chatMessages.add(ChatMessage(content: text, isUser: true));
    isLoading.value = true;

    textController.clear();

    _websocket.sendRequest(
      ChatRequest(
        action: "SEND_MESSAGE",
        conversationId: currentConversationId.value,
        text: text,
      ),
    );
  }
}
