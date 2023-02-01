library chess_cloud_provider;

class LichessRatingInfo {
  late int games;
  late int rating;
  late int rd;
  late int prog;
  late bool prov;

  static final placeholder =
      LichessRatingInfo(games: 0, rating: 1500, rd: 500, prog: 0, prov: true);

  LichessRatingInfo(
      {required this.games,
      required this.rating,
      required this.rd,
      required this.prog,
      required this.prov});

  LichessRatingInfo.fromJson(Map<String, dynamic> json) {
    games = json['games'];
    rating = json['rating'];
    rd = json['rd'];
    prog = json['prog'];
    prov = json['prov'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['games'] = games;
    data['rating'] = rating;
    data['rd'] = rd;
    data['prog'] = prog;
    data['prov'] = prov;
    return data;
  }
}
