class ChatMessageModel {
  String message;
  String socketId;
  bool isLeft;

  ChatMessageModel(
      {required this.message, required this.socketId, required this.isLeft});
}
