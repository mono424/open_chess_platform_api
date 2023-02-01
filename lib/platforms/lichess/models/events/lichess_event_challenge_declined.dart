library chess_cloud_provider;

import 'package:chess_cloud_provider/platforms/lichess/models/events/lichess_event.dart';
import 'package:chess_cloud_provider/platforms/lichess/models/lichess_challenge.dart';

// {"type":"challengeDeclined","challenge":{"id":"9gevY8BQ","url":"https://lichess.org/9gevY8BQ","status":"declined","challenger":{"id":"mono425","name":"mono425","title":null,"rating":1500,"provisional":true,"online":true},"destUser":{"id":"mono424","name":"mono424","title":null,"rating":1500,"provisional":true,"online":true},"variant":{"key":"standard","name":"Standard","short":"Std"},"rated":false,"speed":"correspondence","timeControl":{"type":"unlimited"},"color":"random","finalColor":"black","perf":{"icon":"","name":"Correspondence"},"declineReason":"I'm not accepting challenges at the moment."}}

class LichessEventChallengeDeclined extends LichessEvent {
  late final LichessChallenge challenge;

  LichessEventChallengeDeclined.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    challenge = LichessChallenge.fromJson(json['challenge']);
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = super.toJson();
    map['challenge'] = challenge.toJson();
    return map;
  }
}
