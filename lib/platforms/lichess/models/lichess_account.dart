library open_chess_platform_api;

import 'package:open_chess_platform_api/platforms/lichess/models/lichess_count.dart';
import 'package:open_chess_platform_api/platforms/lichess/models/lichess_user.dart';

class LichessAccount extends LichessUser {
  late int nbFollowing;
  late int nbFollowers;
  late int completionRate;
  late LichessCount count;
  late bool followable;
  late bool following;
  late bool blocking;
  late bool followsYou;

  LichessAccount(
      {required userId,
      required username,
      required online,
      required userRatings,
      required createdAt,
      required seenAt,
      required playTime,
      required language,
      required url,
      required this.nbFollowing,
      required this.nbFollowers,
      required this.completionRate,
      required this.count,
      required this.followable,
      required this.following,
      required this.blocking,
      required this.followsYou})
      : super(
            userId: userId,
            username: username,
            online: online,
            userRatings: userRatings,
            createdAt: createdAt,
            seenAt: seenAt,
            playTime: playTime,
            language: language,
            url: url);

  LichessAccount.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    nbFollowing = json['nbFollowing'];
    nbFollowers = json['nbFollowers'];
    completionRate = json['completionRate'];
    count = LichessCount.fromJson(json['count']);
    followable = json['followable'];
    following = json['following'];
    blocking = json['blocking'];
    followsYou = json['followsYou'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['nbFollowing'] = nbFollowing;
    data['nbFollowers'] = nbFollowers;
    data['completionRate'] = completionRate;
    data['count'] = count.toJson();
    data['followable'] = followable;
    data['following'] = following;
    data['blocking'] = blocking;
    data['followsYou'] = followsYou;
    return data;
  }
}
