library open_chess_platform_api;

import 'package:open_chess_platform_api/models/challenge_result.dart';
import 'package:open_chess_platform_api/platforms/lichess/models/lichess_challenge.dart';

class LichessChallengeResult extends ChallengeResult {
  late LichessChallenge challenge;
  late int socketVersion;
  late String urlWhite;
  late String urlBlack;

  LichessChallengeResult(
      {required this.challenge,
      required this.socketVersion,
      required this.urlWhite,
      required this.urlBlack});

  LichessChallengeResult.fromJson(Map<String, dynamic> json) {
    challenge = LichessChallenge.fromJson(json['challenge']);
    socketVersion = json['socketVersion'];
    urlWhite = json['urlWhite'];
    urlBlack = json['urlBlack'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['challenge'] = challenge.toJson();
    data['socketVersion'] = socketVersion;
    data['urlWhite'] = urlWhite;
    data['urlBlack'] = urlBlack;
    return data;
  }

  @override
  String getChallengeId() {
    return challenge.id;
  }
}
