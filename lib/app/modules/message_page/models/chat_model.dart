class ChatRequest {
  final String action;
  final String? conversationId;
  final String? text;
  final List<ImagePayload>? images;

  ChatRequest({
    required this.action,
    this.conversationId,
    this.text,
    this.images,
  });

  Map<String, dynamic> toJson() {
    return {
      "action": action,
      if (conversationId != null) "conversationId": conversationId,
      if (text != null) "text": text,
      if (images != null) "images": images!.map((i) => i.toJson()).toList(),
    };
  }
}

class ImagePayload {
  final String imageId;

  ImagePayload({required this.imageId});

  Map<String, dynamic> toJson() {
    return {"imageId": imageId};
  }
}

class ChatEvent {
  final String event;
  final String? conversationId;
  final String? text;

  ChatEvent({required this.event, this.conversationId, this.text});

  factory ChatEvent.fromJson(Map<String, dynamic> json) {
    return ChatEvent(
      event: json['event'] ?? 'UNKNOWN',
      conversationId: json['conversationId'],
      text: json['text'],
    );
  }
}

class ChatMessage {
  String content;
  final bool isUser;
  bool isStreaming;

  ChatMessage({
    required this.content,
    required this.isUser,
    this.isStreaming = false,
  });
}
