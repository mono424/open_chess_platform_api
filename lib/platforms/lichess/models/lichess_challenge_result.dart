library open_chess_platform_api;

import 'package:open_chess_platform_api/models/challenge_result.dart';
import 'package:open_chess_platform_api/platforms/lichess/models/lichess_challenge.dart';

class LichessChallengeResult extends ChallengeResult {
  late LichessChallenge challenge;
  late int socketVersion;

  LichessChallengeResult(
      {required this.challenge,
      required this.socketVersion});

  LichessChallengeResult.fromJson(Map<String, dynamic> json) {
    challenge = LichessChallenge.fromJson(json['challenge']);
    socketVersion = json['socketVersion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['challenge'] = challenge.toJson();
    data['socketVersion'] = socketVersion;
    return data;
  }

  @override
  String getChallengeId() {
    return challenge.id;
  }
}
