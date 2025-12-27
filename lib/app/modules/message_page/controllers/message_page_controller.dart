import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xnusa_mobile/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:xnusa_mobile/app/modules/explore_page/controllers/explore_page_controller.dart';
import 'package:xnusa_mobile/app/modules/explore_page/models/island_location.dart';
import '../services/websocket.dart';
import '../models/chat_model.dart';

class MessagePageController extends GetxController {
  final Websocket _websocket = Websocket();

  final TextEditingController textController = TextEditingController();
  final scrollController = ScrollController();

  var chatMessages = <ChatMessage>[].obs;
  var currentConversationId = "".obs;
  var isLoading = false.obs;
  var eventStatus = "".obs;
  var autoScrollEnabled = true.obs;

  var suggestion = "".obs;
  VoidCallback? suggestionAction;

  bool get isReady => currentConversationId.value.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_autoScroll);
  }

  @override
  void onReady() async {
    super.onReady();
    await _connectAndListen();
    startNewConversation();
  }

  @override
  void onClose() {
    _websocket.disconnect();
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void _autoScroll() {
    if (!scrollController.hasClients) return;

    final position = scrollController.position;

    if (position.pixels < position.maxScrollExtent - 50) {
      autoScrollEnabled.value = false;
      return;
    }

    autoScrollEnabled.value = true;
  }

  void _smoothScrollToBottom() {
    if (!scrollController.hasClients) return;
    if (!autoScrollEnabled.value) return;

    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 1),
      curve: Curves.easeOut,
    );
  }

  Future<void> _connectAndListen() async {
    bool success = await _websocket.connect();

    if (!success) {
      isLoading.value = false;
      // Get.snackbar(
      //   "Websocket connection failed",
      //   "Can't connect to the server.",
      // );
      return;
    }

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
        _websocket.resetChannel();
        print("WS: Error ($error)");
        // Opt: Handle Reconnect
      },
      onDone: () {
        _websocket.resetChannel();
        _setStatus("Connection closed.");
        print("WS: Closed");
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

      case 'STATUS':
        _setStatus(chatEvent.text ?? "");
        break;

      case 'LOCATION':
        String suggestionText = "See ${chatEvent.text}";
        _showSuggestion(suggestionText, () {
          _navigateToExplore(chatEvent.text!);
        });
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
      eventStatus.value = "";
      chatMessages.add(
        ChatMessage(content: token, isUser: false, isStreaming: true),
      );
    } else {
      // If the last message was from server.
      var lastMsg = chatMessages.last;
      lastMsg.content += token;
      chatMessages.refresh();
    }
    Future.delayed(const Duration(milliseconds: 1), _smoothScrollToBottom);
  }

  void _finalizeMessage() {
    if (chatMessages.isNotEmpty && !chatMessages.last.isUser) {
      chatMessages.last.isStreaming = false;
      chatMessages.refresh();
    }
    isLoading.value = false;
  }

  void _setStatus(String status) {
    eventStatus.value = status.trim();
  }

  void _showSuggestion(String text, VoidCallback action) {
    suggestion.value = text;
    suggestionAction = action;
  }

  void _navigateToExplore(String location) {
    ExplorePageController explorePageController;
    DashboardController dashboardController;

    if (Get.isRegistered<ExplorePageController>() &&
        Get.isRegistered<DashboardController>()) {
      explorePageController = Get.find<ExplorePageController>();
      dashboardController = Get.find<DashboardController>();
    } else {
      explorePageController = Get.put(ExplorePageController());
      dashboardController = Get.put(DashboardController());
    }

    explorePageController.fetchDynamicIslands(location);

    dashboardController.changeIndex(2);
  }

  // ACTION
  // Start new conversation.
  void startNewConversation() async {
    if (!_websocket.isConnected) {
      print("WS: Reconnecting...");
      await _connectAndListen();
      if (!_websocket.isConnected) return;
    }

    isLoading = false.obs;
    chatMessages.clear();
    currentConversationId.value = "";
    eventStatus.value = "";
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
    suggestion.value = "";

    textController.clear();

    _websocket.sendRequest(
      ChatRequest(
        action: "SEND_MESSAGE",
        conversationId: currentConversationId.value,
        text: text,
      ),
    );
  }

  // Suggestion
  void onSuggestionClicked() {
    suggestion.value = "";

    if (suggestionAction != null) {
      suggestionAction!();
    }

    suggestion.value = "";
    suggestionAction = null;
  }
}
