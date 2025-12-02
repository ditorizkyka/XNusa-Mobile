import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

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
    final Color textColor = isUser ? Colors.white : Colors.black87;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        decoration: BoxDecoration(
          color: isUser ? Colors.blueAccent : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
            bottomRight: isUser ? Radius.zero : const Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MarkdownBody(
              data: message,
              selectable: true,
              styleSheet: MarkdownStyleSheet(
                // Paragraph
                p: TextStyle(fontSize: 15, height: 1.4, color: textColor),

                // Header
                h1: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
                h2: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                h3: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),

                // List Item (Bullet points)
                listBullet: TextStyle(color: textColor),

                // Code Block
                code: TextStyle(
                  color: isUser ? Colors.white : Colors.black,
                  backgroundColor: isUser ? Colors.white24 : Colors.grey[300],
                  fontFamily: 'monospace',
                  fontSize: 14,
                ),
                codeblockDecoration: BoxDecoration(
                  color: isUser ? Colors.black26 : Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade400),
                ),

                // Quote
                blockquote: TextStyle(color: textColor.withOpacity(0.8)),
                blockquoteDecoration: BoxDecoration(
                  border: Border(left: BorderSide(color: textColor, width: 4)),
                ),
              ),

              // Link
              onTapLink: (text, href, title) {
                print("User tapped link: $href");
              },
            ),

            if (isStreaming)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isUser ? Colors.white70 : Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "...",
                      style: TextStyle(
                        fontSize: 10,
                        fontStyle: FontStyle.italic,
                        color: textColor.withOpacity(0.7),
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
