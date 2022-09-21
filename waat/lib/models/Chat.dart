class Chat {
  final List<String> typing;
  final List<String> read;
  final List<String> users;
  final String lastMessageTimestamp;
  final String lastMessage;
  final String lastMessageId;
  final String lastMessageType;
  final String lastSenderId;
  final String chatId;
  final bool isGroupChat;

  Chat({
    this.lastMessageTimestamp,
    this.read,
    this.typing,
    this.lastMessageId,
    this.lastMessageType,
    this.chatId,
    this.lastMessage,
    this.lastSenderId,
    this.users,
    this.isGroupChat,
  });
}
