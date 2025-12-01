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
            child: Obx(
              () => ListView.builder(
                padding: const EdgeInsets.only(bottom: 10),
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
