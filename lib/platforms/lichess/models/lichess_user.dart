library open_chess_platform_api;

import 'package:flutter/widgets.dart';
import 'package:open_chess_platform_api/chess_platform_user.dart';
import 'package:open_chess_platform_api/models/game_time_type.dart';
import 'package:open_chess_platform_api/platforms/lichess/models/lichess_user_ratings.dart';
import 'package:open_chess_platform_api/platforms/lichess/models/lichess_playtime.dart';
import 'package:open_chess_platform_api/platforms/lichess/models/lichess_rating_info.dart';

class LichessUser extends ChessPlatformUser {
  late String userId;
  late String username;
  late bool online;
  late LichessUserRatings userRatings;
  late int createdAt;
  late int seenAt;
  late LichessPlayTime playTime;
  late String language;
  late String url;

  LichessUser(
      {required this.userId,
      required this.username,
      required this.online,
      required this.userRatings,
      required this.createdAt,
      required this.seenAt,
      required this.playTime,
      required this.language,
      required this.url});

  LichessRatingInfo getRating(GameTimeType type) {
    switch (type) {
      case GameTimeType.bullet:
        return userRatings.bullet;
      case GameTimeType.blitz:
        return userRatings.blitz;
      case GameTimeType.rapid:
        return userRatings.rapid;
      case GameTimeType.classical:
        return userRatings.classical;
      case GameTimeType.correspondence:
        return userRatings.correspondence;
      default:
        return userRatings.classical;
    }
  }

  LichessUser.fromJson(Map<String, dynamic> json) {
    userId = (json['id'] != null && json['id'] is String) ? json['id'] : null;
    username = json['username'];
    online = json['online'];
    userRatings = LichessUserRatings.fromJson(json['perfs']);
    createdAt = json['createdAt'];
    seenAt = json['seenAt'];
    playTime = LichessPlayTime.fromJson(json['playTime']);
    language = json['language'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = userId;
    data['username'] = username;
    data['online'] = online;
    data['perfs'] = userRatings.toJson();
    data['createdAt'] = createdAt;
    data['seenAt'] = seenAt;
    data['playTime'] = playTime.toJson();
    data['language'] = language;
    data['url'] = url;
    return data;
  }

  @override
  bool operator ==(other) => other is LichessUser && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String get biography => "";

  @override
  String get displayName => username;

  @override
  ImageProvider<Object> get imageSrc =>
      const AssetImage("lib/platforms/lichess/assets/logo.png");

  @override
  String get id => userId;
}
