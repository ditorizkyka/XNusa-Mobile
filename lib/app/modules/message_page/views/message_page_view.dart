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
        title: Image.asset('assets/logo/NusaAI.png', height: SizeApp.h40),
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

      // ✅ BODY: overlay warning di tengah jika isReady == false
      body: Obx(() {
        final bool isReady = controller.currentConversationId.value.isNotEmpty;

        return Stack(
          children: [
            // ======= Konten utama (chat) =======
            Column(
              children: [
                Expanded(
                  child: Obx(() {
                    return ListView(
                      controller: controller.scrollController,
                      padding: EdgeInsets.zero,
                      children: [
                        // Messages
                        ...controller.chatMessages.map(
                          (message) => ChatBubble(
                            message: message.content,
                            isUser: message.isUser,
                            isStreaming: message.isStreaming,
                          ),
                        ),

                        // Status (italic)
                        if (controller.eventStatus.value.isNotEmpty)
                          Container(
                            alignment: Alignment.topCenter,
                            width: double.infinity,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 720),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                ),
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

                        // Suggestion
                        Obx(() {
                          if (controller.suggestion.isEmpty) {
                            return const SizedBox.shrink();
                          }

                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            color: ColorApp.white.withOpacity(0.9),
                            child: Align(
                              alignment: Alignment.center,
                              child: InkWell(
                                onTap: () => controller.onSuggestionClicked(),
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: ColorApp.primary,
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(width: 8),
                                      Text(
                                        controller.suggestion.value,
                                        style: const TextStyle(
                                          color: ColorApp.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(
                                        Icons.arrow_forward,
                                        color: ColorApp.white,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),

                        const SizedBox(height: 10),
                      ],
                    );
                  }),
                ),
              ],
            ),

            // ======= Overlay warning di tengah jika belum ready =======
            if (!isReady)
              Positioned.fill(
                child: IgnorePointer(
                  ignoring:
                      true, // ✅ biar overlay tidak menghalangi scroll (ubah false kalau mau lock)
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            size: 56,
                            color: ColorApp.grey, // gray
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Connecting to Nusa AI...",
                            textAlign: TextAlign.center,
                            style: TypographyApp.headline1.copyWith(
                              fontSize: SizeApp.h16,
                              color: ColorApp.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Please wait a moment. We’re preparing your conversation.",
                            textAlign: TextAlign.center,
                            style: TypographyApp.textLight.copyWith(
                              fontSize: SizeApp.h12,
                              color: ColorApp.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      }),

      // ======= Bottom input =======
      bottomNavigationBar: BottomAppBar(
        color: ColorApp.white,
        surfaceTintColor: ColorApp.white,
        child: Row(
          children: [
            Expanded(
              child: Obx(() {
                final bool isReady =
                    controller.currentConversationId.value.isNotEmpty;

                return Container(
                  decoration: BoxDecoration(
                    color: ColorApp.lightGrey,
                    borderRadius: BorderRadius.circular(SizeApp.h12),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: SizeApp.h16),
                  padding: EdgeInsets.symmetric(
                    vertical: SizeApp.h8,
                    horizontal: SizeApp.w16,
                  ),
                  child: Row(
                    children: [
                      if (!isReady) ...[
                        Icon(
                          Icons.warning_amber_rounded,
                          size: 18,
                          color: Colors.red,
                        ),
                        SizedBox(width: SizeApp.w8),
                      ],
                      Expanded(
                        child: TextField(
                          controller: controller.textController,
                          enabled: isReady,
                          cursorColor: ColorApp.black,
                          decoration: InputDecoration(
                            hintText:
                                isReady ? 'Ask anything..' : 'Connecting...',
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            hintStyle: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              color: ColorApp.grey,
                            ),
                          ),
                          onSubmitted: (_) => controller.sendMessage(),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),

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
    );
  }
}
