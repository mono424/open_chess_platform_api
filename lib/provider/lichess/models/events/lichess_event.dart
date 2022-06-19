library chess_cloud_provider;

import 'package:chess_cloud_provider/models/provider_event.dart';
import 'package:chess_cloud_provider/provider/lichess/models/events/lichess_event_challenge.dart';
import 'package:chess_cloud_provider/provider/lichess/models/events/lichess_event_challenge_canceled.dart';
import 'package:chess_cloud_provider/provider/lichess/models/events/lichess_event_challenge_declined.dart';
import 'package:chess_cloud_provider/provider/lichess/models/events/lichess_event_game_finish.dart';
import 'package:chess_cloud_provider/provider/lichess/models/events/lichess_event_game_started.dart';

abstract class LichessEvent extends ProviderEvent {
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
