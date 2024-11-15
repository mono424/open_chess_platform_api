library open_chess_platform_api;

import 'package:open_chess_platform_api/platforms/lichess/models/lichess_count.dart';
import 'package:open_chess_platform_api/platforms/lichess/models/lichess_user.dart';

class LichessAccount extends LichessUser {
  late LichessCount count;
  late bool followable;
  late bool following;
  late bool blocking;

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
      required this.count,
      required this.followable,
      required this.following,
      required this.blocking})
      : super(
            userId: userId,
            username: username,
            online: online,
            userRatings: userRatings,
            createdAt: createdAt,
            seenAt: seenAt,
            playTime: playTime,
            language: language,
            url: url,
            disabled: false);

  LichessAccount.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    count = LichessCount.fromJson(json['count']);
    followable = json['followable'];
    following = json['following'];
    blocking = json['blocking'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['count'] = count.toJson();
    data['followable'] = followable;
    data['following'] = following;
    data['blocking'] = blocking;
    return data;
  }
}
