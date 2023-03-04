library chess_cloud_provider;

enum ChessColor {
  random,
  white,
  black,
}

extension ChessColorExtension on ChessColor {
  String get text {
    switch (this) {
      case ChessColor.white:
        return "white";
      case ChessColor.black:
        return 'black';
      default:
        return "random";
    }
  }
}
