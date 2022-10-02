class LichessCompat {
  late final bool bot;
  late final bool board;

  LichessCompat({required this.bot, required this.board});

  LichessCompat.fromJson(Map<String, dynamic> json) {
    bot = json['bot'];
    board = json['board'];
  }

  Map<String, dynamic> toJson() {
    return {
      "bot": bot,
      "board": board,
    };
  }
}