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
            icon: const Icon(Icons.refresh),
            onPressed: () {
              controller.startNewConversation();
            },
            tooltip: 'Reset',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView(
                controller: controller.scrollController,
                padding: const EdgeInsets.only(bottom: 10),
                children: [
                  ...controller.chatMessages.map(
                    (message) => ChatBubble(
                      message: message.content,
                      isUser: message.isUser,
                      isStreaming: message.isStreaming,
                    ),
                  ),

                  // Status
                  if (controller.eventStatus.value.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 16,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CircleAvatar(
                            radius: 14,
                            child: Icon(Icons.smart_toy, size: 16),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              controller.eventStatus.value,
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Obx(() {
                    bool isReady =
                        controller.currentConversationId.value.isNotEmpty;

                    return TextField(
                      controller: controller.textController,
                      enabled: isReady,
                      decoration: InputDecoration(
                        hintText: isReady ? 'Ask anything..' : 'Connecting...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                      onSubmitted: (value) {
                        controller.sendMessage();
                      },
                    );
                  }),
                ),
                const SizedBox(width: 8),
                Obx(
                  () =>
                      controller.isLoading.value
                          ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                          : FloatingActionButton(
                            mini: true,
                            onPressed:
                                controller.currentConversationId.value.isEmpty
                                    ? null
                                    : () {
                                      controller.sendMessage();
                                    },
                            backgroundColor:
                                controller.currentConversationId.value.isEmpty
                                    ? Colors.grey
                                    : null,
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
