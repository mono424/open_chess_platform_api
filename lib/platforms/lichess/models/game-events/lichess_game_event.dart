library chess_cloud_provider;

import 'package:chess_cloud_provider/models/platform_event.dart';
import 'package:chess_cloud_provider/platforms/lichess/models/game-events/lichess_game_event_chat_line.dart';
import 'package:chess_cloud_provider/platforms/lichess/models/game-events/lichess_game_event_game_full.dart';
import 'package:chess_cloud_provider/platforms/lichess/models/game-events/lichess_game_event_game_state.dart';

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
