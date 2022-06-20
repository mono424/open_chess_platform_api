library chess_cloud_provider;

import 'package:chess_cloud_provider/provider/lichess/models/game-events/lichess_game_event.dart';

// 

class LichessGameEventChatLine extends LichessGameEvent {
  late final String username;
  late final String text;
  late final String room;

  LichessGameEventChatLine.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    username = json['username'];
    text = json['text'];
    room = json['room'];
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = super.toJson();
    map['username'] = username;
    map['text'] = text;
    map['room'] = room;
    return map;
  }

}