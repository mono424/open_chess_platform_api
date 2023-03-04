library chess_cloud_provider;

import 'package:chess_cloud_provider/platforms/lichess/models/events/lichess_event.dart';
import 'package:chess_cloud_provider/platforms/lichess/models/lichess_game_info.dart';

// {"type":"gameStart","game":{"fullId":"Pl7c8tq188TF","gameId":"Pl7c8tq1","fen":"rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1","color":"white","lastMove":"","source":"friend","variant":{"key":"standard","name":"Standard"},"speed":"correspondence","perf":"correspondence","rated":false,"hasMoved":false,"opponent":{"id":"mono424","username":"mono424","rating":1500},"isMyTurn":true,"compat":{"bot":false,"board":true},"id":"Pl7c8tq1"}}

class LichessEventGameStarted extends LichessEvent {
  late final LichessGameInfo game;

  LichessEventGameStarted.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    game = LichessGameInfo.fromJson(json["game"]);
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = super.toJson();
    map['game'] = game.toJson();
    return map;
  }
}
