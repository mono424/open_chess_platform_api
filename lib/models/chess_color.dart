library open_chess_platform_api;

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
