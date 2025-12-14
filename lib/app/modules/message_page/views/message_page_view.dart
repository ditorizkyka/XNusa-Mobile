import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xnusa_mobile/constant/constant.dart';
import '../controllers/message_page_controller.dart';
import '../widgets/chat_bubble.dart';

class MessagePageView extends GetView<MessagePageController> {
  const MessagePageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.white,
      appBar: AppBar(
        backgroundColor: ColorApp.white,
        surfaceTintColor: ColorApp.white,
        title: Text('NusaAI', style: TypographyApp.chatHeadline1),
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
                padding: EdgeInsets.zero,
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
                    Container(
                      alignment: Alignment.topCenter,
                      width: double.infinity,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 720),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                      ),
                    ),
                  const SizedBox(height: 10),
                ],
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: ColorApp.white,
        surfaceTintColor: ColorApp.white,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Expanded(
                child: Obx(() {
                  bool isReady =
                      controller.currentConversationId.value.isNotEmpty;

                  return TextField(
                    controller: controller.textController,
                    enabled: isReady,
                    cursorColor: ColorApp.black,
                    decoration: InputDecoration(
                      hintText: isReady ? 'Ask anything..' : 'Connecting...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: ColorApp.primary,
                          width: 1.0,
                        ),
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
                            child: CircularProgressIndicator(
                              color: ColorApp.primary,
                              strokeWidth: 2,
                            ),
                          ),
                        )
                        : FloatingActionButton(
                          mini: true,
                          foregroundColor: ColorApp.white,
                          hoverColor: ColorApp.lightGrey,
                          onPressed:
                              controller.currentConversationId.value.isEmpty
                                  ? null
                                  : () {
                                    controller.sendMessage();
                                  },
                          backgroundColor: ColorApp.primary,
                          child: const Icon(Icons.send),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
