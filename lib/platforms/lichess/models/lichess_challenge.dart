library chess_cloud_provider;

import 'package:chess_cloud_provider/chess_platform_challenge.dart';
import 'package:chess_cloud_provider/platforms/lichess/models/lichess_challeng_participant.dart';
import 'package:chess_cloud_provider/platforms/lichess/models/lichess_perf.dart';
import 'package:chess_cloud_provider/platforms/lichess/models/lichess_time_control.dart';
import 'package:chess_cloud_provider/platforms/lichess/models/lichess_variant.dart';

class LichessChallenge extends ChessPlatformChallenge {
  late String lId;
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

  @override
  get id => lId;

  @override
  get senderId => challenger.id;
  
  @override
  String get senderName => challenger.name;
  
  @override
  get receiverId => destUser.id;
  
  @override
  String get receiverName => destUser.name;


  LichessChallenge(
      {required this.lId,
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
    lId = json['id'];
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
    data['id'] = lId;
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
