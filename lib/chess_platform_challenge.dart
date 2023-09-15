library open_chess_platform_api;

abstract class ChessPlatformChallenge {
  String get id;

  /// The id of the sender
  dynamic get senderId;

  /// The name of the sender
  String get senderName;

  /// The id of the receiver
  dynamic get receiverId;

  /// The name of the receiver
  String get receiverName;
}
