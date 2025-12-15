import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:xnusa_mobile/constant/constant.dart';
import 'package:xnusa_mobile/constant/themes/colors.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;
  final bool isStreaming;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.isUser,
    this.isStreaming = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.85,
          ),
          decoration: BoxDecoration(
            color: ColorApp.primary,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
              bottomRight: isUser ? Radius.zero : const Radius.circular(16),
            ),
          ),
          child: Text(
            message,
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
      );
    }

    return Container(
      alignment: Alignment.topCenter,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MarkdownBody(
              data: message,
              selectable: true,
              styleSheet: MarkdownStyleSheet(
                //Divider
                horizontalRuleDecoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: ColorApp.primary, width: 1.0),
                  ),
                ),

                // Paragraph
                p: TypographyApp.chatTextDark,
                pPadding: const EdgeInsets.only(bottom: 1),

                // Headers
                h1: TypographyApp.chatHeadline1,
                h1Padding: const EdgeInsets.only(top: 20, bottom: 12),

                h2: TypographyApp.chatHeadline2,
                h2Padding: const EdgeInsets.only(bottom: 10),

                h3: TypographyApp.chatHeadline3,
                h3Padding: const EdgeInsets.only(bottom: 8),

                // List
                listBullet: const TextStyle(fontSize: 16),
                listIndent: 24,
                listBulletPadding: const EdgeInsets.only(bottom: 6),

                // Code Block
                code: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 14,
                  color: Color.fromARGB(255, 92, 201, 65),
                ),
                codeblockDecoration: BoxDecoration(
                  color: const Color(0xFF2D2D2D),
                  borderRadius: BorderRadius.circular(8),
                ),
                codeblockPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 14,
                ),

                // Blockquote
                blockquote: TextStyle(
                  color: Colors.grey.shade800,
                  fontStyle: FontStyle.italic,
                ),
                blockquotePadding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 12,
                ),
                blockquoteDecoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: Colors.grey.shade400, width: 4),
                  ),
                ),
              ),
            ),

            if (isStreaming)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "answering…",
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
