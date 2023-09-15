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
  late bool disabled;

  LichessUser(
      {required this.userId,
      required this.username,
      required this.online,
      required this.userRatings,
      required this.createdAt,
      required this.seenAt,
      required this.playTime,
      required this.language,
      required this.disabled,
      required this.url});

  @override
  int getRating(GameTimeType type) {
    return getRatingInfo(type).rating;
  }

  LichessRatingInfo getRatingInfo(GameTimeType type) {
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

  /// This handles also disabled users
  static LichessUser parseJson(Map<String, dynamic> json) {
    final disabled = json["disabled"] ?? false;

    if (disabled) {
      final userId = (json['id'] != null && json['id'] is String) ? json['id'] : null;
      final username = json['username'];
      final url = json['url'];
      return LichessUser(
        userId: userId,
        username: username,
        url: url,
        disabled: disabled,
        online: false,
        userRatings: LichessUserRatings(
          blitz: LichessRatingInfo(games: 0, prog: 0, prov: false, rating: 0, rd: 0),
          bullet: LichessRatingInfo(games: 0, prog: 0, prov: false, rating: 0, rd: 0),
          classical: LichessRatingInfo(games: 0, prog: 0, prov: false, rating: 0, rd: 0),
          rapid: LichessRatingInfo(games: 0, prog: 0, prov: false, rating: 0, rd: 0),
          correspondence: LichessRatingInfo(games: 0, prog: 0, prov: false, rating: 0, rd: 0)
        ),
        createdAt: 0,
        seenAt: 0,
        playTime: LichessPlayTime(total: 0, tv: 0),
        language: "",
      );
    }

    return LichessUser.fromJson(json);
  }

  LichessUser.fromJson(Map<String, dynamic> json) {
    userId = (json['id'] != null && json['id'] is String) ? json['id'] : null;
    username = json['username'];
    online = json['online'] ?? false;
    userRatings = LichessUserRatings.fromJson(json['perfs']);
    createdAt = json['createdAt'];
    seenAt = json['seenAt'];
    playTime = LichessPlayTime.fromJson(json['playTime']);
    language = json['language'] ?? "";
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
  ImageProvider<Object> get imageSrc => const AssetImage("assets/lichess.png",
      package: "open_chess_platform_api");

  @override
  String get id => userId;
}
