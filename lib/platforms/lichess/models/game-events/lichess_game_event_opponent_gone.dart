library chess_cloud_provider;

import 'package:chess_cloud_provider/platforms/lichess/models/game-events/lichess_game_event.dart';

// { "type": "opponentGone", "gone": true, "claimWinInSeconds": 8 }

class LichessGameEventOponnentGone extends LichessGameEvent {
  late final bool gone;
  late final int claimWinInSeconds;

  LichessGameEventOponnentGone.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    gone = json['gone'];
    claimWinInSeconds = json['claimWinInSeconds'] ?? 0;
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = super.toJson();
    map['gone'] = gone;
    map['claimWinInSeconds'] = claimWinInSeconds;
    return map;
  }
}
