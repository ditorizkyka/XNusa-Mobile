import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/message_page_controller.dart';
import '../widgets/chat_bubble.dart';

class MessagePageView extends GetView<MessagePageController> {
  const MessagePageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NusaAI'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_comment),
            onPressed: () {
              controller.startNewConversation();
            },
            tooltip: 'Mulai Percakapan Baru',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                controller:
                    ScrollController()..addListener(() {
                      if (controller.chatMessages.isNotEmpty &&
                          controller.chatMessages.last.isStreaming &&
                          (ScrollController().position.pixels ==
                              ScrollController().position.maxScrollExtent)) {
                        ScrollController().jumpTo(
                          ScrollController().position.maxScrollExtent,
                        );
                      }
                    }),
                itemCount: controller.chatMessages.length,
                itemBuilder: (context, index) {
                  final message = controller.chatMessages[index];
                  return ChatBubble(
                    message: message.content,
                    isUser: message.isUser,
                    isStreaming: message.isStreaming,
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: TextEditingController(),
                    decoration: InputDecoration(
                      hintText: 'Ketik pesan...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        controller.sendMessage(value);
                        TextEditingController().clear();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Obx(
                  () =>
                      controller.isLoading.value
                          ? const CircularProgressIndicator()
                          : FloatingActionButton(
                            onPressed: () {
                              final text = TextEditingController().text;
                              if (text.isNotEmpty) {
                                controller.sendMessage(text);
                                TextEditingController().clear();
                              }
                            },
                            child: const Icon(Icons.send),
                          ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
