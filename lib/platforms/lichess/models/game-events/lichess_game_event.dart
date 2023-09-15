library open_chess_platform_api;

import 'package:open_chess_platform_api/models/platform_event.dart';
import 'package:open_chess_platform_api/platforms/lichess/models/game-events/lichess_game_event_chat_line.dart';
import 'package:open_chess_platform_api/platforms/lichess/models/game-events/lichess_game_event_game_full.dart';
import 'package:open_chess_platform_api/platforms/lichess/models/game-events/lichess_game_event_game_state.dart';
import 'package:open_chess_platform_api/platforms/lichess/models/game-events/lichess_game_event_opponent_gone.dart';

abstract class LichessGameEvent extends PlatformEvent {
  late final String type;

  static LichessGameEvent parseJson(Map<String, dynamic> json) {
    switch (json["type"]) {
      case "gameFull":
        return LichessGameEventGameFull.fromJson(json);

      case "gameState":
        return LichessGameEventGameState.fromJson(json);

      case "chatLine":
        return LichessGameEventChatLine.fromJson(json);

      case "opponentGone":
        return LichessGameEventOponnentGone.fromJson(json);

      default:
        throw Exception("Invalid type");
    }
  }

  LichessGameEvent.fromJson(Map<String, dynamic> json) {
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    return {
      "type": type,
    };
  }
}
