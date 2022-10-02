library open_chess_platform_api;

import 'package:open_chess_platform_api/models/platform_event.dart';
import 'package:open_chess_platform_api/platforms/lichess/models/events/lichess_event_challenge.dart';
import 'package:open_chess_platform_api/platforms/lichess/models/events/lichess_event_challenge_canceled.dart';
import 'package:open_chess_platform_api/platforms/lichess/models/events/lichess_event_challenge_declined.dart';
import 'package:open_chess_platform_api/platforms/lichess/models/events/lichess_event_game_finish.dart';
import 'package:open_chess_platform_api/platforms/lichess/models/events/lichess_event_game_started.dart';

abstract class LichessEvent extends PlatformEvent {
  late final String type;

  static LichessEvent parseJson(Map<String, dynamic> json) {
    switch (json["type"]) {
      case "gameStart":
        return LichessEventGameStarted.fromJson(json);

      case "gameFinish":
        return LichessEventGameFinish.fromJson(json);

      case "challenge":
        return LichessEventChallenge.fromJson(json);

      case "challengeCanceled":
        return LichessEventChallengeCanceled.fromJson(json);

      case "challengeDeclined":
        return LichessEventChallengeDeclined.fromJson(json);

      default:
        throw Exception("Invalid type");
    }
  }

  LichessEvent.fromJson(Map<String, dynamic> json) {
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    return {
      "type": type,
    };
  }
}
