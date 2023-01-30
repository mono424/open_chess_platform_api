library open_chess_platform_api;

import 'package:open_chess_platform_api/platforms/lichess/models/events/lichess_event.dart';
import 'package:open_chess_platform_api/platforms/lichess/models/lichess_game.dart';

// {"type":"gameFinish","game":{"fullId":"81MCx9WWleFJ","gameId":"81MCx9WW","fen":"rnbqkbnr/ppp1pppp/8/3p4/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2","color":"white","lastMove":"d7d5","source":"friend","variant":{"key":"standard","name":"Standard"},"speed":"correspondence","perf":"correspondence","rated":false,"hasMoved":true,"opponent":{"id":"mono424","username":"mono424","rating":1500},"isMyTurn":false,"compat":{"bot":false,"board":true},"id":"81MCx9WW"}}

class LichessEventGameFinish extends LichessEvent {
  late final LichessGame game;

  LichessEventGameFinish.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    game = LichessGame.fromJson(json["game"]);
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = super.toJson();
    map['game'] = game.toJson();
    return map;
  }
}
