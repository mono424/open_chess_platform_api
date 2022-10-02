library open_chess_platform_api;

import 'package:open_chess_platform_api/platforms/lichess/models/events/lichess_event.dart';
import 'package:open_chess_platform_api/platforms/lichess/models/lichess_challenge.dart';

// {"type":"challengeCanceled","challenge":{"id":"tB11DEvH","url":"https://lichess.org/tB11DEvH","status":"canceled","challenger":{"id":"mono425","name":"mono425","title":null,"rating":1500,"provisional":true,"online":true},"destUser":{"id":"mono424","name":"mono424","title":null,"rating":1500,"provisional":true,"online":true},"variant":{"key":"standard","name":"Standard","short":"Std"},"rated":false,"speed":"correspondence","timeControl":{"type":"unlimited"},"color":"random","finalColor":"white","perf":{"icon":"","name":"Correspondence"}}}

class LichessEventChallengeCanceled extends LichessEvent {
  late final LichessChallenge challenge;

  LichessEventChallengeCanceled.fromJson(Map<String, dynamic> json)
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
