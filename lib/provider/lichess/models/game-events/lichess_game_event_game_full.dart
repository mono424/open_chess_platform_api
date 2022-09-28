library chess_cloud_provider;

import 'package:chess_cloud_provider/provider/lichess/models/game-events/lichess_game_event.dart';
import 'package:chess_cloud_provider/provider/lichess/models/lichess_game_event_player.dart';
import 'package:chess_cloud_provider/provider/lichess/models/lichess_game_event_state.dart';
import 'package:chess_cloud_provider/provider/lichess/models/lichess_perf.dart';
import 'package:chess_cloud_provider/provider/lichess/models/lichess_clock.dart';
import 'package:chess_cloud_provider/provider/lichess/models/lichess_variant.dart';

// {"id":"Z0kuazpE","variant":{"key":"standard","name":"Standard","short":"Std"},"clock":{"initial":1800000,"increment":0},"speed":"classical","perf":{"name":"Classical"},"rated":false,"createdAt":1655719938193,"white":{"id":"mono424","name":"mono424","title":null,"rating":1500,"provisional":true},"black":{"id":"mono425","name":"mono425","title":null,"rating":1500,"provisional":true},"initialFen":"startpos","type":"gameFull","state":{"type":"gameState","moves":"e2e4 b8c6 d2d4 e7e6 d4d5 e6d5 e4d5 c6e7 d5d6 c7d6 g1f3 g8f6 f1d3 b7b6 e1g1 c8b7 f1e1 a8c8 a2a3 c8c5 b2b4 c5g5 f3g5 h7h6 g5f7 e8f7 h2h3 d8c7 d1f3 b7f3 g2g3 c7b7 e1e3","wtime":1580560,"btime":1710370,"winc":0,"binc":0,"status":"started"}}

class LichessGameEventGameFull extends LichessGameEvent {
  late final String id;
  late final LichessVariant variant;
  late final LichessClock? clock;
  late final String speed;
  late final LichessPerf perf;
  late final bool rated;
  late final int createdAt;
  late final GameEventPlayer white;
  late final GameEventPlayer black;
  late final String initialFen;
  late final GameEventState state;

  LichessGameEventGameFull.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    id = json["id"];
    variant = LichessVariant.fromJson(json['variant']);
    if (json['clock'] != null) clock = LichessClock.fromJson(json['clock']);
    speed = json['speed'];
    perf = LichessPerf.fromJson(json['perf']);
    rated = json['rated'];
    createdAt = json['createdAt'];
    white = GameEventPlayer.fromJson(json['white']);
    black = GameEventPlayer.fromJson(json['black']);
    initialFen = json['initialFen'];
    state = GameEventState.fromJson(json['state']);
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = super.toJson();
    map['id'] = id;
    map['variant'] = variant.toJson();
    if (clock != null) map['clock'] = clock!.toJson();
    map['speed'] = speed;
    map['perf'] = perf.toJson();
    map['rated'] = rated;
    map['createdAt'] = createdAt;
    map['white'] = white.toJson();
    map['black'] = black.toJson();
    map['initialFen'] = initialFen;
    map['type'] = type;
    map['state'] = state.toJson();
    return map;
  }
}
