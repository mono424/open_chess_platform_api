library chess_cloud_provider;

import 'package:chess_cloud_provider/provider/lichess/models/lichess_rating_info.dart';

class LichessUserRatings {
  late LichessRatingInfo blitz;
  late LichessRatingInfo bullet;
  late LichessRatingInfo correspondence;
  late LichessRatingInfo classical;
  late LichessRatingInfo rapid;

  LichessUserRatings(
      {required this.blitz,
      required this.bullet,
      required this.correspondence,
      required this.classical,
      required this.rapid});

  LichessUserRatings.fromJson(Map<String, dynamic> json) {
    blitz = json['blitz'] != null ? LichessRatingInfo.fromJson(json['blitz']) : LichessRatingInfo.placeholder;
    bullet = json['bullet'] != null ? LichessRatingInfo.fromJson(json['bullet']) : LichessRatingInfo.placeholder;
    correspondence = json['correspondence'] != null ? LichessRatingInfo.fromJson(json['correspondence']) : LichessRatingInfo.placeholder;
    classical = json['classical'] != null ? LichessRatingInfo.fromJson(json['classical']) : LichessRatingInfo.placeholder;
    rapid = json['rapid'] != null ? LichessRatingInfo.fromJson(json['rapid']) : LichessRatingInfo.placeholder;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (blitz != LichessRatingInfo.placeholder) {
      data['blitz'] = blitz.toJson();
    }
    if (bullet != LichessRatingInfo.placeholder) {
      data['bullet'] = bullet.toJson();
    }
    if (correspondence != LichessRatingInfo.placeholder) {
      data['correspondence'] = correspondence.toJson();
    }
    if (classical != LichessRatingInfo.placeholder) {
      data['classical'] = classical.toJson();
    }
    if (rapid != LichessRatingInfo.placeholder) {
      data['rapid'] = rapid.toJson();
    }
    return data;
  }
}