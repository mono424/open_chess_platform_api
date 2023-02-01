library chess_cloud_provider;

enum ChessColorSelection {
  random,
  white,
  black,
}

extension ChessColorSelectionExtension on ChessColorSelection {
  String get text {
    switch (this) {
      case ChessColorSelection.white:
        return "white";
      case ChessColorSelection.black:
        return 'black';
      default:
        return "random";
    }
  }
}
