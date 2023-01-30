library open_chess_platform_api;

import 'package:open_chess_platform_api/chess_platform_challenge.dart';
import 'package:open_chess_platform_api/platforms/lichess/models/lichess_challeng_participant.dart';
import 'package:open_chess_platform_api/platforms/lichess/models/lichess_perf.dart';
import 'package:open_chess_platform_api/platforms/lichess/models/lichess_time_control.dart';
import 'package:open_chess_platform_api/platforms/lichess/models/lichess_variant.dart';

class LichessChallenge extends ChessPlatformChallenge {
  @override
  late String id;

  late String url;
  late String status;
  late LichessChallengParticipant challenger;
  late LichessChallengParticipant destUser;
  late LichessVariant variant;
  late bool rated;
  late String speed;
  late LichessTimeControl timeControl;
  late String color;
  late LichessPerf perf;

  LichessChallenge(
      {required this.id,
      required this.url,
      required this.status,
      required this.challenger,
      required this.destUser,
      required this.variant,
      required this.rated,
      required this.speed,
      required this.timeControl,
      required this.color,
      required this.perf});

  LichessChallenge.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    status = json['status'];
    challenger = LichessChallengParticipant.fromJson(json['challenger']);
    destUser = LichessChallengParticipant.fromJson(json['destUser']);
    variant = LichessVariant.fromJson(json['variant']);
    rated = json['rated'];
    speed = json['speed'];
    timeControl = LichessTimeControl.fromJson(json['timeControl']);
    color = json['color'];
    perf = LichessPerf.fromJson(json['perf']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['url'] = url;
    data['status'] = status;
    data['challenger'] = challenger.toJson();
    data['destUser'] = destUser.toJson();
    data['variant'] = variant.toJson();
    data['rated'] = rated;
    data['speed'] = speed;
    data['timeControl'] = timeControl.toJson();
    data['color'] = color;
    data['perf'] = perf.toJson();
    return data;
  }
}
