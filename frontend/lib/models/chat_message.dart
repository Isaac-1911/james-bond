class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({
    required this.text,
    required this.isUser,
  });

  factory ChatMessage.user(String text) {
    return ChatMessage(text: text, isUser: true);
  }

  factory ChatMessage.ai(String text) {
    return ChatMessage(text: text, isUser: false);
  }
}
