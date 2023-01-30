library open_chess_platform_api;

import 'package:open_chess_platform_api/platforms/lichess/models/game-events/lichess_game_event.dart';

// {"type":"gameState","moves":"e2e4 b8c6 d2d4 e7e6 d4d5 e6d5 e4d5 c6e7 d5d6 c7d6 g1f3 g8f6 f1d3 b7b6 e1g1 c8b7 f1e1 a8c8 a2a3 c8c5 b2b4 c5g5 f3g5 h7h6 g5f7 e8f7 h2h3 d8c7 d1f3 b7f3 g2g3 c7b7","wtime":1592490,"btime":1716180,"winc":0,"binc":0,"status":"started"}

class LichessGameEventGameState extends LichessGameEvent {
  late final String moves;
  late final int wtime;
  late final int btime;
  late final int winc;
  late final int binc;
  late final bool wdraw;
  late final bool bdraw;
  late final String? winner;
  late final String status;

  LichessGameEventGameState.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    moves = json['moves'];
    wtime = json['wtime'];
    btime = json['btime'];
    winc = json['winc'];
    binc = json['binc'];
    bdraw = json['bdraw'] ?? false;
    wdraw = json['wdraw'] ?? false;
    winner = json['winner'];
    status = json['status'];
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = super.toJson();
    map['type'] = type;
    map['moves'] = moves;
    map['wtime'] = wtime;
    map['btime'] = btime;
    map['winc'] = winc;
    map['binc'] = binc;
    map['bdraw'] = bdraw;
    map['wdraw'] = wdraw;
    if (winner != null) map['winner'] = winner;
    map['status'] = status;
    return map;
  }
}
