library chess_cloud_provider;

import 'package:chess_cloud_provider/platforms/lichess/models/game-events/lichess_game_event.dart';
import 'package:chess_cloud_provider/platforms/lichess/models/lichess_game_event_state.dart';

// {"type":"gameState","moves":"e2e4 b8c6 d2d4 e7e6 d4d5 e6d5 e4d5 c6e7 d5d6 c7d6 g1f3 g8f6 f1d3 b7b6 e1g1 c8b7 f1e1 a8c8 a2a3 c8c5 b2b4 c5g5 f3g5 h7h6 g5f7 e8f7 h2h3 d8c7 d1f3 b7f3 g2g3 c7b7","wtime":1592490,"btime":1716180,"winc":0,"binc":0,"status":"started"}

class LichessGameEventGameState extends LichessGameEvent {
  late final GameEventState? state;

  LichessGameEventGameState.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    state = GameEventState.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = super.toJson();

    final lstate = state;
    if (lstate != null) {
      map.addAll(lstate.toJson());
    }
    
    return map;
  }
}
